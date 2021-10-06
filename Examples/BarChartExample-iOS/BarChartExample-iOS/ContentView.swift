//
//  ContentView.swift
//  BarChartExample-iOS
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

import SwiftUI
import BarChart

struct ContentView: View {
    
    let orientationChanged = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
        .makeConnectable()
        .autoconnect()
    
    // MARK: - Chart Properties
    
    let chartHeight: CGFloat = 300
    let config = ChartConfiguration()
    @State var entries = [ChartDataEntry]()
    @State var selectedBarTopCentreLocation: CGPoint?
    @State var selectedEntry: ChartDataEntry?
    
    // MARK: - Controls Properties
    
    @State var maxEntriesCount: Int = 30
    @State var xAxisTicksIntervalValue: Double = 5
    @State var isXAxisTicksHidden: Bool = true
    
    
    // progress Bar
    @State private var leftBar = 200
    @State private var rightBar = 150
    
    // MARK: - Views
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack{
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(.white)
                            .padding(5)
                            .shadow(color: .gray, radius: 2)
                        //  Text("No data").opacity(self.entries.isEmpty ? 1.0 : 0.0)
                        
                        VStack(alignment: .leading) {
                            VStack (alignment: .leading){
                                Text("Total spending")
                                    .font(.title)
                                    .fontWeight(.light)
                                    .foregroundColor(Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
                                    .padding(.bottom,2)
                                
                                Text("$4,246.83")
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    
                            }
                            .padding(.top)
                            .padding(.horizontal,8)
                            
                            self.chartView()
                            self.controlsView()
                        }
                        .padding()
                    }
                    .padding(24)
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(.white)
                            .padding(5)
                            .shadow(color: .gray, radius: 2)
                        VStack(alignment: .leading) {
                            
                            VStack {
                                Text("Ins and outs")
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(#colorLiteral(red: 0.1207325235, green: 0.112150304, blue: 0.3513972461, alpha: 1)))
                                    .padding(.bottom,2)
                            }
                            ZStack {
                                HStack(spacing: 2) {
                                    
                                    RoundedCornersShape(corners: [.topLeft, .bottomLeft], radius: 15)
                                        .fill(Color(#colorLiteral(red: 0.8202568293, green: 0.1505224109, blue: 0.09123057872, alpha: 1)))
                                        .frame(width: CGFloat(leftBar), height: 15)
                                    
                                    RoundedCornersShape(corners: [.topRight, .bottomRight], radius: 15)
                                        .fill(Color(#colorLiteral(red: 0.1263336241, green: 0.1195754185, blue: 0.3506284952, alpha: 1)))
                                        .frame(width: CGFloat(rightBar), height: 15)
                                }
                                .padding(.bottom,4)
                                
                            }
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Spending")
                                        .font(.headline)
                                        .fontWeight(.regular)
                                        .foregroundColor(Color(#colorLiteral(red: 0.1156284884, green: 0.1232237741, blue: 0.1499757469, alpha: 1)))
                                        .padding(.bottom,1)
                                    
                                    Text("$4,246.83")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                    
                                  
                                }
                                Spacer()
                                VStack(alignment: .trailing) {
                                    
                                    Text("Income")
                                        .font(.headline)
                                        .fontWeight(.regular)
                                        .foregroundColor(Color(#colorLiteral(red: 0.1156284884, green: 0.1232237741, blue: 0.1499757469, alpha: 1)))
                                        .padding(.bottom,1)
                                    
                                    Text("$3,687.56")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                  
                                }
                            }
                            .padding(.top,10)
                            
                            
                        }
                        .frame(width: 350)
                        .padding(24)
                    }
                    .padding(.horizontal,24)
                }
                

                
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    func selectionIndicatorView() -> some View {
        Group {
            if self.selectedEntry != nil && self.selectedBarTopCentreLocation != nil {
                SelectionIndicator(entry: self.selectedEntry!,
                                   location: self.selectedBarTopCentreLocation!.x,
                                   infoRectangleColor: Color(red: 241/255, green: 242/255, blue: 245/255))
            } else {
                Rectangle().foregroundColor(.clear)
            }
        }
        .frame(height: 60)
    }
    
    func chartView() -> some View {
        ZStack {
            // Drop shadow rectangle
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(.white)
                .padding()
            //.shadow(color: .gray, radius: 2)
            //  Text("No data").opacity(self.entries.isEmpty ? 1.0 : 0.0)
            VStack(alignment: .leading, spacing: 0) {
                self.selectionIndicatorView()
                SelectableBarChartView<SelectionLine>(config: self.config)
                    .onBarSelection { entry, location in
                        self.selectedBarTopCentreLocation = location
                        self.selectedEntry = entry
                    }
                    .selectionView {
                        SelectionLine(location: self.selectedBarTopCentreLocation,
                                      height: 185)
                    }
                    .onAppear() {
                        let labelsFont = CTFontCreateWithName(("SFProText-Regular" as CFString), 12, nil)
                        self.config.data.entries = self.randomEntries()
                        self.config.data.color = .red
                        self.config.xAxis.labelsColor =  .gray //label X
                        self.config.xAxis.ticksColor = Color(#colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1))
                        self.config.labelsCTFont = labelsFont
                        self.config.xAxis.ticksStyle = StrokeStyle(lineWidth: 0, lineCap: .round)
                        self.config.yAxis.labelsColor = .gray //label Y
                        self.config.yAxis.ticksColor = Color(#colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1))
                        self.config.yAxis.ticksStyle = StrokeStyle(lineWidth: 1.5, lineCap: .round)
                        self.config.yAxis.minTicksSpacing = 30.0
                        self.config.yAxis.formatter = { (value, decimals) in
                            let format = value == 0 ? "" : ""
                            return String(format: " $%.\(decimals)f\(format)", value)
                        }
                    }
                    .animation(.easeInOut)
                    .onReceive([self.isXAxisTicksHidden].publisher.first()) { (value) in
                        self.config.xAxis.ticksColor = value ? .clear : .gray
                    }
                    .onReceive([self.xAxisTicksIntervalValue].publisher.first()) { (value) in
                        self.config.xAxis.ticksInterval = Int(value)
                    }
                    .onReceive(self.orientationChanged) { _ in
                        self.config.objectWillChange.send()
                    }
            }.padding()
        }.frame(height: self.chartHeight)
    }
    
    func controlsView() -> some View {
        Group {
            
            Text("August 2021")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
                .padding(.bottom)
                .frame(maxWidth: .infinity, alignment: .center)
            
      
            //            VStack(spacing: 0) {
            //                Stepper(value: self.$maxEntriesCount, in: 0...29) {
            //                    Text("Max entries count: \(self.maxEntriesCount)")
            //                }.padding()
            //                Button(action: {
            //                   let newEntries = self.randomEntries()
            //                    self.entries = newEntries
            //                    self.config.data.entries = newEntries
            //                }) {
            //                   Text("Generate entries")
            //                }.randomButtonStyle()
            //           }
            
            //            Toggle(isOn: self.$isXAxisTicksHidden, label: {
            //                Text("X axis ticks is hidden")
            //            }).padding(15)
        }
    }
    
    // MARK: - Random Helpers
    
    func randomEntries() -> [ChartDataEntry] {
        var entries = [ChartDataEntry]()
        guard self.maxEntriesCount > 0 else { return [] }
        for data in 0..<self.maxEntriesCount {
            let randomDouble = Double.random(in: 0...150)
            let newEntry = ChartDataEntry(x: "\(1+data)", y: randomDouble)
            entries.append(newEntry)
        }
        return entries
    }
}

extension Color {
    static var random: Color {
        return Color(red: .random(in: 0...1),
                     green: .random(in: 0...1),
                     blue: .random(in: 0...1))
    }
}

// MARK: - Modifers

struct RandomButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(10)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
    }
}

extension View {
    func randomButtonStyle() -> some View {
        self.modifier(RandomButtonStyle())
    }
}


struct RoundedCornersShape: Shape {
    let corners: UIRectCorner
    let radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
