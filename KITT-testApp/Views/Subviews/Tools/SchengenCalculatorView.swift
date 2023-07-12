//
//  SchengenCalculatorView.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 7/10/23.
//

import SwiftUI
import Foundation

class Controls: ObservableObject{
    @Published var controlDate: Date = Date.now
    @Published var controlList: [PassControl] = []
    @Published var randomEnters: [RandomPassControl] = []
    
    public let countedArea: Int = 180
    private let allowedDays: Int = 90
    
    public func authIcon() -> some View {
        if isAllowed() {
            return Image(systemName: "person.fill.checkmark").foregroundColor(.green).font(.largeTitle)
        }else if !controlList.isEmpty {
            return Image(systemName: "person.fill.xmark").foregroundColor(.red).font(.largeTitle)
        }
        
        return Image(systemName: "person.fill.questionmark").foregroundColor(.yellow).font(.largeTitle)
    }
    
    public func countOverstay() -> Int {
        var count = 0
        count = allowedDays - countAllowedStay()
        return abs(count)
    }
    
    public func isAllowed() -> Bool {
        let finalCount = countAllowedStay()
        return finalCount <= allowedDays && !self.controlList.isEmpty
    }
    
    public func getCountedAreaDate() -> Date {
        return Calendar.current.date(byAdding: .day, value: -countedArea, to: self.controlDate)!
    }
    
    public func removeControl(control: IndexSet){
        controlList.remove(atOffsets: control)
    }
    
    public func moveControl(control: IndexSet, dest: Int){
        controlList.move(fromOffsets: control, toOffset: dest)
    }
    
    public func clearControls(){
        controlList.removeAll()
    }
    
    public func removeEnter(enter: IndexSet){
        randomEnters.remove(atOffsets: enter)
    }
    
    public func moveEnter(enter: IndexSet, dest: Int){
        randomEnters.move(fromOffsets: enter, toOffset: dest)
    }
    
    public func addNewEnter(){
        var temp: RandomPassControl = RandomPassControl()
        if let lastOne = randomEnters.last{
            temp.enter = !lastOne.enter
        }
        
        randomEnters.append(temp)
    }
    
    public func clearRandomEnters(){
        randomEnters.removeAll()
    }
    
    public func randomEntersCount() -> Int{
        return randomEnters.count
    }
    
    public func controlsCount() -> Int{
        return controlList.count
    }
    
    public func totalDifferenceInDays() -> Int {
        var total: Int = 0
        for control in self.controlList {
            total = total + control.dateDifferenceInDays
        }
        return total
    }
    
    public func countAllowedStay() -> Int {
        var total: Int = 0
        let tempArea: Date = self.getCountedAreaDate()
        for control in self.controlList{
            let range = control.from...control.until
            let allowedRange = range.clamped(to: tempArea...self.controlDate)
            let lowest = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: allowedRange.lowerBound)!
            let highest = Calendar.current.date(byAdding: .hour, value: 24, to: allowedRange.upperBound)!
            
            let count = Calendar.current.dateComponents([.day], from: lowest, to: highest).day!
            total = total + count
        }
        return total
    }
    
    public func canBeSent() -> Bool {
        var tempCount = 0
        for enter in randomEnters {
            tempCount = tempCount + (enter.enter ? 1 : -1)
        }
        
        return (tempCount == 1 || tempCount == 0)
    }
    
    public func sortRandomEnters() -> Bool {
        var error: Bool = false
        
        if self.randomEnters.count > 0 {
            self.clearControls()
            
            let tempArray:[RandomPassControl] = self.randomEnters.sorted(by: {$0.date < $1.date})
            
            
            var i = 0
            while i < tempArray.count {
                let from: Date = tempArray[i].date
                var until: Date = Date.now
                
                if i+1 < tempArray.count {
                    let tempUntil = tempArray[i+1]
                    if tempUntil.enter == !tempArray[i].enter {
                        until = tempUntil.date
                    }
                    else{
                        error = true
                        break
                    }
                }
                if !error {
                    self.controlList.append(PassControl(from: from, until: until))
                }
                i = i+2
            }
        }
       
        
        return !error
    }
}

struct RandomPassControl: Hashable {
    var date: Date = Date.now
    var enter: Bool = true
}

struct PassControl:Hashable{
    var from: Date = Date.now
    var until: Date = Date.now
    
    public var dateDifferenceInDays:Int {
        let tempModifiedDateFrom: Date = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self.from)!
        
        let tempModifiedDateUntilNoon: Date = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self.until)!
        let tempModifiedDateUntil: Date = Calendar.current.date(byAdding: .hour, value: 24, to: tempModifiedDateUntilNoon)!
        
        return Calendar.current.dateComponents([.day], from: tempModifiedDateFrom, to: tempModifiedDateUntil).day!
    }
}

struct SchengenCalculatorView: View {
    @ObservedObject var controls: Controls = Controls()
    
    @State var randomEntering:Bool = false
    @State var randomEnteringError: Bool = false
    
    var body: some View {
        ZStack{
            VStack{
                VStack{
                    Text("SCHENGEN CALCULATOR")
                        .padding(0)
                    Link("https://ec.europa.eu/assets/home/visa-calculator/calculator.htm?lang=en", destination: URL(string: "https://ec.europa.eu/assets/home/visa-calculator/calculator.htm?lang=en")!)
                        .font(.caption2)
                        .padding(.bottom)
                    
                    VStack{
                        DatePicker("Datum kontroly", selection: $controls.controlDate, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .padding(0)
                            .lineLimit(0)
                        HStack{
                            Text("(- \(controls.countedArea) dní = ") +
                            Text(controls.getCountedAreaDate(), style: .date) +
                            Text(")")
                        }
                        .font(.caption)
                    }
                }
                .padding(.horizontal)
                List{
                    ForEach($controls.controlList, id:\.self) { $control in
                        HStack{
                            DatePicker("OD", selection: $control.from, in: ...controls.controlDate, displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .labelsHidden()
                                .padding(.horizontal, 2)
                                .frame(minWidth: 60)
                                .padding(.vertical, 4)
                            DatePicker("DO", selection: $control.until, in: control.from..., displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .labelsHidden()
                                .padding(.horizontal, 2)
                                .frame(minWidth: 60)
                            
                            Text("DNU: \(control.dateDifferenceInDays)")
                                .font(.caption)
                                .frame(minWidth: 60)
                        }
                        
                    }
                    .onDelete { index in
                        controls.removeControl(control: index)
                    }
                    .onMove { index, offIndex in
                        controls.moveControl(control: index, dest: offIndex)
                    }
                }
                .toolbar {
                    if controls.controlsCount() > 0{
                        ToolbarItem(placement: .automatic) {
                            Button("Vymazat") {
                                controls.clearControls()
                            }
                        }
                        
                        ToolbarItem(placement: .automatic) {
                            EditButton()
                        }
                    }
                }
                
                HStack{
                    VStack(alignment: .center){
                        Text("CELKEM")
                        Text("\(controls.countAllowedStay())")
                            .bold()
                    }
                    .frame(maxWidth: 100, maxHeight: 60)
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    VStack(alignment: .center){
                        Image(systemName: "plus.circle")
                            .foregroundColor(.primary)
                            .font(.largeTitle)
                            .frame(width: 50, height: 60)
                            
                        Text("Stiskni dlouze pro jednodušší vkládání")
                            .font(.caption2)
                            .frame(alignment: .center)
                    }
                    .clipShape(Rectangle())
                    .frame(maxWidth: 200, maxHeight: 100)
                    .onTapGesture {
                        controls.controlList.append(PassControl())
                    }
                    .onLongPressGesture(minimumDuration: 1.0) {
                        randomEntering.toggle()
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .center){
                        controls.authIcon()
                        
                        if controls.controlsCount() > 0 {
                            Text("\(controls.isAllowed() ? "ZBÝVÁ" : "PŘEKROČIL") \(controls.countOverstay())")
                        }
                    }
                    .frame(maxWidth: 100, maxHeight: 100)
                    .padding(.horizontal)
                }
                .fullScreenCover(isPresented: $randomEntering) {
                    if !controls.sortRandomEnters(){
                        randomEnteringError.toggle()
                    }
                } content: {
                    if controls.randomEntersCount() > 0{
                        Button("Vymazat") {
                            controls.clearRandomEnters()
                        }
                    }
                    
                    List{
                        ForEach($controls.randomEnters, id:\.self) { $enter in
                            HStack{
                                Spacer()
                                
                                DatePicker("", selection: $enter.date, displayedComponents: .date)
                                    .datePickerStyle(.compact)
                                    .labelsHidden()
                                    .frame(minWidth: 75)
                                
                                Spacer()
                                
                                Button {
                                    enter.enter.toggle()
                                } label: {
                                    Text(enter.enter ? "VSTOUPIL" : "VYSTOUPIL")
                                }
                                .buttonStyle(.bordered)
                                .frame(minWidth: 75)
                                
                                Spacer()
                            }
                        }
                        .onDelete { index in
                            controls.removeEnter(enter: index)
                        }
                        .onMove { index, offIndex in
                            controls.moveEnter(enter: index, dest: offIndex)
                        }
                    }
                    
                    VStack{
                        Button {
                            controls.addNewEnter()
                        } label: {
                            Image(systemName: "plus.circle")
                                .foregroundColor(.primary)
                                .font(.largeTitle)
                        }
                        .padding()
                        
                        Button {
                            randomEntering.toggle()
                        } label: {
                            Text(controls.randomEntersCount() <= 0 ? "ZRUŠIT" : "ODESLAT")
                        }
                        .buttonStyle(.bordered)
                        .padding()
                        .disabled(!controls.canBeSent())
                    }
                }
                .alert("Nastala chyba při vkládání, každý vstup by měl mít svůj výstup, není-li to vstup poslední", isPresented: $randomEnteringError) {
                    Button("OK", role: .cancel) {}
                }
            }
        }
            
    }
}

struct SchengenCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        SchengenCalculatorView()
    }
}
