//
//  ParagraphModel.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/3/23.
//

import Foundation

public struct ParagraphModel{
    var lawNumber: String = ""
    var lawYear: String = ""
    var paragraphNumber: String = ""
    var paragraphSection: String = ""
    var paragraphLetter: String = ""
    var paragraphPoint: String = ""
    
    init(lawNumber: String, lawYear: String, paragraphNumber: String, paragraphSection: String, paragraphLetter: String, paragraphPoint: String) {
        self.lawNumber = lawNumber
        self.lawYear = lawYear
        self.paragraphNumber = paragraphNumber
        self.paragraphSection = paragraphSection
        self.paragraphLetter = paragraphLetter
        self.paragraphPoint = paragraphPoint
    }
    
    func toString(stripped: Bool = false) -> String {
        var fullString = ""
        if !lawNumber.isEmpty {
            fullString += "zákon č. " + lawNumber
        }
        
        if !lawYear.isEmpty {
            fullString += "/" + lawYear + " Sb."
        }
        if !stripped {
            if !paragraphNumber.isEmpty {
                fullString += " § " + paragraphNumber
            }
            
            if !paragraphSection.isEmpty {
                fullString += " odst. " + paragraphSection
            }
            
            if !paragraphLetter.isEmpty {
                fullString += " písm. " + paragraphLetter + ")"
            }
            
            if !paragraphPoint.isEmpty {
                fullString += " bod " + paragraphPoint + "."
            }
        }
        return fullString
    }

    func generateLawLink() -> URL{
        var link: String = "https://www.zakonyprolidi.cz/cs/"
        if !lawYear.isEmpty {
            link += lawYear
        }
        
        if !lawNumber.isEmpty {
            link += "-" + lawNumber
        }
        if !paragraphNumber.isEmpty {
            link += "#p" + paragraphNumber
        }
        
        if !paragraphSection.isEmpty {
            link += "-" + paragraphSection
        }
        
        if !paragraphLetter.isEmpty {
            link += "-" + paragraphLetter
        }
        
        if !paragraphPoint.isEmpty {
            link += "-" + paragraphPoint
        }
        return URL(string: link)!
    }
}
