//
//  GuideViewModel.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 7/13/23.
//

import Foundation

class GuideViewModel: ObservableObject {
    @Published var maxGuideStep: Int = 7
    @Published var currentGuideStep: Int = 1
    
    init(){
        currentGuideStep = UserDefaults.standard.integer(forKey: "currentGuideStep")
    }
    public func startGuide(){
        currentGuideStep = 1
    }
    
    public func endGuide() {
        currentGuideStep = maxGuideStep + 1

        self.saveCurrentGuideStep()
    }
    
    public func saveCurrentGuideStep(){
        UserDefaults.standard.setValue(currentGuideStep, forKey: "currentGuideStep")
    }
    
    public func beginGuide() -> Bool {
        if self.currentGuideStep <= self.maxGuideStep {
            return true
        }
        return false
    }
    
    public func nextStep() {
        if self.currentGuideStep >= self.maxGuideStep {
            self.endGuide()
        }else{
            self.saveCurrentGuideStep()
        }
        
        self.currentGuideStep = self.currentGuideStep + 1
    }
}
