function getEvalPolInfo(sublineCd,issCd,clmYy,clmSeqNo){
	try{
		mcMainObj = {};
		new Ajax.Request(contextPath + "/GICLMcEvaluationController?action=getPolInfo",{
			method : "GET",
			parameters : {
				sublineCd : sublineCd,
				issCd : issCd,
				clmYy : clmYy,
				clmSeqNo : clmSeqNo
			},					
			asynchronous : false,
			evalScripts : true,
			onCreate: function() {
				// showNotice("Validating Transaction Type. Please wait...");
			},
			onComplete : function(response){
				if (checkErrorOnResponse(response)) {
					var result = response.responseText;
					
					function proceedNewEval(){
						new Ajax.Request(contextPath + "/GICLMcEvaluationController", {
							parameters:{
								action: "popGiclMcEval",
								claimId :objCLMGlobal.claimId,
								sublineCd: objCLMGlobal.sublineCd,
								issCd :objCLMGlobal.issueCd,
								clmYy : objCLMGlobal.claimYy,
								clmSeqNo: objCLMGlobal.claimSequenceNo
							},
							asynchronous: false,
							evalScripts: true,
							onCreate: showNotice("Please wait.."),
							onComplete: function(response){
								hideNotice("");
								if(checkErrorOnResponse(response)) {
									//var res = response.responseText.toQueryParams();
									var res = JSON.parse(response.responseText);
									if(nvl(res.message,"") == ""){
										mcMainObj = {};
										mcMainObj.claimId = objCLMGlobal.claimId;
										mcMainObj.lineCd = objCLMGlobal.lineCode;
										mcMainObj.sublineCd = objCLMGlobal.sublineCd;
										mcMainObj.clmYy = objCLMGlobal.claimYy;
										mcMainObj.clmSeqNo = objCLMGlobal.claimSequenceNo;
										mcMainObj.issCd = objCLMGlobal.issueCd;
										mcMainObj.polRenewNo = objCLMGlobal.renewNo;
										mcMainObj.polIssueYy = objCLMGlobal.issueYy;
										mcMainObj.polIssCd = objCLMGlobal.polIssCd;
										mcMainObj.polSeqNo = objCLMGlobal.polSeqNo;
										mcMainObj.lossDate = objCLMGlobal.strDspLossDate2;
										// get items from popGiclMcEval, for new eval
										$("dspPayee").value = unescapeHTML2(res.dspPayee);
										$("dspCurrShortname").value = unescapeHTML2(res.dspCurrShortname);
										$("currencyRate").value = formatCurrency(res.currencyRate);
										$("dspAdjusterDesc").value = unescapeHTML2(res.dspAdjusterDesc);
										$("clmAdjId").value = res.adjusterId;
										//$("textItemDesc").value = unescapeHTML2(res.dspItemDesc); commented out by robert 
										mcMainObj.dspItemDesc = res.dspItemDesc;
										mcMainObj.currencyCd = res.currencyCd;
										mcMainObj.currencyRate = res.currencyRate;
										mcMainObj.dspCurrShortname = res.dspCurrShortname;
										mcMainObj.tpSw = res.tpSw;
										if(res.allowPlateNo != "Y"){ // it means multiple items because of third party details - irwin
											mcMainObj.itemNo = res.itemNo;
											mcMainObj.plateNo = res.plateNo;
											mcMainObj.perilCd = res.perilCd;
											mcMainObj.dspPerilDesc = res.dspPerilDesc;
										}
										
										if(res.allowPerilCd == "Y"){ // multiple perils
											mcMainObj.perilCd = "";
											mcMainObj.dspPerilDesc = "";
										}
										mcMainObj.assuredName = res.assuredName;
										mcMainObj.annTsiAmt = res.annTsiAmt;
										mcMainObj.payeeClassCd = "";
										mcMainObj.payeeNo = "";
										/////
										mcMainObj.claimFileDate = objCLMGlobal.claimFileDate;
										mcMainObj.assuredName = objCLMGlobal.assuredName; //added by robert
										populatePolicyFields(mcMainObj);
										mcMainObj.polLineCd = $F("txtLineCd");
										mcMainObj.polSublineCd = $F("txtSublineCd");
										varInitialSave = "Y";
										enableButton("btnSave");
										
										$("dspCurrShortname").value = nvl(mcMainObj.dspCurrShortname,"");
										$("currencyRate").value = nvl(mcMainObj.currencyRate,"");
										$("newRepFlag").value = "Y";
										toggleEditableOtherDetails(true);
										changeTag =1;
										varMcMainObj.plateNo = mcMainObj.plateNo; // holds orig values of mcMainObj for masterBlk key commit
										varMcMainObj.itemNo = mcMainObj.itemNo;
										varMcMainObj.perilCd = mcMainObj.perilCd;
										varMcMainObj.tpSw = mcMainObj.tpSw;
										varMcMainObj.payeeClassCd = "";
										varMcMainObj.payeeNo = "";
										
										
										if(res.allowPerilCd == "Y"){
											enableSearch("txtPerilCdIcon");
										}else{
											disableSearch("txtPerilCdIcon");
										}
										if(res.allowAdjuster == "Y"){
											enableSearch("dspAdjusterDescIcon");
										}else{
											disableSearch("dspAdjusterDescIcon");
										}
										if(res.allowPlateNo == "Y"){
											enableSearch("txtPlateNoIcon");
										}else{
											disableSearch("txtPlateNoIcon");
										}
										
										changeTag =1;
									}else{
										toggleEditableOtherDetails(false);
										showMessageBox(res.message, "I");
									}
									getMcEvalItemTG(mcMainObj); //added by robert SR 13629
									//getMcEvaluationTG(mcMainObj); --changed to null by robert SR 13629
									getMcEvaluationTG(null); 
							
								}else{
									showMessageBox(response.responseText, "E");
								}
							}
						});
					}
					
					if( result == "No Evaluation Record Existing."){
						
						clearPolicyInfoFields(true);
						mcMainObj = {};
						if(mcEvalFromItemInfo == "Y"){
							proceedNewEval();
						}else{
							/*showMessageBox(result, imgMessage.INFO);
							getMcEvaluationTG(mcMainObj);
							toggleEditableOtherDetails(false);
							populateEvalSumFields(null);
							populateOtherDetailsFields(null);
							disableButton("btnAddReport");
							disableButton("btnSave");*/ // replaced by: Nica 1.26.2013
							new Ajax.Request(contextPath + "/GICLMcEvaluationController", {
								parameters:{
									action: "popGiclMcEval",
									claimId : "",
									sublineCd: sublineCd,
									issCd : issCd,
									clmYy : clmYy,
									clmSeqNo: clmSeqNo
								},
								asynchronous: false,
								evalScripts: true,
								onComplete: function(response){
									hideNotice();
									var res = JSON.parse(response.responseText);
									if(nvl(res.message, "") != ""){
										showMessageBox(res.message, "E");
									}else{
										objCLMGlobal.claimId = res.claimId;
										updateClaimParameters(function(){
											mcMainObj = {};
											mcMainObj.claimId = objCLMGlobal.claimId;
											mcMainObj.lineCd = objCLMGlobal.lineCode;
											mcMainObj.sublineCd = objCLMGlobal.sublineCd;
											mcMainObj.clmYy = objCLMGlobal.claimYy;
											mcMainObj.clmSeqNo = objCLMGlobal.claimSequenceNo;
											mcMainObj.issCd = objCLMGlobal.issueCd;
											mcMainObj.polRenewNo = objCLMGlobal.renewNo;
											mcMainObj.polIssueYy = objCLMGlobal.issueYy;
											//mcMainObj.polIssCd = objCLMGlobal.polIssCd; changed by robert in case objCLMGlobal.polIssCd is null 
											if(objCLMGlobal.polIssCd){
												mcMainObj.polIssCd = objCLMGlobal.polIssCd; 
											}else{
												objCLMGlobal.polIssCd = res.polIssCd;
												mcMainObj.polIssCd = objCLMGlobal.polIssCd; 
											}
											mcMainObj.polSeqNo = objCLMGlobal.polSeqNo;
											mcMainObj.lossDate = objCLMGlobal.strDspLossDate2;
											// get items from popGiclMcEval, for new eval
											$("dspPayee").value = unescapeHTML2(res.dspPayee);
											$("dspCurrShortname").value = unescapeHTML2(res.dspCurrShortname);
											$("currencyRate").value = formatCurrency(res.currencyRate);
											$("dspAdjusterDesc").value = unescapeHTML2(res.dspAdjusterDesc);
											$("clmAdjId").value = res.adjusterId;
											//$("textItemDesc").value = unescapeHTML2(res.dspItemDesc); commented out by robert
											mcMainObj.dspItemDesc = res.dspItemDesc;
											mcMainObj.currencyCd = res.currencyCd;
											mcMainObj.currencyRate = res.currencyRate;
											mcMainObj.dspCurrShortname = res.dspCurrShortname;
											mcMainObj.tpSw = res.tpSw;
											if(res.allowPlateNo != "Y"){ // it means multiple items because of third party details - irwin
												mcMainObj.itemNo = res.itemNo;
												mcMainObj.plateNo = res.plateNo;
												mcMainObj.perilCd = res.perilCd;
												mcMainObj.dspPerilDesc = res.dspPerilDesc;
											}
											
											if(res.allowPerilCd == "Y"){ // multiple perils
												mcMainObj.perilCd = "";
												mcMainObj.dspPerilDesc = "";
											}
											mcMainObj.assuredName = res.assuredName;
											mcMainObj.annTsiAmt = res.annTsiAmt;
											mcMainObj.payeeClassCd = "";
											mcMainObj.payeeNo = "";
											/////
											mcMainObj.claimFileDate = objCLMGlobal.claimFileDate;
											
											populatePolicyFields(mcMainObj);
											mcMainObj.polLineCd = $F("txtLineCd");
											mcMainObj.polSublineCd = $F("txtSublineCd");
											varInitialSave = "Y";
											enableButton("btnSave");
											
											$("dspCurrShortname").value = nvl(mcMainObj.dspCurrShortname,"");
											$("currencyRate").value = nvl(mcMainObj.currencyRate,"");
											$("newRepFlag").value = "Y";
											toggleEditableOtherDetails(true);
											changeTag =1;
											varMcMainObj.plateNo = mcMainObj.plateNo; // holds orig values of mcMainObj for masterBlk key commit
											varMcMainObj.itemNo = mcMainObj.itemNo;
											varMcMainObj.perilCd = mcMainObj.perilCd;
											varMcMainObj.tpSw = mcMainObj.tpSw;
											varMcMainObj.payeeClassCd = "";
											varMcMainObj.payeeNo = "";
											
											
											if(res.allowPerilCd == "Y"){
												enableSearch("txtPerilCdIcon");
											}else{
												disableSearch("txtPerilCdIcon");
											}
											if(res.allowAdjuster == "Y"){
												enableSearch("dspAdjusterDescIcon");
											}else{
												disableSearch("dspAdjusterDescIcon");
											}
											if(res.allowPlateNo == "Y"){
												enableSearch("txtPlateNoIcon");
											}else{
												disableSearch("txtPlateNoIcon");
											}
											
											changeTag =1;
										});
									}
								}
							});	
						}
					}else{
						mcMainObj = JSON.parse(result);
						populatePolicyFields(mcMainObj);
						mcMainObj.polLineCd = $F("txtLineCd");
						mcMainObj.polSublineCd = $F("txtSublineCd");
						enableButton("btnAddReport");
						//enableButton("btnSave");
						varMcMainObj.plateNo = mcMainObj.plateNo; // holds orig values of mcMainObj for masterBlk key commit
						varMcMainObj.itemNo = mcMainObj.itemNo;
						varMcMainObj.perilCd = mcMainObj.perilCd;
						varMcMainObj.tpSw = mcMainObj.tpSw;
						varMcMainObj.payeeClassCd = mcMainObj.payeeClassCd;
						varMcMainObj.payeeNo = mcMainObj.payeeNo;
						toggleEditableOtherDetails(false);
						getMcEvalItemTG(mcMainObj); //added by robert SR 13629
						//getMcEvaluationTG(mcMainObj); --changed to null by robert SR 13629
						getMcEvaluationTG(null); 
						populateEvalSumFields(null);
						populateOtherDetailsFields(null);
						changeTag = 0;
					}
					
					
					/*
					if( result == "No Evaluation Record Existing."){
						showMessageBox(result, imgMessage.INFO);
						clearPolicyInfoFields(true);
						mcMainObj = {};
						if(mcEvalFromItemInfo == "Y"){
							proceedNewEval();
						}else{
							getMcEvaluationTG(mcMainObj);
							toggleEditableOtherDetails(false);
							populateEvalSumFields(null);
							populateOtherDetailsFields(null);
							disableButton("btnAddReport");
							disableButton("btnSave");
						}
					}else{
						mcMainObj = result.toQueryParams();
						populatePolicyFields(mcMainObj);
						mcMainObj.polLineCd = $F("txtLineCd");
						mcMainObj.polSublineCd = $F("txtSublineCd");
						enableButton("btnAddReport");
						//enableButton("btnSave");
						
						toggleEditableOtherDetails(false);
						getMcEvaluationTG(mcMainObj);
						populateEvalSumFields(null);
						populateOtherDetailsFields(null);
					}*/
					
					
				} else {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}catch(e){
		showErrorMessage("getEvalPolInfo",e);
	}
}