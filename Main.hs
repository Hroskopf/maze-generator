module Main where

import Output
import Maze
import MazeSolver
import Gen

main :: IO ()
main = do
    putStrLn "Enter height of the maze:"
    input <- getLine
    let height = read input :: Int
    putStrLn "Enter width of the maze:"
    input <- getLine
    let width = read input :: Int
    putStrLn "Enter the difficulty in [0, 1]:"
    input <- getLine
    let difficulty = read input :: Float
    graph <- (dfsGen height width difficulty)
    let (Graph _ _ gr start finish) = graph
    putStrLn $ asString (graphToGrid graph)
    putStrLn "Do you want to see the solution (y/n)?"
    input <- getLine
    if input == "y" then do 
        putStrLn ("The length of the solution = " ++ (show (length (shortestPath gr start finish))))
        putStrLn $ asString (graphToGridWithSolution graph) 
    else return ()