(* engines.sml
 *
 * COPYRIGHT (c) 2008 The Fellowship of SML/NJ (http://www.smlnj.org)
 * All rights reserved.
 *)

structure ThompsonRE' = TestFn'(
  struct
    val engineName = "Thompson's engine"
    structure RE = RegExpFn'(
    struct
      structure P = AwkSyntax
      structure E = ThompsonEngine
    end)
  end)

structure DfaRE' = TestFn'(
  struct
    val engineName = "DFA engine"
    structure RE = RegExpFn'(
    struct
      structure P = AwkSyntax
      structure E = DfaEngine
    end)
  end)

structure BackTrackRE' = TestFn'(
  struct
    val engineName = "Back-tracking engine"
    structure RE = RegExpFn'(
    struct
      structure P = AwkSyntax
      structure E = BackTrackEngine
    end)
  end)

