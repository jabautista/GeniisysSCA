/**
 * showBasicColorLOV2
 * Description: Retrieves the showBasicColorLOV2 LOV 
 * Added moduleId for extra functionality
 * @author Irwin Tabisora 9.15.11
 * */
function showBasicColorLOV2(moduleId){
	try {
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getBasicColorLOV",
							page : 1},
			title: "Basic Color",
			width: 390,
			height: 320,
			columnModel : [	{	id : "basicColor",
								title: "Basic Color",
								width: '350px'
							}
						],
			draggable: true,
			onSelect: function(row){
				if(moduleId == "GICLS014other"){
					$("detBasicColor").value = row.basicColor;
					$("detBasicColorCd").value = row.basicColorCd;
					$("detColor").value = "";
					$("detColorCd").value = "";
				}else{
					
				}
			}
		  });
	} catch (e){
		showErrorMessage("showBasicColorLOV2", e);
	}
}