package vuehx.extra;

import hxgnd.Unit;
import hxgnd.AbortablePromise;
import hxgnd.LangTools;

class VuehxModel<TState, TCommand> {
    var middleware: MiddlewareFunc<TState, TCommand>;
    var subscribers: Array<Subscriber<TState>>;

    public var state(default, null): TState;

    public function new(middleware: Middleware<TState, TCommand>, initState: TState) {
        this.middleware = middleware;
        this.subscribers = [];
        this.state = #if debug LangTools.freeze(initState) #else initState #end;
    }

    public function dispatch(message: TCommand): AbortablePromise<Unit> {
        return middleware({
            state: state,
            update: update,
        }, message);
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

abstract Middleware<TState, TCommand>(MiddlewareFunc<TState, TCommand>)
    from MiddlewareFunc<TState, TCommand> to MiddlewareFunc<TState, TCommand>
{
    inline function new(x: MiddlewareFunc<TState, TCommand>) {
        this = x;
    }

    @:from
    public static inline function from1<TState, TCommand>(obj: { call: MiddlewareFunc<TState, TCommand> }) {
        return new Middleware(obj.call);
    }

    @:from
    public static inline function from2<TState, TCommand>(obj: { function call(ctx: Context<TState>, msg: TCommand): AbortablePromise<Unit>; }) {
        return new Middleware(obj.call);
    }
}

private typedef MiddlewareFunc<TState, TCommand> = Context<TState> -> TCommand -> AbortablePromise<Unit>;