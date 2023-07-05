//
//  ContentItemView.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/31/23.
//

import SwiftUI
import MessageUI

struct ContentItemView: View {
    
    
    enum panelShowed {
        case none, miranda, links, note, example
    }
    
    @FetchRequest(sortDescriptors: []) var items: FetchedResults<ContentItem>
    
    @Environment(\.managedObjectContext) var moc
    
    @ObservedObject var item: ContentItem
    
    @State private var currentPanel: panelShowed = .none
    @State private var showPanel: Bool = false
    
    @State private var favoriteToggle: Bool = false
    @State private var customNote: String = ""
    
    @State private var reporting: Bool = false
    
    @State private var mailTo:String = Bundle.main.object(forInfoDictionaryKey: "MAIL_TO") as! String
    
    var body: some View {
        VStack{
            
            VStack(alignment: .center){
                Text(item.wrappedTitle)
                    .font(Font.custom("Roboto-Black", size: 18))
                    .multilineTextAlignment(.center)
                
                Text("\(item.wrappedGroup) - \(item.wrappedSubgroup)")
                    .font(Font.custom("Roboto-Light", size: 10))
                    .foregroundColor(.secondary)
            }
            
            
            ScrollView{
                if !item.wrappedWarning.isEmpty {
                    HStack{
                        Text("POZOR")
                            .fontWeight(.black)
                        Text(item.wrappedWarning)
                        Spacer()
                    }
                    .font(Font.custom("Roboto-Medium", size: 10))
                    .foregroundColor(.white)
                    .padding(7)
                    .frame(minWidth: 310)
                    .background(
                        Color(#colorLiteral(red: 0.6247290969, green: 0, blue: 0, alpha: 0.8))
                    )
                    .padding(.vertical, 5)
                    .cornerRadius(10)
                    
                }
                
                //CONTENT
                if item.wrappedType == "sign" {
                    Image(uiImage: (UIImage(named: "\(item.wrappedId).webp")!))
                        .resizable()
                        .frame(width: 200, height: 180)
                        .padding(.horizontal, 25)
                }
                
                if !item.wrappedContent.isEmpty{
                    ForEach(item.contentList, id: \.title) { content in
                        VStack{
                            if !content.title.isEmpty {
                                VStack(alignment: .leading){
                                    HStack{
                                        Text(content.title)
                                            .fontWeight(.semibold)
                                            .textSelection(.enabled)
                                        
                                        Spacer()
                                    }
                                    .frame(minWidth: 310)

                                    if !content.link.isEmpty {
                                        Link(destination: URL(string: content.link)!) {
                                            Text(content.link)
                                                .font(Font.custom("Roboto-Light", size: 10))
                                                .foregroundColor(.secondary)
                                                .textSelection(.enabled)
                                        }
                                    }
                                }
                                .padding(10)
                                .background(item.typeToColor)
                                .cornerRadius(7)
                            }
                            
                            HStack{
                                Text(content.content)
                                    .font(Font.custom("Roboto-Regular", size: 14))
                                    .textSelection(.enabled)
                                    .lineSpacing(5)
                                
                                Spacer()
                            }
                            .padding()
                            .frame(minWidth: 310)
                            .background(
                                item.typeToColor.opacity(0.3)
                            )
                            .cornerRadius(7)
                        }
                    }
                }
                
                if !item.wrappedSanctions.isEmpty {
                    VStack(alignment: .leading){
                        HStack{
                            Text("SANKCE")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        .padding(10)
                        .frame(minWidth: 310, minHeight: 20)
                        .background(item.typeToColor)
                        .cornerRadius(7)
                        
                        
                        VStack{
                            ForEach(item.sanctionList, id: \.title) { sanction in
                                HStack{
                                    Text(sanction.title.uppercased())
                                        .fontWeight(.semibold)
                                    Spacer()
                                    Text(sanction.content)
                                }
                                .font(Font.custom("Roboto-Regular", size: 14))
                                
                                Rectangle()
                                    .fill(Color.secondary)
                                    .frame(width: 300, height: 2)
                                    .opacity(0.5)
                            }
                        }
                        .padding()
                        .background(
                            item.typeToColor.opacity(0.3)
                        )
                        .cornerRadius(7)
                    }
                    .padding(.vertical, 10)
                }
            }
            .opacity(showPanel ? 0.3 : 1.0)
            .disabled(showPanel)
            
            VStack{
                HStack{
                    Spacer()
                    
                    Button {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            if currentPanel == .none || currentPanel == .note {
                                showPanel.toggle()
                            }
                            
                            currentPanel = .none
                            
                            if showPanel {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    currentPanel = .note
                                }
                            }
                        }
                    } label: {
                        Text("POZNÁMKA")
                            .fontWeight(currentPanel == .note ? .bold : .thin)
                            .foregroundColor(.primary)
                    }
                    
                    if !item.wrappedExample.isEmpty {
                        Button {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                if currentPanel == .none || currentPanel == .example {
                                    showPanel.toggle()
                                }
                                
                                currentPanel = .none
                                
                                if showPanel {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        currentPanel = .example
                                    }
                                }
                            }
                        } label: {
                            Text("PŘÍKLAD UŽITÍ")
                                .fontWeight(currentPanel == .example ? .bold : .thin)
                                .foregroundColor(.primary)
                        }
                    }

                    if !item.wrappedMiranda.isEmpty {
                        Button {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                if currentPanel == .none || currentPanel == .miranda {
                                    showPanel.toggle()
                                }
                                
                                currentPanel = .none
                                
                                if showPanel {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        currentPanel = .miranda
                                    }
                                }
                            }
                        } label: {
                            Text("POUČENÍ")
                                .fontWeight(currentPanel == .miranda ? .bold : .thin)
                                .foregroundColor(.primary)
                        }
                    }
                    
                    
                    
                    if !item.wrappedLinks.isEmpty {
                        Button {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                if currentPanel == .none || currentPanel == .links {
                                    showPanel.toggle()
                                }
                                
                                currentPanel = .none
                                
                                if showPanel {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        currentPanel = .links
                                    }
                                }
                            }
                        } label: {
                            Text("ODKAZY")
                                .fontWeight(currentPanel == .links ? .bold : .thin)
                                .foregroundColor(.primary)
                        }
                    }
                }
                .font(Font.custom("Roboto-Thin", size: 14))
                
                if showPanel {
                    ScrollView{
                        VStack{
                            if currentPanel == .links {
                                VStack(alignment: .leading){
                                    ForEach(item.linkList, id: \.title) { link in
                                        HStack{
                                            Text(link.title.uppercased())
                                                .fontWeight(.semibold)
                                            Spacer()
                                            
                                            if link.link.hasPrefix("in:") {
                                                NavigationLink {
                                                    let str = link.link.replacingOccurrences(of: "in:", with: "")
                                                    if let found = items.first(where: { $0.id == str }) {
                                                        ContentItemView(item: found)
                                                    }
                                                    
                                                } label: {
                                                    Text("PŘEMÍSTIT SE V APLIKACI")
                                                }
                                            }else {
                                                Link(destination: URL(string: link.link)!) {
                                                    Text(link.link)
                                                        .textSelection(.enabled)
                                                }
                                            }
                                            
                                        }
                                        .padding(.bottom, 5)
                                    }
                                }
                                .font(Font.custom("Roboto-Regular", size: 12))
                                .padding(.vertical, 12)
                            }
                            
                            if currentPanel == .miranda {
                                Text(item.wrappedMiranda)
                                    .font(Font.custom("Roboto-Regular", size: 12))
                                    .padding(.vertical, 12)
                                    .textSelection(.enabled)
                                    
                            }
                            
                            if currentPanel == .example {
                                Text(item.wrappedExample)
                                    .font(Font.custom("Roboto-Regular", size: 12))
                                    .padding(.vertical, 12)
                                    .textSelection(.enabled)
                            }
                            
                            if currentPanel == .note {
                                TextField("Poznámka", text: $customNote, axis: .vertical)
                                    .textFieldStyle(.roundedBorder)
                                    .font(Font.custom("Roboto-Regular", size: 12))
                                    .textSelection(.enabled)

                            }
                        }
                        
                        .padding()
                    }
                }
            }
            .padding(.top, 10)
            
            Spacer()
        }
        .onTapGesture(perform: {
            UIApplication.shared.endEditing()
        })
        .navigationTitle("")
        .navigationBarTitle("")
        .padding(20)
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                if !MFMailComposeViewController.canSendMail() {
                    Link(destination: URL(string: "mailto:\(mailTo)")!) {
                        Image(systemName: "exclamationmark.bubble")
                            .font(.title3)
                            .foregroundColor(.primary)
                    }
                }else {
                    Image(systemName: "exclamationmark.bubble")
                        .font(.title3)
                        .onTapGesture {
                            reporting.toggle()
                        }
                        .foregroundColor(.primary)
                }
                
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Image(systemName: item.favorited ? "heart.fill" : "heart")
                    .font(.title3)
                    .foregroundColor(Color(#colorLiteral(red: 0.6247290969, green: 0, blue: 0, alpha: 1)))
                    .scaleEffect(favoriteToggle ? 1.35 : 1.0)
                    .onTapGesture {
                        if !favoriteToggle{
                            withAnimation(.linear(duration: 0.2)) {
                                favoriteToggle = true
                                item.favorited.toggle()
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                withAnimation(.linear(duration: 0.2)) {
                                    favoriteToggle = false
                                }
                            }
                        }
                    }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                if let url = URL(string: "kittapp://id=\(item.wrappedId)") {
                    ShareLink(item: url)
                }
            }
        }
        .onAppear{
            customNote = item.wrappedNote
        }
        .onDisappear{
            item.note = customNote
            
            try? moc.save()
        }
        .sheet(isPresented: $reporting) {
             let content:String = """
                                 <b>ID</b>: <a href='kittapp://id=\(item.wrappedId)'>\(item.wrappedId)</a><br>
                                 <b>TYP</b>: \(item.wrappedType)<br>
                                 <b>NÁZEV</b>: \(item.wrappedTitle)<br>
                                 <b>VAŠE PŘIPOMÍNKA</b>: <br>
                                 """


            MailView(content: content, to: mailTo, subject: "PŘIPOMÍNKA: \(item.wrappedId)", isHTML: true)
         }
    }
                                                                                      
}

struct ContentItemView_Previews: PreviewProvider {
    static var previews: some View {
        ContentItemView(item: ContentItem())
            .preferredColorScheme(.dark)
    }
}
