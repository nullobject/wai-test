# WAI Test

This Haskell program tests HTTP server-sent events using the [WAI
EventSource](http://hackage.haskell.org/package/wai-eventsource) library.

    > cabal sandbox init
    > cabal install --only-dependencies
    > cabal configure
    > cabal run
