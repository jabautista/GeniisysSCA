/**
 * Shows Catastrophic lov
 * @author niknok
 * @date 10.17.2011
 */
function showAllCatastrophicLOV(moduleId){
	LOV.show({
		controller: "ClaimsLOVController",
		urlParameters: {action : "getGiclCatDtlLOV", 
						page : 1},
		title: "List of Catastrophic Event",
		width: 405,
		height: 386,
		columnModel : [	{	id : "catCd",
							title: "CAT Code",
							align: "right",
							width: '70px'
						},
						{	id : "catDesc",
							title: "Catastrophic Desc",
							width: '320px'
						}
					],
		draggable: true,
		onSelect: function(row){
			if (moduleId == "GICLS010"){
				objCLM.basicInfo.catastrophicCode = row.catCd;
				objCLM.basicInfo.dspCatDesc = row.catDesc;
				$("txtCatCd").value = row.catCd; 
				$("txtCat").value = unescapeHTML2(row.catDesc); 
				$("txtCat").focus();
				changeTag = 1;
			}
		},
  		onCancel: function(){
  			if (moduleId == "GICLS010"){
  				$("txtCat").focus();
  			}
  		}
	  });
}