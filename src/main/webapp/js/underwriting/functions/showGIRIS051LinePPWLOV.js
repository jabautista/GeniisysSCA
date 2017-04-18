/*
 * Shows Line LOV for GIRIS051 - Expiry PPW tab
 * Shan 05.15.2013
 */
function showGIRIS051LinePPWLOV(lineCdId, lineNameId){
	try{
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getGIRIS051LinePPWLOV",
				moduleId: "GIRIS051"
			},
			title: 'Line PPW',
			width : 405,
			height : 388,
			columnModel : [ 
	            {
					id : "lineCd",
					width : '0px',
					visible: false
				},
	            {
	            	id: "lineName",
	            	title: "Line Name",
	            	width: '390px'
	            } ],
			draggable : true,
			onSelect : function(row) {
				if (row != undefined) {
					$(lineCdId).value = row.lineCd;
					$(lineNameId).value = row.lineName;
				}
			}
		});
	} catch (e) {
		showErrorMessage("showGIRIS051LinePPWLOV", e);
	}
}