/*	Created by	: mark jm 05.12.2011
 * 	Description	: show coverage list
 * 	Parameters	: objArray - records
 */
function showCoverageList(objArray){
	try{		
		for(var i=0, length=objArray.length; i < length; i++){				
			var content = prepareCoverageDisplay(objArray[i]);
			var row = new Element("div");
			
			row.setAttribute("id", (("rowCoverage"+objArray[i].itemNo)+objArray[i].groupedItemNo)+objArray[i].perilCd);
			row.setAttribute("name", "rowCoverage");
			row.setAttribute("parId", objArray[i].parId);
			row.setAttribute("item", objArray[i].itemNo);
			row.setAttribute("grpItem", objArray[i].groupedItemNo);
			row.setAttribute("perilCd", objArray[i].perilCd);			
			row.addClassName("tableRow");			

			row.update(content);

			setRowCoverageObserver(row);			

			$("coverageListing").insert({bottom : row});
		}
		
		//resizeTableBasedOnVisibleRows("coverageTable", "coverageListing");
		checkIfToResizeTable("coverageListing", "rowCoverage");
		checkTableIfEmpty("rowCoverage", "coverageListing");
		setCoverForm(null);
	}catch(e){
		showErrorMessage("showCoverageList", e);
	}
}