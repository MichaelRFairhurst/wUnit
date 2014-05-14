wUnit
=====

An xUnit style testing framework for the language [wake](wakelang.com).
-----------------------------------------------------------------------

wUnit is a critical piece of developing wake software. It ships with the
standard wake seed project so that wake apps can instantly be unit tested.
After all, unit testing is what wake was made to do.

### Basic Usage:

- create a class with a name ending in Test
- create methods on that class that begin with test, accepting a Printer as the sole argument.
- run wunit-compiler from your project root
- compile bin/TestSuite.wk
- link all of your object files, plus Asserts.o and TestResultReporter.o and TestSuite.o, with mainclass as "TestSuite" and main method as "test()"
- run executable

It will print test progress as well as failed tests broken down by assertion. Basic, but doable.


Example Test Case:

    import Asserts;

    every AdditionTest is:

        testOnePlusOne(Asserts) {
            Asserts.that(1+1)Equals(2);
        }

        testTwoPlusTwo(Asserts) {
            Asserts.that(2+2)Equals(4);
        }


Available Assertions:

    Asserts.that(Int)Equals(Int);

    Asserts.that(Text)Equals(Text);

    Asserts.that(Bool)Equals(Bool);

    Asserts.that(Bool);

    Asserts.that(Bool)IsTrue();

    Asserts.that(Bool)IsFalse();

    Asserts.fail("custom failure");


Happy testing!
