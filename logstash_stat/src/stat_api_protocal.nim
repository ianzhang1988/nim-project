import json
import std/strformat
import std/tables
import std/options
import strutils

type
    mem* = object
        heap_used_percent*: int
    jvm* = object
        mem*: mem
    cpu* = object
        percent*: int
    process* = object
        open_file_descriptors*: int
        peak_open_file_descriptors*: int
        max_file_descriptors*: int
        cpu*: cpu
    events* = object
        `in`*: Option[int]
        filtered*: Option[int]
        `out`*:  Option[int]
        duration_in_millis*: Option[int]
        queue_push_duration_in_millis*: Option[int]
    plugin* = object
        id*: string
        name*: string
        events*: Option[events]
        current_connections*: Option[int]
        peak_connections*: Option[int]
    plugins = object
        inputs*: seq[plugin]
        filters*: seq[plugin]
        outputs*: seq[plugin]
    pipeline* = object
        events*: events
        plugins*: plugins
    logstashStat* = object
        host*: string
        version*: string
        jvm*: jvm
        process*: process
        events*: events
        pipelines*: Table[string, pipeline]


proc parseStat*(data: string): logstashStat =
    let dataJson = parseJson(data)
    result = to(dataJson, logstashStat)

proc `$`(e: events): string =
    var part: seq[string] = @[]
    part.add(&"in:                              {e.in.get()}")
    part.add(&"filtered:                        {e.filtered.get()}")
    part.add(&"outin:                           {e.out.get()}")
    part.add(&"duration_in_millis:              {e.duration_in_millis.get()}")
    part.add(&"queue_push_duration_in_millis:   {e.queue_push_duration_in_millis.get()}")
    return part.join("\n")

# proc `$`(p: plugin): string =
#     var part: seq[string] = @[]
#     part.add(&"id:                    {p.id}")
#     part.add(&"name:                  {p.name}")
#     #part.add(&"events:                \n{indent($p.events, num=1)}")
#     part.add(&"current_connections:   {p.current_connections.get()}")
#     part.add(&"peak_connections:      {p.peak_connections.get()}")
#     return part.join("\n")

proc indent(data: string, holder="    ", num=0): string =
    let part = data.splitLines()
    var indented_part: seq[string] = @[]
    var pad = ""
    for _ in 0..<num:
        pad &= holder

    for p in part:
        indented_part.add( pad & p )
    
    return indented_part.join("\n")

proc printImportant*(stat: logstashStat) =

    var a = {1: "one", 2: "two"}
    echo typeof(a)

    echo &"host:   {stat.host}"
    echo &"memory: {stat.jvm.mem.heap_used_percent}"
    echo &"cpu:    {stat.process.cpu.percent}"
    echo &"file:   {stat.process.open_file_descriptors}/{stat.process.max_file_descriptors}"
    echo &"events: \n{indent($stat.events, num=1)}"

    for k, p in pairs(stat.pipelines):
        echo &"pipeline: {k}"
        echo &"events:   \n{indent($p.events, num=1)}"
        echo &"plugins.inputs({len(p.plugins.inputs)}):"
        for pl in p.plugins.inputs:
            echo pl
            # echo &"{indent($pl, num=1)}"



when isMainModule:
    block:
        let file = "logstash_stat.json"
        var data: string
        try:
            let f = open(file, fmRead)
            defer: f.close() # 关闭文件
            data = f.readAll()
        except IOError as e:
            echo &"open {file} failed: {e.msg}"
    
        let stat = parseStat(data)
        echo stat
        echo "in: ",stat.events.in
        echo "connection ", stat.pipelines["filebeat"].plugins.inputs[0].name, ": " ,stat.pipelines["filebeat"].plugins.inputs[0].current_connections.get()