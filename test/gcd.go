// "mode debug"

def gcd(x:int, y:int): int => {
    if(y == 0){  
        echo(x)
        return x
    }
    else{   
        gcd(y, x%y)  
    }
   return 0
} 

gcd(14, 21) // prints 7
gcd(4,3)    // prints 1
gcd(225, 115) // prints 5