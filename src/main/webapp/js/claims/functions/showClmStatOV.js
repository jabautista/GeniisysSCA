/**
 * Shows Claim Status lov
 * @author niknok
 * @date 10.17.2011
 */
function showClmStatOV(moduleId){
	LOV.show({
		controller: "ClaimsLOVController",
		urlParameters: {action : "getClmStatLOV", 
						page : 1},
		title: "",
		width: 405,
		height: 386,
		columnModel : [	{	id : "clmStatCd",
							title: "Code",
							width: '70px'
						},
						{	id : "clmStatDesc",
							title: "Description",
							width: '320px'
						}
					],
		draggable: true,
		onSelect: function(row){
			if (moduleId == "GICLS010"){
				objCLM.basicInfo.claimStatusCd = row.clmStatCd; 
	 			objCLM.basicInfo.clmStatDesc = row.clmStatDesc;
	 			$("txtClmStatCd").value = unescapeHTML2(row.clmStatCd);
				$("txtClmStat").value = unescapeHTML2(row.clmStatDesc);
				$("txtClmStat").focus();
				changeTag = 1;
			}
		},
  		onCancel: function(){
  			if (moduleId == "GICLS010"){
  				$("txtClmStat").focus();
  			}
  		}
	  });
}