module MazeSolver where

import Maze

neighbours :: GraphList -> Cell -> [Cell]
neighbours ((v, vs):graph) x| x == v      = vs
                            | otherwise   = neighbours graph x

addToQueue :: [Cell] -> [[Cell]] -> [Cell] -> [[Cell]]
addToQueue [] queue _ = queue
addToQueue (v:rest) queue path = ((addToQueue rest queue path) ++ [(v:path)])



shortestPath :: GraphList -> Cell -> Cell -> [Cell]
shortestPath graph start finish = bfs graph finish [] [[start]] 
                        where bfs graph finish visited ((v:path):queue) | v == finish       = (v:path)       
                                                                        | v `elem` visited  = bfs graph finish visited queue
                                                                        | otherwise         = bfs graph finish (v:visited) (addToQueue (neighbours graph v) queue (v:path))