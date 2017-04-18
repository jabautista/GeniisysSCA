<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<!--<div id="officialReceiptHiddenDiv" name="officialReceiptHiddenDiv">
	<input type="hidden" id="message" value="${message}" />
	<input type="hidden" id="collnSourceName" value="${collnSourceName}" />
	<input type="hidden" id="gFundCd" value="${fundCd}" />
	<input type="hidden" id="grpIssCd" value="${grpIssCd}" />
	<input type="hidden" id="gOrTag" value="${orTag}" />
	<input type="hidden" id="gOrFlag" value="${orFlag}" />
	<input type="hidden" id="gOpTag" value="${opTag}" />
	<input type="hidden" id="gWithPdc" value="${withPdc}" />
</div>
-->
<div id="officialReceiptMainDiv" style="margin-top: 1px;">
<form id="officialReceiptForm" name="officialReceiptForm"><jsp:include
	page="subPages/officialReceiptInformation.jsp"></jsp:include> <jsp:include
	page="subPages/collectionBreakDown.jsp"></jsp:include></form>

<div class="buttonsDiv" id="officialReceiptButtonDiv">
<table align="center">
	<tr>
		<td><input type="button" class="button" id="btnCancelOR"
			name="btnCancelOR" value="Cancel" style="width: 90px;" /></td>
		<td><input type="button" class="button" id="btnSave"
			name="btnSave" value="Save" style="width: 90px;" /></td>
	</tr>
</table>
</div>
</div>
<script type="text/javaScript">
	setModuleId("GIACS001"); // andrew - 10.04.2010 - added this line
	if (objACGlobal.orTag == "*") {
		setDocumentTitle("Enter O.R Information: Manual OR without OP");
		$("orPrefSuf").addClassName("required");
		$("orNo").addClassName("required");
	}else if (objACGlobal.orTag == "" || objACGlobal.orTag == null){
		setDocumentTitle("Enter O.R. Information: System-Generated OR without OP");
	}
	if (objAC.fromMenu == "cancelOR"){  // christian 09182012
		setDocumentTitle("Cancel OR");
	}
	
	/* benjo 11.08.2016 SR-5802 */
	if(nvl('${apdcSW}', 'N') == 'Y'){
		if(nvl('${allowSpoil}', 'FALSE') == 'TRUE'){
			enableButton("spoilOR");
		}else{
			disableButton("spoilOR");
		}
	}
	
	if (objAC.fromMenu == "cancelOR" && objAC.showOrDetailsTag == "showOrDetails"){ 
		setDocumentTitle("Enter O.P./O.R. Information");
		disableButton("spoilOR");
	}
	//initializeGlobalValues(); moved to officialReceiptInformation.jsp christian 08.30.2012
	
	changeTag = 0;
	var saveOnly = true;
	/**
	 * Set values for global parameters - GIACS001
	 * @author : Dennis
	 * @version 1.0
	 * @modified : andrew - 10.08.2010 - replaced with global object parameter
	 *             christian - 08.30.2012 - moved to officialReceiptInformation.jsp 
	 */
	/* function initializeGlobalValues() {
		if (objACGlobal.gaccTranId == null || objACGlobal.gaccTranId == "") {
			
			objACGlobal.branchCd		= '${grpIssCd}';
			objACGlobal.fundCd			= '${fundCd}';
			if (objACGlobal.orTag == null) {
				objACGlobal.orTag			= '${orTag}' == "null" ? "" : '${orTag}';
			}
			objACGlobal.orFlag			= '${orFlag}';
			objACGlobal.opTag			= '${opTag}';
			objACGlobal.withPdc			= '${withPdc}';
			objACGlobal.implSwParam		= '${implSwParameter}';
			objACGlobal.transaction		= 'Collection';
			objACGlobal.opRecTag		= 'N';
			objACGlobal.tranSource		= 'OR';
			objACGlobal.tranClass = '${collnSourceName}'; */
			/*
			if(objACGlobal.workflowEventDesc == "CANCEL OR" ){
				objACGlobal.orTag = 'C';
				objACGlobal.orCancel = 'Y';
				//objACGlobal.tranClass = '${collnSourceName}';
			} else {
				if (objACGlobal.workflowEventDesc != null){
					objACGlobal.orTag = 'S';
					objACGlobal.orCancel = 'N';
				}
			}

			if (objACGlobal.workflowEventDesc != "UNPAID PREMIUMS WITH CLAIMS" && objACGlobal.workflowEventDesc != null) {
				if (objACGlobal.orTag == '*') {
					objACGlobal.orTag = 'M';
				}
			}
			*/
		/* }
		objACGlobal.tranClass = '${collnSourceName}';
	} */

	$("dcbBankName").observe("change", function() {
		changeBankDetails();
	});

	// added by shan, to preserve previousModule if buttons are clicked
	if (objACGlobal.previousModule == "GIACS070"){
		objACGlobal.previousModule2 = objACGlobal.previousModule; 
		objACGlobal.previousModule = null;
	}
	 
	observeCancelForm("btnCancelOR", 
			function() {saveOnly=false; saveOR();}, 
			function() {saveOnly=false; 
							if(objACGlobal.previousModule == "GIACS003"){ //added by steven 04.09.2013
								if (objACGlobal.hidObjGIACS003.isCancelJV == 'Y'){
									showJournalListing("showJournalEntries","getCancelJV","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
								}else{
									showJournalListing("showJournalEntries","getJournalEntries","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
								}
								objACGlobal.previousModule = null;
							}else if(objACGlobal.previousModule == "GIACS071"){
								updateMemoInformation(objGIAC071.cancelFlag, objACGlobal.branchCd, objACGlobal.fundCd);
								objACGlobal.previousModule = null;		
							}else if(objACGlobal.previousModule == "GIACS230"){
								showGIACS230("N");
								objACGlobal.previousModule = null;		
							}else if(objACGlobal.previousModule == "GIACS002"){
								showDisbursementVoucherPage(objGIACS002.cancelDV, "getDisbVoucherInfo");
								objACGlobal.previousModule = null;
							}else if(objACGlobal.previousModule == "GIACS070" || objACGlobal.previousModule2 == "GIACS070"){	//added by shan 08.27.2013
								showGIACS070Page();
								objACGlobal.previousModule = null;
							}else if(objACGlobal.previousModule == "GIACS053"){
								showBatchORPrinting();
								objACGlobal.previousModule = null;
							}else{
								goBackToMain();
							}
	});

	$("acExit").stopObserving();
	$("acExit").observe("click", function() {		
		$("btnCancelOR").click();
	});

	function initializeEnabledDisabledProperties() {
		if (objACGlobal.callingForm == "orListing") {
			//$("canORNo").disabled = true;
			//$("canPrefSuf").disabled = true;
			$("bank").disabled = true;
			$("checkClass").disabled = true;
			$("checkCreditCardNo").disabled = true;
			$("checkDateCalendar").disabled = true;
			$("localCurrAmt").disabled = true;
			$("currency").disabled = true;
			$("particular").disabled = true;
			$("grossAmt").disabled = true;
			$("deductionComm").disabled = true;
			$("vatAmount").disabled = true;
			$("fcGrossAmt").disabled = true;
			$("fcCommAmt").disabled = true;
			$("fcTaxAmt").disabled = true;
			$("fcNetAmt").disabled = true;
			
			if (objACGlobal.orTag == '*') {
				$("orPrefSuf").readOnly = false;
				$("orNo").readOnly = false;
			}
		}else {
			if (objACGlobal.orTag == '*') {
				$("orPrefSuf").readOnly = false;
				$("orNo").readOnly = false;
			}else{
				$("orPrefSuf").readOnly = true;
				$("orNo").readOnly = true;
			}
		}
		
		//marco - 09.11.2014 - disable OR Details if OR has APDC
		if(nvl('${withAPDC}', 'N') == 'Y'){
			disableGIACS001ForAPDC(); //john dolon 6.4.2015; For disabling of fields for APDC
			enableButton("btnSave");
			disableDate("hrefCheckDate");
			
			if(nvl('${editAPDCOR}', 'N') == 'Y'){
				$w("payorName payorAddress1 payorAddress2 payorAddress3 payorTinNo payorParticulars").each(function(e){
					enableInputField(e);
				});
				$w("payorName payorNameDiv payorParticulars payorParticularsDiv").each(function(e){
					$(e).addClassName("required");
				});
				enableSearch("oscmPayor");
				$("intermediary").enable();
			}
		}
	}
	
	function saveOR() {
		if(checkAcctRecordStatus(objACGlobal.gaccTranId, "GIACS001")){ //marco - SR-5714 - 10.18.2016
			clearChangeAttribute("officialReceiptInformationDiv");
			if (checkClosedMonthYearTrans(Date.parse($F("orDate")).getMonth(), Date.parse($F("orDate")).getFullYear())){
				if (!$F("dcbNo").blank()) {
					if(checkPendingRecordChanges()) {
						if (objACGlobal.orTag != "*"){
							if (!$F("payorName").blank() && !$F("payorParticulars").blank()) {
								processOR();
							} else {
								showMessageBox("Required fields must be entered.", // Kris 01.29.2013: modified message 
										imgMessage.ERROR);
							}
						}else{
							if (!$F("payorName").blank() && !$F("payorParticulars").blank() && !$F("orPrefSuf").blank() && !$F("orNo").blank()) {
								processOR();
							} else {
								showMessageBox("Required fields must be entered.", // Kris 01.29.2013: modified message 
										imgMessage.ERROR);
							}
						}	
					}
				} else {
					showConfirmBox("Create DCB_NO", "There is no open DCB No. for "
							+ $F("orDate") + ". Create one?", "Yes", "No",
							validatePopulateDCB, cancelDCBCreation);
				}
			}
		}
	}

	function processOR(){
		new Ajax.Request(
				"GIACOrderOfPaymentController?action=saveORInformation",
				{
					method : "POST",
					parameters : {
						gaccTranId : objACGlobal.gaccTranId == ""
								|| objACGlobal.gaccTranId == null ? "0"
								: objACGlobal.gaccTranId, // andrew - 10.08.2010 - replaced with the object global parameter
						moduleName : "GIACS001",
						branchCd : objACGlobal.branchCd,
						fundCd : objACGlobal.fundCd,
						itemNoList : $F("itemNoListToDelete").blank() ? "0"
								: $F("itemNoListToDelete"),
						giacCollnBatchDtl : giacCollnBatchDtl(),
						orderOfPaymentDtl : orderOfPaymentDtl(),
						giacAcctrans : giacAcctrans(),
						giacCollectionDetail : giacCollectionDetail(),
						giacOrRel : prepareJsonAsParameter(giacOrRel()), //john 10.22.2014
						cancelledOrPrefSuf : $F("canPrefSuf"), //john 10.22.2014
						pdcItemIdList : $F("pdcItemIdToDelete"), //john 12.10.2014
						ajax : "1"
					},
					evalScripts : true,
					asynchronous : true,
					onCreate : function() {
						showNotice("Saving information, please wait...");
					},
					onComplete : function(response) {
						if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)) {
							hideNotice("");
							// andrew - 10.20.2010 - replaced with global object parameters						
							objACGlobal.gaccTranId = response.responseText;
							objACGlobal.orFlag = $F("orFlag");
							setRecordStatusToSaved();
							changeTag = 0;
							/*showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
								saveOnly ? "" : goBackToMain();
							});
							editORInformation();*/ // replaced by: Nica 3.12.2013
							
							showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
								if(saveOnly){
									editORInformation();
								}else{
									goBackToMain();
								}
							});
						}
					}
				});
	}
		
	$("btnSave").observe("click", function ()	{
		if(changeTag == 0){showMessageBox(objCommonMessage.NO_CHANGES ,imgMessage.INFO); return;}
		saveOR();	
	});	

	function goBackToMain() {
		/*goToModule("/GIISUserController?action=goToAccounting",
				"Accounting Main", null);*/
		// emman 05.17.2011
		/* updateMainContentsDiv("/GIACOrderOfPaymentController?action=showORListing",
			"Retrieving OR data, please wait...");
		objAC.butLabel = "Spoil OR";
		$("acExit").stopObserving("click");
		$("acExit").observe("click", function(){
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		}); */
		if(objAC.showOrDetailsTag == "showOrDetails"){   //added by KennethL 03.08.2013
			goToOrStatus();
		}else{
			var cancelORTag = objAC.butLabel == "Cancel OR" ? "Y" : "N"; // added by: Nica 04.25.2012 - to check if Cancelled OR's should be displayed or not

			if(objAC.fromMenu == "orListing") {
				updateMainContentsDiv("/GIACOrderOfPaymentController?action=showORListing&cancelOR="+cancelORTag+"&selFundCd="
						+objACGlobal.fundCd+"&selBranch="+($F("branchCd") == "" ? objACGlobal.branchCd : $F("branchCd"))+
						"&orTag="+objAC.createORTag,
					"Retrieving OR data, please wait...");
				//objAC.butLabel = "Spoil OR";
				$("acExit").stopObserving("click");
				$("acExit").observe("click", function(){
					goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
				});
			} else if(objAC.fromMenu == "generateOtherOR"){
				updateMainContentsDiv("/GIACOrderOfPaymentController?action=showORListing&cancelOR="+cancelORTag+"&selFundCd="
						+objACGlobal.fundCd+"&selBranch="+($F("branchCd") == "" ? objACGlobal.branchCd : $F("branchCd"))+
						"&orTag="+objAC.createORTag,
					"Retrieving OR data, please wait...");
			} else if(objAC.fromMenu == "enterOtherManualOR"){
				showBranchOR(2);
			} else if(objAC.fromMenu == "cancelOtherOR"){
				updateMainContentsDiv("/GIACOrderOfPaymentController?action=showORListing&cancelOR=Y"+
						"&selFundCd="+objACGlobal.fundCd+"&selBranch="+$F("branchCd"),
				"Retrieving OR data, please wait...");
			} else if(objAC.fromMenu == "cancelOR"){
				objAC.createORTag = null; 
				updateMainContentsDiv("/GIACOrderOfPaymentController?action=showORListing&cancelOR=Y",
				  						"Retrieving OR data, please wait...");
			} else {
				goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
			}
		}
		
	}
	
	function escapeBackSlashAndComma(str) { // escape backslash and comma - Lara 11/15/2013 
		if(str != null){
			return str.replace(/\\/g,'&#92;').replace(/,/g,'&#44;'); 
		}else{
			return "";
		}
	}

	function setRecordStatusToSaved() {
		$$("div[name='rowItem']").each(function(div) {
			div.down("input", 21).value = "3";
		});
	}

	function giacCollnBatchDtl() {
		var str = '';
		var dcbNo = trim($F("dcbNo"));
		var dcbYear = $F("orDate").split("-")[2];//$F("dcbYear");carlo SR 5936 02-21-2017
		var fundCd = $F("gfunFundCd");
		var branchCd = $F("branchCd");
		var tranDate = $F("orDate") + " " + $F("orTime");
		var dcbFlag = "O";
		var remarks = "Inserted from GIACS001.";
		str += dcbNo + "|" + dcbYear + "|" + fundCd + "|" + branchCd + "|"
				+ tranDate + "|" + dcbFlag + "|" + remarks + "|";
		return str;
	}

	function giacAcctrans() {
		var str = '';

		var gfunFundCd = $F("gfunFundCd");
		var branchCd = $F("branchCd");
		var tranDate = $F("orDate") + " " + $F("orTime");
		var tranFlag = 'O';
		var tranClass = objACGlobal.tranClass; //'COL';
		var tranClassNo = trim($F("dcbNo"));
		var particulars = '';
		var tranYear = $F("dcbYear");
		var tranMonth = $F("tranMonth");
		//added by christian 08.29.2012
		var tranId = $F("tranId") == null || $F("tranId") == "" ? 0 : $F("tranId");
		var tranSeqNo = $F("tranSeqNo") == null || $F("tranSeqNo") == "" ? 0 : $F("tranSeqNo");
		
		str += tranId + "|" + gfunFundCd + "|" + branchCd + "|" + tranDate + "|"
		+ tranFlag + "|" + tranClass + "|" + tranClassNo + "|"
		+ particulars + "|" + tranYear + "|" + tranMonth + "|" + tranSeqNo   
		+ "|";
				
		return str;
	}

	function orderOfPaymentDtl() {
		var str = '';

		/* adpascual - 03.20.2012 - modify the following lines - retrieved each addresses from 3 different fields instead of using a substring function */
		$("address1").value = escapeBackSlashAndComma(escapeHTML2($F("payorAddress1")));  //lara 11/15/2013
		$("address2").value = escapeBackSlashAndComma(escapeHTML2($F("payorAddress2"))); 
		$("address3").value = escapeBackSlashAndComma(escapeHTML2($F("payorAddress3"))); 	
		
		var gfunFundCd = $F("gfunFundCd");
		var branchCd = $F("branchCd");
		var payor = escapeHTML2($F("payorName"));
		var particulars = $F("payorParticulars") == null ? " "
				: escapeBackSlashAndComma(escapeHTML2(($F("payorParticulars"))));  //lara 11/15/2013

		var orTag = objACGlobal.orTag == null ? "" : objACGlobal.orTag;
		var orDate = $F("orDate") + " " + $F("orTime");
		var dcbNo = trim($F("dcbNo"));
		var orFlag = $F("orFlag");
		var opFlag = $F("orFlag");
		var grossTag = $("gross").checked == true ? 'Y' : 'N';
		var currCd; // = objAC.defCurrency; commented out by robert 04.09.2013
		var remitDate = $F("remittance") == "" ? null : $F("remittance");
		var currRt = 0;
		var fcGrossAmt = 0;
		var fcNetAmt = 0;
		var orNo = $F("orNo");
		var orPrefSuf = $F("orPrefSuf");
		var riCommTag = $("riCommTag").checked ? "Y" : "N";
		
		$$("div[name='rowItem']").each(function(row) {
			currCd = row.down("input", 7).value;
			currRt = parseFloat(row.down("input", 17).value);
			fcGrossAmt = fcGrossAmt + (row.down("input", 13).value.replace(/,/g,"") == "" ? "0" : parseFloat(row.down("input", 13).value.replace(/,/g, "")));
			fcNetAmt = fcNetAmt + (row.down("input", 16).value.replace(/,/g, "") == "" ? "0" : parseFloat(row.down("input",16).value.replace(/,/g, "")));
		});

		var grossAmt = fcGrossAmt; //$F("totGrossAmt"); 
		var cashierCd = $F("cashierCode");
		var collectionAmt = fcNetAmt; //$F("netCollectionAmt");
		var intmNo = $("intermediary").options[$("intermediary").selectedIndex].value == "" ? null
				: $("intermediary").options[$("intermediary").selectedIndex].value;
		var tinNo = $F("payorTinNo");
		var provReceiptNo = $F("provReceiptNo");
		str += "0" + "|" + gfunFundCd + "|" + branchCd + "|" + payor 
				+ "|" + $F("address1") 
				+ "|" + $F("address2")
				+ "|" + $F("address3")
				+ "|" + particulars + "|" + orTag + "|" + orDate + "|" + dcbNo
				+ "|" + grossAmt + "|" + cashierCd + "|" + grossTag + "|"
				+ collectionAmt + "|" + orFlag + "|" + opFlag + "|" + nvl(currCd,null)
				+ "|" + intmNo + "|" + tinNo + "|" + "N" + "|" + remitDate
				+ "|" + provReceiptNo + "|" + orNo + "|" + orPrefSuf + "|"+riCommTag+"|";
		return str;
	}

	function giacCollectionDetail() {
		var str = '';

		$$("div[name='rowItem']").each(
				function(row) {
					if(row.down("input", 21).value != 3){
						var itemNo = row.down("input", 0).value;
						var payMode = row.down("input", 1).value;
						var bankName = row.down("input", 2).value;
						var checkClass = row.down("input", 3).value;
						var checkCreditNo = row.down("input", 4).value == "" ? " " : escapeBackSlashAndComma(escapeHTML2(row.down("input", 4).value)); //added escape by robert
						var checkDate = row.down("input", 5).value == "" ? '-'
								: row.down("input", 5).value;
	 					//var localCurrAmt = row.down("input", 6).value.replace(/,/g, "") == "" ? "0" : row.down("input", 6).value.replace(/,/g, "");
						var localCurrAmt = row.down("label", 6).innerHTML.replace(/,/g, "") == "" ? "0" : row.down("label", 6).innerHTML.replace(/,/g, "");
						var currency = row.down("input", 7).value;
						var bank = row.down("input", 8).value;
						var particulars = row.down("input", 9).value == "" ? " "
								: escapeBackSlashAndComma(escapeHTML2(row.down("input", 9).value)); // added by robert 10.09.2013 
						var grossAmt = row.down("input", 10).value
								.replace(/,/g, "") == "" ? "0" : row.down("input",
								10).value.replace(/,/g, "");
						var deductionComm = row.down("input", 11).value.replace(
								/,/g, "") == "" ? "0" : row.down("input", 11).value
								.replace(/,/g, "");
						var vatAmount = row.down("input", 12).value.replace(/,/g,
								"") == "" ? "0" : row.down("input", 12).value
								.replace(/,/g, "");
						var fcGrossAmt = row.down("input", 13).value.replace(/,/g,
								"") == "" ? "0" : row.down("input", 13).value
								.replace(/,/g, "");
						var fcCommAmt = row.down("input", 14).value.replace(/,/g,
								"") == "" ? "0" : row.down("input", 14).value
								.replace(/,/g, "");
						var fcTaxAmt = row.down("input", 15).value
								.replace(/,/g, "") == "" ? "0" : row.down("input",
								15).value.replace(/,/g, "");
						var fcNetAmt = row.down("input", 16).value
								.replace(/,/g, "") == "" ? "0" : row.down("input",
								16).value.replace(/,/g, "");
						var currRt = row.down("input", 17).value;
						var dcbBankCd = row.down("input", 18).value;
						var dcbBankAcctCd = row.down("input", 19).value;
						var bankCd = row.down("input", 20).value;
						var cmTranId = row.down("input", 23).value;
						var pdcItemId = row.down("input", 24).value; //john 12.8.2014
						str += '0' + "|" + itemNo + "|" + currency + "|" + currRt
								+ "|" + payMode + "|" + localCurrAmt + "|"
								+ checkDate + "|" + checkCreditNo + "|"
								+ particulars + "|" + bankCd + "|" + checkClass
								+ "|" + fcNetAmt + "|" + grossAmt + "|"
								+ deductionComm + "|" + vatAmount + "|"
								+ fcGrossAmt + "|" + fcCommAmt + "|" + fcTaxAmt
								+ "|" + dcbBankCd + "|" + dcbBankAcctCd + "|"+ cmTranId + "|"
								+ pdcItemId + "|"; //john 12.8.2014
					}
				});
		return str;
	}
	
	observeReloadForm("reloadForm", function() {
		if(objACGlobal.gaccTranId == "" || objACGlobal.gaccTranId == null) {
			createORInformation(objACGlobal.branchCd);
		} else {
			editORInformation();
		}
	});
	
	/* $("reloadForm").observe("click", function() {
		if(objACGlobal.gaccTranId == "" || objACGlobal.gaccTranId == null) {
			createORInformation(objACGlobal.branchCd);
		} else {
			editORInformation();
		}
	});  */
	
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();	
	
	setCursor("default");
	changeTag = 0;
	initializeEnabledDisabledProperties();
	initializeAllMoneyFields();
	/* initializeChangeTagBehavior(saveOR); 
	initializeChangeAttribute(); */
	
	//added by: kenneth for OR Status 03.08.2013
	function goToOrStatus(){
		//updateMainContentsDiv("/GIACInquiryController?action=showOrStatus", "Retrieving OR data, please wait..."); kenneth 01.14.2014
		objGiacs235.updateOrStatus(); //kenneth 01.14.2014
		$("acExit").stopObserving("click");
		$("acExit").observe("click", function(){
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		});
		objAC.showOrDetailsTag = null;
		objAC.butLabel = null;
		
	}
	
	// andrew - 08.14.2012
	function disableGIACS001(){
		try {
			//setDocumentTitle("Cancel OR"); commented out by christian 09182012
			$("remittance").writeAttribute("readonly");
			disableDate("hrefRemitDate");
			$("provReceiptNo").writeAttribute("readonly");		
			$("payorName").writeAttribute("readonly");
			$("payorName").removeClassName("required");
			$("payorNameDiv").removeClassName("required");
			disableSearch("oscmPayor");
			$("orDate").removeClassName("required");
			$("payorParticulars").writeAttribute("readonly");
			$("payorParticulars").removeClassName("required");
			$("payorParticularsDiv").removeClassName("required");
			$("gross").disable();
			$("net").disable();
			$("riCommTag").disable(); // added by: Nica 06.14.2013
			$("dcbBankName").disable();
			$("dcbBankName").removeClassName("required");
			$$("select[name='dcbBankAccountNo']").each(function(sel){
				sel.disable();
				sel.removeClassName("required");			
			});		
			
			$("paymentMode").disable();
			$("paymentMode").removeClassName("required");
			disableButton("btnAdd");
			$("intermediary").disable();
			$("payorTinNo").writeAttribute("readonly");
			$("payorAddress1").writeAttribute("readonly");
			$("payorAddress2").writeAttribute("readonly");
			$("payorAddress3").writeAttribute("readonly");
			$("particular").writeAttribute("readonly");
			disableButton("btnSave");
			$("orPrefSuf").readOnly = true; //Deo [02.16.2017]: SR-5932
			$("orNo").readOnly = true; 		//Deo [02.16.2017]: SR-5932
		} catch(e){
			showErrorMessage("disableGIACS001", e);
		}
	}
	//added cancelOtherOR by robert 10302013
	if(objAC.fromMenu == "cancelOR" || objAC.fromMenu == "cancelOtherOR" || objAC.tranFlagState == "C" || objACGlobal.queryOnly == "Y"){
		disableGIACS001();
	} else {
		initializeChangeTagBehavior(saveOR); 
		initializeChangeAttribute();
		objAC.showOrDetailsTag = null;
		objAC.butLabel = null;
	}
	
	if (objACGlobal.previousModule == "GIACS230"){
		$("acExit").show();
	}
	
	function giacOrRel(){
		var obj = {};
		if ($F("canPrefSuf") != ""){
			obj.tranId = objACGlobal.gaccTranId;
			obj.newOrTag = objACGlobal.orTag;
			obj.oldTranId = objGiacOrRel.gaccTranId;
			obj.oldOrDate = objGiacOrRel.orDate;
			obj.oldOrPrefSuf = objGiacOrRel.orPrefSuf;
			obj.oldOrNo = objGiacOrRel.orNo;
			obj.oldOrTag = objGiacOrRel.orTag;
			obj.newOrNo = $F("orNo");
			obj.newOrPrefSuf = $F("orPrefSuf");
		}
		
		return obj;
	}
	
	//john dolon 6.4.2015; For disabling of fields for APDC
	function disableGIACS001ForAPDC(){
		try {
			$("remittance").writeAttribute("readonly");
			disableDate("hrefRemitDate");
			$("provReceiptNo").writeAttribute("readonly");		
			$("payorName").writeAttribute("readonly");
			$("payorName").removeClassName("required");
			$("payorNameDiv").removeClassName("required");
			disableSearch("oscmPayor");
			$("orDate").removeClassName("required");
			$("payorParticulars").writeAttribute("readonly");
			$("payorParticulars").removeClassName("required");
			$("payorParticularsDiv").removeClassName("required");
			$("gross").disable();
			$("net").disable();
			$("riCommTag").disable();
			$("intermediary").disable();
			$("payorTinNo").writeAttribute("readonly");
			$("payorAddress1").writeAttribute("readonly");
			$("payorAddress2").writeAttribute("readonly");
			$("payorAddress3").writeAttribute("readonly");
			$("particular").writeAttribute("readonly");
			disableButton("btnSave");
		} catch(e){
			showErrorMessage("disableGIACS001ForAPDC", e);
		}
	}
	if((objACGlobal.orFlag == 'P'
			&& !(objAC.tranFlagState == "O" && objACGlobal.orTag == "*")) //Deo [02.10.2017]: SR-5932
			|| objACGlobal.orFlag == 'C'){
		//setEnabledDisabledProperties("disable");
		$("dcbBankName").disabled = true;
		$("dcbBankName").removeClassName("required");;
		$$("select[name='dcbBankAccountNo']").each(function (r) {
			r.disabled = true;
			r.removeClassName("required");;
		});
		$("remittance").disabled = true;
		disableDate("hrefRemitDate");
		$("provReceiptNo").disabled = true;		
		$("payorName").disabled = true;
		$("payorName").disabled = true;
		$("payorNameDiv").disabled = true;
		disableSearch("oscmPayor");
		$("orDate").disabled = true;
		$("payorName").removeClassName("required");
		$("payorNameDiv").removeClassName("required");
		$("orDate").removeClassName("required");
		$("payorParticulars").removeClassName("required");
		$("payorParticularsDiv").removeClassName("required");
		$("payorParticulars").disabled = true;
		$("payorParticularsDiv").disabled = true;
		$("gross").disable();
		$("net").disable();
		$("riCommTag").disable();
		$("intermediary").disable();
		$("payorTinNo").disabled = true;
		$("payorAddress1").disabled = true;
		$("payorAddress2").disabled = true;
		$("payorAddress3").disabled = true;
		$("particular").disabled = true;
		$("paymentMode").removeClassName("required");
		$("currRt").removeClassName("required");
		$("bank").removeClassName("required");
		$("checkClass").removeClassName("required");
		disableDate("hrefCheckDate");
		$("localCurrAmt").removeClassName("required");
		$("currency").removeClassName("required");
		$("grossAmt").removeClassName("required");
		$("deductionComm").removeClassName("required");
		$("vatAmount").removeClassName("required");
		$("fcGrossAmt").removeClassName("required");
		$("fcCommAmt").removeClassName("required");
		$("fcTaxAmt").removeClassName("required");
		$("fcNetAmt").removeClassName("required");
		$("particular").removeClassName("required");
		$("oscmPayor").disabled = true;
		$("bank").disabled = true;
		$("checkClass").disabled = true;
		$("checkCreditCardNo").disabled = true;
		$("checkCreditCardNo").removeClassName("required");
		$("oscmCheckCredit").hide();
		disableSearch("oscmCheckCredit");
		$("credCardDiv").style.backgroundColor = $("checkCreditCardNo").getStyle('background-color').toString();
		$("oscmCheckCredit").disabled = true;
		$("checkDateCalendar").disabled = true;
		$("localCurrAmt").disabled = true;
		$("currency").disabled = true;
		$("particular").disabled = true;
		$("grossAmt").disabled = true;
		$("deductionComm").disabled = true;
		$("vatAmount").disabled = true;
		$("fcGrossAmt").disabled = true;
		$("fcCommAmt").disabled = true;
		$("fcTaxAmt").disabled = true;
		$("fcNetAmt").disabled = true;
		$("currRt").disabled = true;
		//Deo [02.10.2017]: add start (SR-5932)
		$("orPrefSuf").readOnly = true;
		$("orNo").readOnly = true;
		$("orPrefSuf").removeClassName("required");
		$("orNo").removeClassName("required");
		//Deo [02.10.2017]: add ends (SR-5932)
	}
	
</script>
