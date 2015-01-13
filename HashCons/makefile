
SMLSHARP = smlsharp

VPATH = .:..
INCDIR = $(patsubst %,-I%,$(subst :, ,$(VPATH)))
SMLSHARPFLAGS = $(INCDIR)

SRCS := hash-cons.sml \
		hash-cons-ground-fn.sml \
		hash-cons-atom.sml \
		hash-cons-map.sml \
		hash-cons-set.sml \
		hash-cons-string.sml

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


