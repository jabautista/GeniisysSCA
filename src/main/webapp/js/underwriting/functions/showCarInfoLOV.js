/**
 * Shows required documents lov
 * 
 * @author agazarraga (alvin azarraga)
 * @date 05.16.2012
 */
function showCarInfoLOV(lineCd, notIn) {
	LOV.show({
		controller : "UnderwritingLOVController",
		urlParameters : {
			action : "getCarInfoLOV",
			lineCd : lineCd,
			notIn : notIn,
			page : 1
		},
		title : "Valid values for Carrier",
		width : 500,
		height : 400,
		draggable : true,
		columnModel : [ {
			id : "vesselName",
			title : "Carrier",
			width : "230px"
		}, {
			id : "vesselType",
			title : "Vessel Type",
			width : "80px"
		}, {
			id : "motorNo",
			title : "Motor No",
			width : "100px"
		}, {
			id : "plateNo",
			title : "Plate No",
			width : "70px"
		} ],
		onSelect : function(row) {
			if (row != undefined) {
				/*
				 * $("inputVesselDisplay").value =
				 * unescapeHTML2(row.vesselName); $("inputVesselFlag").value =
				 * unescapeHTML2(row.vesselType); $("hidVesselCd").value =
				 * unescapeHTML2(row.vesselCd); $("hidVesselName").value =
				 * unescapeHTML2(row.vesselName); $("hidVesselFlag").value =
				 * unescapeHTML2(row.vesselFlag); $("hidVesselType").value =
				 * unescapeHTML2(row.vesselType);
				 */
				/*
				 * $("vesselType").value = unescapeHTML2(row.vesselType);
				 * $("motorNo").value = unescapeHTML2(row.motorNo);
				 * $("plateNo").value = unescapeHTML2(row.plateNo);
				 */
				$("inputVesselDisplay").value = unescapeHTML2(row.vesselName);
				// $("hidVesFlag").value = unescapeHTML2(row.vesselFlag);
				$("inputVessel").value = unescapeHTML2(row.vesselCd);
				$("inputVesselFlag").value = unescapeHTML2(row.vesselType);
			}
		}
	});

}