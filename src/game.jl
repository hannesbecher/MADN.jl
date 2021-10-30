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

import Base.print

"""
```
    print(gm::Game)
```
Prints that satus of game `gm` (by calling `printGameState`).
"""
function print(gm::Game)
    printGameState(gm::Game)
    return nothing
end

whoseTurn(gm::Game) = gm.whoseTurn

Base.show(io::IO, gm::Game) = print(io, "Game object (Turn: ", gm.turn, ", Whose turn: ", gm.whoseTurn, ", Positions: ", gm.playerPos, ")")

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
    rollAndMove!(gm)
    

    # increment turn counter
    gm.turn += 1
    
    
    # update whoseTurn to next player
    gm.whoseTurn = mod1(gm.whoseTurn + 1, 4)
    
    
    # optionally print state
    if print==true
        run(`clear`)
        print(gm)
        sleep(0.05)
    end
    
end

"""
```
    rollAndMove!(gm, att=1)
```
Roll die and decide what to do.
"""
function rollAndMove!(gm, att=1)
    # roll a die
    #d = rand(1:6)
    d = 6 # for debug
    bfs = myPiecePositionStruct(gm) # board fields
    
    # concatenate non-waiting fields, convert to pf, add number rolled
    pfs = bf2pf.(vcat(bfs.inGoal, bfs.inGame), whoseTurn(gm))
    
    # true if a piece is on a player's own start field
    on1 = pfs .== 1

    # test of subsequent fields six steps away are occupied, too
    if any(x -> x==true, pfs .== 1) & any(x -> x==true, pfs .== 7)
        if any(x -> x==true, pfs .== 1) & any(x -> x==true, pfs .== 7) & any(x -> x==true, pfs .== 13)
            on1and7and13 = pfs .== 13
            on1and7 = fill(1, size(pfs))
        else # only 7
            on1and7 = pfs .== 7
            on1and7and13 = fill(1, size(pfs))
        end # if 13
    else # neither
        on1and7 = fill(1, size(pfs))
        on1and7and13 = fill(1, size(pfs))
    end

    # board field numbers of aim fields
    aimBfs = pf2bf.(pfs .+ 6, whoseTurn(gm))

    # index of whether aim fields are sensible, i.e. < pf 45
    aims44 = aimBfs .!= -1 # 

    # index of whetehr the player themselves is not the aim fileds
    # if they're on, returns 0/false
    selfOnAim = [!iOnBf(gm, i) for i in aimBfs]
    # selfOnAim = (!).(iOnBf.(gm, aimBfs))

    # index of whetehr another player is not the aim fileds
    # if they're on, returns 1/true
    otherOnAim = [!otherOnBf(gm, i) for i in aimBfs]

    
    # true for a piece on a player's own start field
    onOtherStartField = [i in [11, 21, 32] for i in pfs]

    # true is piece on goal field
    onGoalField = pfs .> 40
    println(pfs)
    println(aimBfs)
    println(on1)
    println(on1and7)
    println(on1and7and13)
    println(aims44)
    println(selfOnAim)
    println(otherOnAim)
    println(onOtherStartField)
    println(onGoalField)
    # # move current player according to their strategy

end