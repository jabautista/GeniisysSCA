/*	Created by	: mark jm 06.06.2011
 * 	Description	: show accident grouped items listing
 * 	Parameters	: objArray - records
 */
function showAccidentGroupedItemsList(objArray){
	try{
		for(var i=0, length=objArray.length; i < length; i++){
			var content = prepareAccidentGroupedItemsDisplay(objArray[i]);
			var row = new Element("div");

			row.setAttribute("id", (("rowEnrollee"+objArray[i].itemNo)+objArray[i].groupedItemNo));
			row.setAttribute("name", "rowEnrollee");
			row.setAttribute("parId", objArray[i].parId);
			row.setAttribute("item", objArray[i].itemNo);
			row.setAttribute("grpItem", objArray[i].groupedItemNo);
			row.setAttribute("principalCd", objArray[i].principalCd);			
			row.addClassName("tableRow");

			row.update(content);

			setAccidentGroupedItemsRowObserver(row);
			
			$("accidentGroupedItemsListing").insert({bottom : row});				
		}

		//checkIfToResizeTable("accidentGroupedItemsTable", "rowEnrollee");
		resizeTableBasedOnVisibleRows("accidentGroupedItemsTable", "accidentGroupedItemsListing");
		//checkTableIfEmpty("rowEnrollee", "accidentGroupedItemsListing");

		checkPopupsTable("coverageTable", "coverageListing", "rowCoverage");
		checkPopupsTable("bBeneficiaryTable", "bBeneficiaryListing", "rowEnrolleeBen");						
	}catch(e){
		showErrorMessage("showAccidentGroupedItemsList", e);
	}
}