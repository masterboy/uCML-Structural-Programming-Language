def max(a:int, b:int, c:int) : int => {
    if (a>b){
        if (a>c){
            return a
        } else {
            return c
        }
    } else {
        if (b>c){
            return b
        } else {
            return c
        }
    }
}

result:int

result = max(2,5,66)

print(result)