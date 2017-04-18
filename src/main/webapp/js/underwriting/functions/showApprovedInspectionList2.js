function showApprovedInspectionList2(parId, assdNo){
	try{
		LOV.show({ 
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getApprovedInspectionList2",
							parId  : parId,
							assdNo : assdNo
							},
			title: "Inspection List",
			width: 900,
			height: 400,
			columnModel : [						
							{
								id : "inspNo",
								title: "Insp. No.",
								width: '65px'
							},
							{
								id : "inspName",
								title: "Inspector Name",
								width: '200px'
							},
							{
								id : "assdName",
								title: "Assured Name",
								width: '265px'
							},
							{
								id : "locOfRisk",
								title: "Location of Risk",
								width: '350px'
							}
							
							/*{
								id : "locRisk1",
								title: "Loc Risk 1",
								width: '125px'
							},
							{
								id : "locRisk2",
								title: "Loc Risk 2",
								width: '125px'
							},
							{
								id : "locRisk3",
								title: "Loc Risk 3",
								width: '125px'
							}*/ // replaced by: Nica 12.21.2012
						],
			draggable: true,
			onSelect: function(row){
				convertInspectionToPAR(row);
			}
		});
	} catch (e) {
		showErrorMessage("showApprovedInspectionList2", e);
	}
}