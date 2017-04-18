/*
 * Date Author Description ========== ===============
 * ============================== 10.06.2011 mark jm lov for accident
 * beneficiary peril lov
 */
function showBeneficiaryPerilLOV(lineCd, sublineCd, notIn) {
	try {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getBeneficiaryPerilLOV",
				lineCd : lineCd,
				sublineCd : sublineCd,
				notIn : notIn,
				page : 1
			},
			title : "Default Perils",
			width : 400,
			height : 300,
			columnModel : [ {
				id : "perilName",
				title : "Peril Name",
				width : '360px'
			} ],
			draggable : true,
			onSelect : function(row) {
				if (row != undefined) {
					$("bpPerilCd").value = row.perilCd;
					$("bpPerilName").value = unescapeHTML2(row.perilName);
					$("bpPerilType").value = row.perilType;
					$("bpRiCommAmt").value = row.riCommAmt;
					$("bpBascPerlCd").value = row.bascPerlCd;
					$("bpBasicPeril").value = row.basicPeril;
					$("bpIntmCommRt").value = row.IntmCommRt;
					$("bpPrtFlag").value = row.prtFlag;
					$("bpLineCd").value = row.lineCd;
				}
			}
		});
	} catch (e) {
		showErrorMessage("showBeneficiaryPerilLOV", e);
	}
}