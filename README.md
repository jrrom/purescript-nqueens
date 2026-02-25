# purescript-nqueens

PureScript package to calculate the [N-Queens](https://en.wikipedia.org/wiki/Eight_queens_puzzle) problem. Currently only supports the naive backtracking implementation. 

🔎 Please check out my post about this: [Solving N-Queens with PureScript!](https://jrrom.com/posts/2026-02-25-nqueens.html)

Official Pursuit documentation: <https://pursuit.purescript.org/packages/purescript-nqueens>

## Project Structure

The library itself is in `src`, the live demo is hosted on GitHub pages at <https://jrrom.github.io/purescript-nqueens>, the code for which is in `demo`.

Note: I would like to credit [Classless.css](https://classless.de/) for the stylesheet.

## Reason for development

I created this package to learn about functional backtracking algorithms for an assignment. It allows users an easy way to calculate N-Queens. It is intended for general use in programs, given that the value of n is small. It works great in the REPL thanks to the custom implementation of the `Show` instance.

## Install instructions

```bash
spago install nqueens
```

## Usage

purescript-nqueens exports `nQueensNaive, boardSize, boardQueens` and the `Board` type. A `Board` represents `{ size :: Int, queens :: List Position }` where size is the `n` in `n x n` and queens is a `List` of `Position :: { row :: Int, col :: Int }`.

```purescript
module Main where

import Prelude

import Data.Foldable (traverse_)
import Data.List (length, List(..), (:))
import Data.NQueens (nQueensNaive, boardSize, boardQueens)
import Effect (Effect)
import Effect.Class.Console (logShow)

main :: Effect Unit
main = do
  let solutions = nQueensNaive 4
  traverse_ (logShow <<< boardQueens) solutions
  case solutions of
    x:_ -> logShow (boardSize x)
    Nil -> pure unit
  logShow solutions
  logShow ("Number of solutions: " <> show (length solutions))
```

Result :-

```
({ col: 2, row: 3 } : { col: 0, row: 2 } : { col: 3, row: 1 } : { col: 1, row: 0 } : Nil)
({ col: 1, row: 3 } : { col: 3, row: 2 } : { col: 0, row: 1 } : { col: 2, row: 0 } : Nil)
4
(
 _  Q  _  _
 _  _  _  Q
 Q  _  _  _
 _  _  Q  _
 :
 _  _  Q  _
 Q  _  _  _
 _  _  _  Q
 _  Q  _  _
 : Nil)
"Number of solutions: 2"
```

## Disclaimer

I made this for a personal assignment of mine. Time complexity is exponential for the naive implementation so performance is poor for any `n > 10`.

## License

MIT License

Copyright (c) 2026 jrrom

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
