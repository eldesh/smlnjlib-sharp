
structure Array2 :> ARRAY2 =
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
  
  fun array (r, c, init) =
    if r < 0 orelse c < 0 then raise Size
    else {body = A.array (r*c, init), cols=c}

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

  fun for' (i,j) next f =
    if i=j then ()
    else
      (f i; for' (next i,j) next f)
  
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
  
  fun nCols      {body,cols} = cols
  fun nRows      {body,cols} = A.length body div cols
  fun dimensions (arr as {body,cols}) = (cols, nRows arr)
  
  fun sub (arr as {body,cols}, i, j) =
    if i<0 orelse j<0 orelse nRows arr<=i orelse nCols arr<=j
    then raise Subscript
    else A.sub (body, i*cols+j)

  fun update (arr as {body,cols}, i, j, a) =
    if i<0 orelse j<0 orelse nRows arr<=i orelse nCols arr<=j
    then raise Subscript
    else A.update (body, i*cols+j, a)

  fun row (arr as {body, cols}, i) =
    if nRows arr <= i orelse i < 0 then raise Subscript
    else A.vector (A.tabulate(cols, fn c=> sub(arr,i,c)))

  fun column (arr, j) =
    if nCols arr <= j orelse j < 0 then raise Subscript
    else A.vector (A.tabulate(nRows arr, fn i=> sub(arr,i,j)))

  fun is_valid {base, row, col, nrows, ncols} =
    0 <= getOpt(nrows,0) andalso
    0 <= getOpt(ncols,0) andalso 
    0 <= row andalso (row + getOpt (nrows,0)) <= nRows base
    andalso
    0 <= col andalso (col + getOpt (ncols,0)) <= nCols base

  fun maybe x  NONE    _ = x
    | maybe _ (SOME x) f = f x

  fun reg_rows {base,row,nrows,...} =
    maybe (nRows base - row) nrows (fn r=>r)

  fun reg_cols {base,col,ncols,...} =
    maybe (nCols base - col) ncols (fn c=>c)

  fun copy {src, dst, dst_row, dst_col} =
    let
      val () = if not (is_valid src) then raise Subscript else ()
      val derived = {base=dst, row=dst_row, col=dst_col,
                       nrows= SOME(reg_rows src), ncols= SOME(reg_cols src)}
      val () = if not (is_valid derived) then raise Subscript else ()

      val for_row =
        if #base src = dst andalso
          (#row src <= dst_row andalso dst_row <= #row src + reg_rows src)
        then for' (reg_rows src-1,~1) (fn n=> n-1) (* bottom shifted & overlapped *)
        else for (0, reg_rows src)

      val for_col =
        if #base src = dst andalso
          (#col src <= dst_col andalso dst_col <= #col src + reg_cols src)
        then for' (reg_cols src-1,~1) (fn n=> n-1) (* right shifted & overlapped *)
        else for (0, reg_cols src)
    in
      for_row (fn i=>
        for_col (fn j=>
            update(dst, dst_row+i, dst_col+j
                    , sub(#base src, #row src+i, #col src+j))))
    end
  
  fun appi trv f (reg as {base,row,col,nrows,ncols}) =
    if not (is_valid reg) then raise Subscript
    else
      case trv
        of RowMajor =>
             for (row, row+reg_rows reg) (fn i=>
                for (col, col+reg_cols reg) (fn j=>
                    f (i, j, sub(base, i, j))))
         | ColMajor =>
             for (col, col+reg_cols reg) (fn j=>
                for (row, row+reg_rows reg) (fn i=>
                    f (i, j, sub(base, i, j))))

  fun fullregion arr =
        {base=arr, row=0, col=0, nrows=NONE, ncols=NONE}

  fun app trv f arr =
      appi trv (f o #3) (fullregion arr)

  fun foldl_n (b,e) f acc =
    if b = e then acc
    else
      foldl_n (b+1,e) f (f(b,acc))

  fun foldi tr f init (reg as {base,row,col,nrows,ncols}) =
    if not (is_valid reg) then raise Subscript
    else
      case tr
        of RowMajor =>
            foldl_n (row, row+reg_rows reg) (fn (i,racc)=>
              foldl_n (col, col+reg_cols reg) (fn (j,cacc)=>
                f (i,j,sub(base,i,j),cacc)) racc) init
         | ColMajor =>
            foldl_n (col, col+reg_cols reg) (fn (j,cacc)=>
              foldl_n (row, row+reg_rows reg) (fn (i,racc)=>
                f (i,j,sub(base,i,j),racc)) cacc) init

  fun fold tr f init arr =
    foldi tr (fn(_,_,a,b)=> f(a,b)) init (fullregion arr)

  fun modifyi tr f (reg as {base,row,col,nrows,ncols}) =
    if not (is_valid reg) then raise Subscript
    else
      case tr
        of RowMajor =>
            for (row, row+reg_rows reg) (fn i =>
              for (col, col+reg_cols reg) (fn j =>
                update (base,i,j,f(i,j,sub(base,i,j)))))
         | ColMajor =>
            for (col, col+reg_cols reg) (fn j =>
              for (row, row+reg_rows reg) (fn i =>
                update (base,i,j,f(i,j,sub(base,i,j)))))

  fun modify tr f arr =
    modifyi tr (fn(_,_,x)=> f x) (fullregion arr)

end (* local *)
end

