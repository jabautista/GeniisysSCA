/**
 * Shows list of recipients 
 * @author Kris Felipe
 * @date 03.21.2013
 * @module GIACS071
 */
function showRecipientLOV(){
	try {
		LOV.show({
			controller : "AccountingLOVController", 
			urlParameters : {
				action : "getRecipientsLOV",
				moduleId: "GIACS071",
				page : 1
			},
			title : "List of Recipients",
			width : 500,
			height : 400,
			columnModel : [ 
			{
				id : "intmName",
				title : "Recipient",
				width : '370px'
			},
			{
				id : "intmDesc",
				title : "Type",
				width : '100px'
			}],
			draggable : true,
			autoSelectOneRecord : true,	
			filterText : escapeHTML2($F("txtRecipient")).trim() == "" ? "%" : escapeHTML2($F("txtRecipient")).trim(),
			onSelect : function(row) {
				$("txtRecipient").value = unescapeHTML2(row.intmName);
				$("hidRecipientType").value = row.intmDesc;
				changeTag = 1;
			},
			onUndefinedRow : function(){
				customShowMessageBox("No record selected.", imgMessage.INFO, $("txtRecipient"));
			},
			onCancel: function(){
				$("txtRecipient").focus();
			}
		});
	} catch(e){
		showErrorMessage("showRecipientLOV", e);
	}
}