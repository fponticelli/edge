import edge.Entity;
using thx.Iterators;

class ViewCurrent<T : {}> {
  public var count(default, null) : Int;
  var map : Map<Entity, T>;
  public function new() {
    map = new Map();
    count = 0;
  }

  public function iterator() : Iterator<ViewDataCurrent<T>> {
    var keys = map.keys(),
        holder = { entity : null, data : null };
    return {
      hasNext : function() {
        return keys.hasNext();
      },
      next : function() {
        var key = keys.next();
        holder.entity = key;
        holder.data = map.get(key);
        return holder;
      }
    };
  }

public function array(): Array<ViewDataCurrent<T>>
  return iterator().toArray();

  public function pairs(f: ViewDataCurrent<T> -> ViewDataCurrent<T> -> Void) {
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
    map.set(entity, data);
    count++;
    return true;
  }

  public function tryRemove(entity : Entity) : T {
    var o = map.get(entity);
    if(null == o) return null;
    map.remove(entity);
    count--;
    return o;
  }
}

typedef ViewDataCurrent<T : {}> = {
  entity : Entity,
  data : T
}
