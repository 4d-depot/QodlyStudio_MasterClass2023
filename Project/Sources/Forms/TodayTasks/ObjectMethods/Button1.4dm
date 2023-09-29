
var $win : Integer
var $data; $status : Object
var $notDropped : cs.ChosenOptionsSelection

$win:=Open form window("ConfirmCancelBooking"; Modal form dialog box; Horizontally centered; Vertically centered)
$data:=New object("task"; Form.selectedTask)
DIALOG("ConfirmCancelBooking"; $data)

If ($data.delete=True)
	$notDropped:=Form.selectedTask.chosenOptions.drop()
	$status:=Form.selectedTask.drop()
	Form.tasks:=Form.tasks.minus(Form.selectedTask)
	SET TIMER(-1)
End if 

