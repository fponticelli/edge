package edge;

import thx.OrderedMap;

class View<T : {}> {
  // public var count(default, null) : Int;
  public var map(default, null): OrderedMap<Entity, { entity : Entity, data : T }>;
  public var count(get, null): Int;
  public function new() {
    map = OrderedMap.createObject();
    // count = 0;
  }

  public function at(index: Int)
    return map.at(index);

  // public function iterator()
  //   return map.iterator();

  function get_count()
    return map.length;

  public function iterator() : Iterator<ViewData<T>>
    return map.iterator();

  function tryAdd(entity : Entity, data : T) {
    if(map.exists(entity)) return false;
    map.set(entity, { entity : entity, data : data });
    // count++;
    return true;
  }

  function tryRemove(entity : Entity) : T {
    var o = map.get(entity);
    if(null == o) return null;
    map.remove(entity);
    // count--;
    return o.data;
  }
}