
SMLSHARP = smlsharp

VPATH = .:..:FrontEnd:BackEnd:Glue
INCDIR = $(patsubst %,-I%,$(subst :, ,$(VPATH)))
SMLSHARPFLAGS = $(INCDIR)

SRCS := FrontEnd/syntax.sml    \
		Glue/match-tree.sml    \
		BackEnd/bt-engine.sml  \
		BackEnd/fsm.sml        \
		BackEnd/dfa-engine.sml \
		BackEnd/thompson-engine.sml \
		FrontEnd/awk-syntax.sml \
		Glue/regexp-fn.sml

OBJS = $(SRCS:.sml=.o)

all: $(OBJS)

## .o type rules
%.o: %.sml
	$(SMLSHARP) $(SMLSHARPFLAGS) -c $<

## generate for SML dependence
%.d: %.sml
	@echo "  GEN [$@]"
	@$(SHELL) -ec '$(SMLSHARP) -MM $(SMLSHARPFLAGS) $< \
		| sed "s|\($*\)\.o[ :]*|\1.o $@ : |g" > $@; \
		[ -s $@ ] || rm -rf $@'

ifeq (,$(findstring $(MAKECMDGOALS),clean))
-include $(filter %.d,$(SRCS:.sml=.d))
endif

.PHONY: clean
clean:
	rm -rf $(OBJS)
	rm -rf $(filter %.d,$(SRCS:.sml=.d))
	make -C Tests/ clean

.PHONY: test
test: $(OBJS)
	make -C Tests/

