# Testing IO-Heavy Haskell Applications

The code in this repository's purpose is to demonstrate how one might test an
IO-heavy Haskell application w/out resorting to side-effectful operations.

This project was inspired by Sean Shubin's [hello](https://github.com/SeanShubin/hello).

## Program Description

The program must do the following:

* take a command-line argument specifying the name of a file
* use that argument to read the contents of said file off disk
* prepend the string "hello " to the contents of the file
* print the aforementioned greeting (i.e. "hello martha") to the console
* print the number of milliseconds it took to complete steps 1-4 to the console

## Required Tooling

All examples rely on [Stack](https://github.com/commercialhaskell/stack) by FP
Complete. On a Mac, one can install Stack using Homebrew:

```
brew update
brew install haskell-stack
```

To build, install, and run the examples, look for `run.sh` and `test.sh` in the
root of each example-folder.

## Examples

* ([complete](https://github.com/laser/haskell-testing-stubbing-io/tree/master/type-class)) using a type class
* using a data type
* ([in progress](https://github.com/laser/haskell-testing-stubbing-io/tree/master/free-monad)) using a free monad

## References

* [Testing functions in Haskell that do IO](http://stackoverflow.com/a/7374754)
* [5 Ways to Test Applications that Access a Database in Haskell](http://functor.tokyo/blog/2015-11-20-testing-db-access)
* [Purify code using free monads](http://www.haskellforall.com/2012/07/purify-code-using-free-monads.html)
