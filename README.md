# MazeGenerator

This is a Haskell project for maze generation.

The program takes the size (height and width) of the maze, the expected difficulty (i.e. the length of the solution) and the sparsity of the maze (i.e. how many alternative solutions can exist), and generates a rectangular maze with the given parameters.

## User docs

Communication with the program happens through the console. To run the program, you need to run the `main` function of the `Main.hs` file.

One way to do this:

Run
```sh
ghc -package random-shuffle Main.hs -o maze
```

to create an executable, then run the program with `./maze` on Linux and macOS or `maze.exe` on Windows.

After that you will see the following questions:

- `Enter height of the maze:` - the height of the maze you want

- `Enter width of the maze:` - the width of the maze

- `Enter the sparsity in [0, 1]:` - a float between 0 and 1. The bigger the number, the more alternative solutions are expected (= the less sparse the graph is). In other words, if you enter 0, you get a tree with exactly one solution; if you enter 1, you get an empty maze without walls.

- `Enter the difficulty in [0, 1]:` - a float between 0 and 1. The bigger the number, the longer the shortest solution is expected to be. So for 0 you can expect a simple maze, and for 1 a more complicated one.

After that the maze is generated and drawn as ASCII art, for example:

```
.-.-.-.-. .
| |       |
. .-. .-. .
|   | |   |
.-. . .-.-.
|   |     |
. .-.-. . .
| |   | | |
. . . .-. .
|   |     |
.-.-.-. .-.
```

(this maze was generated with the parameters `5`, `5`, `0` and `0.5` correspondingly)

The starting and finishing cells are located on the top and bottom sides.

Finally you will get the last question: `Do you want to see the solution (y/n)?`

If you answer `y`, you will see the solution of the maze, like this:

```
The length of the solution = 10
.-.-.-.-.X.
| |  XXXXX|
. .-.X.-. .
|   |X|   |
.-. .X.-.-.
|   |XXXXX|
. .-.-. .X.
| |   | |X|
. . . .-.X.
|   |  XXX|
.-.-.-.X.-.
```

## Programmer docs

### File division

The code is divided into 5 files:
- `Maze.hs` - definitions of the data types used in the other files
- `Gen.hs` - the functions responsible for generating a maze
- `Output.hs` - everything needed to draw mazes to the console
- `MazeSolver.hs` - the implementation of BFS used to find the solution of the generated maze (and also to find a suitable start/finish)
- `Main.hs` - the main file with the user interaction

### Idea of the algorithm

The maze is generated as follows:

First, we run a random DFS on the rectangular grid. Taking all the visited edges gives us a spanning tree of the grid, which is an acyclic maze.

Second, we add some number of edges to create alternative paths and cycles. The number of edges is defined by the corresponding input parameter.

After that, we need to choose the start and finish cells of the maze. By choosing different cells we can set the desired difficulty of the maze. We want the start and finish cells to be on the top and bottom of the grid, so we try all possible pairs of suitable cells, find the length of the shortest path for each, and choose the pair that best matches our difficulty parameter.

Now that we have the maze generated, we solve it using BFS to find the shortest solution.

### Libraries

The implementation uses one library outside the standard ones, for randomness: `System.Random.Shuffle`.

It also uses standard ones like `Control.Monad`, `Data.List` and `Text.Read`.
