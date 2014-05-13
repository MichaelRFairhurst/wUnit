PROGRAM := wUnit.js
TABLEDIR := bin/waketable
OBJECTDIR := bin/wakeobj
SRCDIR := src
SOURCEFILES := $(wildcard $(SRCDIR)/*.wk)
DEPFILES := ${SOURCEFILES:.wk=.d}
OBJECTFILES := $(subst $(SRCDIR),$(OBJECTDIR),${SOURCEFILES:.wk=.o})
TABLEFILES := $(subst $(SRCDIR),$(TABLEDIR),${SOURCEFILES:.wk=.table})
LIBRARYFILES := bin/wakeobj/std.o

bin/$(PROGRAM): $(OBJECTFILES) $(TABLEFILES) $(LIBRARYFILES)
	wake -l -d $(TABLEDIR) -o bin/$(PROGRAM) $(OBJECTFILES) $(LIBRARYFILES)

to-md5 = $1 $(addsuffix .md5,$1)

%.md5: % FORCE
	@$(if $(filter-out $(shell cat $@ 2>/dev/null),$(shell md5sum $*)),md5sum $* > $@)

FORCE:

$(SRCDIR)/%.d: $(SRCDIR)/%.wk
	@./generate-makefile.sh $< $(TABLEDIR) > $@

$(TABLEDIR)/%.table: $(SRCDIR)/%.wk
	wake $< -d $(TABLEDIR) -t

$(OBJECTDIR)/%.o: $(SRCDIR)/%.wk
	wake $< -d $(TABLEDIR) -o $@

ifneq "$(MAKECMDGOALS)" "clean"
-include ${SOURCEFILES:.wk=.d}
endif

clean:
	rm $(TABLEFILES) || :
	rm $(DEPFILES) || :
	rm $(OBJECTFILES) || :
	find . -name '*.md5' -delete
