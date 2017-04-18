/** Show LOV of Policy Issue Code for Claim - to use, please add your moduleid on cmp
 *  Reference By: GICLS261 - Claim Payment Module
 *  @author john dolon  
 *  @date 08.01.2013
 * */
function showPolicyIssCdLOV(moduleID, issCd) {
	try {
		LOV
				.show({
					controller : "ClaimsLOVController",
					urlParameters : {
						action : "getClaimIssLOV",
						moduleId : moduleId,
						issCd : issCd,
						page : 1
					},
					title : "Issuing Code Listing",
					width : 405,
					height : 386,
					columnModel : [ {
						id : "issCd",
						title : "Issuing Code",
						width : '100px'
					}, {
						id : "issName",
						title : "Issuing Name",
						width : '290px'
					} ],
					draggable : true,
					autoSelectOneRecord : true,
					filterText : $("txtNbtPolIssCd").value,
					onSelect : function(row) {
						if (moduleID =="GICLS261"){
							$("txtNbtIssueYy").focus();
							$("txtNbtPolIssCd").enable();
							$("txtNbtPolIssCd").value = unescapeHTML2(row.issCd);
							enableToolbarButton('btnToolbarEnterQuery');
						} else if (moduleID == "GICLS255"){
							$("txtNbtPolIssCd").value = unescapeHTML2(row.issCd);
							$("txtNbtIssueYy").focus();
						}
					},
					onCancel : function() {
						if(moduleID == "GICLS261"){
							$("txtNbtPolIssCd").enable();
							$("txtNbtPolIssCd").focus();
						} else if (moduleID == "GICLS255"){
							$("txtNbtPolIssCd").focus();
						}
						
					},
					onUndefinedRow : function() {
						customShowMessageBox("No record selected.",
								imgMessage.INFO, "txtNbtPolIssCd");
						$("txtNbtPolIssCd").enable();
					}
				});
	} catch (e) {
		showErrorMessage("showPolicyLineCdLOV", e);
	}
}