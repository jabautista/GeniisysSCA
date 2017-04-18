/*	Created by	: BJGA 02.07.2011
 * 	Description	: appends parameters to be used for processing peril data during saving
 *  Parameters	: objParams - the parameters which will be stringified then sent to the controller 
 */
function includePerilParamsForSaving(objParams){
	try{
		objParams.delDiscSw = $F("delDiscSw");
		objParams.deldiscItemNos = nvl($F("deldiscItemNos"), null);
		objParams.globalPackParId = (objUWGlobal.packParId != null ? objUWGlobal.packParId : $F("globalPackParId"));
		objParams.issCd = (objUWGlobal.packParId != null ? objCurrPackPar.issCd : $F("globalIssCd"));
		objParams.globalPackPolFlag = $F("globalPackPolFlag");
		objParams.updateMinPremFlag = nvl(updateMinPremFlag, "N"); 
		objParams.minPremFlag = nvl(minPremFlag, "");
		
		if(objUWGlobal.lineCd == objLineCds.AC || objUWGlobal.menuLineCd == objLineCds.AC){
			/*objParams.planSw = $F("planSw");
			objParams.planCd = $F("planCd");
			objParams.planChTag = $F("planChTag");	*/
			objParams.planSw = objGIPIWPolbas.planSw == null ? "" : objGIPIWPolbas.planSw;
			objParams.planCd = objGIPIWPolbas.planCd == null ? "" : objGIPIWPolbas.planCd;
			objParams.planChTag = objGIPIWPolbas.planChTag == null ? "" : objGIPIWPolbas.planChTag;
		} else {	//modified by Gzelle 09112014
			objParams.planSw = objGIPIWPolbas.planSw == null ? "" : objGIPIWPolbas.planSw;
			objParams.planCd = objGIPIWPolbas.planCd == null ? "" : objGIPIWPolbas.planCd;
			objParams.planChTag = objGIPIWPolbas.planChTag == null ? "" : objGIPIWPolbas.planChTag;
		}
		return objParams;
	} catch(e){
		showErrorMessage("includePerilParamsForSaving", e);
	}

}