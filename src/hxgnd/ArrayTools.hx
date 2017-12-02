package hxgnd;

class ArrayTools {
    // public static function head<T>(array: Array<T>): T {
    //     if (array.length <= 0) throw "empty array";
    //     return array[0];
    // }

    // public static function tail<T>(array: Array<T>): T

    public static function first<T>(array: Array<T>, fn: T -> Bool): Optional<T> {
        for (x in array) {
            if (fn(x)) return x;
        }
        return Optional.empty();
    }

    public static function indexOf<T>(array: Array<T>, fn: T -> Bool): Optional<Int> {
        for (i in 0...array.length) {
            if (fn(array[i])) return i;
        }
        return Optional.empty();
    }

    public static function remove<T>(array: Array<T>, fn: T -> Bool): Optional<T> {
        for (i in 0...array.length) {
            if (fn(array[i])) return array.splice(i, 1)[0];
        }
        return Optional.empty();
    }
}