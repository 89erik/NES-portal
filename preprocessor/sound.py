from code import Code



def checkNoteIndex(code):
    code.append("LDX note_index")
    code.append("BEQ @end_of_note")
    code.indent()
    code.append("DEX")
    code.append("STX note_index")
    code.append("RTS")
    code.unindent()
    code.append("@end_of_note:")

setNoteIndex = """\
    @end_set_note:
        STA note_index
        LDX music_index
        INX
        STX music_index
"""


def produceCode(data):
    code = Code(data["name"])
    code.defineVariable("music_index")
    code.defineVariable("note_index")

    code.includeDependency("macro/sound.asm")
    code.includeDependency("data/constants.inc")
    code.includeDependency("data/sound_constants.inc")

    functionName = "Play%s" % data["name"]
    code.exportFunction(functionName)
    code.append("%s:" % functionName)
    
    code.indent() 

    checkNoteIndex(code)
    code.append("LDA #%00000011; square 1 and 2")
    code.append("STA APU_CTRL")
    code.append("LDA #%10000111")
    code.append("STA $4000")
    code.append("STA $4004")

    code.append("LDA music_index")
    i = 0
    code.indent()
    for note in data["notes"]:
        code.append("SKIP_IF_NOT %d" % i)
        for tone in note["tones"]:
            code.append("SET_SQUARE_NOTE %s, %s, %s" % (tone[0], tone[1], tone[2]))
        code.append("LDA #%s" % note["length"])
        code.append("JMP @end_set_note")
        code.append(":", -1)
        i += 1
    code.unindent()
    code.append("LDA #0")
    code.append("STA music_index")
    code.append("RTS")
    code.append(setNoteIndex)
    code.append("RTS")

    return str(code)


