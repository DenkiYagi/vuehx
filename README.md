# vue.hx
Haxe extern for Vue.js.
This product is alpha version.

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
    haxelib git vuehx
    ```

    If you don't want to install vuehx to global, you can use `haxelib newrepo`.

    ```
    haxelib newrepo
    haxelib git vuehx
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


