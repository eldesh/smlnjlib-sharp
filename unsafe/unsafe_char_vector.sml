
structure UnsafeCharVector
:> UNSAFE_MONO_VECTOR
   where type vector = string
     and type elem   = char
=
struct
  structure S = SMLSharp_Builtin.String
  structure A = SMLSharp_Builtin.Array
  structure V = SMLSharp_Builtin.Vector

  val toVec = A.turnIntoVector
  val toArr = S.castToArray

  type vector = string
  type elem   = char
  val sub     = S.sub
  fun update (v,i,x) = A.update (toArr v, i, x)
  val create = S.alloc_unsafe
end

