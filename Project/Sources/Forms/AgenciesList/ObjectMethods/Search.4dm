

var $text : Text

Case of 
	: (Form event code=On Clicked)
		Form.search:=""
		
	: (Form event code=On After Keystroke)
		
		$text:=Get edited text
		
		Form.agencies:=ds.Agency.searchByName($text)
		
		SET TIMER(-1)
		
		
End case 

