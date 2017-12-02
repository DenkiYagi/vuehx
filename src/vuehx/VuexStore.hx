package vuehx;

import hxgnd.extern.Mixed2;

@:native("Vuex.Store")
extern class VuexStore<TState> {
    function new(options: VuexStoreOptions<TState>);

    var state(default, never): Dynamic;
    var getters(default, never): Dynamic;

}

typedef VuexStoreOptions<TState> = {
    @:optional var state: Mixed2<TState, Void -> TState>;
    @:optional var mutations: Dynamic<Mutation<TState>>;
    @:optional var actions: Dynamic;
    @:optional var getters: Dynamic;
    @:optional var modules: Dynamic;

    /**
     * @see https://vuex.vuejs.org/en/plugins.html
     */
    @:optional var plugins: Array<Plugin<TState>>;

    /**
     * @see https://vuex.vuejs.org/en/strict.html
     */
    @:optional var strict: Bool;
}

typedef Mutation<TState> = Mixed2<TState -> Void, TState -> Dynamic -> Void>;
typedef Plugin<TState> = VuexStore<TState> -> Void;

class Store {

}

class MutationContext {
    function commitIncrement() {

    }
}