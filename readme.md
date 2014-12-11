
What is this
===============================

ported smlnjlib for SML#


Environment
===============================

- SML#2.0.0
- port from SML/NJ 110.77


Attention
===============================

* functors take derived form signature, are bit modified and published to take a wrapper structure.
  This came from limitations of SML# .

* Using HashTableFn.mkTable function (defined in Util/hash-table-fn.sml) would occurs an error in SML#2.0.0 .
  This is reported as issue#28 in the semi-official SML# repository.


