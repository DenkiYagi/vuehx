package vuehx.extra;

import js.Promise;
import hxgnd.Stream;

class SimpleStore<TState, TAction> {
    var currentState: TState;
    var reducer: Reducer<TState, TAction>;
    var subscribers: Array<Subscriber<TState>>;

    public function new(initState: TState, reducer: Reducer<TState, TAction>) {
        this.currentState = initState;
        this.reducer = reducer;
        this.subscribers = [];
    }

    // TODO cancellableを返す
    public function dispatch(action: TAction): Void {
        switch (reducer(action, currentState)) {
            case Sync(state):
                emit(state);
            case Async(promise):
                promise.then(emit);
            case Stream(stream):
                stream.subscribe(function (event) {
                    switch (event) {
                        case Data(state): emit(state);
                        case End:
                    }
                });
        }
    }

    public function subscribe(fn: Subscriber<TState>): Void {
        subscribers.push(fn);
    }

    public function unsubscribe(fn: Subscriber<TState>): Void {
        subscribers.remove(fn);
    }

    inline function emit(state: TState): Void {
        if (currentState != state) {
            currentState = state;
            for (f in subscribers) f(currentState);
        }
    }
}

typedef Reducer<TState, TAction> = TState -> TAction -> ReducerResult<TState>;

enum ReducerResult<TState> {
    Sync(state: TState);
    Async(promise: Promise<TState>);
    Stream(stream: Stream<TState>);
}

typedef Subscriber<TState> = TState -> Void;
