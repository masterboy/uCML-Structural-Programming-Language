def foo(i:int): int => { printi(i) return 0}
def bar(i:int): int => { printi(i) return 1}

def baz(x:int, y:int): int => {
	if(x > y) 
	  { foo(x)}
	else   
	  { bar(y) }

	return 0
} 

baz(30,10)