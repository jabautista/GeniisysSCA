/**
 * Shows Claims Issue Year LOV
 * @author niknok
 * @date 12.09.2011
 */
/** Modification to add GICLS261 on modules using LOV for Pol Iss Cd fields
 *  Reference By: GICLS261 - Claim Payment Module
 *  @author aliza garza  
 *  @date 06.04.2013
 * */
function showClmIssueYyLOV(moduleId, lineCd, sublineCd){
	LOV.show({
		controller: "ClaimsLOVController",
		urlParameters: {action : "getClmIssueYyLOV", 
						lineCd : lineCd,
						sublineCd: sublineCd,
						searchString : $("txtNbtIssueYy").value,
						page : 1},
		title: "",
		width: 405,
		height: 386,
		columnModel : [	{	id : "code",
							title: "Issuing Year",
							width: '100px'
						} 
					],
		draggable: true,
		autoSelectOneRecord: true,
		filterText: $("txtNbtIssueYy").value,
		onSelect: function(row){
			if (moduleId == "GICLS250"){
				$("txtNbtPolSeqNo").focus(); 
				$("txtNbtIssueYy").enable();
				$("txtNbtIssueYy").value = unescapeHTML2(row.code); 
			}
			else if (moduleId == "GICLS261"){
				$("txtNbtClmSeqNo").focus(); 
				$("txtNbtClmYy").enable();
				$("txtNbtClmYy").value = unescapeHTML2(row.code); 
			}			
		},
  		onCancel: function(){
  			if (moduleId == "GICLS250"){
  				$("txtNbtIssueYy").enable();
  				$("txtNbtIssueYy").focus();
  			}
  			else if (moduleId == "GICLS261"){
  				$("txtNbtIssueYy").enable();
  				$("txtNbtIssueYy").focus();
  			}  			
  		},
  		onUndefinedRow : function(){
			customShowMessageBox("No record selected.", imgMessage.INFO, "txtNbtPolIssCd");
			$("txtNbtIssueYy").enable();
			$("txtNbtPolIssCd").enable();
		}
	  });
}