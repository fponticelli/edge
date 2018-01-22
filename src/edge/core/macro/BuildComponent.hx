package edge.core.macro;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
using thx.macro.MacroFields;

import edge.core.macro.Macros.*;

class BuildComponent {
  macro public static function complete() : Array<Field> {
    var fields = Context.getBuildFields(),
        cls = Context.getLocalClass().get();
    makeVarsPublic(fields);
    injectToString(fields, cls);
    injectConstructor(fields, cls);
    return fields;
  }

  static function injectConstructor(fields : Array<Field>, type : ClassType) {
    if(hasField(fields, "new")) return;
    var args = getVarAsFunctionArgs(fields),
        init = args
          .map(function(arg) return arg.name)
          .map(function(name) return macro this.$name = $i{name});

    var ancestor:Null<ClassType> = getAncestor(type),
        ancestorArgs:Array<FunctionArg> = [];

    if (ancestor != null) {
      do {
        //Reverse concat, to make sure ancestor arguments are first
        var funArgs = getClassVarAsFunctionArgs(ancestor.fields.get());
        args = funArgs.concat(args);
        ancestorArgs = funArgs.concat(ancestorArgs);
        type = ancestor;
      } while((ancestor = getAncestor(type)) != null);

      var a = ancestorArgs.map(function(arg) return macro $i{arg.name});
      init.unshift(macro super($a{a}));
    }
    fields.push(createFunctionField("new", args, macro $b{init}));
  }

  static function injectToString(fields : Array<Field>, type : ClassType) {
    if(hasField(fields, "toString")) return;
    var args = getVarAsFunctionArgs(fields),
        access = [APublic];

    var ancestor:Null<ClassType> = getAncestor(type);
    if (ancestor != null) {
      access.push(AOverride);
      do {
        //Reverse concat, to make sure ancestor arguments are first
        args = getClassVarAsFunctionArgs(ancestor.fields.get()).concat(args);
        type = ancestor;
      } while((ancestor = getAncestor(type)) != null);
    }

    var cls = clsName().split(".").pop(),
        params = args
          // .map(function(arg) return '"${arg.name}="+' + arg.name+'+')
          .map(function(arg) return '"${arg.name}="+' + arg.name)
          .join('+","+'),
        s = 'return "$cls("+$params+")"';
    if (args.length == 0) s = 'return "$cls()"';
    fields.push(createFunctionField(
      "toString",
      [],
      macro : String,
      Context.parse(s, Context.currentPos()),
      access)
    );
  }
}
