module Test.Main where

import Prelude

import Data.List (singleton, (:), List(..), length)
import Data.NQueens (boardQueens, boardSize, nQueensNaive)
import Data.NQueens.Internal (Board(..), canAttack, isQueen, valid)
import Effect (Effect)
import Test.Spec (describe, it, Spec)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.Reporter.Console (consoleReporter)
import Test.Spec.Runner.Node (runSpecAndExitProcess)

main :: Effect Unit
main = runSpecAndExitProcess [consoleReporter] spec

spec :: Spec Unit
spec =  do
  -- =====================
  -- Type Checks
  -- =====================
  describe "type definition tests" do
    -- Board
    describe "board behaviours" do
      it "should display properly" do
        let qs = 
              (
                { row: 1, col: 1 }
              : { row: 2, col: 2 }
              : Nil
              )
        let a = (Board { size: 3, queens: qs})
        (show a) `shouldEqual`
          (
            "\n"
            <> " _  _  _ \n"
            <> " _  Q  _ \n"
            <> " _  _  Q \n"
          )
  -- =====================
  -- Helper functions
  -- =====================
  describe "helper function tests" do
    describe "isQueen" do
      it "checks if queen is at a location" do
        let qs =
              (
                { row: 1, col: 1 }
              : { row: 2, col: 2 }
              : Nil
              )
        (isQueen 1 1 qs) `shouldEqual` true
    -- canAttack
    describe "canAttack" do
      describe "checks if queen can attack a position" do
        it "row check" do
          let a = { row: 2, col: 4 }
          let b = { row: 2, col: 8 }
          (canAttack a b) `shouldEqual` true
        it "col check" do
          let a = { row: 7, col: 2 }
          let b = { row: 3, col: 2 }
          (canAttack a b) `shouldEqual` true
        it "diagonal check" do
          let a = { row: 2, col: 3 }
          let b = { row: 0, col: 1 }
          (canAttack a b) `shouldEqual` true
        it "out of range check" do
          let a = { row: 7, col: 7}
          let b = { row: 3, col: 1}
          (canAttack a b) `shouldEqual` false
    -- valid
    describe "valid" do
      describe "checks if a queen can be placed in a position" do
        let qs = singleton { row: 1, col: 1 }
        let board = (Board { size: 3, queens: qs })
        it "checks diagonally" do
          let a = { row: 2, col: 2 }
          (valid board a) `shouldEqual` false
        it "checks horizontally" do
          let b = { row: 1, col: 3 }
          (valid board b) `shouldEqual` false
        it "checks vertically" do
          let c = { row: 3, col: 1 }
          (valid board c) `shouldEqual` false
        it "it can't attack if out of view" do
          let d = { row: 2, col: 3 }
          (valid board d) `shouldEqual` true
    -- boardSize
    describe "boardSize" do
      describe "it gets the boardSize from a Board" do
        let qs = singleton { row: 1, col: 1 }
        let board = (Board { size: 3, queens: qs})
        it "gets the correct board size" do
          (boardSize board) `shouldEqual` 3
    -- boardQueens
    describe "boardQueens" do
      describe "it gets the List Position of queens from a Board" do
        let qs = singleton { row: 1, col: 1 }
        let board = (Board { size: 3, queens: qs})
        it "gets the correct board size" do
          (boardQueens board) `shouldEqual` (singleton { row: 1, col: 1 })
  -- =====================
  -- nQueens
  -- =====================
  describe "nQueens tests" do
    describe "nQueensNaive" do
      describe "generates nQueens formations" do
        it "works for n = 7" do
          (length (nQueensNaive 7)) `shouldEqual` 40
