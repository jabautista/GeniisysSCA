/**
Shows list of branch of a given company for giac inquiry(transaction and or)
* @author Kenneth L.
* @date 03.06.2013
* @module GIACS235, GIACS231
*/
function showGIACSInquiryBranchLOV(moduleId, action, hidFundCd, branchName, branchCdTitle, branchNameTitle, hidBranchCd, fundCd, focus) {
	LOV.show({
		controller : "AccountingLOVController",
		urlParameters : {
			action : action,
			moduleId: moduleId,
			fundCd : hidFundCd.value,
			branch : (hidBranchCd.value != null && hidBranchCd.value != "" ? "" : branchName.value),
			//branch : branchName.value, removed by Joms Diago 05152013 to make sure that list of branches are still available if user wishes to change the branch code.
			//findText: (hidBranchCd.value == "" && branchName.value != ""? branchName.value : "%"), Kenneth  01.14.2013
			page : 1
		},
		title : "List of Branches",
		width : 370,
		height : 400,
		columnModel : [ {
			id : "branchCd",
			title : branchCdTitle,
			width : '100px'
		}, {
			id : "branchName",
			title : branchNameTitle,
			width : '235px'
		}],
		draggable : true,
		autoSelectOneRecord : true,
		filterText: (hidBranchCd.value == "" && branchName.value != ""? branchName.value : "%"),
		//filterText : branchName.value,	
		onSelect : function(row) {
			if (moduleId == "GIACS231" || moduleId == "GIACS236") {	//Gzelle 11.18.2013 UCPBGEN-Phase3 1277
//				hidBranchCd.value = row.branchCd;
//				branchName.value = row.branchCd + " - " + row.branchName;
//				enableToolbarButton("btnToolbarExecuteQuery");
				enableToolbarButton("btnToolbarEnterQuery");
				if(fundCd != ""){
					hidBranchCd.value = row.branchCd;
					branchName.value = row.branchCd + " - " + row.branchName;
					enableToolbarButton("btnToolbarExecuteQuery");
				}else{
					hidBranchCd.value = row.branchCd;
					branchName.value = row.branchCd + " - " + row.branchName;
					disableToolbarButton("btnToolbarExecuteQuery");
				}
			}else {
				if(fundCd != ""){
					hidBranchCd.value = row.branchCd;
					branchName.value = row.branchCd + " - " + row.branchName;
					enableToolbarButton("btnToolbarExecuteQuery");
				}else{
					hidBranchCd.value = row.branchCd;
					branchName.value = row.branchCd + " - " + row.branchName;
					disableToolbarButton("btnToolbarExecuteQuery");
				}
			}
		},
		onUndefinedRow : function(){
			customShowMessageBox("No record selected.", imgMessage.INFO, focus);
		},
		onCancel: function(){
			branchName.focus();
		}
	});
}