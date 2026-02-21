module Data.NQueens.Internal where

import Data.List (List, any, elem)
import Data.Ord (abs)
import Prelude

-- Types

-- | `type Position { row :: Int, col :: Int }
type Position = { row :: Int, col :: Int }

-- | `newtype Board { size :: Int, queens :: List Position }`
newtype Board
  = Board
    { size :: Int
    , queens :: List Position
    }

-- | Will display with leading and ending newline in the form below:
-- |
-- | `
-- | _ Q _ _
-- | _ _ _ Q
-- | Q _ _ _
-- | _ _ Q _
-- | `
instance Show Board where
  show (Board { size: n, queens: qs }) =
    let
      go :: Int -> Int -> String -> String
      go row col acc
        | row == n  = acc
        | col == n  = go (row + 1) 0 (acc <> "\n")
        | isQueen row col qs = go row (col + 1) (acc <> " Q ")
        | otherwise = go row (col + 1) (acc <> " _ ")
    in
     go 0 0 "\n"

-- Helper functions --

-- | Check if the `Position` has a queen.
isQueen :: Int -> Int -> List Position -> Boolean
isQueen r c qs =
  elem { row: r, col: c } qs

-- | Check if the `Position` can be attacked.
canAttack :: Position -> Position -> Boolean
canAttack { row: r1, col: c1 } { row: r2, col: c2} =
  r1 == r2
  || c1 == c2
  || abs (r1 - r2) == abs (c1 - c2)

-- | Check if the `Position` is vaid by comparing against `qs :: List Position`.
valid :: Board -> Position -> Boolean
valid (Board { size: _, queens: qs }) p =
  not $ any (canAttack p) qs
