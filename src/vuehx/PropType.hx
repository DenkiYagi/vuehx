package vuehx;

import haxe.Constraints.Function;

abstract PropType(Function) {
    public static var String(get, never): PropType;
    public static var Number(get, never): PropType;
    public static var Boolean(get, never): PropType;
    public static var Function(get, never): PropType;
    public static var Object(get, never): PropType;
    public static var Array(get, never): PropType;
    public static var Symbol(get, never): PropType;

    inline static function get_String(): PropType {
        return untyped __js__("String");
    }

    inline static function get_Number(): PropType {
        return untyped __js__("Number");
    }

    inline static function get_Boolean(): PropType {
        return untyped __js__("Boolean");
    }

    inline static function get_Function(): PropType {
        return untyped __js__("Function");
    }

    inline static function get_Object(): PropType {
        return untyped __js__("Object");
    }

    inline static function get_Array(): PropType {
        return untyped __js__("Array");
    }

    inline static function get_Symbol(): PropType {
        return untyped __js__("Symbol");
    }
}