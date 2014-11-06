
structure Array2 (* :> ARRAY2 *) =
struct
local
  structure A = Array
in
  type 'a array = { body : 'a A.array
                  , cols : int
                  }
  type 'a region = {
                     base : 'a array,
                     row : int,
                     col : int,
                     nrows : int option,
                     ncols : int option
                   }
  datatype traversal = RowMajor | ColMajor
  
  fun array (r, c, init) = {body = A.array (r*c, init), cols=c}

  fun assertSize size xs =
    if size = length xs then ()
    else raise Size

  fun appi f xs = (foldl (fn (x,i)=> (f(i,x); i+1)) 0 xs; ()) 

  fun fromList []   = {body=A.fromList [], cols=0}
    | fromList [[]] = {body=A.fromList [], cols=0}
    | fromList (xxs as (ys::yys)) =
    let
      val rows = length xxs
      val cols = length ys
      val () = app (assertSize cols) yys
      val arr as {body,cols} = array (rows, cols, hd ys)
    in
      appi (fn(r,ys)=>
        appi (fn(c,y)=> A.update(body, cols*r + c, y)) ys) xxs;
      arr
    end

  fun for (i,j) f =
    if i < j
    then (f i; for (i+1,j) f)
    else ()

  fun tabulate trv (r, c, f) =
    let
      val () = if r < 0 orelse c < 0 then raise Size
               else ()
      val arr = SMLSharp_Builtin.Array.alloc_unsafe (r * c)
    in
      (case trv
         of RowMajor => for (0, r) (fn i=>
                          for (0, c) (fn j=>
                            Array.update(arr, i*c+j, f(i,j))))
          | ColMajor => for (0, c) (fn j=>
                          for (0, r) (fn i=>
                            Array.update(arr, i*c+j, f(i,j)))));
      {body=arr, cols=c}
    end
  
  fun sub ({body,cols}, i, j) = A.sub (body, i*cols+j)

  fun update ({body,cols}, i, j, a) = A.update (body, i*cols+j, a)

  fun nCols      {body,cols} = cols
  fun nRows      {body,cols} = A.length body div cols
  fun dimensions (arr as {body,cols}) = (cols, nRows arr)
  
  fun row (arr as {body, cols}, i) =
    A.vector (A.tabulate(cols, fn c=> sub(arr,i,c)))

  fun column (arr, j) =
    A.vector (A.tabulate(nRows arr, fn i=> sub(arr,i,j)))

  fun is_valid { base, row, col, nrows, ncols } =
    0 <= row andalso (row + getOpt (nrows,0)) <= nRows base
    andalso
    0 <= col andalso (col + getOpt (ncols,0)) <= nCols base
  
  fun copy { src, dst, dst_row, dst_col } =
    if not (is_valid src) then raise Subscript
    else
      let
        val derived = {base=dst, row=dst_row, col=dst_col,
                         nrows= #nrows src, ncols= #ncols src}
        val () = if not (is_valid derived) then raise Subscript
                 else ()
      in
        if #base src = dst then raise Fail "NotImplemented Array2.copy on same array"
        else
          for (#row src, getOpt(#nrows src, nRows (#base src))) (fn i=>
            for (#col src, getOpt(#ncols src, nCols (#base src))) (fn j=>
                update (dst, dst_row+i, dst_col+j, sub (#base src, i, j))))
      end

  
  fun appi trv f (reg as {base,row,col,nrows,ncols}) =
    if not (is_valid reg) then raise Subscript
    else
      case trv
        of RowMajor =>
             for (row, getOpt(nrows, nRows base)) (fn i=>
                for (col, getOpt(ncols, nCols base)) (fn j=>
                    () before f (i, j, sub(base, i, j))))
         | ColMajor =>
             for (col, getOpt(ncols, nCols base)) (fn j=>
                for (row, getOpt(nrows, nRows base)) (fn i=>
                    () before f (i, j, sub(base, i, j))))

  fun app trv f arr =
    let
      val range = {base=arr,row=0,col=0,nrows=NONE,ncols=NONE}
    in
      appi trv (f o #3) range
    end

  (*
  val foldi : traversal
                -> (int * int * 'a * 'b -> 'b)
                  -> 'b -> 'a region -> 'b
  val fold  : traversal
                -> ('a * 'b -> 'b) -> 'b -> 'a array -> 'b
  val modifyi : traversal
                  -> (int * int * 'a -> 'a)
                    -> 'a region -> unit
  val modify  : traversal -> ('a -> 'a) -> 'a array -> unit
  *)
end (* local *)
end

