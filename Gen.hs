module Gen(dfsGen) where

import System.Random.Shuffle (shuffleM)
import Control.Monad (foldM)
import Data.List (sort)

import Maze
import MazeSolver

neighbors :: Cell -> Int -> Int -> [Cell]
neighbors (x, y) height width = filter (\(i, j) -> (i >= 0 && i < height && j >= 0 && j < width)) [(x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)]

addDirectedEdge :: GraphList -> Cell -> Cell -> GraphList
addDirectedEdge ((v, v_neigh):graph) x y| x == v     = ((v, (y:v_neigh)):graph) 
                                              | otherwise  = ((v, v_neigh):(addDirectedEdge graph x y)) 

addEdge :: GraphList -> Cell -> Cell -> GraphList
addEdge graph x y = addDirectedEdge (addDirectedEdge graph x y) y x



dfsGen :: Int -> Int -> Float -> IO Graph
dfsGen height width difficulty = do
    (g, _) <- dfs (emptyGrid height width) [] (-1, -1) (0, 0)
    let difficulty_int = floor (difficulty * (fromIntegral (width * width - 1)))
    let (start, finish) = chooseStartAndFinish g height width difficulty_int
    return (Graph height width g start finish)            
            where
                dfs :: GraphList -> [Cell] -> Cell -> Cell -> IO (GraphList, [Cell]) 
                dfs graph visited parent v| v `elem` visited   =  return (graph, visited)
                                            | otherwise          = do
                                                ns <- shuffleM (neighbors v height width)  
                                                foldM(\(gr, vis) n -> dfs (if parent == (-1, -1) then gr else (addEdge gr parent v)) (v:vis) v n) (graph, visited) ns


emptyGrid :: Int -> Int -> GraphList
emptyGrid height width = [((x, y), []) | x <- [0.. height - 1], y <- [0.. width - 1]]

chooseStartAndFinish :: GraphList -> Int -> Int -> Int -> (Cell, Cell)
chooseStartAndFinish graph height width num = (c1, c2) where
                (_, c1, c2) = (sort shortestPaths) !! num 
                    where cells_up = [(0, x) | x <- [0..(width - 1)]]
                          cells_down   = [(height - 1, x) | x <- [0..(width - 1)]]
                          shortestPaths = [(dist, x, y) | x <- cells_up, (y, dist) <- (shortestPathsLength graph x cells_down)]
                          