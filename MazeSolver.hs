module MazeSolver (shortestPath, shortestPathsLength) where

import Maze

neighbors :: GraphList -> Cell -> [Cell]
neighbors ((v, vs):graph) x| x == v      = vs
                           | otherwise   = neighbors graph x

shortestPath :: GraphList -> Cell -> Cell -> [Cell]
shortestPath graph start finish = bfs graph finish [] [[start]] 
                        where bfs graph finish visited ((v:path):queue) | v == finish       = (v:path)       
                                                                        | v `elem` visited  = bfs graph finish visited queue
                                                                        | otherwise         = bfs graph finish (v:visited) (addToQueue (neighbors graph v) queue (v:path))
                                            where addToQueue :: [Cell] -> [[Cell]] -> [Cell] -> [[Cell]]
                                                  addToQueue [] queue _ = queue
                                                  addToQueue (v:rest) queue path = ((addToQueue rest queue path) ++ [(v:path)])

shortestPathsLength :: GraphList -> Cell -> [Cell] -> [(Cell, Int)]
shortestPathsLength graph start finishes = filterDistances (bfs graph [] [(start, 0)] []) finishes
                where bfs _ _ [] distances = distances
                      bfs graph visited ((v, dist):queue) distances | v `elem` visited  = bfs graph visited queue distances
                                                                    | otherwise         = bfs graph (v:visited) queue' ((v, dist):distances)
                                                                        where queue' = addNeighbors (neighbors graph v) queue (dist + 1) 
                                                                              addNeighbors [] queue _ = queue
                                                                              addNeighbors (v:ns) queue dist = ((addNeighbors ns queue dist) ++ [(v, dist)])
                      filterDistances :: [(Cell, Int)] -> [Cell] -> [(Cell, Int)]
                      filterDistances [] _ = []
                      filterDistances ((v, dist):rest) cells | v `elem` cells = ((v, dist):(filterDistances rest cells))
                                                             | otherwise      = filterDistances rest cells