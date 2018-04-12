package vuehx.extra;

import hxgnd.Unit;
import hxgnd.Future;
import hxgnd.Stream;
import hxgnd.Abortable;
import hxgnd.LangTools;
import hxgnd.Maybe;
import js.Browser.console;

class VuehxStore<TState, TAction> {
    var currentState: TState;
    var processor: Processor<TState, TAction>;
    var subscribers: Array<Subscriber<TState>>;

    public function new(initState: TState, processor: Processor<TState, TAction>) {
        this.currentState = #if debug LangTools.freeze(initState) #else initState #end;
        this.processor = processor;
        this.subscribers = [];
    }

    public function dispatch(action: TAction): Future<Unit> {
        return processor({
            state: currentState,
            action: action,
            commit: commit,
        });
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

    // inline function emit(state: TState): Void {
    //     if (LangTools.notSame(currentState, state)) {
    //         currentState = #if debug LangTools.freeze(state) #else state #end;
    //         for (f in subscribers) f(currentState);
    //     }
    // }
}

// TODO AbortableをFuture<Void>にする
typedef Processor<TState, TAction> = Context<TState, TAction> -> Future<Unit>;

typedef Context<TState, TAction> = {
    var state(default, null): TState;
    var action(default, null): TAction;
    function commit(reducer: TState -> TState): Void;
}

//typedef PreReducer<TAction> = TAction;

// typedef Reducer<TState, TAction> = TState -> TAction -> ReducerResult<TState>;

// enum ReducerResult<TState> {
//     Sync(state: TState);
//     Async(future: Future<TState>);
//     Stream(stream: Stream<TState>);
// }

typedef Subscriber<TState> = TState -> Void;