module MADN

export setupGame,
       printGameState,
       oneTurn!,

       whoOnBf,
       iOnBf,
       otherOnBf,
       isStartField,
       myPiecePositions,
       myPiecePositionDict




include("pieces.jl")
include("players.jl")

include("game.jl")

include("utils.jl")

include("printing.jl")



end # MADN