Class extends EntitySelection




exposed Function orderByNumberOfReservations() : cs.CustomerSelection
	
	var $formula : Object
	
	$formula:=Formula(This.reservations.length)
	
	return This.orderByFormula($formula; dk descending)
	