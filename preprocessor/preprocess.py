#!/usr/bin/python

import sys
import json
import argparse

import sound
import source
from code import CodeException

def preprocessJSON(content):
    data = json.loads(content)
    handlers = {"sound": sound.produceCode}
    if not data["type"] in handlers: 
        raise Exception("Cannot preprocess type '%s', supported handlers are: %s" % 
                (data["type"], handlers.keys()))
    handler = handlers[data["type"]]
    return handler(data)


parser = argparse.ArgumentParser(description="Precompile JSON files into asm")
parser.add_argument("-o", action="store", dest="<file>", type=str, help="Place the output into <file>")
parser.add_argument("input file")
parser.add_argument("--src", help="Preprocess a source file", action="store_true")

args = vars(parser.parse_args())

if not args["<file>"]:
    print "Error: Output file not supplied"
    exit(1)


with open(args["input file"], "r") as f:
    content = f.read()
    try:
        if args["src"]:
            output = source.preprocess(content)
        else:
            output = preprocessJSON(content)
    except CodeException as e:
        e.fileName = args["input file"]
        print str(e)
        exit(-1)

    with open(args["<file>"], "w") as f:
        f.write(output)
