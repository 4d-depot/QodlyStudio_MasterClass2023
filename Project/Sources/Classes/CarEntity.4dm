Class extends Entity


exposed Alias abrandModel model.brandModelString


exposed Alias afullBrandModel model.modelString



Function isAvailable($startDate : Date; $endDate : Date)->$return : Boolean
	var $bookingList : cs.ReservationSelection
	
	var $res1; $res2 : cs.ReservationSelection
	
	$res1:=This.reservations.query("(departureDate >= :1 AND departureDate <= :2)"; $startDate; $endDate)
	$res2:=This.reservations.query("(arrivalDate >= :1 AND arrivalDate <= :2)"; $startDate; $endDate)
	$return:=(($res1.length=0) & ($res2.length=0))
	
	