//
//  WelcomeView.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 4/24/23.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        ZStack{
            Color(#colorLiteral(red: 0.1099997535, green: 0.1100001708, blue: 0.1187582836, alpha: 1))
                .ignoresSafeArea()
            
            TabView {
                ThankYouSubView()
            }
            .tabViewStyle(.page)
        }
        
    }
}

struct ThankYouSubView: View {
    @State private var textAnim: Bool = false
    @State private var imgAnim: Bool = false
    @State private var logoMove: Bool = false
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack{
            Image("MainLogoTransp")
                .resizable()
                .frame(width: imgAnim ? 150 : 300, height: imgAnim ? 150: 300)
                .background(Color(red: 0.0, green: 0, blue: 0.0, opacity: 0.0))
                .cornerRadius(180)
                .opacity(imgAnim ? 1.0 : 0.0).animation(.easeInOut(duration: 4.0), value: imgAnim)
                
            
            if textAnim {
                VStack{
                    
                    VStack(alignment: .leading){
                        Text("Děkuji za užívání aplikace a šíření mezi Vaše kolegy.\nVěřím, že i přes určitý nedostatek materiálu naleznete aplikaci užitečnou a především nápomocnou v už tak náročných situacích na ulici.\n\nAplikace je zdarma a taková navždy zůstane. I přesto se našlo několik desítek z Vás, kteří podpořili mě, tak i kolegu z Android verze KITTu. Děkujeme.")
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom)

                        Text("Od 14.3.2023 do 23.04.2023 si aplikaci KITT na iOS stáhlo: ")
                            .padding(.bottom)
                        
                        HStack{
                            Spacer()
                            Text("2 333 lidí")
                                .font(.title)
                                .bold()
                                .padding(.bottom)
                            Spacer()
                        }
                        
                        Text("Neskutečné, s tím děkuji i za hodnocení na AppStore. 5/5")
                            .padding(.bottom)
                        
                        Text("Nakonec Vám chci jen popřát hodně štěstí a především, abyste se vždy domů vrátili zdraví. \n\nKolega Radek.")
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom)
                    }
                    .padding(.bottom)
                    
                    Button {
                        dismiss()
                    } label: {
                        Text("Pokračovat do aplikace v novém kabátě")
                    }
                    .padding()
                    .foregroundColor(.blue)
                }
                .opacity(textAnim ? 1.0 : 0.0)
                
            }
            
            if logoMove {
                Spacer()
            }
            
        }
        .font(Font.custom("Roboto-Light", size: 16))
        .foregroundColor(.white)
        .lineSpacing(4)
        .padding()
        .onAppear{
            imgAnim = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                withAnimation(.easeInOut(duration: 0.8)) {
                    logoMove = true

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        withAnimation(.easeInOut(duration: 1.5)) {
                            textAnim = true
                        }
                    }
                }
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
            .preferredColorScheme(.dark)
    }
}
