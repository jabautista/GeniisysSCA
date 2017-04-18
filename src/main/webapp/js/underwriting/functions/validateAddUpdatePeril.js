/*	Created by	: joanne 01.21.2014
 * 	Description	: validation for renewal perils
 */
function validateAddUpdatePeril(){
	try{
		var result = true;
		var itemNo = $("txtB480ItemNo").value; 
		var tsiAmt = $("txtB490TsiAmt").value;		
		var highestAlliedTsiAmt = getHighestAlliedTsiAmt3(itemNo);
		var highestBasicTsiAmt = getHighestBasicTsiAmt3(itemNo);
		tsiAmt = (tsiAmt == "") ? 0.00 : parseFloat(unformatCurrencyValue(tsiAmt));
		var requiresBasicPeril	 = false;
		var bascPerlCd = $("txtB490DspBascPerlCd").value;
		var perilType = $("txtB490DspPerilType").value;
		
		if (tsiAmt < 0.00 || tsiAmt > 99999999999999.99) { //if TSI value input is valid	
			$("txtB490TsiAmt").focus();
			$("txtB490TsiAmt").value = "";
			showMessageBox("Invalid TSI Amount. Value should be from 0.01 to 99,999,999,999,999.99.", imgMessage.ERROR);
			result = false;
		} else { 					
			if (bascPerlCd == ""){
				if (perilType == "A"){ //if peril is allied
					var objArrFilteredBasic = objGIEXItmPeril.filter(function(obj){
						return obj.itemNo == itemNo && obj.dspPerilType == 'B'  && obj.recordStatus != -1;});
					
					if(objArrFilteredBasic.length == 0){ //if there is no basic peril yet and allied peril is being added
						$("txtB490PerilCd").value = "";
						$("txtB490DspPerilName").value = "";
						$("txtB490PremAmt").value = ""; 
						$("txtB490TsiAmt").value = "";
						$("txtB490PremRt").value = "";
						showMessageBox("A basic peril should exist before this peril can be added.", imgMessage.ERROR);
						return false;
					}else{
						if (tsiAmt > highestBasicTsiAmt){ //if allied peril being added have higher TSI than highest basic peril
							result = false;
							$("txtB490TsiAmt").value = "";
							$("txtB490TsiAmt").focus();
							$("txtB490PremAmt").value = ""; 
							showMessageBox("TSI Amount must not be greater than "+formatCurrency(highestBasicTsiAmt)+".", imgMessage.ERROR);
						}
					}
				}else{ 
					if ((getPerilCdOfHighestBasicTsi2(itemNo) == $("txtB490PerilCd").value) && (tsiAmt < highestAlliedTsiAmt) ){ 
						result = false;
						$("txtB490TsiAmt").value = "";
						$("txtB490TsiAmt").focus();
						$("txtB490PremAmt").value = ""; 
						showMessageBox("TSI Amount must not be lower than "+formatCurrency(highestAlliedTsiAmt)+".", imgMessage.ERROR);
					}
					var perilCd = $("txtB490PerilCd").value;
					
					var objArrWithBasicPerilCd = objGIEXItmPeril.filter(function(obj){
						return obj.itemNo == itemNo && obj.dspPerilType == 'A' && perilCd == obj.dspBascPerlCd && obj.tsiAmt > tsiAmt  && obj.recordStatus != -1;});
					
					if(objArrWithBasicPerilCd.length > 0) {
						result = false;
						var perilTsiAmt = parseFloat(objArrWithBasicPerilCd.max(function(obj) {
							return parseFloat(obj.tsiAmt); 
						}));
						$("txtB490PremAmt").value = ""; 
						$("txtB490TsiAmt").value = "";
						$("txtB490TsiAmt").focus();
						showMessageBox("TSI Amount must be greater than "+formatCurrency(perilTsiAmt)+".", imgMessage.ERROR);					
					} else {
						var objArrFilteredAllied = objGIEXItmPeril.filter(function(obj){
							return obj.itemNo == itemNo && obj.dspPerilType == 'A' && obj.tsiAmt > tsiAmt  && obj.recordStatus != -1;});
						var objArrFilteredBasic = objGIEXItmPeril.filter(function(obj){
							return obj.itemNo == itemNo && obj.dspPerilType == 'B' && obj.tsiAmt > tsiAmt && obj.perilCd != perilCd  && obj.recordStatus != -1;});
						
						if(objArrFilteredAllied.length > 0 && objArrFilteredBasic < 1){
							result = false;
							var perilTsiAmt = parseFloat(objArrFilteredAllied.max(function(obj) {
								return parseFloat(obj.tsiAmt); 
							}));
							$("txtB490PremAmt").value = ""; 
							$("txtB490TsiAmt").value = "";
							$("txtB490TsiAmt").focus();
							showMessageBox("TSI Amount must be greater than "+formatCurrency(perilTsiAmt)+".", imgMessage.ERROR);					
						}
					}
					
				}
			} else { //if chosen peril has a basic peril	
				requiresBasicPeril	 = true;
				for (var i = 0; i<objGIEXItmPeril.length; i++){
					if ((itemNo == objGIEXItmPeril[i].itemNo)
							&& (bascPerlCd == objGIEXItmPeril[i].perilCd)
							&& (objGIEXItmPeril[i].recordStatus != -1)){
						requiresBasicPeril = false;
					}
				}
				
				if(requiresBasicPeril){
					$("txtB490PerilCd").value = "";
					$("txtB490DspPerilName").value = "";
					$("txtB490PremAmt").value = ""; 
					$("txtB490TsiAmt").value = "";
					$("txtB490PremRt").value = "";
					showMessageBox(bascPerlCd+" should exist before this peril can be added.", imgMessage.ERROR);
					return false;
				}
				
				var objArrFiltered = objGIEXItmPeril.filter(function(obj){	
					return obj.itemNo == itemNo && obj.perilCd == bascPerlCd && obj.tsiAmt < tsiAmt  && obj.recordStatus != -1;});
				if(objArrFiltered.length > 0){
					result = false;
					var bascPerlTsiAmt = objArrFiltered[0].tsiAmt; 
					$("txtB490PremAmt").value = ""; 
					$("txtB490TsiAmt").value = "";
					$("txtB490TsiAmt").focus();
					showMessageBox("TSI Amount must not be greater than "+formatCurrency(bascPerlTsiAmt)+".", imgMessage.ERROR);					
				}
			}
		}
		return result;
	}catch(e){
		showErrorMessage("validateAddUpdatePeril", e);
	}	
}