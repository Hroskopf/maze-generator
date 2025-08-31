module Output () where

import Maze
import MazeSolver

type Grid = [String]

fullGrid :: Int -> Int -> Grid
fullGrid height width = [[ if x `mod` 2 == 0 && y `mod` 2 == 0 then '.' else if x `mod` 2 == 0 then '-' else if y `mod` 2 == 0 then '|' else ' ' | y <- [0.. 2 * width]] | x <- [0.. 2 * height]]

asString :: Grid -> String
asString [row] = row
asString (row:grid) = row ++ "\n" ++ (asString grid)

setCharInString :: String -> Int -> Char -> String
setCharInString (_:row) 0 c = (c:row)
setCharInString (s:row) x c = (s:(setCharInString row (x - 1) c))

setChar :: Grid -> Int -> Int -> Char -> Grid
setChar (row:grid) 0 y c = ((setCharInString row y c):grid)
setChar (row:grid) x y c = (row:(setChar grid (x - 1) y c))

createGraphGrid :: Grid -> GraphList ->  Grid
createGraphGrid grid [] = grid
createGraphGrid grid ((_, []):graph) = createGraphGrid grid graph
createGraphGrid grid (((v, (u:rest))):graph) = if x1 == x2 then 
                                    setChar (createGraphGrid grid  ((v, rest):graph)) (2 * x1 + 1) (2 * (min y1 y2) + 2) ' ' else 
                                    setChar (createGraphGrid grid  ((v, rest):graph)) (2 * (min x1 x2) + 2) (2 * (min y1 y2) + 1) ' '         
                                                        where (x1, y1) = v
                                                              (x2, y2) = u

graphToGrid :: Graph -> Grid
graphToGrid (Graph x y gr _ _) = createGraphGrid (fullGrid x y) gr

graphToGridWithSolution :: Graph -> Grid
graphToGridWithSolution (Graph x y gr start finish) = addPath (createGraphGrid (fullGrid x y) gr) (shortestPath gr start finish)

addPath :: Grid -> [Cell] -> Grid
addPath grid [(x, y)] = setChar grid (2 * x + 1) (2 * y + 1) 'X'
addPath grid ((x1, y1):((x2, y2):rest)) = addPath grid1 ((x2, y2):rest)
                                                    where grid1 = setChar (if x1 == x2 then setChar grid (2 * x1 + 1) (2 * (min y1 y2) + 2) 'X' else setChar grid (2 * (min x1 x2) + 2) (2 * y1 + 1) 'X') (2 * x1 + 1) (2 * y1 + 1) 'X'

instance Show Graph where
    show (Graph height width graph _ _) = (asString grid)
                                    where grid = setChar (setChar (createGraphGrid (fullGrid height width) graph) (2 * height) 1 ' ') 0 (2 * width - 1) ' ' 

