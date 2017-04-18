function prepareBenInfo(obj) {
	try {
		var benRow = "";
		if(obj != null) {
			var bName		= obj.beneficiaryName == null ? "---" : escapeHTML2(obj.beneficiaryName).truncate(20, "...");
			var bAddress 	= obj.beneficiaryAddr == null ? "---" : escapeHTML2(obj.beneficiaryAddr).truncate(20, "...");
			var bBirthDate 	= obj.dateOfBirth == null ? "---" : obj.dateFormatted == "Y" ? 
								obj.dateOfBirth : dateFormat(obj.dateOfBirth, "mm-dd-yyyy");
			var bAge 		= obj.age == null ? "---" : obj.age;
			var bRelation 	= obj.relation == null ? "---" : obj.relation;
			var bRemarks 	= obj.remarks == null ? "---" : escapeHTML2(obj.remarks).truncate(20, "...");
			var bNum 		= obj.beneficiaryNo == null ? "" : obj.beneficiaryNo;
			
			if(objUWParList.parType == "P"){
				benRow 	=	'<input type="hidden" id="benNo'+bNum+'" name="benNo" value="'+bNum+'" />' +
			 	'<label style="text-align: left; width: 19%; margin-left: 10px;">'+bName+'</label>' + 
				'<label style="text-align: left; width: 15%; margin-right: 10px;">'+bAddress+'</label>' +
				'<label style="text-align: left; width: 14%; margin-right: 10px;">'+bBirthDate+'</label>' +
				'<label style="text-align: left; width: 8%; margin-right: 10px;">'+bAge+'</label>' +
				'<label style="text-align: left; width: 14%; margin-right: 10px;">'+bRelation+'</label>' +
				'<label style="text-align: left; width: 20%;">'+bRemarks+'</label>';
			}else{
				benRow 	=	'<label style="text-align: right; width: 40px;">' + bNum + '</label>' + 
			 	'<label style="text-align: left; width: 200px; margin-left: 10px;">'+bName+'</label>' + 
				'<label style="text-align: left; width: 200px; margin-right: 10px;">'+bAddress+'</label>' +
				'<label style="text-align: left; width: 70px; margin-right: 10px;">'+bBirthDate+'</label>' +
				'<label style="text-align: left; width: 35px; margin-right: 10px;">'+bAge+'</label>' +
				'<label style="text-align: left; width: 100px; margin-right: 10px;">'+bRelation+'</label>' +
				'<label style="text-align: left; width: 200px;">'+bRemarks+'</label>';
			}
			
		}
		return benRow; 
	} catch(e) {
		showErrorMessage("prepareBenInfo", e);
	}
}