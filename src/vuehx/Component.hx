package vuehx;

import vuehx.Vue;
import js.Promise;
import hxgnd.extern.Mixed2;

abstract Component(Dynamic)
    from Class<Vue<Dynamic>>
    from ComponentOptions<Dynamic>
    from (Mixed2<Class<Vue<Dynamic>>, ComponentOptions<Dynamic>> -> Void) -> (Dynamic -> Void) -> Void
    from Promise<Mixed2<Class<Vue<Dynamic>>, ComponentOptions<Dynamic>>>
    from AsyncComponentOptions
{
    inline function new(x: Dynamic) {
        this = x;
    }

    @:from
    public static function fromVueHxComponent(x: VueHxComponent) {
        return new Component(x.options);
    }
}

typedef VueHxComponent = {
    var options: ComponentOptions<Dynamic>;
}