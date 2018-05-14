package vuehx.extra;

import hxgnd.Unit;
import hxgnd.Future;
import hxgnd.LangTools;

class VuehxModel<TState, TAction> {
    public var state(default, null): TState;
    var processor: Processor<TState, TAction>;
    var subscribers: Array<Subscriber<TState>>;

    public function new(initState: TState, middleware: Middleware<TState, TAction>) {
        this.state = #if debug LangTools.freeze(initState) #else initState #end;
        this.processor = middleware;
        this.subscribers = [];
    }

    public function dispatch(action: TAction): Future<Unit> {
        return processor({
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

typedef Context<TState> = {
    var state(default, null): TState;
    function update(reducer: TState -> TState): Void;
}

typedef Subscriber<TState> = TState -> Void;

private typedef Processor<TState, TAction> = Context<TState> -> TAction -> Future<Unit>;

abstract Middleware<TState, TAction>(Processor<TState, TAction>)
    from Processor<TState, TAction> to Processor<TState, TAction>
{
    inline function new(x: Processor<TState, TAction>) {
        this = x;
    }

    @:from
    public static inline function from<TState, TAction>(obj: { process: Processor<TState, TAction> }) {
        return new Middleware(obj.process);
    }
}