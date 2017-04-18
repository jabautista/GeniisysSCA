/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	10.19.2011	mark jm			show populate benefits page
 */
function showPopulateBenefits(command, groupedItemNo, notIn, popChecker){
	try{
		overlayAccidentPopulateBenefits = Overlay.show(contextPath + "/GIPIWAccidentItemController", {
			title : command + " Benefits",
			urlContent : true,
				urlParameters : {
					action : "showPopulateBenefits",
					parId : (objUWGlobal.packParId != null ? objCurrPackPar.parId : objUWParList.parId),
					itemNo : $F("itemNo"),
					selectedGroupedItemNo : groupedItemNo,
					command : command,
					notIn : notIn,
					popChecker : popChecker,
					page : 1},
				width : 600,
				height : 270,
				closable : true,
				draggable : true});
	}catch(e){
		showErrorMessage("showPopulateBenefits", e);
	}
}