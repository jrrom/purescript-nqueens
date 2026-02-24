module Main where

import Prelude

import Data.Array as Array
import Data.List (List(..))
import Data.NQueens (Board, nQueensNaive, boardSize, boardQueens)
import Data.NQueens.Internal (isQueen)
import Effect (Effect)
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Halogen.VDom.Driver (runUI)

main :: Effect Unit
main = HA.runHalogenAff do
  body <- HA.awaitBody
  runUI component unit body

type State = 
  { size :: Int
  , solutions :: List Board
  , hasGenerated :: Boolean
  }

data Action = Increment | Decrement | Generate

component :: forall query input output m. H.Component query input output m
component =
  H.mkComponent
  { initialState
  , render
  , eval: H.mkEval $ H.defaultEval { handleAction = handleAction }
  }
  where
  initialState _ = { size: 4, solutions: Nil, hasGenerated: false }

  render state =
    HH.main_
    [ HH.h1_ [ HH.text "jrrom's N-Queens Demo" ]
    , HH.hr_
    , HH.div
      [ HP.style "padding: 12px 0;" ]
      [ HH.button [ HE.onClick \_ -> Decrement ] [ HH.text "-" ]
      , HH.span_ [ HH.text $ " Board Size: " <> show state.size <> " " ]
      , HH.button [ HE.onClick \_ -> Increment ] [ HH.text "+" ]
      , HH.button [ HE.onClick \_ -> Generate ] [ HH.text "Generate" ]
      ]
    , HH.hr_
    , renderSolutions state
    , HH.br_
    ]
    
  handleAction = case _ of
    Increment -> H.modify_ \st -> st { size = st.size + 1, hasGenerated = false }
    Decrement -> H.modify_ \st -> st { size = if st.size > 1 then st.size - 1 else 1, hasGenerated = false }
    Generate  -> H.modify_ \st -> st { solutions = nQueensNaive st.size, hasGenerated = true }

  renderSolutions state =
    if not state.hasGenerated then
      HH.div_ [ HH.text "Press Generate to see solutions for this board size." ]
    else case state.solutions of
      Nil -> HH.div_ [ HH.text $ "No solutions found for a board of size " <> show state.size ]
      sols -> 
        let 
          solArray = Array.fromFoldable sols
        in
         HH.div_
         [ HH.h3_ [ HH.text $ "Found " <> show (Array.length solArray) <> " solution(s):" ]
         , HH.br_
         , HH.div 
           [ HP.style "display: flex; flex-wrap: wrap; gap: 20px;" ] 
           (map renderBoard solArray)
         ]

  renderBoard board =
    let
      n = boardSize board
      qs = boardQueens board
      
      renderCell r c =
        HH.td 
        [ HP.style "width: 30px; height: 30px; text-align: center; border: 1px solid black; font-size: 20px;" ]
        [ HH.text (if isQueen r c qs then "♛" else "") ]

      renderRow r =
        HH.tr_ (map (renderCell r) (Array.range 0 (n - 1)))
    in
     HH.table 
     [ HP.style "border-collapse: collapse; background-color: #f0f0f0; border: 2px solid black;" ] 
     [ HH.tbody_ (map renderRow (Array.range 0 (n - 1))) ]
