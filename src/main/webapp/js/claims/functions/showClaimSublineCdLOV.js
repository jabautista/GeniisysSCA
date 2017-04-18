/** Show LOV of Subline Codes for Claim - to use, please add your moduleid on cmp
 *  Reference By: GICLS261 - Claim Payment Module
 *  @author aliza garza  
 *  @date 06.04.2013
 * */
function showClaimSublineCdLOV(moduleId, lineCd, subLineCd){
	try{
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getClaimSublineLOV", 
							lineCd : lineCd,
							moduleId : moduleId,
							subLineCd : subLineCd,
							page : 1},
			title: "Subline Code Listing",
			width: 405,
			height: 386,
			columnModel : [	{	id : "sublineCd",
								title: "Subline Code",
								width: '100px'
							},
							{	id : "sublineName",
								title: "Subline Name",
								width: '290px'
							}
						],
			draggable: true,
			autoSelectOneRecord: true,
			filterText: $("txtNbtClmSublineCd").value,
			onSelect: function(row){
				if (moduleId == "GICLS261"){	
					$("txtNbtClmSublineCd").enable();
					$("txtNbtClmSublineCd").value = unescapeHTML2(row.sublineCd); 
					$("txtNbtClmLineCd").value = unescapeHTML2(row.lineCd);
					$("txtNbtClmIssCd").focus();
					enableToolbarButton('btnToolbarEnterQuery');
				} else if (moduleId == "GICLS255"){
					$("txtNbtClmSublineCd").value = unescapeHTML2(row.sublineCd); 
				}
			},
	  		onCancel: function(){
	  			if (moduleId == "GICLS261"){
	  				$("txtNbtClmSublineCd").enable();
	  				$("txtNbtClmSublineCd").focus();
	  			}		
	  		},
	  		onUndefinedRow : function(){
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtNbtClmSublineCd");
				$("txtNbtClmSublineCd").enable();
			}
		  });
	} catch (e){
		showErrorMessage("showClaimSublineCdLOV", e);
	}
}