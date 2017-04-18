//d.alcantara, 05-22-12
//obj = itemGrouped, objArray = peril grouped
function computeEndtCoverageTotals(itemNo, groupedItemNo) {
	try {
		/*editted by steven 9/6/2012 to populate the values of TSI,Prem, Annual TSI and Annual Prem.*/
		var tsiAmt = 0;
		var premAmt = 0;
		var annTsiAmt = 0;
		var annPremAmt = 0;
		
		var annTsiAmtTemp = 0;
		var annPremAmtTemp = 0;
		var tsiAmtTemp = 0;
		var premAmtTemp = 0;
		
		for ( var i = 0; i < objGIPIItmPerilGrouped.length; i++) {  
			if(objGIPIItmPerilGrouped[i].itemNo == itemNo && objGIPIItmPerilGrouped[i].groupedItemNo == groupedItemNo){
				if(objGIPIItmPerilGrouped[i].perilType == "B"){ // to consider Basic perils only - Nica 10.08.2012
					annTsiAmtTemp += parseFloat(nvl(objGIPIItmPerilGrouped[i].annTsiAmt,0));
				}
				annPremAmtTemp += parseFloat(nvl(objGIPIItmPerilGrouped[i].annPremAmt,0));
				tsiAmtTemp = nvl(objGIPIItmPerilGrouped[i].sumTsiAmt,0);
				premAmtTemp = nvl(objGIPIItmPerilGrouped[i].sumPremAmt,0);
				//break;
			}
		}
		
		for ( var i = 0; i < objGIPIWItmperlGrouped.length; i++) { 
			if(objGIPIWItmperlGrouped[i].itemNo == itemNo && objGIPIWItmperlGrouped[i].groupedItemNo == groupedItemNo && objGIPIWItmperlGrouped[i].recordStatus != -1){
//				annPremAmt += parseFloat(nvl((objGIPIWItmperlGrouped[i].annPremAmt).replace(/,/g,""),0));
				//premAmt += parseFloat(nvl((objGIPIWItmperlGrouped[i].premAmt).replace(/,/g,""),0)); replaced by: Nica 09.28.2012
				premAmt += parseFloat(unformatCurrencyValue(nvl(objGIPIWItmperlGrouped[i].premAmt,0).toString()));
			}
		}
		for ( var i = 0; i < objGIPIWItmperlGrouped.length; i++) { 
			if(objGIPIWItmperlGrouped[i].itemNo == itemNo && objGIPIWItmperlGrouped[i].perilType == "B" 
				&& objGIPIWItmperlGrouped[i].groupedItemNo == groupedItemNo && objGIPIWItmperlGrouped[i].recordStatus != -1){
//				annTsiAmt += parseFloat(nvl((objGIPIWItmperlGrouped[i].annTsiAmt).replace(/,/g,""),0));
				//tsiAmt += parseFloat(nvl((objGIPIWItmperlGrouped[i].tsiAmt).replace(/,/g,""),0)); replaced by: Nica 09.28.2012
				tsiAmt += parseFloat(unformatCurrencyValue(nvl(objGIPIWItmperlGrouped[i].tsiAmt,0).toString()));
			}
		}
		annTsiAmt = parseFloat(tsiAmt) + parseFloat(annTsiAmtTemp); //change by steven 9/24/2012 annTsiAmt 
		annPremAmt = parseFloat(premAmt) + parseFloat(annPremAmtTemp);
		tsiAmt	= parseFloat(tsiAmt) + parseFloat(tsiAmtTemp);
		premAmt	= parseFloat(premAmt) + parseFloat(premAmtTemp);
		$("cTotalTsiAmt").value = formatCurrency(nvl(tsiAmt,0));
		$("cTotalAnnTsiAmt").value = formatCurrency(nvl(annTsiAmt,0));
		$("amountCovered").value = formatCurrency(nvl(annTsiAmt,0));
		$("cTotalPremAmt").value = formatCurrency(nvl(premAmt,0));
		$("cTotalAnnPremAmt").value = formatCurrency(nvl(annPremAmt,0));	
		
		/*
		var totalTsi = 0;
		var totalPrem = 0;
		var annTsi = 0;
		var annPrem = 0;
		 
		for(var i=0; i<objGIPIWItmperlGrouped.length; i++){
			if(objGIPIWItmperlGrouped[i].itemNo == itemNo && objGIPIWItmperlGrouped[i].perilType == "B" 
				&& objGIPIWItmperlGrouped[i].groupedItemNo == groupedItemNo && objGIPIWItmperlGrouped[i].recordStatus != -1){
				totalTsi += parseFloat(objGIPIWItmperlGrouped[i].tsiAmt);
				totalPrem += parseFloat(objGIPIWItmperlGrouped[i].premAmt);
			}
		}
		
		for(var i=0; i<objGIPIItmPerilGrouped.length; i++) {
			if(objGIPIItmPerilGrouped[i].itemNo == itemNo && objGIPIItmPerilGrouped[i].perilType == "B" 
				&& objGIPIItmPerilGrouped[i].groupedItemNo == groupedItemNo && objGIPIItmPerilGrouped[i].recordStatus != -1){
				annTsi += parseFloat(objGIPIItmPerilGrouped[i].annTsiAmt);
				annPrem += parseFloat(objGIPIItmPerilGrouped[i].annPremAmt);
			}
		}
		annTsi += totalTsi;
		annPrem += totalPrem;
		
		$("cTotalTsiAmt").value = formatCurrency(totalTsi);
		$("cTotalPremAmt").value = formatCurrency(totalPrem);
		
		$("cTotalAnnTsiAmt").value = formatCurrency(annTsi);
		$("cTotalAnnPremAmt").value = formatCurrency(annPrem);*/
	} catch(e) {
		showErrorMessage("computeEndtCoverageTotals", e);
	}
}