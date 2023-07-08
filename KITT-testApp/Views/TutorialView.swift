//
//  TutorialView.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 7/8/23.
//

import SwiftUI

struct TutorialView: View {
    var body: some View {
        TabView {
            TutorialFirstPage()
            
            TutorialSecondPage()
        }
        .tabViewStyle(.page)
    }
}

struct TutorialFirstPage: View {
    @State private var imgAnim: Bool = false
    @State private var afterImgAnim: Bool = false
    
    var body: some View{
        ScrollView{
            VStack{
                Image("MainLogoTransp")
                    .resizable()
                    .frame(width: imgAnim ? 150 : 300, height: imgAnim ? 150: 300)
                    .background(Color(red: 0.0, green: 0, blue: 0.0, opacity: 0.0))
                    .cornerRadius(180)
                    .opacity(imgAnim ? 1.0 : 0.0)
            }
            .padding(.bottom, 5)

            VStack{
                Text("Zdar!")
                    .font(.largeTitle)
                    .bold()
                
                Text("Aplikace KITT zaměřuje svůj obsah především k pomoci a asistenci našich kolegů při práci na ulicích, která je už tak dost náročná.\n\nAplikaci a obsah doplňuji postupně a díky Vašim připomínkám, názorům a reportům chyb je obsah více detailní a můžete se na něj spolehnout.\n\nProto bych i rád připomněl, že obsah děláte právě vy kvalitním a proto prosím vše, co se Vám nezdá nebo je špatně, prosím nahlašujte.")
                    .padding(.bottom, 3)

                Text("Pokračujte swipem doprava.")
            }
            .padding()
            .opacity(afterImgAnim ? 1.0 : 0.0)
            .font(Font.custom("Roboto-Light", size: 16))
        }
        .onAppear{
            withAnimation(.easeInOut(duration: 1.5)) {
                imgAnim = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeIn(duration: 0.5)) {
                    afterImgAnim = true
                }
            }
        }
    }
}

struct TutorialSecondPage: View {
    var body: some View{
        ScrollView{
            VStack{
                
            }
        }
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
            .preferredColorScheme(.dark)
    }
}
