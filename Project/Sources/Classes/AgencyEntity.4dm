Class extends Entity





exposed Function get todayBookings() : cs.ReservationSelection
	var $result : cs.ReservationSelection
	
	$result:=This.reservationsDeparted.query("departureDate = :1"; Current date)
	$result:=$result.or(This.reservationsArrived.query("arrivalDate = :1"; Current date))
	return $result.orderBy("todayTaskTime asc")
	
	
	
exposed Function get mostPopularCars()->$result : cs.CarSelection
	
	var $formula : Object
	var $carsWithReservations : cs.CarSelection
	
	
	If (This.cars#Null)
		$carsWithReservations:=This.cars.query("reservations # Null")
		If ($carsWithReservations.length#0)
			$formula:=Formula(This.reservations.length)
			$result:=$carsWithReservations.orderByFormula($formula; dk descending).slice(0; 3)
		Else 
			$result:=Null
		End if 
	Else 
		$result:=Null
	End if 
	
	
	
exposed Function searchAvailableCars($depDate : Date; $arrDate : Date; $gearbox : Text; $category : cs.CategoryCarEntity) : cs.CarSelection
	var $cars : cs.CarSelection
	var $keyGear : Text
	var $availCars; $cars : cs.CarSelection
	var $param : Object
	
	$availCars:=ds.Car.newSelection()
	
	var $formula : Object
	
	$param:=New object("args"; New object("dep"; $depDate; "arr"; $arrDate))
	
	$formula:=Formula(This.isAvailable($1.dep; $1.arr)=True)
	$cars:=This.cars.query($formula; $param)
	
	$keyGear:=$gearbox
	
	If (($keyGear="") | ($keyGear="All"))
		$keyGear:="@"
	End if 
	
	If ($category#Null)
		$cars:=$cars.query("model.gearbox=:1 and model.ID_category_car=:2"; $keyGear; $category.ID)
	Else 
		$cars:=$cars.query("model.gearbox=:1"; $keyGear)
	End if 
	
	return $cars