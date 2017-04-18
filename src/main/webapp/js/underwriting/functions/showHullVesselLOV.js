/*
 * Date Author Description ========== ===============
 * ============================== 12.01.2011 mark jm lov for marine hull vessel
 */
function showHullVesselLOV(parId, itemNo) {
	try {
		LOV
				.show({
					controller : "UnderwritingLOVController",
					urlParameters : {
						action : "getHullVesselLOV",
						parId : parId,
						itemNo : itemNo,
						page : 1
					},
					title : "Available Vessel",
					width : 600,
					height : 300,
					columnModel : [ {
						id : "vesselName",
						title : "Vessel Name",
						width : '200px'
					}, {
						id : "vesselOldName",
						title : "Old Name",
						width : '200px'
					}, {
						id : "vestypeDesc",
						title : "Type",
						width : '150px'
					}, {
						id : "hullTypeDesc",
						title : "Hull Type",
						width : '150px'
					}, {
						id : "noCrew",
						title : "No. of Crew",
						width : '80px',
						align : 'right'
					}, {
						id : "netTon",
						title : "Net Ton",
						width : '60px',
						align : 'right'
					}, {
						id : "deadweight",
						title : "Deadweight",
						width : '80px',
						align : 'right'
					}, {
						id : "crewNat",
						title : "Nationality",
						width : '70px'
					}, {
						id : "dryPlace",
						title : "Drydock Place",
						width : '100px'
					}, {
						id : "dryDate",
						title : "Drydock Date",
						width : '70px',
						renderer : function(value) {
							return formatDateToDefaultMask(value);
						}
					} ],
					draggable : true,
					onSelect : function(row) {
						if (row != undefined) {
							$("vesselCd").value = row.vesselCd;
							$("vesselName").value = unescapeHTML2(row.vesselName);
							$("vesselOldName").value = unescapeHTML2(row.vesselOldName);
							$("vesTypeDesc").value = unescapeHTML2(row.vestypeDesc);
							$("propelSw").value = unescapeHTML2(row.propelSw);
							$("vessClassDesc").value = unescapeHTML2(row.vessClassDesc);
							$("hullDesc").value = unescapeHTML2(row.hullTypeDesc);
							$("regOwner").value = unescapeHTML2(row.regOwner);
							$("regPlace").value = unescapeHTML2(row.regPlace);
							$("grossTon").value = nvl(row.grossTon, "") != "" ? formatCurrency(row.grossTon)
									: "";
							$("vesselLength").value = nvl(row.vesselLength, "") != "" ? formatCurrency(
									row.vesselLength).replace(/,/g, "")
									: "";
							$("yearBuilt").value = row.yearBuilt;
							$("netTon").value = nvl(row.netTon, "") != "" ? formatCurrency(row.netTon)
									: "";
							$("vesselBreadth").value = nvl(row.vesselBreadth,
									"") != "" ? formatCurrency(
									row.vesselBreadth).replace(/,/g, "") : "";
							$("noCrew").value = nvl(row.noCrew, "") != "" ? lpad(
									row.noCrew, 8, "0")
									: "";
							$("deadWeight").value = nvl(row.deadweight, "") != "" ? lpad(
									row.deadweight, 8, "0")
									: "";
							$("vesselDepth").value = nvl(row.vesselDepth, "") != "" ? formatCurrency(
									row.vesselDepth).replace(/,/g, "")
									: "";
							$("crewNat").value = unescapeHTML2(row.crewNat);	//Gzelle 06012015 SR4302
							$("dryPlace").value = unescapeHTML2(row.dryPlace);	//Gzelle 06012015 SR4302
							$("dryDate").value = formatDateToDefaultMask(row.dryDate);

							changeTag = 1;
						}
					}
				});
	} catch (e) {
		showErrorMessage("showHullVesselLOV", e);
	}
}