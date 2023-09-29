Class extends DataClass




exposed Function searchAvailableCars($reservation : cs.ReservationEntity; $gearbox : Text) : cs.CarSelection
	return $reservation.departureAgency.searchAvailableCars($reservation.departureDate; $reservation.arrivalDate; $gearbox; $reservation.categoryCar)