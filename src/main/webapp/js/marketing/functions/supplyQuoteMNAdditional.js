function supplyQuoteMNAdditional(obj){
	try{
		$("geogCd").value				= (obj == null ? "" : nvl(obj.geogCd, ""));
		$("cargoType").value 			= (obj == null ? "" : nvl(obj.cargoType, ""));
		$("cargoClassCd").value			= (obj == null ? "" : nvl(obj.cargoClassCd, ""));
		$("packMethod").value 			= unescapeHTML2(obj == null ? "" : nvl(obj.packMethod, ""));
		$("blAwb").value 				= unescapeHTML2(obj == null ? "" : nvl(obj.blAwb, ""));
		$("transhipOrigin").value 		= unescapeHTML2(obj == null ? "" : nvl(obj.transhipOrigin, ""));
		$("transhipDestination").value 	= unescapeHTML2(obj == null ? "" : nvl(obj.transhipDestination, ""));
		$("voyageNo").value 			= unescapeHTML2(obj == null ? "" : nvl(obj.voyageNo, ""));
		$("lcNo").value 				= unescapeHTML2(obj == null ? "" : nvl(obj.lcNo, ""));
		$("etd").value 					= (obj == null || nvl(obj.etd, "") == "" ? "" : dateFormat(Date.parse(obj.etd), "mm-dd-yyyy"));
		$("eta").value 					= (obj == null || nvl(obj.eta, "") == "" ? "" : dateFormat(Date.parse(obj.eta), "mm-dd-yyyy"));
		$("printTag").value 			= (obj == null ? "" : nvl(obj.printTag, ""));
		$("origin").value 				= unescapeHTML2(obj == null ? "" : nvl(obj.origin, ""));
		$("destn").value 				= unescapeHTML2(obj == null ? "" : nvl(obj.destn, ""));
		$("vesselCd").value				= (obj == null) ? "" : nvl(obj.vesselCd, "");
		
	}catch (e) {
		showErrorMessage("supplyQuoteMNAdditional", e);
	}
}