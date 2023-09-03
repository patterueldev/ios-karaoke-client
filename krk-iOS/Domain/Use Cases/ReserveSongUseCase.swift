//
//  ReserveSongUseCase.swift
//  krk-iOS
//
//  Created by John Patrick Teruel on 9/3/23.
//

import Foundation

protocol ReserveSongUseCase {
    func execute(song: Song) async throws
}

class DefaultReserveSongUseCase: ReserveSongUseCase {
    let dataSource: KaraokeDataSource
    
    init(dataSource: KaraokeDataSource) {
        self.dataSource = dataSource
    }
    
    func execute(song: Song) async throws {
        try await dataSource.reserveSong(song)
    }
}
