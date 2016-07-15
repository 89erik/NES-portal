ROOT_DIR = ""
MEMORY_SEGMENT = "\"ZERO_PAGE\""

def legalVariableName(name):
    if " " in name: raise Exception("Illegal variable name: '%s'" % name)

class CodeException(Exception):
    def __str__(self):
        return "%s:%d: error: %s" % (self.fileName, self.lineNumber, self.message)

class Code(object):
    def __init__(self, name):
        self.name = name
        self.variables = []
        self.code = ""
        self.includes = []
        self.exports = []
        self.imports = []
        self.indentation = 0

    def append(self, line, extraIndent=0):
        self.code += ("    " * (self.indentation+extraIndent)) + line + "\n"

    def defineVariable(self, variable):
        legalVariableName(variable)
        self.variables.append(variable)

    def includeDependency(self, dependency):
        self.includes.append(dependency)

    def exportFunction(self, function):
        self.exports.append(function)

    def importFunction(self, function):
        self.imports.append(function)

    def indent(self):
        self.indentation += 1

    def unindent(self):
        self.indentation -= 1

    def variableInitializer(self):
        return "%sInitVariables" % self.name

    def __str__(self):
        s = ""
        for function in self.exports:
            s += ".export %s\n" % function
        for function in self.imports:
            s += ".import %s\n" % function
        if self.variables:
            s += ".export %s\n" % self.variableInitializer()
            s += ".segment %s\n" % MEMORY_SEGMENT
            for var in self.variables:
                s += "    %s: .word 0\n" % var

        s += "\n.segment \"CODE\"\n\n"
        for include in self.includes:
            s += ".include \"%s%s\"\n" % (ROOT_DIR, include)
        if self.variables:
            s += "%s:\n" % self.variableInitializer()
            s += "    LDA #0\n"
            for var in self.variables:
                s += "    STA %s\n" % var
            s += "    RTS\n"

        s += "\n" + self.code
        return s

