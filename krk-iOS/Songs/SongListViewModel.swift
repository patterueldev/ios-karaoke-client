//
//  SongListViewModel.swift
//  krk-iOS
//
//  Created by John Patrick Teruel on 9/1/23.
//

import SwiftUI

class SongListViewModel: ObservableObject {
    private let getSongs: GetSongsUseCase
    private let reserveSongs: ReserveSongUseCase
    
    init(getSongs: GetSongsUseCase, reserveSongs: ReserveSongUseCase) {
        self.getSongs = getSongs
        self.reserveSongs = reserveSongs
    }
    
    @Published var songs: [SongWrapper] = []
    @Published var searchText: String = "1"
    
    func loadSongs() {
        Task {
            do {
                let songs = try await getSongs.execute().map { SongWrapper(id: $0.identifier, song: $0) }
                await MainActor.run {
                    self.songs = songs
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func reserveSong(identifier: String) {
        print("Reserving song \(identifier)")
        
        Task {
            do {
                let song = songs.first { $0.id == identifier }
                guard let song = song else { throw NSError(domain: "SongListViewModel", code: 1, userInfo: nil) }
                
                try await reserveSongs.execute(song: song.song)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    

    struct SongWrapper: Identifiable {
        let id: String
        let song: Song
    }
}
