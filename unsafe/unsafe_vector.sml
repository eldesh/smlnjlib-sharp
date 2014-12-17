
structure UnsafeVector :> UNSAFE_VECTOR =
struct
  structure Builtin = SMLSharp_Builtin
  structure A = Builtin.Array
  structure V = Builtin.Vector
  val sub = V.sub
  fun create (n, xs) =
  let
    val arr = A.alloc_unsafe n
    val i = ref 0
  in
    while !i < n do (
      A.update_unsafe (arr, !i, List.nth(xs, !i));
      i := !i + 1
    );
    A.turnIntoVector arr
  end
end

