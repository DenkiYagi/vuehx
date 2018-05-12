package vuehx.extra;

import hxgnd.Unit;
import hxgnd.Future;
import hxgnd.LangTools;

class VuehxStore<TState, TAction> {
    public var state(default, null): TState;
    var subscribers: Array<Subscriber<TState>>;
    var middleware: Middleware<TState, TAction>;

    public function new(initState: TState, middleware: Middleware<TState, TAction>) {
        this.state = #if debug LangTools.freeze(initState) #else initState #end;
        this.subscribers = [];
        this.middleware = middleware;
    }

    public function dispatch(action: TAction): Future<Unit> {
        return middleware({
            state: state,
            action: action,
            commit: commit,
        });
    }

    function commit(reducer: TState -> TState): Void {
        var newState = reducer(state);
        if (LangTools.notSame(state, newState)) {
            state = #if debug LangTools.freeze(newState) #else state #end;
            for (f in subscribers) f(state);
        }
    }

    public function subscribe(fn: Subscriber<TState>): Void {
        subscribers.push(fn);
    }

    public function unsubscribe(fn: Subscriber<TState>): Void {
        subscribers.remove(fn);
    }
}

typedef Middleware<TState, TAction> = Context<TState, TAction> -> Future<Unit>;

typedef Context<TState, TAction> = {
    var state(default, null): TState;
    var action(default, null): TAction;
    function commit(reducer: TState -> TState): Void;
}

typedef Subscriber<TState> = TState -> Void;