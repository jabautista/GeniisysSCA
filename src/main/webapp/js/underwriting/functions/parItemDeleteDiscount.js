/*	Created by	: mark jm 12.14.2010
 * 	Description	: updates the values in gipi_witem and set the flag for deleting discount
 */
function parItemDeleteDiscount(blnUpdate){
	var objPre = new Object();
	var objSca = new Object();
	var amount;
	
	function computeAmount(amt1, amt2){
		amount = [];
		objPre = {};
		objSca = {};

		amount = amt1.replace(/,/g, "").split(".");
		objPre[0] = parseInt(nvl(amount[0], "0"));
		objSca[0] = parseInt(nvl(((parseInt(amount[0]) < 0) ? "-" : "") + amount[1], "0"));
		
		amount = amt2.replace(/,/g, "").split(".");
		objPre[1] = parseInt(nvl(amount[0], "0"));
		objSca[1] = parseInt(nvl(((parseInt(amount[0]) < 0) ? "-" : "") + amount[1], "0"));
		
		return addObjectNumbers(objPre, objSca);
	}
	
	for(var i=0, length=objGIPIWPerilDiscount.length; i < length; i++){
		for(var x=0, y=objGIPIWItem.length; x < y; x++){
			if(objGIPIWItem[x].itemNo == objGIPIWPerilDiscount[i].itemNo && nvl(objGIPIWItem[x].recordStatus, 0) != -1){
				objGIPIWItem[x].premAmt = computeAmount(nvl(objGIPIWItem[x].premAmt, "0.00"), nvl(objGIPIWPerilDiscount[i].discountAmt, "0.00"));
				objGIPIWItem[x].premAmt = formatCurrency(parseFloat(objGIPIWItem[x].premAmt) - parseFloat(nvl(objGIPIWPerilDiscount[i].surchargeAmt, "0.00"))); // andrew - 02.08.2012 - to revert the surcharge amt				
				objGIPIWItem[x].annPremAmt = nvl(objGIPIWPerilDiscount[i].origItemAnnPremAmt, objGIPIWItem[x].annPremAmt);
				objGIPIWItem[x].discountSw = "N";
				objGIPIWItem[x].surchargeSw = "N"; // andrew - 02.07.2012				
			}else {
				objGIPIWItem[x].premAmt = objGIPIWItem[x].premAmt; 
				objGIPIWItem[x].annPremAmt = objGIPIWItem[x].annPremAmt;				
				 
				//if(blnUpdate){					
					//objGIPIWItem[x].fromDate	 = $F("dateFormatted") == "Y" ? $F("fromDate") : $F("fromDate").empty() ? $F("globalInceptDate") : $F("fromDate");
					//objGIPIWItem[x].toDate		 = $F("dateFormatted") == "Y" ? $F("toDate") : $F("toDate").empty() ? $F("globalExpiryDate") : $F("toDate");					
				//}
			}
			var dateformatting = /^\d{1,2}(\-)\d{1,2}\1\d{4}$/; // format : mm-dd-yyyy
			 
			if((objGIPIWItem[x].fromDate != null || objGIPIWItem[x].fromDate != undefined) && !(dateformatting.test(objGIPIWItem[x].fromDate))){			 
				objGIPIWItem[x].fromDate = dateFormat(objGIPIWItem[x].fromDate, "mm-dd-yyyy");
			}
			 
			if((objGIPIWItem[x].toDate != null || objGIPIWItem[x].toDate != undefined) && !(dateformatting.test(objGIPIWItem[x].toDate.toDate))){
				objGIPIWItem[x].toDate = dateFormat(objGIPIWItem[x].toDate, "mm-dd-yyyy");
			}
			objGIPIWItem[x].recordStatus = 1;
		}

		for(var z=0; z<objGIPIWItemPeril.length; z++){
			if(objGIPIWItemPeril[z].itemNo == objGIPIWPerilDiscount[i].itemNo && nvl(objGIPIWItemPeril[z].recordStatus, 0) != -1){
				if(objGIPIWItemPeril[z].perilCd == objGIPIWPerilDiscount[i].perilCd){
					objGIPIWItemPeril[z].annPremAmt = nvl(objGIPIWPerilDiscount[i].origPerilAnnPremAmt, objGIPIWItemPeril[z].annPremAmt);
					objGIPIWItemPeril[z].premAmt = computeAmount(nvl(objGIPIWItemPeril[z].premAmt, "0.00"), nvl(objGIPIWPerilDiscount[i].discountAmt, "0.00"));
					objGIPIWItemPeril[z].premAmt = formatCurrency(parseFloat(objGIPIWItemPeril[z].premAmt) - parseFloat(nvl(objGIPIWPerilDiscount[i].surchargeAmt, "0.00"))); // andrew - 02.08.2012 - to revert the surcharge amt
					objGIPIWItemPeril[z].discountSw = "N";
					objGIPIWItemPeril[z].surchargeSw = "N"; // andrew - 02.07.2012
				}
				if(blnUpdate){
					objGIPIWItemPeril[z].fromDate	 = $F("dateFormatted") == "Y" ? $F("fromDate") : $F("fromDate").empty() ? $F("globalInceptDate") : $F("fromDate");
					objGIPIWItemPeril[z].toDate		 = $F("dateFormatted") == "Y" ? $F("toDate") : $F("toDate").empty() ? $F("globalExpiryDate") : $F("toDate");										
				}
				objGIPIWItemPeril[z].recordStatus = 1;
			}
		}
		
		if(!blnUpdate){
			parItemUpdateGipiWPolbas();	
		}
	}
	
	//objFormMiscVariables.miscNbtInvoiceSw = "Y";
	objFormMiscVariables.miscDeletePerilDiscById = "Y";
	objFormMiscVariables.miscDeleteItemDiscById = "Y";
	objFormMiscVariables.miscDeletePolbasDiscById = "Y";
}