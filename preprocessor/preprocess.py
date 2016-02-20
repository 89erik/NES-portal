#!/usr/bin/python

import sys
import json
import argparse

import sound

parser = argparse.ArgumentParser(description="Precompile JSON files into asm")
parser.add_argument("-o", action="store", dest="<file>", type=str, help="Place the output into <file>")
parser.add_argument("input file")

args = vars(parser.parse_args())

if not args["<file>"]:
    print "Error: Output file not supplied"
    exit(1)

handlers = {"sound": sound.produceCode}

with open(args["input file"], "r") as f:
    content = f.read()
    data = json.loads(content)

if not data["type"] in handlers: 
    raise Exception("Cannot preprocess type '%s', supported handlers are: %s" % 
            (data["type"], handlers.keys()))
handler = handlers[data["type"]]

with open(args["<file>"], "w") as f:
    f.write(handler(data))

