/**
 * Shows LOV for Payor Class 
 * @author Niknok Orio 
 * @date   06.04.2012
 */
function showPayeeLOV(moduleId, filterText){
	try{
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action : 	"getGIISPayeeClass2LOV",
							page : 		1,
							filterText:	filterText == null ? "%" : filterText
			},
			title: "",
			width: 403,
			height: 386,
			columnModel:[	
			             	{	id : "payeeClassCd",
								title: "Code",
								width: '70px',
								type: 'number'
							},
							{	id : "classDesc",
								title: "Description",
								width: '318px'
							} 
						],
			draggable: true,
			filterText:	filterText == null ? "%" : filterText,
			autoSelectOneRecord: true,
			onSelect : function(row){
				if (moduleId == "GIACS016"){
					$("txtPayeeCd").clear();
					$("txtPayee").clear();
					$("txtPayeeClassCd").value = unescapeHTML2(row.payeeClassCd);
					$("txtPayeeClassCd").focus();
				}else if (moduleId == "GIACS002"){ //jeffDojello Enhancement SR-1069 11.05.2013
					$("txtPayeeClassCd").clear();
					$("txtPayeeNo").clear();
					$("txtPayeeName").clear();
					$("txtPayeeClassCd").value = unescapeHTML2(row.payeeClassCd);
					$("txtPayeeClassCd").focus();
				}
			},
	  		onCancel: function(){
	  			if (moduleId == "GIACS016"){
	  				$("txtPayeeClassCd").focus();
	  			}
	  		}
		});
	}catch(e){
		showErrorMessage("showPayeeLOV",e);
	}
}