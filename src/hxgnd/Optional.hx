package hxgnd;

abstract Optional<T>(Null<T>) from Null<T> {
	public static inline function of<T>(x: Null<T>): Optional<T> {
		return if (x != null) x else throw "null value";
	}
	
	public static inline function empty<T>(): Optional<T>  {
		return null;
	}
	
	public inline function isEmpty(): Bool {
		return this == null;
	}
	
	public inline function nonEmpty(): Bool {
		return this != null;
	}
	
	public inline function get(): T {
		return if (nonEmpty()) this else throw "null value";
	}
	
	public inline function getOr(x: T): T {
		return if (nonEmpty()) this else x;
	}
	
	public inline function getOrNull(x: T): Null<T> {
		return this;
	}
	
	public inline function getOrElse(fn: Void -> T): T {
		return if (nonEmpty()) this else fn();
	}
	
	public inline function getOrThrow(error: Any): T {
		return if (nonEmpty()) this else throw error;
	}

	public inline function foreach(fn: T -> Void): Void {
		if (nonEmpty()) fn(this);
	}

	public inline function map<U>(fn: T -> U): Optional<U> {
		return if (nonEmpty()) fn(this) else null;
	}
	
	public inline function flatMap<U>(fn: T -> Optional<U>): Optional<U> {
		return if (nonEmpty()) fn(this) else null;
	}

	public inline function match(fn: T -> Void, elseFn: Void -> Void): Void {
		if (nonEmpty()) {
			fn(this);
		} else {
			elseFn();
		}
	}

	public inline function matchReturn<S>(fn: T -> S, elseFn: Void -> S): S {
		return if (nonEmpty()) {
			fn(this);
		} else {
			elseFn();
		}
	}
}