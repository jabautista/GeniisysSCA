/*	Created by	: mark jm 07.28.2011
 * 	Moved from	: peril information page
 */
function validatePerilTsiAmt2(){
	try{
		var result = true;
		var itemNo = $F("itemNo");
		var tsiAmt = $F("perilTsiAmt").replace(/,/g, "");		
		var perilRate = $("perilRate").value;
		var perilExistsForCurrentItem = false;
		var highestAlliedTsiAmt = getHighestAlliedTsiAmt2(itemNo);
		var highestBasicTsiAmt = getHighestBasicTsiAmt2(itemNo);
		tsiAmt = (tsiAmt == "") ? 0.00 : parseFloat(tsiAmt);
		var allowAlliedMoreThanBasic = nvl(getGiisParamValue("ALLOW_ALLIED_MORE_THAN_BASIC"), 'N'); //added by robert SR 21949 03.23.16
		
		if (tsiAmt < 0.00 || tsiAmt > 99999999999999.99) {
			$("perilTsiAmt").focus();
			$("perilTsiAmt").value = "";
			showMessageBox("Invalid TSI Amount. Value should be from 0.01 to 99,999,999,999,999.99.", imgMessage.ERROR);
			result = false;
		} else if(allowAlliedMoreThanBasic == 'N') { //considered param -- robert SR 21949 03.23.16 //if TSI value input is valid			
			var bascPerlCd = $("bascPerlCd").value;
			var perilType = $("perilType").value;
			
			if (bascPerlCd == ""){
				if (perilType == "A"){
					if (tsiAmt > highestBasicTsiAmt){
						result = false;
						$("perilTsiAmt").value = "";
						$("perilTsiAmt").focus();
						showMessageBox("TSI Amount must not be greater than "+formatCurrency(highestBasicTsiAmt)+".", imgMessage.ERROR);
					}
				}else{ // additional condition added by: Nica 05.07.2012
					if ((getPerilCdOfHighestBasicTsi(itemNo) == $("perilCd").value) && (tsiAmt < highestAlliedTsiAmt) ){ //added condition by robert 10.03.2013 //added by christian 03/16/2013
						result = false;
						$("perilTsiAmt").value = "";
						$("perilTsiAmt").focus();
						showMessageBox("TSI Amount must not be lower than "+formatCurrency(highestAlliedTsiAmt)+".", imgMessage.ERROR);
					}
					/*var perilCd = $("perilCd").value;
					
					var objArrWithBasicPerilCd = objGIPIWItemPeril.filter(function(obj){
						return obj.itemNo == itemNo && obj.perilType == 'A' && perilCd == obj.bascPerlCd && obj.tsiAmt > tsiAmt;});
					
					if(objArrWithBasicPerilCd.length > 0) {
						result = false;
						var perilTsiAmt = parseFloat(objArrWithBasicPerilCd.max(function(obj) {
							return parseFloat(obj.tsiAmt); 
						}));
						$("premiumAmt").value = ""; 
						$("perilTsiAmt").value = "";
						$("perilTsiAmt").focus();
						showMessageBox("TSI Amount must be greater than "+formatCurrency(perilTsiAmt)+".", imgMessage.ERROR);					
					}*/ // commented by d.alcantara, replaced with changes from ucpbgen
					var perilCd = $("perilCd").value;
					
					var objArrWithBasicPerilCd = objGIPIWItemPeril.filter(function(obj){
						return obj.itemNo == itemNo && obj.perilType == 'A' && perilCd == obj.bascPerlCd && obj.tsiAmt > tsiAmt;});
					
					if(objArrWithBasicPerilCd.length > 0) {
						result = false;
						var perilTsiAmt = parseFloat(objArrWithBasicPerilCd.max(function(obj) {
							return parseFloat(obj.tsiAmt); 
						}));
						$("premiumAmt").value = ""; 
						$("perilTsiAmt").value = "";
						$("perilTsiAmt").focus();
						showMessageBox("TSI Amount must be greater than "+formatCurrency(perilTsiAmt)+".", imgMessage.ERROR);					
					} else {
						var objArrFilteredAllied = objGIPIWItemPeril.filter(function(obj){
							return obj.itemNo == itemNo && obj.perilType == 'A' && obj.tsiAmt > tsiAmt;});
						var objArrFilteredBasic = objGIPIWItemPeril.filter(function(obj){
							return obj.itemNo == itemNo && obj.perilType == 'B' && obj.tsiAmt > tsiAmt && obj.perilCd != perilCd;});
						
						if(objArrFilteredAllied.length > 0 && objArrFilteredBasic < 1){
							result = false;
							var perilTsiAmt = parseFloat(objArrFilteredAllied.max(function(obj) {
								return parseFloat(obj.tsiAmt); 
							}));
							$("premiumAmt").value = ""; 
							$("perilTsiAmt").value = "";
							$("perilTsiAmt").focus();
							showMessageBox("TSI Amount must be greater than "+formatCurrency(perilTsiAmt)+".", imgMessage.ERROR);					
						}
					}
					
				}
			} else { //if chosen peril has a basic peril				
				/*
				$$("div[name='row2']").each(function(row){
					if (row.getAttribute("item") == itemNo){
						if (row.getAttribute("peril") == bascPerlCd){
							var bascPerlTsiAmt = parseFloat(row.down("input", 5).value.replace(/,/g, ""));
							if (tsiAmt > bascPerlTsiAmt){
								showMessageBox("TSI Amount must not be greater than "+formatCurrency(bascPerlTsiAmt)+".", imgMessage.ERROR);
								result = false;
								$("premiumAmt").value = ""; 
								$("perilTsiAmt").value = "";
								$("perilTsiAmt").focus();
							} 
						}	
					} 
				});
				*/
				var objArrFiltered = objGIPIWItemPeril.filter(function(obj){	
					return obj.itemNo == itemNo && obj.perilCd == bascPerlCd && obj.tsiAmt < tsiAmt;});
				
				if(objArrFiltered.length > 0){
					result = false;
					var bascPerlTsiAmt = objArrFiltered[0].tsiAmt; // added by Nica 05.03.2012
					$("premiumAmt").value = ""; 
					$("perilTsiAmt").value = "";
					$("perilTsiAmt").focus();
					showMessageBox("TSI Amount must not be greater than "+formatCurrency(bascPerlTsiAmt)+".", imgMessage.ERROR);					
				}
			}
		}
		
		return result;
	}catch(e){
		showErrorMessage("validatePerilTsiAmt2", e);
	}	
}