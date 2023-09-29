//C_OBJECT($child; $_children)



Case of 
		
	: (Form event code=On Selection Change)
		//setPopularCarsInfo
		
		
		//childrenPortraits:=childrenPortraits*0  // erase pictures
		//childrenNames:=""  // erase names
		
		//$_children:=GetChildren(man)  // get the entity selection of children
		//For each ($child; $_children)
		//COMBINE PICTURES(childrenPortraits; childrenPortraits; Horizontal concatenation; $child.Portrait_0)
		//childrenNames:=childrenNames+$child.Firstname+" ("+String($child.Birthday)+") "
		//End for each 
		
End case 
