/**
 * gets list of user for posting limit maintenance in
 * copy to another user pop up
 * @author msison
 * @param userId
 * 12.21.2012
 */
function showUserLOV(userId){
	LOV.show({
 		controller: "UnderwritingLOVController",
 		urlParameters: {action : "getUserListingLOV",
 						userId : userId,
 						  page : 1},
 		title: "User",
 		width: '390',
 		height: '290',
		columnModel : [	{	id : "userId",
 							title: "User Id",
 							width: '258px',
 							//sortable: false		comment out by Gzelle 05.23.2013 - SR13166
 						},
 						{	id : "userName",
 							title: "User Name",
 							visible: false
 						}
 					],
 		draggable: true,
 		onCancel: function() {
 			objGiiss207.resetToLastValidValue($("txtUserIdTo"), $("hidLastValidTo"), $("txtUserIdFrom"), $("hidLastValidFrom"));
		},
 		onUndefinedRow: function() {
 			showMessageBox("No record selected.", imgMessage.INFO);
 			objGiiss207.resetToLastValidValue($("txtUserIdTo"), $("hidLastValidTo"), $("txtUserIdFrom"), $("hidLastValidFrom"));
		},
		autoSelectOneRecord: true,
		filterText:  userId,
 		onSelect: function(row){
 			if ($("searchUserSw").checked == true) {
 				$("txtUserIdFrom").value = row.userId;
 				$("hidLastValidFrom").value = row.userId;
 				$("txtBranchFrom").clear();					//Gzelle 03242014
				$("hidLastValidFromBranch").clear();
			} else if ($("searchUserSw").checked == false){
				$("txtUserIdTo").value = row.userId;
				$("hidLastValidTo").value = row.userId;
				$("txtBranchTo").clear();					//Gzelle 03242014
				$("hidLastValidToBranch").clear();
			}
 		}
	});	
}