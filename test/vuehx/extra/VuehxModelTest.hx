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
        describe("VuehxModel.dispatch()", {
            timeoutMs = 100;

            it("should call", function (done) {
                var called = false;
                var store = new VuehxModel(function (action, ctx) {
                    called = true;
                    ctx.update(function (state) return state);
                    return Future.successfulUnit();
                }, 0);
                store.dispatch(Increment);
                Timer.delay(function () {
                    called.should.be(true);
                    done();
                }, 10);
            });

            it("should call 2-times", function (done) {
                var called = 0;
                var store = new VuehxModel(function (action, ctx) {
                    called++;
                    return Future.successfulUnit();
                }, 0);
                store.dispatch(Increment);
                store.dispatch(Increment);

                Timer.delay(function () {
                    called.should.be(2);
                    done();
                }, 10);
            });

            it("should not notify when it has given same state", function (done) {
                var store = new VuehxModel(function (action, ctx) {
                    ctx.update(function (state) return {data: 1});
                    return Future.successfulUnit();
                }, {data: 1});
                store.subscribe(function (x) {
                    fail();
                    done();
                });
                store.dispatch(Increment);
                Timer.delay(done, 10);
            });

            it("should notify when it has given different state", function (done) {
                var store = new VuehxModel(function (action, ctx) {
                    ctx.update(function (state) return {data: 2});
                    return Future.successfulUnit();
                }, {data: 1});
                store.subscribe(function (x) {
                    x.same({data: 2}).should.be(true);
                    done();
                });
                store.dispatch(Increment);
            });

            it("should notify 2-times", function (done) {
                var store = new VuehxModel(function (action, ctx) {
                    ctx.update(function (state) return state + 1);
                    return Future.successfulUnit();
                }, 0);

                var count = 0;
                store.subscribe(function (x) {
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

                store.dispatch(Increment);
                count++;
                store.dispatch(Increment);
                count++;
                Timer.delay(done, 10);
            });

            it("should notify 2-subscribers", function (done) {
                var store = new VuehxModel(function (action, ctx) {
                    ctx.update(function (state) return state + 1);
                    return Future.successfulUnit();
                }, 0);

                var count1 = 0;
                store.subscribe(function (x) {
                    x.should.be(++count1);
                });

                var count2 = 0;
                store.subscribe(function (x) {
                    x.should.be(++count2);
                });

                store.dispatch(Increment);
                store.dispatch(Increment);
                Timer.delay(function () {
                    count1.should.be(2);
                    count2.should.be(2);
                    done();
                }, 10);
            });

            describe("returned Future", {
                it("should not be active", {
                    var store = new VuehxModel(function (action, ctx) {
                        return Future.successfulUnit();
                    }, {data: 1});
                    var future = store.dispatch(Increment);
                    future.isActive.should.be(false);
                });

                it("should abort with Future", function (done) {
                    var store = new VuehxModel(function (action, ctx) {
                        return Future.applySync(function (ctx) {
                            ctx.onAbort = function () {
                                done();
                            }
                        });
                    }, {data: 1});
                    var future = store.dispatch(Increment);
                    future.abort();
                });

                it("should abort with Stream", function (done) {
                    var store = new VuehxModel(function (_, _) {
                        return Stream.apply(function (ctx) {
                            ctx.onAbort = function () {
                                done();
                            }
                        }).end;
                    }, {data: 1});

                    var future = store.dispatch(Increment);
                    Timer.delay(function () {
                        future.abort();
                    }, 10);
                });
            });
        });

        describe("VuehxModel.unsubscribe()", {
            it("should pass", {
                var store = new VuehxModel(function (action, ctx) {
                    ctx.update(function (state) return state + 1);
                    return Future.successfulUnit();
                }, 0);

                var count = 0;
                function subscriber(x) {
                    count++;
                }
                store.subscribe(subscriber);
                store.dispatch(Increment);
                count.should.be(1);

                store.unsubscribe(subscriber);
                store.dispatch(Increment);
                count.should.be(1);
            });
        });
    }
}

enum Action {
    Increment;
}