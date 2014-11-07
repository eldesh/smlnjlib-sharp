
signature NFA = 
    sig

	exception SyntaxNotHandled

	structure IntSet : ORD_SET where type Key.ord_key = int

	type nfa

	val build : RegExpSyntax.syntax * int -> nfa
	val buildPattern : RegExpSyntax.syntax list -> nfa
	val start : nfa -> IntSet.set
	val move : nfa -> int * char -> IntSet.set
	val chars : nfa -> int -> char list
	val accepting : nfa -> int -> int option

	val print : nfa -> unit
    end

signature DFA = 
    sig

	exception SyntaxNotHandled
	
	type dfa

	val build : RegExpSyntax.syntax -> dfa
	val buildPattern : RegExpSyntax.syntax list -> dfa
	val move : dfa -> int * char -> int option
	val accepting : dfa -> int -> int option
	val canStart : dfa -> char -> bool

    end


