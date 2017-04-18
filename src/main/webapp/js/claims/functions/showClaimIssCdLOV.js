/** Show LOV of Issue Codes for Claim - to use, please add your moduleid on cmp
 *  Reference By: GICLS261 - Claim Payment Module
 *  @author aliza garza  
 *  @date 06.04.2013
 * */
function showClaimIssCdLOV(moduleId, issCd, lineCd){
	try{
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getClaimIssLOV", 
							issCd: issCd,
							moduleId : moduleId,
							lineCd: lineCd,
							page : 1},
			title: "Issuing Code Listing",
			width: 405,
			height: 386,
			columnModel : [	{	id : "issCd",
								title: "Issuing Code",
								width: '100px'
							},
							{	id : "issName",
								title: "Issuing Name",
								width: '290px'
							}
						],
			draggable: true,
			autoSelectOneRecord: true,
			filterText: $("txtNbtClmIssCd").value,
			onSelect: function(row){
				if (moduleId == "GICLS261"){
					$("txtNbtClmYy").focus(); 
					$("txtNbtClmIssCd").enable();
					$("txtNbtClmIssCd").value = unescapeHTML2(row.issCd);
					enableToolbarButton("btnToolbarEnterQuery");
				} else if (moduleId == "GICLS255"){
					$("txtNbtClmYy").focus(); 
					$("txtNbtClmIssCd").value = unescapeHTML2(row.issCd);
				}				
			},
	  		onCancel: function(){
	  			if (moduleId == "GICLS261"){
	  				$("txtNbtClmIssCd").enable();
	  				$("txtNbtClmIssCd").focus();
	  			} else if (moduleId == "GICLS255"){		
	  				$("txtNbtClmIssCd").focus();
	  			}
	  		},
	  		onUndefinedRow : function(){
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtNbtClmIssCd");
				$("txtNbtClmIssCd").enable();
			}
		  });
	} catch (e){
		showErrorMessage("showClaimSublineCdLOV", e);
	}
}