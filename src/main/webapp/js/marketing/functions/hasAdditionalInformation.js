/**
 * Checks if all objects in quotationInformation (MC) has an additional information
 * @author rencela
 * @date 02.16.2012
 */
function hasAdditionalInformation(mcItemArray){
	for(var i =0; i<mcItemArray.length; i++){
		var mcItem = mcItemArray[i];

		if(mcItem.acquiredFrom == "" &&	mcItem.appUser == "" &&	mcItem.assignee == "" && mcItem.basicColor == "" &&
			mcItem.basicColorCd == "" && mcItem.carCompany == "" &&	mcItem.carCompanyCd == "" && mcItem.cocAtcn == "" &&
			mcItem.cocIssueDate == "" && mcItem.cocSeqNo == "" &&	mcItem.cocSerialNo == "" && mcItem.cocType == "" &&
			mcItem.cocYy == "" && mcItem.color == "" &&	mcItem.colorCd == "" && mcItem.createDate == "" &&
			mcItem.createUser == "" && mcItem.ctvTag == "" && mcItem.deductibleAmt == "" && mcItem.destination == "" &&
			mcItem.engineSeries == "" && mcItem.estValue == "" && mcItem.itemNo == "" && mcItem.lastUpdate == "" &&
			mcItem.make == "" && mcItem.makeCd == "" &&	mcItem.modelYear == "" && mcItem.motType == "" &&
			mcItem.motorNo == "" && mcItem.mvFileNo == "" && mcItem.noOfPass == "" && mcItem.origin == "" &&
			mcItem.plateNo == "" && mcItem.quoteId == "" &&	mcItem.repairLim == "" && mcItem.rowCount == "" &&
			mcItem.rowNum == "" && mcItem.serialNo == "" &&	mcItem.seriesCd == "" && mcItem.strLastUpdate == "" &&
			mcItem.subTypeDesc == "" && mcItem.sublineCd == "" && mcItem.sublineTypeCd == "" && mcItem.tariffZone == "" &&
			mcItem.towing == "" && mcItem.typeOfBody == "" && mcItem.typeOfBodyCd == "" && mcItem.unladenWt == ""){
			return false;
		}
	}
	return true;
}