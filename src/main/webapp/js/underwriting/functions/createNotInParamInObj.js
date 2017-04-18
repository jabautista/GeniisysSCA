function createNotInParamInObj(objArray, funcFilter, attr){
	try{
		var notIn = "";
		var withPrevious = false;

		var objArrFiltered = objArray.filter(funcFilter);

		for(var i=0, length=objArrFiltered.length; i < length; i++){			
			if(withPrevious){
				notIn += ",";
			}
			notIn += "'" + objArrFiltered[i][attr] + "'";
			withPrevious = true;
		}
		
		notIn = (notIn != "" ? "("+notIn+")" : "");
		
		return notIn;
	}catch(e){
		showErrorMessage("createNotInParamInObj", e);
	}
}