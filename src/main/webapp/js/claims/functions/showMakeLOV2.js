/**
 * showMakeLOV2
 * Description: Retrieves the showMakeLOV2 LOV 
 * Added moduleId for extra functionality
 * @author Irwin Tabisora 9.15.11
 * */
function showMakeLOV2(sublineCd, carCompanyCd, moduleId){
	try{
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getMakeLOV",
				sublineCd : sublineCd,
				carCompanyCd : carCompanyCd,
				page : 1			
			},
			title: "Make",
			width : 400,
			height : 300,
			columnModel : [
			               {
			            	   id : "makeCd",
			            	   title : "Make Cd",
			            	   width : '100px'
			               },
			               {
			            	   id : "make",
			            	   title : "Make",
			            	   width : '260px'
			               }
			              ],
			draggable : true,
			onSelect : function(row){
				if(moduleId == "GICLS014other"){
					$("detMakeCd").value 		= row.makeCd;
					$("detMake").value 		= unescapeHTML2(row.make);
					$("detCarCompanyCd").value = row.carCompanyCd;
					$("detCarCompany").value 	= unescapeHTML2(row.carCompany);
				}else{
					$("carCompanyCd").value	= row.carCompanyCd;
					$("carCompany").value	= unescapeHTML2(row.carCompany);
					$("makeCd").value 		= row.makeCd;
					$("make").value 		= unescapeHTML2(row.make);
				}
			}			
		});
	}catch(e){
		showErrorMessage("showMakeLOV2", e);
	}
}