/**
 * Validate if minimum premium amount is maintained in Line and Subline Maintenance
 * and check if summation of premium meets the minimum premium amount requirement 
 * @param refresh
 */
function validatePremiumAmount(refresh){
	try{
		var parId = (objUWGlobal.packParId != null ? objCurrPackPar.parId : objGIPIWPolbas.parId);
		var lineCd = objUWGlobal.lineCd;
		minPremFlag = "";
		
		new Ajax.Request(contextPath+"/GIPIWItemPerilController?action=validatePremiumAmount&globalParId="+parId+"&lineCd="+lineCd,{
			method: "POST",
			evalScripts: true,
			asynchronous: true,
			onComplete: function (response)	{
				if(checkErrorOnResponse(response)){
					var res = JSON.parse(response.responseText);
					//if(res.vIndicator == "0"){
						var objPerils = objGIPIWItemPeril.filter(function(obj){ return nvl(obj.recordStatus, 0) != -1; });
						var premTotal = 0;
						var minPremAmt = nvl(res.minPremAmt, 0);
						for(var i=0; i<objPerils.length; i++){
							var currRt = 1;
							for(var c=0; c<objGIPIWItem.length; c++){
								if(objPerils[i].itemNo == objGIPIWItem[c].itemNo){
									currRt = nvl(objGIPIWItem[c].currencyRt, 1);
									break;
								}
							}
							premTotal = parseFloat(nvl(premTotal, 0)) + (parseFloat(nvl(objPerils[i].premAmt,0))*parseFloat(currRt));
						}
						if(parseFloat(premTotal) < parseFloat(minPremAmt)){
							showConfirmBox4("Confirmation", "Prem amt PHP "+formatCurrency(premTotal)+" should not be less than PHP "+formatCurrency(minPremAmt)+"."+
									' "Continue" if you want to continue the process.' +
									' "Update" if you want the module to update the prem.' +
									' "Cancel" if you want to manually update the prem.', "Continue", "Update", "Cancel", 
									function(){
										if (!validateUserFunc2("OV", "GIPIS038")){
											showGenericOverride("GIPIS038", "OV", 
												function(ovr, userId, result){
													if(result.toString() == "FALSE"){
														updateMinPremFlag = "N";
														showMessageBox("Invalid User / Password.", "E");
														return false;
													}else{
														updateMinPremFlag = "Y";
														minPremFlag = "1";
														checkIfBinderExists(refresh);
														ovr.close();
													}
												}, 
												function(){
													updateMinPremFlag = "N";
												}
											);
										}else{
											updateMinPremFlag = "Y";
											minPremFlag = "1";
											checkIfBinderExists(refresh);
										}
									},
									function(){
										var minItemNo = 0;
										var minPerilCd = 0;
										var currRt = 1;
										
										minItemNo = parseInt(objGIPIWItem.min(function(item) {
											return nvl(item.recordStatus, 0) != -1 && parseInt(item.itemNo);
										}));
										
										minPerilCd = parseInt(objGIPIWItemPeril.min(function(peril) {
											return nvl(peril.recordStatus, 0) != -1 && parseInt(peril.itemNo) == minItemNo && parseInt(peril.perilCd);
										}));
										
										if(nvl(minPerilCd, 0) == 0 || (isNaN(minPerilCd))){
											var prevItem = 0;
											var currItem = 0;
											
											var objArray = objGIPIWItem.filter(function(o){ return nvl(o.recordStatus, 0) != -1;});
											
											for(var c=0; c<objArray.length; c++){
												if(nvl(prevItem, 0) == 0){
													prevItem = objArray[c].itemNo;
													currItem = objArray[c].itemNo;
												}
												
												if(parseInt(objArray[c].itemNo) <= parseInt(prevItem)){
													prevItem = currItem;
													currItem = objArray[c].itemNo;
												}
											}
											
											minItemNo = currItem;
											
											var prevPeril = 0;
											var currPeril = 0;
											var objItemPeril = objGIPIWItemPeril.filter(function(p){ return nvl(p.recordStatus, 0) != -1 && parseInt(p.itemNo)== minItemNo;});
											
											for(var c=0; c<objItemPeril.length; c++){
												if(nvl(prevPeril, 0) == 0){
													prevPeril = objItemPeril[c].perilCd;
													currPeril = objItemPeril[c].perilCd;
												}
												if(parseInt(objItemPeril[c].perilCd) <= parseInt(prevPeril)){
													prevPeril = currPeril;
													currPeril = objItemPeril[c].perilCd;
												}
											}
											
											minPerilCd = currPeril;
										}
										
										for(var c=0; c<objGIPIWItem.length; c++){
											if(minItemNo == objGIPIWItem[c].itemNo){
												currRt = nvl(objGIPIWItem[c].currencyRt, 1);
												break;
											}
										}
										
										for (var i=0; i<objGIPIWItemPeril.length; i++) {
											if((objGIPIWItemPeril[i].itemNo == minItemNo) && (objGIPIWItemPeril[i].perilCd == minPerilCd)){
												var editedObj = objGIPIWItemPeril[i];
												var newPrem = (parseFloat(minPremAmt) - parseFloat(premTotal)) + (parseFloat(objGIPIWItemPeril[i].premAmt) * parseFloat(currRt)); 
												var premAmt = nvl(newPrem, 0) / nvl(currRt, 1);
												//added by: Nica - to restrict saving premium amount greater than the TSI amount
												if(parseFloat(premAmt) > parseFloat(editedObj.tsiAmt)){
													showMessageBox("Premium must not be greater than TSI amount.", "E");
													updateMinPremFlag = "N";
													return false;
												}
												editedObj.recordStatus = 1;
												editedObj.premAmt = nvl(newPrem, 0) / nvl(currRt, 1);
												objGIPIWItemPeril.splice(i, 1);
												objGIPIWItemPeril.push(editedObj);
												break;
											}
										}
										updateMinPremFlag = "Y";
										minPremFlag = "2";
										checkIfBinderExists(refresh);
									},
									function(){
										updateMinPremFlag = "Y";
										minPremFlag = "3";
									},
									1
							);
						}else{
							updateMinPremFlag = "Y";
							minPremFlag = "";
							checkIfBinderExists(refresh);
						}
					//}else{
					//	updateMinPremFlag = "Y";
					//	minPremFlag = "";
					//	checkIfBinderExists(refresh);
					//}
				}else{
					showMessageBox(response.responseText, "E");
				}
			}	
		});	
	} catch(e){
		showErrorMessage("validatePremiumAmount", e);
	}
}