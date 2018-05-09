package vuehx.extra;

import hxgnd.Unit;
import hxgnd.Future;
import hxgnd.LangTools;
import externtype.ValueOrArray;

class VuehxStore<TState, TAction> {
    public var state(default, null): TState;
    var subscribers: Array<Subscriber<TState>>;
    var middlewares: Array<Middleware<TState, TAction>>;

    public function new(initState: TState, middlewares: ValueOrArray<Middleware<TState, TAction>>) {
        this.state = #if debug LangTools.freeze(initState) #else initState #end;
        this.subscribers = [];
        this.middlewares = middlewares.toArray();
    }

    public function dispatch(action: TAction): Future<Unit> {
        var len = middlewares.length;
        if (len <= 0) return Future.successfulUnit();

        var i = 0;
        var completed = false;

        function commit(reducer: TState -> TState): Void {
            if (completed) return;

            var newState = reducer(state);
            if (LangTools.notSame(state, newState)) {
                state = #if debug LangTools.freeze(newState) #else state #end;
                for (f in subscribers) f(state);
            }
        }

        function next() {
            return if (i < len) {
                var future = middlewares[i++]({
                    state: state,
                    action: action,
                    commit: commit,
                    next: next,
                });
                future.then(function (_) {
                    completed = true;
                });
                future;
            } else {
                Future.successfulUnit();
            }
        }
        return next();
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
    function next(): Future<Unit>;
}

typedef Subscriber<TState> = TState -> Void;