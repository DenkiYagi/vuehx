package;

class Run {
    public static function main() {
        var args = Sys.args();
var dependencies = getDependencies();
trace(dependencies);
        if (args.length == 1) {
            switch (args[0]) {
                case "setup":
                    setupWithNpm();
                case "setup-yarn":
                    setupWithYarn();
                case _:
            }
        }
        printUsage();
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
        trace(jsonPath);
        var content = sys.io.File.getContent(jsonPath);
        trace(content);

        var dependencies: Dynamic<String> = haxe.Json.parse(content).devDependencies;

        var result = [];
        for (name in Reflect.fields(dependencies)) {
            result.push('$name@"${Reflect.field(dependencies, name)}"');
        }
        return result;
    }
}