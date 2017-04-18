/** Show LOV of Policy No - to use, please add your moduleid on cmp
 *  Reference By: GICLS261 - Claim Payment Module
 *  @author john dolon  
 *  @date 08.01.2013
 * */
function showPolicyLOV(moduleId, lineCd, subLineCd, issCd, issueYy,
		polSeqNo, renewNo) {
	try {
		LOV
				.show({
					controller : "ClaimsLOVController",
					urlParameters : {
						action : "getPolicyLOV",
						moduleId : moduleId,
						lineCd : lineCd,
						subLineCd : subLineCd,
						issCd : issCd,
						issueYy : issueYy,
						polSeqNo : polSeqNo,
						renewNo : renewNo,
						page : 1
					},
					title : "Policy Listing",
					width : 535,
					height : 390,
					columnModel : [ {
						id : "policyNo",
						title : "Policy No",
						width : '205px'
					}, {
						id : 'assuredName',
						title : 'Assured Name',
						titleAlign : 'left',
						width : '310px',
					} ],
					draggable : true,
					autoSelectOneRecord : true,
					onSelect : function(row) {
						if(moduleId == "GICLS261"){
							$("txtNbtLineCd").value = unescapeHTML2(row.lineCd);
							$("txtNbtSublineCd").value = unescapeHTML2(row.sublineCd);
							$("txtNbtPolIssCd").value = unescapeHTML2(row.polIssCd);
							$("txtNbtIssueYy").value = unescapeHTML2(row.issueYy);
							$("txtNbtPolSeqNo").value = unescapeHTML2(row.polSeqNo);
							$("txtNbtRenewNo").value = unescapeHTML2(row.renewNo);
							showClmPolLOV("GICLS261");
							enableToolbarButton('btnToolbarEnterQuery');
						} else if (moduleId == "GICLS255"){
							$("txtNbtLineCd").value = unescapeHTML2(row.lineCd);
							$("txtNbtSublineCd").value = unescapeHTML2(row.sublineCd);
							$("txtNbtPolIssCd").value = unescapeHTML2(row.polIssCd);
							$("txtNbtIssueYy").value = unescapeHTML2(row.issueYy);
							$("txtNbtPolSeqNo").value = unescapeHTML2(row.polSeqNo);
							$("txtNbtRenewNo").value = unescapeHTML2(row.renewNo);
							showClmListLOV(objCLMGlobal.moduleId);
						}
					},
					onCancel : function() {
						if(moduleId == "GICLS261"){
							$("txtNbtPolIssCd").enable();
							$("txtNbtPolIssCd").focus();
						} else if (moduleId == "GICLS255"){
							$("txtNbtPolIssCd").focus();
						}
						
					},
					onUndefinedRow : function() {
						customShowMessageBox("No record selected.",
								imgMessage.INFO, "txtNbtLineCd");
						$("txtNbtPolIssCd").enable();
						if(moduleId == "GICLS261"){
							$("txtNbtClmLineCd").clear();
							$("txtNbtClmSublineCd").clear();
							$("txtNbtClmIssCd").clear();
							$("txtNbtClmYy").clear();
							$("txtNbtClmSeqNo").clear();
							$("txtNbtLineCd").clear();
							$("txtNbtSublineCd").clear();
							$("txtNbtPolIssCd").clear();
							$("txtNbtIssueYy").clear();
							$("txtNbtPolSeqNo").clear();
							$("txtNbtRenewNo").clear();
							$("txtLossCategory").clear();
							$("txtLossDate").clear();
							$("txtClmStatus").clear();
						}
					}
				});
	} catch (e) {
		showErrorMessage("showPolicyLOV", e);
	}
}