//
//  GetSongListUseCase.swift
//  krk-iOS
//
//  Created by John Patrick Teruel on 9/1/23.
//

import Foundation

protocol GetSongsUseCase {
    func execute(limit: Int?, offset: Int?, filter: String?) async throws -> [Song]
}

class DefaultGetSongsUseCase: GetSongsUseCase {
    let dataSource: KaraokeRepository
    
    init(dataSource: KaraokeRepository) {
        self.dataSource = dataSource
    }
    
    func execute(limit: Int?, offset: Int?, filter: String?) async throws -> [Song] {
        return try await dataSource.getSongList(
            limit: limit,
            offset: offset,
            filter: filter
        )
    }
}


