package;

class Run {
    public static function main() {
        switch (readCommand()) {
            case "setup":
                setupWithNpm();
            case "setup-yarn":
                setupWithYarn();
            case _:
                printUsage();
        }
    }

    static function readCommand(): Null<String> {
        var args = Sys.args();
        if (args.length <= 0) return null;
        if (args.length == 1) return args[0];
        if (args.length == 4 && args[0] == "haxelib") return args[3];
        return null;
    }

    static function printUsage() {
        Sys.println("usage: haxelib run hxgnd <command>");
        Sys.println("  setup        setup with npm");
        Sys.println("  setup-yarn   setup with yarn");
        Sys.exit(0);
    }

    static function setupWithNpm() {
        Sys.command('npm i -D ${getDependencies().join(" ")}');
        Sys.exit(0);
    }

    static function setupWithYarn() {
        Sys.command('yarn add -D ${getDependencies().join(" ")}');
        Sys.exit(0);
    }

    static function getDependencies() {
        var jsonPath = ~/run.n$/.replace(Sys.programPath(), "package.json");
        var content = sys.io.File.getContent(jsonPath);
        var dependencies: Dynamic<String> = haxe.Json.parse(content).devDependencies;

        var result = [];
        for (name in Reflect.fields(dependencies)) {
            result.push('$name@"${Reflect.field(dependencies, name)}"');
        }
        return result;
    }
}