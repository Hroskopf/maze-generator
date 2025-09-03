# MazeGenerator

This is a Haskell project for maze generating.

The program gets sizes (height and width) of the maze, the expeccted difficulty (or the length of the solution) and the sparsity of the maze (or how many alternative solutions can exist) and generates the rectangular maze with given parameters.

## Users docs

The comunication with the program is done throught the console. To run the program you need to run the `main` function of the `Main.hs` file. 

One way you can do this is:

Run 
```sh
ghc -package random-shuffle Main.hs -o maze
```

To create an executable file and the run the program using `./maze` on Linux and MacOS or `maze.exe` on Windows.

After that you will see next questions:

- `Enter height of the maze:` - you need to write the height of the maze that you want

- `Enter width of the maze:` - width of the maze

- `Enter the sparsity in [0, 1]:` - enter the float number between 0 and 1. The bigger the number is the more different solution expected (= the less sparser graph is). In other words if you enter 0, you would get a tree with an exactly one solution; if you enter 1, you will get empty maze without the walls.

- `Enter the difficulty in [0, 1]:` - the float number between 0 and 1. The bigger the number is the longer shortest solution is expected. So if you enter a 0, you will expect the simple maze and for 1, more complicated one.

After that you the maze will be generated and written with ASCII art, for example:

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

(given maze is generated with the parameters `5`, `5`, `0` and `0.5` Correspondingly)

The starting and finishing cells will be located on the top and bottom side.

After that you will get the last question `Do you want to see the solution (y/n)?`.

If you answer with `y`, you will see the solution for the maze like this:

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

## Programmers docs

### File division

The code is divided into 5 files:
- `Maze.hs` - there is a definition of datatypes used in other files
- `Gen.hs` - file with function responsible for generating a maze
- `Output.hs` - everything needed to draw mazes to the console
- `MazeSolver.hs` - implementation of the bfs needed to find the solution of the generated maze (and also for finding suitable start/finish)
- `Main.hs` - main file with the user interaction

### Idea of the algorithm

The maze is generated as follows:

Firstly, we do the random DFS on the rectangular grid. If we look at all the visited edges, we will get the spanning tree of the grid which is a acyclic maze.

Secondly, we want to add some amount of edges to create some alternative pathes and cycles. The number of edges is defined by the corresponding input parameter.

After that, we need to choose the start/finish cell of the maze. By choosing different cells we can set the desired difficulty of the maze. We want start and finish cells to be on the top and bottom of the grid. So we will try all the possible pairs of suitable cells, find the length of the smallest path for each, and choose the best pair of cells for out difficulty parameter.

Now when we have the maze generated, we would wanna solve it using a bfs and find the shortest solution.

### Libraries

The implementation uses all the standart libraries, except of library used for a random library: `System.Random.Shuffle`. 

It also uses the standart ones like `Control.Monad`, `Data.List` and `Text.Read`.