package hxgnd;

class MapTools {
    public static function entries<K, V>(map: Map<K, V>): Iterable<{key: K, value: V}> {
        var keys = map.keys();
        
        function iterator(): Iterator<{key: K, value: V}> {
            return {
                hasNext: keys.hasNext,
                next: function () {
                    var k = keys.next();
                    return { key: k, value: map.get(k) };
                }
            } 
        };
        
        return { iterator: iterator };
    }
}