//
//  ToolsView.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 7/10/23.
//

import SwiftUI

struct ToolsView: View {
    var body: some View {
        List{
            // SCHENGEN CALCULATOR
            NavigationLink {
                SchengenCalculatorView()
            } label: {
                HStack{
                    Image(systemName: "candybarphone")
                    
                    Text("Schengen kalkulačka")
                }
            }
            
            // ZAKONYPROLIDI SEARCHER
            NavigationLink {
                LawSearchView(tfSearch: "")
            } label: {
                HStack{
                    Image(systemName: "network")
                    
                    Text("Hledám, co tu není")
                }
            }
            
            //WHAT ELSE? MAYBE OTHER LINKS?
        }
    }
}

struct ToolsView_Previews: PreviewProvider {
    static var previews: some View {
        ToolsView()
            .preferredColorScheme(.dark)
    }
}
