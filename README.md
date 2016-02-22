# SwiftXCTestLinuxNameGenerator
Script to generate test Swift function names for XCTest on Linux

## Why?
Currently when using XCTest on Linux you have to manually declare all tests to be ran, which is an annoying chore that can be automated with this super naive generator. Just run it in your test directory and it will print out exactly the code that you need to copy into your test classes.

Just clone this repo and run
```
swift /path/to/SwiftXCTestLinuxNameGenerator.swift /absolute/path/to/YourXCTestCaseFile.swift
```

The generator will print out the code you need to copy into your test file (above/below your test case class).

## Run for all test Swift files in a directory

```
➜ for i in *swift; do swift ../../../SwiftXCTestLinuxNameGenerator/SwiftXCTestLinuxNameGenerator.swift $PWD/$i; done
Using /Users/honzadvorsky/Documents/Jay/Tests/Jay/ConstsTests.swift
Copy the lines below into your testcase file
----------------------------------------------
#if os(Linux)
extension ConstsTests: XCTestCaseProvider {
    var allTests : [(String, () throws -> Void)] {
        return [
            ("testConsts", testConsts),
            ("testUnicodeTesting", testUnicodeTesting)
        ]
    }
}
#endif
----------------------------------------------
```

:gift_heart: Contributing
------------
Please create an issue with a description of your problem or open a pull request with a fix.

:v: License
-------
MIT

:alien: Author
------
Honza Dvorsky - http://honzadvorsky.com, [@czechboy0](http://twitter.com/czechboy0)



