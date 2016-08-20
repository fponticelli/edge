import edge.Entity;
using thx.Iterators;

class ViewOpt<T : {}> {
  public var count(default, null): Int;
  var map: Map<Entity, ViewDataOpt<T>>;
  public function new() {
    map = new Map();
    count = 0;
  }

  public function iterator() : Iterator<ViewDataOpt<T>>
    return map.iterator();

  public function array(): Array<ViewDataOpt<T>> {
    var arr: Array<ViewDataOpt<T>> = [];
    for(v in map) {
      arr.push(v);
    }
    return arr;
  }

  public function array2(): Array<ViewDataOpt<T>> {
    var arr: Array<ViewDataOpt<T>> = #if js untyped __js__("new Array")(count) #else [] #end;
    var counter = 0;
    for(v in map) {
      arr[counter++] = v;
    }
    return arr;
  }

  public function pairs(f: ViewDataOpt<T> -> ViewDataOpt<T> -> Void) {
    var arr = array();
    if(arr.length < 2) return;
    for(i in 0...arr.length - 1) {
      for(j in (i+1)...arr.length) {
        f(arr[i], arr[j]);
      }
    }
  }

  public function tryAdd(entity : Entity, data : T) {
    if(map.exists(entity)) return false;
    map.set(entity, { entity : entity, data : data });
    count++;
    return true;
  }

  public function tryRemove(entity : Entity) : T {
    if(!map.exists(entity)) return null;
    var inst = map.get(entity);
    map.remove(entity);
    count--;
    return inst.data;
  }
}

typedef ViewDataOpt<T : {}> = {
  entity : Entity,
  data : T
}
