/* Author: Udel
 * Date: 03282012
 * show Quotation Warranties and Clauses LOV (based on function showQuoteWarrantyAndClauseLOV)
 * */
function showQuoteWarrClaLOV(lineCd, notIn,generatePrintSeqNo){
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
			jsonWarrCla.populateQuoteWarrCla(row);
			$("printSeqNumber").value = generatePrintSeqNo;
		}
	  });
}