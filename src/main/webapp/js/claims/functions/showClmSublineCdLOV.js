/**
 * Shows Claims Subline Code LOV
 * @author niknok
 * @date 12.09.2011
 */
/** Modification to add GICLS261 on modules using LOV
 *  Reference By: GICLS261 - Claim Payment Module
 *  @author aliza garza  
 *  @date 06.04.2013
 * */
function showClmSublineCdLOV(moduleId, lineCd){
	LOV.show({
		controller: "ClaimsLOVController",
		urlParameters: {action : "getClmSublineLOV", 
						lineCd : lineCd,
						searchString : $("txtNbtSublineCd").value,
						page : 1},
		title: "",
		width: 405,
		height: 386,
		columnModel : [	{	id : "code",
							title: "Subline Code",
							width: '100px'
						},
						{	id : "codeDesc",
							title: "Subline Name",
							width: '290px'
						}
					],
		draggable: true,
		autoSelectOneRecord: true,
		filterText: $("txtNbtSublineCd").value,
		onSelect: function(row){
			if (moduleId == "GICLS250"){
				$("txtNbtSublineCd").enable();
				$("txtNbtPolIssCd").focus(); 
				$("txtNbtSublineCd").value = unescapeHTML2(row.code); 
			}
			else if (moduleId == "GICLS261"){
				$("txtNbtSublineCd").enable();
				$("txtNbtPolIssCd").focus(); 
				$("txtNbtSublineCd").value = unescapeHTML2(row.code); 
			}			
		},
  		onCancel: function(){
  			if (moduleId == "GICLS250"){
  				$("txtNbtSublineCd").enable();
  				$("txtNbtSublineCd").focus();
  			}
  			else if (moduleId == "GICLS261"){
  				$("txtNbtSublineCd").enable();
  				$("txtNbtSublineCd").focus();
  			}  			
  		},
  		onUndefinedRow : function(){
			customShowMessageBox("No record selected.", imgMessage.INFO, "txtNbtSublineCd");
			$("txtNbtSublineCd").enable();
		}
	  });
}