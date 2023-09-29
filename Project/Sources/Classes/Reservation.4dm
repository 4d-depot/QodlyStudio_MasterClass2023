Class extends DataClass




exposed Function getNewBooking() : cs.ReservationEntity
	
	var $newBooking : cs.ReservationEntity
	
	$newBooking:=ds.Reservation.new()
	$newBooking.departureDate:=Current date
	$newBooking.arrivalDate:=Add to date(Current date; 0; 0; 1)
	
	return $newBooking
	
	
	
	