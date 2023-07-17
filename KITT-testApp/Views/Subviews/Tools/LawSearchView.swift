//
//  LawSearchView.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 7/14/23.
//

import SwiftUI

struct LawSearchView: View {
    @State var tfSearch: String
    
    var body: some View {
        VStack{
            Text("Hledám, co tu není")
                .padding(0)
            Link("https://www.zakonyprolidi.cz", destination: URL(string: "https://www.zakonyprolidi.cz")!)
                .font(.caption2)
                .padding(.bottom)
            
            TextField("Klíčová slova", text: $tfSearch)
                .textFieldStyle(.roundedBorder)
            if !isTextAllowed(check: tfSearch){
                Text("Ve vyhledávacím poli se mohou nacházet pouze písmena bez diakritiky, čísla a pomlčka")
                    .font(.caption)
                    .foregroundColor(.red)
            }
            
            Spacer()
            
            if isTextAllowed(check: tfSearch){
                VStack{
                    Link(destination: URL(string: "https://www.zakonyprolidi.cz/hledani?text=\(tfSearch.replacingOccurrences(of: " ", with: "%20"))")!) {
                        Text("Vyhledat")
                    }
                    .padding(.bottom, 2)
                    
                    VStack{
                        Text("Stisknutím otevřete:")
                        Text("\("https://www.zakonyprolidi.cz/hledani?text=\(tfSearch.replacingOccurrences(of: " ", with: "%20"))")")
                    }
                    .font(.caption2)
                }
            }
        }
        .padding()
    }
}

extension LawSearchView {
    func isTextAllowed(check: String) -> Bool{
        if check.range(of: "[^a-zA-Z0-9- ]", options: .regularExpression) != nil {
          return false
        } else {
          return true
        }
    }
}

struct LawSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LawSearchView(tfSearch: "")
    }
}
