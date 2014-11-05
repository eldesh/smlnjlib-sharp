
SMLSHARP = smlsharp

VPATH = .:..
INCDIR = $(patsubst %,-I%,$(subst :, ,$(VPATH)))
SMLSHARPFLAGS = $(INCDIR)

SRCS = lib-base.sml          \
       hash-string.sml       \
       atom.sml              \
       redblack-set-fn.sml   \
       redblack-map-fn.sml   \
       atom-redblack-set.sml \
       atom-redblack-map.sml \
       atom-set.sml \
       atom-map.sml \
       int-redblack-set.sml  \
       int-redblack-map.sml  \
       word-redblack-set.sml \
       word-redblack-map.sml \
       list-set-fn.sml       \
       list-map-fn.sml       \
       int-list-set.sml      \
       int-list-map.sml      \
       hash-table-rep.sml    \
       hash-set-fn.sml       \
       hash-table-fn.sml     \
       hash2-table-fn.sml    \
       hash-table.sml        \
       int-hash-table.sml    \
       word-hash-table.sml   \
       atom-table.sml        \
       binary-set-fn.sml     \
       binary-map-fn.sml     \
       atom-binary-map.sml   \
       atom-binary-set.sml   \
       int-binary-map.sml    \
       int-binary-set.sml    \
       array-qsort-fn.sml    \
       array2.sml            \
       base64.sml            \
       bit-array.sml         \
       bsearch-fn.sml        \
       char-map.sml

OBJS = $(SRCS:.sml=.o)

all: unsafe/unsafe.o $(OBJS)

unsafe/unsafe.o:
	make -C ../unsafe

## .o type rules
%.o: %.sml
	$(SMLSHARP) $(SMLSHARPFLAGS) -c $<

## generate for SML dependence
%.d: %.sml
	@echo "generate [$@] from [$*]"
	@$(SHELL) -ec '$(SMLSHARP) -MM $(SMLSHARPFLAGS) $< \
		| sed "s/\($*\)\.o[ :]*/\1.o $@ : /g" > $@; \
		[ -s $@ ] || rm -rf $@'

-include $(filter %.d,$(SRCS:.sml=.d))

.PHONY: clean
clean:
	rm -rf $(TARGET)
	rm -rf $(OBJS)
	rm -rf $(filter %.d,$(SRCS:.sml=.d))

