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
            if item.wrappedType == "sign" && UIImage(named: "\(item.wrappedId).webp") != nil {
                Image(uiImage: (UIImage(named: "\(item.wrappedId).webp")!))
                    .resizable()
                    .frame(width: 100, height: 90)
                    .padding(.horizontal, 25)
            }else{
                Text(item.typeToLabel)
                    .fontWeight(.semibold)
                    .background(
                        Rectangle()
                            .frame(minWidth: 100, minHeight: 100)
                            .foregroundColor(item.typeToColor)
                    )
                    .padding(.horizontal, 25)
            }
            
            Spacer()
            VStack{
                Text(item.wrappedTitle)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .padding(.leading, 5)
            Spacer()
        }
        .foregroundColor(.primary)
        .frame(minWidth: 310, minHeight: 50)
        .padding(8)
        .background(.regularMaterial)
        .cornerRadius(7)
    }
}
