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
    chooseAndMove!(dat, pl::Player, att, d)
```
To be called by rollAndMove to pick which piece to move (if any) given player `pl`'s strategy.
"""
function chooseAndMove!(dat::Intelligence, pl::Player, att, d)
    # if none can be moved
        #if d != 6 and att < 1, call rollAndMove(gm, att+1)
    # else pass

    # if some can be moved, sugget which depending on dat and player strategy
        # and move

    return nothing
end


struct Intelligence
    bfs::PPS
    pfs::Vector
    aimBfs::Vector
    aims44::Vector # no-nonsense aims, multiply
    myStart::Vector # highest priority
    kick::Vector #*
    fFS::Vector # *free foreign start
    aFS::Vector # *avoid foreign start
    aGS::Vector # *avoid goal shuffling
    eG::Vector # *enter goal
    fP::Vector # *my furthest-ahead piece
end

function gatherIntelligence(gm::Game)
    Intelligence(myPiecePositionStruct(gm), # bfs (PPS)
                 bf2pf.(vcat(bfs.inGoal, bfs.inGame), whoseTurn(gm)), #pfs
                 pf2bf.(pfs .+ d, whoseTurn(gm)), # aim bfs
                 aimBfs .!= -1 # aims44 
                 # other vectors
                 # true if a piece is on a player's own start field
    #on1 = pfs .== 1


    # index of whetehr the player themselves is not the aim fileds
    # if they're on, returns 0/false
    #selfOnAim = [!iOnBf(gm, i) for i in aimBfs]
    # selfOnAim = (!).(iOnBf.(gm, aimBfs))

    # index of whetehr another player is not the aim fileds
    # if they're on, returns 1/true
    #otherOnAim = [!otherOnBf(gm, i) for i in aimBfs]

    
    # true for a piece on a player's own start field
    #onOtherStartField = [i in [11, 21, 32] for i in pfs]

    # true is piece on goal field
    #onGoalField = pfs .> 40
    
                 )
end

"""
```
    rollAndMove!(gm, att=1)
```
Roll die and decide what to do.
"""
function rollAndMove!(gm, att=1)
    # roll a die
    d = rand(1:6)
    #d = 6 # for debug
    itg = gatherIntelligence(gm)

    if d == 6
        if length(itg.bfs.waiting) > 0 # any waiting to move out?
            if 1 in pfs # if current pl on their start
                # ADD! chooseAndMove!(itg, gm.players[whoseTurn(gm)], att, d)
                gm.turn += 1
                rollAndMove!(gm) # 2nd turn
                return nothing
            else # curent pl not on their start, move out!
                moveAndKick!(gm, 
                             startFromWhere(gm, whoseTurn(gm)),
                             pf2bf(1, whoseTurn(gm))
                             )

                gm.turn += 1
                rollAndMove!(gm) # 2nd turn
                return nothing
            end
        else # no-one's waiting
            # ADD chooseAndMove!(itg, gm.players[whoseTurn(gm)], att, d)
            gm.turn += 1
            rollAndMove!(gm)  # 2nd turn
            return nothing
        end
    else
        # ADD! chooseAndMove!(itg, gm.players[whoseTurn(gm)], att, d)
    end
    return nothing

end