package;

import vuehx.Vue;
import vuehx.IVueComponent;
import page.Sample;

class Test {
    public static function main() {
        var vue = new Vue({
            render: function (createElement) {
                return createElement(Sample);
            }
        });
        vue.mount("#app");
    }
}
