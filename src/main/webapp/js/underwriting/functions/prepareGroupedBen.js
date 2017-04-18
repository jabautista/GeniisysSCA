function prepareGroupedBen(obj) {
	try {
		var benRow = "";
		if(obj != null) {
			var benName = obj.beneficiaryName == null ? "---" : escapeHTML2(obj.beneficiaryName).truncate(20, "...");
			var benAddr = obj.beneficiaryAddr == null ? "---" : escapeHTML2(obj.beneficiaryAddr).truncate(20, "...");
			var bDate	= obj.dateOfBirth == null ? "---" : obj.dateFormatted == "Y" ?
					obj.dateOfBirth : dateFormat(obj.dateOfBirth, "mm-dd-yyyy");
			var age 	= obj.age == null ? "---" : obj.age;
			var relation = obj.relation == null ? "---" : obj.relation;

			benRow = 	'<label style="width: 20%; margin-right: 10px; text-align: left;">'+benName+'</label>' +
						'<label style="width: 17%; margin-right: 10px; text-align: left;>'+benAddr+'</label>' +
						'<label style="width: 10%; margin-right: 10px; text-align: left;>'+bDate+'</label>' +
						'<label style="width: 10%; margin-right: 10px; text-align: left;">'+age+'</label>' + 
						'<label style="width: 14%; margin-right: 10px; text-align: left;">'+relation+'</label>';
		}
		return benRow;
	} catch (e) {
		showErrorMessage("prepareGroupedBen", e);
	}
}