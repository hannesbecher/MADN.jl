
function bf2pf(bf::Int, pl::Int)
    bf > 72 && error("Board field cannot be > 72.")
    if bf < 41
        return mod1(((5 - pl) * 10 + bf), 40)
    elseif bf > 56
        if (bf < 57 + (pl-1) * 4) | (bf > 56 + (pl) * 4)
            error("BF $bf is a goal field, but not of player $pl")
        else
            return 40 + mod1(bf, 4)
        end
    else
        error("Player field not defined for waiting area fileds.")
    end
end

function pf2bf(pf, pl)
    # No error is thrown if the pf is nonsense!
    if 0 < pf < 41 # in game
        return mod1((pf + (pl - 1) * 10), 40)
    elseif 40 < pf < 45 # goal field
        return pf + 16 + (pl-1)*4
    end
    return -1
end

###################
# sensing functions
###################

"""
Return player number of piece on board field. Zero if field is 'empty' (ghost piece).
"""
function whoOnBf(gm, bf)
    if bf>72 error("Board field cannot be greater than 72.") end
    return gm.board[bf].player
end

"""
Test whether a field is a start field.
"""
function isStartField(gm, bf)
    # todo: consider active players
    # todo: possibly check if there are waiting pieces
    return bf in [1, 11, 21, 31][gm.playerPos]
end


isWaiting(x) = (x > 40) && (x < 57)
isInGame(x) = (x < 41)
isInGoal(x) = (x > 56)

"""
Return a vector of the board fields of all of the active player's pieces.
"""
function playerPiecePositions(gm, pl)
    [i for i in 1:72 if gm.board[i].player == pl]
end

"""
Pice position struct
"""
struct PPS
    waiting::Vector{Int}
    inGame::Vector{Int}
    inGoal::Vector{Int}
end


Base.show(io::IO, mps::PPS) = print(io, "(Waiting: ", mps.waiting, ", In game: ", mps.inGame, ", In goal: ", mps.inGoal, ")")

"""
```
    piecePositionStruct(gm, pl)
```
A type to store where one player `pl`'s pieces are on the board in game `gm`.
"""
function piecePositionStruct(gm, pl)
    PPS(filter(isWaiting, playerPiecePositions(gm, pl)),
        filter(isInGame, playerPiecePositions(gm, pl)),
        filter(isInGoal, playerPiecePositions(gm, pl)))
end



"""
Return the board posistions of all of the active player's pieces in a Dict with keys `waiting`, `inGame`, and `goal`.
"""
myPiecePositionStruct(gm) = piecePositionStruct(gm, gm.whoseTurn)

"""
```
    kickBackToWhere(gm, pl)
```
Board field to move a kicked-out of player `pl`piece to
"""
function kickBackToWhere(gm, pl)
    waitingPieces = piecePositionStruct(gm, pl).waiting
    length(waitingPieces) > 3 && error("Cannot kick when more than 3 pieces are in waiting space.")
    length(waitingPieces) == 0 && return 37 + 4* pl
    return maximum(waitingPieces) + 1
end

"""
```
    swapPieces!(gm, fr, to)
```
Swap pieces of game `gm` between board fields `fr` and `to`. The secon is meant to be a ghost piece.
"""
function swapPieces!(gm, fr, to)
    gm.board[fr], gm.board[to] = gm.board[to], gm.board[fr]
    return nothing
end

"""
```
    startFromWhere(gm, pl)
```
Board field of game `gm` from where to move a piece of player `pl` into the game.
"""
function startFromWhere(gm, pl)
    waitingPieces = piecePositionStruct(gm, pl).waiting
    length(waitingPieces) == 0 && error("Cannot move out. Nobody's waiting.")
    return maximum(waitingPieces)
end


"""
```
    playerOnBF(gm, bf)
```
Return player id of the piece on board field `bf` in game `gm`
"""
function playerOnBF(gm, bf)
    bf == -1 && return 0
    return gm.board[bf].player
end

"""
```
    iOnBf(gm, bf)
```
Return whether currently acitve player from game `gm` has a piece on board field `bf`
"""
function iOnBf(gm, bf)
    return playerOnBF(gm, bf) == whoseTurn(gm)
end

"""
```
    otherOnBf(gm, bf)
```
Return whether a player except for the currently acitve one from game `gm` has a piece on board field `bf`
"""
function otherOnBf(gm, bf)
    return playerOnBF(gm, bf) in filter(x-> x != whoseTurn(gm), [1,2,3,4])
end

"""
```
    kickOut(gm, bf)
```
Kick out a piece from board field `bf` of game `gm` to its corresponding waiting position
"""
function kickOut(gm, bf)
    # add recording corde here
    #println("Kicking BF $bf")
    swapPieces!(gm,
    bf,
    kickBackToWhere(gm, playerOnBF(gm, bf))
    )
end

"""
```
    recordKick(gm, fr, to)
```
Record kicking info to `gm.events`
"""
function recordKick(gm, to)
    push!(gm.events["kickingTurns"], gm.turn)
    push!(gm.events["kickingWho"], gm.whoseTurn)
    push!(gm.events["whoField"], bf2pf(to, gm.whoseTurn)) # field were the kick happens in pf notation for who
    push!(gm.events["kickingWhom"], whoOnBf(gm, to))
    push!(gm.events["whomField"], bf2pf(to, whoOnBf(gm, to)))
end

"""
```
    moveAndKick!(gm, fr, to)
```
Move piece in game `gm` from board field `fr` to `to`. Kick out of there is apiece on `to`.
"""
function moveAndKick!(gm, fr, to)
    if otherOnBf(gm, to) 
        recordKick(gm, to)
        kickOut(gm, to)
    end
    swapPieces!(gm, fr, to)
    # test if finished
    if hasPlFinished(gm, gm.whoseTurn)
        # finishing proc
        push!(gm.events["finishingOrder"], gm.whoseTurn)
        push!(gm.events["finishingTurns"], gm.turn)
    end
end

"""
```
    gapsInGoal(gm, pl)
```
Test whether player `pl` in game `gm` has gaps in their goal. I.e., whether there are pieces on their goal fields one (or more) of which could be moved further.
"""
function gapsInGoal(gm, pl::Int)
    pfs = bf2pf.(piecePositionStruct(gm, pl).inGoal, pl) # get piece positions in goan and convert to player fields
    length(pfs) < 1 && error("There seem to be no pieces in player $pl's goal.")
    return minimum(pfs) < 45 - length(pfs)
    
end

"""
```
    hasPlFinished(gm, pl)
```
Test whether player `pl` has all their pieces in their goal range.
"""
function hasPlFinished(gm, pl)
    return length(piecePositionStruct(gm, pl).inGoal) == 4
end

