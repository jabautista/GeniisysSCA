/**
 * showColorLOV2
 * Description: Retrieves the showDetColorLOV2 LOV 
 * Added moduleId for extra functionality
 * @author Irwin Tabisora 9.15.11
 * */

function showColorLOV2(basicColorCd,moduleId){
	try {
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getColorLOV",
							basicColorCd : basicColorCd,
							page : 1},
			title: "Color",
			width: 390,
			height: 320,
			columnModel : [	{	id : "colorCd",
								title: "Color Cd",
								width: '350px'
							},{	id : "color",
								title: "Color",
								width: '350px'
							}
						],
			draggable: true,
			onSelect : function(row){
				if(moduleId == "GICLS014other"){
					$("detBasicColor").value = row.basicColor;
					$("detBasicColorCd").value = row.basicColorCd;
					$("detColor").value = row.color;
					$("detColorCd").value = row.colorCd;
				}else{
					
				}
				
			}
		  });
	} catch (e){
		showErrorMessage("showColorLOV2", e);
	}
}