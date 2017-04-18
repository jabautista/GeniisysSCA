function deleteItemPeril(){
	var isSelectedExist = false;
	if(!checkItemExists2($F("itemNo"))){
		return false;
	}else if ("Y" == $F("discExists")){
		showMessageBox("Deleting of peril is not allowed because Policy have existing discount. If you want to make any changes please press the button for removing discounts.", "info");
		return false;
		// belle 03112011 - validation of basic and allied peril relationship
	}else if ("B" == $F("perilType")) {
		for (var i=0; i<objGIPIWItemPeril.length; i++){
				if($F("itemNo") == objGIPIWItemPeril[i].itemNo && $F("perilCd") == objGIPIWItemPeril[i].bascPerlCd){
					showMessageBox("The peril '"+objGIPIWItemPeril[i].perilName+"' must be deleted first.", imgMessage.ERROR);
					return false;
				}
		}
	}

	var diffTsiAmt = parseFloat(unformatNumber($F("perilTotalTsiAmt"))) - parseFloat(unformatNumber($F("perilTsiAmt")));
	var totalTsiAmtAllied = 0;
	var tsiAmtAllied = new Array;
	var maxTsiAmtAllied = 0;			
	var maxAlliedName;
	
	for(var i=0; i<objGIPIWItemPeril.length; i++){
		if ($F("itemNo") == objGIPIWItemPeril[i].itemNo && "A" == objGIPIWItemPeril[i].perilType && objGIPIWItemPeril[i].recordStatus != -1) {
			tsiAmtAllied = parseFloat(objGIPIWItemPeril[i].tsiAmt);
			totalTsiAmtAllied += tsiAmtAllied;
					
			if(maxTsiAmtAllied < tsiAmtAllied) {
				maxTsiAmtAllied = tsiAmtAllied;
				maxAlliedName = objGIPIWItemPeril[i].perilName;
			}
		}
	}
	if ("B" == $F("perilType"))
		if (diffTsiAmt < totalTsiAmtAllied ) {
			showMessageBox("The peril '"+maxAlliedName+"' must be deleted first.", imgMessage.ERROR);
			return false;
		}
	
	$$("div[name='row2']").each(function (row)	{
		if (row.hasClassName("selectedRow"))	{
			isSelectedExist = true;
			Effect.Fade(row, {
				duration: .001,
				afterFinish: function (){
					var deletedObj = createObjFromCurrPeril();
					addDeletedObjPeril(objGIPIWItemPeril, deletedObj);
					prepareItemPerilforDelete(1); 
					row.remove();
					clearItemPerilFields();
					checkPerilTableIfEmpty("row2", "itemPerilMotherDiv"+$F("itemNo"), "itemPerilMainDiv");
					checkIfToResizePerilTable("itemPerilMainDiv", "itemPerilMotherDiv"+$F("itemNo"), "row2");
					hideAllItemPerilOptions();
					selectItemPerilOptionsToShow();
					hideExistingItemPerilOptions();
					getTotalAmounts();
					$("deleteTag").value = "N";
				}
			});
		}
	});
	if (!isSelectedExist) {
		showMessageBox("Please select peril to be deleted.", imgMessage.ERROR);
	}
}