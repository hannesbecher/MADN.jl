module MADN

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
       
       Game

       




include("pieces.jl")
include("players.jl")

include("utils.jl")

include("game.jl")



include("printing.jl")



end # MADN