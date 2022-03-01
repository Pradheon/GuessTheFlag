//
//  ContentView.swift
//  JoshanRai-GuessTheFlag
//
//  Created by Joshan Rai on 2/2/22.
//

import SwiftUI

struct FlagImage: View {
    var imgFileName: String
    
    var body: some View {
        Image(imgFileName)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var gameOver = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var nQuestionsAsked = 0
    @State var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State var correctAnswer = Int.random(in: 0...2)
    @State private var animationOpacity = 1.0
    @State private var animationCount = 0.0
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            /*
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()*/
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .foregroundColor(.black)
                            .font(.largeTitle.weight(.semibold))
                    }
                    ForEach(0..<3) { number in
                        Button {
                            withAnimation {
                                flagTapped(number)
                            }
                        } label: {
                            FlagImage(imgFileName: countries[number])
                        }
                        // Day 34 - Challege 1 - rotate 360 on y-axis
                        .rotation3DEffect(number == correctAnswer ? .degrees(animationCount) : .degrees(0), axis: (x: 0, y: 1, z: 0))
                        // Day 34 - Challege 3 - rotate 360 on x-axis
                        .rotation3DEffect(number != correctAnswer ? .degrees(animationCount) : .degrees(0), axis: (x: 2, y: 0, z: 0))
                        // Day 34 - Challege 2 - opacity to 25%
                        .opacity(number != correctAnswer ? animationOpacity : 1.0)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
                
                Text("Progess: \(nQuestionsAsked) of 8 Questions")
                    .foregroundColor(.white)
                    .font(.headline)
                
                Spacer()
            }
            
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score) correct answers")
                .foregroundColor(.white)
                .font(.title.bold())
        }
        
        .alert(scoreTitle, isPresented: $gameOver) {
            Button("Reset", action: reset)
        } message: {
            Text("Try beating your score!")
                .foregroundColor(.white)
                .font(.title.bold())
        }
        
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct!"
            score += 1
            withAnimation(.easeInOut(duration: 1.0)) {
                animationCount += 360
            }
        } else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
            score -= 1
            withAnimation(.easeInOut) {
                animationCount += 360
            }
        }
        
        withAnimation {
            animationOpacity = 0.25
        }
        
        nQuestionsAsked += 1
        showingScore = true
    }
    
    func askQuestion() {
        if nQuestionsAsked == 8 {
            reset()
        } else {
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
            animationOpacity = 1.0
        }
    }
    
    func reset() {
        scoreTitle = "Your final score is \(score) correct answers"
        gameOver = true
        nQuestionsAsked = 0
        score = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
