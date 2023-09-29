//%attributes = {"invisible":true}


If (Form.selectedTask#Null)
	If (Form.selectedTask.alternatives.length=0)
		OBJECT SET TITLE(*; "AlternativesTitle"; "No alternatives vehicles")
	Else 
		OBJECT SET TITLE(*; "AlternativesTitle"; "Alternatives vehicles")
	End if 
	OBJECT SET VISIBLE(*; "LB_alternatives"; Form.selectedTask.todayTaskType="D")
	OBJECT SET VISIBLE(*; "AlternativesTitle"; Form.selectedTask.todayTaskType="D")
End if 