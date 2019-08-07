sbt-verilator
================

An Alpine-based Docker image that contains:
    
- sbt (@1.2.8)
- verilator (@4.012)
- openjdk-jre @(8)


... and the following packages from the Alpine repo which are needed for
a full working verilator installation:

- g++
- make
- perl

The inteneded purpose is dependency-packaging for a
[chisel](https://github.com/freechipsproject/chisel3) project, but if
it suits your needs, then have at it.
