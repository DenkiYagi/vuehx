package hxgnd;

class Enumerable<T> {
    var fetch: Void -> T;
    var pipeline: Array<T - Result<T>>; 

    function new(fetch: Void -> T, pipeline: Array<T -> Result<T>>) {
        this.fetch = fetch;
        this.pipeline = pipeline;
    }
    

    public function filter(f: T -> Bool) {
        pipeline.push(function (x) {
            return if (f(x)) Some(x) else None;
        })
    }

    public function toArray(): Array<T> {
        return null;
    }
}

private enum Result<T> {
    Some(x: T);
    None;
    End;
} 