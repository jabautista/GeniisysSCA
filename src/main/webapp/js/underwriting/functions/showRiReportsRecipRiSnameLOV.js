/**
* Shows Reinsurer Name and Reinsurer CD LOV for GIRIS051 - Generate RI Reports (Reciprocity tab)
* @author Shan Bati 02.12.2013
*/

function showRiReportsRecipRiSnameLOV(riSnameId, riCdId) {
	try {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getReinsurerLOV2"
			},
			title : "Reinsurers",
			width : 405,
			height : 388,
			columnModel : [ 
                {
					id : "riSname",
					title : "Reinsurer",
					width : '320px'
				},
                {
                	id: "riCd",
                	title: "RI CD",
                	width: '70px'
                } ],
			draggable : true,
			onSelect : function(row) {
				if (row != undefined) {
					$(riSnameId).value = row.riSname;
					$(riCdId).value = row.riCd;
				}
			}
		});
	} catch (e) {
		showErrorMessage("showRiReportsRecipRiSnameLOV", e);
	}
}