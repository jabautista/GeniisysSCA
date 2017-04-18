/**
 * Show Loss Category LOV
 * @author niknok 10.14.2011
 * */
function showLossCatLOV(lineCd, moduleId){
	try{
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : 	"getLossCatDtlLOV",
							page : 		1,
							lineCd: 	lineCd
			},
			title: "List of Loss Category",
			width: 405,
			height: 386,
			columnModel:[	
							{	id : "lossCatCd",
								title: "Code",
								width: '70px',
								type: 'number'
							},
							{	id : "lossCatDesc",
								title: "Description",
								width: '318px'
							},
							{	id : "totalTag",
								title: "",
								width: '0px',
								visible: false
							} 
						],
			draggable: true,
			onSelect : function(row){
				if (moduleId == "GICLS010"){
					changeTag = 1;
					objCLM.basicInfo.lossCatCd = row.lossCatCd;
					objCLM.basicInfo.dspLossCatDesc = row.lossCatDesc;
					$("txtLossCatCd").value = unescapeHTML2(row.lossCatCd);
					$("txtLossDesc").value = unescapeHTML2(row.lossCatDesc);
					$("txtLossDesc").focus();
					if (nvl(row.totalTag,"N") == "Y"){
						showConfirmBox("","Do you want to tag the total loss for this claim? If yes, then you will not be able to create another claim for this policy.","Yes","No",
								function(){
									objCLM.basicInfo.totalTag = "Y";
									$("chkTotalLoss").checked = true;
								},
								function(){
									objCLM.basicInfo.totalTag = "N";
									$("chkTotalLoss").checked = false;
								});
					}
				}
			},
	  		onCancel: function(){
	  			if (moduleId == "GICLS010"){
	  				$("txtLossDesc").focus();
	  			}
	  		}
		});
	}catch(e){
		showErrorMessage("showLossCatLOV",e);
	}
}