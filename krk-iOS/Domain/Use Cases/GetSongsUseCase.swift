//
//  GetSongListUseCase.swift
//  krk-iOS
//
//  Created by John Patrick Teruel on 9/1/23.
//

import Foundation

protocol GetSongsUseCase {
    func execute() async throws -> [Song]
}

class DefaultGetSongsUseCase: GetSongsUseCase {
    let dataSource: KaraokeDataSource
    
    init(dataSource: KaraokeDataSource) {
        self.dataSource = dataSource
    }
    
    func execute() async throws -> [Song] {
        return try await dataSource.getSongList()
    }
}


