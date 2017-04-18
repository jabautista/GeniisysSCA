/*	Created by	: mark jm 05.11.2011
 * 	Description	: create new grouped item object
 * 	Parameters	: newObj - master record
 */
function setGroupedItemsObject(newObj){
	try{
		var groupedItems = new Object();
		
		groupedItems.parId				= objUWParList.parId;
		groupedItems.itemNo				= $F("itemNo");
		groupedItems.groupedItemNo		= $F("groupedItemNo") == "" ? null : removeLeadingZero($F("groupedItemNo"));
		groupedItems.includeTag			= "N";
		groupedItems.groupedItemTitle	= changeSingleAndDoubleQuotes2($F("groupedItemTitle"));
		groupedItems.sex				= nvl($F("sex"), null);
		groupedItems.positionCd			= nvl($F("positionCd"), null);
		groupedItems.civilStatus		= nvl($F("civilStatus"), null);
		groupedItems.dateOfBirth		= nvl($F("dateOfBirth"), null);
		groupedItems.age				= nvl($F("age"), null);
		groupedItems.salary				= nvl($F("salary"), null);
		groupedItems.salaryGrade		= nvl($F("salaryGrade"), null);
		groupedItems.amountCovered		= nvl($F("amountCovered"), null);
		groupedItems.remarks			= changeSingleAndDoubleQuotes2($F("remarks"));
		groupedItems.lineCd				= objUWGlobal.lineCd;
		groupedItems.sublineCd			= $F("globalSublineCd");
		groupedItems.deleteSw			= $("deleteSw").checked ? "Y" : "N";
		groupedItems.groupCd			= nvl($F("groupCd"), null);
		groupedItems.packBenCd			= nvl($F("packBenCd"), null);
		groupedItems.fromDate			= nvl($F("grpFromDate"), null);
		groupedItems.toDate				= nvl($F("grpToDate"), null);
		groupedItems.paytTerms			= nvl($F("paytTerms"), null);
		groupedItems.annTsiAmt			= nvl($F("gAnnTsiAmt"), null);
		groupedItems.annPremAmt			= nvl($F("gAnnPremAmt"), null);
		groupedItems.controlCd			= nvl($F("controlCd"), null);
		groupedItems.controlTypeCd		= nvl($F("controlTypeCd"), null);
		groupedItems.tsiAmt				= nvl($F("tsiAmt"), null);
		groupedItems.premAmt			= nvl($F("premAmt"), null);
		groupedItems.principalCd		= nvl($F("principalCd"), null);
		
		if(newObj == null){
			return groupedItems;
		}else{
			newObj.gipiWGroupedItems = groupedItems;
			return newObj;
		}
	}catch(e){
		showErrorMessage("setGroupedItemsObject", e);
	}
}