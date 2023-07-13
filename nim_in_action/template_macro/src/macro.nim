import macros
import std/json

dumpTree:
  config MyAppConfig:
    address: string
    port: int
  

macro configCheck(typeName: untyped, fields: untyped): untyped =
  result = newStmtList()
  echo treeRepr(typeName)
  echo treeRepr(fields)

configCheck MyAppConfig:
  address: string
  port: int

# 上面给出来下面的信息
# Ident "MyAppConfig"
# StmtList
#   Call
#     Ident "address"
#     StmtList
#       Ident "string"
#   Call
#     Ident "port"
#     StmtList
#       Ident "int"
  
proc createRefType(ident: NimIdent, identDefs: seq[NimNode]): NimNode =
  result = newTree(nnkTypeSection,
    newTree(nnkTypeDef,
      newIdentNode(ident),
      newEmptyNode(),
      newTree(nnkRefTy,
        newTree(nnkObjectTy,
          newEmptyNode(),
          newEmptyNode(),
          newTree(nnkRecList,
            identDefs
          )
        )
      )
    )
  )

proc toIdentDefs(stmtList: NimNode): seq[NimNode] =
  expectKind(stmtList, nnkStmtList)
  result = @[]
  for child in stmtList:
    expectKind(child, nnkCall)
    result.add(
      newIdentDefs(
        child[0],
        child[1][0]
      )
    )

template constructor(ident: untyped): untyped =
  proc `new ident`(): `ident` =
    new result

# proc load*(cfg: MyAppConfig, filename: string) =
#   var obj = parseFile(filename)
#   cfg.address = obj["address"].getStr
#   cfg.port = obj["port"].getNum.int

proc createLoadProc(typeName: NimIdent, identDefs: seq[NimNode]): NimNode =
  var cfgIdent = newIdentNode("cfg")
  var filenameIdent = newIdentNode("filename")
  var objIdent = newIdentNode("obj")

  var body = newStmtList()
  body.add quote do:
    var `objIdent` = parseFile(`filenameIdent`)

  for identDef in identDefs:
    let fieldNameIdent = identDef[0]
    let fieldName = $fieldNameIdent.ident
    case $identDef[1].ident
    of "string":
      body.add quote do:
        `cfgIdent`.`fieldNameIdent` = `objIdent`[`fieldName`].getStr
    of "int":
      body.add quote do:
        `cfgIdent`.`fieldNameIdent` = `objIdent`[`fieldName`].getInt.int
    else:
      doAssert(false, "Not Implemented")

  return newProc(newIdentNode("load"),
    [newEmptyNode(),
    newIdentDefs(cfgIdent, newIdentNode(typeName)),
    newIdentDefs(filenameIdent, newIdentNode("string"))],
    body)

macro config(typeName: untyped, fields: untyped): untyped =
  result = newStmtList()
  let identDefs = toIdentDefs(fields)
  result.add createRefType(typeName.ident, identDefs)
  result.add getAst(constructor(typeName.ident))
  result.add createLoadProc(typeName.ident, identDefs)
  echo "------\n", repr(result)


config MyAppConfig:
  address: string
  port: int

var myConf = newMyAppConfig()
myConf.load("myappconfig.json")
echo("Address: ", myConf.address)
echo("Port: ", myConf.port)

