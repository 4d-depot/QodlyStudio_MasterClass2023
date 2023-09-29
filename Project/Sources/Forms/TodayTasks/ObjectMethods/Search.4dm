
var $text : Text

Case of 
	: (Form event code=On Clicked)
		
		Form.search:=""
		
		
	: (Form event code=On After Keystroke)
		
		$text:=Get edited text
		
		Form.agencies:=ds.Agency.searchByName($text)
		
		If (Form.agencies.length>=1)
			Form.tasks:=Form.agencies.first().todayBookings
		Else 
			Form.tasks:=Null
		End if 
		
		SET TIMER(-1)
		
End case 
