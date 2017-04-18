/*
 * Created by : mark jm 07.21.2011 Description : lov for peril by item_no (for
 * item module only)
 */
function showPerilByItemLOV(parId, itemNo, lineCd, sublineCd, perilType, notIn,
		func) {
	LOV
			.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGIISPerilByItemLOV",
					parId : parId,
					itemNo : itemNo,
					lineCd : lineCd,
					sublineCd : sublineCd,
					perilType : perilType,
					notIn : notIn,
					page : 1
				},
				title : "Perils",
				width : 660,
				height : 320,
				columnModel : [ {
					id : "perilName",
					title : "Peril Name",
					width : '220px'
				}, {
					id : "perilSname",
					title : "Short Name",
					width : '90px'
				}, {
					id : "perilType",
					title : "Type",
					width : '90px'
				}, {
					id : "bascPerlCd",
					title : "Basic Peril Code",
					width : '120px',
					visible : false
				}, {
					id : "basicPeril",
					title : "Basic Peril Name",
					width : '120px'
				}, {
					id : "perilCd",
					title : "Code",
					width : '90px'
				}, ],
				draggable : true,
				onSelect : function(row) {
					if (row != undefined) {
						var prevPerilcd = $("perilCd").value;
						$("perilCd").value = row.perilCd;
						$("txtPerilName").value = unescapeHTML2(row.perilName);
						$("txtPerilName").writeAttribute("perilCd",
								nvl(row.perilCd, ""));
						$("txtPerilName").writeAttribute("riCommRt",
								nvl(row.riCommRt, ""));
						$("txtPerilName").writeAttribute("perilType",
								nvl(row.perilType, ""));
						$("txtPerilName").writeAttribute("bascPerlCd",
								nvl(row.bascPerlCd, ""));
						$("txtPerilName").writeAttribute("basicPerilName",
								nvl(row.basicPerilName, "")); // added by:
						// Nica
						// 05.03.2012
						$("txtPerilName").writeAttribute("wcSw",
								nvl(row.wcSw, ""));
						$("txtPerilName").writeAttribute("tarfCd",
								nvl(row.tarfCd, ""));
						$("txtPerilName").writeAttribute("defaultRate",
								nvl(row.defaultRate, ""));
						$("txtPerilName").writeAttribute("defaultTsi",
								nvl(row.defaultTsi, ""));
						$("perilTarfCd").value = row.tarfCd;
						$("txtPerilTarfDesc").value = row.tarfCd;
						// added by darwin, 12/15/2011
						if (row.perilType == "B") {
							$("perilRate").setAttribute("min", '0.000000001');
							$("premiumAmt").setAttribute("min", '0.01');
						} else {
							$("perilRate").setAttribute("min", '0');
							$("premiumAmt").setAttribute("min", '0');
						}

						if (prevPerilcd == row.perilCd) { // belle 11.09.2011
							// to clear fields
							// when perilCd was
							// changed
							func();
						} else {
							$("perilRate").value = "";
							$("perilTsiAmt").value = "";
							$("premiumAmt").value = "";

							func();
						}
						if(row.riCommRt != null && row.defaultTsi != null){ // bonok :: 10.07.2014 :: compute for RI Comm Amt if there is Default TSI and default rate
							$("perilRiCommAmt").value = (unformatCurrencyValue($("premiumAmt").value) * parseFloat(row.riCommRt)) / 100;
							$("perilRiCommAmt").value = formatCurrency($("perilRiCommAmt").value);
						}
					}
				}
			});
}