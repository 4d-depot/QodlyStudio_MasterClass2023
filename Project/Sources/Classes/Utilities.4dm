Class extends DataClass




exposed Function returnValue($variant : Variant) : Variant
	return $variant
	
exposed Function hideAndShowItem($hide : Text; $show : Text)
	Web Form[$hide].hide()
	Web Form[$show].show()
	
exposed Function sessionInfo()->$result : cs.EmployeeEntity
	$result:=Null
	
	If (Session.storage.userSel#Null)
		$result:=Session.storage.userSel.first().employee
	End if 
	
exposed Function getRole()->$result : Text
	
	$result:=""
	
	If (Session.storage.userSel#Null)
		$result:=Session.storage.userSel.first().role
	End if 
	
	
exposed Function clearSession()->$result : cs.EmployeeEntity
	Session.clearPrivileges()
	Use (Session.storage)
		Session.storage.userSel:=Null
	End use 
	
	$result:=This.sessionInfo()
	
	
exposed Function authenticate($identifier : Text; $password : Text) : Text
	
	var $user : cs.UserEntity
	
	$user:=ds.User.query("mail = :1"; $identifier).first()
	
	If ($user#Null)
		If (Verify password hash($password; $user.passwordHash))
			Session.clearPrivileges()
			Session.setPrivileges(New object("roles"; $user.role; "userName"; $user.firstname+" "+$user.lastname))
			Use (Session.storage)
				Session.storage.userSel:=ds.User.newSelection().add($user).copy(ck shared)
			End use 
			return "OK"
		Else 
			return "Authentication failed: wrong password"
		End if 
	Else 
		return "Authentication failed: wrong user"
	End if 
	
	
exposed Function applyCSS($item : Text; $cssClass : Text)
	Web Form[$item].addCSSClass($cssClass)
	
exposed Function removeCSS($item : Text; $cssClass : Text)
	Web Form[$item].removeCSSClass($cssClass)
	
	
exposed Function selectEntity($reservation : cs.ReservationEntity; $what : Text; $selection : 4D.EntitySelection) : 4D.Entity
	
	Case of 
			
		: ($reservation[$what]#Null)
			If (($reservation[$what].indexOf($selection)#-1))
				return $reservation[$what]
			Else 
				return $selection.first()
			End if 
			
		Else 
			return $selection.first()
	End case 