/*	Created by	: mark jm 07.29.2011
 * 	Description	: set the total tsi and prem amt (another version of getTotalAmounts)
 */
function getTotalAmounts2(){
	try{
		/*
		var totalTsi = parseFloat(0);
		var totalPrem = parseFloat(0);
		$$("div#itemPerilMotherDiv"+$F("itemNo")+" div[name='row2']").each(function(r){
			var perilType = r.down("input", 8).value;
			var tsiAmt = parseFloat(r.down("input", 5).value.replace(/,/g, ""));
			var premAmt = parseFloat(r.down("input", 6).value.replace(/,/g, ""));
			if (perilType == "B"){
				totalTsi = totalTsi + tsiAmt;
			} 
			totalPrem = totalPrem + premAmt;
		});
		$("perilTotalTsiAmt").value = formatCurrency(totalTsi);
		$("perilTotalPremAmt").value = formatCurrency(totalPrem);
		confirmChangesInMaintainedRatesAmts();
		*/
		var totalTsi = parseFloat(0);
		var totalPrem = parseFloat(0);
		var objArrFiltered = [];
		//edited by d.alcantara, to include allied perils in computation of total premium amt
		if(objFormMiscVariables.miscCreatePerils == "Y"){
			objArrFiltered = getAddedAndModifiedJSONObjects(objGIPIWItemPeril).filter(function(obj){	return obj.itemNo == $F("itemNo");/* && obj.perilType == "B";*/	});
		}else{	
			objArrFiltered = objGIPIWItemPeril.filter(function(obj){	return obj.itemNo == $F("itemNo") && nvl(obj.recordStatus, 0) != -1;/* && obj.perilType == "B";*/	});
		}
		var tsiAmt = [];
		var premAmt = [];
		var objTsiPre = new Object();
		var objTsiSca = new Object();
		var objPremPre = new Object();
		var objPremSca = new Object();
		var totalPremAmount = 0; // bonok :: 10.04.2012
		var premAmount = 0; // bonok :: 10.04.2012
		var totalTsiAmount = 0; // ruben :: 12.11.2013
		var tsiAmount = 0; // ruben :: 12.11.2013
		
		var j=0;
		for(var i=0, length=objArrFiltered.length; i < length; i++){
			if(objArrFiltered[i].perilType == "B") {
				/* comment out 12.11.2013 */
				//used formatCurrency function to format objArrFiltered[i].tsiAmt into currency form to prevent problem in concatination of whole numbers and decimals by MAC 12/11/2012
				/*tsiAmt = (nvl(formatCurrency(objArrFiltered[i].tsiAmt), "0.00")).replace(/,/g, "").split("."); // edited, changed objArrFiltered[j] to i
				objTsiPre[j] = parseInt(nvl(tsiAmt[0], "0"));
				objTsiSca[j] = parseInt(nvl(((parseInt(tsiAmt[0]) < 0) ? "-" : "") + tsiAmt[1], "0"));
				j++;
				*/
				
				tsiAmount = objArrFiltered[i].tsiAmt; // ruben :: 12.11.2013
				totalTsiAmount = parseFloat(totalTsiAmount) + parseFloat(tsiAmount); // ruben :: 12.11.2013
			}
			
			//premAmt = (nvl(objArrFiltered[i].premAmt, "0.00")).replace(/,/g, "").split("."); // bonok :: 10.04.2012
			//objPremPre[i] = parseInt(nvl(premAmt[0], "0")); // bonok :: 10.04.2012
			//objPremSca[i] = parseInt(nvl(((parseInt(premAmt[0]) < 0) ? "-" : "") + premAmt[1], "0")); // bonok :: 10.04.2012
			
			premAmount = objArrFiltered[i].premAmt; // bonok :: 10.04.2012
			totalPremAmount = parseFloat(totalPremAmount) + parseFloat(premAmount); // bonok :: 10.04.2012
		}
		
		$("perilTotalTsiAmt").value = addSeparatorToNumber(addObjectNumbers(objTsiPre, objTsiSca), ",");
		//$("perilTotalPremAmt").value = addSeparatorToNumber(addObjectNumbers(objPremPre, objPremSca), ","); // bonok :: 10.04.2012
		$("perilTotalTsiAmt").value = formatCurrency(totalTsiAmount); // ruben :: 12.11.2013
		$("perilTotalPremAmt").value = formatCurrency(totalPremAmount); // bonok :: 10.04.2012
		confirmChangesInMaintainedRatesAmts();
	}catch(e){
		showErrorMessage("getTotalAmounts2", e);
	}	
}