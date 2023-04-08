//
//  ContentItemRowView.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 4/7/23.
//

import SwiftUI

struct ContentItemRowView: View {
    @ObservedObject var item: ContentItem
    
    var body: some View {
        HStack{
            Text(item.typeToLabel)
                .fontWeight(.semibold)
                .background(
                    Rectangle()
                        .frame(minWidth: 100, minHeight: 100)
                        .foregroundColor(item.typeToColor)
                )
                .padding(.horizontal, 25)
            Spacer()
            VStack{
                Text(item.wrappedTitle)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            Spacer()
        }
        .foregroundColor(.primary)
        .frame(minWidth: 310, minHeight: 20)
        .padding(8)
        .background(.regularMaterial)
        .cornerRadius(7)
    }
}
