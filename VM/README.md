MMix Simulator Virtual Machine
==============================

The graphical user interface component for this project requires the Erlang language. Check out http://www.erlang.org/ to find out how to install Scala on your computer.

The version of erlang we used to develop this application is R17B4.

The application can only be run from an erlang repl. The first time you run the application you need to compile all of the separate modules, thereafter you will only need to compile the communication component to load it into the repl.

To compile all of the modules you need to, firstly, move, from this folder, into the VirtualMachine/src folder. When you are in this folder you need to start the erlang repl by running *erl*. When you are in the repl you need to run all of these commands: -

c(branch).
c(comm).
c(cpu).
c(memory).
c(register_ra).
c(registers).
c(trap).
c(utilities).

If you wish to run the virtual machine at any time after the first run all you need to do is: -

c(comm).

When you have compiled the modules all you need to do to start the application is to run: -

comm:start_vm().


**Please Note that all . in the above essential and not just punctation**