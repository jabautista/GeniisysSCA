/**

 * MC EVALuATION FUNCTIONS
 * @author Irwin Tabisora
 * @description Functions for MC Evaluation module GICLS070
 */

var mcMainObj = {};
var varMcMainObj = {};
var selectedMcEvalObj = {};
var variablesObj= {};
var addReportOverlay;
var tempArrForPrint = [];
var tempArrForGenerate = [];
var hasSaved = ""; // variable to check if the overlay modules has been modified and saved.
var mcEvalFromItemInfo ="";
var varInitialSave;
var mcEvalGrid;

/**
 * Replace Details
 * */
var selectedReplaceDetObj;
var changePayeeOverlay;

/**END OF REPLACE DETAILS*/

/**REPAIR DETAILS*/
var giclRepairObj;
var repairGrid; 
var repairGridSelectedIndex;
var objGICLReplaceLpsDtlArr = [];
var objGICLReplaceLpsDtlDelRows = [];
var otherLaborOverlay;
var hasSavedLabor;

/**
 * DEDUCTIBLE DETAILS
 * 
 */
var objGICLEvalDeductiblesArr = [];
var objGICLEvalDeductiblesReplaceRows = [];
var applyDedOverlay;
/**END OF DEDUCTIBLE DETAILS**/

/***/

/**DEPRECIATION DETAILS/
 * */
var giclEvalDepDtlTGArrObj;
var depreciationGrid;
var selectedDepIndex;
var prevDedRt;
var prevDedAmt;
/***end of depreciation details*/

/**
 *  VAT DETAILS
 * */
var vatGrid;
var giclEvalVatDtlTGArrObj = [];
var selectedVatIndex;
/***END OF VAT DETAILS*/

/// not used 
/**
 * @deprecated
 * */
function popGiclMcEval(claimId, sublineCd, issCd, clmYy, clmSeqNo){
	try{
		new Ajax.Request(contextPath + "/GICLMcEvaluationController", {
			parameters:{
				action: "popGiclMcEval",
				claimId :claimId,
				sublineCd: sublineCd,
				issCd :issCd,
				clmYy : clmYy,
				clmSeqNo : clmSeqNo,
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: showNotice("Please wait.."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)) {
					res = response.responseText.toQueryParams(); 
					
					if(res.message ==""){
						if( res.evalExist == "N"){
							showMessageBox("No Evaluation Record Existing", imgMessage.INFO);
							clearPolicyInfoFields(true);
							mcMainObj = {};
							if(mcEvalFromItemInfo == "Y"){
								mcMainObj.claimId = objCLMGlobal.claimId;
								mcMainObj.lineCd = objCLMGlobal.lineCode;
								mcMainObj.sublineCd = objCLMGlobal.sublineCd;
								mcMainObj.clmYy = objCLMGlobal.claimYy;
								mcMainObj.clmSeqNo = objCLMGlobal.claimSequenceNo;
								mcMainObj.issCd = objCLMGlobal.issueCd;
								
								mcMainObj.polRenewNo = objCLMGlobal.polRenewNo;
								mcMainObj.polIssueYy = objCLMGlobal.polIssueYy;
								mcMainObj.polIssCd = objCLMGlobal.polIssCd;
								mcMainObj.polSeqNo = objCLMGlobal.polSeqNo;
								mcMainObj.lossDate = objCLMGlobal.strDspLossDate2;
								
								// get items from popGiclMcEval, for new eval
								$("dspPayee").value = unescapeHTML2(res.dspPayee);
								$("dspCurrShortname").value = unescapeHTML2(res.dspCurrShortname);
								$("currencyRate").value = formatCurrency(res.currencyRate);
								$("dspAdjusterDesc").value = unescapeHTML2(res.dspAdjusterDesc);
								$("clmAdjId").value = res.adjusterId;
								mcMainObj.currencyCd = res.currencyCd;
								mcMainObj.currencyRate = res.currencyRate;
								mcMainObj.dspCurrShortname = res.dspCurrShortname;
								mcMainObj.perilCd = res.perilCd;
								mcMainObj.dspPerilDesc = res.dspPerilDesc;
								mcMainObj.tpSw = res.tpSw;
								mcMainObj.itemNo = res.itemNo;
								mcMainObj.plateNo = res.plateNo;
								mcMainObj.assuredName = res.assuredName;
								mcMainObj.annTsiAmt = res.annTsiAmt;
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
							}else{
								getMcEvaluationTG(mcMainObj);
								toggleEditableOtherDetails(false);
								populateEvalSumFields(null);
								populateOtherDetailsFields(null);
								disableButton("btnAddReport");
								disableButton("btnSave");
							}
						}else{
							mcMainObj = res.toQueryParams();
							populatePolicyFields(mcMainObj);
							mcMainObj.polLineCd = $F("txtLineCd");
							mcMainObj.polSublineCd = $F("txtSublineCd");
							enableButton("btnAddReport");
							enableButton("btnSave");
							
							toggleEditableOtherDetails(false);
							getMcEvaluationTG(mcMainObj);
							populateEvalSumFields(null);
							populateOtherDetailsFields(null);
						}
						

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
							//enableSearch("txtPerilCdIcon");
						}else{
						//	disableSearch("txtPerilCdIcon");
						}
					}else{
						showMessageBox(res.message, "I");
						getMcEvaluationTG(mcMainObj);
						toggleEditableOtherDetails(false);
						populateEvalSumFields(null);
						populateOtherDetailsFields(null);
						disableButton("btnAddReport");
						disableButton("btnSave");
						
					}
					
					
					
				}else{
					showMessageBox(response.responseText, "E");
				}
			}
		});
		
	}catch(e){
		showErrorMessage("popGiclMcEval",e);
	}
}

/**end of mc eval report*/