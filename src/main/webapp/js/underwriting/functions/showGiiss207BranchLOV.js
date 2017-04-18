/**
 * gets list of issue sources for posting limit maintenance in
 * copy to another user pop up
 * @author msison
 * @param issCd
 * 12.21.2012
 */
function showGiiss207BranchLOV(issCd, userId){	//Gzelle 03212014
 	LOV.show({
 		controller: "UnderwritingLOVController",
 		urlParameters: {action : "getIssueSourceListingLOV",
 						 issCd : issCd,
 						 userId: userId,	//Gzelle 03212014
 						  page : 1},
 		title: "Issue Source",
 		width: '390',
 		height: '290',
 		columnModel : [	{	id : "issCd",
 							title: "Issue Code",
 							width: '275px',
 							//sortable: false 		comment out by Gzelle 05.23.2013 - SR13166
 						},
 						{	id : "issName",
 							title: "Issue Name",
 							visible: false
 						}
 					],
 		draggable: true,
 		onCancel: function() {
 			objGiiss207.resetToLastValidValue($("txtBranchTo"), $("hidLastValidToBranch"), $("txtBranchFrom"), $("hidLastValidFromBranch"));
		},
		onUndefinedRow: function() {
			showMessageBox("No record selected.", imgMessage.INFO); 
			objGiiss207.resetToLastValidValue($("txtBranchTo"), $("hidLastValidToBranch"), $("txtBranchFrom"), $("hidLastValidFromBranch"));
		},
		autoSelectOneRecord: true,
		filterText:  issCd,
 		onSelect: function(row){
 			if ($("searchBranchSw").checked == true) {
 				$("txtBranchFrom").value = row.issCd;
 				$("hidLastValidFromBranch").value = row.issCd;
			} else{
				$("txtBranchTo").value = row.issCd;
				$("hidLastValidToBranch").value = row.issCd;
			}
 			enableInputField("txtBranchTo");
 			enableSearch("btnSearchBranchTo");
 			$("chkPopulateAll").disabled = false;
 		}
	});	
}