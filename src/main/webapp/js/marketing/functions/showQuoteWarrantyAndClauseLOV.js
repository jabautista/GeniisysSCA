/**
 * Shows policy warranties and clauses list of values(same with showWarrantyAndClauseLOV)
 * @author emsy bolaños
 * @date 11.16.2011
 */
function showQuoteWarrantyAndClauseLOV(lineCd, notIn){ //steven 3.20.2012
	LOV.show({
		controller: "UnderwritingLOVController",
		urlParameters: {action : "getGIISWarrClaLOV",
					    lineCd : lineCd,
					    notIn : notIn,
					    page : 1},
		title: "List of Warranties and Clauses",
		width: 650,
		height: 386,
		columnModel : [	{	id : "wcTitle",
							title: "Warranty Title",
							width: '450px'
						},
						{	id : "wcCd",
							title: "Code",
							width: '70px'
						},  
						{	id : "wcSw",
							title : "Type",
							width : '100px'
						}
					],
		draggable: true,
		onSelect: function(row){
			synchQuoteDetailsInWarrantyList(row);
		}
	  });
}