//
//  Player.swift
//  Shuffle Game
//
//  Created by Sepehr on 5/16/24.
//

import Foundation

struct Player {
    var id: Int
    var name: String
    var ball: Int
    var redRemaining: Int
    var win: Int
    var password: String?
    var isWinner: Bool
    var coloredPottedBalls: [Int]
    var redPottedBalls: Int
    var pitok: Int
    var isPlayerTurn: Bool
    
    init(id: Int, name: String, ball: Int, redRemaining: Int, win: Int, password: String? = nil, isWinner: Bool, coloredPottedBalls: [Int], redPottedBalls: Int, pitok: Int, isPlayerTurn: Bool) {
        self.id = id
        self.name = name
        self.ball = ball
        self.redRemaining = redRemaining
        self.win = win
        self.password = password
        self.isWinner = isWinner
        self.coloredPottedBalls = coloredPottedBalls
        self.redPottedBalls = redPottedBalls
        self.pitok = pitok
        self.isPlayerTurn = isPlayerTurn
    }
}
