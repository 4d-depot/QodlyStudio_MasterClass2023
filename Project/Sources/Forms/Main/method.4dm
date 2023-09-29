
var objTabs : Object

Case of 
	: (Form event code=On Load)
		
		
		
		//objTabs:=New object()
		
		//objTabs.values:=["Agencies list"; "Today tasks"]
		//objTabs.index:=0
		
		OBJECT SET SUBFORM(*; "pageContent"; "AgenciesList")
		
		Form.pageContentObj:=New object()
		
		OBJECT SET FONT STYLE(*; "MenuAgencies"; Bold)
		OBJECT SET FONT STYLE(*; "MenuTodayTasks"; Plain)
		
End case 