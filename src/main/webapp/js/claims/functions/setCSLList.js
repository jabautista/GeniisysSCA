function setCSLList(param){
	var objArray = cslTableGrid.getModifiedRows();
	
	if(param == "Print"){
		objArray = objArray.filter(function(obj){ return nvl(obj.cslNo, "") != "" && obj.printTag == true;});
	}else{
		objArray = objArray.filter(function(obj){ return nvl(obj.cslNo, "") == "" && obj.generateTag == true;});
	}
	
	
	var cslList = [];
	
	for(var i=0; i<objArray.length; i++){
		var csl = new Object();
		csl.claimId = objCLMGlobal.claimId;
		csl.sublineCd = objCLMGlobal.sublineCd;
		csl.issCd = objCLMGlobal.issueCode;
		csl.clmyy = objCLMGlobal.claimYy;
		csl.itemNo = objCurrGICLItemPeril.itemNo;
		csl.payeeClassCd = objArray[i].payeeClassCd;
		csl.payeeCd = objArray[i].payeeCd;
		csl.clmLossId = objArray[i].clmLossId;
		csl.tpSw = objArray[i].thirdPartyTag == true ? "Y" : "N";
		csl.remarks = objArray[i].remarks == null ? null :  objArray[i].remarks.replace(/\\/g, "&#92;"); //added condition for null remarks robert 10.22.2013 //added replace by Halley 10.03.2013 - workaround to retain backslashes after prepareJsonAsParameter
		csl.cancelSw = "";
		csl.evalId = objArray[i].evalId;
		csl.classDesc = objArray[i].classDesc; // irwin
		csl.cslNo = objArray[i].cslNo; // andrew
		cslList.push(csl);
	}
	return cslList;
}