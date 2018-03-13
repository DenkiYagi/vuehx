package;

import sys.FileSystem;
import sys.io.File;

class Run {
    public static function main() {
        var arg = readArgs();
        switch (arg.command) {
            case "setup":
                setupWithNpm(arg.dir);
            case "setup-yarn":
                setupWithYarn(arg.dir);
            case _:
                printUsage();
        }
    }

    static function readArgs(): { command: Null<String>, dir: Null<String> } {
        // When called by haxelib, args is [<command>, <dir>]
        var args = Sys.args();
        if (args.length == 2) {
            if (FileSystem.isDirectory(args[1])) {
                return { command: args[0], dir: args[1] }
            }
        }
        return { command: null, dir: null };
    }

    static function printUsage() {
        Sys.println("usage: haxelib run hxgnd <command>");
        Sys.println("  setup        setup with npm");
        Sys.println("  setup-yarn   setup with yarn");
        Sys.exit(0);
    }

    static function setupWithNpm(dir: String) {
        Sys.setCwd(dir);
        Sys.command('npm i -D ${getDependencies().join(" ")}');
        Sys.exit(0);
    }

    static function setupWithYarn(dir: String) {
        Sys.setCwd(dir);
        Sys.command('yarn add -D ${getDependencies().join(" ")}');
        Sys.exit(0);
    }

    static function getDependencies() {
        var jsonPath = ~/run.n$/.replace(Sys.programPath(), "package.json");
        var content = File.getContent(jsonPath);
        var dependencies: Dynamic<String> = haxe.Json.parse(content).devDependencies;

        var result = [];
        for (name in Reflect.fields(dependencies)) {
            result.push('$name@"${Reflect.field(dependencies, name)}"');
        }
        return result;
    }
}