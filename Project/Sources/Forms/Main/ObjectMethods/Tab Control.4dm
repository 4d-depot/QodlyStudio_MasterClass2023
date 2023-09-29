

var $target : Text

Case of 
	: (Form event code=On Clicked)
		
		Case of 
			: (objTabs.currentValue="Agencies list")
				$target:="AgenciesList"
				
			: (objTabs.currentValue="Today tasks")
				$target:="TodayTasks"
				
		End case 
		
		OBJECT SET SUBFORM(*; "pageContent"; $target)
		
		Form.agenciesListObj:=New object()
		
End case 