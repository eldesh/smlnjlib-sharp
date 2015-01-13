
SMLSHARP = smlsharp

VPATH = .
INCDIR = $(patsubst %,-I%,$(subst :, ,$(VPATH)))
SMLSHARPFLAGS = $(INCDIR)

SRCS = packword32big.sml \
	   Array2.sml

OBJS = $(SRCS:.sml=.o)

all: $(OBJS)

## .o type rules
%.o: %.sml
	$(SMLSHARP) $(SMLSHARPFLAGS) -c $<

## generate for SML dependence
%.d: %.sml
	@echo "  GEN [$@]"
	@$(SHELL) -ec '$(SMLSHARP) -MM $(SMLSHARPFLAGS) $< \
		| sed "s/\($*\)\.o[ :]*/\1.o $@ : /g" > $@; \
		[ -s $@ ] || rm -rf $@'

ifeq (,$(findstring $(MAKECMDGOALS),clean))
-include $(filter %.d,$(SRCS:.sml=.d))
endif

.PHONY: clean
clean:
	rm -rf $(OBJS)
	rm -rf $(filter %.d,$(SRCS:.sml=.d))

