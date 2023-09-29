Class extends DataClass



exposed Function searchByName($toSearch : Text) : cs.CustomerSelection
	
	var $formula : Object
	
	$formula:=Formula(This.reservations.length)
	
	If ($toSearch="")
		return This.all().orderByFormula($formula; dk descending)
	Else 
		return This.query("fullname == :1"; $toSearch).orderByFormula($formula; dk descending)
	End if 