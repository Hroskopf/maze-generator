module Main where

import Output
import Maze
import MazeSolver

main :: IO ()
main = do
    putStrLn "Enter height of the maze:"
    input <- getLine
    let height = read input :: Int
    putStrLn "Enter width of the maze:"
    input <- getLine
    let width = read input :: Int
    putStrLn $ asString (graphToGrid (dfsGen height width))
    putStrLn "Do you want to see the solution (y/n)?"
    input <- getLine
    if input == "y" then putStrLn $ asString (graphToGridWithSolution (dfsGen height width)) else return ()