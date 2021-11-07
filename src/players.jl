
"""
The Strateg type, which contains weights.
"""
struct Strategy
    sWeights::Vector
end

makeStrategy(x=[1, 2, 4, 5, 6, 3, 7]) = Strategy(2 .^ (8 .- x))


"""
The `Player` type for specifying strategies.
"""
struct Player
    strategy::Strategy
end

"""
```
    Player() = Player(makeStrategy())
```
Generate a `Player` with default strategy.
"""
Player() = Player(makeStrategy())
    
