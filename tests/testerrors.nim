#[
  This module uses debug versions of the rpc components that
  allow unchecked and unformatted calls.
]#

import unittest, debugclient, ../rpcserver
import strformat, chronicles

var server = newRpcServer("localhost", 8547.Port)
var client = newRpcClient()

server.start()
waitFor client.connect("localhost", Port(8547))

server.rpc("rpc") do(a: int, b: int):
  result = %(&"a: {a}, b: {b}")

suite "RPC Errors":
  test "Malformed json":
    expect ValueError:
      let
        malformedJson = "{field: 2, \"field: 3}\n"
        res = waitFor client.rawCall("rpc", malformedJson)
  test "Missing RPC":
    #expect: 
    let res = waitFor client.call("phantomRpc", %[])
    echo ">>", res
