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
    let size: CGFloat
    let hPosition: [VerticalAlignment]
    let vPosition: [HorizontalAlignment]
    let hOffset: Double
    let vOffset: Double

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.clear
            Image(systemName: imageSystem)
                .font(.system(size: size))
                .padding(5)
                .foregroundColor(.white)
                .background(backgroundColor)
                .clipShape(Circle())
                // custom positioning in the top-right corner
                .alignmentGuide(vPosition[0]) { $0[vPosition[1]] - $0.height * hOffset }
                .alignmentGuide(hPosition[0]) { $0[hPosition[1]] - $0.width * vOffset }
        }
    }
}

struct CustomBadgeView_Previews: PreviewProvider {
    static var previews: some View {
        Image(systemName: "arrow.triangle.2.circlepath")
            .overlay {
                CustomBadgeView(imageSystem: "wifi.slash", backgroundColor: Color(red: 100, green: 0, blue: 0), size: 0, hPosition: [.top, .bottom], vPosition: [.trailing, .trailing], hOffset: 1.5, vOffset: 0.7)
            }
        
    }
}
