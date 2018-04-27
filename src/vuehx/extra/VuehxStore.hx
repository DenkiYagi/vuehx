package vuehx.extra;

import hxgnd.Unit;
import hxgnd.Future;
import hxgnd.LangTools;
import externtype.ValueOrArray;

class VuehxStore<TState, TAction> {
    var currentState: TState;
    var subscribers: Array<Subscriber<TState>>;
    var middlewares: Array<Middleware<TState, TAction>>;

    public function new(initState: TState, middlewares: ValueOrArray<Middleware<TState, TAction>>) {
        this.currentState = #if debug LangTools.freeze(initState) #else initState #end;
        this.subscribers = [];
        this.middlewares = middlewares.toArray().copy();
    }

    public function dispatch(action: TAction): Future<Unit> {
        var i = 0;
        var len = middlewares.length;
        function next() {
            return if (i < len) {
                middlewares[i++]({
                    state: currentState,
                    action: action,
                    commit: commit,
                }, next);
            } else {
                Future.successfulUnit();
            }
        }
        return next();
    }

    function commit(reducer: TState -> TState): Void {
        var state = reducer(currentState);
        if (LangTools.notSame(currentState, state)) {
            currentState = #if debug LangTools.freeze(state) #else state #end;
            for (f in subscribers) f(currentState);
        }
    }

    public function subscribe(fn: Subscriber<TState>): Void {
        subscribers.push(fn);
    }

    public function unsubscribe(fn: Subscriber<TState>): Void {
        subscribers.remove(fn);
    }
}

typedef Middleware<TState, TAction> = Context<TState, TAction> -> Next -> Future<Unit>;
typedef Next = Void -> Future<Unit>;

typedef Context<TState, TAction> = {
    var state(default, null): TState;
    var action(default, null): TAction;
    function commit(reducer: TState -> TState): Void;
}

typedef Subscriber<TState> = TState -> Void;