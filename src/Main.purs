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
