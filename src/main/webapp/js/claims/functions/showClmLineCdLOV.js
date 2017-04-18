/**
 * Shows Claims Line Code LOV
 * @author niknok
 * @date 12.09.2011
 */
function showClmLineCdLOV(moduleId){
	LOV.show({
		controller: "ClaimsLOVController",
		urlParameters: {action : "getClmLineLOV", 
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
		},
  		onCancel: function(){
  			if (moduleId == "GICLS250"){
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