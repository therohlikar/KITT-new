//
//  NewsView.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/8/23.
//

import SwiftUI

struct NewsView: View {
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "version", ascending: false)]) var news: FetchedResults<Version>
    
    var body: some View {
        List(news, id:\.self){ version in
            Section(version.wrappedVersion){
                Text(version.wrappedContent)
            }
        }
    }
}
