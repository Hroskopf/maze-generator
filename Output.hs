module Output () where

import Maze

type Grid = [String]

fullGrid :: Int -> Int -> Grid
fullGrid height width = [[ if x `mod` 2 == 0 && y `mod` 2 == 0 then '.' else if x `mod` 2 == 0 then '-' else if y `mod` 2 == 0 then '|' else ' ' | y <- [0.. 2 * width]] | x <- [0.. 2 * height]]

asString :: Grid -> String
asString [row] = row
asString (row:grid) = row ++ "\n" ++ (asString grid)

deleteWallFromRow :: String -> Int -> String
deleteWallFromRow (_:row) 0 = (' ':row)
deleteWallFromRow (s:row) x = (s:(deleteWallFromRow row (x - 1)))

deleteWall :: Grid -> Int -> Int -> Grid
deleteWall (row:grid) 0 y = ((deleteWallFromRow row y):grid)
deleteWall (row:grid) x y = (row:(deleteWall grid (x - 1) y))

createGraphGrid :: Grid -> GraphList ->  Grid
createGraphGrid grid [] = grid
createGraphGrid grid ((_, []):graph) = createGraphGrid grid graph
createGraphGrid grid (((v, (u:rest))):graph) = if x1 == x2 then 
                                    deleteWall (createGraphGrid grid  ((v, rest):graph)) (2 * x1 + 1) (2 * (min y1 y2) + 2) else 
                                    deleteWall (createGraphGrid grid  ((v, rest):graph)) (2 * (min x1 x2) + 2) (2 * (min y1 y2) + 1)        
                                                        where (x1, y1) = v
                                                              (x2, y2) = u

instance Show Graph where
    show (Graph height width graph) = (asString grid)
                                    where grid = deleteWall (deleteWall (createGraphGrid (fullGrid height width) graph) (2 * height) 1) 0 (2 * width - 1)