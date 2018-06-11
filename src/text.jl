module Text

using ColorTypes, Colors.@colorant_str

import SenseHat.LED: RGB565, led_matrix, led_clear

export show_char, show_message, @colorant_str

"""
    show_char(c::Char, color::ColorTypes.AbstractRGB = colorant"white")

Display a single character `c` on the `SenseHat` LED Matrix.
"""
function show_char(c::Char, color::ColorTypes.AbstractRGB = colorant"white")
    if haskey(font, c)
        tocolor(b) = b ? RGB565(color) : RGB565(colorant"black")
        L = PermutedDimsArray(led_matrix(), (2, 1))
        L[:] .= colorant"black"
        L[:,2:6] .= tocolor.(font[c])
    else
        error("Character font for $c not available \n")
    end
    return
end

"""
    show_message(s::String, speed::Real = 0.2, color::ColorTypes.AbstractRGB = colorant"white")

Display a scrolling message `s` on the `SenseHat` LED Matrix. `speed` is the time in seconds per frame and `color` is the color of text.

# Example

```
using SenseHat

show_message("Hello, World!", 0.2, colorant"purple")
```
"""
function show_message(s::String, speed::Real = 0.2, color::ColorTypes.AbstractRGB = colorant"white")
    for c in s
        if haskey(font, c) == false
            error("Character font for $c not available \n")
            return
        end
        img = Array{Bool}(8, 16 + 5*length(s))
        img[1:8,1:8] = Bool.(zeros(8,8))
        img[1:8,(9 + 5*length(s)):(16 + 5*length(s))] = Bool.(zeros(8,8))
        for i in 1:length(s)
            img[1:8, (4 + 5*i):(8 + 5*i)] = font[s[i]]
        end
        tocolor(b) = b ? RGB565(color) : RGB565(colorant"black")
        for i in 1:(size(img,2) - 7)
            frame = tocolor.(img[1:8, i:(i + 7)])
            led_matrix()[:] = permutedims(frame, (2,1))
            sleep(speed)
        end
    return
    end
end

show_message(s::String, color::ColorTypes.AbstractRGB) = show_message(s, 0.2, color)

font = Dict(' ' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; ]),
'+' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 1 1 1 1 1 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 0 0 0 ; ]),
'-' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 1 1 1 1 1 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; ]),
'*' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 1 0 0 ; 1 0 1 0 1 ; 0 1 1 1 0 ; 1 0 1 0 1 ; 0 0 1 0 0 ; 0 0 0 0 0 ; ]),
'/' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 1 ; 0 0 0 1 0 ; 0 0 1 0 0 ; 0 1 0 0 0 ; 1 0 0 0 0 ; 0 0 0 0 0 ; ]),
'!' => Bool.([0 0 0 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 0 0 0 ; 0 0 1 0 0 ; ]),
'"' => Bool.([0 0 0 0 0 ; 0 1 0 1 0 ; 0 1 0 1 0 ; 0 1 0 1 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; ]),
'#' => Bool.([0 0 0 0 0 ; 0 1 0 1 0 ; 0 1 0 1 0 ; 1 1 1 1 1 ; 0 1 0 1 0 ; 1 1 1 1 1 ; 0 1 0 1 0 ; 0 1 0 1 0 ; ]),
'$' => Bool.([0 0 0 0 0 ; 0 0 1 0 0 ; 0 1 1 1 1 ; 1 0 1 0 0 ; 0 1 1 1 0 ; 0 0 1 0 1 ; 1 1 1 1 0 ; 0 0 1 0 0 ; ]),
'>' => Bool.([0 0 0 0 0 ; 0 1 0 0 0 ; 0 0 1 0 0 ; 0 0 0 1 0 ; 0 0 0 0 1 ; 0 0 0 1 0 ; 0 0 1 0 0 ; 0 1 0 0 0 ; ]),
'<' => Bool.([0 0 0 0 0 ; 0 0 0 1 0 ; 0 0 1 0 0 ; 0 1 0 0 0 ; 1 0 0 0 0 ; 0 1 0 0 0 ; 0 0 1 0 0 ; 0 0 0 1 0 ; ]),
'0' => Bool.([0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 1 0 0 1 1 ; 1 0 1 0 1 ; 1 1 0 0 1 ; 1 0 0 0 1 ; 0 1 1 1 0 ; ]),
'1' => Bool.([0 0 0 0 0 ; 0 0 1 0 0 ; 0 1 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 1 1 1 0 ; ]),
'2' => Bool.([0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 0 0 0 0 1 ; 0 0 0 1 0 ; 0 0 1 0 0 ; 0 1 0 0 0 ; 1 1 1 1 1 ; ]),
'3' => Bool.([0 0 0 0 0 ; 1 1 1 1 1 ; 0 0 0 1 0 ; 0 0 1 0 0 ; 0 0 0 1 0 ; 0 0 0 0 1 ; 1 0 0 0 1 ; 0 1 1 1 0 ; ]),
'4' => Bool.([0 0 0 0 0 ; 0 0 0 1 0 ; 0 0 1 1 0 ; 0 1 0 1 0 ; 1 0 0 1 0 ; 1 1 1 1 1 ; 0 0 0 1 0 ; 0 0 0 1 0 ; ]),
'5' => Bool.([0 0 0 0 0 ; 1 1 1 1 1 ; 1 0 0 0 0 ; 1 1 1 1 0 ; 0 0 0 0 1 ; 0 0 0 0 1 ; 1 0 0 0 1 ; 0 1 1 1 0 ; ]),
'6' => Bool.([0 0 0 0 0 ; 0 0 1 1 0 ; 0 1 0 0 0 ; 1 0 0 0 0 ; 1 1 1 1 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 1 1 0 ; ]),
'7' => Bool.([0 0 0 0 0 ; 1 1 1 1 1 ; 0 0 0 0 1 ; 0 0 0 1 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; ]),
'8' => Bool.([0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 1 1 0 ; ]),
'9' => Bool.([0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 1 1 1 ; 0 0 0 0 1 ; 0 0 0 1 0 ; 0 1 1 0 0 ; ]),
'.' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 1 1 0 0 ; 0 1 1 0 0 ; ]),
'=' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 1 1 1 1 1 ; 0 0 0 0 0 ; 1 1 1 1 1 ; 0 0 0 0 0 ; 0 0 0 0 0 ; ]),
')' => Bool.([0 0 0 0 0 ; 0 1 0 0 0 ; 0 0 1 0 0 ; 0 0 0 1 0 ; 0 0 0 1 0 ; 0 0 0 1 0 ; 0 0 1 0 0 ; 0 1 0 0 0 ; ]),
'(' => Bool.([0 0 0 0 0 ; 0 0 0 1 0 ; 0 0 1 0 0 ; 0 1 0 0 0 ; 0 1 0 0 0 ; 0 1 0 0 0 ; 0 0 1 0 0 ; 0 0 0 1 0 ; ]),
'A' => Bool.([0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 1 1 1 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; ]),
'B' => Bool.([0 0 0 0 0 ; 1 1 1 1 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 1 1 1 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 1 1 1 0 ; ]),
'C' => Bool.([0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 1 0 0 0 0 ; 1 0 0 0 0 ; 1 0 0 0 0 ; 1 0 0 0 1 ; 0 1 1 1 0 ; ]),
'D' => Bool.([0 0 0 0 0 ; 1 1 1 0 0 ; 1 0 0 1 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 1 0 ; 1 1 1 0 0 ; ]),
'E' => Bool.([0 0 0 0 0 ; 1 1 1 1 1 ; 1 0 0 0 0 ; 1 0 0 0 0 ; 1 1 1 1 0 ; 1 0 0 0 0 ; 1 0 0 0 0 ; 1 1 1 1 1 ; ]),
'F' => Bool.([0 0 0 0 0 ; 1 1 1 1 1 ; 1 0 0 0 0 ; 1 0 0 0 0 ; 1 1 1 1 0 ; 1 0 0 0 0 ; 1 0 0 0 0 ; 1 0 0 0 0 ; ]),
'G' => Bool.([0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 1 0 0 0 0 ; 1 0 1 1 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 1 1 1 ; ]),
'H' => Bool.([0 0 0 0 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 1 1 1 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; ]),
'I' => Bool.([0 0 0 0 0 ; 0 1 1 1 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 1 1 1 0 ; ]),
'J' => Bool.([0 0 0 0 0 ; 0 0 1 1 1 ; 0 0 0 1 0 ; 0 0 0 1 0 ; 0 0 0 1 0 ; 0 0 0 1 0 ; 1 0 0 1 0 ; 0 1 1 0 0 ; ]),
'K' => Bool.([0 0 0 0 0 ; 1 0 0 0 1 ; 1 0 0 1 0 ; 1 0 1 0 0 ; 1 1 0 0 0 ; 1 0 1 0 0 ; 1 0 0 1 0 ; 1 0 0 0 1 ; ]),
'L' => Bool.([0 0 0 0 0 ; 1 0 0 0 0 ; 1 0 0 0 0 ; 1 0 0 0 0 ; 1 0 0 0 0 ; 1 0 0 0 0 ; 1 0 0 0 0 ; 1 1 1 1 1 ; ]),
'M' => Bool.([0 0 0 0 0 ; 1 0 0 0 1 ; 1 1 0 1 1 ; 1 0 1 0 1 ; 1 0 1 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; ]),
'N' => Bool.([0 0 0 0 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 1 0 0 1 ; 1 0 1 0 1 ; 1 0 0 1 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; ]),
'O' => Bool.([0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 1 1 0 ; ]),
'P' => Bool.([0 0 0 0 0 ; 1 1 1 1 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 1 1 1 0 ; 1 0 0 0 0 ; 1 0 0 0 0 ; 1 0 0 0 0 ; ]),
'Q' => Bool.([0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 1 0 1 ; 1 0 0 1 0 ; 0 1 1 0 1 ; ]),
'R' => Bool.([0 0 0 0 0 ; 1 1 1 1 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 1 1 1 0 ; 1 0 1 0 0 ; 1 0 0 1 0 ; 1 0 0 0 1 ; ]),
'S' => Bool.([0 0 0 0 0 ; 0 1 1 1 1 ; 1 0 0 0 0 ; 1 0 0 0 0 ; 0 1 1 1 0 ; 0 0 0 0 1 ; 0 0 0 0 1 ; 1 1 1 1 0 ; ]),
'T' => Bool.([0 0 0 0 0 ; 1 1 1 1 1 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; ]),
'U' => Bool.([0 0 0 0 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 1 1 0 ; ]),
'V' => Bool.([0 0 0 0 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 0 1 0 ; 0 0 1 0 0 ; ]),
'W' => Bool.([0 0 0 0 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 1 0 1 ; 1 0 1 0 1 ; 1 1 0 1 1 ; 1 0 0 0 1 ; ]),
'X' => Bool.([0 0 0 0 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 0 1 0 ; 0 0 1 0 0 ; 0 1 0 1 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; ]),
'Y' => Bool.([0 0 0 0 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 0 1 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; ]),
'Z' => Bool.([0 0 0 0 0 ; 1 1 1 1 1 ; 0 0 0 0 1 ; 0 0 0 1 0 ; 0 0 1 0 0 ; 0 1 0 0 0 ; 1 0 0 0 0 ; 1 1 1 1 1 ; ]),
'a' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 1 1 1 0 ; 0 0 0 0 1 ; 0 1 1 1 1 ; 1 0 0 0 1 ; 0 1 1 1 1 ; ]),
'b' => Bool.([0 0 0 0 0 ; 1 0 0 0 0 ; 1 0 0 0 0 ; 1 0 1 1 0 ; 1 1 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 1 1 0 ; ]),
'c' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 0 ; 1 0 0 0 0 ; 1 0 0 0 1 ; 0 1 1 1 0 ; ]),
'd' => Bool.([0 0 0 0 0 ; 0 0 0 0 1 ; 0 0 0 0 1 ; 0 1 1 0 1 ; 1 0 0 1 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 1 1 1 ; ]),
'e' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 1 1 1 1 1 ; 1 0 0 0 0 ; 0 1 1 1 0 ; ]),
'f' => Bool.([0 0 0 0 0 ; 0 0 0 1 0 ; 0 0 1 0 1 ; 0 0 1 0 0 ; 0 1 1 1 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; ]),
'g' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 1 1 1 1 ; 1 0 0 0 1 ; 0 1 1 1 1 ; 0 0 0 0 1 ; 0 1 1 1 0 ; ]),
'h' => Bool.([0 0 0 0 0 ; 1 0 0 0 0 ; 1 0 0 0 0 ; 1 0 1 1 0 ; 1 1 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; ]),
'i' => Bool.([0 0 0 0 0 ; 0 0 1 0 0 ; 0 0 0 0 0 ; 0 1 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 1 1 1 0 ; ]),
'j' => Bool.([0 0 0 0 0 ; 0 0 0 1 0 ; 0 0 0 0 0 ; 0 0 0 1 0 ; 0 0 0 1 0 ; 0 0 0 1 0 ; 1 0 0 1 0 ; 0 1 1 0 0 ; ]),
'k' => Bool.([0 0 0 0 0 ; 0 1 0 0 0 ; 0 1 0 0 0 ; 0 1 0 0 1 ; 0 1 0 1 0 ; 0 1 1 0 0 ; 0 1 0 1 0 ; 0 1 0 0 1 ; ]),
'l' => Bool.([0 0 0 0 0 ; 0 1 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 1 1 1 0 ; ]),
'm' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 1 1 0 1 0 ; 1 0 1 0 1 ; 1 0 1 0 1 ; 1 0 1 0 1 ; 1 0 1 0 1 ; ]),
'n' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 1 0 1 1 0 ; 1 1 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; ]),
'o' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 1 1 0 ; ]),
'p' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 1 1 1 1 0 ; 1 0 0 0 1 ; 1 1 1 1 0 ; 1 0 0 0 0 ; 1 0 0 0 0 ; ]),
'q' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 1 1 1 1 ; 1 0 0 0 1 ; 0 1 1 1 1 ; 0 0 0 0 1 ; 0 0 0 0 1 ; ]),
'r' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 1 0 1 1 ; 0 1 1 0 0 ; 0 1 0 0 0 ; 0 1 0 0 0 ; 0 1 0 0 0 ; ]),
's' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 1 1 1 1 ; 1 0 0 0 0 ; 0 1 1 1 0 ; 0 0 0 0 1 ; 1 1 1 1 0 ; ]),
't' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 1 0 0 ; 0 1 1 1 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 1 ; 0 0 0 1 0 ; ]),
'u' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 1 1 ; 0 1 1 0 1 ; ]),
'v' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 0 1 0 1 0 ; 0 0 1 0 0 ; ]),
'w' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 1 0 0 0 1 ; 1 0 0 0 1 ; 1 0 1 0 1 ; 1 0 1 0 1 ; 0 1 0 1 0 ; ]),
'x' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 1 1 0 0 1 ; 0 0 1 1 0 ; 0 0 1 0 0 ; 0 1 1 0 0 ; 1 0 0 1 1 ; ]),
'y' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 1 0 0 0 1 ; 0 1 0 0 1 ; 0 0 1 1 0 ; 0 0 1 0 0 ; 1 1 0 0 0 ; ]),
'z' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 1 1 1 1 1 ; 0 0 0 1 0 ; 0 0 1 0 0 ; 0 1 0 0 0 ; 1 1 1 1 1 ; ]),
'?' => Bool.([0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 0 0 0 0 1 ; 0 0 0 1 0 ; 0 0 1 0 0 ; 0 0 0 0 0 ; 0 0 1 0 0 ; ]),
',' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 1 1 0 0 ; 0 0 1 0 0 ; 0 1 0 0 0 ; ]),
';' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 1 1 0 0 ; 0 1 1 0 0 ; 0 0 0 0 0 ; 0 1 1 0 0 ; 0 0 1 0 0 ; 0 1 0 0 0 ; ]),
':' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 1 1 0 0 ; 0 1 1 0 0 ; 0 0 0 0 0 ; 0 1 1 0 0 ; 0 1 1 0 0 ; 0 0 0 0 0 ; ]),
'|' => Bool.([0 0 0 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; 0 0 1 0 0 ; ]),
'@' => Bool.([0 0 0 0 0 ; 0 1 1 1 0 ; 1 0 0 0 1 ; 0 0 0 0 1 ; 0 1 1 0 1 ; 1 0 1 0 1 ; 1 0 1 0 1 ; 0 1 1 1 0 ; ]),
'%' => Bool.([0 0 0 0 0 ; 1 1 0 0 0 ; 1 1 0 0 1 ; 0 0 0 1 0 ; 0 0 1 0 0 ; 0 1 0 0 0 ; 1 0 0 1 1 ; 0 0 0 1 1 ; ]),
'[' => Bool.([0 0 0 0 0 ; 0 1 1 1 0 ; 0 1 0 0 0 ; 0 1 0 0 0 ; 0 1 0 0 0 ; 0 1 0 0 0 ; 0 1 0 0 0 ; 0 1 1 1 0 ; ]),
'&' => Bool.([0 0 0 0 0 ; 0 1 1 0 0 ; 1 0 0 1 0 ; 1 0 1 0 0 ; 0 1 0 0 0 ; 1 0 1 0 1 ; 1 0 0 1 0 ; 0 1 1 0 1 ; ]),
'_' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 1 1 1 1 1 ; ]),
'\'' => Bool.([0 0 0 0 0 ; 0 1 1 0 0 ; 0 0 1 0 0 ; 0 1 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; ]),
']' => Bool.([0 0 0 0 0 ; 0 1 1 1 0 ; 0 0 0 1 0 ; 0 0 0 1 0 ; 0 0 0 1 0 ; 0 0 0 1 0 ; 0 0 0 1 0 ; 0 1 1 1 0 ; ]),
'\\' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 1 0 0 0 0 ; 0 1 0 0 0 ; 0 0 1 0 0 ; 0 0 0 1 0 ; 0 0 0 0 1 ; 0 0 0 0 0 ; ]),
'~' => Bool.([0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 1 1 0 1 ; 1 0 1 1 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0 ; ]));

end #module