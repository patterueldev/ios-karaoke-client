//
//  KaraokeDataSource.swift
//  krk-iOS
//
//  Created by John Patrick Teruel on 9/1/23.
//

import Foundation

protocol KaraokeDataSource {
    func getSongList() async throws -> [Song]
    func reserveSong(_ song: Song) async throws
    func getReservedSongs() async throws -> [Song]
    func playNext() async throws
    func cancelReservation(_ song: Song) async throws
}
