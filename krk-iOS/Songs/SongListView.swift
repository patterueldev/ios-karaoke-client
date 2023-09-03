//
//  SongListView.swift
//  krk-iOS
//
//  Created by John Patrick Teruel on 9/1/23.
//

import SwiftUI

struct SongListView: View {
    @ObservedObject var viewModel: SongListViewModel
    
    init(environment: DependencyManager.Environment) {
        var dependencyManager = DependencyManager.shared
        self.viewModel = SongListViewModel(
            getSongs: dependencyManager.getSongsUseCase,
            reserveSongs: dependencyManager.reserveSongUseCase
        )
    }
    
    var body: some View {
        ZStack {
            List(viewModel.songs) { song in
                HStack {
                    AsyncImage(url: song.song.image?.asURL()) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill) // Added aspect ratio modifier
                            .frame(width: 50, height: 50)
                            .clipped() // Added clipped modifier to ensure the image doesn't exceed the frame
                    } placeholder: {
                        // Placeholder view with music symbol
                        Image(systemName: "music.note")
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                            .frame(width: 50, height: 50)
                    }
                    .background(Color.gray.opacity(0.5))
                    
                    VStack(alignment: .leading) {
                        Text(song.song.title)
                            .font(.headline)
                        
                        if let artist = song.song.artist {
                            Text(artist)
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.reserveSong(identifier: song.id)
                    }, label: {
                        Image(systemName: "mic")
                            .font(.system(size: 20))
                            .foregroundColor(.blue.opacity(0.75))
                    
                    })
                }
            }
            .scrollContentBackground(.hidden)
            VStack{
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(action: {}, label: {
                        Image(systemName: "book.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                    })
                    .padding()
                    .background(.blue.opacity(0.75))
                    .clipShape(Circle()) // Make the button circular
                }.padding(.horizontal, 16)
            }
        }
        .background(Color.indigo) // Set the background color of the bottom bar
        .searchable(text: $viewModel.searchText)
        .onAppear() {
            viewModel.loadSongs()
        }
    }
}

#Preview {
    let environment = DependencyManager.Environment.preview
    DependencyManager.setup(environment: environment)
    return SongListView(environment: environment)
}
