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
                    .scaledToFit()
                    .padding(.horizontal, 25)
                    .padding(.vertical, 2)
            }else{
                Rectangle()
                    .frame(width: 10)
                    .ignoresSafeArea(edges: [.leading, .top, .bottom])
                    .foregroundColor(item.typeToColor)
                    .roundedCorner(4, corners: .bottomLeft)
                    .roundedCorner(4, corners: .topLeft)
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
        .frame(height: 50)
        .background(
            Color("ItemRowMenuColor")
        )
    }
}
