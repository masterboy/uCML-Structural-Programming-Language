BISON = bison -d
FLEX = flex
GCC = gcc

TARGET = uc
GEN_SOURCES = parser.tab.c lex.yy.c
GEN_HEADERS = parser.tab.h

RMFILES = $(TARGET) $(GEN_SOURCES) $(GEN_HEADERS)

$(TARGET): parser.tab.c lex.yy.c parser.tab.h
	$(GCC) -o $(TARGET) $(GEN_SOURCES) library.c -lm

parser.tab.c: parser.y
	$(BISON) $<

lex.yy.c: scanner.l
	$(FLEX) $<

clean:
	rm -f $(RMFILES)

cleanw:
	del $(RMFILES)