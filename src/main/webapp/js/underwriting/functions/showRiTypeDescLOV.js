/**
 * Shows Reinsurer Type Desc LOV
 * Module: GIRIS051 (Ri Listing tab)
 * @author Shan Bati 02.11.2013
 */
function showRiTypeDescLOV(){
	try{
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters:{
				action: "getGIISReinsurerTypeLOV"
			},
			title: "Type of Reinsurers",
			width: 405,
			height: 387,
			columnModel: [
				{
					id: "riTypeDesc",
					title: "Reinsurer Type Description",
					width: "392px"
				}
			],
			draggable: true,
			onSelect: function(row){
				if(row != undefined){
					$("txtRiTypeDesc").value = row.riTypeDesc;
				}
			}
			
		});
	}catch(e){
		showErrorMessage("showRiTypeDescLOV", e);
	}
}