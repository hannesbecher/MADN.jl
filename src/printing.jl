
"""
```
lf(c=:white)
```
Print a large field of colour c.
"""
function lf(c=:white)
    printstyled("O", color=c)
end

"""
```
sf(c=:white)
```
Print a small field of colour c.
"""
function sf(c=:white)
    printstyled("o", color=c)
end

"""
Print a space.
"""
function nf()
    print(" ")
end

"""
```
nl()
```
Move cursor to a new line.
"""
function nl()
    print("\n")
end

# lf(:red)
# lf(:green)
# nl()
# lf(:cyan)
# lf(:yellow)
# nl()
# lf();sf();sf();sf();sf();sf()
# nl()

function printBoard(brd)
    nl()
    lf(brd[41].colour)
    lf(brd[42].colour)
    nf()
    nf()
    sf(brd[9].colour)
    sf(brd[10].colour)
    lf(brd[11].colour)
    nf()
    nf()
    lf(brd[45].colour)
    lf(brd[46].colour)
    nl()
    
    lf(brd[43].colour)
    lf(brd[44].colour)
    nf()
    nf()
    sf(brd[8].colour)
    lf(brd[61].colour)
    sf(brd[12].colour)
    nf()
    nf()
    lf(brd[47].colour)
    lf(brd[48].colour)
    nl()
    
    nf()
    nf()
    nf()
    nf()
    sf(brd[7].colour)
    lf(brd[62].colour)
    sf(brd[13].colour)
    nf()
    nf()
    nf()
    nf()
    nl()
    
    nf()
    nf()
    nf()
    nf()
    sf(brd[6].colour)
    lf(brd[63].colour)
    sf(brd[14].colour)
    nf()
    nf()
    nf()
    nf()
    nl()
    
    lf(brd[1].colour)
    sf(brd[2].colour)
    sf(brd[3].colour)
    sf(brd[4].colour)
    sf(brd[5].colour)
    lf(brd[64].colour)
    sf(brd[15].colour)
    sf(brd[16].colour)
    sf(brd[17].colour)
    sf(brd[18].colour)
    sf(brd[19].colour)
    nl()
    
    sf(brd[40].colour)
    lf(brd[57].colour)
    lf(brd[58].colour)
    lf(brd[59].colour)
    lf(brd[60].colour)
    nf()
    lf(brd[68].colour)
    lf(brd[67].colour)
    lf(brd[66].colour)
    lf(brd[65].colour)
    sf(brd[20].colour)
    nl()
    
    sf(brd[39].colour)
    sf(brd[38].colour)
    sf(brd[37].colour)
    sf(brd[36].colour)
    sf(brd[35].colour)
    lf(brd[72].colour)
    sf(brd[25].colour)
    sf(brd[24].colour)
    sf(brd[23].colour)
    sf(brd[22].colour)
    lf(brd[21].colour)
    nl()
    
    nf()
    nf()
    nf()
    nf()
    sf(brd[34].colour)
    lf(brd[71].colour)
    sf(brd[26].colour)
    nf()
    nf()
    nf()
    nf()
    nl()
    
    nf()
    nf()
    nf()
    nf()
    sf(brd[33].colour)
    lf(brd[70].colour)
    sf(brd[27].colour)
    nf()
    nf()
    nf()
    nf()
    nl()
    
    lf(brd[53].colour)
    lf(brd[54].colour)
    nf()
    nf()
    sf(brd[32].colour)
    lf(brd[69].colour)
    sf(brd[28].colour)
    nf()
    nf()
    lf(brd[49].colour)
    lf(brd[50].colour)
    nl()
    
    lf(brd[55].colour)
    lf(brd[56].colour)
    nf()
    nf()
    lf(brd[31].colour)
    sf(brd[30].colour)
    sf(brd[29].colour)
    nf()
    nf()
    lf(brd[51].colour)
    lf(brd[52].colour)
    nl()
    nl()
    nl()
end