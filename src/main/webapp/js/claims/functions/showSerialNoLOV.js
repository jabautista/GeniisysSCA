/**
 * Shows Serial number lov
 * @author niknok
 * @date 10.28.2011
 */
function showSerialNoLOV(moduleId){
	LOV.show({
		controller: "ClaimsLOVController",
		urlParameters: {action : "getSerialDtlLOV", 
						page : 1},
		title: "Valid Serial Nos.",
		width: 405,
		height: 386,
		columnModel : [	{	id : "id",
							title: "Serial Number",
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
				$("txtSerialNumber").focus(); //mauna si focus para sa checking ng pre-text
				$("txtSerialNumber").value = unescapeHTML2(row.id);
				$("txtAssuredName").value = unescapeHTML2(row.desc); 
			}
		},
  		onCancel: function(){
  			if (moduleId == "GICLS010"){
  				$("txtSerialNumber").focus();
  			}
  		}
	  });
}