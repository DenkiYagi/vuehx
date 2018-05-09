package vuehx.extra;

import buddy.BuddySuite;
using buddy.Should;

import vuehx.extra.VuehxStore;
import hxgnd.Future;
import hxgnd.Stream;
import haxe.Timer;
using hxgnd.LangTools;

class VuehxStoreTest extends BuddySuite {
    public function new() {
        describe("VuehxStore.dispatch()", {
            timeoutMs = 100;

            describe("No middleware", {
                it("should not throw error", function (done) {
                    var store = new VuehxStore(0, []);
                    store.dispatch(Increment);
                    Timer.delay(function () {
                        done();
                    }, 10);
                });

                it("should not be active", {
                    var store = new VuehxStore({data: 1}, []);
                    var future = store.dispatch(Increment);
                    future.isActive.should.be(false);
                });
            });

            describe("Single middleware", {
                it("should call", function (done) {
                    var called = false;
                    var store = new VuehxStore(0, function (ctx) {
                        called = true;
                        ctx.commit(function (state) return state);
                        return Future.successfulUnit();
                    });
                    store.dispatch(Increment);
                    Timer.delay(function () {
                        called.should.be(true);
                        done();
                    }, 10);
                });

                it("should call 2-times", function (done) {
                    var called = 0;
                    var store = new VuehxStore(0, function (ctx) {
                        called++;
                        return Future.successfulUnit();
                    });
                    store.dispatch(Increment);
                    store.dispatch(Increment);

                    Timer.delay(function () {
                        called.should.be(2);
                        done();
                    }, 10);
                });

                it("should not notify when it call next", function (done) {
                    var store = new VuehxStore(0, function (ctx) {
                        return ctx.next();
                    });
                    store.subscribe(function (x) {
                        fail();
                        done();
                    });
                    store.dispatch(Increment);
                    Timer.delay(done, 10);
                });

                it("should not notify when it has given same state", function (done) {
                    var store = new VuehxStore({data: 1}, function (ctx) {
                        ctx.commit(function (state) return {data: 1});
                        return Future.successfulUnit();
                    });
                    store.subscribe(function (x) {
                        fail();
                        done();
                    });
                    store.dispatch(Increment);
                    Timer.delay(done, 10);
                });

                it("should notify when it has given different state", function (done) {
                    var store = new VuehxStore({data: 1}, function (ctx) {
                        ctx.commit(function (state) return {data: 2});
                        return Future.successfulUnit();
                    });
                    store.subscribe(function (x) {
                        x.same({data: 2}).should.be(true);
                        done();
                    });
                    store.dispatch(Increment);
                });

                it("should notify 2-times", function (done) {
                    var store = new VuehxStore(0, function (ctx) {
                        ctx.commit(function (state) return state + 1);
                        return Future.successfulUnit();
                    });

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
                    var store = new VuehxStore(0, function (ctx) {
                        ctx.commit(function (state) return state + 1);
                        return Future.successfulUnit();
                    });

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
                        var store = new VuehxStore({data: 1}, function (ctx) {
                            return Future.successfulUnit();
                        });
                        var future = store.dispatch(Increment);
                        future.isActive.should.be(false);
                    });

                    it("should abort with Future", function (done) {
                        var store = new VuehxStore({data: 1}, function (ctx) {
                            return Future.applySync(function (ctx) {
                                ctx.onAbort = function () {
                                    done();
                                }
                            });
                        });
                        var future = store.dispatch(Increment);
                        future.abort();
                    });

                    it("should abort with Stream", function (done) {
                        var store = new VuehxStore({data: 1}, function (_) {
                            return Stream.apply(function (ctx) {
                                ctx.onAbort = function () {
                                    done();
                                }
                            }).end;
                        });

                        var future = store.dispatch(Increment);
                        Timer.delay(function () {
                            future.abort();
                        }, 10);
                    });
                });
            });

            describe("Multiple middleware", {
                it("should call only 1st middleware", function (done) {
                    var called = false;
                    var store = new VuehxStore(0, [
                        function (ctx) {
                            called = true;
                            return Future.successfulUnit();
                        },
                        function (ctx) {
                            fail();
                            return Future.successfulUnit();
                        }
                    ]);
                    store.dispatch(Increment);
                    Timer.delay(function () {
                        called.should.be(true);
                        done();
                    }, 10);
                });

                it("should call 2nd middleware", function (done) {
                    var called1 = false;
                    var called2 = false;
                    var store = new VuehxStore(0, [
                        function (ctx) {
                            called1 = true;
                            return ctx.next();
                        },
                        function (ctx) {
                            called2 = true;
                            return Future.successfulUnit();
                        }
                    ]);
                    store.dispatch(Increment);
                    Timer.delay(function () {
                        called1.should.be(true);
                        called2.should.be(true);
                        done();
                    }, 10);
                });

                it("should not commit when it already completed", function (done) {
                    var store = new VuehxStore(0, [
                        function (ctx) {
                            Timer.delay(function () {
                                ctx.commit(function (x) return 1);
                            }, 5);
                            return ctx.next();
                        },
                        function (ctx) {
                            ctx.commit(function (x) return 2);
                            return Future.successfulUnit();
                        }
                    ]);
                    store.dispatch(Increment);
                    Timer.delay(function () {
                        store.state.should.be(2);
                        done();
                    }, 10);
                });

            });
        });

        describe("VuehxStore.unsubscribe()", {
            it("should pass", {
                var store = new VuehxStore(0, function (ctx) {
                    ctx.commit(function (state) return state + 1);
                    return Future.successfulUnit();
                });

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