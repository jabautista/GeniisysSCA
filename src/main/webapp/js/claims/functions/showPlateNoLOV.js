/**
 * Shows Plate number lov
 * @author niknok
 * @date 10.28.2011
 */
function showPlateNoLOV(moduleId){
	LOV.show({
		controller: "ClaimsLOVController",
		urlParameters: {action : "getPlateDtlLOV", 
						page : 1},
		title: "Valid Plate Nos.",
		width: 405,
		height: 386,
		columnModel : [	{	id : "id",
							title: "Plate Number",
							width: '95px'
						},
						{	id : "desc",
							title: "Assured",
							width: '295px'
						}
					],
		draggable: true,
		onSelect: function(row){
			if (moduleId == "GICLS010"){
				setPreText("txtAssuredName", $F("txtAssuredName")); //set pre-text ni assured para pag failed sa validation
				$("txtPlateNumber").focus(); //mauna si focus para sa checking ng pre-text
				$("txtPlateNumber").value = unescapeHTML2(row.id);
				$("txtAssuredName").value = unescapeHTML2(row.desc); 
			}
		},
  		onCancel: function(){
  			if (moduleId == "GICLS010"){
  				$("txtPlateNumber").focus();
  			}
  		}
	  });
}