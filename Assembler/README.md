MMix Simulator Assembler
========================

The assembler component for this project requires the Haskell language. Check out https://www.haskell.org/platform/ to find out how to install Haskell on your computer.

We used the Glasgow Haskell Compiler (GHCi) version 7.8.4 during the development of this project.

There is two way to execute this application. You can start the ghci repl and load the application directly into the repl. The preferred approach is to create an executable program. The command to do this is:

ghc -o MMixAssembler --make Main

Once you have created the executable all you need to do is run this program and specify the location of the MMIXAL source file as the argument.

This will cause the application to create a binary representation of the file in the same folder as the source, but with an "SE" extenstion.