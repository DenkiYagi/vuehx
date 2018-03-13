package vuehx;

import js.Promise;
import js.html.Element;
import haxe.Constraints.Function;
import haxe.extern.Rest;
import externtype.Mixed2;
import externtype.Mixed3;
import externtype.ValueOrArray;
import externtype.ValueOrFunction;
import vuehx.VueRouter;

@:native("Vue")
extern class Vue<TData> implements Dynamic {
    function new(options: VueOptions<TData>);
    
    // public properties
    /**
     * @see https://vuejs.org/v2/api/#vm-data
     */
    @:native("$data") var data(default, never): TData;

    /**
     * @see https://vuejs.org/v2/api/#vm-props
     */
    @:native("$props") var props(default, never): Null<Dynamic<Dynamic>>;

    /**
     * @see https://vuejs.org/v2/api/#vm-el
     */
    @:native("$el") var el(default, never): Element;

    /**
     * @see https://vuejs.org/v2/api/#vm-options
     */
    @:native("$options") var options(default, never): Null<ComponentOptions<TData>>;

    /**
     * @see https://vuejs.org/v2/api/#vm-parent
     */
    @:native("$parent") var parent(default, never): Null<Vue<Dynamic>>;

    /**
     * @see https://vuejs.org/v2/api/#vm-root
     */
    @:native("$root") var root(default, never): Vue<Dynamic>;

    /**
     * @see https://vuejs.org/v2/api/#vm-children
     */
    @:native("$children") var children(default, never): Array<Vue<Dynamic>>;

    /**
     * @see https://vuejs.org/v2/api/#vm-slots
     */
    @:native("$slots") var slots(default, never): Dynamic<Array<VNode>>;

    /**
     * @see https://vuejs.org/v2/api/#vm-scopedSlots
     */
    @:native("$scopedSlots") var scopedSlots(default, never): Dynamic<Dynamic -> Mixed2<VNode, Array<VNode>>>;

    /**
     * @see https://vuejs.org/v2/api/#vm-refs
     */
    @:native("$refs") var refs(default, never): Dynamic<Mixed3<Vue<Dynamic>, Element, Array<Mixed2<Vue<Dynamic>, Element>>>>;
    
    /**
     * @see https://vuejs.org/v2/api/#vm-isServer
     */
    @:native("$isServer") var isServer(default, never): Bool;

    /**
     * @see https://vuejs.org/v2/api/#vm-attrs
     */
    @:native("$attrs") var attrs(default, never): Dynamic<String>;

    /**
     * @see https://vuejs.org/v2/api/#vm-listeners
     */
    @:native("$listeners") var listeners(default, never): Dynamic<ValueOrArray<Function>>;
    
    // public methods
    //@:native("$createElement") function createElement(tag: Mixed2<String, ComponentOptions>, ?data: {}, ?children: Array<Mixed2<String, VNode>>): VNode;

    /**
     * @see https://vuejs.org/v2/api/#vm-watch
     */
    @:overload(function(fn: Void -> String, callback: WatchCallback, ?options: WatchOptions): Unwatch {})
    @:native("$watch") function watch(exp: String, callback: WatchCallback, ?options: WatchOptions): Unwatch; 
    
    /**
     * @see https://vuejs.org/v2/api/#vm-set
     */
    @:overload(function<T>(target: Array<T>, key: Int, value: T): T {})
    @:native("$set") function set<T>(target: {}, key: String, value: T): T; 

    /**
     * @see https://vuejs.org/v2/api/#vm-delete
     */
    @:overload(function<T>(target: Array<T>, key: Int): Void {})
    @:native("$delete") function delete<T>(target: {}, key: String): Void;

    /**
     * @see https://vuejs.org/v2/api/#vm-on
     */
    @:overload(function<T>(event: Array<String>, fn: Function): Vue<TData> {})
    @:native("$on") function on(event: String, fn: Function): Vue<TData>;

    /**
     * @see https://vuejs.org/v2/api/#vm-once
     */
    @:overload(function<T>(event: Array<String>, fn: Function): Vue<TData> {})
    @:native("$once") function once(event: String, fn: Function): Vue<TData>;

    /**
     * @see https://vuejs.org/v2/api/#vm-off
     */
    @:overload(function<T>(event: Array<String>, ?fn: Function): Vue<TData> {})
    @:native("$off") function off(event: String, ?fn: Function): Vue<TData>;

    /**
     * @see https://vuejs.org/v2/api/#vm-emit
     */
    @:native("$emit") function emit(event: String, args: Rest<Dynamic>): Vue<TData>;

    /**
     * @see https://vuejs.org/v2/api/#vm-mount
     */
    @:overload(function<T>(): Vue<TData> {})
    @:overload(function<T>(selector: String, ?hydrating: Bool): Vue<TData> {})
    @:native("$mount") function mount(element: Element, ?hydrating: Bool): Vue<TData>;

    /**
     * @see https://vuejs.org/v2/api/#vm-forceUpdate
     */
    @:native("$forceUpdate") function forceUpdate(): Void;

    /**
     * @see https://vuejs.org/v2/api/#vm-nextTick
     */
    @:native("$nextTick") function nextTick(fn: Void -> Void): Promise<Void>;
    
    /**
     * @see https://vuejs.org/v2/api/#vm-destroy
     */
    @:native("$destroy") function destroy(): Void; 

    // css modules
    /**
     * @see https://vue-loader.vuejs.org/en/features/css-modules.html
     */
    @:native("$style") var style(default, never): Dynamic<String>;

    // vue router
    /**
     * @see https://router.vuejs.org/en/essentials/getting-started.html
     */
    @:native("$router") var router(default, never): VueRouter;

    /**
     * @see https://router.vuejs.org/en/essentials/getting-started.html
     * @see https://router.vuejs.org/en/api/route-object.html
     */
    @:native("$route") var route(default, never): Route;

    // static
    /**
     * @see https://vuejs.org/v2/api/#Vue-extend
     */
    static function extend(options: Mixed2<Class<Vue<Dynamic>>, ComponentOptions<Dynamic>>): Class<Vue<Dynamic>>;

    /**
     * @see https://vuejs.org/v2/api/#Vue-nextTick
     */
    @:overload(function(callback: Void -> Void, ?context: {}): Void {})
    static function nextTick(): Promise<Void>;

    /**
     * @see https://vuejs.org/v2/api/#Vue-set
     */
    @:overload(function<T>(target: Array<T>, key: Int, value: T): Void {})
    static function set(target: {}, key: String, value: Dynamic): Void;

    /**
     * @see https://vuejs.org/v2/api/#Vue-delete
     */
    @:overload(function<T>(target: Array<T>, key: Int): Void {})
    static function delete(target: {}, key: String): Void;

    /**
     * @see https://vuejs.org/v2/api/#Vue-directive
     */
    @:overload(function(id: String, definition: ValueOrFunction<DirectiveOptions>): DirectiveOptions {})
    static function directive(id: String): DirectiveOptions;

    /**
     * @see https://vuejs.org/v2/api/#Vue-filter
     */
    @:overload(function(id: String, definition: Filter): Filter {})
    static function filter(id: String): Filter;

    /**
     * @see https://vuejs.org/v2/api/#Vue-component
     */
    @:overload(function(id: String, definition: Component): Class<Vue<Dynamic>> {})
    static function component(id: String): Class<Vue<Dynamic>>;

    /**
     * @see https://vuejs.org/v2/api/#Vue-use 
     **/
    static function use(plugin: Dynamic, ?options: Dynamic): Void;

    /**
     * @see https://vuejs.org/v2/api/#Vue-mixin
     */
    static function mixin(mixin: VueOptions<Dynamic>): Void;

    /**
     * @see https://vuejs.org/v2/api/#Vue-compile
     */
    static function compile(template: String): RenderFunctions;

    /**
     * @see https://vuejs.org/v2/api/#Vue-version
     */
    static var version(default, never): String;
}

typedef VueOptions<TData> = {
    > ComponentOptions<TData>, 
    @:optional var router: VueRouter;
}

typedef ComponentOptions<TData> = {
    // data
    /**
     * @see https://vuejs.org/v2/api/#data
     */
    @:optional var data: Void -> TData;

    /**
     * @see https://vuejs.org/v2/api/#props
     */
    @:optional var props: Mixed2<Array<String>, Dynamic<Mixed3<PropType, Array<PropType>, PropOptions>>>;

    /**
     * @see https://vuejs.org/v2/api/#propsData
     */
    @:optional var propsData: {};

    /**
     * @see https://vuejs.org/v2/api/#computed
     */
    @:optional var computed: Dynamic<Mixed2<Void -> Dynamic, ComputedOptions>>;

    /**
     * @see https://vuejs.org/v2/api/#methods
     */
    @:optional var methods: Dynamic<Function>;

    /**
     * @see https://vuejs.org/v2/api/#watch
     */
    @:optional var watch: Dynamic<Mixed2<String, Dynamic -> Dynamic -> Void>>;

    // DOM
    /**
     * @see https://vuejs.org/v2/api/#el
     */
    @:optional var el: Mixed2<String, js.html.Element>;

    /**
     * @see https://vuejs.org/v2/api/#template
     */
    @:optional var template: String;
    
    /**
     * @see https://vuejs.org/v2/api/#render
     */
    @:optional var render: CreateElement -> VNode;

    /**
     * @see https://vuejs.org/v2/api/#renderError
     */
    @:optional var renderError: CreateElement -> js.Error -> VNode;
    @:optional var staticRenderFns: Array<Void -> VNode>;

    // lifecycle
    /**
     * @see https://vuejs.org/v2/api/#beforeCreate
     */
    @:optional var beforeCreate: Void -> Void;

    /**
     * @see https://vuejs.org/v2/api/#created
     */
    @:optional var created: Void -> Void;

    /**
     * @see https://vuejs.org/v2/api/#beforeMount
     */
    @:optional var beforeMount: Void -> Void;

    /**
     * @see https://vuejs.org/v2/api/#mounted
     */
    @:optional var mounted: Void -> Void;

    /**
     * @see https://vuejs.org/v2/api/#beforeUpdate
     */
    @:optional var beforeUpdate: Void -> Void;

    /**
     * @see https://vuejs.org/v2/api/#updated
     */
    @:optional var updated: Void -> Void;

    /**
     * @see https://vuejs.org/v2/api/#activated
     */
    @:optional var activated: Void -> Void;

    /**
     * @see https://vuejs.org/v2/api/#deactivated
     */
    @:optional var deactivated: Void -> Void;

    /**
     * @see https://vuejs.org/v2/api/#beforeDestroy
     */
    @:optional var beforeDestroy: Void -> Void;

    /**
     * @see https://vuejs.org/v2/api/#destroyed
     */
    @:optional var destroyed: Void -> Void;

    // assets
    /**
     * @see https://vuejs.org/v2/api/#directives
     * @see https://vuejs.org/v2/guide/custom-directive.html
     */
    @:optional var directives: Dynamic<DirectiveOptions>;

    /**
     * @see https://vuejs.org/v2/api/#filters
     * @see https://vuejs.org/v2/guide/filters.html
     */
    @:optional var filters: Dynamic<Filter>;

    /**
     * @see https://vuejs.org/v2/api/#components
     * @see https://vuejs.org/v2/guide/components.html
     */
    @:optional var components: Dynamic<Component>;
    
    // transitions?: { [key: string]: Object };

    // composition
    /**
     * @see https://vuejs.org/v2/api/#parent
     */
    @:optional var parent: Vue<Dynamic>;
    
    /**
     * @see https://vuejs.org/v2/api/#mixins
     * @see https://vuejs.org/v2/guide/mixins.html
     */
    @:optional var mixins: Array<ComponentOptions<Dynamic>>;

    // TODO マクロでextendをextendsに変換
    /**
     * @see https://vuejs.org/v2/api/#extends
     */
    #if (haxe_ver >= 4.0)
    // Maybe it works on Haxe 4. https://github.com/HaxeFoundation/haxe/issues/5105
    @:native("extends") @:optional var extend: Mixed2<ComponentOptions<Dynamic>, Class<Vue>>;
    #end
    
    /**
     * @see https://vuejs.org/v2/api/#provide-inject
     */
    @:optional var provide: ValueOrFunction<{}>;

    /**
     * @see https://vuejs.org/v2/api/#provide-inject
     */
    @:optional var inject: Mixed2<Array<String>, Dynamic<{}>>;

    // misc
    /**
     * @see https://vuejs.org/v2/api/#name
     */
    @:optional var name: String;

    /**
     * @see https://vuejs.org/v2/api/#delimiters
     */
    @:optional var delimiters: Array<String>;

    /**
     * @see https://vuejs.org/v2/api/#functional
     */
    @:optional var functional: Bool;

    /**
     * @see https://vuejs.org/v2/api/#model
     */
    @:optional var model: { 
        @:optional var prop: String;
        @:optional var event: String;
    }

    /**
     * @see https://vuejs.org/v2/api/#inheritAttrs
     */
    @:optional var inheritAttrs: Bool;

    /**
     * @see https://vuejs.org/v2/api/#comments
     */
    @:optional var comments: Bool;
}

typedef AsyncComponentOptions = {
    var component: Mixed2<Promise<ComponentOptions<Dynamic>>, Promise<Class<Vue<Dynamic>>>>;
    var loading: Mixed2<ComponentOptions<Dynamic>, Class<Vue<Dynamic>>>;
    var error: Mixed2<ComponentOptions<Dynamic>, Class<Vue<Dynamic>>>;
    @:optional var delay: Int;
    @:optional var timeout: Int;
}

// NOTE Haxe3.4.4: typeをValueOrArray<T>で記述するとコンパイルが通らないので、仕方なくこの定義方法にしている
typedef PropOptions = Mixed2<
    {
        @:optional var type: PropType;
        //TODO マクロでextendをextendsに変換
        #if (haxe_ver >= 4.0)
        // Maybe it works on Haxe 4. https://github.com/HaxeFoundation/haxe/issues/5105
        @:native("default") @:optional var defaultValue: Dynamic;
        #end
        @:optional var required: Bool;
        @:optional var validator: Dynamic -> Bool;
    },
    {
        @:optional var type: Array<PropType>;
        // TODO マクロでextendをextendsに変換
        #if (haxe_ver >= 4.0)
        // Maybe it works on Haxe 4. https://github.com/HaxeFoundation/haxe/issues/5105
        @:native("default") @:optional var defaultValue: Dynamic;
        #end
        @:optional var required: Bool;
        @:optional var validator: Dynamic -> Bool;
    }
>

typedef ComputedOptions = {
    @:optional var get: Void -> Dynamic;
    @:optional var set: Dynamic -> Void;
    @:optional var cache: Bool;
}

typedef Filter = Dynamic -> Dynamic;

/**
 * @see https://vuejs.org/v2/guide/custom-directive.html
 */
typedef DirectiveOptions = {
    @:optional function bind(el: Element, binding: DirectiveBinding, vnode: VNode, oldVnode: VNode): Void;
    @:optional function inserted(el: Element, binding: DirectiveBinding, vnode: VNode, oldVnode: VNode): Void;
    @:optional function update(el: Element, binding: DirectiveBinding, vnode: VNode, oldVnode: VNode): Void;
    @:optional function componentUpdated(el: Element, binding: DirectiveBinding, vnode: VNode, oldVnode: VNode): Void;
    @:optional function unbind(el: Element, binding: DirectiveBinding, vnode: VNode, oldVnode: VNode): Void;    
}

typedef DirectiveBinding = {
    var name(default, never): String;
    var value(default, never): Dynamic;
    var oldValue(default, never): Dynamic;
    var expression(default, never): String;
    var arg(default, never): String;
    var modifiers(default, never): Dynamic<Bool>;
}

/**
 * @see https://vuejs.org/v2/guide/render-function.html#createElement-Arguments
 */
typedef CreateElement = Mixed2<String, Component> -> ?{} -> ?Array<Mixed2<String, VNode>> -> VNode;

extern class VNode {}

typedef RenderFunctions = {
    function render(fn: CreateElement): VNode;
    function staticRenderFns(): Array<Void -> VNode>;
}

typedef WatchCallback = Any -> Any -> Void;

typedef WatchOptions = {
    @:optional var deep: Bool;
    @:optional var immediate: Bool;    
}

typedef Unwatch = Void -> Void;
