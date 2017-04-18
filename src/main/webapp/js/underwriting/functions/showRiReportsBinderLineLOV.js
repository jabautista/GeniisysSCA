/**
* Shows Line LOV for GIRIS051 - Generate RI Reports (Binder tab)
* @author Shan Bati 01.16.2013
*/

function showRiReportsBinderLineLOV() {
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
			height : 386,
			columnModel : [ {
				id : "lineCd",
				title : "Line Cd",
				width : '80px'
			}, {
				id : "lineName",
				title : "Line Name",
				width : '308px'
			} ],
			draggable : true,
			onSelect : function(row) {
				if (row != undefined) {
					$("txtLineCd").value = row.lineCd;
					if(row.lineCd == "SU"){
						$("chkPrNtcTD").show();						
					}else {
						$("chkPrNtcTD").hide();			
					}
				}
			}
		});
	} catch (e) {
		showErrorMessage("showRiReportsBinderLineLOV", e);
	}
}