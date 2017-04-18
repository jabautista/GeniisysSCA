/*Parameters to retrieve default peril amounts (With Tariff)
 * Gzelle 11262014
 * */
function supplyDefPerilAmtParam(lineCd, commonObj, obj) {
	try {
		objDefaultPerilAmts.coverageCd  	   = commonObj == null ? "" : commonObj.coverageCd;
		
		if (lineCd == "MC") {
			objDefaultPerilAmts.sublineTypeCd  = obj == null ? "" : obj.sublineTypeCd;
			objDefaultPerilAmts.motorTypeCd	   = obj == null ? "" : obj.motType;
		} else if (lineCd == "FI") {
			objDefaultPerilAmts.tariffZone	   = obj == null ? "" : obj.tariffZone;
			objDefaultPerilAmts.tarfCd		   = obj == null ? "" : obj.tarfCd;
			objDefaultPerilAmts.constructionCd = obj == null ? "" : obj.constructionCd;
		}
	} catch (e) {
		showErrorMessage("supplyDefPerilAmtParam", e);
	}
}