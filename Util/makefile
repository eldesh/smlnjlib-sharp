
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
       array-qsort.sml       \
       array2.sml            \
       base64.sml            \
       bit-array.sml         \
       bsearch-fn.sml        \
       char-map.sml          \
       dynamic-array-fn.sml  \
       dynamic-array.sml     \
       fifo.sml              \
       fmt-fields.sml        \
       format-comb.sml       \
       real-format.sml       \
       format.sml            \
       getopt.sml            \
       graph-scc-fn.sml      \
       interval-set-fn.sml   \
       io-util.sml           \
       iterate.sml           \
       keyword-fn.sml        \
       left-priorityq-fn.sml \
       list-format.sml       \
       list-mergesort.sml    \
       list-xprod.sml        \
       mono-array-fn.sml     \
       parser-comb.sml       \
       path-util.sml         \
       plist.sml             \
       prime-sizes.sml       \
       queue.sml             \
       rand.sml              \
       random.sml            \
       real-order-stats.sml  \
       scan.sml              \
       simple-uref.sml       \
       uref.sml              \
       splaytree.sml         \
       splay-set-fn.sml      \
       splay-map-fn.sml      \
	   univariate-stats.sml  \
	   utf8.sml
#      bit-vector.sml
#      time-limit.sml

OBJS = $(SRCS:.sml=.o)

all: unsafe/unsafe.o basis/packword32big.o $(OBJS)

unsafe/unsafe.o:
	make -C ../unsafe

basis/packword32big.o:
	make -C ../basis

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

