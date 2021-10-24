
function bf2pf(bf::Int, plNum::Int)
    bf > 72 && error("Board field cannot be > 72.")
    if bf < 41
        return ((5 - plNum) * 10 + bf) % 40
    end
    # add goal fields
    
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
Given state of the game, does the piece on `bf` belong to the current player?
"""
function iOnBf(gm, bf)
    return gm.board[bf].player == gm.whoseTurn
end

"""
Given state of the game, does the piece on `bf` belong to any but the current player? Returns `false` if field is empty.
"""
function otherOnBf(gm, bf)
    return gm.board[bf].player in filter(x -> x != gm.whoseTurn, [1,2,3,4])
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

"""
Return the board posistions of all of the active player's pieces in a Dict with keys `waiting`, `inGame`, and `goal`.
"""
function myPiecePositionStruct(gm)
     PPS(filter(isWaiting, playerPiecePositions(gm, gm.whoseTurn)),
         filter(isInGame, playerPiecePositions(gm, gm.whoseTurn)),
         filter(isInGoal, playerPiecePositions(gm, gm.whoseTurn)))
 end

