
What is this
===============================

ported smlnjlib for [SML#][1]


Environment
===============================

- SML#2.0.0
- port from SML/NJ 110.77


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


