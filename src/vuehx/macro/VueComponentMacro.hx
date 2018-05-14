package vuehx.macro;

#if macro
import sys.FileSystem;
import sys.io.Process;
import sys.io.File;
import sys.io.FileOutput;
import haxe.Json;
import haxe.macro.Context;
import haxe.macro.Compiler;
import haxe.macro.Type;
import haxe.macro.Expr;
import hxgnd.Maybe;
import haxe.Http;

using hxgnd.ArrayTools;
#end

class VueComponentMacro {
    #if macro
    static var cssPath: Maybe<String>;
    static var process: Process;

    public static macro function build(): Array<Field> {
        var orignalFields = Context.getBuildFields();
        var cls = Context.getLocalClass().get();

        // compile .vue file
        var compileResult = getVueFilePath(cls).map(compile);

        // generate fields
        var options = orignalFields.head(function (f) return f.name == "_");
        var datatype = options.flatMap(
            function (f) {
                return switch (f.kind) {
                    case FVar(_, {expr: EObjectDecl(optFlds), pos: p}):
                        optFlds.head(function(o) return o.field == "data").flatMap(function (df) {
                            return switch (Context.toComplexType(Context.typeof(df.expr))) {
                                case TFunction(_, ret): Maybe.of(ret);
                                default: Maybe.empty();
                            }
                        });
                    default:
                        Maybe.empty();
                };
            }
        ).getOrElse(macro :Dynamic);

        var fields = [];
        fields = fields.concat(options.match(
            function (f) {
                // オリジナルの _ は残す。残さないと入力補完が利かなくなる。
                // _ を残してもコンパイルオプションで -dce full を指定している場合は、jsには残らない。
                return [f, switch (f.kind) {
                    case FVar(_, {expr: EObjectDecl(optFlds), pos: p}):
                        makeOptionsField(datatype, optFlds, compileResult, p);
                    case FVar(_, {expr: EBlock(_), pos: p}):
                        makeOptionsField(datatype, [], compileResult, p);
                    default:
                        Context.warning("'_' is not vuehx.VueCompoentOptions, so orignal definition is ignored.", f.pos);
                        makeOptionsField(datatype, [], compileResult, f.pos);
                }];
            },
            function () {
                return [makeOptionsField(datatype, [], compileResult, cls.pos)];
            }
        ));

        // var methods = options.flatMap(function (f) {
        //     return switch (f.kind) {
        //         case FVar(_, {expr: EObjectDecl(optFlds), pos: p}):
        //             var methods = ArrayTools.first(optFlds, function(o) return o.field == "methods");
        //             methods.foreach(function (m) {
        //                 switch (m.expr.expr) {
        //                     case EObjectDecl(fields):
        //                         for (method in fields) {
        //                             method.field
        //                         }
        //                     case _:
        //                 }
        //             });

        //             //methods.map(function (m) return Context.typeof(m.expr));
        //             // ArrayTools.first(optFlds, function(o) return o.field == "methods").flatMap(function (df) {
        //             //     return Optional.of(Context.toComplexType(Context.typeof(df.expr)));
        //             // });
        //             Optional.empty();
        //         default:
        //             Optional.empty();
        //     };
        // });

        // fields.push({
        //     name: "vue",
        //     access: [Access.APrivate, Access.AStatic, Access.AInline],
        //     pos: cls.pos,
        //     kind: FieldType.FFun({
        //         args: [],
        //         ret: ComplexType.TPath({
        //             pack: ["vuehx"],
        //             name: "Vue",
        //             params: [ TypeParam.TPType(datatype) ]
        //         }),
        //         params: null,
        //         expr: macro return js.Lib.nativeThis
        //     })
        // });

        for (f in orignalFields.filter(function (f) return f.name != "_")) {
            switch (f.kind) {
                case FVar(t, _):
                    var name = f.name.substr(0, 1).toUpperCase() + f.name.substr(1);
                    fields.push({
                        name: "get" + name,
                        access: [Access.APrivate, Access.AStatic, Access.AInline],
                        pos: cls.pos,
                        kind: FieldType.FFun({
                            args: [],
                            ret: t,
                            params: null,
                            expr: macro return untyped __js__($v{"this['$" + f.name + "']"})
                        })
                    });
                    fields.push({
                        name: "set" + name,
                        access: [Access.APrivate, Access.AStatic, Access.AInline],
                        pos: cls.pos,
                        kind: FieldType.FFun({
                            args: [{name: "value", type: t}],
                            ret: macro :Void,
                            params: null,
                            expr: macro Reflect.setField(js.Lib.nativeThis, $v{"$" + f.name}, value)
                        })
                    });
                case FFun(_):
                    fields.push(f);
                default:
            }
        }

        // export css file
        // TODO .css出力先は、vuehx外部ライブラリ化した際、extraParams.hxml によって起動時に算出するように変更する
        Context.onAfterGenerate(function () {
            compileResult.forEach(function (x) {
                var file: FileOutput;
                try {
                    if (cssPath.isEmpty()) {
                        var path = ~/\.js$/.replace(Compiler.getOutput(), "") + ".css";
                        cssPath = path;
                        file = File.write(cssPath.get());
                    } else {
                        file = File.append(cssPath.get());
                    }
                    file.writeString(x.style.content);
                    file.close();
                } catch (_: Dynamic) {
                    if (file != null) file.close();
                }
            });
        });

        return fields;
    }

    static function makeJsExpr(js: String): Expr {
        return macro untyped __js__($v{js});
    }

    static function getVueFilePath(cls: ClassType): Maybe<String> {
        var path = ~/.hx$/u.replace(Context.getPosInfos(cls.pos).file, ".vue");
        return if (FileSystem.exists(path)) {
            FileSystem.absolutePath(path);
        } else {
            Maybe.empty();
        }
    }

    static function makeOptionsField(datatype: ComplexType, origFields: Array<{field: String, expr: Expr}>,
            compileResult: Maybe<CompiledResult>, pos: Position): Field {
        var fields = compileResult.match(function (cr) {
            var newFields = origFields.filter(function (f) {
                return f.field != "beforeCreate"
                    && f.field != "render"
                    && f.field != "staticRenderFns";
            });

            var beforeCreate = macro function () {
                $a{Reflect.fields(cr.style.classNames).map(function (name) {
                    var mapping = Json.stringify(Reflect.field(cr.style.classNames, name));
                    return makeJsExpr('this.${"$"+name} = $mapping');
                })}
            };

            newFields.push({
                field: "beforeCreate",
                expr: origFields.head(function(o) return o.field == "beforeCreate").match(
                    function (x) {
                        return macro [ ${x.expr}, ${beforeCreate} ];
                    },
                    function () {
                        return beforeCreate;
                    }
                )
            });

            newFields.push({
                field: "render",
                expr: ${makeJsExpr(cr.template.render)}
            });
            newFields.push({
                field: "staticRenderFns",
                expr: macro [$a{cr.template.staticRenderFns.map(makeJsExpr)}]
            });

            return newFields;
        }, function () {
            return origFields;
        });

        return {
            name: "options",
            access: [Access.APublic, Access.AStatic],
            pos: pos,
            kind: FieldType.FVar(
                ComplexType.TPath({
                    pack: ["vuehx"],
                    name: "Vue",
                    sub: "ComponentOptions",
                    params: [ TypeParam.TPType(datatype) ]
                }),
                {expr: EObjectDecl(fields), pos: pos})
        };
    }

    // TODO optimizeSSR https://github.com/vuejs/vue-loader/blob/master/lib/template-compiler/index.js#L31

    // TODO node.exe起動タイミングをマクロ起動時に変更する = server側のexpire不要
    static function compile(path: String): CompiledResult {
        startCompilerServer();

        var http = new Http("http://localhost:54301/compile?file=" + path);
        http.onError = function (err) {
            Context.fatalError(err, Context.currentPos());
        }
        http.request();

        var response = Json.parse(http.responseData);
        if (response.status == "success") {
            return response.message;
        } else {
            throw response.message;
        }
    }

    static function startCompilerServer() {
        if (process != null) return;

        // NOTE 通常ビルド時はビルド完了とともにプロセスがクローズされる。入力補完の場合は、起動しっぱなしになる。
        var serverPath = findCompilerServerPath();
        process = new Process('node ${serverPath} --css-camelcase');
        try {
            process.stdout.readLine();
        } catch (e: haxe.io.Eof) {
            process.close();

            var detail = [];
            try {
                while (true) detail.push(process.stderr.readLine());
            } catch (_: haxe.io.Eof) {
            }
            process = null;

            Context.fatalError("can not start compiler-service:\n" + detail.join("\n"), Context.currentPos());
        }
    }

    static function findCompilerServerPath(): String {
        var path = "script/server.js";
        if (FileSystem.exists(path)) return path;

        var process = new Process("haxelib path vuehx");
        try {
            while (true) {
                var line = process.stdout.readLine();
                var path = line + "../script/server.js";
                if (FileSystem.exists(path)) {
                    process.close();
                    return path;
                }
            }
        } catch (e: haxe.io.Eof) {
            process.close();
        }

        return Context.fatalError("can not find compiler-service", Context.currentPos());
    }
    #end
}

#if macro
@:noPackageRestrict
typedef CompiledResult = {
    template: {
        render: String,
        staticRenderFns: Array<String>,
    },
    style: {
        content: String,
        classNames: Dynamic<Dynamic<String>>
    }
};
#end