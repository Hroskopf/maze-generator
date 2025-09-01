module Maze (Cell, Graph(..), GraphList, dfsGen) where

import System.Random.Shuffle (shuffleM)
import Control.Monad (foldM)

type Cell = (Int, Int)
type GraphList = [(Cell, [Cell])]
data Graph = Graph Int Int GraphList Cell Cell 

neighbors :: Cell -> Int -> Int -> [Cell]
neighbors (x, y) height width = filter (\(i, j) -> (i >= 0 && i < height && j >= 0 && j < width)) [(x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)]

addDirectedEdge :: GraphList -> Cell -> Cell -> GraphList
addDirectedEdge ((v, v_neigh):graph) x y| x == v     = ((v, (y:v_neigh)):graph) 
                                              | otherwise  = ((v, v_neigh):(addDirectedEdge graph x y)) 

addEdge :: GraphList -> Cell -> Cell -> GraphList
addEdge graph x y = addDirectedEdge (addDirectedEdge graph x y) y x


dfsGen :: Int -> Int -> IO Graph
dfsGen height width = do
    (g, _) <- dfs (emptyGrid height width) [] (-1, -1) (0, 0)
    return (Graph height width g (0, 0) (height - 1, width - 1))            
            where
                dfs :: GraphList -> [Cell] -> Cell -> Cell -> IO (GraphList, [Cell]) 
                dfs graph visited parent v| v `elem` visited   =  return (graph, visited)
                                            | otherwise          = do
                                                ns <- shuffleM (neighbors v height width)  
                                                foldM(\(gr, vis) n -> dfs (if parent == (-1, -1) then gr else (addEdge gr parent v)) (v:vis) v n) (graph, visited) ns


emptyGrid :: Int -> Int -> GraphList
emptyGrid height width = [((x, y), []) | x <- [0.. height - 1], y <- [0.. width - 1]]
