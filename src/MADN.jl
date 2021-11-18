module MADN
using Random
export setupGame,
       printGameState,
       oneTurn!,
       whoseTurn,
       
       whoOnBf,
       iOnBf,
       otherOnBf,
       isStartField,
       myPiecePositions,
       piecePositionStruct,
       myPiecePositionStruct,       
       kickBackToWhere,
       startFromWhere,
       playerOnBF,
       iOnBF,
       otherOnBF,
       gapsInGoal,
       hasPlFinished,       
       bf2pf,
       pf2bf,

       swapPieces!,       
       kickOut,
       moveAndKick!,
       rollAndMove!,
       gatherIntelligence,

       Strategy,
       makeStrategy,
       pieceWeights,
       Player,
       
       Game,

       oneGame

       




include("pieces.jl")
include("players.jl")

include("utils.jl")

include("game.jl")



include("printing.jl")



function oneGame(nPl=4, noPrint=true; seed=nothing)
    if !isnothing(seed)
        Random.seed!(seed)
    end
    a = setupGame(nPl)
    while length(a.events["finishingOrder"]) < 3 
        oneTurn!(a, prnt=!noPrint)
    end   
    return a.events
end

end # MADN