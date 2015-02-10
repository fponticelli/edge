package edge.core.macro;

import haxe.macro.Context;
import haxe.macro.Expr;
using thx.macro.MacroFields;
import Type in RType;

class Macros {
  public static function makeVarsPublic(fields : Array<Field>) {
    fields.map(function(field) switch field.kind {
      case FVar(_, _) if(!field.isPublic()):
        field.access.push(APublic);
      case _:
    });
  }

  public static function makePublic(fields : Array<Field>, name : String) {
    var field = findField(fields, name);
    if(null == field) return;
    makeFieldPublic(field);
  }

  public static function makeFieldPublic(field : Field) {
    if(isPublic(field)) return;
    field.access.push(APublic);
  }

  public static function isPublic(field : Field) {
    for(a in field.access)
      if(RType.enumEq(a, APublic))
        return true;
    return false;
  }

  public static function findField(fields : Array<Field>, name : String) {
    for(field in fields)
      if(field.name == name)
        return field;
    return null;
  }

  public static function hasVarField(fields : Array<Field>, fieldName : String) {
    for(field in fields)
      if(field.name == fieldName && switch field.kind {
        case FVar(_, _): true;
        case _: false;
      })
        return true;
    return false;
  }

  public static function hasFunField(fields : Array<Field>, fieldName : String) {
    for(field in fields)
      if(field.name == fieldName && switch field.kind {
        case FFun(_): true;
        case _: false;
      })
        return true;
    return false;
  }

  public static function fieldHasMeta(field : Field, name : String) {
    if(field.meta == null) return false;
    for(meta in field.meta)
      if(meta.name == name)
        return true;
    return false;
  }

  inline public static function clsName()
    return Context.getLocalClass().toString();

  public static function appendExprToFieldFunction(field : Field, expr : Expr) {
    switch field.kind {
      case FFun(o):
        var exprs = [o.expr, expr];
        o.expr = macro $b{exprs};
      case _:
    }
  }

  public static function fieldFunctionHasArguments(field : Field) {
    switch field.kind {
      case FFun(o):
        return o.args.length > 0;
      case _:
        return false;
    }
  }

  public static function fieldFunctionArguments(field : Field) {
    switch field.kind {
      case FFun(o):
        return o.args;
      case _:
        return null;
    }
  }
}