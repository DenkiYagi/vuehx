package vuehx.extra;

import hxgnd.Unit;
import hxgnd.Future;
import hxgnd.LangTools;

class VuehxModel<TAction, TState> {
    public var state(default, null): TState;
    var hanlder: ActionHanlder<TAction, TState>;
    var subscribers: Array<Subscriber<TState>>;

    public function new(hanlder: ActionHanlder<TAction, TState>, initState: TState) {
        this.state = #if debug LangTools.freeze(initState) #else initState #end;
        this.hanlder = hanlder;
        this.subscribers = [];
    }

    public function dispatch(action: TAction): Future<Unit> {
        return hanlder(action, {
            state: state,
            update: update,
        });
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

typedef ActionHanlder<TAction, TState> = TAction -> Context<TState> -> Future<Unit>;

typedef Context<TState> = {
    var state(default, null): TState;
    function update(reducer: TState -> TState): Void;
}

typedef Subscriber<TState> = TState -> Void;