/**
 * Shows LOV for Recovery Status 
 * @author Niknok Orio 
 * @date   03.29.2012
 */
function showRecoveryStatusLOV(moduleId){
	try{
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : 	"getRecoveryStatusLOV",
							//notIn : 	notIn,
							page : 		1 
			},
			title: "List of Recovery Status",
			width: 403,
			height: 386,
			columnModel:[	
			             	{	id : "recStatCd",
								title: "Recovery Status Cd",
								width: '120px',
								type: 'number'
							},
							{	id : "recStatDesc",
								title: "Recovery Status Description",
								width: '268px'
							} 
						],
			draggable: true,
			onSelect : function(row){
				if (moduleId == "GICLS025"){
					$("txtRecStatCd").value = unescapeHTML2(row.recStatCd);
					$("txtDspRecStatDesc").value = unescapeHTML2(row.recStatDesc);
					$("txtRecStatCd").focus();
				}
			},
			prePager: function(){
				//tbgLOV.request.notIn = notIn;
			}
		});
	}catch(e){
		showErrorMessage("showRecoveryStatusLOV",e);
	}
}