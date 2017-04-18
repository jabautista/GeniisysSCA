/**
 * Shows risks lov
 * @author andrew
 * @date   04.25.2011
 */
function showQuoteRiskLOV(blockId){
	LOV.show({
		controller: "UnderwritingLOVController",
		urlParameters: {action : "getGIISRiskLOV",
						blockId : blockId,
						page : 1},
		title: "Risks",
		width: 460,
		height: 300,
		columnModel : [						
						{
							id : "riskCd",
							title: "Code",
							width: '0',
							visible: false
						},
						{
							id : "riskDesc",
							title: "Risk",
							width: '350px'
						}
					],
		draggable: true,
		/* emsy 12.02.2011
		 * onOk: function(row){
							$("riskCd").value = row.riskCd;
							$("risk").value = row.riskDesc;
						},
						onRowDoubleClick: function(row){
							$("riskCd").value = row.riskCd;
							$("risk").value = row.riskDesc;
						}
	  });*/
		onSelect: function(row){
			$("riskCd").value = row.riskCd;
			$("risk").value = row.riskDesc;
		}
	  });
}