#
CC=gcc
LEX=flex

% : %.tab.o %.o
	$(CC) $< $*.o $(LDFLAGS) -o $@

%.tab.c %.tab.h: %.y
	bison -d $<

%.c: %.lex %.tab.h
	$(LEX) -t $< > $@

p: p.y p.lex
