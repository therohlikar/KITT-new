//
//  ContentSubView.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/3/23.
//

import SwiftUI
import MessageUI

struct ContentSubView: View {
    @State var contentItem: Any? = nil

    var body: some View {
        if contentItem is Offense {
            OffenseContent(offense: contentItem as! Offense)
        }else if contentItem is Crime{
            CrimeContent(crime: contentItem as! Crime)
        }else if contentItem is LawExtract{
            LawExtractContent(le: contentItem as! LawExtract)
        }
    }
}

//OFFENSE
struct OffenseContent: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var sc: SettingsController
    @EnvironmentObject var networkController: NetworkController
    @ObservedObject var offense: Offense
    
    @State private var canSendMail: Bool = false
    @State private var customNote = ""
    @State private var noteChanged = false
    @State private var sendingMail = false
    @FocusState private var noteFocused:Bool

    @State private var mailTo:String = Bundle.main.object(forInfoDictionaryKey: "MAIL_TO") as! String
    
    var body: some View{
        ScrollView{
            if !offense.wrappedWarning.isEmpty {
                VStack(alignment: .leading){
                    Text(offense.wrappedWarning)
                }
                .padding(3)
                .frame(width: 350, alignment: .leading)
                .padding(2)
                .background(Color("NetworkErrorColor"))
                .cornerRadius(6)
                .font(.caption)
                .foregroundColor(.white)
            }
            
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
                
                if !offense.wrappedFineExample.isEmpty{
                    VStack{
                        Text("Obsah příkazového bloku")
                            .font(.headline)
                        
                        Text(offense.wrappedFineExample)
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                    .padding(.vertical, 5)
                }
                
                if !offense.wrappedMiranda.isEmpty{
                    VStack{
                        Text("Poučení")
                            .font(.headline)
                        
                        Text(offense.wrappedMiranda)
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                    .padding(.vertical, 5)
                }
                
                VStack{
                    TextField("Poznámka", text: $customNote, axis: .vertical)
                        .autocorrectionDisabled()
                        .focused($noteFocused)
                        .textFieldStyle(.roundedBorder)
                        .onChange(of: customNote) { _ in
                            offense.note = customNote
                            noteChanged = true
                        }
                        .onSubmit {
                            offense.note = customNote
                            try? moc.save()
                        }
                }
                .padding(.vertical, 5)
            }
            .padding(.vertical, 10)
        }
        .onTapGesture{
            noteFocused = false
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
                HStack{
                    Text("Mail aplikace nelze spustit")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .opacity(!canSendMail ? 1.0 : 0.0)
                    
                    Button {
                        sendingMail.toggle()
                    } label: {
                        Image(systemName: "exclamationmark.bubble.fill")
                    }
                    .disabled(!canSendMail ? true : false)
                }
                .onAppear{
                    canSendMail = networkController.connected && !mailTo.isEmpty && MFMailComposeViewController.canSendMail()
                }
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
    @EnvironmentObject var networkController: NetworkController
    @ObservedObject var crime: Crime
    
    @State private var canSendMail: Bool = false
    @State private var customNote = ""
    @State private var noteChanged = false
    @State private var sendingMail = false
    @FocusState private var noteFocused:Bool
    
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
                if !crime.wrappedCrimeExample.isEmpty {
                    VStack{
                        Text("Příklad skutku")
                            .font(.headline)
                        
                        Text(crime.wrappedCrimeExample)
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                    .padding(.vertical, 5)
                }
            }
            .padding(.vertical, 10)
            
            VStack{
                TextField("Poznámka", text: $customNote, axis: .vertical)
                    .autocorrectionDisabled()
                    .focused($noteFocused)
                    .textFieldStyle(.roundedBorder)
                    .onChange(of: customNote) { _ in
                        crime.note = customNote
                        noteChanged = true
                    }
                    .onSubmit {
                        crime.note = customNote
                        try? moc.save()
                    }
            }
            .padding(.vertical, 5)
        }
        .onTapGesture{
            noteFocused = false
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
                HStack{
                    Text("Mail aplikace nelze spustit")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .opacity(!canSendMail ? 1.0 : 0.0)
                    
                    Button {
                        sendingMail.toggle()
                    } label: {
                        Image(systemName: "exclamationmark.bubble.fill")
                    }
                    .disabled(!canSendMail ? true : false)
                }
                .onAppear{
                    canSendMail = networkController.connected && !mailTo.isEmpty && MFMailComposeViewController.canSendMail()
                }
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
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var sc: SettingsController
    @EnvironmentObject var networkController: NetworkController
    @ObservedObject var le: LawExtract
    
    @State private var canSendMail: Bool = false
    @State private var customNote = ""
    @State private var noteChanged = false
    @State private var sendingMail = false
    @FocusState private var noteFocused:Bool
    
    @State private var mailTo:String = Bundle.main.object(forInfoDictionaryKey: "MAIL_TO") as! String
    
    var body: some View{
        ScrollView{
            VStack{
                Text(le.wrappedTitle)
                    .font(.headline)
                Link("\(le.paragraphModel.toString())",
                     destination: le.paragraphModel.generateLawLink())
                
                Text(le.wrappedContent)
                    .font(.caption)
                    .padding(.top, 10)
                
                VStack{
                    TextField("Poznámka", text: $customNote, axis: .vertical)
                        .autocorrectionDisabled()
                        .focused($noteFocused)
                        .textFieldStyle(.roundedBorder)
                        .onChange(of: customNote) { _ in
                            le.note = customNote
                            noteChanged = true
                        }
                        .onSubmit {
                            le.note = customNote
                            try? moc.save()
                        }
                }
                .padding(.vertical, 5)
            }.padding(.vertical, 10)
        }
        .onTapGesture{
            noteFocused = false
        }
        .onAppear{
            customNote = le.wrappedNote
            noteChanged = false
        }
        .onDisappear{
            if noteChanged && sc.settings.saveNotes {
                try? moc.save()
            }
        }
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack{
                    Text("Mail aplikace nelze spustit")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .opacity(!canSendMail ? 1.0 : 0.0)
                    
                    Button {
                        sendingMail.toggle()
                    } label: {
                        Image(systemName: "exclamationmark.bubble.fill")
                    }
                    .disabled(!canSendMail ? true : false)
                }
                .onAppear{
                    canSendMail = networkController.connected && !mailTo.isEmpty && MFMailComposeViewController.canSendMail()
                }
                
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    le.isFavorited.toggle()
                    try? moc.save()
                } label: {
                    Image(systemName: le.isFavorited ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                }
            }
        }
        .sheet(isPresented: $sendingMail) {
            let content:String = """
                                <b>NÁZEV</b>: \(le.wrappedTitle)<br>
                                <b>ZÁKONNÉ ZNĚNÍ</b>: \(le.wrappedContent)<br>
                                <b>PARAGRAF</b>: <a href=\(le.paragraphModel.generateLawLink())>\(le.paragraphModel.toString())</a><br>
                                <b>SKUPINY</b>: \(le.groupArray.map({$0.wrappedTitle}).joined(separator: ", "))<br>
                                """

            MailView(content: content, to: mailTo, subject: "Chyba ve znění: " + le.paragraphModel.toString() + " [" + le.wrappedParagraph + "]", isHTML: true)
        }
        .padding()
    }
}
