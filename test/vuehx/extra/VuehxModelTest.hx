package vuehx.extra;

import buddy.BuddySuite;
using buddy.Should;

import vuehx.extra.VuehxModel;
import hxgnd.Future;
import hxgnd.Stream;
import haxe.Timer;
using hxgnd.LangTools;

class VuehxModelTest extends BuddySuite {
    public function new() {
        describe("VuehxModel middleware", {
            it("should can compile", function () {
                new VuehxModel(function (ctx, msg) {
                    return Future.successfulUnit();
                }, 0);
                new VuehxModel({
                    call: function (ctx, msg) {
                        return Future.successfulUnit();
                    }
                }, 0);
                new VuehxModel(TestAction, 0);
            });
        });

        describe("VuehxModel.dispatch()", {
            timeoutMs = 100;

            it("should call", function (done) {
                var called = false;
                var model = new VuehxModel(function (ctx, msg) {
                    called = true;
                    ctx.update(function (state) return state);
                    return Future.successfulUnit();
                }, 0);
                model.dispatch(Increment);
                Timer.delay(function () {
                    called.should.be(true);
                    done();
                }, 10);
            });

            it("should call 2-times", function (done) {
                var called = 0;
                var model = new VuehxModel(function (ctx, msg) {
                    called++;
                    return Future.successfulUnit();
                }, 0);
                model.dispatch(Increment);
                model.dispatch(Increment);

                Timer.delay(function () {
                    called.should.be(2);
                    done();
                }, 10);
            });

            it("should not notify when it has given same state", function (done) {
                var model = new VuehxModel(function (ctx, msg) {
                    ctx.update(function (state) return {data: 1});
                    return Future.successfulUnit();
                }, {data: 1});
                model.subscribe(function (x) {
                    fail();
                    done();
                });
                model.dispatch(Increment);
                Timer.delay(done, 10);
            });

            it("should notify when it has given different state", function (done) {
                var model = new VuehxModel(function (ctx, msg) {
                    ctx.update(function (state) return {data: 2});
                    return Future.successfulUnit();
                }, {data: 1});
                model.subscribe(function (x) {
                    x.same({data: 2}).should.be(true);
                    done();
                });
                model.dispatch(Increment);
            });

            it("should notify 2-times", function (done) {
                var model = new VuehxModel(function (ctx, msg) {
                    ctx.update(function (state) return state + 1);
                    return Future.successfulUnit();
                }, 0);

                var count = 0;
                model.subscribe(function (x) {
                    switch (count) {
                        case 0:
                            x.same(1).should.be(true);
                        case 1:
                            x.same(2).should.be(true);
                        case _:
                            fail();
                            done();
                    }
                });

                model.dispatch(Increment);
                count++;
                model.dispatch(Increment);
                count++;
                Timer.delay(done, 10);
            });

            it("should notify 2-subscribers", function (done) {
                var model = new VuehxModel(function (ctx, msg) {
                    ctx.update(function (state) return state + 1);
                    return Future.successfulUnit();
                }, 0);

                var count1 = 0;
                model.subscribe(function (x) {
                    x.should.be(++count1);
                });

                var count2 = 0;
                model.subscribe(function (x) {
                    x.should.be(++count2);
                });

                model.dispatch(Increment);
                model.dispatch(Increment);
                Timer.delay(function () {
                    count1.should.be(2);
                    count2.should.be(2);
                    done();
                }, 10);
            });

            describe("returned Future", {
                it("should not be active", {
                    var model = new VuehxModel(function (ctx, msg) {
                        return Future.successfulUnit();
                    }, {data: 1});
                    var future = model.dispatch(Increment);
                    future.isActive.should.be(false);
                });

                it("should abort with Future", function (done) {
                    var model = new VuehxModel(function (ctx, msg) {
                        return Future.applySync(function (ctx) {
                            ctx.onAbort = function () {
                                done();
                            }
                        });
                    }, {data: 1});
                    var future = model.dispatch(Increment);
                    future.abort();
                });

                it("should abort with Stream", function (done) {
                    var model = new VuehxModel(function (_, _) {
                        return Stream.apply(function (ctx) {
                            ctx.onAbort = function () {
                                done();
                            }
                        }).end;
                    }, {data: 1});

                    var future = model.dispatch(Increment);
                    Timer.delay(function () {
                        future.abort();
                    }, 10);
                });
            });
        });

        describe("VuehxModel.unsubscribe()", {
            it("should pass", {
                var model = new VuehxModel(function (ctx, msg) {
                    ctx.update(function (state) return state + 1);
                    return Future.successfulUnit();
                }, 0);

                var count = 0;
                function subscriber(x) {
                    count++;
                }
                model.subscribe(subscriber);
                model.dispatch(Increment);
                count.should.be(1);

                model.unsubscribe(subscriber);
                model.dispatch(Increment);
                count.should.be(1);
            });
        });
    }
}

enum Command {
    Increment;
}

class TestAction {
    public static function call(ctx, msg) {
        return Future.successfulUnit();
    }
}