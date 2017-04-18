/**
 * Shows Claims Issue Code LOV
 * @author niknok
 * @date 12.09.2011
 */
function showClmIssCdLOV(moduleId, lineCd, sublineCd){
	LOV.show({
		controller: "ClaimsLOVController",
		urlParameters: {action : "getClmIssLOV", 
						lineCd : lineCd,
						sublineCd: sublineCd,
						searchString : $("txtNbtPolIssCd").value,
						page : 1},
		title: "",
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
		},
  		onCancel: function(){
  			if (moduleId == "GICLS250"){
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