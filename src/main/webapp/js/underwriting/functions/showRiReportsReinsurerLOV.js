/**
* Shows Reinsurer Name LOV for GIRIS051 - Generate RI Reports (Outstanding tab)
* @author Shan Bati 01.29.2013
*/

function showRiReportsReinsurerLOV(riNameId, riCdId) {
	try {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getGIISReinsurerLOV4"
			},
			title : "Reinsurers",
			width : 405,
			height : 388,
			columnModel : [ 
                {
                	id: "riCd",
                	width: '0px',
                	visible: false
                },
                {
					id : "riName",
					title : "Reinsurer Name",
					width : '390px'
				} ],
			draggable : true,
			onSelect : function(row) {
				if (row != undefined) {
					$(riNameId).value = unescapeHTML2(row.riName); //edited by gab 11.13.2015
					$(riCdId).value = row.riCd;
				}
			}
		});
	} catch (e) {
		showErrorMessage("showRiReportsReinsurerLOV", e);
	}
}