maze: Main.hs Gen.hs Maze.hs MazeSolver.hs Output.hs
	ghc -package random-shuffle -outputdir build Main.hs -o maze

run: maze
	./maze

clean:
	rm -rf maze build

.PHONY: run clean
