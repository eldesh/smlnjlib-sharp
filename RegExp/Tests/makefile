
SMLSHARP = smlsharp

VPATH = .:..:../..
INCDIR = $(patsubst %,-I%,$(subst :, ,$(VPATH)))
SMLSHARPFLAGS = $(INCDIR)

SRCS := test-fn.sml \
        engines-smlsharp.sml \
		run.sml

OBJS = $(SRCS:.sml=.o)
TEST = run

all: $(TEST)

$(TEST): run.smi $(OBJS)
	@echo "compiling test..."
	@$(SMLSHARP) $(SMLSHARPFLAGS) -o run $<
	@echo "run test..."
	./$@

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
	rm -rf $(TEST)
	rm -rf $(OBJS)
	rm -rf $(filter %.d,$(SRCS:.sml=.d))

