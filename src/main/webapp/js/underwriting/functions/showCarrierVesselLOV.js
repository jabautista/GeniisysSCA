/*
 * Date Author Description ========== ===============
 * ============================== 09.23.2011 mark jm lov for marine cargo list
 * of carrier lov
 */
function showCarrierVesselLOV(parId, notIn) {
	try {
		LOV
				.show({
					controller : "UnderwritingLOVController",
					urlParameters : {
						action : "getVesselLOV",
						parId : parId,
						notIn : notIn,
						page : 1
					},
					title : "List of Vessels",
					width : 400,
					height : 300,
					columnModel : [ {
						id : "vesselCd",
						title : "Vessel Cd",
						width : '100px'
					}, {
						id : "vesselName",
						title : "Vessel Name",
						width : '260px'
					}, {
						id : "plateNo",
						title : "Plate No.",
						width : '150px'
					}, {
						id : "motorNo",
						title : "Motor No.",
						width : '150px'
					}, {
						id : "serialNo",
						title : "Serial No.",
						width : '150px'
					} ],
					draggable : true,
					onSelect : function(row) {
						if (row != undefined) {
							$("carrierVesselCd").value = row.vesselCd;
							$("carrierVesselName").value = unescapeHTML2(row.vesselName);
							$("carrierPlateNo").value = row.plateNo;
							$("carrierMotorNo").value = row.motorNo;
							$("carrierSerialNo").value = row.serialNo;
						}
					}
				});
	} catch (e) {
		showErrorMessage("showCarrierVesselLOV", e);
	}
}