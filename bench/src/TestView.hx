import thx.benchmark.speed.*;

import edge.Entity;
using thx.Ints;
import ViewCurrent;
import ViewOpt;
import ViewOrderedMap;

class TestView {
  public static var minReps = 10;
  public static var maxTime = 100;
  public static function main() {
    for(qt in [10000]) {
      add(qt);
      remove(qt);
      array(qt);
      iterate(qt);
      pairs(qt);
    }
  }

  static function print(qt: Int, msg: String) {
    #if hxnodejs
      js.Node.console.log('\n ━━━━━━━━━━━━━━━━━━━━ \n┃ QT: ${qt.lpad(" ", 14)} ┃' + msg);
    #elseif cpp
      Sys.print('\n ━━━━━━━━━━━━━━━━━━━━ \n┃ QT: ${qt.lpad(" ", 14)} ┃' + msg);
    #else
      trace('\n ━━━━━━━━━━━━━━━━━━━━ \n┃ QT: ${qt.lpad(" ", 14)} ┃' + msg);
    #end
  }

  public static function add(qt: Int) {
    var suite = new Suite(minReps, maxTime);
    var instances = createInstances(qt);

    function pick() return instances[Math.floor(instances.length * Math.random())];

    suite.add('add: current', function() {
      var view = new ViewCurrent();
      var inst;
      @:measure {
        inst = pick();
        view.tryAdd(inst.entity, inst.data);
      };
    });

    suite.add('add: ordered', function() {
      var view = new ViewOrderedMap();
      var inst;
      @:measure {
        inst = pick();
        view.tryAdd(inst.entity, inst.data);
      };
    });

    suite.add('add: optimized    ', function() {
      var view = new ViewOpt();
      var inst;
      @:measure {
        inst = pick();
        view.tryAdd(inst.entity, inst.data);
      };
    });

    print(qt, suite.run().toString());
  }

  public static function remove(qt: Int) {
    var suite = new Suite(minReps, maxTime);
    var instances = createInstances(qt);
    var toRemove = Std.int(qt / 3);

    function pick() return instances[Math.floor(instances.length * Math.random())].entity;

    suite.add('remove: current', function() {
      var view = new ViewCurrent();
      for(inst in instances)
        view.tryAdd(inst.entity, inst.data);
      @:measure {
        view.tryRemove(pick());
      };
    });

    suite.add('remove: ordered', function() {
      var view = new ViewOrderedMap();
      for(inst in instances)
        view.tryAdd(inst.entity, inst.data);
      @:measure {
        view.tryRemove(pick());
      };
    });

    suite.add('remove: optimized ', function() {
      var view = new ViewOpt();
      for(inst in instances)
        view.tryAdd(inst.entity, inst.data);
      @:measure {
        view.tryRemove(pick());
      };
    });

    print(qt, suite.run().toString());
  }

  public static function array(qt: Int) {
    var suite = new Suite(minReps, maxTime);
    var instances = createInstances(qt);

    suite.add('array: current  ', function() {
      var view = new ViewCurrent();
      for(inst in instances)
        view.tryAdd(inst.entity, inst.data);
      var v = 0;
      @:measure {
        v = view.array().length;
      };
      if(v != qt) throw 'unexpected result $v';
    });

    suite.add('array: ordered  ', function() {
      var view = new ViewOrderedMap();
      for(inst in instances)
        view.tryAdd(inst.entity, inst.data);
      var v = 0;
      @:measure {
        v = view.array().length;
      };
      if(v != qt) throw 'unexpected result $v';
    });

    suite.add('array: optimized  ', function() {
      var view = new ViewOpt();
      for(inst in instances)
        view.tryAdd(inst.entity, inst.data);
      var v = 0;
      @:measure {
        v = view.array().length;
      };
      if(v != qt) throw 'unexpected result $v';
    });

    print(qt, suite.run().toString());
  }

  public static function iterate(qt: Int) {
    var suite = new Suite(minReps, maxTime);
    var instances = createInstances(qt);

    suite.add('iterate: current', function() {
      var view = new ViewCurrent();
      for(inst in instances)
        view.tryAdd(inst.entity, inst.data);
      var v = null;
      @:measure {
        for(it in view)
          v = it.data.name;
      };
      if(v != "Doe") throw 'unexpected result $v';
    });

    suite.add('iterate: ordered', function() {
      var view = new ViewOrderedMap();
      for(inst in instances)
        view.tryAdd(inst.entity, inst.data);
      var v = null;
      @:measure {
        for(it in view)
          v = it.data.name;
      };
      if(v != "Doe") throw 'unexpected result $v';
    });

    suite.add('iterate: optimized', function() {
      var view = new ViewOpt();
      for(inst in instances)
        view.tryAdd(inst.entity, inst.data);
      var v = null;
      @:measure {
        for(it in view)
          v = it.data.name;
      };
      if(v != "Doe") throw 'unexpected result $v';
    });

    print(qt, suite.run().toString());
  }

  public static function pairs(qt: Int) {
    var suite = new Suite(minReps, maxTime);
    var instances = createInstances(qt);

    suite.add('pairs: current', function() {
      var view = new ViewCurrent();
      for(inst in instances)
        view.tryAdd(inst.entity, inst.data);
      var tot = 0;
      @:measure {
        view.pairs(function(a, b) {
          tot = a.data.age + b.data.age;
        });
      };
      if(tot == 0) throw 'unexpected result $tot';
    });

    suite.add('pairs: ordered', function() {
      var view = new ViewOrderedMap();
      for(inst in instances)
        view.tryAdd(inst.entity, inst.data);
      var tot = 0;
      @:measure {
        view.pairs(function(a: ViewDataOrderedMap<Data>, b: ViewDataOrderedMap<Data>) {
          tot = a.data.age + b.data.age;
        });
      }
      if(tot == 0) throw 'unexpected result $tot';
    });

    suite.add('pairs: optimized  ', function() {
      var view = new ViewOpt();
      for(inst in instances)
        view.tryAdd(inst.entity, inst.data);
      var tot = 0;
      @:measure {
        view.pairs(function(a, b) {
          tot = a.data.age + b.data.age;
        });
      };
      if(tot == 0) throw 'unexpected result $tot';
    });

    print(qt, suite.run().toString());
  }

  @:access(edge.Entity.new)
  public static function createInstances(qt: Int) {
    var arr = [];
    for(i in 0...qt) {
      arr.push({ entity : new Entity(null, []), data : data });
    }
    return arr;
  }

  public static var data: Data = { name : "Doe", age : 10 };
}

typedef Data = { name : String, age : Int };
