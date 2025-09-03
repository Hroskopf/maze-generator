module Main where

import Output
import Maze
import MazeSolver
import Gen
import Text.Read (readMaybe)

-- Writes given text to a console output and reads a integer value input.
-- If given value is not integer calls itself once again
readInt :: String -> IO Int
readInt text = do
    putStrLn text
    input <- getLine
    let maybeN = readMaybe input :: Maybe Int
    if maybeN == Nothing
        then do
            putStrLn "Invalid input, please enter an integer."
            readInt text
        else do
            let Just n = maybeN
            return n
  
-- Writes given text to a console output and reads a float value in range [0, 1].
-- If given value cannot be parsed to [0, 1] float, calls itself
readFloat :: String -> IO Float
readFloat text = do
    putStrLn text
    input <- getLine
    let maybeF = readMaybe input :: Maybe Float
    if maybeF == Nothing
        then do
            putStrLn $ "Invalid input, please enter a number between 0 and 1" 
            readFloat text
        else
            let Just f = maybeF
            in if f >= 0 && f <= 1
                then return f
                else do
                    putStrLn $ "Invalid input, please enter a number between 0 and 1" 
                    readFloat text


-- The main function for interaction with the user
main :: IO ()
main = do
    height <- readInt "Enter height of the maze:"
    width  <- readInt "Enter width of the maze:"
    sparsity <- readFloat "Enter the sparsity in [0, 1]:"
    difficulty <- readFloat "Enter the difficulty in [0, 1]:"

    graph <- dfsGen height width difficulty sparsity
    let (Graph _ _ gr start finish) = graph

    putStrLn $ asString (graphToGrid graph)

    putStrLn "Do you want to see the solution (y/n)?"
    input <- getLine
    if input == "y"
      then do 
          putStrLn $ "The length of the solution = " ++ show (length (shortestPath gr start finish))
          putStrLn $ asString (graphToGridWithSolution graph)
      else return ()
