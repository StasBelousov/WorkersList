//
//  DetailView.swift
//  WorkerList Watch App
//
//  Created by Станислав Белоусов on 24.12.2023.
//

import SwiftUI

struct DetailView: View {
    
    // MARK: - PROPERTY
    
    let note: Note
    let count: Int
    let index: Int
    
    // MARK: - BODY
    
    var body: some View {
        VStack(alignment: .center, spacing: 3.0) {
            
            HStack {
                Capsule()
                    .frame(height: 1)
                Image(systemName: "note.text")
                Capsule()
                    .frame(height: 1)
            } //:HSTACK
            .foregroundColor(.accentColor)
            
            GeometryReader {_ in
                ScrollView(.vertical) {
                    Text(note.text)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                }
                .frame(maxHeight: .infinity)
            }
            
            HStack(alignment: .center) {
                Image(systemName: "gear")
                    .imageScale(.large)
                Spacer()
                Text("\(count) / \(index + 1)")
                Spacer()
                
                Image(systemName: "info")
                    .imageScale(.large)
                
            } //: HSTACK
            .foregroundColor(.secondary)
            
        } //: VSTACK
        .padding(3)
    }
    
}

// MARK: - PREVIEW

struct DetailView_Previews: PreviewProvider {
    static var sampleDate = Note(id: UUID(), text: "Hello Worker!")
    
    static var previews: some View {
        DetailView(note: sampleDate, count: 1, index: 1)
    }
}
