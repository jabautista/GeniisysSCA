<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-chache");
	response.setHeader("Pragma","no-cache");
%>
<div id="genRecoveryAccEntMainDiv" style="float: left;">
	<div id="genRecoveryAccEntMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="createNewRecoveryAccEnt">Create New</a></li>
					<li><a id="genRecoveryExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Generate Accounting Entries - Loss Recovery</label>
			<span class="refreshers" style="margin-top: 0;">
				<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
		</div>
	</div>
	<div id="recoveryAccEntDiv">
		<div style="padding-top: 15px; padding-bottom: 15px; width: 100%; float: left;" class="sectionDiv">
			<table align="center" border="0">
				<tr>
					<td class="rightAligned">Recovery Acct No. </td>
					<td class="leftAligned" width="32%">
						<input type="text" id="recoveryAcctNo" name="recoveryAcctNo" readonly="readonly" value="" style="width: 200px;" />
						
						<input type="hidden" id="hidClaimId" name="hidClaimId" value="" />
						<input type="hidden" id="varFundCd" name="varFundCd" value="" />
						<input type="hidden" id="varBranchCd" name="varBranchCd" value="" />
						
						<input type="hidden" id="c042RecAcctId" name="c042RecAcctId" value="" />
						<input type="hidden" id="c042AcctTranId" name="c042AcctTranId" value="" />
						<input type="hidden" id="c042TranDate" name="c042TranDate" value="" />
						<input type="hidden" id="c042RecAcctYear" name="c042RecAcctYear" value="" />
						<input type="hidden" id="c042RecAcctSeqNo" name="c042RecAcctSeqNo" value="" />
						<input type="hidden" id="c042RecAcctFlag" name="c042RecAcctFlag" value="" />
						<input type="hidden" id="refreshTG" name="refreshTG" value="" />
					</td>
					<td class="rightAligned">Recovered Amount </td>
					<td class="leftAligned" width="38%">
						<input type="text" id="recoveredAmt" class="money" name="recoveredAmt" value="" readonly="readonly" style="width: 200px; float: left;" />
						<div style="float: left; margin-left: 2px; float: left;">
							<img id="searchRecoveryAcct" name="searchRecoveryAcct" alt="Go" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />
							<%-- <img id="addRecoveryAcct" name="addRecoveryAcct" alt="Clear" src="${pageContext.request.contextPath}/css/mtg/images/add.png" /> --%>
						</div>
						<input type="hidden" id="selectedPaytIndex" name="selectedPaytIndex" value="" />
					</td>
				</tr>
			</table>
		</div>
		<div id="generateRecPaytEntriesMainDiv" class="sectionDiv">
			<div id="recoveryPaytTableGridDiv" style="padding: 10px; float: left;">
				<div id="recoveryPaytTableGrid" style="height: 325px; width: 900px; float: left;"></div>
			</div>
			<div id="recPaytAddlInfo" style="margin-top: 10px; float: left; width: 100%;">
				<table align="center">
					<tr>
						<td class="rightAligned" width="70px">Loss Date</td>
						<td class="leftAligned"><input id="dspLossDate" style="width: 200px;" type="text" /></td>
						<td class="rightAligned" width="110px">Loss Category</td>
						<td class="leftAligned"><input id="dspLossCtgry" style="width: 200px;" type="text" /></td>
					</tr>
				</table>
			</div>
		</div>
	</div>
	<div class="buttonsDiv" style="margin-left: 12%; margin-top: 10px; width: 700px;">
		<input id="btnViewDist" name="btnViewDist" class="disabledButton" type="button" value="View Distribution" style="margin-left: 1px; margin-top: 5px; float: left;" />
		<input id="btnGenerateRecAcct" name="btnGenerateRecAcct" class="disabledButton" type="button" value="Generate Rec. Acct." style="margin-left: 10px; margin-top: 5px; float: left;" />
		<input id="btnCancelRecAcct" name="btnCancelRecAcct" class="disabledButton" type="button" value="Cancel Rec. Acct." style="margin-left: 10px; margin-top: 5px; float: left;" />
		<div style=" margin-left:10px; width: 50px; height: 50px; float: left;">
			<img  id="btnAcctEnt" name="btnAcctEnt" disabled="Y" alt="Go" style="width: 30px; height: 30px; margin-bottom: 10px;" src="${pageContext.request.contextPath}/images/misc/masterDetail.png" />
		</div>
		<input id="btnPostEntries" name="btnPostEntries" class="disabledButton" type="button" value="Post Entries to Acctg." style="margin-left: 10px; margin-top: 5px; float: left;" />
		<input id="btnCancelLR" name="btnCancelLR" class="disabledButton" type="button" value="Cancel LR" style="margin-left: 10px; margin-top: 5px; float: left;" />
	</div>
</div>
<script type="text/javascript">
	setModuleId("GICLS055");
	setDocumentTitle("Generate Recovery Accounting Entries - Loss Recovery");
	objRecPayt = new Object();
	objRecPayt.recPaytTableGrid = JSON.parse('${recPaytGrid}'.replace(/\\/g, '\\\\'));
	var genBtnToggled = false;
	var genAcctObj = [];	
	var recAccts = eval('${recAccts}');
	var createEnabled = false; //lara 1/13/2014
	initializeAll();
	
	$("varFundCd").value = '${vFundCd}';
	$("varBranchCd").value = objCLMGlobal.branchCd == null ? '${vIssCd}' : objCLMGlobal.branchCd;
	
	var selectedRecPayt = null;
	var paytSelectedIndex = null;
	var mtgIdA = null;
	var forCancel = null;
	
	var claimId = nvl(objCLMGlobal.claimId, null); //benjo 08.27.2015 UCPBGEN-SR-19654 
	var recAcctId = nvl(objCLMGlobal.recoveryAcctId, null); //benjo 08.27.2015 UCPBGEN-SR-19654 
	
	try {
		var recPaytTable = {
			url: contextPath+"/GICLRecoveryPaytController?action=getRecoveryPaytListing&refreshAction="+$F("refreshTG")+"&moduleId="+
			//objCLMGlobal.callingForm+"&claimId="+$F("hidClaimId")+"&recoveryAcctId="+$F("c042RecAcctId")+"&refresh="+1+"&createEnabled="+createEnabled, //lara 1/13/2014 //benjo 08.27.2015 comment out 
			objCLMGlobal.callingForm+"&claimId="+claimId+"&recoveryAcctId="+recAcctId+"&refresh="+1+"&createEnabled="+createEnabled, //benjo 08.27.2015 UCPBGEN-SR-19654 
			options: {
				title: '',
				height: '300px',
				onCellFocus: function(element, value, x, y, id) {
					selectedRecPayt = recPaytGrid.geniisysRows[y];
					paytSelectedIndex = y;
					$("selectedPaytIndex").value = y;
					
					$("dspLossDate").value = selectedRecPayt.dspLossDate;
					$("dspLossCtgry").value = unescapeHTML2(selectedRecPayt.dspLossCtgry);
					selectedRecPayt.distSw == "Y" ? enableButton("btnViewDist") : disableButton("btnViewDist"); // Kenneth L. 11.08.2013
					
					if(!(createEnabled)){ //lara 1/14/2014
						enableButton("btnViewDist");	
					}else{
						if(selectedRecPayt.distSw == "Y") {
							enableButton("btnViewDist");
						}else{
							disableButton("btnViewDist");
						}
					}
				},
				onCellBlur: function(element, value, x, y, id) {
				},
				onRemoveRowFocus: function() {
					selectedRecPayt = null;
					paytSelectedIndex = null;
					
					$("selectedPaytIndex").value = "";
					
					$("dspLossDate").value = "";
					$("dspLossCtgry").value = "";
					
					disableButton("btnViewDist"); // Kenneth L. 11.08.2013
				},
				toolbar: {
					elements : [MyTableGrid.FILTER_BTN],
					onFilter: function(){
					}
				}
			},
			columnModel: [
				{
					id: 'recordStatus',
					width: '0',
					visible: false,
					editor: 'checkbox'
				},
				{	
					id: 'divCtrId',
					width: '0',
					visible: false
				},
				{
					id: 'recoveryId',
					title: 'recoveryId',
					width: '0',
					visible: false
				},
				{
					id: 'recoveryPaytId',
					title: 'recoveryPaytId',
					width: '0',
					visible: false
				},
				{
					id: 'claimId',
					title: 'claimId',
					width: '0',
					visible: false
				},
				{
					id: 'acctTranId',
					title: 'acctTranId',
					width: '0',
					visible: false
				},
				{
					id: 'tranDate2',
					title: 'tranDate2',
					width: '0',
					visible: false
				},
				{
					id: 'recoveryAcctId',
					title: 'recoveryAcctId',
					width: '0',
					visible: false
				}, 
				{
					id: 'statSw',
					title: 'statSw',
					width: '0',
					visible: false
				}, 
				{
					id: 'dspLossDate',
					title: 'dspLossDate',
					width: '0',
					visible: false
				},
				{
					id: 'dspLossCtgry',
					title: 'dspLossCtgry',
					width: '0',
					visible: false
				},
				{
					id: 'dspPayorName',
					title: '',
					width: '0',
					visible: false
				},
				{
					id: 'nbtCheckRec',
					title: '',
					width: '22px',
					titleAlign: 'center',
					sortable : false,
					altTitle : 'Tag for Accounting Entry Generation',
					editable: ($("c042RecAcctId").value == "" ? true : false),
					editor: new MyTableGrid.CellCheckbox({
						getValueOf: function(value){
		            		if (value){
								return "Y";
		            		}else{
								return "N";	
		            		}	
		            	},
		            	onClick: function(value, checked) {
		            		var enableGenBtn = true;
		            		if(selectedRecPayt.distSw == "N" || selectedRecPayt.distSw == null) {
		            			showMessageBox("Please check the Distribution Status field. "+ 
		            					"Records must be distributed before generation of accounting entries.", "I"); //changed to message box Kenneth L. 11.13.2013

	            				$("mtgInput"+mtgIdA+"_12,"+paytSelectedIndex).checked = false;
	            				enableGenBtn = false;
		            		}
		            		
		            		if(selectedRecPayt.recoveryAcctId == "" || selectedRecPayt.recoveryAcctId == null) {
		            			//add
		            		} else {
		            			showMessageBox("Recovery Accounting Entries have already been generated "+ 
            					"for this recovery payment record.", "I");	//changed to showMessageBox Kenneth L. 11.13.2013
		        				$("mtgInput"+mtgIdA+"_12,"+paytSelectedIndex).checked = false;
		        				enableGenBtn = false;
		            		}
		            		
		            		if(enableGenBtn) {
		            			if(value == "Y") {
		            				includeGenAcctObj(selectedRecPayt);
		            				//genAcctObj.push(selectedRecPayt);
		            			} else {
		            				removeFromGenAcctObj(selectedRecPayt);
		            			}
		            			toggleGenBtn();
		            		}
		            		
		            		changeTag = 0; 
		            	}
					}) 
				},
				{
					id: 'dspRecoveryNo',
					title: 'Recovery Number',
					width: '105',
					filterOption: true
				},
				{
					id: 'dspRefNo',
					title: 'Reference No.',
					width: '115',
					titleAlign: 'center',
					align: 'right',
					editable: false,
					filterOption: true
				},
				{
					id: 'dspPayorName',
					title: 'Payor',
					width: '175',
					titleAlign: 'center',
					editable: false,
					filterOption: true
				},
				{
					id: 'recoveredAmt', 
					title: 'Recovered Amt',
					width: '100',
					titleAlign: 'center',
					align: 'right',
					editable: false,
					renderer: function(value) {
						return formatCurrency(value);
					}
				}, 
				{
					id: 'distSw',
					title: 'Dist',
					width: '25',
					editable: false,
					filterOption: true
				},
				{
					id: 'dspClaimNo',
					title: 'Claim Number',
					width: '105',
					editable: false
				},
				{
					id: 'dspPolicyNo',
					title: 'Policy Number',
					width: '130',
					titleAlign: 'center',
					align: 'right',
					editable: false
				},
				{
					id: 'dspAssdName',
					title: 'Assured Name',
					width: '150',
					titleAlign: 'center',
					editable: false
				}
			],
			resetChangeTag: false,
			rows: objRecPayt.recPaytTableGrid.rows
		};
		
		recPaytGrid = new MyTableGrid(recPaytTable);
		recPaytGrid.pager = objRecPayt.recPaytTableGrid;
		recPaytGrid.render('recoveryPaytTableGrid');
		mtgIdA = recPaytGrid._mtgId;
	} catch(e) {
		showErrorMessage("recoveryPaytTableGrid", e);
	}
	
	$("searchRecoveryAcct").observe("click", function() {
		//var claimId = nvl($F("globalClaimId"), "") == "" ? null : $F("globalClaimId");
		var searchClaimId = nvl(objCLMGlobal.claimId, null);
		var searchRecAcctId = nvl(objCLMGlobal.recoveryAcctId, null);
		getRecoveryAcctLOV(searchClaimId, "GICLS055", searchRecAcctId);	
	});
	
	//$("addRecoveryAcct").observe("click", function() { // andrew - 04.24.2012
	$("createNewRecoveryAccEnt").observe("click", function() {
		createEnabled = true; //lara 1/13/2014
		$("recoveryAcctNo").clear();
		$("recoveredAmt").clear();
		recPaytGrid.url = contextPath+"/GICLRecoveryPaytController?action=getRecoveryPaytListing&refreshAction=getRecoveryPaytTG&moduleId="+
			//objCLMGlobal.callingForm+"&claimId="+null+"&recoveryAcctId="+null+"&refresh="+1+"&createEnabled="+createEnabled; //lara 1/13/2014 //benjo 08.27.2015 comment out
			objCLMGlobal.callingForm+"&claimId="+claimId+"&recoveryAcctId="+recAcctId+"&refresh="+1+"&createEnabled="+createEnabled; //benjo 08.27.2015 UCPBGEN-SR-19654
	 	recPaytGrid.refresh();
	 	disableMainButtons();
	});
	
	$("btnViewDist").observe("click", function() {
		 var contentDiv = new Element("div", {id : "modal_content_dist"});
		 var contentHTML = '<div id="modal_content_dist"></div>';
		 
		 distOverlay = Overlay.show(contentHTML, {
			 				id: 'modal_dialog_dist',
			 				title: "View Distribution",
			 				width: 650,
			 				height: 400,
			 				draggable: true,
			 				closable: true
		 				});
		 
		 new Ajax.Updater("modal_content_dist", 
				 contextPath+"/GICLRecoveryPaytController?action=showDistDetailsModal&loadTG=0&recoveryId="+selectedRecPayt.recoveryId
				 +"&recoveryPaytId="+selectedRecPayt.recoveryPaytId, {
			evalScripts: true,
			asynchronous: false,
			
			onComplete: function (response) {			
				if (!checkErrorOnResponse(response)) {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		 });
	});
	
	function disableMainButtons() {
		disableButton("btnViewDist");
		disableButton("btnGenerateRecAcct");
		disableButton("btnCancelRecAcct");
		disableButton("btnPostEntries");
		disableButton("btnCancelLR");
		$("btnAcctEnt").setAttribute("disabled", "Y");
	}
	
	function getNewRecAcctInfo() {
		var res = new Object;
		new Ajax.Request(contextPath+"/GICLRecoveryPaytController", {
			method: "GET",
			parameters: {
					action: "generateRecAcctInfo",
					issCd: $F("varBranchCd")
				},
			evalScripts: true,
			asynchronous: false,
			onComplete: function(response) {
				if(checkErrorOnResponse(response)) {
					res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
				} 
			}
		});
		return res;
	}
	
	function generateRecoveryAcct() {
		try {
			var recPaytObj;
			var recoveryAmtSum = 0;
			var genObj = new Object();

			for(var i=0; i<genAcctObj.length; i++) {
				if(genAcctObj[i].recoveryAcctId == null) {
					recoveryAmtSum = recoveryAmtSum + unformatCurrencyValue(genAcctObj[i].recoveredAmt);
				}
			}
			if(genAcctObj.length>0) {
				recPaytObj = getNewRecAcctInfo();
			}
			recPaytObj.recoveryAmt = recoveryAmtSum;
			recPaytObj.recAcctFlag = "N";
			
			genObj.recPayts = prepareGeneratedRecPayt(genAcctObj, recPaytObj.recoveryAcctId);
			genObj.recAcct = recPaytObj;
			
			  new Ajax.Request(contextPath+"/GICLRecoveryPaytController", {
				method: "GET",
				parameters: {
					action: "generateRecovery",
					parameters: JSON.stringify(genObj)
				},
				evalScripts: true,
				asynchronous: false,
				onComplete: function (response) {	
					//var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
					if (response.responseText == null || response.responseText == '') {
						//showMessageBox("Recovery generated.", imgMessage.SUCCESS);
						showMessageBox("Recovery Acct No. generated.", imgMessage.SUCCESS); // Kenneth L. 11.08.2013 
						//showGenerateRecoveryAcctEntries($F("hidClaimId"), $F("c042RecAcctId")); //benjo 08.27.2015 comment out
						showGenerateRecoveryAcctEntries(claimId, recAcctId); //benjo 08.27.2015 UCPBGEN-SR-19654
					} else if (response.responseText.include("not a posting account")){
						showWaitingMessageBox("Recovery Acct No. generated.", imgMessage.SUCCESS, function() { // Kenneth L. 11.08.2013 
						//showWaitingMessageBox("Recovery generated.", imgMessage.INFO, function() {
							showWaitingMessageBox(response.responseText, imgMessage.INFO, function() {
								//showGenerateRecoveryAcctEntries($F("hidClaimId"), $F("c042RecAcctId")); //benjo 08.27.2015 comment out
								showGenerateRecoveryAcctEntries(claimId, recAcctId); //benjo 08.27.2015 UCPBGEN-SR-19654
								});
							});
					} else if (response.responseText.include("does not exist in Chart of Accounts")){
						showWaitingMessageBox(response.responseText, imgMessage.INFO, function() {
							//showGenerateRecoveryAcctEntries($F("hidClaimId"), $F("c042RecAcctId")); //benjo 08.27.2015 comment out
							showGenerateRecoveryAcctEntries(claimId, recAcctId); //benjo 08.27.2015 UCPBGEN-SR-19654
						});
					} else {
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});  
			
			genAcctObj = [];
		} catch(e) {
			showErrorMessage("generateRecoveryAcct", e);
		}
	}
	
	function whenNotInGlAccount() {
		new Ajax.Request(contextPath+"/GICLRecoveryPaytController", {
			method: "POST",
			evalScripts: true,
			asynchronous: false,
			parameters: {
				action: "cancelRecoveryPayt",
				acctTranId: $F("c042AcctTranId"),
				tranDate: $F("c042TranDate"),
				recoveryAcctId: $F("c042RecAcctId")
			},
			onComplete: function(response) {
				var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
				if (res.message == null || res.message == '') {
					$("c042RecAcctFlag").value = "D";
					setRecoveryAccts(true, true);
				} else {
					showMessageBox(res.message, imgMessage.ERROR);
				}
			}
		});
	};
	
	$("btnGenerateRecAcct").observe("click", function() {
		//generate_recovery_acct
		generateRecoveryAcct();
		//aeg_parameters
	});
	
	$("btnCancelRecAcct").observe("click", function () {
		forCancel = $F("btnCancelRecAcct");
		showConfirmBox("Confirm", "This recovery account number will be tag as deleted.\n Do you really want to cancel this record? ",
				"Yes", "No", 
				function() {/*Yes*/
					new Ajax.Request(contextPath+"/GICLRecoveryPaytController", {
						method: "POST",
						evalScripts: true,
						asynchronous: false,
						parameters: {
							action: "cancelRecoveryPayt",
							acctTranId: $F("c042AcctTranId"),
							tranDate: $F("c042TranDate"),
							recoveryAcctId: $F("c042RecAcctId")
						},
						onComplete: function(response) {
							var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
							if (res.message == null || res.message == '') {
								$("c042RecAcctFlag").value = "D";
								setRecoveryAccts(true, true);
							} else {
								showMessageBox(res.message, imgMessage.ERROR);
							}
							/* if(checkErrorOnResponse(response)) {
								$("c042RecAcctFlag").value = "D";
								//$("c042TranDate").value = "";
								//$("c042AcctTranId").value = "";
								setRecoveryAccts(true, true);
							} */
						}
					});
				},
				"");
	});
	
	$("btnPostEntries").observe("click", function() {
		try{
			if (paytSelectedIndex == null){
				showMessageBox("Please select an entry to post.");
			} else {
				/* generateAEOverlay = Overlay.show(contextPath+"/GICLRecoveryPaytController", {
					urlContent: true,
					urlParameters: {action : "showPostRecovery",
					ajax : "1"},
					title: "Post Recovery",
					height: 170,
					width: 560,
					draggable: true
				}); */ //benjo 08.27.2015 comment out
				validateRecAETotals(); //benjo 08.27.2015 UCPBGEN-SR-19654
			}
		}catch(e){
			showErrorMessage("showPostRecovery",e);
		}
	});
	
	/* benjo 08.27.2015 UCPBGEN-SR-19654 */
	function validateRecAETotals() {
		var res = new Object;
		new Ajax.Request(contextPath+"/GICLRecoveryPaytController", {
			method: "GET",
			parameters: {
					action: "getRecAEAmountSum",
					recoveryAcctId: $F("c042RecAcctId")
				},
			onComplete: function(response) {
				if(checkErrorOnResponse(response)) {
					res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
					if (res.debitSum != res.creditSum){
						showMessageBox("Total Debit and Credit amounts are not equal. Please check the entries.", "e");
			    		return;
					} else {
						generateAEOverlay = Overlay.show(contextPath+"/GICLRecoveryPaytController", {
							urlContent: true,
							urlParameters: {action : "showPostRecovery",
							ajax : "1"},
							title: "Post Recovery",
							height: 170,
							width: 560,
							draggable: true
						});
					}
				} 
			}
		});
	}
	
	$("btnCancelLR").observe("click", function() {
		forCancel = $F("btnCancelLR");
		new Ajax.Request(contextPath+"/GIACAccTransController", {
			method: "POST",
			evalScripts: true,
			asynchronous: false,
			parameters: {
				action: "updateAccTransFlag",
				tranId: $F("c042AcctTranId"),
				tranFlag: "D"
			},
			onComplete: function(response) {
				if(checkErrorOnResponse(response)) {
					changeTag = 0;
					//	$("c042AcctTranId").value = "";
					$("c042RecAcctFlag").value = "C";	//benjo 08.27.2015 UCPBGEN-SR-19654
					setRecoveryAccts(true, true);
				}
			}
		});
	});
	
	$("btnAcctEnt").observe("click", function() {
		if($F("c042RecAcctId") != "" && selectedRecPayt != null) {
			//recPaytGrid.releaseKeys();
			var contentDiv = new Element("div", {id : "modal_content_ae"});
			var contentHTML = '<div id="modal_content_ae"></div>';
			
			aeOverlay = Overlay.show(contentHTML, {
					id: 'modal_dialog_acct_entries',
					title: "Recovery Accounting Entries",
					width: 650,
					height: 540,
					draggable: true,
					closable: true
				});
			
			new Ajax.Updater("modal_content_ae", 
					 contextPath+"/GICLRecoveryPaytController?action=showRecAcctEntries&refresh=0&recoveryAcctId="+$F("c042RecAcctId")+
							 "&payorCd="+selectedRecPayt.payorCd+"&payorClassCd="+selectedRecPayt.payorClassCd+"&acctTranId="+$F("c042AcctTranId"), { //lara 1/16/2014
				evalScripts: true,
				asynchronous: false,
				onComplete: function (response) {			
					if (!checkErrorOnResponse(response)) {
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			 });
		}
	});
	
	function setRecoveryAccts(refresh, showMesg) {
		try {
			var param = prepareRecAcctParam();
			if(param != null) {
				new Ajax.Request(contextPath+"/GICLRecoveryPaytController", {
					method: "POST",
					parameters: {
						action: "setRecoveryAcct",
						parameters: JSON.stringify(param)
					},
					evalScripts: true,
					asynchronous: false,
					onComplete: function(response) {
						if(checkErrorOnResponse(response)) {
							if(showMesg) {
								//showMessageBox("SUCCESS", imgMessage.SUCCESS); //Kenneth L. 11.08.2013
								var outMsg = "";
								outMsg = forCancel == "Cancel LR" ?  "Saving successful." : "This recovery account number has already been tagged as deleted.";
								showMessageBox(outMsg, imgMessage.SUCCESS);
							}
							if(refresh) {
								//claimId = $F("hidClaimId") == "" ? null : $F("hidClaimId"); //benjo 08.27.2015 comment out
								//showGenerateRecoveryAcctEntries(null, null, null); //lara 01.24.2014 //benjo 08.27.2015 comment out
								showGenerateRecoveryAcctEntries(claimId, recAcctId); //benjo 08.27.2015 UCPBGEN-SR-19654
							}
						}
					}
				});
			}
		} catch(e) {
			showErrorMessage("setRecoveryAccts", e);
		}
	}
	
	function prepareRecAcctParam() {
		try {
			var obj = new Object();
			if($F("c042RecAcctId") == "") {
				showMessageBox("No recovery account available.", "e");
				return null;
			} else {
				obj.recoveryAcctId = $F("c042RecAcctId") == "" ? null : $F("c042RecAcctId");
				obj.issCd = $F("varBranchCd");
				obj.recAcctYear = $F("c042RecAcctYear") == "" ? null : $F("c042RecAcctYear");
				obj.recAcctSeqNo = $F("c042RecAcctSeqNo") == "" ? null : $F("c042RecAcctSeqNo");
				obj.recoveryAmt = $F("recoveredAmt") == "" ? null : unformatCurrencyValue($F("recoveredAmt"));
				obj.acctTranId = $F("c042AcctTranId") == "" ? null : $F("c042AcctTranId");
				obj.tranDate = $F("c042TranDate") == "" ? null : $F("c042TranDate");
				obj.recAcctFlag = $F("c042RecAcctFlag") == "" ? null : $F("c042RecAcctFlag");
				return obj;
			}
		} catch(e) {
			showErrorMessage("getMainPostParams", e);
		}
	}
	
	function prepareGeneratedRecPayt(objArr, acctId) {
		try {
			var obj = new Object();
			var recPaytArr = [];
			for(var i=0; i<objArr.length; i++) {
				obj = new Object(); //lara 01/22/2013
				obj.recoveryId = objArr[i].recoveryId;
				obj.recoveryPaytId = objArr[i].recoveryPaytId;
				obj.recoveryAcctId = acctId;
				recPaytArr.push(obj);
			}
			return recPaytArr;
		} catch(e) {
			showErrorMessage("prepareGeneratedRecPayt", e);
		}
	}
	
	function includeGenAcctObj(row) {
		var exists = false;
		try {
			for(var i=0; i<genAcctObj.length; i++) {
				if(row.recoveryId == genAcctObj[i].recoveryId &&
						row.recoveryPaytId == genAcctObj[i].recoveryPaytId) {
					exists = true;
				}
			}
			if(!exists) genAcctObj.push(row);
		} catch(e) {
			showErrorMessage("includeGenAcctObj", e);
		}
	}
	
	function removeFromGenAcctObj(row) {
		for(var i=0; i<genAcctObj.length; i++) {
			if(row.recoveryId == genAcctObj[i].recoveryId &&
					row.recoveryPaytId == genAcctObj[i].recoveryPaytId) {
				genAcctObj.splice(i, 1);
			}
		}
	}
	
	function toggleGenBtn() {
		var exists = genAcctObj.length;
		if(exists > 0) {
			genBtnToggled = true;
			enableButton($("btnGenerateRecAcct"));
			enableButton($("btnViewDist"));
		} else {
			genBtnToggled = false;
			disableButton($("btnGenerateRecAcct"));
		}
	}
	
	$("genRecoveryExit").observe("click", function(){
		if(objCLMGlobal.callingForm == "GICLS052"){ // andrew - 04.24.2012
			$("recoveryInfoDiv").innerHTML = "";
			$("recoveryInfoDiv").hide();
			$("lossRecoveryListingMainDiv").show();
			lossRecoveryListTableGrid._refreshList();
			disableMenu("recoveryDistribution");
			disableMenu("generateRecoveryAcctEnt");
			setModuleId("GICLS052");
		} else if(objCLMGlobal.callingForm == "GICLS025"){ // Kris 03.27.2014
			objGICLS055CallingForm = "GICLS025";
			//showClaimBasicInformation();
			objCLMGlobal.callingForm = $("lblModuleId").readAttribute("moduleid");
			showRecoveryInformation();			
		} else if (objCLMGlobal.callingForm == "GICLS054") {
			objCLMGlobal.callingForm = $("lblModuleId").readAttribute("moduleid");
			showRecoveryDistribution();
		}else if(objCLMGlobal.callingForm == "GICLS010"){ //marco - 08.06.2014 ; SR#4361 - Issues in Generating the Claim Recovery Accounting Entries 
			/* $("claimViewPolicyInformationDiv").hide();
			$("claimViewPolicyInformationDiv").update();
			$("claimListingMainDiv").show();
			setModuleId("GICLS002");
			setDocumentTitle("Claim Listing"); */ //benjo 08.27.2015 comment out
			showClaimBasicInformation(); //benjo 08.27.2015 UCPBGEN-SR-19654
		} else {
			goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
		}
		objRecPayt = null;
	});
	
	observeReloadForm("reloadForm", function(){ // andrew - 04.24.2012
		/* var claimId = $F("hidClaimId") == "" ? null : $F("hidClaimId");
		var recAcctId = $F("c042RecAcctId") == "" ? null : $F("c042RecAcctId"); */ //benjo 08.27.2015 comment out
		showGenerateRecoveryAcctEntries(claimId, recAcctId);
	});
	
	function assignRecovery(row) {
		$("recoveryAcctNo").value = row.dspRecoveryAcctNo;
		 $("recoveredAmt").value = row.recoveryAmt == null ? "" : formatCurrency(row.recoveryAmt);
		 
		 $("c042RecAcctId").value = row.recoveryAcctId == null ? "" : row.recoveryAcctId;
		 $("c042AcctTranId").value = row.acctTranId == null ? "" : row.acctTranId;
		 $("c042TranDate").value = row.tranDate == null ? "" : row.tranDate;
		 $("c042RecAcctFlag").value = row.recAcctFlag == null ? "" : row.recAcctFlag;
		 $("c042RecAcctYear").value = row.recAcctYear == null ? "" : row.recAcctYear;
		 $("c042RecAcctSeqNo").value = row.recAcctSeqNo == null ? "" : row.recAcctSeqNo;
		 $("hidClaimId").value = row.nbtClaimId;
		/*  if(nvl(objCLMGlobal.claimId, null) == null) {
			 $("hidClaimId").value = row.nbtClaimId;
		 } else { 
			 $("hidClaimId").value = nvl(objCLMGlobal.claimId, null);
		 }*/
		
		 if($F("c042RecAcctId") == "") {
				disableMainButtons();
		 } else {
			//enableButton("btnViewDist");
			if(row.acctExists == "1") {
				disableButton("btnCancelRecAcct");
				disableButton("btnPostEntries");
				enableButton("btnCancelLR"); //lara 01.24.2014
			} else {
				enableButton("btnCancelRecAcct");
				enableButton("btnPostEntries");
				disableButton("btnCancelLR"); //lara 01.24.2014
			}
			if(row.dspTranFlag == "P" || row.dspTranFlag == null) {
				disableButton("btnCancelLR");
			} else {
				//enableButton("btnCancelLR"); //lara 01.24.2014
			}
			disableButton("btnGenerateRecAcct");
			
			$("btnAcctEnt").setAttribute("disabled", "N");
		 }
	}
	
	function getRecoveryAcctLOV(claimId, moduleId, recoveryAcctId) {
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getRecoveryAcctLOV",
										  claimId: claimId,
										  moduleId: moduleId,
										  recoveryAcctId: recoveryAcctId,
										  page : 1},
			title: "Recovery Accounts",
			width: 360,
			height: 400,
			columnModel: [  { 	
								id: "dspRecoveryAcctNo",
							  	title: "Recovery Acct No",
							  	width: '140px'
							},
							{
								id: "recoveryAmt",
								title: "Recovery Amount",
								width: '140px',
							  	align: 'right',
								renderer: function(value) {
									return formatCurrency(value);
								}
							},
							{
								id: "recoveryAcctId",
								title: "recoveryAcctId",
								width: '0',
								visible: false
							},
							{
								id: "acctTranId",
								title: "acctTranId",
								width: '0',
								visible: false
							}
			              ],
			 draggable: true,
			 onBlur: disableButton("btnViewDist"),
			 onSelect: function(row) {
				 assignRecovery(row);
				 $("refreshTG").value = "getRecoveryPaytWithAcctTG";
				 if(recPaytGrid != undefined || recPaytGrid != null) {
					 recPaytGrid.url = contextPath+"/GICLRecoveryPaytController?action=getRecoveryPaytListing" +
					 	"&refreshAction=getRecoveryPaytWithAcctTG&moduleId="+objCLMGlobal.callingForm+
						"&claimId="+null+"&recoveryAcctId="+row.recoveryAcctId+"&refresh="+1+"&page="+1+"&createEnabled=true"; //lara 1/13/2014
					 recPaytGrid.refresh();	
				 }
			 }
		});
	}
	
	if(recAccts.length > 0) {
		assignRecovery(recAccts[0]);
	}
	initializeAccordion();
</script>