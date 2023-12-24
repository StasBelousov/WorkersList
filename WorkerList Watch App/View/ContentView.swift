//
//  ContentView.swift
//  WorkerList Watch App
//
//  Created by Станислав Белоусов on 23.12.2023.
//

import SwiftUI

struct ContentView: View {
    // MARK: - PROPERTY
    
    @State private var notes: [Note] = [Note]()
    @State private var text: String = ""
    
    // MARK: - FUNCTION
    
    func getDocumentDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
    
    func save() {
        // dump(notes)
        
        do {
            let data = try JSONEncoder().encode(notes)
            let url = getDocumentDirectory().appendingPathComponent("notes")
            try data.write(to: url)
        } catch {
            print("Saving failed!")
        }
    }
    
    func load() {
        DispatchQueue.main.async {
            do {
                let url = getDocumentDirectory().appendingPathComponent("notes")
                let data = try Data(contentsOf: url)
                notes = try JSONDecoder().decode([Note].self, from: data)
            } catch {
                print("Load failed!")
            }
        }
    }
    
    func delete(offsets: IndexSet) {
        withAnimation {
            notes.remove(atOffsets: offsets)
            save()
        }
    }
    
    // MARK: - BODY
    
    var body: some View {
        NavigationStack {
            HStack(alignment: .center, spacing: 6.0) {
                TextField("Add New Note", text: $text)
                Button {
                    //: ACTION
                    guard text.isEmpty == false else { return }
                    let note = Note(id: UUID(), text: text)
                    notes.append(note)
                    text = ""
                    save()
                } label: {
                    Image(systemName: "plus.circle")
                        .font(.system(size: 42, weight: .semibold))
                }
                .fixedSize()
                .buttonStyle(.plain)
                .foregroundColor(.accentColor)
            } //: HSTACK
            
            Spacer()
            
            if notes.count >= 1 {
                    List {
                        ForEach(0..<notes.count, id: \.self ) { item in
                            
                            NavigationLink(destination: DetailView(note: notes[item], count: notes.count, index: item)) {
                                HStack {
                                    Capsule()
                                        .frame(width: 4.0)
                                        .foregroundColor(.accentColor)
                                    Text(notes[item].text)
                                        .lineLimit(1)
                                        .padding(.leading, 5)
                                }
                                
                            }//: HSTACK
                        } //: LOOP
                        .onDelete(perform: delete)
                    } //: LIST
            } else {
                Spacer()
                Image(systemName: "note.text")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray)
                    .opacity(0.3)
                    .padding(20)
                Spacer()
            }
        } //: VSTACK
        .navigationTitle("Notes")
        .onAppear(perform: {
            load()
        })
    }
}

// MARK: - PREVIEW

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
