//
//  CYCMenuView.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/12/23.
//

import SwiftUI

struct CYCMenuView: View {

    @State private var record: Int = 0
    @Binding var showingCYC: Bool
    
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea()
            
            NavigationStack{
                ZStack{
                    VStack (alignment: .center){
                        Text("Chyť si svého zločince")
                            .padding()
                            .font(.largeTitle)
                            .bold()
                        
                        VStack(alignment: .leading){
                            HStack{
                                Image("criminal")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                
                                VStack (alignment: .leading){
                                    Text("Klikni pro získání bodů (+1 bod).")
                                    Text("Ignoruj a získáš chybu (+1 chyba)")
                                }
                                
                            }
                            
                            HStack{
                                Image("innocent")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                
                                Text("Klikni a získáš chybu (+1 chyba)")
                            }
                        }
                        .padding()
                        
                        Text("Konec hry nastane při získání 10 chyb")
                        
                        
                        NavigationLink {
                            CatchYourCriminalView()
                        } label: {
                            Text("PLAY")
                                .foregroundColor(.white)
                                .font(.largeTitle)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .foregroundColor(.secondary)
                                        .frame(width: 250, height: 75)
                                        
                                )
                        }
                        .isDetailLink(false)
                        .padding()
                        
                        VStack{
                            Text("Nejvyšší dosažené skóre")
                                .foregroundColor(.secondary)
                            Text("\(record)")
                                .font(.title)
                        }
                        
                    }
                    .foregroundColor(.white)
                }
            }
        }
        .onAppear{
            record = UserDefaults.standard.integer(forKey: "CYCrecordScore")
        }
    }
}
