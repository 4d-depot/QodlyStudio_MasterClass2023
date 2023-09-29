

Case of 
	: (Form event code=On Load)
		
		Form.agencies:=ds.Agency.all()
		
		Form.meta:=New object("fill"; "#6bc799"; "fontWeight"; "bold")
		
		Form.search:="Enter an agency name"
		
		SET TIMER(-1)
		
		
	: (Form event code=On Timer)
		SET TIMER(0)
		
		If (Form.agencies.length>=1)
			LISTBOX SELECT ROWS(*; "LB_agencies"; ds.Agency.newSelection().add(Form.agencies.first()); lk replace selection)
		End if 
		
End case 
