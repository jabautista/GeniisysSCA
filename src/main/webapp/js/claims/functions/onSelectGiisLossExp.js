function onSelectGiisLossExp(giclItemPeril, giclLossExpPayees, clmLossExpense, row){
	if($("hidMCTowing").value == unescapeHTML2(row.lossExpCd) && (objCLMGlobal.menuLineCd == "MC" || objCLMGlobal.lineCd == "MC" || objCLMGlobal.lineCd == objLineCds.MC || objCLMGlobal.menuLineCd == objLineCds.MC)){
		$("txtLoss").value = unescapeHTML2(row.lossExpDesc);
		$("txtLoss").setAttribute("lossExpCd", row.lossExpCd);
		getTowAmount(giclItemPeril);
	}else if((objCLMGlobal.menuLineCd == "PA" || objCLMGlobal.lineCd == "PA" || objCLMGlobal.lineCd == objLineCds.AC || objCLMGlobal.menuLineCd == objLineCds.AC || objCLMGlobal.lineCd == "AH" || objCLMGlobal.menuLineCd == "AC") && giclItemPeril.noOfDays > 0){
		$("txtLoss").value = unescapeHTML2(row.lossExpDesc);
		$("txtLoss").setAttribute("lossExpCd", row.lossExpCd);
		getAcBaseAmount();
	}else{
		$("txtLoss").value = unescapeHTML2(row.lossExpDesc);
		$("txtLoss").setAttribute("lossExpCd", row.lossExpCd);
	}
	if($("hidLossExpClass").value == "" && nvl(row.partSw, "N") == "Y"){
		$("hidLossExpClass").value = "P";
	} 
}