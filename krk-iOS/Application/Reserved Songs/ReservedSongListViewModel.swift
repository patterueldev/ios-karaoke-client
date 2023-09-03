//
//  ReservedSongListViewModel.swift
//  krk-iOS
//
//  Created by John Patrick Teruel on 9/3/23.
//

import SwiftUI

class ReservedSongListViewModel: ObservableObject {
    private let getReservedSongs: GetReservedSongsUseCase
    
    init() {
        let dependencyManager = DependencyManager.shared
        self.getReservedSongs = dependencyManager.getReservedSongsUseCase
    }
    @Published var songs: [ReservedSongWrapper] = []
    
    func loadSongs() {
        Task {
            do {
                let songs = try await getReservedSongs.execute().map({ ReservedSongWrapper($0) })
                await MainActor.run {
                    self.songs = songs
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    struct ReservedSongWrapper: Identifiable {
        let id: String
        let reservedSong: ReservedSong
        
        init(_ song: ReservedSong) {
            self.id = song.identifier
            self.reservedSong = song
        }
    }
}
