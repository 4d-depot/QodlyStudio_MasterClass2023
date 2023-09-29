Class extends DataClass


Function dropAndResetTable($tableName : Text)
	
	var $trash : 4D.EntitySelection
	var $table_ptr : Pointer
	
	$trash:=ds[$tableName].all().drop()
	If (Is Windows | Is macOS)
		var $dataclassObj : Object
		
		$dataclassObj:=ds[$tableName]
		$table_ptr:=Table($dataclassObj.getInfo().tableNumber)
		SET DATABASE PARAMETER($table_ptr->; Table sequence number; 0)
	End if 
	
Function randomRegistration() : Text
	var $registration : Text
	var $firstPart; $secondPart; $thirdPart : Text
	var $secondPartNumber : Integer
	
	//(Random%(90-65+1))+65
	$firstPart:=Char((Random%26)+65)+Char((Random%26)+65)
	$secondPartNumber:=(Random%(999))+1
	$secondPart:=(($secondPartNumber<100) ? "0" : "")+(($secondPartNumber<10) ? "0" : "")+String($secondPartNumber)
	$thirdPart:=Char((Random%26)+65)+Char((Random%26)+65)
	
	return $firstPart+"-"+$secondPart+"-"+$thirdPart
	
Function randInt($N : Integer) : Integer
	var $Q; $R : Real
	var $rd : Integer
	
	$N:=$N-1
	
	$Q:=$N\32767
	$R:=$N%32767
	
	C_COLLECTION($listRandom)
	$listRandom:=New collection
	For (i; 1; $Q)
		$listRandom.push(Random)
	End for 
	$listRandom.push(1+$R)
	
	$rd:=$listRandom.sum()
	
	return $rd
	
	
	
Function randomPhone() : Text
	return "0"+String((Random%(9999-1000+1))+1000)+String((Random%(9999-1000+1))+1000)+String((Random%(9))+1)
	
	
Function createCars($nbCars : Integer; $nbDaysPast : Integer)
	
	var $today : Date
	var $tires : Collection
	var $carModels : cs.CarModelSelection
	var $carColors : cs.ColorSelection
	var $agencies : cs.AgencySelection
	
	var $car : cs.CarEntity
	var $rdAge : Integer
	
	var $i : Integer
	var $delta; $choiceTires : Integer
	var $chosenOptions : cs.ChosenOptionsEntity
	
	//drop all cars
	This.dropAndResetTable("Car")
	
	$today:=Current date
	
	$tires:=New collection("Summer"; "Winter"; "All-season")
	$carModels:=ds.CarModel.all()
	$carColors:=ds.Color.all()
	$agencies:=ds.Agency.all()
	
	For ($i; 1; $nbCars)  // Creation of nbCars cars
		$car:=ds.Car.new()
		$car.model:=$carModels[Random%$carModels.length]
		
		$rdAge:=1+(Random%$nbDaysPast)  // car age in days
		$car.buyingDate:=$today-$rdAge  // Random purchase date
		$car.mileage:=(31*$rdAge)  // The vehicule arrives news, then drives around 31 km per day (FR average)
		$car.color:=$carColors[Random%$carColors.length]
		$car.inMaintenance:=False  // Car arrives in good state
		
		$choiceTires:=Random%100  // 97% Summer, 2% All-seasons, 1% Winter
		If ($choiceTires<97)
			$car.tires:=$tires[0]
		Else 
			If ($choiceTires=99)
				$car.tires:=$tires[1]
			Else 
				$car.tires:=$tires[2]
			End if 
		End if 
		
		$car.agency:=$agencies[Random%$agencies.length]
		$car.nextTechnicalVisit:=$car.buyingDate+1277  // First tech visit after 3.5 ans in France
		
		// 1 year insurance validity
		$delta:=Year of($today)-Year of($car.buyingDate)+1
		$car.endOfInsuranceValidity:=$car.buyingDate+(365*$delta)
		
		$car.lastOilChange:=Date("")
		// oil change every 10000 km, so for approx 31km/day =>  322d
		If ($rdAge>322)
			$car.lastOilChange:=$car.buyingDate+322
		Else 
			$car.lastOilChange:=$car.buyingDate
		End if 
		
		$car.registration:=This.randomRegistration()
		$car.save()
	End for 
	
Function createOptions($reservation : cs.ReservationEntity)
	
	var $i; $nbOptions : Integer
	var $options : cs.OptionAvailableSelection
	var $chosenOptions : cs.ChosenOptionsSelection
	
	$nbOptions:=1+(Random%3)  // Between 1 and 3 options
	$options:=ds.OptionAvailable.all()
	
	For ($i; 1; $nbOptions)
		$chosenOptions:=ds.ChosenOptions.new()
		$chosenOptions.reservation:=$reservation
		$chosenOptions.optionChosen:=$options[Random%$options.length]
		$chosenOptions.save()
	End for 
	
	$reservation.save()
	
Function createInventory($reservation : cs.ReservationEntity; $departureFlag : Boolean)->$inventory : cs.InventoryEntity
	
	var $YesNoDefects : Integer
	var $inventory : cs.InventoryEntity
	var $defectiveElements : cs.DefectiveElementSelection
	var $remarks : Collection
	var $rdSeverity : Integer
	
	$YesNoDefects:=Random%10
	$inventory:=ds.Inventory.new()
	$defectiveElements:=ds.DefectiveElement.all()
	
	If ($departureFlag)
		$inventory.date:=$reservation.departureDate
		$inventory.time:=$reservation.departureTime
		$inventory.reservationDeparture:=$reservation
	Else 
		$inventory.date:=$reservation.arrivalDate
		$inventory.time:=$reservation.arrivalTime
		$inventory.reservationArrival:=$reservation
	End if 
	
	$inventory.employee:=$reservation.employee
	$inventory.save()
	
	$remarks:=New collection("The defect is very slight. There’s not a lot of damage to the part, but it has to be reported."; \
		"The defect is light, but there is a small difference compared to the original condition of the part."; \
		"The defect is fairly visible in relation to the normal condition of the vehicle. It should be notified and repaired."; \
		"The defect is rather annoying, one notices it visually and can cause discomfort."; \
		"An average defect. It is not essential to have it repaired, but it is starting to be desirable."; \
		"This is a defect that is quite visible, we can call it slightly above average, but it is quite repairable."; \
		"A defect that begins to be disabling, the defective element should be repaired or replaced as soon as possible."; \
		"The defect is of an advanced gravity level. The part must be repaired or replaced as soon as possible."; \
		"The defect is at the level of almost maximum severity, the repairers must act on the vehicle as soon as possible before its next booking."; \
		"The defect is at the maximum severity level, you must make an appointment with a mechanic to repair it as soon as possible.")
	
	If ($YesNoDefects>8)
		var $defect : cs.DefectEntity
		$defect:=ds.Defect.new()
		$defect.inventory:=$inventory
		$defect.element:=$defectiveElements[Random%$defectiveElements.length]
		$rdSeverity:=1+(Random%10)  // Severity from 1 to 10
		$defect.severity:=$rdSeverity
		$defect.remark:=$remarks[$rdSeverity-1]
		$defect.car:=$reservation.car
		$defect.save()
	End if 
	
	
	
	
	
Function createBookings($nbDaysFuture : Integer)->$ok : Boolean
	
	var $today : Date
	var $dateEnd : Date
	var $hours : Collection
	var $cars : cs.CarSelection
	var $agencies : cs.AgencySelection
	var $listCustomers : cs.CustomerSelection
	var $valStatus : cs.StatusEntity
	var $availOptions : cs.OptionAvailableSelection
	var $abandonOption : cs.OptionAvailableEntity
	var $car : cs.CarEntity
	var $bookingDate : Date
	var $reservation : cs.ReservationEntity
	var $YesNoSameArrival : Integer
	var $option : cs.ChosenOptionsEntity
	var $randomNbDays : Integer
	var $status : Text
	var $randomRestDays : Integer
	var $bookingDate : Date
	
	
	//Dropping tables
	This.dropAndResetTable("Reservation")
	This.dropAndResetTable("Inventory")
	This.dropAndResetTable("Defect")
	This.dropAndResetTable("ChosenOptions")
	
	// Time boundaries initialization
	$today:=Current date
	$dateEnd:=$today+$nbDaysFuture  // We'll create bookings until $dateEnd
	
	$hours:=New collection(?10:00:00?; ?10:00:00?; ?11:00:00?; ?11:00:00?; ?12:00:00?; ?12:00:00?; ?13:00:00?; ?13:00:00?; ?14:00:00?; ?14:00:00?; ?15:00:00?; ?15:00:00?; ?16:00:00?; ?16:00:00?; ?17:00:00?; ?17:00:00?; ?18:00:00?; ?18:00:00?; ?19:00:00?; ?19:00:00?; ?20:00:00?)
	
	$cars:=ds.Car.all()
	$agencies:=ds.Agency.all()
	$listCustomers:=ds.Customer.all()
	$valStatus:=ds.Status.query("label = 'Validated'").first()
	$availOptions:=ds.OptionAvailable.all()
	$abandonOption:=$availOptions.query("label = 'Car abandonment'").first()
	
	//Let's parse all cars in database to generate several bookings for each one of them
	For each ($car; $cars)
		$bookingDate:=$car.buyingDate+1  //no bookings before car purchasing date
		
		While (($bookingDate<$dateEnd))
			$reservation:=ds.Reservation.new()
			$reservation.car:=$car
			//TODO: ugly way to randomize >+ 32k customer
			
			If ($listCustomers.length<=32768)
				$reservation.customer:=$listCustomers[Random%$listCustomers.length]
			Else 
				$reservation.customer:=$listCustomers[This.randInt($listCustomers.length)-1]
			End if 
			
			$reservation.departureAgency:=$car.agency
			$reservation.employee:=$reservation.departureAgency.employees[Random%$reservation.departureAgency.employees.length]
			
			// choose an arrival agency. In 98% cases: same as departure agency
			$YesNoSameArrival:=(Random%100)
			If ($YesNoSameArrival>98)  // different agency
				$reservation.arrivalAgency:=$agencies[Random%$agencies.length]
				//in such case, we add the abandon option to the booking
				$option:=ds.ChosenOptions.new()
				$option.reservation:=$reservation
				$option.optionChosen:=$abandonOption
				$option.save()
			Else   //same as departure
				$reservation.arrivalAgency:=$reservation.departureAgency
			End if 
			
			//Dates: bookings are between 2 and 10 days long
			$reservation.departureDate:=$bookingDate
			$randomNbDays:=2+(Random%9)
			$reservation.arrivalDate:=$reservation.departureDate+$randomNbDays
			
			// Hours
			$reservation.departureTime:=$hours[Random%$hours.length]
			$reservation.arrivalTime:=$hours[Random%$hours.length]
			
			//Status
			$reservation.status:=$valStatus
			
			//Price
			$reservation.price:=($car.model.dailyRentalPrice)*($randomNbDays)
			
			// We give options 7/10 times
			If ((Random%10)<8)
				This.createOptions($reservation)  // let's create a booking option
			End if 
			
			// Update price with options
			$reservation.price+=$reservation.chosenOptions.sum("price")
			$reservation.categoryCar:=$car.model.category
			
			
			// If booking is over, Inventory must be set
			// On attribue des etats des lieux si la reservation est passee, et on attribue un nombre de killometres consommés
			$status:=$reservation.quickStatus
			
			If ($status="Past")
				$reservation.departureInventory:=This.createInventory($reservation; True)
				$reservation.arrivalInventory:=This.createInventory($reservation; False)
				$reservation.kilometersConsumed:=$randomNbDays*31  // let's add some km to the booking
				$car.mileage:=$car.mileage+$reservation.kilometersConsumed
				$car.save()
			Else 
				If ($status="On going")
					$reservation.departureInventory:=This.createInventory($reservation; True)
				End if 
			End if 
			
			$reservation.save()
			
			//prepare the date for next booking creation
			$bookingDate:=$reservation.arrivalDate
			
			//If the booking is On going or in the past, or will start soon, gap with next booking is between 1 to 7 days.
			//If the booking is far in the future, then gap with next booking is between 5 to 15 days
			$randomRestDays:=($reservation.departureDate>=($today+15)) ? (5+(Random%11)) : (1+(Random%7))
			
			// One additional gap day if car must return to departure agency
			If (($randomNbDays<2) & ($YesNoSameArrival>98))
				$randomRestDays:=$randomRestDays+1
			End if 
			
			$bookingDate:=$bookingDate+$randomRestDays  // We let a few gap days after en of booking before placing a new booking
			
		End while 
		
	End for each 
	
	
	
Function genericCSVImport($csvFile : Text; $dataClass : Text; $dropFlag : Boolean; $spliter : Text)
	
	var $file : Text
	var $lines; $header; $fields; $relationDef : Collection
	var $i; $p : Integer
	var $object; $targetEntity : 4D.Entity
	
	
	If ($dropFlag)
		This.dropAndResetTable($dataClass)
	End if 
	
/** We only import csv in empty tables 
* Empty because a drop has been done
*or because of the$dropflag
***/
	
	If (ds[$dataClass].all().length=0)
		
		$file:=Folder(fk resources folder).file($csvFile).getText("UTF-8")
		
		$file:=Replace string($file; "\r"; "")/* for windows */
		$lines:=Split string($file; "\n")/* Split csv into lines */
		$header:=Split string($lines[0]; $spliter)/* retrieve header */
		
		For ($i; 1; $lines.length-1)/* for each line after header */
			$fields:=Split string($lines[$i]; $spliter)/* get all fields */
			If ($fields.length=$header.length)/* check if we have same amount of fields than headers */
				$object:=ds[$dataClass].new()
				For ($p; 0; $header.length-1)/* for each field*/
					Case of 
						: (($fields[$p]="True") | ($fields[$p]="False"))/* if boolean like */
							$object[$header[$p]]:=($fields[$p]="True")
						: ($header[$p]="$rel_@")/* relation, of course this could be optimzed */
							$relationDef:=Split string($header[$p]; "_")
							If ($relationDef.length=4)
								$targetEntity:=ds[$relationDef[1]].query($relationDef[2]+" = '"+$fields[$p]+"'").first()
								$object[$relationDef[3]]:=$targetEntity
							End if 
						Else 
							$object[$header[$p]]:=$fields[$p]
					End case 
				End for 
				$object.save()
			End if 
		End for 
	End if 
	
Function loadOptionPhotos()
	
	var $sel : cs.OptionAvailableSelection
	var $opt : cs.OptionAvailableEntity
	var $label; $path : Text
	
	$sel:=ds.OptionAvailable.all()
	
	For each ($opt; $sel)
		$label:=$opt.label
		$path:="/RESOURCES/OptionImage/"+$label+".jpg"
		$opt.photo:=$path
		$opt.save()
	End for each 
	
Function loadColorPhotos()
	
	var $sel : cs.ColorSelection
	var $i : Integer
	var $col : cs.ColorEntity
	var $id : Text
	var $path : Text
	
	
	$sel:=ds.Color.all()
	$i:=1
	
	For each ($col; $sel)
		$id:=String($i)
		$path:="/RESOURCES/Colors/"+$id+".jpg"
		$col.photo:=$path
		$col.save()
		$i:=$i+1
	End for each 
	
Function setManagerToAgencies()
	var $employees : cs.EmployeeSelection
	var $agencies : cs.AgencySelection
	var $agency : cs.AgencyEntity
	
	$employees:=ds.Employee.all()
	$agencies:=ds.Agency.query("manager == null")
	
	For each ($agency; $agencies)
		$agency.manager:=$employees[Random%$employees.length]
		$employees:=$employees.minus($agency.manager)
		
		If ($employees.length=0)
			$employees:=ds.Employee.all()
		End if 
		$agency.save()
	End for each 
	
Function updateEmployeesInfos($distinctAgency : Boolean)
	
	var $sel : cs.EmployeeSelection
	var $emp : cs.EmployeeEntity
	var $agencies : cs.AgencySelection
	
	var $femalePhotoFiles; $malePhotoFiles : Collection
	
	var $fcount; $mcount : Integer
	
	var $myFile : 4D.File
	
	var $managedAgencies : cs.AgencySelection
	var $status : Object
	
	$sel:=ds.Employee.all()
	$agencies:=ds.Agency.all()
	
	$femalePhotoFiles:=Folder("/RESOURCES/femalefaces/").files()
	$malePhotoFiles:=Folder("/RESOURCES/malefaces/").files()
	
	$fcount:=$femalePhotoFiles.length
	$mcount:=$malePhotoFiles.length
	
	For each ($emp; $sel)
/* get employee photo */
		$myFile:=(Random%2=0) ? ($femalePhotoFiles[Random%$fcount]) : ($malePhotoFiles[Random%$mcount])
		
		$emp.photo:=$myFile.path
		
		$managedAgencies:=$emp.managedAgencies
		
		If ($managedAgencies.length=0)
			$emp.employeeAgency:=$agencies[Random%$agencies.length]
			If ($distinctAgency)
				$agencies:=$agencies.minus($emp.employeeAgency)
			End if 
		Else 
			$emp.employeeAgency:=$managedAgencies[Random%$managedAgencies.length]
		End if 
		
		$status:=$emp.save()
	End for each 
	
	
Function updateCustomersInfos()
	
	var $sel : cs.CustomerSelection
	var $femalePhotoFiles; $malePhotoFiles : Collection
	var $fcount; $mcount : Integer
	var $cust : cs.CustomerEntity
	var $myFile : 4D.File
	
	$sel:=ds.Customer.all()
	
	$femalePhotoFiles:=Folder("/RESOURCES/femalefaces/").files()
	$malePhotoFiles:=Folder("/RESOURCES/malefaces/").files()
	
	$fcount:=$femalePhotoFiles.length
	$mcount:=$malePhotoFiles.length
	
	For each ($cust; $sel)
		$myFile:=(Random%2=0) ? ($femalePhotoFiles[Random%$fcount]) : ($malePhotoFiles[Random%$mcount])
		$cust.photo:=$myFile.path
		$cust.save()
	End for each 
	
	
Function generatePeople($howMany : Integer; $dataClass : Text)
	var $i; $fcount; $lcount; $acount; $rd : Integer
	var $firstnameList; $lastnameList; $addressList : Collection
	var $newEntity : 4D.Entity
	var $day; $month; $year; $monthdays : Integer
	var $firstDay : Date
	var $dateRoot : Text
	
	$firstnameList:=Split string(File("/RESOURCES/firstnames.csv").getText("UTF-8"); "\n")
	$lastnameList:=Split string(File("/RESOURCES/lastnames.csv").getText("UTF-8"); "\n")
	$fcount:=$firstnameList.length
	$lcount:=$lastnameList.length
	If ($dataClass="Customer")
		$addressList:=Split string(File("/RESOURCES/addresses_20k.csv").getText("UTF-8"); "\n")
		$acount:=$addressList.length
	End if 
	
	For ($i; 1; $howMany)
		$newEntity:=ds[$dataClass].new()
		$newEntity.firstname:=$firstnameList[(Random%$fcount)]
		$newEntity.lastname:=$lastnameList[(Random%$lcount)]
		$newEntity.phone:=This.randomPhone()
		$newEntity.mail:=Lowercase($newEntity.firstname)+"."+Lowercase($newEntity.lastname)+"@acme.qodlyrent.com"
		
		If ($dataClass="Customer")
			$newEntity.address:=String((Random%300)+1)+" "+$addressList[(Random%$acount)]
		End if 
		
		$year:=(Random%(2004-1940+1))+1940
		$month:=(Random%(12))+1
		$dateRoot:=String($year)+"-"+($month<10 ? "0" : "")+String($month)
		$firstDay:=Date($dateRoot+"-01T00:00:00")
		$monthdays:=Add to date($firstDay; 0; 1; 0)-$firstDay
		$day:=(Random%($monthdays))+1
		$newEntity.birthdate:=Date($dateRoot+"-"+($day<10 ? "0" : "")+String($day)+"T00:00:00")
		
		$newEntity.save()
	End for 
	
Function generateUsers()
	var $i; $fcount; $lcount; $acount; $rd : Integer
	var $firstnameList; $lastnameList; $addressList : Collection
	var $user : cs.UserEntity
	var $managers : cs.EmployeeSelection
	var $mcount; $ecount : Integer
	var $agency : cs.AgencyEntity
	var $employees : cs.EmployeeSelection
	var $employee : cs.EmployeeEntity
	var $status : Object
	var $photo : 4D.File
	
	If (ds.User.all().length=0)
		
		$user:=ds.User.new()
		$user.mail:="manager@4d.com"
		$user.role:="Manager"
		
		$managers:=ds.Agency.all().manager
		$mcount:=$managers.length
		
		//Update this employee with MSL name + photo
		$employee:=$managers[(Random%$mcount)]
		
		$photo:=File("/RESOURCES/Photo_MSL_manager.JPG")
		$employee.photo:=$photo.path
		$employee.firstname:="Marie-Sophie"
		$employee.lastname:="Yvert"
		$status:=$employee.save()
		
		$user.employee:=$employee
		$user.firstname:=$employee.firstname
		$user.lastname:=$employee.lastname
		$user.passwordHash:=Generate password hash("a")
		$status:=$user.save()
		
		//Search the employees of the agency
		$agency:=$employee.employeeAgency
		
		$employees:=$agency.employees
		$employees:=$employees.minus($user.employee)
		
		$ecount:=$employees.length
		
		$user:=ds.User.new()
		$user.mail:="employee@4d.com"
		$user.role:="Employee"
		
		//Update this employee with MSL name + photo
		$employee:=$employees[(Random%$ecount)]
		
		$photo:=File("/RESOURCES/Photo_MSL_employee.png")
		$employee.photo:=$photo.path
		$employee.firstname:="Marie-Sophie"
		$employee.lastname:="Yvert"
		$status:=$employee.save()
		
		$user.employee:=$employee
		$user.firstname:=$employee.firstname
		$user.lastname:=$employee.lastname
		$user.passwordHash:=Generate password hash("a")
		$status:=$user.save()
		
	Else 
		
		$user:=ds.User.query("role = :1"; "Manager").first()
		$photo:=File("/RESOURCES/Photo_MSL_manager.JPG")
		$employee:=$user.employee
		$employee.photo:=$photo.path
		$status:=$employee.save()
		
		$user:=ds.User.query("role = :1"; "Employee").first()
		$photo:=File("/RESOURCES/Photo_MSL_employee.png")
		$employee:=$user.employee
		$employee.photo:=$photo.path
		$status:=$employee.save()
		
	End if 
	
	
/*
 * This function runs at each login, to ensure basic data is there
 */
exposed Function generateBaseData()
	
	This.genericCSVImport("CategoryAgency.csv"; "CategoryAgency"; False; ";")
	This.genericCSVImport("Region.csv"; "Region"; False; ";")
	This.genericCSVImport("Department.csv"; "Department"; False; ";")
	This.genericCSVImport("Agency.csv"; "Agency"; False; ";")
	If (ds.Employee.all().length=0)
		This.generatePeople((ds.Agency.all().length*2); "Employee")
		This.setManagerToAgencies()
		This.updateEmployeesInfos(True)
	End if 
	
	
Function generatePartial($params : Object; $dropTables : Boolean) : Object
	
	This.generateBaseData()
	
	//Load tables
	This.genericCSVImport("CategoryCar.csv"; "CategoryCar"; $dropTables; ";")
	This.genericCSVImport("DefectCategory.csv"; "DefectCategory"; $dropTables; ";")
	This.genericCSVImport("DefectiveElement.csv"; "DefectiveElement"; $dropTables; ";")
	This.genericCSVImport("CategoryOption.csv"; "OptionCategory"; $dropTables; ";")
	This.genericCSVImport("Status.csv"; "Status"; $dropTables; ";")
	This.genericCSVImport("OptionAvailable.csv"; "OptionAvailable"; $dropTables; ";")
	This.genericCSVImport("Colors.csv"; "Color"; $dropTables; ";")
	This.genericCSVImport("CarModel.csv"; "CarModel"; $dropTables; ";")
	If (ds.Employee.all().length<$params.employees)
		This.generatePeople($params.employees; "Employee")
	End if 
	
	If (ds.Customer.all().length<$params.customers)
		This.generatePeople($params.customers; "Customer")
	End if 
	
	//Load photos
	This.loadOptionPhotos()
	This.loadColorPhotos()
	This.setManagerToAgencies()
	This.updateEmployeesInfos(False)
	This.updateCustomersInfos()
	
	// Generate cars
	This.createCars($params.nbCars; $params.nbPastDays)
	
	// Generate bookings
	This.createBookings($params.nbDaysFuture)
	
	This.generateUsers()
	
	return New object("status"; "success")
	
	
exposed Function generate($datasetSize : Text; $dropTables : Boolean) : Object
	var $nbCars; $nbPastDays; $nbDaysFuture : Integer
	var $params : Object
	
	$datasetSize:=(Count parameters>=1) ? $datasetSize : "Tiny"
	$dropTables:=(Count parameters>=2) ? $dropTables : False
	
	Case of 
		: ($datasetSize="Big")  //Approx 1.3M bookings
			$params:={nbCars: 30000; nbPastDays: 365; nbDaysFuture: 365; customers: 100000; employees: 10000}
		: ($datasetSize="Medium")  //Approx 550k bookings
			$params:={nbCars: 25000; nbPastDays: 180; nbDaysFuture: 180; customers: 50000; employees: 5000}
		: ($datasetSize="Small")  //Approx 112k bookings
			$params:={nbCars: 10000; nbPastDays: 90; nbDaysFuture: 90; customers: 20000; employees: 2000}
		Else   // Tiny
			$params:={nbCars: 200; nbPastDays: 30; nbDaysFuture: 30; customers: 10000; employees: 1000}
	End case 
	
	return This.generatePartial($params; $dropTables)
	