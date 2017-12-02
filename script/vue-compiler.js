#!/usr/bin/env node
'use strict';

// vuehx-sfc-compiler
//
// [制限事項]
// 未実装：optimizeSSR https://vue-loader.vuejs.org/ja/options.html#optimizessr
//   - vue-loaderのソース解析が必要だが、単にCompilerのメソッドをSSR用に切り替えてるだけっぽい
//   - https://github.com/vuejs/vue-loader/blob/407ddbd9e442fc8551d662d1709fcffd35419f21/lib/template-compiler/index.js#L31-L33
// 未検討： https://vue-loader.vuejs.org/ja/features/postcss.html
//   - postcss.plugin.js を読み込む形で対応予定 / processStyle()を参照
//   - プリプロセッサ（sassなど） postcssの設定を直接設定して対応 https://vue-loader.vuejs.org/ja/configurations/pre-processors.html
//   - アセット URL ハンドリング postcssの設定を直接設定して対応 https://vue-loader.vuejs.org/ja/configurations/asset-url.html
//   - CSS Lint これもpostcssで
// 未検討：カスタムブロック https://vue-loader.vuejs.org/ja/configurations/custom-blocks.html
//   - 用途が思いつかないため
// 未検討：単体テスト https://vue-loader.vuejs.org/ja/workflow/testing.html
//   - Karmaを使う想定。Haxe外から制御した方が良いと思われる
// 未検討：E2Eテスト https://github.com/vuejs-templates/webpack
//   - Nightwatch.jsを使う想定になっているが…。これもHaxe側から別途制御した方が良いと思われる
// 未検討：プロダクションビルド https://vue-loader.vuejs.org/ja/workflow/production.html
//     sourcemapの生成抑制, minifyのみ対応予定
// 非対応：<script>：マクロを使う（クラスから.vueファイルを参照する）構造上、不可能
// 非対応：scoped css <style scoped> ：css modules <style module> と機能がかぶり、コンパイラの実装も複雑化する
// 非対応：CSS を単一のファイルに抽出する https://vue-loader.vuejs.org/ja/configurations/extract-css.html
//     webpack依存による問題（JSファイル内にcss文字列が組み込まれ、実行時styleタグが生成される）なので対応不要 https://blog.unsweets.net/2016/03/webpack2.html
// 非対応：eslint https://vue-loader.vuejs.org/ja/workflow/linting.html
//     そもそもHaxeなのでeslintは意味がない…
// 非対応：モックテスト https://vue-loader.vuejs.org/ja/workflow/testing-with-mocks.html
//     webpack依存、Haxe側でやった方が楽だと思われる

const os = require('os');
const fs = require('fs');
const path = require('path');
const compiler = require('vue-template-compiler');
const postcss = require('postcss');
const sourcemap = require('source-map');

function compile(src, options = {}) {
    const parts = compiler.parseComponent(fs.readFileSync(src, 'utf-8'), { pad: 'line' });

    if (parts.styles.some(function (x) { return x.scoped; })) {
        // TODO WARN: scoped css <style scoped> はサポートしない
    }

    return Promise.all([processTemplate(parts.template)]
            .concat(parts.styles.map(function (x, i) { return  processStyle(x, i, src, options)})))
        .then(function (results) {
            var template = results[0];
            var styles = results.slice(1);

            return {
                template: template,
                style: {
                    content: styles.map(x => x.css).join('\n'),
                    classNames: Object.assign({}, ...styles.map(x => x.classNames))
                }
            };
        })
        .catch(function (err) {
            console.log(err);
        })
}

function processTemplate(part) {
    function toFunction(code) {
        return "Function('" + code.replace(/['"\\]/g, "\\$&") + "')";
    }
    
    // TODO part.lang=pug をプリコンパイルする

    return getContent(part).then(function (content) {
        var compiled = compiler.compile(content);
        // console.log(compiled);
        
        // TODO エラーハンドリング
        return {
            render: toFunction(compiled.render),
            staticRenderFns: compiled.staticRenderFns.map(toFunction)
        };
    });
}

function processStyle(part, index, src, options) {
    let plugins = [];
    let classNames = {};
    
    let moduleName = (part.module === true) ? 'style' : part.module;
    if (moduleName) {
        plugins.push(require('postcss-modules')({
            scopeBehaviour: 'local',
            //generateScopedName: '[name]__[local]___[hash:base64:5]',
            generateScopedName: '[hash:base64]__' + index,
            getJSON: function(cssFileName, json) {
                if (options && options.cssModules && options.cssModules.camelCase) {
                    var mapping = {};
                    for (let key of Object.keys(json)) {
                        mapping[toCamelCase(key)] = json[key];
                    }
                    classNames[moduleName] = mapping;
                } else {
                    classNames[moduleName] = json;
                }
            }
        }));
    }
    
    // TODO postcss.plugins.js をロードできるようにする
    // module.exports = () => [
    //     { 'postcss-plugin': { opt: true } }
    // ]

    return getContent(part).then(function (content) {
        return postcss(plugins).process(content, {map: {inline: false}})
            .then(function (result) {
                var generator = new sourcemap.SourceMapGenerator({
                    file: src.replace(/\\/g, '/'),
                    sourceRoot: "file:///"
                });

                var consumer = new sourcemap.SourceMapConsumer(result.map.toString());
                consumer.eachMapping(function (m) { 
                    generator.addMapping({
                        source: resolvePath(src),
                        name: m.name,
                        original: { line: m.originalLine + part.start - 1, column: m.originalColumn },
                        generated: { line: m.generatedLine, column: m.generatedColumn }
                    });
                });

                return { css: result.css, map: generator.toString(), classNames: classNames };
            });
    });
}

function getContent(part) {
    if (part.src) {
        return fs.readFile(part.src, 'utf-8');
    } else {
        return Promise.resolve(part.content);
    }
}

function resolvePath(x) {
    if (process.platform === 'win32') {
        return path.resolve(x)
            .replace(/\\/g, '/')
            .replace(/^[A-Z]:\//, function (x) { return x.toLowerCase() });
    } else {
        return path.resolve(x);
    }
}

function toCamelCase(x) {
    return x.replace(/[_-]./g, s => s.charAt(1).toUpperCase());
}

module.exports = {
    compile: compile
}