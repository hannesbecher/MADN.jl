

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
    Piece() 
```
The Piece constructor. By default makes a ghost piece.
"""
Piece() = Piece(0, 0, :white)
    
