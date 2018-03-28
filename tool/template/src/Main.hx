package;

import vuehx.Vue;

class Main {
    public static function main(): Void {
        var vue = new Vue({
            render: function (createElement) {
                return createElement(App);
            }
        });
        vue.mount("#app");
    }
}