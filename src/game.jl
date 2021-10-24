# printstyled("Ze game!\n", color=:yellow)

# To describe the state of the game, we need
# - board adn where each piece is
# - number of round
# - whose turn it is


"""
```
    makeBoard(nPl=4)
```
Return a length-72 Vector of `Piece`, the 'board'.
"""
function makeBoard(nPl=4,
                   colours=[:red, :green, :cyan, :yellow])
    board = [Piece() for _ in 1:72]
    # 1: 40 board fields
    # 41:56 waiting area
    # 57:72 goal area
    for i in 1:nPl
        for j in 1:4
            board[36 + 4i + j] = Piece(i, j, colours[i])
        end
    end
    return board
end

"""
The Game type to represent the state of the game, containing the `board`, number of `turn`, and the player `whoseTurn` it is.
"""
mutable struct Game
    board::Vector{Piece}
    turn::Int
    whoseTurn::Int
    players::Vector{Player}
    # useful for two-player games with opposite players and to check which start fields are 'active'
    playerPos::Vector{Int} 
end

"""
```
    setupGame(nPl)
```
Generate a Game object with `nPl` players.
"""
function setupGame(nPl)
    return Game(makeBoard(nPl), 1, 1, [Player() for i in 1:4], [1, 2, 3, 4])
end

"""
```
    oneTurn!(gm::Game; print=false)
```
The function called each turn to update the game's state.
"""
function oneTurn!(gm::Game; print=false)
    
    # roll die and decide what to do
    rollAndMove(gm)
    

    # increment turn counter
    gm.turn += 1
    
    
    # update whoseTurn to next player
    gm.whoseTurn = (gm.whoseTurn % 4) + 1
    
    
    # optionally print state
    if print==true
        run(`clear`)
        printGameState(gm)
        sleep(0.05)
    end
    
end

"""
```
    rollAndMoce(gm, att=1)
```
Roll die and decide what to do.
"""
function rollAndMove(gm, att=1)
    # roll a die
    d = rand(1:6)

    pcs = myPiecePositionDict(gm)

    # move current player according to their strategy

end