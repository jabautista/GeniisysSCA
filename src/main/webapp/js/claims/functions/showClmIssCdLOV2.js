/** Modification to add GICLS261 on modules using LOV for Pol Iss Cd fields
 *  Reference By: GICLS261 - Claim Payment Module
 *  @author aliza garza  
 *  @date 06.04.2013
 * */
function showClmIssCdLOV2(moduleId, lineCd, sublineCd){
	LOV.show({
		controller: "ClaimsLOVController",
		urlParameters: {action : "getClmIssLOV2", 
						lineCd : lineCd,
						sublineCd: sublineCd,
						moduleId : moduleId,
						searchString : $("txtNbtPolIssCd").value,
						page : 1},
		title: "List of Issue Code",
		width: 405,
		height: 386,
		columnModel : [	{	id : "code",
							title: "Issuing Code",
							width: '100px'
						},
						{	id : "codeDesc",
							title: "Issuing Name",
							width: '290px'
						}
					],
		draggable: true,
		autoSelectOneRecord: true,
		filterText: $("txtNbtPolIssCd").value,
		onSelect: function(row){
			if (moduleId == "GICLS250"){
				$("txtNbtIssueYy").focus(); 
				$("txtNbtPolIssCd").enable();
				$("txtNbtPolIssCd").value = unescapeHTML2(row.code); 
			}
			else if (moduleId == "GICLS261"){
				$("txtNbtIssueYy").focus(); 
				$("txtNbtPolIssCd").enable();
				$("txtNbtPolIssCd").value = unescapeHTML2(row.code); 
			}				
		},
  		onCancel: function(){
  			if (moduleId == "GICLS250"){
  				$("txtNbtPolIssCd").enable();
  				$("txtNbtPolIssCd").focus();
  			}
  			else if (moduleId == "GICLS261"){
  				$("txtNbtPolIssCd").enable();
  				$("txtNbtPolIssCd").focus();
  			}  			
  		},
  		onUndefinedRow : function(){
			customShowMessageBox("No record selected.", imgMessage.INFO, "txtNbtPolIssCd");
			$("txtNbtPolIssCd").enable();
		}
	  });
}