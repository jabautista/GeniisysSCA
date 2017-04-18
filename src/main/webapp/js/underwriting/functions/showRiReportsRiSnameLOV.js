/**
* Shows Reinsurer SName LOV for GIRIS051 - Generate RI Reports (Expiry List tab)
* @author Shan Bati 02.06.2013
*/

function showRiReportsRiSnameLOV(riSnameId, riCdId) {
	try {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getReinsurerLOV2"
			},
			title : "List of Reinsurers",
			width : 405,
			height : 388,
			columnModel : [ 
                {
                	id: "riCd",
                	width: '0px',
                	visible: false
                },
                {
					id : "riSname",
					title : "Reinsurer",
					width : '390px'
				} ],
			draggable : true,
			onSelect : function(row) {
				if (row != undefined) {
					$(riSnameId).value = row.riSname;
					if(riCdId != ""){
						$(riCdId).value = row.riCd;
					}
				}
			}
		});
	} catch (e) {
		showErrorMessage("showRiReportsRiSnameLOV", e);
	}
}