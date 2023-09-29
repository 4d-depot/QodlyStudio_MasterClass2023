//%attributes = {"invisible":true}


#DECLARE()->$result : Object

var $event : Object

$event:=FORM Event

$result:=New object

Case of 
	: ($event.code=On Display Detail)
		If ($event.isRowSelected)
			$result:=Form.meta
		End if 
End case 