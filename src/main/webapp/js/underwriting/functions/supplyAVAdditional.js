/*	Created by	: Jerome Orio 03.02.2011
 * 	Description	: supply par information in AV item screen (GIPIS019)
 */
function supplyAVAdditional(obj){
	try{		
		// changed field id's, as per field id's on aviationAdditionalInformation.jsp
		// used to check what vessel fields to be used (selVessel on quotation, vesselCd on par) - emman 04.28.2011
		var vesselId = "selVessel";
		if ($("selVessel") == null || $("selVessel") == undefined) {
			vesselId = "vesselCd";
			
			/*if(itemTablegridSw != "Y" || objUWParList.parType == "E"){// Nica 05.18.2012 - temporarily added condition for endt until AV endt item info is converted to tableGrid
				$(vesselId).value 				= obj == null ? "" : unescapeHTML2(nvl(obj.vesselCd, ""));
				$("airType").value 				= unescapeHTML2($(vesselId).options[$(vesselId).selectedIndex].getAttribute("airDesc"));
				$("rpcNo").value 				= unescapeHTML2($(vesselId).options[$(vesselId).selectedIndex].getAttribute("rpcNo"));
			}else{ */
				$("vesselCd").value				= obj == null ? "" : unescapeHTML2(nvl(obj.vesselCd, ""));
				$("txtVesselName").value		= obj == null ? "" : unescapeHTML2(nvl(obj.vesselName, ""));
				$("airType").value 				= obj == null ? "" : unescapeHTML2(nvl(obj.airDesc, ""));
				$("rpcNo").value 				= obj == null ? "" : unescapeHTML2(nvl(obj.rpcNo, ""));
			//}			
			
			$("totalFlyTime").value 			= obj == null ? "" : unescapeHTML2(formatNumber(nvl(obj.totalFlyTime, "")));
			$("qualification").value 			= obj == null ? "" : unescapeHTML2(nvl(obj.qualification, ""));
			$("purpose").value 					= obj == null ? "" : unescapeHTML2(nvl(obj.purpose, ""));
			$("geogLimit").value 				= obj == null ? "" : unescapeHTML2(nvl(obj.geogLimit, ""));
			$("deductText").value 				= obj == null ? "" : unescapeHTML2(nvl(obj.deductText, ""));
			$("recFlagAv").value 				= obj == null ? "" : unescapeHTML2(nvl(obj.recFlagAv, "A"));
			$("prevUtilHrs").value 				= obj == null ? "" : unescapeHTML2(formatNumber(nvl(obj.prevUtilHrs, "")));
			$("estUtilHrs").value 				= obj == null ? "" : unescapeHTML2(formatNumber(nvl(obj.estUtilHrs, "")));
		} else {
			$(vesselId).value 					= obj == null ? "" : unescapeHTML2(nvl(obj.vesselCd, ""));
			$("txtAirType").value 				= unescapeHTML2($(vesselId).options[$(vesselId).selectedIndex].getAttribute("airDesc"));
			$("txtRpcNo").value 				= unescapeHTML2($(vesselId).options[$(vesselId).selectedIndex].getAttribute("rpcNo"));
			$("txtTotalFlyTime").value 			= obj == null ? "" : unescapeHTML2(formatNumber(nvl(obj.totalFlyTime, "")));
			$("txtQualification").value 		= obj == null ? "" : unescapeHTML2(nvl(obj.qualification, ""));
			$("txtPurpose").value 				= obj == null ? "" : unescapeHTML2(nvl(obj.purpose, ""));
			$("txtGeogLimit").value 			= obj == null ? "" : unescapeHTML2(nvl(obj.geogLimit, ""));
			$("txtDeductText").value 			= obj == null ? "" : unescapeHTML2(nvl(obj.deductText, ""));
			$("txtRecFlagAv").value 			= obj == null ? "" : unescapeHTML2(nvl(obj.recFlagAv, "A"));
			$("txtPrevUtilHrs").value 			= obj == null ? "" : unescapeHTML2(formatNumber(nvl(obj.prevUtilHrs, "")));
			$("txtEstUtilHrs").value 			= obj == null ? "" : unescapeHTML2(formatNumber(nvl(obj.estUtilHrs, "")));
		}
		
		// mark jm 12.08.2011 remove this whole if condition if tablegrid in marine hull is on full implementation
		/*if(itemTablegridSw != "Y"){
			filterAviationVesselLOV(vesselId, $(vesselId).value);
		}	*/	
	}catch(e){
		showErrorMessage("supplyAVAdditional", e);
	}
}