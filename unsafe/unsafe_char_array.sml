
structure UnsafeCharArray
:> UNSAFE_MONO_ARRAY
   where type elem = char
=
struct
  structure A = SMLSharp_Builtin.Array
  type array = char array
  type elem  = char
  val sub    = A.sub_unsafe
  val update = A.update_unsafe
  val create = A.alloc_unsafe
end

