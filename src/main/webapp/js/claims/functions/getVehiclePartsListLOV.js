function getVehiclePartsListLOV(evalId,notIn){
	try{
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getVehiclePartsListLOV",
							evalId: evalId,
							notIn: notIn,
							page : 1},
			title: "Vehicle Parts",
			width: 380,
			height: 400,
			columnModel : [
							{
								id : "dspLossDesc",
								title: "Vehicle Part",
								width: '350px'
							},
							{
								id : "lossExpCd",
								title: "",
								width: '0',
								visible: false
							}
						],
			draggable: true,
			onSelect : function(row){
				$("lossExpCd").value = row.lossExpCd;
				$("dspLossDesc").value = unescapeHTML2(row.dspLossDesc);
				changeTag = 1;
				$("dspLossDesc").setAttribute("changed", "changed");
				$("tinsmithRepairCd").disabled = "";
				$("paintingsRepairCd").disabled = "";
			}
		});	
	}catch(e){
		showErrorMessage("getCompanyListLOV",e);
	}
}