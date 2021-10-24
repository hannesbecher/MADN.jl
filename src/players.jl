

"""
The `Player` type for specifying strategies.
"""
struct Player
    kicker::Bool
    avoidsStart::Bool
end

"""
```
    Player() = Player(true, false)
```
Generate a `Player`
"""
Player() = Player(true, false)
    