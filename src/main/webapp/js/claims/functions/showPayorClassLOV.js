/**
 * Shows LOV for Payor Class 
 * @author Niknok Orio 
 * @date   03.22.2012
 * used on GICL272 module --jed 06.06.2013
 */
function showPayorClassLOV(moduleId){
	try{
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : 	"getGiisPayeeClassLOV",
							//notIn : 	notIn,
							page : 		1 
			},
			title: "List of Payor Class",
			width: 403,
			height: 386,
			columnModel:[	
			             	{	id : "payeeClassCd",
								title: "Payor Class Cd",
								width: '100px',
								type: 'number'
							},
							{	id : "classDesc",
								title: "Payor Class Description",
								width: '288px'
							} 
						],
			draggable: true,
			onSelect : function(row){
				if (moduleId == "GICLS025"){
					$("txtPayorClassCd").value = unescapeHTML2(row.payeeClassCd);
					$("txtClassDesc").value = unescapeHTML2(row.classDesc);
					if(unescapeHTML2(row.payeeClassCd) == objCLM.gicls025vars.assdClassCd){
						if(objCLM.recPayorTG.geniisysRows.filter(function(obj){return obj.payorClassCd == objCLM.gicls025vars.assdClassCd &&
							obj.payorCd == objCLM.gicls025vars.assdNo;}).length == 0){ //marco - added condition - 10.16.2013
							$("txtPayorCd").value = objCLM.gicls025vars.assdNo;
							$("txtDspPayorName").value = unescapeHTML2(objCLM.gicls025vars.assdName);//added by steven 12/13/2012  "escapeHTML2"
						}
					}else{
						$("txtPayorCd").clear();
						$("txtDspPayorName").clear();
					}
					$("txtPayorClassCd").focus();
				}
				else if(moduleId == 'GICLS272'){
					$("txtPayeeClassNo").value = unescapeHTML2(row.payeeClassCd);
					$("txtPayeeClass").value = unescapeHTML2(row.classDesc);
					$("txtPayeeClassNo").focus();
				}
			},
			prePager: function(){
				//tbgLOV.request.notIn = notIn;
			}
		});
	}catch(e){
		showErrorMessage("showPayorClassLOV",e);
	}
}