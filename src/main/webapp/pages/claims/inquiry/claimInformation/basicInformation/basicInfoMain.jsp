<div id="basicInfoDiv1" class="sectionDiv" style="border: 0;">
	<table border="0" style="margin-top: 10px; margin-bottom: 10px; margin-left: 8px; width: 100%;">
		<tr>
			<td class="rightAligned" style="width: 100px;"></td>
			<td class="leftAligned"></td>
			<td style="width: 100px;"></td>
			<td class="leftAligned">
				<input type="checkbox" id="chkLossRecovery" style="float: left;" value="" readonly="readonly" disabled="disabled"><label style="float: left; width: 130px; text-align: left; margin-top: 0px; margin-left: 4px;">Loss Recovery</label></input>
				<input type="checkbox" id="chkPackPol" style="float: left;" readonly="readonly" disabled="disabled">
				<label style="float: left; width: 100px; text-align: left; margin-top: 0px; margin-left: 4px;">Package Policy</label></input>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 100px;"></td>
			<td class="leftAligned"></td>
			<td style="width: 100px;"></td>
			<td class="leftAligned">
				<input type="checkbox" id="chkOkProcessing" style="float: left;" value="" readonly="readonly" disabled="disabled">
					<label style="float: left; width: 130px; text-align: left; margin-top: 0px; margin-left: 4px;">Ok for Processing</label></input>
				<input type="checkbox" id="chkTotalLoss" style="float: left;" value="" readonly="readonly" disabled="disabled">
					<label style="float: left; width: 100px; text-align: left; margin-top: 0px; margin-left: 4px;">Total Loss</label> </input>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Effectivity Date</td>
			<td class="leftAligned">
				<input id="txtEffectivityDate" name="txtEffectivityDate" type="text" style="width: 315px;" value="" readonly="readonly"/>
			</td>
			<td class="rightAligned" id="lblPlateNumber">Plate Number</td>
			<td class="leftAligned">
				<input id="txtPlateNumber" name="txtPlateNumber" type="text" style="width: 315px;" value="" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Expiry Date</td>
			<td class="leftAligned">
				<input id="txtExpiryDate" name="txtExpiryDate" type="text" style="width: 315px;" value="" readonly="readonly"/>
			</td>
			<td class="rightAligned">Loss Description</td>
			<td class="leftAligned">
				<input id="txtLossCatCd"   name="txtLossCatCd"   type="text" style="width: 70px;"  value="" readonly="readonly"/>
				<input id="txtLossCatDesc" name="txtLossCatDesc" type="text" style="width: 233px;" value="" readonly="readonly" />
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Loss Date</td>
			<td class="leftAligned">
				<input style="float: left; width: 134px;" id="txtDspLossDate" name="txtDspLossDate" type="text" value="" readonly="readonly" />
				<label style="float: left; width: 50px; text-align: right; margin-top: 6px; margin-right: 8px;">Time</label>
				<input type="text" id="txtLossTime" name="txtLossTime" value="" style="width: 115px; float: left;" readonly="readonly" >
			</td>
			<td class="rightAligned">Loss Details</td>
			<td class="leftAligned">
				<input id="txtLossDetails" name="txtLossDetails" type="text" style="width: 315px;" value="" readonly="readonly" />
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Claim Processor</td>
			<td class="leftAligned">
				<input id="txtInHouAdj" 	name="txtInHouAdj" 	   type="text" style="width: 70px;"  value="" readonly="readonly"/>
				<input id="txtInHouAdjName" name="txtInHouAdjName" type="text" style="width: 233px;" value="" readonly="readonly" />
			</td>
			<td class="rightAligned">Location of Loss</td>
			<td class="leftAligned">
				<input id="txtLocOfLoss1" name="txtLocOfLoss1" type="text" style="width: 315px;" value="" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Date Filed</td>
			<td class="leftAligned">
				<input id="txtClmFileDate" name="txtClmFileDate" type="text" style="width: 315px;" value="" readonly="readonly"/>
			</td>
			<td class="rightAligned"></td>
			<td class="leftAligned">
				<input id="txtLocOfLoss2" name="txtLocOfLoss2" type="text" style="width: 315px;" value="" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Cedant</td>
			<td class="leftAligned">
				<input id="txtRiCd" 		name="txtRiCd" 	   	type="text" style="width: 70px;"  value="" readonly="readonly"/>
				<input id="txtRiName" 		name="txtRiName" 	type="text" style="width: 233px;" value="" readonly="readonly" />
			</td>
			<td class="rightAligned"></td>
			<td class="leftAligned">
				<input id="txtLocOfLoss3" name="txtLocOfLoss3" type="text" style="width: 315px;" value="" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">CAT Code</td>
			<td class="leftAligned">
				<input id="txtCatCd" 		name="txtCatCd" 	type="text" style="width: 70px;"  value="" readonly="readonly"/>
				<input id="txtCatDesc" 		name="txtCatDesc" 	type="text" style="width: 233px;" value="" readonly="readonly" />
			</td>
			<td class="rightAligned">Claim Status</td>
			<td class="leftAligned">
				<input id="txtClmStatCd"   name="txtClmStatCd" 	 type="text" style="width: 70px;" value="" readonly="readonly"/>
				<input id="txtClmStatDesc" name="txtClmStatDesc" type="text" style="width: 233px;" value="" readonly="readonly" />
			</td>
		</tr>
		<tr>
			<td class="rightAligned"></td>
				<td class="leftAligned">
					<input id="txtUnpaidPremium" name="txtUnpaidPremium" type="text" style="width: 315px; text-align: center;" value="" readonly="readonly"/>
			</td>
			<td class="rightAligned">User ID</td>
			<td class="leftAligned">
				<input style="float: left; width: 70px;" id="txtUserId" name="txtUserId" type="text" value="" readonly="readonly" />
				<label style="float: left; width: 80px; text-align: right; margin-top: 6px; margin-right: 8px;">Last Update</label>
				<input type="text" id="txtLastUpdate" name="txtLastUpdate" value="" style="width: 148px; float: left;" readonly="readonly" >
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Remarks</td>
			<td class="leftAligned">
				<div style="float:left; width: 320px;" class="withIconDiv">
					<textarea class="withIcon" id="txtRemarks" name="txtRemarks" style="width: 290px; resize:none;" readonly="readonly"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editTxtRemarks" />
				</div>
			</td>
			<td class="rightAligned">Crediting Branch</td>
			<td class="leftAligned">
				<input id="txtCredBranchCd"   name="txtCredBranchCd"   type="text" style="width: 70px;" value=""  readonly="readonly"/>
				<input id="txtCredBranchName" name="txtCredBranchName" type="text" style="width: 233px;" value="" readonly="readonly" />
			</td>
		</tr>
		<tr>
			<td class="rightAligned" id="lblOpNumber">OP Number</td>
			<td class="leftAligned">
				<input id="txtOpNumber" name="txtOpNumber" type="text" style="width: 315px;" value="" readonly="readonly"/>
			</td>
			<td class="rightAligned" id="lblCloseDate">Close Date</td>
			<td class="leftAligned">
				<input id="txtCloseDate" name="txtCloseDate" type="text" style="width: 315px;" value="" readonly="readonly"/>
			</td>
		</tr>
	</table>
</div>
<div id="basicInfoDiv2" class="sectionDiv" style="border-bottom: 0; border-left: 0; border-right: 0; padding: 10px 0px;">
	<table cellspacing="2" border="0" style="margin: auto;">
		<tr>
			<td class="rightAligned">Loss Reserve</td>
			<td class="leftAligned">
				<input id="txtLossResAmt" name="txtLossResAmt" type="text" class="money" style="width: 230px;" value="" readonly="readonly" />
			</td>
			<td class="rightAligned" style="width: 120px;">Loss Paid</td>
			<td class="leftAligned" style="width: 230px;">
				<input id="txtLossPdAmt" style="width: 230px;" type="text" class="money" value="" readonly="readonly" />
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Expense Reserve</td>
			<td class="leftAligned">
				<input id="txtExpResAmt" name="txtExpResAmt" type="text" class="money" style="width: 230px;" value="" readonly="readonly" />
			</td>
			<td class="rightAligned" style="width: 120px;">Expense</td>
			<td class="leftAligned" style="width: 230px;">
				<input id="txtExpPdAmt" style="width: 230px;" type="text" class="money" value="" readonly="readonly" />
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Entry Date</td>
			<td class="leftAligned">
				<input id="txtEntryDate" name="txtEntryDate" type="text" style="width: 230px;" value="" readonly="readonly" />
			</td>
			<td class="rightAligned" style="width: 120px;">Date Settled</td>
			<td class="leftAligned" style="width: 230px;">
				<input id="txtClmSetlDate" style="width: 230px;" type="text" value="" readonly="readonly" />
			</td>
		</tr>
	</table>
	<table align="center" cellpadding="1" style="margin-top: 15px;">
		<tr>
			<td><input type="button" id="btnProcessorHist"	name="btnProcessorHist"    style="width: 130px;" class="button"	value="Processor History" /></td>
			<td><input type="button" id="btnClaimStatHist"	name="btnClaimStatHist"    style="width: 150px;" class="button"	value="Claim Status History" /></td>
			<td><input type="button" id="btnAdjuster"		name="btnAdjuster"   	   style="width: 130px;" class="button"	value="Adjuster" /></td>
			<td><input type="button" id="btnSettSurvAgent"	name="btnSettSurvAgent"    style="width: 150px;" class="disabledButton"	value="Settling/Survey Agent" /></td>
		</tr>
		<tr>
			<td><input type="button" id="btnIntermediaries" name="btnIntermediaries"   style="width: 130px;" class="disabledButton"	value="Intermediaries" /></td>
			<td><input type="button" id="btnBondPolicyData" name="btnBondPolicyData"   style="width: 150px;" class="disabledButton"	value="Bond Policy Data" /></td>
			<td><input type="button" id="btnMortgagee" 		name="btnMortgagee"   	   style="width: 130px;" class="disabledButton"	value="Mortgagee" /></td>
			<td><input type="button" id="btnRecoveryAmts" 	name="btnRecoveryAmts" 	   style="width: 150px;" class="disabledButton"	value="Recovery Amounts" /></td>
		</tr>
	</table>
</div>

<script type="text/javascript">

	function showPopupBasicInfoListing(action1,title,width,height){
		var contentDiv = new Element("div", {id : "modal_content_lov"});
	    var contentHTML = '<div id="modal_content_lov"></div>';
	    overlayPopupGrid = Overlay.show(contentHTML, {
							id: 'modal_dialog_lov',
							title: nvl(title,""),
							width: nvl(width,600),
							height: nvl(height,300),
							draggable: false,
							closable: false
						});
	    
	    new Ajax.Updater("modal_content_lov", contextPath+"/GICLClaimsController?action=showGICLS260TableGridPopup", {
			evalScripts: true,
			asynchronous: false,
			parameters:{
				action1: action1,
				claimId: objCLMGlobal.claimId,
				itemNo: 0,
				ajax: 1
			},
			onCreate: function(){
				showNotice("Loading, please wait...");
			},
			onComplete: function (response) {			
				hideNotice();
				if (!checkErrorOnResponse(response)) {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}
	
	//Processor History
	$("btnProcessorHist").observe("click", function () {
		showPopupBasicInfoListing("getProcessorHistTableGridListing", "Processor History");
	});
	
	//Claim Status History
	$("btnClaimStatHist").observe("click", function () {
		showPopupBasicInfoListing("getStatHistTableGridListing", "Claim Status History");
	});
	
	//Adjuster
	$("btnAdjuster").observe("click", function () {
		showPopupBasicInfoListing("getClmAdjusterListing", "Claim Adjuster", 780);
	});
	
	//Settling/Survey Agent
	$("btnSettSurvAgent").observe("click", function () {
		overlaySettSurvAgent = Overlay.show(contextPath+"/GICLClaimsController", {
			urlContent: true,
			urlParameters: {action : "showGicls260SurveySettlingAgent",
							claimId : objCLMGlobal.claimId},
			title: "Settling/Survey Agents",	
			id: "survey_settling_canvas",
			width: 625,
			height: 120,
			showNotice: true,
		    draggable: false,
		    closable: true
		});
	});

	//Intermediary
	$("btnIntermediaries").observe("click", function () {
		showPopupBasicInfoListing("getBasicIntmDtls", "Intermediary");
	});
	
	//Bond Policy Data - reuse page in Claim Basic Info
	$("btnBondPolicyData").observe("click", function () {
		overlayBondPol = Overlay.show(contextPath+"/GIPIBondBasicController", {
			urlContent: true,
			urlParameters: {action : 	"showBondPolicyData", 
							lineCd: 	objCLMGlobal.lineCode,
							sublineCd: 	objCLMGlobal.sublineCd,
							polIssCd: 	objCLMGlobal.policyIssueCode,
							issueYy: 	objCLMGlobal.issueYy,
							polSeqNo: 	objCLMGlobal.policySequenceNo,
							renewNo: 	objCLMGlobal.renewNo,
							lossDate: 	setDfltSec(objCLMGlobal.strLossDate),
							expiryDate: setDfltSec(objCLMGlobal.strExpiryDate),
							polEffDate: setDfltSec(objCLMGlobal.strPolicyEffectivityDate)
							},
			title: "Bond Policy Data",	
			id: "bond_policy_data_view",
			width: 790,
			height: 345,
			showNotice: true,
		    draggable: false,
		    closable: true
		});	
	});
	
	//Mortgagee
	$("btnMortgagee").observe("click", function () {
		showPopupBasicInfoListing("getGiclMortgageeGrid", "Mortgagee");
	});
	
	//Recovery Amounts
	$("btnRecoveryAmts").observe("click", function () {
		overlayRecoveryAmts = Overlay.show(contextPath+"/GICLClaimsController", {
			urlContent: true,
			urlParameters: {action : "getGicls260RecoveryAmts",
							claimId : objCLMGlobal.claimId},
			title: "Recovery Amounts",	
			id: "recovery_amts_canvas",
			width: 335,
			height: 130,
			showNotice: true,
		    draggable: false,
		    closable: true
		});
	});
	
</script>
