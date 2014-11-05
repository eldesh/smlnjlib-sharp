
structure UnsafeArray :> UNSAFE_ARRAY =
struct
  structure Int = SMLSharp_Builtin.Int
  structure A = SMLSharp_Builtin.Array
  val sub = A.sub_unsafe
  val update = A.update_unsafe
  fun create (n,v) = let
    val arr = A.alloc_unsafe n
    fun fill 0 = ()
      | fill n = (update(arr,n,v);
                  fill (Int.sub_unsafe(n,1)))
  in
    fill n;
    arr
  end
end

