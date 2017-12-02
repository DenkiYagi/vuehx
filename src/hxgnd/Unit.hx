package hxgnd;

abstract Unit(Dynamic) {
    inline function new() {
        this = null;
    }

    public static var _(default, never): Unit;
    inline function get__() {
        return new Unit();
    }
}