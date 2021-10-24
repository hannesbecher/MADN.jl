module MADN

export printBoard, makeBoard

const nPlayers = 4
plCols = [:red, :green, :cyan, :yellow]

include("printing.jl")
include("game.jl")
include("pieces.jl")
include("utils.jl")
# board = makeBoard(4)
# printBoard(board)





end # MADN