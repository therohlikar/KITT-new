//
//  ContentItemView.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/31/23.
//

import SwiftUI

struct ContentItemView: View {
    @Environment(\.managedObjectContext) var moc
    
    @ObservedObject var item: ContentItem
    
    @State private var showingLinks: Bool = false
    @State private var showingMiranda: Bool = false
    @State private var showPanel: Bool = false
    
    @State private var favoriteToggle: Bool = false
    
    var body: some View {
        VStack{
            Text(item.wrappedTitle)
                .font(Font.custom("Raleway-Black", size: 36))
            
            if !item.wrappedKeywords.isEmpty {
                Text("(\(item.wrappedKeywords))")
                    .font(Font.custom("Raleway-Light", size: 10))
                    .foregroundColor(.secondary)
            }
            
            ScrollView{
                if !item.wrappedWarning.isEmpty {
                    Text(item.wrappedWarning)
                        .font(Font.custom("Raleway-Medium", size: 12))
                        .padding(7)
                        .frame(width: 350)
                        .background(
                            Color(#colorLiteral(red: 0.6247290969, green: 0, blue: 0, alpha: 1))
                        )
                        .padding(.vertical, 5)
                        .cornerRadius(8)
                }
                
                //CONTENT
                if !item.wrappedContent.isEmpty{
                    ForEach(item.contentList, id: \.title) { content in
                        VStack(alignment: .leading){
                            Text(content.title)
                                .font(Font.custom("Raleway-Black", size: 18))
                            
                            if !content.link.isEmpty {
                                Link(destination: URL(string: content.link)!) {
                                    Text(content.link)
                                        .font(Font.custom("Raleway-Light", size: 10))
                                }
                            }
                            
                            Text(content.content)
                                .font(Font.custom("Raleway-Regular", size: 14))
                                .padding(.leading, 5)
                        }
                        .padding(.vertical, 10)
                    }
                }
                
                if !item.wrappedSanctions.isEmpty {
                    VStack(alignment: .leading){
                        Text("sankce".uppercased())
                            .font(Font.custom("Raleway-Black", size: 18))
                        
                        VStack{
                            ForEach(item.sanctionList, id: \.title) { sanction in
                                HStack{
                                    Text(sanction.title.uppercased())
                                        .fontWeight(.semibold)
                                    Spacer()
                                    Text(sanction.content)
                                }
                                .font(Font.custom("Raleway-Regular", size: 14))
                            }
                        }
                        .padding(.leading, 5)
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
                            if !showingLinks {
                                showPanel.toggle()
                            }
                            showingLinks = false
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                showingMiranda.toggle()
                            }
                        }
                    } label: {
                        Text("POUČENÍ")
                            .fontWeight(showingMiranda ? .bold : .thin)
                            .foregroundColor(.primary)
                    }
                    .opacity(item.wrappedMiranda.isEmpty ? 0.0 : 1.0)
                    .disabled(item.wrappedMiranda.isEmpty)
                    
                    
                    Button {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            if !showingMiranda {
                                showPanel.toggle()
                            }
                            
                            showingMiranda = false
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                showingLinks.toggle()
                            }
                        }
                    } label: {
                        Text("ODKAZY")
                            .fontWeight(showingLinks ? .bold : .thin)
                            .foregroundColor(.primary)
                    }
                    .opacity(item.wrappedLinks.isEmpty ? 0.0 : 1.0)
                    .disabled(item.wrappedLinks.isEmpty)
                }
                .font(Font.custom("Raleway-Thin", size: 14))
                
                if showPanel {
                    ScrollView{
                        VStack{
                            if showingLinks {
                                VStack(alignment: .leading){
                                    ForEach(item.linkList, id: \.title) { link in
                                        HStack{
                                            Text(link.title.uppercased())
                                                .fontWeight(.semibold)
                                            Spacer()
                                            Link(destination: URL(string: link.link)!) {
                                                Text(link.link)
                                            }
                                        }
                                        .padding(.bottom, 5)
                                    }
                                }
                                .font(Font.custom("Raleway-Regular", size: 12))
                                .padding(.vertical, 12)
                            }
                            
                            if showingMiranda {
                                Text(item.wrappedMiranda)
                                    .font(Font.custom("Raleway-Regular", size: 12))
                                    .padding(.vertical, 12)
                            }
                        }
                        
                        .padding()
                    }
                }
            }
            .padding(.top, 10)
            
            Spacer()
        }
        .navigationTitle("")
        .navigationBarTitle("")
        .padding(10)
        .toolbar{
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
                                
                                try? moc.save()
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                withAnimation(.linear(duration: 0.2)) {
                                    favoriteToggle = false
                                }
                            }
                        }
                    }
            }
        }
    }
}

struct ContentItemView_Previews: PreviewProvider {
    static var previews: some View {
        ContentItemView(item: ContentItem())
            .preferredColorScheme(.dark)
    }
}
