package vuehx.extra;

import hxgnd.Unit;
import hxgnd.Future;
import hxgnd.LangTools;

class VuehxModel<TState, TAction> {
    public var state(default, null): TState;
    var hanlder: ActionHanlder<TState, TAction>;
    var subscribers: Array<Subscriber<TState>>;

    public function new(initState: TState, hanlder: ActionHanlder<TState, TAction>) {
        this.state = #if debug LangTools.freeze(initState) #else initState #end;
        this.hanlder = hanlder;
        this.subscribers = [];
    }

    public function dispatch(action: TAction): Future<Unit> {
        return hanlder({
            state: state,
            update: update,
        }, action);
    }

    function update(reducer: TState -> TState): Void {
        var newState = reducer(state);
        if (LangTools.notSame(state, newState)) {
            state = #if debug LangTools.freeze(newState) #else newState #end;
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

typedef ActionHanlder<TState, TAction> = Context<TState> -> TAction -> Future<Unit>;

typedef Context<TState> = {
    var state(default, null): TState;
    function update(reducer: TState -> TState): Void;
}

typedef Subscriber<TState> = TState -> Void;