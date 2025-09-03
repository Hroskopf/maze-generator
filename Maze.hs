module Maze (Cell, Graph(..), GraphList) where

type Cell = (Int, Int)
type GraphList = [(Cell, [Cell])]
data Graph = Graph Int Int GraphList Cell Cell 

