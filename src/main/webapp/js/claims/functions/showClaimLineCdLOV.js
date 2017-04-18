/** Show LOV of Line Codes for Claim - to use, please add your moduleid on cmp
 *  Reference By: GICLS261 - Claim Payment Module
 *  @author aliza garza  
 *  @date 06.04.2013
 * */
function showClaimLineCdLOV(moduleId, clmLineCd){
	try{
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getClaimLineLOV", 
							moduleId : moduleId,
							page : 1,
							lineCd : clmLineCd
						   },
			title: "Line Code Listing",
			width: 405,
			height: 386,
			columnModel : [	{	id : "lineCd",
								title: "Line Code",
								width: '100px'
							},
							{	id : "lineName",
								title: "Line Name",
								width: '290px'
							}
						],
			draggable: true,
			autoSelectOneRecord: true,
			filterText: $("txtNbtClmLineCd").value,
			onSelect: function(row){
				if (moduleId == "GICLS261"){
					$("txtNbtClmLineCd").enable();
					$("txtNbtClmLineCd").value = unescapeHTML2(row.lineCd);
					$("txtNbtClmSublineCd").focus();
					enableToolbarButton('btnToolbarEnterQuery');
				} else if (moduleId == "GICLS255"){
					$("txtNbtClmLineCd").value = unescapeHTML2(row.lineCd);
					$("txtNbtClmSublineCd").focus();
					enableToolbarButton("btnToolbarEnterQuery");
				}
			},
	  		onCancel: function(){
	  			if (moduleId == "GICLS261"){
	  				$("txtNbtClmLineCd").enable();
	  				$("txtNbtClmLineCd").focus();
	  			} else if (moduleId == "GICLS255"){
	  				$("txtNbtClmLineCd").focus();
	  			}	
	  		},
	  		onUndefinedRow : function(){
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtNbtClmLineCd");
				$("txtNbtClmLineCd").enable();
			}
		  });
	} catch (e) {
		showErrorMessage("showClaimLineCdLOV", e);
	}
}