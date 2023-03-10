//
//  NewsView.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/8/23.
//

import SwiftUI

struct NewsView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "version", ascending: false)]) var news: FetchedResults<Version>
    
    var body: some View {
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
        .onDisappear{
            try? moc.save()
        }
    }
}
