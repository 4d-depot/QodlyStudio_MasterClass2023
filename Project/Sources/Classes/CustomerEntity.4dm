Class extends Entity



exposed Function get fullname($event : Object) : Text
	
	var $result : Text
	
	If ((This.firstname=Null) && (This.lastname=Null))
		$result:=""
	Else 
		Case of 
			: (This.firstname=Null)
				$result:=This.lastname
			: (This.lastname=Null)
				$result:=This.firstname
			Else 
				$result:=This.firstname+" "+This.lastname
		End case 
	End if 
	return $result
	
	
	
Function query fullname($event : Object)->$result : Object
	
	var $name : Text
	var $operator : Text
	var $parameters : Collection
	var $query : Text
	
	$name:=$event.value
	$operator:=$event.operator
	
	$name:="@"+$name+"@"
	$parameters:=New collection($name)
	
	Case of 
		: ($operator="==") | ($operator="===")
			$query:="firstname = :1 or lastname = :1"
	End case 
	
	$result:=New object("query"; $query; "parameters"; $parameters)