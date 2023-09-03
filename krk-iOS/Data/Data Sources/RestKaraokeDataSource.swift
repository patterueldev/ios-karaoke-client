//
//  RestKaraokeDataSource.swift
//  krk-iOS
//
//  Created by John Patrick Teruel on 9/3/23.
//

import Foundation

class RestKaraokeDataSource: KaraokeDataSource {
    let apiManager: APIManager
    
    init(apiManager: APIManager) {
        self.apiManager = apiManager
    }
    
    func getSongList() async throws -> [Song] {
        let response: GenericResponse<[RestSong]> = try await apiManager.getRequest(path: .songs)
        return response.data
    }
    
    func reserveSong(_ song: Song) async throws {
        let response: GenericResponse<String> = try await apiManager.postRequest(path: .reserve, body: ReserveSongParams(id: song.identifier))
        print("Reserve song response \(response)")
    }
    
    func getReservedSongs() async throws -> [Song] {
        throw notImplemented()
    }
    
    func playNext() async throws {
        throw notImplemented()
    }
    
    func cancelReservation(_ song: Song) async throws {
        throw notImplemented()
    }
    
    
}

private struct ReserveSongParams: Codable {
    let id: String
}


private func notImplemented() -> Error {
    NSError(domain: "DemoKaraokeDataSource", code: 1, userInfo: [
        NSLocalizedDescriptionKey: "Not implemented"
    ])
}


struct GenericResponse<T: Codable>: Codable {
    let data: T
    let message: String
    let status: Int
    
    enum CodingKeys: String, CodingKey {
        case data
        case message
        case status
    }
}
