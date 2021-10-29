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
        swapPieces!,

        playerOnBF,
        iOnBF,
        otherOnBF,
        kickOut,
        moveAndKick,
        noGapsInGoal,

        bf2pf





include("pieces.jl")
include("players.jl")

include("game.jl")

include("utils.jl")

include("printing.jl")



end # MADN