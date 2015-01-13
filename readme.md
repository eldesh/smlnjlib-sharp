
What is this
===============================

Utility library written in StandardML.
Ported *smlnjlib* from SML/NJ 110.77 to [SML#][1].


Environment
===============================

- require SML# (>= 2.0.0)
- checked on Linux (i386)
- ported from [SML/NJ (= 110.77)][3]


Build
===============================


 $ make -C basis
 $ make -C unsafe
 $ make -C Util
 $ make -C RegExp
 $ make -C PP


Attention
===============================

* Using HashTableFn.mkTable function (defined in Util/hash-table-fn.sml) would occurs an error in SML#2.0.0 .
  This is reported as issue#28 in the [semi-official SML# repository][2].


----

[1]: http://www.pllab.riec.tohoku.ac.jp/smlsharp/
[2]: https://github.com/smlsharp/smlsharp
[3]: http://www.smlnj.org/

