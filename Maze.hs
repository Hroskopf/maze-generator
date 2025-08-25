module Maze (Cell, Graph(..), GraphList, dfsGen) where

type Cell = (Int, Int)
type GraphList = [(Cell, [Cell])]
data Graph = Graph Int Int GraphList

cellToInt :: Cell -> Int -> Int
cellToInt (x, y) width = x * width + y

intToCell :: Int -> Int -> Cell
intToCell idx width = (idx `div` width, idx `mod` width)

neighbours :: Cell -> Int -> Int -> [Cell]
neighbours (x, y) height width = filter (\(i, j) -> (i >= 0 && i < height && j >= 0 && j < width)) [(x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)]

addDirectedEdge :: GraphList -> Cell -> Cell -> GraphList
addDirectedEdge ((v, v_neigh):graph) x y| x == v     = ((v, (y:v_neigh)):graph) 
                                              | otherwise  = ((v, v_neigh):(addDirectedEdge graph x y)) 

addEdge :: GraphList -> Cell -> Cell -> GraphList
addEdge graph x y = addDirectedEdge (addDirectedEdge graph x y) y x


dfsGen :: Int -> Int -> Graph
dfsGen height width = (Graph height width (fst (dfs (emptyGrid height width) [] (-1, -1) (0, 0))))
            where dfs graph visited parent v| v `elem` visited   =  (graph, visited)
                                            | parent == (-1, -1) = (foldl (\(gr, vis) n -> dfs gr (v:vis) v n) (graph, visited) (neighbours v height width))
                                            | otherwise          = (foldl (\(gr, vis) n -> dfs (addEdge gr parent v) (v:vis) v n) (graph, visited) (neighbours v height width))

emptyGrid :: Int -> Int -> GraphList
emptyGrid height width = [((x, y), []) | x <- [0.. height - 1], y <- [0.. width - 1]]
