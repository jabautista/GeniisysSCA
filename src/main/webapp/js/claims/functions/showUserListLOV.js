/**
 * Shows User lov
 * @author niknok
 * @date 10.17.2011
 */
function showUserListLOV(lineCd, polIssCd, moduleId){
	LOV.show({
		controller: "ClaimsLOVController",
		urlParameters: {action : "getUserListLOV", 
						lineCd: lineCd,
						polIssCd: polIssCd,
						moduleId: moduleId,	
						page : 1},
		title: "List of Claim Processor",
		width: 405,
		height: 386,
		columnModel : [	{	id : "userId",
							title: "Id",
							width: '70px'
						},
						{	id : "userName",
							title: "Name",
							width: '320px'
						}
					],
		draggable: true,
		onSelect: function(row){
			if (moduleId == "GICLS010"){
				objCLM.basicInfo.inHouseAdjustment = row.userId;
				objCLM.basicInfo.dspInHouAdjName = row.userName;
				$("txtInHouseAdjustment").value = unescapeHTML2(row.userId);
				$("txtClmProcessor").value = unescapeHTML2(row.userName); 
				$("txtClmProcessor").focus();
				changeTag = 1;
			}
		},
  		onCancel: function(){
  			if (moduleId == "GICLS010"){
  				$("txtClmProcessor").focus();
  			}
  		}
	  });
}