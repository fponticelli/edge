import edge.Entity;
import thx.OrderedMap;
using thx.Iterators;

class ViewOrderedMap<T : {}> {
  public var map(default, null): OrderedMap<Entity, { entity : Entity, data : T }>;
  public var count(get, null): Int;
  public function new()
    map = OrderedMap.createObject();

  function get_count()
    return map.length;

  public function iterator(): Iterator<ViewDataOrderedMap<T>>
    return map.iterator();

  public function array(): Array<ViewDataOrderedMap<T>>
    return map.toArray();

  public function pairs(f: ViewDataOrderedMap<T> -> ViewDataOrderedMap<T> -> Void) {
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

typedef ViewDataOrderedMap<T : {}> = {
  entity : Entity,
  data : T
}
