
structure UnsafeWord8Vector
:> UNSAFE_MONO_VECTOR
   where type vector = word8 vector
     and type elem   = word8
=
struct
  structure A = SMLSharp_Builtin.Array
  structure V = SMLSharp_Builtin.Vector

  val toVec = A.turnIntoVector
  val toArr = V.castToArray

  type vector = word8 vector
  type elem   = word8
  val sub     = V.sub
  fun update (v,i,x) = A.update (toArr v, i, x)
  val create = fn n => toVec (A.alloc_unsafe n)
end

