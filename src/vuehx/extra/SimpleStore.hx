package vuehx.extra;

class SimpleStore<TState, TAction> {
    var state: TState;
    var middleware: Reducer<TState, TAction>;
    var subscribers: Array<Subscriber<TState>>;

    public function new(middleware: Middleware<TState, TAction>) {
        this.middleware = middleware;
        this.subscribers = [];
    }

    public function dispatch(action: TAction): Void {
        switch (reducer(action, state)) {
            case Sync(s): emit(s);
            case Async(p): p.then(emit);
            case Stream(s): // TODO
        }
    }

    public function subscribe(fn: Subscriber<TState>): Void {
        subscribers.push(fn);
    }

    public function unsubscribe(fn: Subscriber<TState>): Void {
        subscribers.remove(fn);
    }

    function reduce(action: TAction): Void {

    }

    function emit(state: TState): Void {
        this.state = state;
        // call subscriber
    }
}

typedef Middleware<TState, TAction> = TState -> TAction -> MiddlewareResult<TState>;

enum MiddlewareResult<TState> {
    Sync(state: TState);
    Async(promise: js.Promise<TState>);
    Stream(stream: Stream<TState>);
}

typedef Subscriber<TState> = TState -> Void;
