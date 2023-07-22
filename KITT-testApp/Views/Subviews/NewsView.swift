//
//  NewsView.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/8/23.
//

import SwiftUI

struct NewsView: View {
    @EnvironmentObject var dc: DataController
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "version", ascending: false)]) var news: FetchedResults<Version>
    
    var body: some View {
        VStack{
            Button {
                self.readAll()
            } label: {
                Text("Označit vše za přečtené")
            }

            
            List(news, id:\.self){ version in
                Section {
                    Text(version.wrappedContent)
                        .swipeActions {
                            Button {
                                version.read = true
                            } label: {
                                Label("", systemImage: "envelope.open.fill")
                                    .labelsHidden()
                            }
                            .tint(.blue)
                        }
                } header: {
                    HStack{
                        Image(systemName: version.read ? "envelope.open.fill" : "envelope.fill")
                            .foregroundColor(.blue)
                        Text(version.wrappedVersion)
                            .font(.headline)
                    }
                }
            }
        }
        .onDisappear{
            dc.save()
        }
    }
    
    func readAll() {
        for item in news {
            if !item.read {
                item.read = true
            }
        }
    }
}
