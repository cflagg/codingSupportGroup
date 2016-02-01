## Simple functions for converting degrees into radians, and vice versa
## 'return' displays the value on screen or passes it to another function

rad = function(degrees) {
	radians = (degrees*pi)/180
  return(radians)
  }

deg = function(radians) {
	degrees = (radians*180)/pi
	return(degrees)
	}
	
