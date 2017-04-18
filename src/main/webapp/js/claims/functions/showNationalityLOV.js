/**
 * showNationalityLOV
 * Description: Retrieves the GIISNationality LOV 
 * @author Irwin Tabisora 9.14.11
 * */
function showNationalityLOV(moduleId){
	try{
		LOV.show({
			controller : "ClaimsLOVController",
			urlParameters : {
				action : "getNationalityLOV",
				page : 1			
			},
			title: "Nationality",
			width : 400,
			height : 300,
			columnModel : [
			               {
			            	   id : "nationalityCd",
			            	   title : "Nationality Cd",
			            	   width : '100px'
			               },
			               {
			            	   id : "nationalityDesc",
			            	   title : "NationalityDesc",
			            	   width : '260px'
			               }
			              ],
			draggable : true,
			onSelect : function(row){
				if(moduleId == "GICLS014other"){
					$("detNationalityDesc").value = row.nationalityDesc;
					$("detNationalityCd").value = row.nationalityCd;
				}else{
					$("txtNationalityDesc").value = row.nationalityDesc;
					$("txtNationalityCd").value = row.nationalityCd;
				}
				
			}			
		});
	}catch(e){
		showErrorMessage("showNationalityLOV",e);
	}
}