function showQuoteDeductibleLOV(lineCd, sublineCd, notIn, perilTsiAmount){
	try {
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getGIISDeductibleLOV",
							lineCd : lineCd,
							sublineCd : sublineCd,
							notIn : nvl(notIn, ""),
							page : 1},
			title: "Deductibles",
			width: 660,
			height: 320,
			columnModel : [	{	id : "deductibleCd",
								title: "Code",
								width: '80px'
							},
							{	id : "deductibleTitle",
								title: "Title",
								width: '220px'
							},
							{	id : "deductibleTypeDesc",
								title: "Type",
								width: '150px'
							},	
							{	id : "deductibleRate",
								title: "Rate",
								width: '100px',
								align: 'right',
								geniisysClass: 'money'
							},
							{	id : "deductibleAmt",
								title: "Amount",
								width: '100px',
								align: 'right',
								geniisysClass: 'money'
							},
						],
			draggable: true,
			onSelect : function(row){
				if(row != undefined){
					onQuoteDeductibleSelected(row, perilTsiAmount);
				}
			}
		  });
	} catch (e){
		showErrorMessage("showQuoteDeductibleLOV", e);
	}
}