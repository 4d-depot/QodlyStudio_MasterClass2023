Class extends Entity



exposed Function get manager() : Boolean
	return (This.managedAgencies.length>=1)
	
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