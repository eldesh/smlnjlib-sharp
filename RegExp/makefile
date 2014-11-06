
SMLSHARP = smlsharp

VPATH = .:..:FrontEnd:BackEnd:Glue
INCDIR = $(patsubst %,-I%,$(subst :, ,$(VPATH)))
SMLSHARPFLAGS = $(INCDIR)

SRCS := FrontEnd/syntax.sml \
		Glue/match-tree.sml

OBJS = $(SRCS:.sml=.o)

all: $(OBJS)

## .o type rules
%.o: %.sml
	$(SMLSHARP) $(SMLSHARPFLAGS) -c $<

## generate for SML dependence
%.d: %.sml
	@echo "generate [$@] from [$*]"
	@$(SHELL) -ec '$(SMLSHARP) -MM $(SMLSHARPFLAGS) $< \
		| sed "s|\($*\)\.o[ :]*|\1.o $@ : |g" > $@; \
		[ -s $@ ] || rm -rf $@'

-include $(filter %.d,$(SRCS:.sml=.d))

.PHONY: clean
clean:
	rm -rf $(OBJS)
	rm -rf $(filter %.d,$(SRCS:.sml=.d))
