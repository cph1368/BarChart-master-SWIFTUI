//
//  YAxisTests.swift
//  BarChartTests
//
//  Copyright (c) 2020 Roman Baitaliuk
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.

import XCTest
@testable import BarChart

class YAxisTests: XCTestCase {

    func testScaler1() {
        let yAxis = YAxis(frameHeight: 400, data: [])
        XCTAssert(yAxis.scaler == nil)
    }
    
    func testScaler2() {
        let yAxis = YAxis(frameHeight: 0, data: [1, 2, 3])
        XCTAssert(yAxis.scaler?.tickSpacing == nil)
        XCTAssert(yAxis.scaler?.scaledMin == nil)
        XCTAssert(yAxis.scaler?.scaledMax == nil)
        XCTAssert(yAxis.formattedLabels().count == 0)
    }

    func testScaler3() {
        let yAxis = YAxis(frameHeight: 400, data: [10])
        XCTAssert(yAxis.scaler?.tickSpacing == 1)
        XCTAssert(yAxis.scaler?.scaledMin == 0)
        XCTAssert(yAxis.scaler?.scaledMax == 10)
        XCTAssert(yAxis.formattedLabels().count == 11)
    }

    func testScaler4() {
        let ref = YAxisReference()
        ref.minTicksSpacing = 100
        let yAxis = YAxis(frameHeight: 600, data: [5, 7, 14], ref: ref)
        XCTAssert(yAxis.scaler?.tickSpacing == 5)
        XCTAssert(yAxis.scaler?.scaledMin == 0)
        XCTAssert(yAxis.scaler?.scaledMax == 15)
        XCTAssert(yAxis.formattedLabels().count == 4)
    }
    
    func testMaxTicks1() {
        let ref = YAxisReference()
        ref.minTicksSpacing = 60
        let yAxis = YAxis(frameHeight: 400, data: TestData.Values.Positive.Small.values1, ref: ref)
        let expectedLabels = ["0.0", "0.1", "0.2", "0.3"]
        XCTAssert(yAxis.formattedLabels() == expectedLabels)
    }
    
    func testMaxTicks2() {
        let ref = YAxisReference()
        ref.minTicksSpacing = 20
        let yAxis = YAxis(frameHeight: 400, data: TestData.Values.Positive.Small.values1, ref: ref)
        let expectedLabels = ["0.00", "0.02", "0.04", "0.06", "0.08", "0.10", "0.12", "0.14", "0.16", "0.18", "0.20", "0.22", "0.24"]
        XCTAssert(yAxis.formattedLabels() == expectedLabels)
    }
    
    func testMaxTicks3() {
        let ref = YAxisReference()
        ref.minTicksSpacing = 0
        let yAxis = YAxis(frameHeight: 400, data: TestData.Values.Positive.Small.values1, ref: ref)
        let expectedLabels = ["0.00", "0.05", "0.10", "0.15", "0.20", "0.25"]
        XCTAssert(ref.minTicksSpacing == 40.0)
        XCTAssert(yAxis.formattedLabels() == expectedLabels)
    }
    
    func testMaxTicks4() {
        let ref = YAxisReference()
        ref.minTicksSpacing = -30
        let yAxis = YAxis(frameHeight: 400, data: TestData.Values.Positive.Small.values1, ref: ref)
        let expectedLabels = ["0.00", "0.05", "0.10", "0.15", "0.20", "0.25"]
        XCTAssert(ref.minTicksSpacing == 40.0)
        XCTAssert(yAxis.formattedLabels() == expectedLabels)
    }
    
    func testFormatter() {
        let ref = YAxisReference()
        ref.formatter = { value, decimals in
            let billions = value == 0 ? "" :"b"
            return String(format: "%.\(decimals)f\(billions)", value)
        }
        let yAxis = YAxis(frameHeight: 400, data: TestData.Values.Positive.Small.values1, ref: ref)
        let expectedLabels = ["0.00", "0.05b", "0.10b", "0.15b", "0.20b", "0.25b"]
        XCTAssert(yAxis.formattedLabels() == expectedLabels)
    }
    
    // MARK: - Positive values
    
    func testPositiveLabels1() {
        let yAxis = YAxis(frameHeight: 400, data: TestData.Values.Positive.Small.values1)
        let expectedLabels = ["0.00", "0.05", "0.10", "0.15", "0.20", "0.25"]
        XCTAssert(yAxis.formattedLabels() == expectedLabels)
    }
    
    func testPositiveLabels2() {
        let yAxis = YAxis(frameHeight: 400, data: TestData.Values.Positive.Small.values2)
        let expectedLabels = ["0.00", "0.05", "0.10", "0.15", "0.20", "0.25", "0.30"]
        XCTAssert(yAxis.formattedLabels() == expectedLabels)
    }
    
    func testPositiveLabels3() {
        let yAxis = YAxis(frameHeight: 400, data: TestData.Values.Positive.Small.values3)
        let expectedLabels = ["0.00", "0.05", "0.10", "0.15", "0.20", "0.25", "0.30"]
        XCTAssert(yAxis.formattedLabels() == expectedLabels)
    }
    
    func testPositiveLabels4() {
        let yAxis = YAxis(frameHeight: 400, data: TestData.Values.Positive.Small.values4)
        let expectedLabels = ["0.00", "0.05", "0.10", "0.15", "0.20", "0.25", "0.30"]
        XCTAssert(yAxis.formattedLabels() == expectedLabels)
    }
    
    func testPositiveLabels5() {
        let yAxis = YAxis(frameHeight: 400, data: TestData.Values.Positive.Small.values5)
        let expectedLabels = ["0.0", "0.1", "0.2", "0.3", "0.4", "0.5", "0.6", "0.7", "0.8", "0.9", "1.0"]
        XCTAssert(yAxis.formattedLabels() == expectedLabels)
    }
    
    func testPositiveLabels6() {
        let yAxis = YAxis(frameHeight: 400, data: TestData.Values.Positive.Mid.values1)
        let expectedLabels = ["0", "10", "20", "30", "40", "50", "60", "70", "80", "90", "100"]
        XCTAssert(yAxis.formattedLabels() == expectedLabels)
    }
    
    func testPositiveLabels7() {
        let yAxis = YAxis(frameHeight: 400, data: TestData.Values.Positive.Mid.values2)
        let expectedLabels = ["0", "10", "20", "30", "40", "50", "60", "70"]
        XCTAssert(yAxis.formattedLabels() == expectedLabels)
    }
    
    func testPositiveLabels8() {
        let yAxis = YAxis(frameHeight: 400, data: TestData.Values.Positive.Mid.values3)
        let expectedLabels = ["0", "10", "20", "30", "40", "50", "60"]
        XCTAssert(yAxis.formattedLabels() == expectedLabels)
    }
    
    func testPositiveLabels9() {
        let yAxis = YAxis(frameHeight: 400, data: TestData.Values.Positive.Mid.values4)
        let expectedLabels = ["0", "10", "20", "30", "40", "50", "60", "70", "80", "90", "100"]
        XCTAssert(yAxis.formattedLabels() == expectedLabels)
    }
    
    func testPositiveLabels10() {
        let yAxis = YAxis(frameHeight: 400, data: TestData.Values.Positive.Mid.values5)
        let expectedLabels = ["0", "10", "20", "30", "40", "50", "60", "70", "80", "90", "100"]
        XCTAssert(yAxis.formattedLabels() == expectedLabels)
    }
    
    func testPositiveLabels11() {
        let yAxis = YAxis(frameHeight: 400, data: TestData.Values.Positive.Large.values1)
        let expectedLabels = ["0", "100", "200", "300", "400", "500", "600", "700", "800", "900", "1000"]
        XCTAssert(yAxis.formattedLabels() == expectedLabels)
    }
    
    func testPositiveLabels12() {
        let yAxis = YAxis(frameHeight: 400, data: TestData.Values.Positive.Large.values2)
        let expectedLabels = ["0", "50", "100", "150", "200", "250", "300", "350", "400", "450", "500"]
        XCTAssert(yAxis.formattedLabels() == expectedLabels)
    }
    
    func testPositiveLabels13() {
        let yAxis = YAxis(frameHeight: 400, data: TestData.Values.Positive.Large.values3)
        let expectedLabels = ["0", "100", "200", "300", "400", "500", "600", "700", "800", "900"]
        XCTAssert(yAxis.formattedLabels() == expectedLabels)
    }
    
    func testPositiveLabels14() {
        let yAxis = YAxis(frameHeight: 400, data: TestData.Values.Positive.Large.values4)
        let expectedLabels = ["0", "100", "200", "300", "400", "500", "600", "700", "800", "900", "1000"]
        XCTAssert(yAxis.formattedLabels() == expectedLabels)
    }
    
    func testPositiveLabels15() {
        let yAxis = YAxis(frameHeight: 400, data: TestData.Values.Positive.Large.values5)
        let expectedLabels = ["0", "100", "200", "300", "400", "500", "600", "700", "800", "900", "1000"]
        XCTAssert(yAxis.formattedLabels() == expectedLabels)
    }
    
    // MARK: - Negative values
    
    func testNegativeLabels1() {
        let yAxis = YAxis(frameHeight: 500, data: TestData.Values.Negative.Small.values1)
        let expectedLabels = ["-0.25", "-0.20", "-0.15", "-0.10", "-0.05", "0.00"]
        XCTAssert(yAxis.formattedLabels() == expectedLabels)
    }
    
    func testNegativeLabels2() {
        let yAxis = YAxis(frameHeight: 500, data: TestData.Values.Negative.Small.values2)
        let expectedLabels = ["-0.20", "-0.18", "-0.16", "-0.14", "-0.12", "-0.10", "-0.08", "-0.06", "-0.04", "-0.02", "-0.00"]
        XCTAssert(yAxis.formattedLabels() == expectedLabels)
    }
    
    func testNegativeLabels3() {
        let yAxis = YAxis(frameHeight: 550, data: TestData.Values.Negative.Small.values3)
        let expectedLabels = ["-0.30", "-0.25", "-0.20", "-0.15", "-0.10", "-0.05", "0.00"]
        XCTAssert(yAxis.formattedLabels() == expectedLabels)
    }
    
    func testNegativeLabels4() {
        let yAxis = YAxis(frameHeight: 600, data: TestData.Values.Negative.Small.values4)
        let expectedLabels = ["-0.30", "-0.25", "-0.20", "-0.15", "-0.10", "-0.05", "0.00"]
        XCTAssert(yAxis.formattedLabels() == expectedLabels)
    }
    
    func testNegativeLabels5() {
        let yAxis = YAxis(frameHeight: 400, data: TestData.Values.Negative.Small.values5)
        let expectedLabels = ["-0.30", "-0.25", "-0.20", "-0.15", "-0.10", "-0.05", "0.00"]
        XCTAssert(yAxis.formattedLabels() == expectedLabels)
    }
    
    func testNegativeLabels6() {
        let yAxis = YAxis(frameHeight: 300, data: TestData.Values.Negative.Mid.values1)
        let expectedLabels = ["-15", "-10", "-5", "0"]
        XCTAssert(yAxis.formattedLabels() == expectedLabels)
    }
    
    func testNegativeLabels7() {
        let yAxis = YAxis(frameHeight: 250, data: TestData.Values.Negative.Mid.values2)
        let expectedLabels = ["-50", "-40", "-30", "-20", "-10", "0"]
        XCTAssert(yAxis.formattedLabels() == expectedLabels)
    }
    
    func testNegativeLabels8() {
        let yAxis = YAxis(frameHeight: 280, data: TestData.Values.Negative.Mid.values3)
        let expectedLabels = ["-80", "-60", "-40", "-20", "0"]
        XCTAssert(yAxis.formattedLabels() == expectedLabels)
    }
    
    func testNegativeLabels9() {
        let yAxis = YAxis(frameHeight: 780, data: TestData.Values.Negative.Mid.values4)
        let expectedLabels = ["-100", "-95", "-90", "-85", "-80", "-75", "-70", "-65", "-60", "-55", "-50", "-45", "-40", "-35", "-30", "-25", "-20", "-15", "-10", "-5", "0"]
        XCTAssert(yAxis.formattedLabels() == expectedLabels)
    }
    
    func testNegativeLabels10() {
        let yAxis = YAxis(frameHeight: 450, data: TestData.Values.Negative.Mid.values5)
        let expectedLabels = ["-100", "-90", "-80", "-70", "-60", "-50", "-40", "-30", "-20", "-10", "0"]
        XCTAssert(yAxis.formattedLabels() == expectedLabels)
    }
    
    func testNegativeLabels11() {
        let yAxis = YAxis(frameHeight: 454, data: TestData.Values.Negative.Large.values1)
        let expectedLabels = ["-250", "-200", "-150", "-100", "-50", "0"]
        XCTAssert(yAxis.formattedLabels() == expectedLabels)
    }
    
    func testNegativeLabels12() {
        let yAxis = YAxis(frameHeight: 676, data: TestData.Values.Negative.Large.values2)
        let expectedLabels = ["-400", "-350", "-300", "-250", "-200", "-150", "-100", "-50", "0"]
        XCTAssert(yAxis.formattedLabels() == expectedLabels)
    }
    
    func testNegativeLabels13() {
        let yAxis = YAxis(frameHeight: 673, data: TestData.Values.Negative.Large.values3)
        let expectedLabels = ["-950", "-900", "-850", "-800", "-750", "-700", "-650", "-600", "-550", "-500", "-450", "-400", "-350", "-300", "-250", "-200", "-150", "-100", "-50", "0"]
        XCTAssert(yAxis.formattedLabels() == expectedLabels)
    }
    
    func testNegativeLabels14() {
        let yAxis = YAxis(frameHeight: 120, data: TestData.Values.Negative.Large.values4)
        let expectedLabels = ["-1000", "-500", "0"]
        XCTAssert(yAxis.formattedLabels() == expectedLabels)
    }
    
    func testNegativeLabels15() {
        let yAxis = YAxis(frameHeight: 300, data: TestData.Values.Negative.Large.values5)
        let expectedLabels = ["-1000", "-800", "-600", "-400", "-200", "0"]
        XCTAssert(yAxis.formattedLabels() == expectedLabels)
    }
    
    // MARK: - Positive and Negative values
    
    func testPositiveAndNegativeLabels1() {
        let yAxis = YAxis(frameHeight: 400, data: TestData.Values.PositiveAndNegative.Small.values1)
        let expectedLabels = ["-0.15", "-0.10", "-0.05", "0.00", "0.05", "0.10", "0.15", "0.20"]
        XCTAssert(yAxis.formattedLabels() == expectedLabels)
    }
    
    func testPositiveAndNegativeLabels2() {
        let yAxis = YAxis(frameHeight: 500, data: TestData.Values.PositiveAndNegative.Small.values2)
        let expectedLabels = ["-0.20", "-0.15", "-0.10", "-0.05", "0.00", "0.05", "0.10", "0.15", "0.20"]
        XCTAssert(yAxis.formattedLabels() == expectedLabels)
    }
    
    func testPositiveAndNegativeLabels3() {
        let yAxis = YAxis(frameHeight: 550, data: TestData.Values.PositiveAndNegative.Small.values3)
        let expectedLabels = ["-0.20", "-0.15", "-0.10", "-0.05", "0.00", "0.05", "0.10", "0.15", "0.20"]
        XCTAssert(yAxis.formattedLabels() == expectedLabels)
    }
    
    func testPositiveAndNegativeLabels4() {
        let yAxis = YAxis(frameHeight: 600, data: TestData.Values.PositiveAndNegative.Small.values4)
        let expectedLabels = ["-0.15", "-0.10", "-0.05", "0.00", "0.05", "0.10", "0.15", "0.20"]
        XCTAssert(yAxis.formattedLabels() == expectedLabels)
    }
    
    func testPositiveAndNegativeLabels5() {
        let yAxis = YAxis(frameHeight: 300, data: TestData.Values.PositiveAndNegative.Mid.values1)
        let expectedLabels = ["-20", "-10", "0", "10", "20", "30"]
        XCTAssert(yAxis.formattedLabels() == expectedLabels)
    }
    
    func testPositiveAndNegativeLabels6() {
        let yAxis = YAxis(frameHeight: 250, data: TestData.Values.PositiveAndNegative.Mid.values2)
        let expectedLabels = ["-100", "-50", "0", "50", "100"]
        XCTAssert(yAxis.formattedLabels() == expectedLabels)
    }
    
    func testPositiveAndNegativeLabels7() {
        let yAxis = YAxis(frameHeight: 280, data: TestData.Values.PositiveAndNegative.Mid.values3)
        let expectedLabels = ["-100", "-50", "0", "50", "100"]
        XCTAssert(yAxis.formattedLabels() == expectedLabels)
    }
    
    func testPositiveAndNegativeLabels8() {
        let yAxis = YAxis(frameHeight: 780, data: TestData.Values.PositiveAndNegative.Mid.values4)
        let expectedLabels = ["-100", "-90", "-80", "-70", "-60", "-50", "-40", "-30", "-20", "-10", "0", "10", "20", "30", "40", "50", "60", "70", "80", "90"]
        XCTAssert(yAxis.formattedLabels() == expectedLabels)
    }
    
    func testPositiveAndNegativeLabels9() {
        let yAxis = YAxis(frameHeight: 600, data: TestData.Values.PositiveAndNegative.Large.values1)
        let expectedLabels = ["-500", "-400", "-300", "-200", "-100", "0", "100", "200", "300", "400", "500"]
        XCTAssert(yAxis.formattedLabels() == expectedLabels)
    }
    
    func testPositiveAndNegativeLabels10() {
        let yAxis = YAxis(frameHeight: 673, data: TestData.Values.PositiveAndNegative.Large.values2)
        let expectedLabels = ["-1000", "-900", "-800", "-700", "-600", "-500", "-400", "-300", "-200", "-100", "0", "100", "200", "300", "400", "500", "600", "700", "800"]
        XCTAssert(yAxis.formattedLabels() == expectedLabels)
    }
    
    func testPositiveAndNegativeLabels11() {
        let yAxis = YAxis(frameHeight: 500, data: TestData.Values.PositiveAndNegative.Large.values3)
        let expectedLabels = ["-1000", "-800", "-600", "-400", "-200", "0", "200", "400", "600", "800", "1000"]
        XCTAssert(yAxis.formattedLabels() == expectedLabels)
    }
    
    func testPositiveAndNegativeLabels12() {
        let yAxis = YAxis(frameHeight: 120, data: TestData.Values.PositiveAndNegative.Large.values4)
        let expectedLabels = ["-1000", "0", "1000"]
        XCTAssert(yAxis.formattedLabels() == expectedLabels)
    }
}
