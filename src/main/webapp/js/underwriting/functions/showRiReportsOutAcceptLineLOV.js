/**
* Shows Line LOV for GIRIS051 - Generate RI Reports (Outstanding tab)
* @author Shan Bati 01.29.2013
*/

function showRiReportsOutAcceptLineLOV(lineNameId, lineCdId) {
	try {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getAllLineLOV",
				issCd : "",
				moduleId : "GIRIS051"
			},
			title : "Lines",
			width : 405,
			height : 388,
			columnModel : [ 
                {
					id: "lineCd",
					width: '0px',
					visible: false
				},
				{
					id : "lineName",
					title : "Line Name",
					width : '390px'
				} ],
			draggable : true,
			onSelect : function(row) {
				if (row != undefined) {
					$(lineNameId).value = row.lineName;
					$(lineCdId).value = row.lineCd;
				}
			}
		});
	} catch (e) {
		showErrorMessage("showRiReportsOutAcceptLineLOV", e);
	}
}