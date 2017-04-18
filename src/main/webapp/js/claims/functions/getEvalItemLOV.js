function getEvalItemLOV(claimId){
	try{
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getEvalItemLOV",
							claimId: claimId,
							page : 1},
			title: "Item",
			width: 600,
			height: 400,
			columnModel : [
							{
								id : "itemNo",
								title: "Item No.",
								width: '40px'
							},
							{
								id : "itemTitle",
								title: "Item Title",
								width: '300'
							},
							{
								id : "plateNo",
								title: "Plate Number",
								width: '100'
							},
							{
								id : "carCompany",
								title: "Car Company",
								width: '150'
							},
							{
								id : "make",
								title: "Make",
								width: '100'
							},
							{
								id : "engineSeries",
								title: "Eng Series",
								width: '100'
							},
							{
								id : "tpSw",
								title: "TP SW",
								width: '30'
							},
							{
								id : "payeeName",
								title: "Payee Name",
								width: '150'
							},
							{
								id : "payeeClassCd",
								title: "",
								width: '0',
								visible: false
							},
							{
								id : "payeeNo",
								title: "",
								width: '0',
								visible: false
							},
							{
								id : "currencyCd",
								title: "",
								width: '0',
								visible: false
							},
							{
								id : "shortName",
								title: "",
								width: '0',
								visible: false
							},
							{
								id : "perilCd",
								title: "",
								width: '0',
								visible: false
							},
							{
								id : "dspPerilDesc",
								title: "",
								width: '0',
								visible: false
							},
							{
								id : "allowPeril",
								title: "",
								width: '0',
								visible: false
							}
						],
			draggable: true,
			onSelect : function(row){
				mcMainObj.itemNo = row.itemNo;
				mcMainObj.dspItemDesc = row.itemTitle;
				mcMainObj.plateNo = nvl(row.plateNo,"");
				mcMainObj.tpSw = row.tpSw;
				mcMainObj.payeeClassCd = row.payeeClassCd;
				mcMainObj.payeeNo = row.payeeNo;
				
				if(nvl(row.allowPeril, "N") == "N"){ //marco - 05.26.2015 - GENQA SR 4484 - added condition
					mcMainObj.perilCd = row.perilCd;
					mcMainObj.dspPerilDesc = row.dspPerilDesc;
				}
				
				$("textItemNo").value = row.itemNo;
				$("textItemDesc").value = unescapeHTML2(row.itemTitle);
				$("txtPlateNo").value = unescapeHTML2(row.plateNo);
				$("dspPayee").value = unescapeHTML2(row.payeeName);
				$("dspCurrShortname").value = unescapeHTML2(row.shortName);

				changeTag = 1;
				
				getMcItemPeril(claimId,row.itemNo);
			}
		});	
	
	}catch(e){
		showErrorMessage("getEvalItemLOV",e);
	}
}