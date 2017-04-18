/*
 * Date Author Description ========== ===============
 * ============================== 12.08.2011 mark jm lov for aviation vessel
 */
function showAviationVesselLOV(notIn) {
	try {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getAviationVesselLOV",
				notIn : notIn,
				page : 1
			},
			title : "Valid Aircraft Names",
			width : 600,
			height : 300,
			columnModel : [ {
				id : "vesselName",
				title : "Vessel Name",
				width : '200px'
			}, {
				id : "rpcNo",
				title : "RPC No.",
				width : '70px'
			}, {
				id : "airDesc",
				title : "Air Type",
				width : '200px'
			}, {
				id : "vesselCd",
				title : "Vessel Cd",
				width : '150px'
			} ],
			draggable : true,
			onSelect : function(row) {
				if (row != undefined) {
					$("vesselCd").value = row.vesselCd;
					$("txtVesselName").value = unescapeHTML2(row.vesselName);
					$("airType").value = unescapeHTML2(row.airDesc);
					$("rpcNo").value = unescapeHTML2(row.rpcNo);

					changeTag = 1;
				}
			}
		});
	} catch (e) {
		showErrorMessage("showAviationVesselLOV", e);
	}
}