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
        }else if contentItem is Crime{
            CrimeContent(crime: contentItem as! Crime)
        }else if contentItem is LawExtractModel{
            LawExtractContent(lawExtract: contentItem as? LawExtractModel)
        }
    }
}

//OFFENSE
struct OffenseContent: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var sc: SettingsController
    @ObservedObject var offense: Offense
    
    @State private var customNote = ""
    @State private var noteChanged = false
    @State private var sendingMail = false
    
    @State private var mailTo:String = Bundle.main.object(forInfoDictionaryKey: "MAIL_TO") as! String
    
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
            if noteChanged && sc.settings.saveNotes {
                try? moc.save()
            }
        }
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    sendingMail.toggle()
                } label: {
                    Image(systemName: "exclamationmark.bubble.fill")
                }
                .disabled(mailTo.isEmpty ? true : false)
            }
            
            
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
                TextField("Poznámka", text: $customNote)
                    .autocorrectionDisabled()
                    .onChange(of: customNote) { _ in
                        offense.note = customNote
                        noteChanged = true
                    }
                    .onSubmit {
                        offense.note = customNote
                        try? moc.save()
                    }
            }
        }
        .sheet(isPresented: $sendingMail) {
            let content:String = """
                                <b>NÁZEV</b>: \(offense.wrappedTitle)<br>
                                <b>ZÁKONNÉ ZNĚNÍ</b>: \(offense.wrappedContent)<br>
                                <b>PARAGRAF</b>: <a href=\(offense.paragraphModel.generateLawLink())>\(offense.paragraphModel.toString())</a><br>
                                <b>PŘESTUPEK</b>: \(offense.wrappedViolationParagraph.isEmpty ? "NENÍ" : offense.violationParagraphModel.toString()) <br>
                                <b>PŘÍKLAD PŘÍKAZOVÉHO BLOKU</b>: \(offense.wrappedFineExample)<br>
                                <b>SKUPINY</b>: \(offense.groupArray.map({$0.wrappedTitle}).joined(separator: ", "))<br>
                                """
            

            MailView(content: content, to: mailTo, subject: "Chyba ve znění: " + offense.paragraphModel.toString() + " [" + offense.wrappedParagraph + "]", isHTML: true)
        }
        .padding()
    }
}

//CRIME
struct CrimeContent: View{
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var sc: SettingsController
    @ObservedObject var crime: Crime
    
    @State private var customNote = ""
    @State private var noteChanged = false
    @State private var sendingMail = false
    
    @State private var mailTo:String = Bundle.main.object(forInfoDictionaryKey: "MAIL_TO") as! String
    
    var body: some View{
        ScrollView{
            VStack{
                Text(crime.wrappedTitle)
                    .font(.headline)
                Link("\(crime.paragraphModel.toString())",
                     destination: crime.paragraphModel.generateLawLink())
                
                Text(crime.wrappedContent)
                    .font(.caption)
                    .padding(.top, 10)
            }.padding(.vertical, 10)
            
            
            VStack{
                VStack{
                    Text("Příklad skutku")
                        .font(.headline)
                    
                    Text(crime.wrappedCrimeExample)
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                .padding(.vertical, 5)
            }
            .padding(.vertical, 10)
        }
        .onAppear{
            customNote = crime.wrappedNote
            noteChanged = false
        }
        .onDisappear{
            if noteChanged && sc.settings.saveNotes {
                try? moc.save()
            }
        }
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    sendingMail.toggle()
                } label: {
                    Image(systemName: "exclamationmark.bubble.fill")
                }
                .disabled(mailTo.isEmpty ? true : false)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    crime.isFavorited.toggle()
                    try? moc.save()
                } label: {
                    Image(systemName: crime.isFavorited ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                }
            }
            
            ToolbarItem(placement: .bottomBar) {
                TextField("Poznámka", text: $customNote)
                    .autocorrectionDisabled()
                    .onChange(of: customNote) { _ in
                        crime.note = customNote
                        noteChanged = true
                    }
                    .onSubmit {
                        crime.note = customNote
                        try? moc.save()
                    }
            }
        }
        .sheet(isPresented: $sendingMail) {
            let content:String = """
                                <b>NÁZEV</b>: \(crime.wrappedTitle)<br>
                                <b>ZÁKONNÉ ZNĚNÍ</b>: \(crime.wrappedContent)<br>
                                <b>PARAGRAF</b>: <a href=\(crime.paragraphModel.generateLawLink())>\(crime.paragraphModel.toString())</a><br>
                                <b>PŘÍKLAD SKUTKU</b>: \(crime.wrappedCrimeExample)<br>
                                <b>SKUPINY</b>: \(crime.groupArray.map({$0.wrappedTitle}).joined(separator: ", "))<br>
                                """

            MailView(content: content, to: mailTo, subject: "Chyba ve znění: " + crime.paragraphModel.toString() + " [" + crime.wrappedParagraph + "]", isHTML: true)
        }
        .padding()
    }
}

//LAW EXTRACT
struct LawExtractContent: View{
    @State var lawExtract: LawExtractModel? = nil
    
    var body: some View{
        Text("LAW EXTRACT")
    }
}
