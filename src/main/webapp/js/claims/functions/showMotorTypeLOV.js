/**
 * showMotorTypeLOV
 * Description: Retrieves the GIISMotorType LOV
 * @param sublineCd
 * @author Irwin Tabisora, 9.14.11
 * */
function showMotorTypeLOV(sublineCd, moduleId){
	try{
		LOV.show({
			controller : "ClaimsLOVController",
			urlParameters : {
				action : "getMotorTypeLOV",
				sublineCd : sublineCd,
				page : 1			
			},
			title: "Motor Type",
			width : 400,
			height : 300,
			columnModel : [
			               {
			            	   id : "typeCd",
			            	   title : "Type Cd",
			            	   width : '100px'
			               },
			               {
			            	   id : "motorTypeDesc",
			            	   title : "Motor Type",
			            	   width : '260px'
			               }
			              ],
			draggable : true,
			onSelect : function(row){
				if (moduleId == "GICLS014other"){
					$("detTypeCd").value = row.typeCd;
					$("detMotorTypeDesc").value = row.motorTypeDesc;
				}else{
					$("motorTypeDesc").value = row.motorTypeDesc;
					$("typeCd").value = row.typeCd;	
				}
				
			}			
		});
	}catch(e){
		showErrorMessage("showMotorTypeLOV", e);
	}
}