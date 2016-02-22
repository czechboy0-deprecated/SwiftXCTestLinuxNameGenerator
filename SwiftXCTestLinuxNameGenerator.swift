import Foundation

let sourceFile = NSProcessInfo().arguments.last!
if sourceFile == "SwiftXCTestLinuxNameGenerator" {
	print("You must provide a test class absolute path as the only argument")
	exit(1)
}

func parseTestFunc(line: String) -> String? {
	let comps = line.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).filter { !$0.isEmpty }
	guard comps.count >= 2 else { return nil }
	guard comps[0] == "func" else { return nil }
	guard comps[1].hasPrefix("test") else { return nil }
	//remove trailing parentheses
	return String(comps[1].characters.dropLast(2))
}

func parseClassName(line: String) -> String? {
	let set = NSCharacterSet(charactersInString:":\r\t\n ")
	let comps = line.componentsSeparatedByCharactersInSet(set).filter { !$0.isEmpty }
	guard comps.count >= 2 else { return nil }
	guard comps[0] == "class" else { return nil }
	guard comps[2] == "XCTestCase" else { return nil }
	return comps[1]
}

print("Using \(sourceFile)")

do {
	let data = try String(contentsOfURL: NSURL(string: "file://" + sourceFile)!)

	let allLines = data.componentsSeparatedByString("\n")
	
	guard let className: String = allLines.flatMap({ parseClassName($0) }).first else {
		print("No XCTestCase found")
		exit(1)
	}
	let funcs: [String] = allLines.flatMap { parseTestFunc($0) } //only keep test func candidates
	guard funcs.count > 0 else {
		print("No test functions found")
		exit(1)
	}

	func funcLine(funcName: String) -> String {
		return "            (\"\(funcName)\", \(funcName))"
	}

	//print
	print("Copy the lines below into your testcase file")
	print("----------------------------------------------")
	print("#if os(Linux)")
	print("extension \(className): XCTestCaseProvider {")
	print("    var allTests : [(String, () throws -> Void)] {")
	print("        return [")
	let all = funcs.map { funcLine($0) }.joinWithSeparator(",\n")
	print(all)
	print("        ]")
	print("    }")
	print("}")
	print("#endif")
	print("----------------------------------------------")

} catch {
	print("Error reading file: \(error)")		
}
