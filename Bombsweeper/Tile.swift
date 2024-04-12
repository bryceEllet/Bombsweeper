//
//  Tile.swift
//  Bombsweeper
//
//  Created by there#2 on 1/22/24.
//

import UIKit

class Tile: UIButton {
    let size: CGFloat
    let margin: CGFloat
    var square: Square
    
    init(size: CGFloat, margin: CGFloat, square: Square) {
        self.size = size
        self.margin = margin
        self.square = square
        let x = CGFloat(square.column) * (size + margin)
        let y = CGFloat(square.row) * (size + margin)
        let buttonFrame = CGRect(x: x, y: y, width: size, height: size)
        super.init(frame: buttonFrame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tileInfo(clicked: Bool) -> String {
        if square.isFlagged {
            return "🚫"
        }
        if square.isBomb {
            if clicked {
                return "💥"
            }
            return "💣"
        } else {
            if square.adjacentBombs == 0 {
                return ""
            }
            return "\(square.adjacentBombs)"
        }
    }
}
