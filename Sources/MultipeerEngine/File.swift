//
// File.swift
//
//
// Created by Zakk Hoyt on 12/5/23.
//

import Foundation

public struct Packet: Codable {
    public struct Metadata: Codable {
        public struct Source: Codable {
            public let peer: MPEngine.Peer
            public let date: Date
        }
    }
    
    public struct TicTacToe: Codable {
        public struct Player: Codable {
            let name: String
            let avatar: String
        }

        public struct Turn: Codable {
            let round: Int
            let date: Date
            let player: Player
            let action: Int
        }

        public struct Game: Codable {
            let players: [Player]
            let board: [Int]
            let turns: [Turn]
        }
    }
        
    public let metadata: Metadata
    public let game: TicTacToe
}
