//
//  Board.swift
//  Bombsweeper
//
//  Created by there#2 on 1/11/24.
//

import Foundation

class Board {
    let size: Int
    var squares: [[Square]] = []
    
    init(size: Int) {
        self.size = size
        for row in 0..<size {
            var squareRow: [Square] = []
            for column in 0..<size {
                let square = Square(row: row, column: column)
                squareRow.append(square)
            }
            squares.append(squareRow)
        }
    }
    
    func resetBoard(bombNum: Int) {
        for row in 0..<size {
            for column in 0..<size {
                squares[row][column].isShowing = false;
                squares[row][column].isBomb = false;
            }
        }
        
        // gets bombs positions
        for _ in 0..<bombNum {
            var rRow = 0
            var rColumn = 0
            repeat {
                rRow = Int.random(in: 0..<size)
                rColumn = Int.random(in: 0..<size)
            } while squares[rRow][rColumn].isBomb  
            squares[rRow][rColumn].isBomb = true
        }
        
        for row in 0..<size {
            for column in 0..<size {
                countCloseBombs(square: squares[row][column])
            }
        }
    }
    
    func countCloseBombs(square: Square) {
        let surroundingSquares = getRadius(square: square)
        var bombs = 0
        for neighbor in surroundingSquares {
            if neighbor.isBomb {
                bombs += 1
            }
        }
        square.adjacentBombs = bombs
    }
    
    func getRadius(square: Square) -> [Square] {
        var neighbors: [Square] = []
        let offsets = [(-1, -1), (-1, 0), (-1, 1), (1, 1), (1, 0), (1, -1), (0, -1), (0, 1)]
        for (rowOffset, columnOffset) in offsets {
            let row = square.row + rowOffset
            let column = square.column + columnOffset
            if row >= 0 && row < size && column >= 0 && column < size {
                neighbors.append(squares[row][column])
            }
        }
        return neighbors
    }
}
