package;

import vuehx.Vue;

class App implements IVueComponent {
    var _ = {
        name: "App",
        components: {
            hello: component.Hello
        }
    }
}