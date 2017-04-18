/**
 * Shows Motor number lov
 * @author niknok
 * @date 10.28.2011
 */
function showMotorNoLOV(moduleId){
	LOV.show({
		controller: "ClaimsLOVController",
		urlParameters: {action : "getMotorDtlLOV", 
						page : 1},
		title: "Valid Motor Nos.",
		width: 405,
		height: 386,
		columnModel : [	{	id : "id",
							title: "Motor Number",
							width: '100px'
						},
						{	id : "desc",
							title: "Assured",
							width: '290px'
						}
					],
		draggable: true,
		onSelect: function(row){
			if (moduleId == "GICLS010"){
				setPreText("txtAssuredName", $F("txtAssuredName")); //set pre-text ni assured para pag failed sa validation
				$("txtMotorNumber").focus(); //mauna si focus para sa checking ng pre-text
				$("txtMotorNumber").value = unescapeHTML2(row.id);
				$("txtAssuredName").value = unescapeHTML2(row.desc); 
			}
		},
  		onCancel: function(){
  			if (moduleId == "GICLS010"){
  				$("txtMotorNumber").focus();
  			}
  		}
	  });
}