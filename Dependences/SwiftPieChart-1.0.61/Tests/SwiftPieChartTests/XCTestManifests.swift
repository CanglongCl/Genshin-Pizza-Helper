import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    [
        testCase(SwiftPieChartTests.allTests),
    ]
}
#endif
