/** chris  10/17/2012
 *  GIISS208 LOV
 */ 
function showPerilDepNameLOV(moduleId, lineCd){
	try{
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getPerilDepNameLOV",
				lineCd : lineCd,
				page : 1
			},
			title: "Peril Code and Name List",
			width : 360,
			height : 400,
			columnModel : [{
			            	   id : "perilCd",
			            	   title : "Peril Code",
			            	   width : '100px'
			               },
			               {
			            	   id : "perilName",
			            	   title : "Peril Name",
			            	   width : '250px'
			               },
			              ],
			draggable : true,
			onSelect: function(row){
				$("txtPerilCd").value = row.perilCd;
				$("txtPerilName").value = unescapeHTML2(row.perilName);
			}
		});
	}catch(e){
		showErrorMessage("showPerilDepNameLOV", e);
	}
}