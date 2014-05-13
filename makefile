PROGRAM := wUnit.js
TABLEDIR := bin/waketable
OBJECTDIR := bin/wakeobj
SRCDIR := src
SOURCEFILES := $(wildcard $(SRCDIR)/*.wk)
DEPFILES := ${SOURCEFILES:.wk=.d}
OBJECTFILES := $(subst $(SRCDIR),$(OBJECTDIR),${SOURCEFILES:.wk=.o})
TABLEFILES := $(subst $(SRCDIR),$(TABLEDIR),${SOURCEFILES:.wk=.table})
LIBRARYFILES := bin/wakeobj/std.o
TESTLIBRARYFILES := bin/wakeobj/TestResultReporter.o bin/wakeobj/Asserts.o

bin/$(PROGRAM): $(OBJECTFILES) $(TABLEFILES) $(LIBRARYFILES) tests
	wake -l -d $(TABLEDIR) -o bin/$(PROGRAM) $(OBJECTFILES) $(LIBRARYFILES)

.PHONY:
tests: bin/$(PROGRAM)-test
	node bin/$(PROGRAM)-test

bin/$(PROGRAM)-test: $(OBJECTFILES) $(TESTLIBRARYFILES) $(LIBRARYFILES) $(TABLEFILES)
	node bin/wUnit.js
	wake bin/TestSuite.wk -d $(TABLEDIR) -o bin/TestSuite.o
	wake -l -d $(TABLEDIR) $(OBJECTFILES) $(TESTLIBRARYFILES) $(LIBRARYFILES) bin/TestSuite.o -o bin/$(PROGRAM)-test -c TestSuite -m 'tests()'

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
