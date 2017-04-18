/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	10.06.2011	mark jm			show grouped item perils
 * 								Parameters	: no more explanation :D 
 * 10.4.2012    irwin           added fromDate and toDate
 */
function retrieveItmperlGrouped(parId, itemNo, groupedItemNo,fromDate,toDate){
	try{		
		
		new Ajax.Updater("grpItemsCoverageTable", contextPath+"/GIPIWItmperlGroupedController?action=getItmperlGroupedTableGrid&parId="+parId+
				"&itemNo="+itemNo+"&groupedItemNo="+groupedItemNo+"&refresh=0&fromDate="+fromDate+"&toDate="+toDate, {
			method: "GET",
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
				$("grpItemsCoverageTable").hide();
			},
			onComplete: function(){
				$("grpItemsCoverageTable").show();				
			}
		});
	}catch(e){
		showErrorMessage("retrieveItmperlGrouped", e);
	}
}