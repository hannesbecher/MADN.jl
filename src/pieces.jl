

"""
The Piece type (including ghost piece.)
"""
struct Piece
    player::Int
    playerPiece::Int
    colour::Symbol
end

"""
```
    Piece(player=0, playerPiece=0, color=:white)
```
The Piece constructor. By default makes a ghost piece.
"""
function Piece(player=0, playerPiece=0, colour=:white)
    player = player
    playerPiece = playerPiece
    colour = colour
end


"""
```
    makeBoard(nPl=4)
```
Return a length-72 Vector of `Piece`, the 'board'.
"""
function makeBoard(nPl=4)
    board = [Piece() for _ in 1:72]
    # 1: 40 board fields
    # 41:56 waiting area
    # 57:72 goal area
    for i in 1:nPl
        for j in 1:4
            board[36 + 4i + j] = Piece(i, j, plCols[i])
        end
    end
    return board
end
