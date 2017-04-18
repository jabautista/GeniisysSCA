/**
 * showDriverOccupationLOV
 * Description: Retrieves the GICLDrvrOccptn LOV
 * @author Irwin Tabisora, 9.14.11
 * */
function showDriverOccupationLOV(moduleId){
	try{
		LOV.show({
			controller : "ClaimsLOVController",
			urlParameters : {
				action : "getDriverOccupationList",
				page : 1			
			},
			title: "Occupation",
			width : 400,
			height : 300,
			columnModel : [
			               {
			            	   id : "drvrOccCd",
			            	   title : "Occupation Cd",
			            	   width : '100px'
			               },
			               {
			            	   id : "occDesc",
			            	   title : "Occupation Type",
			            	   width : '260px'
			               }
			              ],
			draggable : true,
			onSelect : function(row){
				if(moduleId == "GICLS014other"){
					$("detDriverOccupation").value = unescapeHTML2(row.occDesc);
					$("detDriverOccupationCd").value = row.drvrOccCd;
				}else{
					$("txtDrvrOccDesc").value = unescapeHTML2(row.occDesc);
					$("txtDrvrOccCd").value = row.drvrOccCd;
				}
			}			
		});
	}catch(e){
		showErrorMessage("showDriverOccupationLOV",e);
	}
}