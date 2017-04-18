/**
 * Shows LOV for Lawyer 
 * @author Niknok Orio 
 * @date   03.14.2012
 */
function showLawyerLOV(moduleId){
	try{
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : 	"getLawyerLOV",
							//notIn : 	notIn,
							page : 		1 
			},
			title: "List of Lawyer",
			width: 405,
			height: 386,
			columnModel:[	
			             	{	id : "lawyerCd",
								title: "Code",
								width: '70px',
								type: 'number'
							},
							{	id : "lawyerName",
								title: "Lawyer",
								width: '318px'
							},
							{	id : "lawyerClassCd",
								title: "",
								width: '0',
								visible: false
							}
						],
			draggable: true,
			onSelect : function(row){
				if (moduleId == "GICLS025"){
					$("txtLawyerCd").value = unescapeHTML2(row.lawyerCd);
					$("hidLawyerClassCd").value = unescapeHTML2(row.lawyerClassCd);
					$("txtDspLawyerName").value = unescapeHTML2(row.lawyerName);
					$("txtLawyerCd").focus();
				}
			},
			prePager: function(){
				//tbgLOV.request.notIn = notIn;
			}
		});
	}catch(e){
		showErrorMessage("showLawyerLOV",e);
	}
}