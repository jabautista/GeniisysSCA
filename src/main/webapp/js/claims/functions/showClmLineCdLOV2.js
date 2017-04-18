/** Modification to add GICLS261 on modules using LOV
 *  Reference By: GICLS261 - Claim Payment Module
 *  @author aliza garza  
 *  @date 06.04.2013
 * */
function showClmLineCdLOV2(moduleId){
	LOV.show({
		controller: "ClaimsLOVController",
		urlParameters: {action : "getClmLineLOV2", 
						moduleId : moduleId,
						page : 1,
						searchString : $("txtNbtLineCd").value
					   },
		title: "",
		width: 405,
		height: 386,
		columnModel : [	{	id : "code",
							title: "Line Code",
							width: '100px'
						},
						{	id : "codeDesc",
							title: "Line Name",
							width: '290px'
						}
					],
		draggable: true,
		autoSelectOneRecord: true,
		filterText: $("txtNbtLineCd").value,
		onSelect: function(row){
			if (moduleId == "GICLS250"){
				$("txtNbtLineCd").enable();
				$("txtNbtLineCd").value = unescapeHTML2(row.code);
				$("txtNbtSublineCd").focus();
				enableToolbarButton('btnToolbarEnterQuery');
			}
			else if (moduleId == "GICLS261"){
				$("txtNbtLineCd").enable();
				$("txtNbtLineCd").value = unescapeHTML2(row.code);
				$("txtNbtSublineCd").focus();
				enableToolbarButton('btnToolbarEnterQuery');
				showClmSublineCdLOV("GICLS261", $F("txtNbtLineCd"));
			}			
		},
  		onCancel: function(){
  			if (moduleId == "GICLS250"){
  				$("txtNbtLineCd").enable();
  				$("txtNbtLineCd").focus();
  			}
  			else if (moduleId == "GICLS261"){
  				$("txtNbtLineCd").enable();
  				$("txtNbtLineCd").focus();
  			}  			
  		},
  		onUndefinedRow : function(){
			customShowMessageBox("No record selected.", imgMessage.INFO, "txtNbtLineCd");
			$("txtNbtLineCd").enable();
		}
	  });
}