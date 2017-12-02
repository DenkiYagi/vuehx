package vuehx;

import haxe.macro.Context;
import haxe.macro.Type;
import haxe.macro.Expr;

class VueHelper {
    public static macro function vue() {
        var cls = Context.getLocalClass().get();
        for (s in cls.statics.get()) {
            if (s.name != "options") continue;
            
            switch (s.type) {
                case TType(_, params):
                    var T = Context.toComplexType(params[0]);
                    return macro {
                        var vue: vuehx.Vue<$T> = js.Lib.nativeThis;
                        vue;
                    }
                case _:
                    break;
            }
        }
        
        return macro null;
    }
}