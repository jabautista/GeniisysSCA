/*	Created by	: Jerome Orio 03.02.2011
 * 	Description	: setting par information in AV item screen (GIPIS019)
 */
function setAVItemObject(newObj){
	try{
		var gipiWAviationItem = new Object();		
		
		gipiWAviationItem.rpcNo					= escapeHTML2($F("rpcNo"));
		gipiWAviationItem.totalFlyTime			= escapeHTML2(unformatNumber($F("totalFlyTime")));
		gipiWAviationItem.qualification			= escapeHTML2($F("qualification"));
		gipiWAviationItem.purpose				= escapeHTML2($F("purpose"));
		gipiWAviationItem.geogLimit				= escapeHTML2($F("geogLimit"));
		gipiWAviationItem.deductText			= escapeHTML2($F("deductText"));
		gipiWAviationItem.recFlagAv				= escapeHTML2(nvl($F("recFlagAv"),"A"));
		gipiWAviationItem.prevUtilHrs			= escapeHTML2(unformatNumber($F("prevUtilHrs")));
		gipiWAviationItem.estUtilHrs			= escapeHTML2(unformatNumber($F("estUtilHrs")));
		gipiWAviationItem.fixedWing				= "";
		gipiWAviationItem.rotor					= "";
		
		newObj.gipiWAviationItem = gipiWAviationItem;
		
		//mark jm remove if condition anf lov filtering once tablegrid is to be implemented in ucpb 
		/*if(itemTablegridSw != "Y"){
			filterAviationVesselLOV("vesselCd", $("vesselCd").value);
		}else{*/
			gipiWAviationItem.vesselCd				= escapeHTML2($F("vesselCd"));
			gipiWAviationItem.vesselName			= escapeHTML2($F("txtVesselName"));
			gipiWAviationItem.airDesc				= escapeHTML2($F("airType"));
		//}
		
		return newObj;
	}catch(e){
		showMessageBox("setAVItemObject : " + e.message);
	}
}
