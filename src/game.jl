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
    finishingOrder::Vector{Int}
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
    return Game(makeBoard(nPl), 1, 1, [Player() for i in 1:4], Int[], [1, 2, 3, 4])
end

"""
```
    oneTurn!(gm::Game; print=false)
```
The function called each turn to update the game's state.
"""
function oneTurn!(gm::Game; prnt=false)
    
    if gm.whoseTurn in gm.finishingOrder
        gm.whoseTurn = mod1(gm.whoseTurn + 1, 4)
        return nothing
    end
    # roll die and decide what to do
    rollAndMove!(gm)
    

    # increment turn counter
    gm.turn += 1
    
    
    # update whoseTurn to next player
    gm.whoseTurn = mod1(gm.whoseTurn + 1, 4)
    
    
    # optionally print state
    if prnt==true
        #run(`clear`)
        print(gm)
        sleep(0.05)
    end
    
end

struct Intelligence
    pps::PPS
    bfs::Vector
    pfs::Vector
    aimBfs::Vector
    aims44::Vector # no-nonsense aims, multiply
    iOnAim::Vector # no-nonsense aims, multiply

    # for weights
    weights::Matrix{Int}
    # myStart::Vector # highest priority
    # kick::Vector #*
    # fFS::Vector # *free foreign start
    # aFS::Vector # *avoid foreign start
    # aGS::Vector # *avoid goal shuffling
    # eG::Vector # *enter goal
    # fP::Vector # *my furthest-ahead piece not in goal
end

Base.show(io::IO, itl::Intelligence) = print(io, "Intelligence object (PPS: ", itl.bfs,
    ", player fields: ", itl.pfs,
    ", aim BFs: ", itl.aimBfs,
    ", aims OK: ", itl.aims44,
    ", I not on aim: ", itl.iOnAim,
    ", weights: ", itl.weights,
    # ", kickable aim: ", itl.kick,
    # ", leave foreign start: ", itl.fFS,
    # ", enter foreign start: ", itl.aFS,
    # ", enter goal: ", itl.eG,
    # ", furthest-ahead non-goal: ", itl.fP,
    ")")



"""
```
    gatherIntelligence(gm::Game, d)
```
Explore state of the game `gm`, assuming that a number `d` was rolled. Only run if there are pieces `inGame` or `inGoal`.
"""
function gatherIntelligence(gm::Game, d)
    pps = myPiecePositionStruct(gm)
    bfs = vcat(pps.inGoal, pps.inGame) # only those in game or goal
    pfs = bf2pf.(bfs, whoseTurn(gm)) # only those in game or goal
    aims = pf2bf.(pfs .+ d, whoseTurn(gm)) # these are board fields
    isInGoal = pfs .> 40
    aimInGoal = (pfs .+ d) .> 40
    #println("In Game: $(length(pps.inGame))")
    if length(pps.waiting) < 4
        #println("Some inGame")
        pfs .== 1#myStart
        map(x -> otherOnBf(gm, x), aims)
        map(x -> x in [11, 21, 31], pfs)
        map(x -> x+d in [11, 21, 31], pfs)
        isInGoal .& aimInGoal
        (!).(isInGoal) .& aimInGoal
        #println("Collect bit")
        collect(pfs .== maximum(pfs))
        #println("Collect bit done")
        return Intelligence(pps, # PPS (has board fields)
                     bfs,
                     pfs, # player fields of inGame and inGoal
                     aims, # aims of these as bfs
                     aims .!= -1, # whether aims make sense
                     map(x -> !iOnBf(gm, x), aims), # whether player is not on goal field
                     # weightings
                     hcat(
                     pfs .== 1,#myStart
                     map(x -> otherOnBf(gm, x), aims), # Kickable aim?
                     map(x -> x in [11, 21, 31], pfs), # any of mine on a foreightn start field?
                     map(x -> x+d in [11, 21, 31], pfs), # any of mine heading for a foreign start field?
                     isInGoal .& aimInGoal,# in goal and heading for goal?
                     (!).(isInGoal) .& aimInGoal, # entering goal 
                     collect(pfs .== maximum(pfs))
                     )
                     
        )
    else
        #println("None inGame")
        return Intelligence(pps, # PPS (has board fields)
        bfs,
        pfs, # player fields of inGame and inGoal
        aims, # aims of these as bfs
        aims .!= -1, # whether aims make sense
        map(x -> !iOnBf(gm, x), aims), # whether player is not on goal field
        # weightings
        zeros(Int, (7,0))
        
)
    end
end



"""
```
    chooseAndMove!(dat, gm::Game, att, d)
```
To be called by rollAndMove to pick which piece to move (if any) given player `pl`'s strategy.
"""
function chooseAndMove!(itg::Intelligence, gm::Game, att, d)
    if (length(itg.bfs) == 0) # i.e. non in game or goal
        if att < 3
            rollAndMove!(gm, att+1)
        end
        return nothing
    end
    #println(itg)
    pw = pieceWeights(gm.players[gm.whoseTurn].strategy, itg)
    #println(pw) # for debug
    if all(pw .== 0) # none can be moved
        #println("All weights are zero!")
        if length(itg.pps.inGame) == 0 
            #println("Only pieces in goal (and waiting).")
            if !gapsInGoal(gm, gm.whoseTurn)
                #println("No gaps in goal.")
                if att < 3
                    rollAndMove!(gm, att+1)
                end
            end
        end

        return nothing
    end
    scInd = findall(x -> x == maximum(pw), pw)
    indVec = collect(1:length(itg.pfs))[scInd] # indices of highest weights
    ind = ifelse(length(indVec) > 1, rand(indVec), indVec[1]) # in case of ties, select randomly
    moveAndKick!(gm, itg.bfs[ind], itg.aimBfs[ind])
    # if none can be moved
        #if d != 6 and att < 1, call rollAndMove(gm, att+1)
    # else pass

    # if some can be moved, sugget which depending on dat and player strategy
        # and move

    return nothing
end



pieceWeights(s::Strategy, itl::Intelligence) = (sum(s.sWeights' .* itl.weights, dims=[2]) .+ 1) .* itl.aims44 .* itl.iOnAim

"""
```
    rollAndMove!(gm, att=1)
```
Roll die and decide what to do.
"""
function rollAndMove!(gm, att=1)
    # roll a die
    d = rand(1:6)
    #d = 3 # for debug
    #println("Rolled a $d.")
    itg = gatherIntelligence(gm, d)

    if d == 6
        if length(itg.pps.waiting) > 0 # any waiting to move out?
            if 1 in itg.pfs # if current pl on their start
                #println("I'm on my start!")
                chooseAndMove!(itg, gm, att, d)
                gm.turn += 1
                #println("Second turn!")
                rollAndMove!(gm) # 2nd turn
                return nothing
            else # curent pl not on their start, move out!
                #println("Moving out.")
                moveAndKick!(gm, 
                             startFromWhere(gm, whoseTurn(gm)),
                             pf2bf(1, whoseTurn(gm))
                             )

                gm.turn += 1
                #println("Second turn!")
                rollAndMove!(gm) # 2nd turn
                return nothing
            end
        else # no-one's waiting
            chooseAndMove!(itg, gm, att, d)
            gm.turn += 1
            #println("Second turn!")
            rollAndMove!(gm)  # 2nd turn
            return nothing
        end
    else # no 6
        chooseAndMove!(itg, gm, att, d)
    end
    return nothing

end


