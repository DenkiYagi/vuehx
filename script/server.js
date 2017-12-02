#!/usr/bin/env node
// vuehx-sfc-compiler server
'use strict';

const os = require('os');
const fs = require('fs');
const path = require('path');
const express = require('express');
const compiler = require('./vue-compiler');

const SERVICE_NAME = 'vuehx-sfc-compiler-service';

const program = require('commander')
    .usage('[options]')
    .version('0.2.0')
    .option('--port [port]', 'listen port number [default: 54301]', 54301)
    .option('--css-camelcase', 'enable css-module camelcase', false)
    .parse(process.argv);

checkProcess();
start(parseInt(program.port, 10), parseInt(program.expire, 10) * 1000, {
    cssModules: {
        camelCase: program.cssCamelcase
    }
});

function checkProcess() {
    const pidFilePath = path.normalize(os.tmpdir() + '/' + SERVICE_NAME + '.pid');
    
    if (fs.existsSync(pidFilePath)) {
        // TODO プロセスは死んでいるがpidだけ残ってしまっているケースに問題あり
        let pid = parseInt(fs.readFileSync(pidFilePath).toString(), 10);
        if (require('is-running')(pid)) {
            console.log(SERVICE_NAME + ' is already running')
            process.exit(0);
        }
    }
    
    fs.writeFileSync(pidFilePath, process.pid.toString());

    process.on('exit', function () {
        fs.unlinkSync(pidFilePath);
        console.log(SERVICE_NAME + ' is stoped');
    });    
}

function start(port, expire, options) {
    const app = express();

    function closeKeepAlive(res) {
        res.shouldKeepAlive = false;
        
        let conn = res.connection;
        res.on("finish", function () {
            conn.destroy();
        });
    }

    app.get('/', function (req, res) {
        res.send(SERVICE_NAME + ' is running');
    });

    function pong(req, res) {
        res.send('pong');
    }
    app.get('/ping', pong);
    app.post('/ping', pong);

    function compile(req, res) {
        closeKeepAlive(res);
        
        let src = req.params.file || req.query.file;
        if (src && fs.existsSync(src)) {
            res.type("json");
            compiler.compile(src, options).then(function (result) {
                res.send({
                    status: "success",
                    message: result
                });
            }, function(err) {
                res.send({
                    status: "error",
                    message: err
                });
            });
        } else {
            res.send({
                status: "error",
                message: "bad request"
            });
        }
    }
    app.get('/compile', compile);
    app.post('/compile', compile);
    
    const server = app.listen(parseInt(program.port, 10), function () {
        console.log(SERVICE_NAME + ' is started');
    });
    server.listen(port);
}