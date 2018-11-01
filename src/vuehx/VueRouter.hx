package vuehx;

import vuehx.Vue;
import haxe.Constraints.Function;
import extype.extern.Mixed;
import extype.extern.ValueOrArray;

/**
 * @see https://router.vuejs.org/en/api/router-instance.html
 */
@:native("VueRouter")
extern class VueRouter {
    function new(options: VueRouterOptions);

    var app(default, never): Vue<Dynamic>;

    var mode(default, never): String;

    var currentRoute(default, never): Route;

    function beforeEach(guard: NavigationGuard): Function;

    function beforeResolve(guard: NavigationGuard): Function;

    function afterEach(guard: NavigationGuard): Function;

    function push(location: RawLocation, ?onComplete: Void -> Void, ?onAbort: Void -> Void): Void;

    function replace(location: RawLocation, ?onComplete: Void -> Void, ?onAbort: Void -> Void): Void;

    function go(n: Int): Void;

    function back(): Void;

    function forward(): Void;

    @:overload(function(to: RawLocation): Array<Vue<Dynamic>> {})
    @:overload(function(to: Route): Array<Vue<Dynamic>> {})
    function getMatchedComponents(): Array<Vue<Dynamic>>;

    function resolve(to: RawLocation, ?current: Route, ?append: Bool): { location: Location, route: Route, href: String };

    function addRoutes(routes: Array<RouteConfig>): Void;

    function onReady(callback: Void -> Void, ?errorCallback: Dynamic -> Void): Void;

    function onError(callback: Dynamic -> Void): Void;
}

typedef VueRouterOptions = {
    /**
     * @see https://router.vuejs.org/en/api/options.html#routes
     */
    @:optional var routes: Array<RouteConfig>;

    /**
     * @see https://router.vuejs.org/en/api/options.html#mode
     */
    @:optional var mode: RouterMode;

    /**
     * @see https://router.vuejs.org/en/api/options.html#base
     */
    @:optional var base: String;

    /**
     * @see https://router.vuejs.org/en/api/options.html#linkactiveclass
     */
    @:optional var linkactiveclass: String;

    /**
     * @see https://router.vuejs.org/en/api/options.html#scrollbehavior
     */
    @:optional var scrollBehavior: String;

    /**
     * @see https://router.vuejs.org/en/api/options.html#parsequery--stringifyquery
     */
    @:optional var parseQuery: Dynamic;

    /**
     * @see https://router.vuejs.org/en/api/options.html#parsequery--stringifyquery
     */
    @:optional var stringifyQuery: Dynamic;

    /**
     * @see https://router.vuejs.org/en/api/options.html#parsequery--stringifyquery
     */
    @:optional var fallback: Bool;
}

/**
 * @see https://router.vuejs.org/en/api/options.html#routes
 */
typedef RouteConfig = {
    var path: String;

    @:optional var component: Component;
    @:optional var name: String;
    @:optional var components: Dynamic<Component>;
    @:optional var redirect: RedirectOption;
    @:optional var props: Mixed3<Bool, {}, Route -> {}>;
    @:optional var alias: ValueOrArray<String>;
    @:optional var children: Array<RouteConfig>;
    @:optional var beforeEnter: NavigationGuard;
    @:optional var meta: Dynamic;
    @:optional var caseSensitive: Bool;
    @:optional var pathToRegexpOptions: PathToRegexpOptions; // 正規表現のコンパイルとして path-to-regexp オプション
}

@:enum abstract RouterMode(String) {
    var Hash = "hash";
    var History = "history";
    var Abstract = "abstract";
}

typedef Location = {
    @:optional var name: String;
    @:optional var path: String;
    @:optional var hash: String;
    @:optional var query: Dynamic<String>;
    @:optional var params: Dynamic<String>;
    @:optional var append: Bool;
    @:optional var replace: Bool;
}
typedef RawLocation = Mixed2<String, Location>;

typedef NavigationGuard = Route -> Route -> (?Mixed4<Bool, RawLocation, Vue<Dynamic> -> Void, js.Error> -> Void) -> Void;

typedef RedirectOption = Mixed2<RawLocation, Location -> RawLocation>;

/**
 * @see https://router.vuejs.org/en/essentials/dynamic-matching.html#advanced-matching-patterns
 */
typedef PathToRegexpOptions = {
    @:optional var sensitive: Bool;
    @:optional var strict: Bool;
    @:optional var end: Bool;
    @:optional var delimiter: String;
    @:optional var endsWith: ValueOrArray<String>;
}

/**
 * @see https://router.vuejs.org/en/api/route-object.html
 */
typedef Route = {
    var path(default, never): String;
    var params(default, never): Dynamic<String>;
    var query(default, never): Dynamic<String>;
    var hash(default, never): String;
    var fullPath(default, never): String;
    var matched(default, never): Array<RouteRecord>;
    @:optional var name(default, never): String;
    var meta(default, never): Dynamic;
    @:optional var redirectedFrom(default, never): String;
}

typedef RouteRecord = {
    var path(default, never): String;
    var regex: js.RegExp;
    var components: Dynamic<Component>;
    var instances: Dynamic<Vue<Dynamic>>;
    @:optional var name: String;
    @:optional var parent: RouteRecord;
    @:optional var redirect: RedirectOption;
    @:optional var matchAs: String;
    var meta: Dynamic;
    @:optional var beforeEnter: NavigationGuard;
    var props: Mixed3<Bool, {}, Route -> {}>;
}