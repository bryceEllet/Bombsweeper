//
//  Square.swift
//  Bombsweeper
//
//  Created by there#2 on 1/11/24.
//

class Square {
    let row: Int
    let column: Int
    
    var isBomb = false
    var isShowing = false
    var adjacentBombs = 0
    var isFlagged = false
    
    init(row: Int, column: Int) {
        self.row = row
        self.column = column
    }
    
}
