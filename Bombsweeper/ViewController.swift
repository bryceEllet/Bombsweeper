//
//  ViewController.swift
//  Bombsweeper
//
//  Created by there#2 on 1/10/24.
//

import UIKit

class ViewController: UIViewController {
    var boardSize: Int = 10
    var bombNumber: Int = 10
    var board: Board
    var tiles: [Tile] = []
    let tileMargin: CGFloat = 2.0
    var oneSecondTimer: Timer?
    var firstClick = true
    var flag = false
    var paused = false
    var min = 0
    var sec = 0
    var minString = ""
    var secString = ""
    var backgroundColor = UIColor.systemBlue
    var tileColor = UIColor.systemCyan
    var bestTimeString = "00:00"
    var bestTime = 999999999
    var moves: Int = 0 {
        didSet {
            movesLabel.text = "Moves: \(moves)"
        }
    }
    var time: Int = 0 {
        didSet {
            minString = ""
            secString = ""
            if time == 60 {
                min += 1
                time = 0
            }
            sec = time
            if min < 10 {
                minString = "0\(min)"
            } else {
                minString = "\(min)"
            }
            if sec < 10 {
                secString = "0\(sec)"
            } else {
                secString = "\(sec)"
            }
            timeLabel.text = "Time: \(minString):\(secString)"
        }
    }
    
    @IBOutlet weak var boardView: UIView!
    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var flagControl: UISegmentedControl!
    @IBOutlet weak var bombCountLabel: UILabel!
    @IBAction func pausedPressed(_ sender: UIButton) {
        paused = true
    }
    @IBAction func settingsButtonPressed(_ sender: UIBarButtonItem) {
        endGame()
    }
    @IBAction func newGamePressed(_ sender: UIBarButtonItem) {
        endGame()
        startGame(difficulty: bombNumber)
    }
    @IBAction func flagChanged(_ sender: UISegmentedControl) {
        if flagControl.selectedSegmentIndex == 1 {
            flag = true
        } else {
            flag = false
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        board = Board(size: boardSize)
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        initializeBoard()
        startGame(difficulty: bombNumber)
        paused = false
    }

    func initializeBoard() {
        for row in 0..<boardSize {
            for column in 0..<boardSize {
                let square = board.squares[row][column]
                let buttonSize: CGFloat = (boardView.frame.width - (tileMargin * CGFloat (boardSize - 1))) / CGFloat (boardSize)
                let tile = Tile(size: buttonSize, margin: tileMargin, square: square)
                tile.addTarget(self, action: #selector(self.tilePressed), for: .touchUpInside)
                tiles.append(tile)
                boardView.addSubview(tile)
            }
        }
    }
    
    @objc func tilePressed(_ tile: Tile) {
        if firstClick {
            oneSecondTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(oneSec), userInfo: nil, repeats: true)
            repeat {
                startGame(difficulty: bombNumber)
            } while tile.square.adjacentBombs != 0 || tile.square.isBomb
            firstClick = false
        }
        if flag && !tile.square.isShowing {
            if tile.square.isFlagged {
                tile.square.isFlagged = false
                tile.setTitle("", for: .normal)
            } else {
                tile.square.isFlagged = true
                tile.setTitle(tile.tileInfo(clicked: true), for: .normal)
            }
            
        } else {
            moves += 1
            if !tile.square.isShowing && !tile.square.isFlagged {
                tile.setTitle(tile.tileInfo(clicked: true), for: .normal)
                tile.backgroundColor = backgroundColor
                autoExpand(tile: tile)
                tile.square.isShowing = true
                if tile.tileInfo(clicked: true) == "💥" {
                    endGame(win: false, square: tile.square)
                }
                if checkWinner() {
                    endGame(win: true, square: tile.square)
                }
            }
        }
    }
    
    func endGame(win: Bool, square: Square) {
        endGame()
        for tile in tiles {
            tile.square.isFlagged = false
            if tile.square.column == square.column && tile.square.row == square.row {
                tile.setTitle(tile.tileInfo(clicked: true), for: .normal)
            } else {
                tile.setTitle(tile.tileInfo(clicked: false), for: .normal)
            }
            tile.backgroundColor = backgroundColor
        }
        var message = ""
        if win {
            let currentTime = (min*60)+time
            if currentTime < bestTime {
                bestTime = currentTime
                bestTimeString = "\(minString):\(secString)"
            }
            message = "You Win!"
        } else {
            if bestTime == 999999999 {
                bestTimeString = "N/A"
            }
            message = "You Lose!"
        }
        let alert = UIAlertController(title: message, message: "Best Time: \(bestTimeString)", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Play Again", style: .default, handler: doSomething))
        self.present(alert, animated: true)
    }
    
    func checkWinner() -> Bool{
        for tile in tiles {
            if !tile.square.isBomb {
                if !tile.square.isShowing {
                    return false
                }
            }
        }
        return true
    }
    
    func doSomething(action: UIAlertAction) {
        startGame(difficulty: bombNumber)
    }
                            
    func startGame(difficulty: Int) {
        bombCountLabel.text = String(bombNumber)
        moves = 0
        time = 0
        min = 0
        board.resetBoard(bombNum: difficulty)
        for tile in tiles {
            tile.setTitle("", for: .normal)
            tile.backgroundColor = tileColor
            tile.square.isFlagged = false
        }
        firstClick = true
    }
    
    @objc func oneSec() {
        if !paused {
            time += 1
        }
    }
    
    func endGame() {
        oneSecondTimer?.invalidate()
        oneSecondTimer = nil
    }
    
    func autoExpand(tile: Tile) {
        if !tile.square.isShowing {
            tile.square.isShowing = true
            tile.square.isFlagged = false
            tile.backgroundColor = backgroundColor
            tile.setTitle(tile.tileInfo(clicked: false), for: .normal)
            if tile.square.adjacentBombs == 0 {
                for square in board.getRadius(square: tile.square) {
                    for loopBox in tiles {
                        if loopBox.square.row == square.row && loopBox.square.column == square.column {
                            autoExpand(tile: loopBox)
                        }
                    }
                }
            }
        }
        
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        let settingsVC = segue.source as! SettingsVC
        bombNumber = settingsVC.bombs
        switch settingsVC.theme {
        case "Volcano":
            backgroundColor = UIColor.systemRed
            tileColor = UIColor.systemOrange
        case "Landscape":
            backgroundColor = UIColor.systemBrown
            tileColor = UIColor.systemGreen
        default:
            backgroundColor = UIColor.systemBlue
            tileColor = UIColor.systemCyan
        }
        startGame(difficulty: bombNumber)
        
    }
    
    @IBAction func unwind(segue: UIStoryboardSegue) {
        let pauseVC = segue.source as! PauseVC
        paused = false
    }
}

