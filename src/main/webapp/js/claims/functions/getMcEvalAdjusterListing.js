function getMcEvalAdjusterListing(claimId){
	try{
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getMcEvalAdjusterListing",
							claimId : claimId,
							page : 1},
			title: "Subline",
			width: 400,
			height: 400,
			columnModel : [
							{
								id : "payeeName",
								title: "Payee Name",
								width: '380px'
							},
							{
								id : "clmAdjId",
								title: "",
								visible: false,
								width: '0px'
							}
						],
			draggable: true,
			onSelect : function(row){
				changeTag = 1; //marco - 03.27.2014
				$("dspAdjusterDesc").value = unescapeHTML2(row.payeeName);
				$("clmAdjId").value = row.clmAdjId;
			}
		});	
	}catch(e){
		showErrorMessage("getMcEvalAdjusterListing",e);
	}
}