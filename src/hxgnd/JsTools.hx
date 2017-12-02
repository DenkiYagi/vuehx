package hxgnd;

import hxgnd.js.JsReflect;
import js.html.EventTarget;
import js.html.EventListener;
import haxe.Constraints.Function;
import haxe.extern.EitherType;

class JsTools {
    public static inline function addVenderEventListener(target: EventTarget, type: String, listener: EitherType<EventListener, Function>, ?capture: Bool = false): Void {
        if (JsReflect.has(target, "on" + type)) {
            target.addEventListener(type, listener);
        } else if (JsReflect.has(target, "onwebkit" + type)) {
            target.addEventListener("webkit" + type, listener);
        } else if (JsReflect.has(target, "onmoz" + type)) {
            target.addEventListener("moz" + type, listener);
        } else if (JsReflect.has(target, "onms" + type)) {
            target.addEventListener("ms" + type, listener);
        } 
    }

    public static inline function removeVenderEventListener(target: EventTarget, type: String, listener: EitherType<EventListener, Function>, ?capture: Bool = false): Void {
        if (JsReflect.has(target, "on" + type)) {
            target.removeEventListener(type, listener);
        } else if (JsReflect.has(target, "onwebkit" + type)) {
            target.removeEventListener("webkit" + type, listener);
        } else if (JsReflect.has(target, "onmoz" + type)) {
            target.removeEventListener("moz" + type, listener);
        } else if (JsReflect.has(target, "onms" + type)) {
            target.removeEventListener("ms" + type, listener);
        } 
    }

    public static inline function instanceof(v: Dynamic, t: Dynamic): Bool {
        return untyped __instanceof__(v, t);
    }

    public static inline function typeof(v: Dynamic): String {
        return untyped __typeof__(v);
    }

    public static inline function equals(a: Dynamic, b: Dynamic): Bool {
        return untyped __strict_eq__(a, b);
    }

    public static inline function notEquals(a: Dynamic, b: Dynamic): Bool {
        return untyped __strict_neq__(a, b);
    }
}