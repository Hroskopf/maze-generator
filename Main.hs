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
    graph <- (dfsGen height width)
    putStrLn $ asString (graphToGrid graph)
    putStrLn "Do you want to see the solution (y/n)?"
    input <- getLine
    if input == "y" then putStrLn $ asString (graphToGridWithSolution graph) else return ()