//Remove all row listing (item info and endt item info)
function removeAllRowListing(){
	if ($F("globalLineCd") == "AH"){
		removeAllRowInTable("benefeciaryTable","ben","item",$F("itemNo"));	
		checkTableItemInfoAdditional("benefeciaryTable","beneficiaryListing","ben","item",$F("itemNo"));
	} else if ($F("globalLineCd") == "CA"){
		removeAllRowInTable("personnelTable","per","item",$F("itemNo"));	
		removeAllRowInTable("groupedItemsTable","grpItem","item",$F("itemNo"));	
		checkTableItemInfoAdditional("personnelTable","personnelListing","per","item",$F("itemNo"));
		checkTableItemInfoAdditional("groupedItemsTable","groupedItemsListing","grpItem","item",$F("itemNo"));
	} else if ($F("globalLineCd") == "MC"){
		if (!($("accessory").empty())){
			removeAllRowInTable("accessoryTable","acc","item",$F("itemNo"));	
			checkTableItemInfoAdditional("accessoryTable","accListing","acc","item",$F("itemNo"));
		}
	}	
}