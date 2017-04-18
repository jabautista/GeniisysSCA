/**
 * Shows LOV for Recovery Type 
 * @author Niknok Orio 
 * @date   03.13.2012
 */
function showRecoveryTypeLOV(moduleId){
	try{
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : 	"getGiisRecoveryTypeLOV",
							//notIn : 	notIn,
							page : 		1 
			},
			title: "List of Recovery Type",
			width: 450,
			height: 386,
			columnModel:[	
			             	{	id : "recTypeCd",
								title: "Recovery Type Cd",
								width: '115px',
								type: 'number'
							},
							{	id : "recTypeDesc",
								title: "Recovery Type Description",
								width: '320px'
							} 
						],
			draggable: true,
			onSelect : function(row){
				if (moduleId == "GICLS025"){
					$("txtRecTypeCd").value = unescapeHTML2(row.recTypeCd);
					$("txtDspRecTypeDesc").value = unescapeHTML2(row.recTypeDesc);
					$("txtRecTypeCd").focus();
				}
			},
			prePager: function(){
				//tbgLOV.request.notIn = notIn;
			}
		});
	}catch(e){
		showErrorMessage("showRecoveryTypeLOV",e);
	}
}