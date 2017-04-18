/*
 * Date Author Description ========== ===============
 * ============================== 10.06.2011 mark jm lov for accident grouped
 * coverage peril lov
 */
function showGroupedPerilLOV(parId, lineCd, sublineCd, notIn, perilType, func) {
	try {
		LOV
				.show({
					controller : "UnderwritingLOVController",
					urlParameters : {
						action : "getGroupedPerilLOV",
						parId : parId,
						lineCd : lineCd,
						sublineCd : sublineCd,
						notIn : notIn,
						perilType : perilType,
						page : 1
					},
					title : "Default Perils",
					width : 400,
					height : 300,
					columnModel : [ {
						id : "perilName",
						title : "Peril Name",
						width : '200px'
					}, {
						id : "perilCd",
						title : "Peril Cd",
						align : 'right',
						width : '50px'
					}, {
						id : "lineCd",
						title : "Line Cd",
						width : '50px'
					}, {
						id : "perilType",
						title : 'Peril Type',
						width : '60px'
					}, {
						id : "bascPerlCd",
						title : '',
						width : '0px',
						visible : false
					}

					],
					draggable : true,
					onSelect : function(row) {
						if (row != undefined) {
							$("cPerilCd").value = row.perilCd;
							$("cPerilName").value = unescapeHTML2(row.perilName);
							$("cLineCd").value = row.lineCd;
							$("cPerilType").value = row.perilType;
							$("cWcSw").value = row.wcSw;
							$("cBascPerlCd").value = row.bascPerlCd;
							$("cBasicPerilName").value = unescapeHTML2(row.basicPerilName);

							func();
						}
					}
				});
	} catch (e) {
		showErrorMessage("showGroupedPerilLOV", e);
	}
}