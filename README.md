# vue.hx
Haxe extern for Vue.js.
This product is alpha version.

## Motivation
* I want to develop the Vue.js application with Haxe/JS.
* But I don't like Webpack.
* So, I have to make a Vue.js extern that is not dependent on Webpack.
* And this extern must be able to parse the Vue.js template at compile-time.

## Requirements
* Haxe 3.4.x
* Node.js v8+
* npm or yarn

## Creating a new vue.hx project
WIP

1. Create a project directory:

    ```
    mkdir MyProject
    cd MyProject
    ```

2. Install vuehx.

    ```
    haxelib newrepo
    haxelib git vuehx https://github.com/DenkiYagi/vuehx.git
    ```

3. Install npm modules.

    ```
    haxelib run vuehx setup
    ```

    If you want to use yarn, try `setup-yarn`:

    ```
    haxelib run vuehx setup-yarn
    ```

4. ...

## Updating vue.hx
```
haxelib update
haxelib run vuehx setup
```

If you are using yarn, run this:

```
haxelib update
haxelib run vuehx setup-yarn
```


