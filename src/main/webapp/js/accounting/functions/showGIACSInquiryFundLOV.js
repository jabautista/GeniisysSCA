/**
Shows list of Company for giac inquiry(transaction and or)
* @author Kenneth L.
* @date 03.06.2013
* @module GIACS235, GIACS230
*/
function showGIACSInquiryFundLOV(action, fundDesc, FundCdTitle, FundDescTitle, hidFundCd, branchCd, focus) {
	LOV.show({
		controller : "AccountingLOVController",
		urlParameters : {
			action : action,
			company: fundDesc.value,
			page : 1
		},
		title : "List of Funds",
		width : 370,
		height : 400,
		columnModel : [ {
			id : "fundCd",
			title : FundCdTitle,
			width : '100px'
		}, {
			id : "fundDesc",
			title : FundDescTitle,
			width : '235px'
		} ],
		draggable : true,
		autoSelectOneRecord : true,
		filterText : fundDesc.value,
		onSelect : function(row) {
				if(branchCd.value != ""){
					hidFundCd.value = row.fundCd;
					fundDesc.value = row.fundCd + " - " + row.fundDesc;
					enableToolbarButton("btnToolbarExecuteQuery");
				}else{
					hidFundCd.value = row.fundCd;
					fundDesc.value = row.fundCd + " - " + row.fundDesc;
					disableToolbarButton("btnToolbarExecuteQuery");
				}
		},
		onUndefinedRow : function(){
			customShowMessageBox("No record selected.", imgMessage.INFO, focus);
		},
		onCancel: function(){
			fundDesc.focus();
		}
	});
}