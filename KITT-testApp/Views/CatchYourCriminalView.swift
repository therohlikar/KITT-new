//
//  CatchYourCriminalView.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/11/23.
//

import SwiftUI

import SwiftUI
import Combine

enum PersonType{
    case innocent
    case criminal
}

class ImageModel{
    var id: UUID = UUID()
    var type: PersonType = .criminal
    var x: CGFloat = 50.0
    var y: CGFloat = 100.0
    var timer: AnyCancellable?
    
    init(type: PersonType, x: CGFloat, y: CGFloat, timer: AnyCancellable?) {
        self.type = type
        self.x = x
        self.y = y
        self.timer = timer
    }
}

class ImagePersonController: ObservableObject{
    @Published var images: [ImageModel] = []
    @Published var mistakes: Int = 0
    @Published var highestScore: Int = 0
    @Published var currentLevel: Double = 2.0
    @Published var finished: Bool = false
    
    private var maxDifficulty: Double = 0.2
    private var middleDifficulty: Double = 1.0
    private var disappearDuration: Double = 5.0
    var maxMistakes: Int = 10
    
    func begin(image: ImageModel){
        image.timer = Timer
                .publish(every: self.disappearDuration, on: .main, in: .common)
                .autoconnect()
                .sink { _ in
                    image.timer?.cancel()
                    self.updateScore(image)
                }
    }
    
    func updateScore(_ selectedType: ImageModel, clicked: Bool = false){
        if !self.finished {
            switch(selectedType.type){
            case .criminal:
                if clicked {
                    self.highestScore += 1
                }
                else{
                    self.mistakes += 1
                }
                
            case .innocent:
                if clicked{
                    self.mistakes += 1
                }
            }
            
            if self.mistakes >= self.maxMistakes {
                finishTheGame()
                return
            }
            
            self.harderDifficulty()
            
            selectedType.timer?.cancel()
            self.images.removeAll(where: {$0.id == selectedType.id})
        }
    }
    
    func harderDifficulty(){
        if self.currentLevel >= self.middleDifficulty{
            self.currentLevel -= 0.1
        }else if self.currentLevel >= self.maxDifficulty {
            self.currentLevel -= 0.03
        }
    }
    
    func generateNewPerson(){
        let randomX = CGFloat.random(in: 50...UIScreen.main.bounds.width - 50)
        let randomY = CGFloat.random(in: 100...UIScreen.main.bounds.height - 200)
        let randomInt = Int.random(in: 1...500)
        
        var type: PersonType = .criminal
        if randomInt < 100 {
            type = .innocent
        }
        let newImage = ImageModel(type: type, x: randomX, y: randomY, timer: nil)
        
        self.images.append(newImage)
        self.begin(image: newImage)
    }
    
    func finishTheGame(){
        self.finished = true
    }
    
    func restart(){
        for img in images{
            if img.timer != nil {
                img.timer?.cancel()
            }
        }
        
        self.images = []
        self.highestScore = 0
        self.mistakes = 0
        self.currentLevel = 2.0
        
        self.finished = false
    }
}

struct CatchYourCriminalView: View {
    @ObservedObject var ipController: ImagePersonController = ImagePersonController()
    @State private var timer:AnyCancellable? = nil
    
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea()

            VStack{
                HStack{
                    Text("SKÓRE: ")
                        .font(.caption)
                        
                    + Text("\(ipController.highestScore)")
                        .bold()
                        .font(.title)
                }
                
                HStack{
                    Text("CHYBY: ")
                        .font(.caption)

                    + Text("\(ipController.mistakes) / \(ipController.maxMistakes)")
                        .bold()
                        .foregroundColor(.red)
                }
                
                
                Text("RYCHLOST: \(ipController.currentLevel) / za sekudu")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .foregroundColor(.white)
            .position(x: UIScreen.main.bounds.width / 2, y: 30)
            
            ForEach(ipController.images, id: \.id) { image in
                Image(image.type == .innocent ? "innocent" : "criminal")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .position(x: image.x, y: image.y)
                    .onTapGesture {
                        ipController.updateScore(image, clicked: true)
                    }
            }
        }
        .onAppear{
            ipController.images = []
            newCriminal(ipController.currentLevel)
        }
        .onDisappear{
            ipController.finishTheGame()
            timer?.cancel()
        }
        .sheet(isPresented: $ipController.finished, onDismiss: {
            restartGame()
        }) {
            ZStack{
                Color.black.ignoresSafeArea()
                
                VStack{
                    HStack{
                        Text("NEJVYŠŠÍ SKÓRE: ")
                            
                        + Text("\(ipController.highestScore)")
                            .bold()
                            .font(.title)
                            .foregroundColor(.green)
                    }
                    .foregroundColor(.white)
                    
                    Text("RYCHLOST: \(ipController.currentLevel) / za sekundu")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
    }
    
    func newCriminal(_ duration: Double = 1.5){
        if !ipController.finished{
            ipController.generateNewPerson()
            
            timer = Timer
                .publish(every: duration, on: .main, in: .common)
                .autoconnect()
                .sink { _ in
                    newCriminal(ipController.currentLevel)
                }
        }
    }
    
    func restartGame(){
        ipController.restart()
        newCriminal()
    }
}

struct CatchYourCriminalView_Previews: PreviewProvider {
    static var previews: some View {
        CatchYourCriminalView()
    }
}
