//
//  StampView.swift
//  PhotoCollage
//
//  Created by cmStudent on 2024/07/04.
//

import SwiftUI

struct StampView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var stamp: String?
    @Binding var subStamp: String?
    
    let stampSet = ["😀", "😂", "😎", "😍", "😇", "😤", "🥵", "😵‍💫", "👹", "🤖", "👈", "🐶", "🍏", "⚽️", "❤️", "🧃", "🎂", "☀️"]
    let stampTra = ["☹️", "😅", "🥸", "🤩", "😣", "🤬", "🥶", "🤮", "🤡", "👽", "👉", "🐱", "🍎", "🏀", "💔", "🥂", "🍭", "⛈️"]
    let grid = Array(repeating: GridItem(.fixed(40)), count: 6)
    var body: some View {
        ScrollView {
            LazyVGrid(columns: grid) {
                ForEach(stampSet.indices, id: \.self) { index in
                    Text(stampSet[index])
                        .font(.largeTitle)
                        .frame(width: 80, height: 50)
                        .onTapGesture {
                            stamp = stampSet[index]
                            subStamp = stampTra[index]
                            presentationMode.wrappedValue.dismiss()
                        }
                }
            }
            .padding()
        }
    }
}
