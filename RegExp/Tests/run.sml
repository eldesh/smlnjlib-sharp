
structure Main =
struct
  fun main (name,args) =
    app (fn f=> f())
      [ ThompsonRE.doTests
      , DfaRE.doTests
      , BackTrackRE.doTests
      ]
end
val _ = Main.main(CommandLine.name(), CommandLine.arguments())

