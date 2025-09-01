module MazeSolver (shortestPath) where

import Maze

neighbors :: GraphList -> Cell -> [Cell]
neighbors ((v, vs):graph) x| x == v      = vs
                            | otherwise   = neighbors graph x

addToQueue :: [Cell] -> [[Cell]] -> [Cell] -> [[Cell]]
addToQueue [] queue _ = queue
addToQueue (v:rest) queue path = ((addToQueue rest queue path) ++ [(v:path)])



shortestPath :: GraphList -> Cell -> Cell -> [Cell]
shortestPath graph start finish = bfs graph finish [] [[start]] 
                        where bfs graph finish visited ((v:path):queue) | v == finish       = (v:path)       
                                                                        | v `elem` visited  = bfs graph finish visited queue
                                                                        | otherwise         = bfs graph finish (v:visited) (addToQueue (neighbors graph v) queue (v:path))