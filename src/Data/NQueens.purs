module Data.NQueens
       ( module Exports,
         boardSize,
         boardQueens,
         nQueensNaive
       ) where

import Prelude

import Control.MonadPlus (guard)
import Data.List (List(..), concatMap, length, range, singleton, (:))
import Data.NQueens.Internal (Board) as Exports
import Data.NQueens.Internal (Position, Board(..), valid)

-- Board functions

-- | Returns the size `n :: Int` of a `Board`.
-- |
-- | `Board { size: n, queens: _ }`
boardSize :: Board -> Int
boardSize (Board { size: n, queens: _ }) = n

-- | Returns the `qs :: List Position` of queens in a `Board`.
-- |
-- | `Position :: { col :: Int, row :: Int }`
-- |
-- | `Board { size: _, queens : qs }`
-- |
-- | The queens are in descending row order from `n - 1` to `0`.
boardQueens :: Board -> List Position
boardQueens (Board { size: _, queens: qs}) = qs

-- N-Queens --

-- | To solve N-Queens using a naive backtracking approach.
-- |
-- | Given a board size `n`, this function returns all valid solutions as a
-- | `List Board` value.
-- |
-- | `Board { size: n, queens: qs }`
-- |
-- | Use `boardSize` and `boardQueens` to get the respective values.
nQueensNaive :: Int -> List Board
nQueensNaive size =
  let
    next :: Board -> List Board
    next board@(Board { size: n, queens: qs }) = do
      let r = length qs
      col <- range 0 (n - 1)
      let q' = { row: r, col: col }
      guard(valid board q')
      pure(Board { size: n, queens: q' : qs })
      
    go :: Board -> List Board
    go board@(Board { size: n, queens: qs })
      | (length qs) == n = (singleton board)
      | otherwise = concatMap go (next board)
  in
   if size > 0 then go (Board { size: size, queens: Nil })
   else Nil

