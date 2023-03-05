//
//  ContentSubView.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/3/23.
//

import SwiftUI

struct ContentSubView: View {
    @State var contentItem: Any? = nil

    var body: some View {
        if contentItem is Offense {
            OffenseContent(offense: contentItem as! Offense)
        }else if contentItem is CrimeModel{
            CrimeContent(crime: contentItem as? CrimeModel)
        }else if contentItem is LawExtractModel{
            LawExtractContent(lawExtract: contentItem as? LawExtractModel)
        }
    }
}

//OFFENSE
struct OffenseContent: View {
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var offense: Offense
    
    @State private var customNote = ""
    @State private var noteChanged = false
    
    var body: some View{
        ScrollView{
            VStack{
                Text(offense.wrappedTitle)
                    .font(.headline)
                Link("\(offense.paragraphModel.toString())",
                     destination: offense.paragraphModel.generateLawLink())
                
                Text(offense.wrappedContent)
                    .font(.caption)
                    .padding(.top, 10)
            }.padding(.vertical, 10)
            
            
            VStack{
                if !offense.wrappedViolationParagraph.isEmpty {
                    HStack{
                        Text("Přestupek")
                            .font(.headline)
                        Spacer()
                        Link("\(offense.violationParagraphModel.toString())",
                             destination: offense.violationParagraphModel.generateLawLink())
                        .font(.caption)
                    }
                    .padding(.vertical, 5)
                }
                if offense.offenseScore >= 0 {
                    HStack{
                        Text("Body za porušení")
                            .font(.headline)
                        Spacer()
                        Text("\(offense.offenseScore)")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                    .padding(.vertical, 5)
                }
                
                HStack{
                    Text("Sledovaný přestupek")
                        .font(.headline)
                    Spacer()
                    Text(offense.isOffenseTracked ? "Ano" : "Ne")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                .padding(.vertical, 5)
                
                
                HStack{
                    Text("Možnosti rešení")
                        .font(.headline)
                    Spacer()
                    Text(offense.wrappedResolveOptions)
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                .padding(.vertical, 5)
                
                VStack{
                    Text("Obsah příkazového bloku")
                        .font(.headline)
                    
                    Text(offense.wrappedFineExample)
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                .padding(.vertical, 5)
            }
            .padding(.vertical, 10)
        }
        .onAppear{
            customNote = offense.wrappedNote
            noteChanged = false
        }
        .onDisappear{
            if noteChanged {
                try? moc.save()
            }
            
        }
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    offense.isFavorited.toggle()
                    try? moc.save()
                } label: {
                    Image(systemName: offense.isFavorited ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                }
            }
            
            ToolbarItem(placement: .bottomBar) {
                TextField("Poznamka", text: $customNote)
                    .autocorrectionDisabled()
                    .onChange(of: customNote) { _ in
                        offense.note = customNote
                        noteChanged = true
                    }
            }
        }
        .padding()
    }
}

//CRIME
struct CrimeContent: View{
    @State var crime: CrimeModel? = nil
    
    var body: some View{
        Text("CRIME")
    }
}

//LAW EXTRACT
struct LawExtractContent: View{
    @State var lawExtract: LawExtractModel? = nil
    
    var body: some View{
        Text("LAW EXTRACT")
    }
}
