
SMLSHARP = smlsharp

VPATH = .:..
INCDIR = $(patsubst %,-I%,$(subst :, ,$(VPATH)))
SMLSHARPFLAGS = $(INCDIR)

SRCS := src/pp-debug-fn.sml \
		src/pp-desc-fn.sml \
		src/pp-stream-fn.sml \
		devices/string-token.sml \
		devices/simple-textio-dev.sml \
		devices/textio-pp.sml \
		devices/ansi-term-dev.sml \
		devices/ansi-term-pp.sml
#    	html-dev.sml

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

