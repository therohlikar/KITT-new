//
//  RecentListView.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 7/12/23.
//

import SwiftUI

struct RecentListView: View {
    @EnvironmentObject var rvm: RecentViewModel
    @FetchRequest(sortDescriptors: []) var items: FetchedResults<ContentItem>
    
    var body: some View {
        ScrollView{
            if rvm.countRecentItems() > 0 {
                ForEach(rvm.recentItemsList, id:\.self){ recentItem in
                    if let item = items.first(where: { $0.id == recentItem.id }) {
                        NavigationLink {
                            ContentItemView(item: item)
                        } label: {
                            ContentItemRowView(item: item)
                        }
                    }
                }
            }
            else{
                Text("Prozatím nemáte žádnou historii prohlížení")
            }
        }
        .padding()
        .toolbar{
            if rvm.countRecentItems() > 0 {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        rvm.clearRecentItems()
                    } label: {
                        Text("Odstranit historii")
                    }
                }
            }
        }
    }
}

struct RecentListView_Previews: PreviewProvider {
    static var previews: some View {
        RecentListView()
    }
}
