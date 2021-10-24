
function bf2pf(bf::Int, plNum::Int)
    bf > 56 && error("Board field cannot be > 56.")
    if bf < 41
        return ((5 - plNum) * 10 + bf) % 40
    end
    
end