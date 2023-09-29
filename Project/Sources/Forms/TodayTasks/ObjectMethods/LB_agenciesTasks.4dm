

Case of 
		
	: (Form event code=On Selection Change)
		
		If (Form.selectedAgency#Null)
			Form.tasks:=Form.selectedAgency.todayBookings
		Else 
			Form.tasks:=Null
		End if 
		
		SET TIMER(-1)
		
End case 