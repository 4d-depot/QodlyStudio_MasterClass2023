Class extends DataClass




exposed Function searchByName($toSearch : Text) : cs.AgencySelection
	
	If ($toSearch="")
		return This.all()
	Else 
		return This.query("name = :1"; "@"+$toSearch+"@")
	End if 
	