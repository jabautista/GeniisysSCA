/*	Created by	: joanne 01.24.2014
 * 	Description	: validation before deleting renewal perils
 */
function validateDeletePeril(){
	try{
		var result = true;
		var itemNo = $("txtB480ItemNo").value; 
		var tsiAmt = $("txtB490TsiAmt").value;		
		var highestAlliedTsiAmt = getHighestAlliedTsiAmt3(itemNo);
		tsiAmt = (tsiAmt == "") ? 0.00 : parseFloat(unformatCurrencyValue(tsiAmt));
		var perilCd = $("txtB490PerilCd").value;

		var perilType = $("txtB490DspPerilType").value;
		
			if (perilType == "B"){ 
				 //if peril to be deleted is a basic peril and have allied perils
				var objArrFiltered = objGIEXItmPeril.filter(function(obj){	
					return obj.itemNo == itemNo && obj.dspPerilType == 'A' && obj.dspBascPerlCd == perilCd && obj.recordStatus != -1;});
				if(objArrFiltered.length > 0){
					result = false;
					var alliedPerilName = objArrFiltered[0].dspPerilName; 
					showMessageBox("The peril "+alliedPerilName+" must be deleted first.", imgMessage.ERROR);					
				}
				//get all basic perils except current peril
				var objArrBasicPerls = objGIEXItmPeril.filter(function(obj){
					return obj.itemNo == itemNo && obj.dspPerilType == 'B' && perilCd != obj.perilCd && obj.recordStatus != -1;});
				
				if(objArrBasicPerls.length > 0){
					highestCurrBasicTsiAmt = parseFloat(objArrBasicPerls.max(function(obj) {
						return parseFloat(obj.tsiAmt);  
					})); //if peril to be deleted is basic and an allied peril will have the highest tsi than the remaining basic perils
						if(highestAlliedTsiAmt>highestCurrBasicTsiAmt){
							result = false;
							var objArrAlliedPerls = objGIEXItmPeril(function(obj) {
								return obj.itemNo == itemNo && obj.perilCd == getPerilCdOfHighestAlliedTsi(itemNo);});
							var alliedPerilName = objArrAlliedPerls[0].dspPerilName; 
							showMessageBox("The peril "+alliedPerilName+" must be deleted first.", imgMessage.ERROR);	
						}
				}	
				//if peril to be deleted is the only basic peril and there are allied perils
				var objArrFilteredBasic = objGIEXItmPeril.filter(function(obj){
					return obj.itemNo == itemNo && obj.dspPerilType == 'B'  && obj.recordStatus != -1;});
				
				if(objArrFilteredBasic.length == 1){
					var objArrAlliedPerls = objGIEXItmPeril.filter(function(obj) {
						return obj.itemNo == itemNo && obj.dspPerilType == 'A'  && obj.recordStatus != -1;});
					
					if(objArrAlliedPerls.length > 0){
						result = false;
						var alliedPerilName = objArrAlliedPerls[0].dspPerilName; 
						showMessageBox("The peril "+alliedPerilName+" must be deleted first.", imgMessage.ERROR);
					}
				}
			}	
		return result;
	}catch(e){
		showErrorMessage("validateDeletePeril", e);
	}	
}