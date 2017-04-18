function endtDeleteDiscount(){
	// delete_discount
	new Ajax.Request(contextPath + "/GIPIParDiscountController?action=getDeleteDiscountList", {
		method : "GET",
		parameters : {parId : (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"))},
		asynchronous : true,
		evalScripts : true,
		onComplete : function(response){
			if(checkErrorOnResponse(response)){
				var obj = JSON.parse(response.responseText);
				if(obj.length > 0){
					var objList = getItemObjects();
					var recordStatus;
					
					for(var i=0, j=obj.length; i < j; i++){
						for(var x=0, y=objList.length; x < y; x++){
							recordStatus = nvl(objList[x].recordStatus, 0);
							if((recordStatus > -1) && objList[x].itemNo == obj[i].itemNo){
								objList[i].premAmt 		= parseFloat(objList[x].premAmt) + parseFloat(obj[i].discAmt);
								objList[i].annPremAmt 	= nvl(obj[i].origItemAnnPremAmt, objList[i].annPremAmt);
								objList[i].discountSw 	= "N";
								objList[i].recordStatus	= 1;
							}
						}
					}

					for(var i=0, j=obj.length; i < j; i++){
						for(var x=0, y=objGIPIWItemPeril.length; x < y; x++){
							recordStatus = nvl(objGIPIWItemPeril[x].recordStatus, 0);
							if((recordStatus > -1) && (objGIPIWItemPeril[x].itemNo == obj[i].itemNo) && (objGIPIWItemPeril[x].perilCd == obj[i].perilCd)){
								objGIPIWItemPeril[x].premAmt		= parseFloat(objGIPIWItemPeril[x].premAmt) + parseFloat(obj[i].discAmt);
								objGIPIWItemPeril[x].annPremAmt		= nvl(obj[i].origItemAnnPremAmt, objGIPIWItemPeril[x].annPremAmt);
								objGIPIWItemPeril[x].discountSw		= "N";
								objGIPIWItemPeril[x].recordStatus	= 1;
							}
						}
					}										
				}
				delete obj;

				objFormMiscVariables.miscDeletePerilDisc 	= "Y";
				objFormMiscVariables.miscDeleteItemDisc		= "Y";
				objFormMiscVariables.miscDeletePolbasDisc	= "Y";
				
				// update_gipi_wpolbas
				 function updateGipiWpolbas(){
					 new Ajax.Request(contextPath + "/GIPIParInformationController?action=updateGipiWPolbasEndt", {
							method : "GET",
							parameters : {
								parId : (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId")),
								negateItem : objFormVariables.varVNegateItem,
								prorateFlag : objFormVariables.varVProrateFlag,
								compSw : objFormVariables.varCompSw,
								endtExpDate : objFormVariables.varVEndtExpiryDate,
								effDate : objFormVariables.varVEffDate,
								shortRtPct : objFormVariables.varVShortRtPercent,
								expDate : objFormVariables.varVExpiryDate
							},
							asynchronous : true,
							evalScripts : true,
							onComplete : function(response){
								try {
									if(checkErrorOnResponse(response)){								
										var obj = JSON.parse(response.responseText);
										
										if(obj.message == null){													
											objParPolbas.tsiAmt = obj.tsiAmt;
											objParPolbas.premAmt = obj.premAmt;
											objParPolbas.annTsiAmt = obj.annTsiAmt;
											objParPolbas.annPremAmt = obj.annPremAmt;
											
											var objParameters = new Object(); 
											objParameters.setItemRows = getAddedAndModifiedJSONObjects(objGIPIWItem);
											
											new Ajax.Request(contextPath + "/GIPIWItemPerilController?action=getNegateDeleteItem", {
												method : "POST",
												parameters : {
													parId : (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId")),
													params : JSON.stringify(objParameters),
													itemNo : $F("itemNo")
												},
												asynchronous : true,
												evalScripts : true,
												onComplete : function(response){
													if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){ //added checkCustomErrorOnResponse : edgar 01/23/2015
														objMapNegate = JSON.parse(response.responseText); //EDGAR 01/23/2015
														showEndtPerilInfoPage(); //EDGAR 01/23/2015
														showWaitingMessageBox("Deletion has been sucessfully completed. Check peril subpage for information.", imgMessage.INFO, function(){
															globalNegate = "N";
															updateNegated();
														});
														//edgar 01/23/2015 : comment out codes below to correct the flow of negation, transferred in another function
														/*var objMap = JSON.parse(response.responseText);
														var objPerilList = objMap.gipiWItmPerl;
														var objItemList = getItemObjects();
														var recordStatus;
														var bool = false; // andrew - 11.24.2010 - used to check if a peril has been negated or deleted
			
														for(var x=0, y=objItemList.length; x < y; x++){
															recordStatus = nvl(objItemList[x].recordStatus, 0);
															if((recordStatus > -1) && objItemList[x].itemNo == $F("itemNo")){
																objItemList[x].tsiAmt		= objMap.tsiAmt;
																objItemList[x].premAmt 		= objMap.premAmt;
																objItemList[x].annTsiAmt	= objMap.annTsiAmt;
																objItemList[x].annPremAmt 	= objMap.annPremAmt;																		
																objItemList[x].recordStatus	= 1;
																
																$("itemTsiAmt").value 		 = formatCurrency(objMap.tsiAmt);
																$("itemPremiumAmt").value 	 = formatCurrency(objMap.premAmt);
																$("itemAnnPremiumAmt").value = formatCurrency(objMap.annPremAmt);
																$("itemAnnTsiAmt").value 	 = formatCurrency(objMap.annTsiAmt);
															}
														}
														
														if(objPerilList.length > 0){
															/*for(var i=0, j=objPerilList.length; i < j; i++){
																for(var x=0, y=objGIPIWItemPeril.length; x < y; x++){
																	recordStatus = nvl(objGIPIWItemPeril[x].recordStatus, 0);
																	if((recordStatus > -1) && (objGIPIWItemPeril[x].itemNo == $F("itemNo"))){
																		objGIPIWItemPeril[x].lineCd			= objPerilList[i].lineCd;
																		objGIPIWItemPeril[x].perilCd		= objPerilList[i].perilCd;
																		objGIPIWItemPeril[x].discountSw		= objPerilList[i].discountSw;
																		objGIPIWItemPeril[x].premRt			= objPerilList[i].premRt;
																		objGIPIWItemPeril[x].tsiAmt			= objPerilList[i].tsiAmt;
																		objGIPIWItemPeril[x].premAmt		= objPerilList[i].premAmt;
																		objGIPIWItemPeril[x].annTsiAmt		= objPerilList[i].annTsiAmt;
																		objGIPIWItemPeril[x].annPremAmt		= objPerilList[i].annPremAmt;
																		objGIPIWItemPeril[x].prtFlat		= objPerilList[i].prtFlag;
																		objGIPIWItemPeril[x].recFlag		= objPerilList[i].recFlag;
																		objGIPIWItemPeril[x].recordStatus	= 1;															
																		updateNegatedPerilRow(objGIPIWItemPeril[x]); // andrew - 11.23.2010 - added this line to update the peril html row
																		bool = true;															
																	}
																}
															}*/
															/*for(var i=0; i<objPerilList.length; i++){
																//if(objPerilList[i].itemNo == $F("itemNo")){ //commented out edgar 10/29/2014
																    objGIPIWItemPeril[i].itemNo			= objPerilList[i].itemNo; //added edgar 10/29/2014
																    objGIPIWItemPeril[i].lineCd			= objPerilList[i].lineCd;
																	objGIPIWItemPeril[i].perilCd		= objPerilList[i].perilCd;
																	objGIPIWItemPeril[i].discountSw		= objPerilList[i].discountSw;
																	objGIPIWItemPeril[i].premRt			= objPerilList[i].premRt;
																	objGIPIWItemPeril[i].tsiAmt			= objPerilList[i].tsiAmt;
																	objGIPIWItemPeril[i].premAmt		= objPerilList[i].premAmt;
																	objGIPIWItemPeril[i].annTsiAmt		= objPerilList[i].annTsiAmt;
																	objGIPIWItemPeril[i].annPremAmt		= objPerilList[i].annPremAmt;
																	objGIPIWItemPeril[i].prtFlat		= objPerilList[i].prtFlag;
																	objGIPIWItemPeril[i].recFlag		= objPerilList[i].recFlag;
																	objGIPIWItemPeril[i].riCommRate		= objPerilList[i].riCommRate; //edgar 10/21/2014
																	if(objPerilList[i].riCommRate == null || objPerilList[i].riCommRate == ""){
																		objGIPIWItemPeril[i].riCommAmt		= null;
																	}else{
																		objGIPIWItemPeril[i].riCommAmt		= formatCurrency(objPerilList[i].premAmt*(objGIPIWItemPeril[i].riCommRate/100)); // edgar 10/01/2014 for recomputation of ri_comm_amt
																	}
																	objGIPIWItemPeril[i].recordStatus	= 0;															
																	updateNegatedPerilRow(objGIPIWItemPeril[i]); // andrew - 11.23.2010 - added this line to update the peril html row
																	bool = true;															
																//} //commented out edgar 10/29/2014
															}
														}else{
															for(var i=0, length=objGIPIWItemPeril.length; i < length; i++){
																if(objGIPIWItemPeril[i].itemNo == $F("itemNo")){														
																	var rowEndtPeril;
																	addDeletedJSONObject(objGIPIWItemPeril, objGIPIWItemPeril[i]);
																	rowEndtPeril = $("rowEndtPeril" + objGIPIWItemPeril[i].itemNo + objGIPIWItemPeril[i].perilCd);
																	Effect.Fade(rowEndtPeril, {
																		duration: .5,
																		afterFinish: function () {
																			rowEndtPeril.remove();
																			checkTableIfEmpty2("rowEndtPeril", "endtPerilTable");
																			checkIfToResizeTable2("perilTableContainerDiv", "rowEndtPeril");																
																			setEndtPerilForm(null);
																			setEndtPerilFields(null);
																		}
																	});		
																	bool = true;
																}													
															}
														}																											
														
														//if (bool) { // andrew - 11.24.2010 - added this 'if' block to show the updates on item values
															//setEndtItemAmounts($F("itemNo"), objGIPIWItemPeril, objGIPIItemPeril);
														//}
														
														delete objMap, objPerilList;														
				
														showMessageBox("Deletion has been sucessfully completed. Check peril subpage for information.", imgMessage.INFO);
														
														/*var gro = $("perilInformationDiv").previous("div").down("div").down("span").down("label");
														if(gro.innerHTML == "Show") {
															fireEvent(gro, "click");
														}*/
														//$("itemTsiAmt").scrollTo();
													}
												}
											});
										}else{
											showMessageBox(obj.message, imgMessage.ERROR);
										}
										delete obj;
									}
								} catch(e){
									showErrorMessage("endtDeleteDiscount - onComplete 2", e);
								}
							}
						});
				 }
				
				setTimeout(function(){updateGipiWpolbas();}, 500); //delay function to take effect -jeffdojello 11.18.2013
			}								
		}
	});
}