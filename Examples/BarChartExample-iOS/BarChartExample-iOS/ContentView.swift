//
//  ContentView.swift
//  BarChartExample-iOS

//  Created by Corry Handayani on 5/10/21.
//

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
                            .accessibilityElement(children: .combine)
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
                                //accessibility#1 - combine
                                .accessibilityElement(children: .combine)
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
                                .accessibilityElement(children: .combine)
                            }
                            .padding(.top,10)
                        }
                        //accessibility#2 - combine
                        .accessibilityElement(children: .combine)
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
            // Adding drop shadow rectangle to replicate design
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(.white)
                .padding()
            
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
                .accessibilityElement(children: .ignore)
                .accessibility(value: Text("This bar chart describes your expenditures in August 2021 with the total of $4,246.83"))
            // accessibility#5 - customise text because it does not make any sense
        }
    }
    
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
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
