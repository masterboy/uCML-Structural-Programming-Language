def factorial(n: int): int => {
	if (n == 0){   
 		echo(n)
     	return 1 
	}
	else {
	    echo(n)
	    return (n * factorial(n - 1))
	}
}

echo(factorial(10)) // prints 3628800