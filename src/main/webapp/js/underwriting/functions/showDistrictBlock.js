/*
 * Date Author Description ========== ===============
 * ============================== 08.31.2011 mark jm lov for district and block
 */
function showDistrictBlock(regionCd, provinceCd, cityCd, districtNo) {
	try {
		LOV
				.show({
					controller : "UWPolicyIssuanceLOVController",
					urlParameters : {
						action : "getGIISDistrictBlockLOV",
						regionCd : regionCd,
						provinceCd : escapeHTML2(provinceCd),
						cityCd : escapeHTML2(cityCd),
						districtNo : districtNo,
						page : 1
					},
					title : "List of Districts and Blocks",
					width : 660,
					height : 320,
					columnModel : [ {
						id : "districtNo",
						title : "District No.",
						width : '80px'
					}, {
						id : "districtDesc",
						title : "Description",
						width : '200px'
					}, {
						id : "blockNo",
						title : "Block No.",
						width : '80px'
					}, {
						id : "blockDesc",
						title : "Description",
						width : '260px'
					} ],
					draggable : true,
					onSelect : function(row) {
						if (row != undefined) {
							 // edited by Gab Ramos 07.15.15
							$("region").value = row.regionCd;
							$("provinceCd").value = unescapeHTML2(row.provinceCd);
							$("province").value = unescapeHTML2(row.province);
							$("cityCd").value = unescapeHTML2(row.cityCd);
							$("city").value = unescapeHTML2(row.city);
							$("district").value = unescapeHTML2(row.districtNo);
							$("districtNo").value = unescapeHTML2(row.districtNo);
							$("block").value = unescapeHTML2(row.blockNo);
							$("blockId").value = row.blockId;
							$("eqZone").value = unescapeHTML2(row.eqZone);
							$("eqZoneDesc").value = unescapeHTML2(row.eqDesc);
							$("typhoonZone").value = row.typhoonZone;
							$("typhoonZoneDesc").value = unescapeHTML2(row.typhoonZoneDesc);
							$("floodZone").value = row.floodZone;
							$("floodZoneDesc").value = unescapeHTML2(row.floodZoneDesc);
						}
					}
				});
	} catch (e) {
		showErrorMessage("showDistrictBlock", e);
	}
}