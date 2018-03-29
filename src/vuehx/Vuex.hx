package vuehx;

import externtype.Mixed2;
import js.Promise;

@:native("Vuex")
extern class Vuex {
    // mapState(namespace?: string, map: Array<string> | Object): Object
    // mapGetters(namespace?: string, map: Array<string> | Object): Object
    // mapActions(namespace?: string, map: Array<string> | Object): Object
    // mapMutations(namespace?: string, map: Array<string> | Object): Object
    // createNamespacedHelpers(namespace: string): Object
}

@:native("Vuex.Store")
extern class Store {
    function new(options: StoreOptions);

    var state(default, never): Dynamic;
    var getters(default, never): Dynamic;

    @:overload(function <T: Payload>(payload: T, ?options: CommitOptions): Void {})
    function commit(type: String, ?payload: Dynamic, ?options: CommitOptions): Void;

    @:overload(function <T: Payload>(payload: T, ?options: DispatchOptions): Promise<Void> {})
    function dispatch(type: String, ?payload: Dynamic, ?options: DispatchOptions): Promise<Void>;

    function replaceState(state: Dynamic): Void;
}

typedef StoreOptions = {
    //@:optional var state: Mixed2<TState, Void -> TState>;
    @:optional var mutations: Dynamic<Mutation>;
    @:optional var actions: Dynamic;
    @:optional var getters: Dynamic;
    @:optional var modules: Dynamic;

    /**
     * @see https://vuex.vuejs.org/en/plugins.html
     */
    @:optional var plugins: Array<Plugin>;

    /**
     * @see https://vuex.vuejs.org/en/strict.html
     */
    @:optional var strict: Bool;
}


typedef Mutation = Mixed2<Dynamic -> Void, Dynamic -> Dynamic -> Void>;
typedef Plugin = Store -> Void;

class MutationContext {
    function commitIncrement() {

    }
}

typedef Payload = {
    var type: String;
}

typedef CommitOptions = {
    @:optional var silent: Bool;
    @:optional var root: Bool;
}

typedef DispatchOptions = {
    @:optional var root: Bool;
}





@:autoBuild(vuehx.macro.VuexStoreMacro.build())
interface IVuexStore {
}