//
//  GuideView.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 7/12/23.
//

import SwiftUI

struct GuideView: View {
    @AppStorage("currentGuideStep") private var currentGuideStep: Int = 0
    
    var body: some View {
        VStack(alignment: .leading){
            GuideStepView(title: "Vyhledavani a tak", text: "Kdyz nejsi trapak a kliknes nahore, tak... yes, zacnes vyhledavat.")
                
            HStack{
                Button {
                    
                } label: {
                    Text("Přeskočit průvodce")
                }
                .buttonStyle(.plain)
                .font(.caption)
                
                Spacer()
                
                Button {
                    
                } label: {
                    Text("Pokračovat")
                }
                .foregroundColor(.white)
                .buttonStyle(.bordered)
            }
            .padding()
        }
        .foregroundColor(.white)
        .background(
            Color("GuideColor")
        )
        .cornerRadius(7)
        .padding()
    }
}

struct GuideStepView: View {
    var title: String
    var text: String
    
    var body: some View {
        VStack{
            HStack{
                Text(title)
                    .bold()
                    .font(.title3)
                Spacer()
                Text("1/3")
            }
            .ignoresSafeArea()
            .padding()
            .background(
                Color("GuideTitleColor")
            )
            
            Text(text)
                .padding(.horizontal, 3)
        }
    }
}

struct GuideView_Previews: PreviewProvider {
    static var previews: some View {
        GuideView()
    }
}
