//belle 02.20.2012 show peril list in availments page
function showClmAvailPerilLOV(){
	try{
		var availNoOfDays = null;
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : 	"getClmAvailPerilLOV",
							page : 		1,
							claimId:	objCLMGlobal.claimId,
							itemNo:		$F("txtItemNo"),
							groupedItemNo: $F("txtGrpItemNo")
			},
			title: "List of peril",
			width: 405,
			height: 386,
			columnModel:[	
			             	{	id : "perilCd",
								title: "Peril Cd",
								width: '70px',
								type: 'number'
							},
							{	id : "dspPerilName",
								title: "Peril Name",
								width: '320px'
							} 
						],
			draggable: true,
			onSelect : function(row){
				$("perilName").value  = unescapeHTML2(row.dspPerilName);
				$("dspAllow").value   = unescapeHTML2(row.dspAllow);
				availmentsGrid.url += "&noOfDays=" +row.noOfDays;
				availmentsGrid._refreshList();	
			}
		});
	}catch(e){
		showErrorMessage("showClmBenNoLOV", e);
	}
}