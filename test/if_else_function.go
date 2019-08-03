// "mode debug"
// This program finds maximum and minimum of two numbers using some unnecessary complex calculations for test purpose

a:int = 20
b:int = 300

def max(a:int, b:int) : int => {
	if (a>b){
		return a
	} else {
		return b
	}
}

def min(a:int, b:int) : int => {
	if (max(a,b) == a){
		return b
	} else {
		return a
	}
}

print(max(a,b)) // prints 300
print(min(a,b)) // prints 20