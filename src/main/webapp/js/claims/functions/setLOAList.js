function setLOAList(param){
	var objArray = loaTableGrid.getModifiedRows();
	
	if(param == "Print"){
		objArray = objArray.filter(function(obj){return nvl(obj.loaNo, "") != "" && obj.printTag == true;});
	}else{
		objArray = objArray.filter(function(obj){return nvl(obj.loaNo, "") == "" && obj.generateTag == true;});
	}
	
	var loaList = [];
	
	for(var i=0; i<objArray.length; i++){
		var loa = new Object();
		loa.claimId = objCLMGlobal.claimId;
		loa.sublineCd = objCLMGlobal.sublineCd;
		loa.issCd = objCLMGlobal.issueCode;
		loa.clmyy = objCLMGlobal.claimYy;
		loa.itemNo = objCurrGICLItemPeril.itemNo;
		loa.payeeClassCd = objArray[i].payeeClassCd;
		loa.payeeCd = objArray[i].payeeCd;
		loa.clmLossId = objArray[i].clmLossId;
		loa.tpSw = objArray[i].thirdPartyTag == true ? "Y" : "N";
		loa.tpPayeeClassCd = objArray[i].tpPayeeClassCd;
		loa.tpPayeeNo = objArray[i].tpPayeeNo;
		loa.remarks = objArray[i].remarks == null ? null :  objArray[i].remarks.replace(/\\/g, "&#92;"); //added condition for null remarks robert 10.22.2013  //added replace by Halley 10.03.2013 - workaround to retain backslashes after prepareJsonAsParameter
		loa.cancelSw = "";
		loa.evalId = objArray[i].evalId;
		loa.loaNo = objArray[i].loaNo;// added by irwin
		loaList.push(loa);
	}
	return loaList;
}