//Set record list per item for item info and endt item info usage.
function setRecordListPerItem(blnApply){
	/*
	var listTableName 	= ["wdeductibleListing2", "itemPerilMotherDiv", "mortgageeInformationDiv", "accListing", "wdeductibleListing3", "carrierListing", "groupedItemsListing", "personnelListing", 
	               		   "beneficiaryListing"];
	var listRowName		= ["ded2", "row2", "rowMortg", "acc", "ded3", "carr", "grpItem", "per", "ben"];
	var listCode 		= ["dedCd", "peril", "mortg", "accCd", "dedCd", "carrVesselCd", "groupedItemNo", "personnelNo" , "beneficiaryNo"];
	*/
	var listTableName 	= ["wdeductibleListing2", "itemPerilMotherDiv", "accListing", "wdeductibleListing3", "carrierListing", "groupedItemsListing", "personnelListing", 
	               		   "beneficiaryListing"];
	var listRowName		= ["ded2", "row2", "acc", "ded3", "carr", "grpItem", "per", "ben"];
	var listCode 		= ["dedCd", "peril", "accCd", "dedCd", "carrVesselCd", "groupedItemNo", "personnelNo" , "beneficiaryNo"];
	if(blnApply){
		for(var index = 0, length = listTableName.length; index < length; index++){				
			$$("div#"+listTableName[index]+" div[name='"+listRowName[index]+"']").each(
				function(row){						
					if(listTableName[index] == "itemPerilMotherDiv"){
						setTableRecordVisibility(row, $F("itemNo"), listTableName[index]+row.getAttribute("item"), listCode[index]);
					} else{
						setTableRecordVisibility(row, $F("itemNo"), listTableName[index], listCode[index]);
					}
				});
		}			
	} else{			
		for(var index = 0, length = listTableName.length; index < length; index++){				
			$$("div#"+listTableName[index]+" div[name='"+listRowName[index]+"']").each(
				function(row){
					row.hide();
				});
		}
	}
}