/**
 * Shows Location lov
 * @author emsy
 * @date 04.20.2012
 */
function showLocationLOV(locationCd, locationDesc, moduleId){
	LOV.show({
		controller: "ClaimsLOVController",
		urlParameters: {action : "getGIISCaLocationTG", 
						locationCd: locationCd,
						locationDesc: locationDesc,
						moduleId: moduleId,	
						page : 1},
		title: "",
		width: 413,
		height: 386,
		columnModel : [	{	id : "locationCd",
							title: "Location Code",
							width: '85px'
						},
						{	id : "locationDesc",
							title: "Description",
							width: '310px'
						}
					],
		draggable: true,
		onSelect: function(row){
			if (moduleId == "GICLS010"){
				objCLM.basicInfo.locationCode = row.locationCd;
				objCLM.basicInfo.locationDesc = row.locationDesc;
				$("txtLocation").value = unescapeHTML2(row.locationDesc); 
				$("txtLocation").focus();
	
			}
		},
  		onCancel: function(){
  			if (moduleId == "GICLS010"){
  				$("txtLocation").focus();
  			}
  		}
	  });
}