module Gen(dfsGen, addRandomEdges) where

import System.Random.Shuffle (shuffleM)
import Control.Monad (foldM)
import Data.List (sort)
import Debug.Trace (traceShow)


import Maze
import MazeSolver

neighbors :: Cell -> Int -> Int -> [Cell]
neighbors (x, y) height width = filter (\(i, j) -> (i >= 0 && i < height && j >= 0 && j < width)) [(x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)]

addDirectedEdge :: GraphList -> Cell -> Cell -> GraphList
addDirectedEdge ((v, v_neigh):graph) x y| x == v     = ((v, (y:v_neigh)):graph) 
                                              | otherwise  = ((v, v_neigh):(addDirectedEdge graph x y)) 

addEdge :: GraphList -> Cell -> Cell -> GraphList
addEdge graph x y = addDirectedEdge (addDirectedEdge graph x y) y x

addEdges :: GraphList -> [(Cell, Cell)] -> GraphList
addEdges g [] = g
addEdges g ((x, y):rest) = addEdges (addEdge g x y) rest

emptyGrid :: Int -> Int -> GraphList
emptyGrid height width = [((x, y), []) | x <- [0.. height - 1], y <- [0.. width - 1]]

dfsGen :: Int -> Int -> Float -> Float -> IO Graph
dfsGen height width difficulty sparsity = do
    (g, _) <- dfs (emptyGrid height width) [] (-1, -1) (0, 0)
    let difficulty_int = floor (difficulty * (fromIntegral (width * width - 1)))
    let edges_to_add = floor (sparsity * (fromIntegral ((height * width) - height - width + 1)))
    graph <- addRandomEdges g height width edges_to_add
    let (start, finish) = chooseStartAndFinish graph height width difficulty_int
    return (Graph height width graph start finish)            
            where
                dfs :: GraphList -> [Cell] -> Cell -> Cell -> IO (GraphList, [Cell]) 
                dfs graph visited parent v| v `elem` visited   =  return (graph, visited)
                                            | otherwise          = do
                                                ns <- shuffleM (neighbors v height width)  
                                                foldM(\(gr, vis) n -> dfs (if parent == (-1, -1) then gr else (addEdge gr parent v)) (v:vis) v n) (graph, visited) ns


chooseStartAndFinish :: GraphList -> Int -> Int -> Int -> (Cell, Cell)
chooseStartAndFinish graph height width num = (c1, c2)
  where
    (_, c1, c2) = (sort debuggedPaths) !! num
    cells_up    = [(0, x) | x <- [0..(width - 1)]]
    cells_down  = [(height - 1, x) | x <- [0..(width - 1)]]
    shortestPaths =
      [(dist, x, y) | x <- cells_up, (y, dist) <- (shortestPathsLength graph x cells_down)]
    debuggedPaths = traceShow shortestPaths shortestPaths


addRandomEdges :: GraphList -> Int -> Int -> Int -> IO GraphList
addRandomEdges graph height width number = do   
                        let notEdges = [(x, y) | (x, ns) <- graph, y <- (neighbors x height width), not (y `elem` ns), x < y]
                        edgesShuffled <- shuffleM notEdges
                        let edgesToAdd = take number edgesShuffled
                        return (addEdges graph edgesToAdd)
