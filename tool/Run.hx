package;

import sys.FileSystem;
import sys.io.File;

/**
 * haxelib run command
 */
class Run {
    static var PATH_SEPARATOR = if (Sys.systemName() == "Windows") "\\" else "/";

    public static function main() {
        var arg = readArgs();
        switch (arg.command) {
            case "setup":
                setup(arg.dir, false);
            case "setup-yarn":
                setup(arg.dir, true);
            case _:
                printUsage();
        }
        Sys.exit(0);
    }

    static function readArgs(): { command: Null<String>, dir: Null<String> } {
        // When called by haxelib, args is [<command>, <dir>]
        var args = Sys.args();
        if (args.length == 2) {
            if (FileSystem.isDirectory(args[1])) {
                return { command: args[0], dir: args[1] };
            }
        }
        return { command: null, dir: null };
    }

    static function printUsage() {
        Sys.println("usage: haxelib run hxgnd <command>");
        Sys.println("  setup        setup with npm");
        Sys.println("  setup-yarn   setup with yarn");
    }

    static function setup(projectDir: String, yarnEnabled: Bool) {
        var libDir = getDirectory(Sys.programPath());
        var templateDir = joinPath([libDir, "tool", "template"]);
        copy(templateDir, projectDir);

        Sys.setCwd(projectDir);
        if (yarnEnabled) {
            Sys.command('npm i -D ${getDependencies()}');
        } else {
            Sys.command('yarn add -D ${getDependencies()}');
        }
    }

    static inline function getDirectory(path: String): String {
        return new EReg('\\${PATH_SEPARATOR}[^\\${PATH_SEPARATOR}]+$', "").replace(path, "");
    }

    static inline function joinPath(route: Array<String>): String {
        return route.join(PATH_SEPARATOR);
    }

    static function copy(srcDir: String, distDir: String): Void {
        if (!FileSystem.isDirectory(srcDir)) throw '${srcDir} is not directory';
        if (!FileSystem.isDirectory(distDir)) throw '${distDir} is not directory';
        if (FileSystem.readDirectory(distDir).length > 0) throw '${distDir} is not empty directory';

        var stack = [];
        stack.push("");
        while (stack.length > 0) {
            var node = stack.pop();
            var srcPath = joinPath([srcDir, node]);
            var distPath = joinPath([distDir, node]);
            if (FileSystem.isDirectory(srcPath)) {
                for (child in FileSystem.readDirectory(srcPath)) {
                    stack.push(joinPath([node, child]));
                }
                FileSystem.createDirectory(distPath);
            } else {
                File.copy(srcPath, distPath);
            }
        }
    }

    static function getDependencies(): String {
        var jsonPath = ~/run.n$/.replace(Sys.programPath(), "package.json");
        var content = File.getContent(jsonPath);
        var dependencies: Dynamic<String> = haxe.Json.parse(content).devDependencies;

        var result = [];
        for (name in Reflect.fields(dependencies)) {
            result.push('$name@"${Reflect.field(dependencies, name)}"');
        }
        return result.join(" ");
    }
}