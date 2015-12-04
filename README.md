# Testing IO-Heavy Haskell Applications

The code in this repository's purpose is to demonstrate how one might test an
IO-heavy Haskell application w/out resorting to side-effectful operations.

## Program Description

The program must do the following:

* take a command-line argument specifying the name of a file
* use that argument to read the contents of said file off disk
* prepend the string "hello " to the contents of the file
* print the aforementioned greeting (i.e. "hello martha") to the console
* print the number of milliseconds it took to complete steps 1-4 to the console

## Examples

* (complete) using a type class
* using a data type
* using free monads
