// jerome 01.05.10 for accessory information pop-up
function showAccessoryInfoModal(parId,itemNo){
	new Ajax.Updater("accessory", contextPath+"/GIPIWMcAccController?action=showAccessory&globalParId="+parId+"&itemNo="+itemNo, {
		method: "GET",
		asynchronous: true,
		evalScripts: true
	});	
	/*Modalbox.show(contextPath+"/GIPIWMcAccController?action=showAccessory&parId="+parId+"&itemNo="+itemNo, {
		title: "Accessory Information",
		width: 600
	});*/
}