/**
 * This file contains underwriting lov functions 
 */

/**
 * Shows pack quotation list for pack par creation
 * 
 * @author Irwin
 * @date 07.04.2011
 * 
 */

/**
 * Shows Event Type lov Usage : Event Maintenance
 * 
 * @author andrew robes
 * @date 07.19.2011
 * move by steven in eventMaintenance.jsp
 */
/*function showEventTypeLOV() {
	try {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getCgRefCodeLOV",
				domain : "GIIS_EVENTS.EVENT_TYPE",
				page : 1
			},
			title : "Event Type",
			width : 450,
			height : 300,
			columnModel : [ {
				id : "rvLowValue",
				title : "Type",
				width : '80px'
			}, {
				id : "rvMeaning",
				title : "Meaning",
				width : '350px'
			} ],
			draggable : true,
			onSelect : function(row) {
				$("hidEventType").value = row.rvLowValue;
				$("txtEventTypeDesc").value = row.rvMeaning;
			}
		});
	} catch (e) {
		showErrorMessage("showEventTypeLOV", e);
	}
}*/

/**
 * Shows Receiver Tag Usage : Event Maintenance
 * 
 * @author andrew robes
 * @date 07.19.2011
 * move by steven in eventMaintenance.jsp
 */
/*function showReceiverTagLOV() {
	try {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getCgRefCodeLOV",
				domain : "GIIS_EVENTS.RECEIVER_TAG",
				page : 1
			},
			title : "Receiver Tag",
			width : 390,
			height : 300,
			columnModel : [ {
				id : "rvLowValue",
				title : "Receiver Tag",
				width : '100px'
			}, {
				id : "rvMeaning",
				title : "Description",
				width : '260px'
			} ],
			draggable : true,
			onSelect : function(row) {
				$("hidReceiverTag").value = row.rvLowValue;
				$("txtReceiverTagDesc").value = row.rvMeaning;
			}
		});
	} catch (e) {
		showErrorMessage("showReceiverTagLOV", e);
	}
}*/