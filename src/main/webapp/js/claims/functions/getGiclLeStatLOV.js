/**
 * Gets the list of all gicl_le_stat records
 * @author Veronica V. Raymundo
 * 
 */

function getGiclLeStatLOV(){
	try{
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getGiclLeStatList"},
			title: "History Status",
			width: 400,
			height: 400,
			columnModel : [
							{
								id : "leStatCd",
								title: "Claim Status",
								width: '100px'
							},
							{
								id : "leStatDesc",
								title: "Description",
								width: '280px'
							}
						],
			draggable: true,
			onSelect : function(row){
				$("txtHistStatus").value = unescapeHTML2(row.leStatDesc);
				$("txtHistStatus").setAttribute("histStatus", row.leStatCd);
				changeTag = 1;
			}
		});	
	}catch(e){
		showErrorMessage("getGiclLeStatLOV",e);
	}
}
