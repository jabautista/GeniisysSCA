/**
 * showColorLOV2
 * Description: Retrieves the showDetColorLOV2 LOV 
 * Added moduleId for extra functionality
 * @author Irwin Tabisora 9.15.11
 * */
function showReinsurerLOV3(notIn, moduleId){
	try {
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getReinsurerLOV2",
							notIn : notIn,
							page : 1},
			title: "TP Insurer",
			width: 660,
			height: 386,
			columnModel : [	{	id : "riCd",
								title: "TP Insurer Cd",
								width: '57px'	
							},
			               	{	id : "riSname",
								title: "TP Insurer Short Name",
								width: '290px'
							},
							{	id : "riName",
								title: "TP Insurer Long Name",
								width: '290px'
							},
							{	id : "billAddress1",
								title: "",
								width: '0px',
								visible: false
							},
							{	id : "billAddress2",
								title: "",
								width: '0px',
								visible: false
							},
							{	id : "billAddress3",
								title: "",
								width: '0px',
								visible: false
							}
						],
			draggable: true,
			onSelect : function(row){
				if(moduleId == "GICLS014other"){
					$("detRiCd").value = nvl(row.riCd);
					$("detRiName").value = unescapeHTML2(nvl(row.riSname));
				
				}else{
					
				}
			},
			prePager: function(){
				tbgLOV.request.notIn = notIn;
			}
		  });
	} catch (e){
		showErrorMessage("showReinsurerLOV3", e);
	}
}