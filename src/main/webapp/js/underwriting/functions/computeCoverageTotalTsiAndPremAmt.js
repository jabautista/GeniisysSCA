/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	11.10.2011	mark jm			compute the total tsi and prem amt in coverage (accident)
 */
function computeCoverageTotalTsiAndPremAmt(){
	try{
		var objTsiPre = new Object();
		var objTsiSca = new Object();
//		var objPremPre = new Object(); //remove by steven 1/15/2013
//		var objPremSca = new Object(); //remove by steven 1/15/2013
		var amountTsi;
		var amountPrem = 0;
		var objArray = [];
		
		objArray = objGIPIWItmperlGrouped.filter(function(o){ return nvl(o.recordStatus, 0) != -1 && 
						o.groupedItemNo == $F("groupedItemNo") && o.perilType == "B"; }).slice(0);
		
		objArrayPremAmt = objGIPIWItmperlGrouped.filter(function(o){ return nvl(o.recordStatus, 0) != -1 && 
			o.groupedItemNo == $F("groupedItemNo"); }).slice(0);
		
		for(var i=0, length=objArray.length; i < length; i++){				
			if(objArray[i].tsiAmt != null){
				amountTsi = ((objArray[i].tsiAmt).replace(/,/g, "")).split(".");
				objTsiPre[i] = parseInt(amountTsi[0]);
				objTsiSca[i] = parseInt(((parseInt(amountTsi[0]) < 0) ? "-" : "") + (amountTsi[1] == undefined ? 0 : amountTsi[1]));
			}
			
			/*if(objArray[i].premAmt != null){
				amountPrem = ((objArray[i].premAmt).replace(/,/g, "")).split(".");
				objPremPre[i] = parseInt(amountPrem[0]);
				objPremSca[i] = parseInt(((parseInt(amountPrem[0]) < 0) ? "-" : "") + (amountPrem[1] == undefined ? 0 : amountPrem[1]));
			}*/
		}
		
		// seperate looping for ann_prem_amt. Allied perils are considered for the computation of ann_prem_amt - irwin 9.13.2012
		for(var i=0, length=objArrayPremAmt.length; i < length; i++){				
			if(objArrayPremAmt[i].premAmt != null){
				amountPrem += parseFloat((objArrayPremAmt[i].premAmt).replace(/,/g, "")); //added by steven 1/15/2013
				//remove by steven 1/15/2013 incorrect computation kapag may decimal ung premAmt.
				/*amountPrem = ((objArrayPremAmt[i].premAmt).replace(/,/g, "")).split(".");
				objPremPre[i] = parseInt(amountPrem[0]);
				objPremSca[i] = parseInt(((parseInt(amountPrem[0]) < 0) ? "-" : "") + (amountPrem[1] == undefined ? 0 : amountPrem[1]));*/
				
			}
		}
		
		$("cTotalTsiAmt").value = addSeparatorToNumber(addObjectNumbers(objTsiPre, objTsiSca), ",");
//		$("cTotalPremAmt").value = addSeparatorToNumber(addObjectNumbers(objPremPre, objPremSca), ","); //remove by steven 1/15/2013
		$("cTotalPremAmt").value = formatCurrency(amountPrem); //added by steven 1/15/2013
	}catch(e){
		showErrorMessage("computeCoverageTotalTsiAndPremAmt", e);
	}
}