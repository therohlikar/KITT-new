//
//  MailView.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/8/23.
//

import SwiftUI
import MessageUI

struct MailView: UIViewControllerRepresentable {
    var content: String
    var to: String
    var subject: String
    var isHTML: Bool
    
    typealias UIViewControllerType = MFMailComposeViewController
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let view = MFMailComposeViewController()
        view.mailComposeDelegate = context.coordinator
        view.setToRecipients([to])
        view.setSubject(subject)
        view.setMessageBody(content, isHTML: isHTML)
        
        return view
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    
    class Coordinator : NSObject, MFMailComposeViewControllerDelegate{
        var parent : MailView
        
        init(_ parent: MailView){
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true)
        }
    }
}
