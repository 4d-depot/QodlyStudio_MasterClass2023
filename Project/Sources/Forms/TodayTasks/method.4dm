


Case of 
	: (Form event code=On Load)
		
		Form.agencies:=ds.Agency.all()
		
		Form.tasks:=Form.agencies.first().todayBookings
		
		//Form.meta:=New object("fill"; "#eff9f4")
		Form.meta:=New object("fill"; "#6bc799"; "fontWeight"; "bold")
		
		Form.search:="Enter an agency name"
		
		SET TIMER(-1)
		
		
		
	: (Form event code=On Timer)
		SET TIMER(0)
		
		
		If ((Form.agencies.length>=1) && (Form.selectedAgency=Null))
			
			//LISTBOX SELECT ROW(*; "LB_agenciesTasks"; 1; lk replace selection)
			LISTBOX SELECT ROWS(*; "LB_agenciesTasks"; ds.Agency.newSelection().add(Form.agencies.first()); lk replace selection)
		End if 
		
		If (Form.tasks#Null)
			//LISTBOX SELECT ROW(*; "LB_tasks"; 1; lk replace selection)
			LISTBOX SELECT ROWS(*; "LB_tasks"; ds.Reservation.newSelection().add(Form.tasks.first()); lk replace selection)
		End if 
		
		handleAlternatives
		
		
End case 



