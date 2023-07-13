//
//  GuideView.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 7/12/23.
//

import SwiftUI

struct GuideView: View {
    @EnvironmentObject var gvm: GuideViewModel
    
    var body: some View {
        VStack(alignment: .leading){
            if gvm.currentGuideStep == 1 {
                GuideStepView(title: "Úvod", text: "Vítej! \nDěkuji, že využíváš aplikace KITT a věřím, že ti bude ve všech ohledech užitečná.\nPokud najdeš nějakou chybu, nebo budeš mít připomínku k obsahu či funkcím aplikace, prosím, ozvi se na e-mail. Děkuji!\nKolega Radek")
            }
            else if gvm.currentGuideStep == 2 {
                GuideStepView(title: "Aktualizace obsahu", text: "Obsah se aktualizuje kdykoli, kdy je nahlášena nějaká připomínka nebo chyba, případně když se obsah něčím doplňuje.\nV aplikaci se změna projeví, pokud stiskneš na hlavní stránce na tlačítko šipek v kolečku. Na tuto akci je nutné být připojený k internetu.\nJestliže na tlačítku vidíš modrou tečku, je dostupný nový obsah.\nJestliže vidíš tečku červenou, nejsi připojen do sítě.")
            }
            else if gvm.currentGuideStep == 3 {
                GuideStepView(title: "Hlavní obsah", text: "Na hlavní stránce uvidíš seznam hlavních kategorií.\nRozklikneš-li kategorii, uvidíš seznam konkrétních zákonných znění.\nTyto převážně obsahují hlavní nadpis, paragraf a obsah tohoto paragrafu, případně sankci za porušení.\nU každého z nich nalezneš i odkazy na zdroj nebo na jiná užitečná místa\nV horním panelu můžeš konkrétní zákonné znění nahlásit přes e-mail, vložit do seznamu oblíbených nebo sdílet ostatním, jako odkaz - každý s aplikací KITT jej otevře.")
            }
            else if gvm.currentGuideStep == 4{
                GuideStepView(title: "Vyhledávání", text: "Vyhledávat můžeš ve vyhledávacím políčku.\nDo něj můžeš napsat cokoli, co by mohlo být obsahem zákonného znění, které zrovna potřebuješ.\nPokud jsi si jistý, o který zákon se jedná, můžeš použít následující formát:\n\nČÍSLO-ROK-PARAGRAF-ODSTAVEC-PÍSMENO-BOD\n(např. 361-2000-7-1-c, držení telefonu za jízdy, zákon o silničním provozu)\n\nFiltrování vyhledávání si můžeš upravit v Nastavení.")
            }
            else if gvm.currentGuideStep == 5 {
                GuideStepView(title: "Submenu", text: "Na hlavní stránce na horním panelu úplně vpravo uvidíš ikonku podmenu, tři tečky v kolečku.\nToto menu obsahuje především Pomůcky, Nastavení, Novinky a závislou hru.\nMůžeš tu ale také najít verzi obsahu a aplikace, případně kontakt na vývojáře.\nPřímo v Nastavení je pak změna tmavého či světlého režimu aplikace a kontaktní tlačítko, prostřednictvím kterého mi můžeš napsat e-mail.\nPozor na tlačítko s názvem VYMAZAT DATA, slouží převážně pro vývojáře.")
            }
            else if gvm.currentGuideStep == 6 {
                GuideStepView(title: "Favorites", text: "Klikneš-li na srdíčko na hlavní stránce v horním panelu, uvidíš a můžeš vyhledávat pouze ve svých oblíbených.")
            }
            else if gvm.currentGuideStep == 7 {
                GuideStepView(title: "Recent", text: "Na hlavní stránce na horním panelu úplně vlevo nakonec nalezneš historii prohlížení. Tuto můžeš kdykoli smazat. A neboj, nikam se nezapisuje, je to jen pro tvé ulehčení")
            }
            else{
                GuideStepView(title: "Chyba", text: "Někde nastala chyba.")
            }
            
                
            HStack{
                if gvm.currentGuideStep < gvm.maxGuideStep {
                    Button {
                        gvm.endGuide()
                    } label: {
                        Text("Přeskočit průvodce")
                    }
                    .buttonStyle(.plain)
                    .font(.caption)
                }
                
                Spacer()
                
                Button {
                    gvm.nextStep()
                } label: {
                    Text(gvm.currentGuideStep >= gvm.maxGuideStep ? "Ukončit průvodce" : "Pokračovat")
                }
                .foregroundColor(.white)
                .background(
                    Color("GuideTitleColor")
                )
                .buttonStyle(.bordered)
                .cornerRadius(7)
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
            Text(text)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .padding()
        }
    }
}

struct GuideView_Previews: PreviewProvider {
    static var previews: some View {
        GuideView()
    }
}
