function populateOtherDetailsFields(obj){
	try{
		$("detSublineCd").value = obj == null? null : obj.sublineCd;
		$("detIssCd").value = obj == null? null : obj.issCd;
		$("evalYy").value = obj == null? null : obj.evalYy;
		$("evalSeqNo").value = obj == null? null : obj.evalSeqNo;
		$("evalVersion").value = obj == null? null : obj.evalVersion;
		$("csoId").value = obj == null? null : unescapeHTML2(obj.csoId);
		
		$("evalDate").value = obj == null? null : obj.evalDate;
		$("inspectDate").value = obj == null? null : obj.inspectDate;
		$("inspectPlace").value = obj == null? null : unescapeHTML2(obj.inspectPlace);
		$("dspAdjusterDesc").value = obj == null? null : unescapeHTML2(obj.dspAdjusterDesc);
		$("dspPayee").value = obj == null? null : unescapeHTML2(obj.dspPayee);
		$("dspEvalDesc").value = obj == null? null : unescapeHTML2(obj.dspEvalDesc);
		$("dspReportTypeDesc").value = obj == null? null : unescapeHTML2(obj.dspReportTypeDesc);
		$("remarks").value = obj == null? null : unescapeHTML2(obj.remarks);
		
		$("hidInspectionDate").value = obj == null? null : obj.inspectDate;
		if($("hidInspectPlace")){ //marco - 05.26.2015 - GENQA SR 4484 - added condition
			$("hidInspectPlace").value = obj == null? null : unescapeHTML2(obj.inspectPlace);	//added by Gzelle 08282014
		}
		if($("hidRemarks")){ //marco - 05.26.2015 - GENQA SR 4484 - added condition
			$("hidRemarks").value = obj == null? null : unescapeHTML2(obj.remarks);	//added by Gzelle 08282014
		}
	}catch(e){
		showErrorMessage("populateOtherDetailsFields",e);
	}
}