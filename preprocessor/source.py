import re
from code import CodeException

def intToBin8(num):
    if num < -127 or num > 0xFF:
        raise CodeException("value %d cannot be represented in 8 bits" % num)
    if num >= 0: 
        return str(num)
    decval = 0xFF + num
    return "$" + hex(decval)[2:]

def convertNegativeNumber(match):
    num = int(match.group(0)[1:])
    return "#" + intToBin8(num)


negativeNumber = re.compile("#-?[0-9]+")
def preprocessLine(line):
    if ";" in line:
        line = line[:line.find(";")]
    return re.sub(negativeNumber, convertNegativeNumber, line)

def preprocess(content):
    output = ""
    content = content.split("\n")
    for lineNumber, line in enumerate(content):
        try:
            output += preprocessLine(line) + "\n"
        except CodeException as e:
            e.lineNumber = lineNumber
            raise e
    return output

