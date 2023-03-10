//
//  CustomBadgeView.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/10/23.
//

import SwiftUI

struct CustomBadgeView: View {
    let imageSystem: String
    let backgroundColor: Color

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.clear
            Image(systemName: imageSystem)
                .font(.system(size: 10))
                .padding(5)
                .foregroundColor(.white)
                .background(backgroundColor)
                .clipShape(Circle())
                // custom positioning in the top-right corner
                .alignmentGuide(.top) { $0[.bottom] }
                .alignmentGuide(.trailing) { $0[.trailing] - $0.width * 0.25 }
        }
    }
}

struct CustomBadgeView_Previews: PreviewProvider {
    static var previews: some View {
        CustomBadgeView(imageSystem: "wifi.slash", backgroundColor: Color(red: 100, green: 0, blue: 0))
    }
}
