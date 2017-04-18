/** Show LOV of Policy Subline Code for Claim - to use, please add your moduleid on cmp
 *  Reference By: GICLS261 - Claim Payment Module
 *  @author john dolon  
 *  @date 08.01.2013
 * */
function showPolicySublineCdLOV(lineCd, subLineCd,moduleID) {
	LOV
			.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action : "getClaimSublineLOV",
					lineCd : lineCd,
					subLineCd : subLineCd,
					moduleId : moduleID,
					page : 1
				},
				title : "Subline Code Listing",
				width : 405,
				height : 386,
				columnModel : [ {
					id : "sublineCd",
					title : "Subline Code",
					width : '100px'
				}, {
					id : "sublineName",
					title : "Subline Name",
					width : '290px'
				} ],
				draggable : true,
				autoSelectOneRecord : true,
				filterText : $("txtNbtSublineCd").value,
				onSelect : function(row) {
					if (moduleID == "GICLS261"){
						$("txtNbtSublineCd").enable();
						$("txtNbtSublineCd").value = unescapeHTML2(row.sublineCd);
						$("txtNbtLineCd").value = unescapeHTML2(row.lineCd);
						$("txtNbtPolIssCd").focus();
						enableToolbarButton('btnToolbarEnterQuery');
					} else if (moduleID == "GICLS255"){
						$("txtNbtSublineCd").value = unescapeHTML2(row.sublineCd);
						$("txtNbtPolIssCd").focus();
					}
				},
				onCancel : function() {
					if (moduleID == "GICLS261"){
						$("txtNbtSublineCd").enable();
						$("txtNbtSublineCd").focus();
					} else if (moduleID == "GICLS255"){
						$("txtNbtSublineCd").focus();
					}
				},
				onUndefinedRow : function() {
					customShowMessageBox("No record selected.",
							imgMessage.INFO, "txtNbtSublineCd");
					$("txtNbtSublineCd").enable();
				}
			});
}