package edge;

import thx.OrderedMap;

#if js
class View<T : {}> {
  public var map(default, null): OrderedMap<Entity, { entity : Entity, data : T }>;
  public var count(get, null): Int;
  public function new()
    map = OrderedMap.createObject();

  function get_count()
    return map.length;

  public function iterator(): Iterator<ViewData<T>>
    return map.iterator();

  public function array(): Array<ViewData<T>>
    return map.toArray();

  public function pairs(f: ViewData<T> -> ViewData<T> -> Void) {
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
    return true;
  }

  public function tryRemove(entity : Entity) : T {
    var o = map.get(entity);
    if(null == o) return null;
    map.remove(entity);
    return o.data;
  }
}
#else
class View<T : {}> {
  public var count(default, null): Int;
  var map: Map<Entity, ViewData<T>>;
  public function new() {
    map = new Map();
    count = 0;
  }

  public function iterator() : Iterator<ViewData<T>>
    return map.iterator();

  public function array(): Array<ViewData<T>> {
    var arr = [];
    for(v in map)
      arr.push(v);
    return arr;
  }

  public function pairs(f: ViewData<T> -> ViewData<T> -> Void) {
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
#end
