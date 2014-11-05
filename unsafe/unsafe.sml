
structure Unsafe =
struct
  (*
  structure Vector      = UnsafeVector
  structure Array       = UnsafeArray
  *)
  structure CharVector  = UnsafeCharVector
  structure CharArray   = UnsafeCharArray
  structure Word8Vector = UnsafeWord8Vector
  (*
  structure Word8Array  = UnsafeWord8Array
  structure Real64Array = UnsafeReal64Array
  *)
end

