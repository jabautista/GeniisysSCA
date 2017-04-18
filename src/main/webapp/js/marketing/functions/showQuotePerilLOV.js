function showQuotePerilLOV(lineCd, sublineCd, perilType, notIn){
	LOV.show({
		controller: "UnderwritingLOVController",
		urlParameters: {action : "getGIISPerilLOV",
						lineCd : lineCd,
						sublineCd : sublineCd,
						perilType : perilType,
						notIn : nvl(notIn, ""),
						page : 1},
		title: "Perils",
		width: 660,
		height: 320,
		columnModel : [	{	id : "perilName",
							title: "Peril Name",
							width: '220px'
						},
						{	id : "perilSname",
							title: "Short Name",
							width: '90px'
						},
						{	id : "perilType",
							title: "Type",
							width: '90px'
						},	
						{	id : "basicPeril",
							title: "Basic Peril Name",
							width: '120px'
						},
						{	id : "perilCd",
							title: "Code",
							width: '90px'
						},
					],
		draggable: true,
		onSelect: function(row){
			if(row != undefined){ // modified by: nica 05.24.2011
				$("txtPerilName").value = unescapeHTML2(row.perilName);
				$("txtTsiAmount").value = formatCurrency(nvl(row.defaultTsi, 0));
				$("txtPerilRate").value = formatToNineDecimal(nvl(row.defaultRate, 0));
				if(objMKGlobal.packQuoteId != null){
					$("txtPremiumAmount").value =  computePremiumAmountForPackQuote();
				}
				$("txtPerilName").writeAttribute("perilCd", row.perilCd);
				$("txtPerilName").writeAttribute("perilType", row.perilType);
				$("txtPerilName").writeAttribute("basicPerilCd", row.bascPerlCd);
				$("txtPerilName").writeAttribute("basicPerilName", row.basicPerilName);
			}
		}
	  });
}