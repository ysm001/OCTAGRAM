
class Util

    @includedAngle: (vec1, vec2) ->
        tmp = 1
        if (vec1.y * vec2.x - vec1.x * vec2.y ) < 0
            tmp *= -1
        dot = (vec1.x * vec2.x + vec1.y * vec2.y)
        len1 = Math.sqrt(vec1.x * vec1.x + vec1.y * vec1.y)
        len2 = Math.sqrt(vec2.x * vec2.x + vec2.y * vec2.y)
        tmp * Math.acos(dot/(len1*len2))


    @toDeg: (r) ->
        r * 180.0 / (Math.atan(1.0) * 4.0)

class Stack

    constructor: (@maxSize) ->
        @s = []

    push: (item) ->
        @s.push item if @maxSize >= @s.length

    pop: () ->
        @s.pop() if @s.length > 0

    size: () ->
        @s.length
