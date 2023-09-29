Class extends Entity





local exposed Function get bookingEstimate() : Real
	
	If (This.dayCount#0)
		return This.car=Null ? 0 : (This.dayCount*This.car.model.dailyRentalPrice)
	Else 
		return 0
	End if 
	
	
local exposed Function get dayCount($event : Object) : Integer
	return ((This.arrivalDate=Null) || (This.departureDate=Null)) ? 0 : This.arrivalDate-This.departureDate
	
	
exposed Function get todayTaskTime() : Time
	Case of 
		: (This.arrivalDate=Current date)
			return (This.arrivalTime ? This.arrivalTime : Time(0))
		: (This.departureDate=Current date)
			return (This.departureTime ? This.departureTime : Time(0))
		Else 
			return Time(0)
	End case 
	
	
exposed Function get todayTaskType() : Text
	
	Case of 
		: (This.arrivalDate=Current date)
			return "A"
		: (This.departureDate=Current date)
			return "D"
		Else 
			return ""
	End case 
	
	
exposed Function get alternatives() : cs.CarSelection
	
	
	Case of 
		: (This.departureAgency=Null)
			return ds.Car.newSelection()
			
		: (Undefined(This.departureDate))
			return ds.Car.newSelection()  //return empty selection
			
		: (This.departureDate=Null)
			return ds.Car.newSelection()  //return empty selection
			
		: (Undefined(This.arrivalDate))
			return ds.Car.newSelection()  //return empty selection
			
		: (This.arrivalDate=Null)
			return ds.Car.newSelection()  //return empty selection
			
		: (This.categoryCar=Null)
			return ds.Car.newSelection()  //return empty selection
			
		: (This.departureDate=Current date)
			return This.departureAgency.searchAvailableCars(This.departureDate; This.arrivalDate; ""; This.categoryCar)
		Else 
			return ds.Car.newSelection()
			
	End case 
	
	
exposed Function confirmBooking()
	
	var $status : Object
	
	This.price:=This.bookingEstimate
	This.employee:=This.departureAgency.manager
	$status:=This.save()
	