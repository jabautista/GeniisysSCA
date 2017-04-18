<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<input type="hidden" value="${editQuotation}" id="isEditQuotation" name="isEditQuotation" />
<input type="hidden" id="allowMultipleAssuredSw" value="false"></input>
<div id="contentsDiv" style="margin-top: 1px;" >
	<div changeTagAttr="true">
		<input type="hidden" id="src" name="src" value="${src}" />
		<form id="createQuotationForm" name="createQuotationForm">
			<input id="userId" 		name="userId" 	type="hidden" value="${USER.userId}" />
			<input id="quoteId" 	name="quoteId" 	type="hidden" value="${gipiQuote.quoteId}" />
			<input id="lineCd" 		name="lineCd" 	type="hidden" value="<c:if test="${not empty gipiQuote}">${gipiQuote.lineCd}</c:if><c:if test="${not empty lineCd}">${lineCd}</c:if>" />
			<input id="lineName" 	name="lineName" type="hidden" value="<c:if test="${not empty gipiQuote}">${gipiQuote.lineName}</c:if><c:if test="${not empty lineName}">${lineName}</c:if>" />
			<input id="issCd" 	name="issCd" type="hidden" value="<c:if test="${not empty gipiQuote}">${gipiQuote.issCd}</c:if><c:if test="${not empty issCd}">${issCd}</c:if>" />
			<input id="quoteItemExist" name="quoteItemExist" value="${quoteItemExist}"  type="hidden"/>
			<input id="vSelInsp" name="vSelInsp" value="${vSelInsp}" type="hidden" />
		    <jsp:include page="/pages/marketing/quotation/subPages/quotationInformation1.jsp"></jsp:include>
			<jsp:include page="/pages/marketing/quotation/subPages/poi.jsp"></jsp:include>
			<jsp:include page="/pages/marketing/quotation/subPages/quotationDeductibles.jsp"></jsp:include> <!--nieko 02262016 UW-SPECS-2015-086 Quotation Deductibles -->
			<jsp:include page="/pages/marketing/quotation/subPages/otherDetails.jsp"></jsp:include>
			<div id="quoteMortgagee" name="quoteMortgagee" style="margin-top: 1px; display: none;"></div>
		</form>
	</div>
	<div class="buttonsDiv">
		<input type="button" id="btnMortgageeInformation" name="btnMortgageeInformation" class="disabledButton" value="Mortgagee" title="Mortgagee Information" style="width: 80px;" />
		<input type="button" id="btnMaintainAssured" name="btnMaintainAssured" class="button" value="Maintain Assured">
		<input type="button" class="button" id="btnMaintainReason" value="Maintain Reason" title="Maintain Reason" style="width: 120px;" />
		<input type="button" class="button" id="btnSelectInspection" value="Select Inspection" title="Select Inspection" style="width: 120px;" />
		<input type="button" id="btnCancel" name="btnCancel" class="button" title="Cancel" value="Cancel" style="width: 80px;" />
		<input type="button" class="button" id="btnSave" name="btnSave" title="Save" value="Save" style="width: 80px;" />
	</div>
</div>
<div style="display: none;"> <!-- trick for errorMessage - whofeih -->
	<div id="errorMessage"><label></label></div>
</div>
<div id="quoteIdDiv" name="quoteIdDiv" style="display: none;">

</div>

<div id="assuredDiv" name="assuredDiv" style="margin-top: 1px; display: none;">
	
</div>

<script>
	try{		
		var quoteId = '${gipiQuote.quoteId}';
		changeTag = 0; // added for change tag. Irwin
		if (objMKTG.giimm001QouteInfo.toPopulateQuoteInfo) {//added by steven 12/04/2012
			populateQuoteInfo(); 
			objMKTG.giimm001QouteInfo.toPopulateQuoteInfo = false;
		}
		saveSw = 0;
		exitCtr = 0; // by Bonok: testcase 01.02.2012
		assuredMaintainExitCtr = 0;
		disableButton("btnMaintainAssured");
		disableButton("btnSelectInspection");
		
		objMKTG.giimm001QouteInfo.reqRefNo = '${requireRefNo}'; //Added by Jerome 12.12.2016 SR 5746
		objMKTG.giimm001QouteInfo.genBankRefNoTag = 'N'; //Added by Jerome 12.12.2016 SR 5746

		var inspExists = parseInt('${inspExists}') == 0 ? "N" : "Y";
		if($F("lineCd") == 'FI' && $F("quoteItemExist") == 'N' && $F("vSelInsp") == "Q" && inspExists == "Y"){
			enableButton("btnSelectInspection");
		}
		
		$("btnSelectInspection").observe("click",function(){
			if (changeTag == 1) {
				showMessageBox("Please save changes first.", imgMessage.INFO);
			}else{
				//showInspectionList();
				showInspectionList2();
			}
		});
	
		function saveInspection(row){
			new Ajax.Request(contextPath+ "/GIPIQuotationController",{
				method: "POST",
				parameters: {
					action: "saveQuoteInspectionDetails",
					quoteId: $F("quoteId"),
					inspNo:  row.inspNo,
					itemNo:  row.itemNo,
					provinceCd: row.provinceCd,
					itemDesc: row.itemDesc,
					blockNo: row.blockNo,
					districtNo: row.districtNo,
					locRisk1: row.locRisk1,
					locRisk2: row.locRisk2,
					locRisk3: row.locRisk3
				},onCreate : function(){
					showNotice("Saving inspection details.");
				},onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){		
						showWaitingMessageBox("Inspection details saved.",imgMessage.SUCCESS, function(){
							disableButton("btnSelectInspection");
						});											
					}
				}
			});
		}
		
		function showInspectionList(){
			/* Modalbox.show(contextPath+"/GIPIQuotationController?action=showInspectionList&assdNo="+$F("assuredNo")+"&quoteId="+$F("quoteId"), {
				title: "Inspection List",
				width: 1000,
				overlayClose: false,
				asynchronous:false
				
			}); */
			
			// andrew 05.11.2012
			LOV.show({ 
				controller: "MarketingLOVController",
				urlParameters: {action : "getQuoteInpsList",
								assdNo : $F("assuredNo"),
								page : 1},
				title: "Inspection List",
				width: 900,
				height: 400,
				columnModel : [						
								{
									id : "itemNo",
									title: "",
									width: '0',
									visible: false
								},
								{
									id : "inspNo",
									title: "",
									width: '0',
									visible: false
								},
								{
									id : "assdName",
									title: "Assured Name",
									width: '200px'
								},
								{
									id : "inspName",
									title: "Inspector Name",
									width: '200px'
								},
								{
									id : "itemDesc",
									title: "Item Description",
									width: '200px'
								},
								{
									id : "province",
									title: "Province",
									width: '150px'
								},
								{
									id : "city",
									title: "City",
									width: '150px'
								},
								{
									id : "districtDesc",
									title: "District",
									width: '150px'
								},
								{
									id : "blockDesc",
									title: "Block",
									width: '150px'
								},
								{
									id : "locRisk1",
									title: "Loc Risk 1",
									width: '150px'
								},
								{
									id : "locRisk2",
									title: "Loc Risk 2",
									width: '150px'
								},
								{
									id : "locRisk3",
									title: "Loc Risk 3",
									width: '150px'
								},
								{
									id : "provinceCd",
									title: "",
									width: '0',
									visible: false
								},
								{
									id : "blockNo",
									title: "",
									width: '0',
									visible: false
								},
								{
									id : "districtNo",
									title: "",
									width: '0',
									visible: false
								},
							],
				draggable: true,
				onSelect: function(row){
					saveInspection(row);
				}
			  });
		}
		
		function showInspectionList2(){
			LOV.show({ 
				controller: "MarketingLOVController",
				urlParameters: {action : "getQuoteInspList",
								assdNo : $F("assuredNo"),
								page : 1},
				title: "Inspection List",
				width: 900,
				height: 400,
				hideColumnChildTitle: true,
				columnModel : [		
								{
									id : "inspNo",
									title: "Inspection No.",
									width: '95px'
								},
								{
									id : "inspName",
									title: "Inspector",
									width: '218px'
								},
								{
									id : "assdName",
									title: "Assured Name",
									width: '218px'
								},
								{
									id: 'locRisk',
								    title: 'Location of Risk',
								    width : '350px'
								}
							],
				draggable: true,
				onSelect: function(row){
					saveInspection2(row);
				}
			  });
		}
		
		function saveInspection2(row){
			new Ajax.Request(contextPath+ "/GIPIQuotationController",{
				method: "POST",
				parameters: {
					action: "saveQuoteInspectionDetails2",
					quoteId: $F("quoteId"),
					inspNo:  row.inspNo
				},
				onCreate: function(){
					showNotice("Saving inspection details...");
				},
				onComplete: function(response){
					copyAttachments(row); // SR-21674 JET DEC-12-2016
					hideNotice();
					if(checkErrorOnResponse(response)){		
						showWaitingMessageBox("Inspection details saved.",imgMessage.SUCCESS, function(){
							disableButton("btnSelectInspection");
						});							
					}
				}
			});
		}
		
		function copyAttachments(row) {
			new Ajax.Request(contextPath + "/GIPIQuotationController", {
				method: "POST",
				parameters: {
					action: "copyAttachments",
					lineCd: $F("lineCd"),
					quoteId: $F("quoteId"),
					inspNo: row.inspNo,
					quoteNoDisp: $F("lineCd") + "-" + $("subline").getAttribute("sublineCd") + "-" + $F("issCd") + "-" + 
								 $F("quotationYY") + "-" + $F("quotationNo") + "-" + $F("proposalNo")
				}
			});
		}
		
		// mark jm
		//$$('input[type="text"], .text').each(function (obj) {
		//	obj.setStyle("font-size: 11px; font-family: Verdana; color: #000000; border: solid 1px gray; padding: 3px;");
		//});
		
		$$("select").each(function (s) {
			s.setStyle("padding: 3px;");
		});
	
		$$(".rightAligned").each(function (td)	{
			td.setStyle("text-align: right; padding-right: 5px;");
		});
		
		function hideAll()	{
			$$(".quoteInfo").each(function (q)	{
				q.hide();
			});
		}
		
		$("btnSave").observe("click", function (){
			createNewQuotation();
		});
		
		function createNewQuotation(){
			try{
				if(validateBeforeSave()){
					saveQuotation();
				}else{
					showMessageBox('A field may have been invalid.', imgMessage.ERROR);
				}
			}catch(e){
				showErrorMessage("createNewQuotation", e);
			}		
		}
	
		function saveQuotation(){
			try{
				var sublineCd = "";
				var sublineName = "";
				
				var setRows = getAddedAndModifiedJSONObjects(tbgQuotationDeductible.geniisysRows); //nieko 02162016 UW-SPECS-2015-086 Quotation Deductibles
				var delRows = getDeletedJSONObjects(tbgQuotationDeductible.geniisysRows);		   //nieko 02162016 UW-SPECS-2015-086 Quotation Deductibles
				
				if($F("isEditQuotation")!='1'){
					sublineCd = $("subline").options[$("subline").selectedIndex].getAttribute("sublineCd");
					sublineName = $("subline").options[$("subline").selectedIndex].getAttribute("sublineName");
				}else{
					sublineCd = $("subline").getAttribute("sublineCd");
					sublineName = $("subline").getAttribute("sublineName");
				}
				
				if(sublineCd == "" || sublineCd == null){ // by bonok :: 09.17.2012 temp solution to ORA-01400: cannot insert NULL into ("CPI"."GIIS_QUOTATION_NO"."SUBLINE_CD") 
					sublineCd = $F("subline");
				}
				
				if(objMKTG.giimm001QouteInfo.genBankRefNoTag == 'N'){ //Added by Jerome 12.12.2016 SR 5746
					if(objMKTG.giimm001QouteInfo.reqRefNo == 'Y'){
						customShowMessageBox("Please provide a bank reference number for this quotation before saving.",imgMessage.ERROR,"nbtAcctIssCd");
						return false;
					}
				}
				
				new Ajax.Updater("quoteIdDiv", contextPath+'/GIPIQuotationController?action=saveQuotation&delRows=' + encodeURIComponent(prepareJsonAsParameter(delRows)) + '&setRows=' + encodeURIComponent(prepareJsonAsParameter(setRows)) + "&accountOfSW=" + objGIIMM001.chkboxSW,{ //nieko 02162016 UW-SPECS-2015-086 Quotation Deductibles 
					method: "POST",
					postBody: Form.serialize("createQuotationForm")+"&prorateFlag="+$("prorateFlag").value+
					          "&sublineName="+nvl(sublineName, "")+"&sublineCd="+encodeURIComponent(nvl(sublineCd, "")), //encodeURIComponent added by jeffdojello 10.21.2013 to handle & in subline code
					asynchronous: false,
					evalScripts: true,
					onCreate: function ()	{
						$("createQuotationForm").disable();
						showNotice("Saving, please wait...");
					},
					onComplete: function (response)	{
						try{						
							$("createQuotationForm").enable();
							if(checkErrorOnResponse(response)){		
								if ("SUCCESS" == $F("message") && $F("isEditQuotation").blank()) {								
									$("quotationNo").value = $F("quoteNo");
									$("quoteId").value = $F("generatedQuoteId");
									
									$("reloadForm").stopObserving();
									$("reloadForm").observe("click", reloadForm);
									enableMenu("quoteInformation"); // addedBy irwin march 3, 2011
									enableButton("btnMaintainAssured");
									//showNotice("Success!");
									//hideNotice(response.responseText);
									changeTag = 0;
								}						
								if ("SUCCESS" == $F("message") && $F("isEditQuotation")!='1'){
									//changeContainers("text");
									changeQuotationContainers();
									$("isEditQuotation").value = "1";
									if($F("lineCd") == 'FI' && nvl($F("quoteItemExist"), "N") == "N" && $F("vSelInsp") == "Q"){ // added condition: Nica 06.20.2012
										enableButton("btnSelectInspection");
									}
								}	
								changeTag = 0;
								//refreshQuotationMenu(); // added by mark jm 04.14.2011 @UCPBGEN
								refreshQuotationMenu2(); // by bonok :: 09.17.2012 nawawala kasi ung value ng objGIPIQuote pagka nag View Policy Information galing dun sa List of Existing Quotations/s and Policies
								objGIPIQuote.quoteId = $F("generatedQuoteId");
								if($("prorateFlag").selectedIndex == 1){//added by robert 9.20.2012
									objGIPIQuote.disableProrate(); 
								};	
								hideNotice(response.responseText);							
								//showMessageBox(objCommonMessage.SUCCESS,imgMessage.SUCCESS);
								showWaitingMessageBox(objCommonMessage.SUCCESS,imgMessage.SUCCESS, function(){
									$("reloadForm").click();
								});
							}
						}catch(e){
							showErrorMessage("onComplete", e);
						}		
					}
				});
			}catch(e){
				showErrorMessage("saveQuotation", e);
			}		
		}
		
		function validateBeforeSave(){
			var result = true;
			var today = new Date();
			var eff = makeDate($F("validDate"));
			var incept = makeDate($F("doi"));
			var exp = makeDate($F("doe"));
			
			if(changeTag == 0){
				showMessageBox("No changes to save.", imgMessage.INFO);
				return false;
			}else if($F("subline")=="" || $F("subline").empty()){
				result = false;
				showWaitingMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, function(){
					$('subline').focus();	
				});
			} else if ($F('validDate')=='' || $F("validDate").empty()) {
				result = false;
				$('validDate').focus();
				showMessageBox('Validity date is required.', imgMessage.ERROR);
			} else if ($F("quotationNo").blank() && Math.ceil((eff-today)/1000/24/60/60)<30){ // nilagyan ng addtl condition para pag edit di mag-error
				result = false;
				showMessageBox('Validity date should be at least 30 days after system date.', imgMessage.ERROR);
				$('validDate').focus();
			} /*else if ($F('assuredName')=='' || $F('assuredName').empty()){   // removed by Irwin.
				result = false;
				$F('assuredName').focus;
				showMessageBox('Assured Name is Required.', imgMessage.ERROR);		
			} */else if ($F('doi')=='' || $F('doi').empty()) {
				result = false;
				showWaitingMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, function(){
					$('doi').focus();
				});
			} else if ($F('doe')=='') {
				result = false;
				showWaitingMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, function(){
					$('doe').focus();
				});
			} /*else if (incept<today) {
				result = false;
				$('doi').focus();
				showMessageBox('Incept date must not be earlier than system date.', imgMessage.ERROR); // removed. - Irwin
			} */else if (exp<incept) {
				result = false;
				$('doe').focus();
				showMessageBox('Expiry date must not be earlier than or equal to incept date.', imgMessage.ERROR);
			} else if ($F('prorateFlag')=='1' && parseInt($F('noOfDays')) < 0) {
				result = false;
				$('noOfDays').focus();
				showMessageBox('Tagging of -1 day will result to invalid no. of days. Changing is not allowed.', imgMessage.ERROR);			
			} else if ($F('prorateFlag')=='1' && isNaN($F("noOfDays"))) {
				result = false;
				$('noOfDays').focus();
				showMessageBox('Invalid No. of Days', imgMessage.ERROR);			
			} else if ($F('prorateFlag')=='1' && $F("noOfDays") > 9999){
				result = false;
				$('noOfDays').focus();
				showMessageBox('Entered pro-rate number of days is invalid. Entered value should not result to a year greater than 9999.', imgMessage.ERROR);
			} else if ($F('prorateFlag')=='3' && (	$F('shortRatePercent') == '' || 
													$F("shortRatePercent").blank()/* ||
													parseFloat($F('shortRatePercent')) <= 0 || 
													parseFloat($F('shortRatePercent')) > 100*/)) {
				result = false;
				$('shortRatePercent').focus();
				
				showMessageBox('Short Rate Percent is required.', imgMessage.ERROR);
	
				$("shortRatePercent").value = '';
			} else if ($F('prorateFlag')=='3' &&  (parseFloat($F('shortRatePercent')) <= 0 || 
													parseFloat($F('shortRatePercent')) > 100)) {
				result = false;
				$('shortRatePercent').focus();
				
				showMessageBox('Entered short rate percent is invalid. Valid value is from 0.000000001 to 100.000000000.', imgMessage.ERROR);
				
				$("shortRatePercent").value = '';
			} else if($F("prorateFlag")=='3' && isNaN($F("shortRatePercent"))){
				showMessageBox('Invalid Short Rate Percent. Value must range from 0.000000001% - 100.000000000%.', imgMessage.ERROR);
			} /*else if(!checkAssdExistsList()){//added to check if there is an existing policy with same assured BJGA 01.06.2011
				result = false;
				$F('assuredName').focus;
			} moved the validation on the field itself. - irwin */
			
			return result;
		}
		
		function refreshQuotationMenu2(){
			try{
				var lineCd = $F("lineCd");
				(lineCd == "MN" /*|| lineCd == "MH"*/) ? enableMenu("quoteCarrierInfo") : disableMenu("quoteCarrierInfo"); // MH line commented by: Nica 06.19.2012
				(lineCd == "SU" || objUWGlobal.menuLineCd == "SU") ? enableMenu("bondPolicyData") : disableMenu("bondPolicyData");
				(lineCd == "EN") ? enableMenu("quoteEngineeringInfo") : disableMenu("quoteEngineeringInfo");
			}catch(e){
				showErrorMessage("refreshQuotationMenu2", e);
			}
		}
	
		$("btnMortgageeInformation").observe("click", function () {
			new Ajax.Updater("quoteMortgagee", contextPath+ "/GIPIQuotationMortgageeController?action=getQuoteMortgagee", { // leads to mortgageeinformation2.jsp
				method : "GET",
				parameters : {
					quoteId 	: $F("quoteId")
				},
				asynchronous 	: true,
				evalScripts 	: true,
				onCreate: function() {
					showNotice("Loading Mortgagee Information, please wait...");
				},
				onComplete : function(){
					/*Effect.Fade("notice", {
						duration : .3
					});*/
					hideNotice();	
					Effect.Appear("quoteMortgagee", {
						duration : 1
					});
				}
			}
			);
		});
		
		/*$("btnMortgageeInformation").observe("click", function () {
			Modalbox.show(contextPath+"/GIPIQuotationMortgageeController?action=getItemQuoteMortgagee"+
					"&quoteId="+$F("quoteId")+"&itemNo=0&ajaxModal=1",
					  {title: '<div>Mortgagee Information</div>', 
					  width: 800});
		});*/
		$("reloadForm").observe("click", function ()	{
			if (nvl(quoteId,null) != null) {
				reloadForm();
			}else{
				if(changeTag==1){
					showConfirmBox("Confirmation", objCommonMessage.RELOAD_WCHANGES, "Yes", "No", 
							function(){
								createQuotation();
								changeTag = 0;
							}, stopProcess);
				}else{
					createQuotation();
				}					
			}
		}); 

		$("btnCancel").observe("click", function () {
			var src = $F("src");
			//checkChangeTagBeforeCancel();
			//added change tag function - irwin
			if(changeTag == 1) {
				if (changeTagFunc == null || changeTagFunc == undefined || changeTagFunc == ""){
					changeTag = 0;
					changeTagFunc = "";
				}else{
					showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
							function(){
								//$("allowMultipleAssuredSw").value = "false";
								validateBeforeSave();
								changeTagFunc(); 
								saveSw = 1;
								if (changeTag == 0){
									changeTagFunc = "";
								}
								changeTag = 1;
							}, 
							function(){
								changeTag = 0;
								changeTagFunc = "";
	
								if (src == "") {
									createQuotationFromLineListing();
								} else {
									new Ajax.Updater("mainContents", src, {
										asynchronous: true,
										evalScripts: true,
										onCreate: showNotice("Getting list, please wait..."),
										onComplete: function ()	{
											hideNotice("");
											initializeAll();
											Effect.Fade($("mainContents").down("div", 0), {
												duration: .5,
												afterFinish: function () {
													Effect.Appear($("mainContents").down("div", 0), {
														duration: .3
													});
												}
											});
										}
									});
								}
								
							}, 
							"");
				}	
			}else{
				if (src == "") {
					createQuotationFromLineListing();
				} else {
					new Ajax.Updater("mainContents", src, {
						asynchronous: true,
						evalScripts: true,
						onCreate: showNotice("Getting list, please wait..."),
						onComplete: function ()	{
							hideNotice("");
							initializeAll();
							Effect.Fade($("mainContents").down("div", 0), {
								duration: .5,
								afterFinish: function () {
									Effect.Appear($("mainContents").down("div", 0), {
										duration: .3
									});
								}
							});
						}
					});
				}
				
			}
			
		});
	
		/*
		
		if (src == "") {
			createQuotationFromLineListing();
				} else {
					new Ajax.Updater("mainContents", src, {
						asynchronous: true,
						evalScripts: true,
						onCreate: showNotice("Getting list, please wait..."),
						onComplete: function ()	{
							hideNotice("");
							initializeAll();
							Effect.Fade($("mainContents").down("div", 0), {
								duration: .5,
								afterFinish: function () {
									Effect.Appear($("mainContents").down("div", 0), {
										duration: .3
									});
								}
							});
						}
					});
				}
		*/
		
		initializeAccordion();
		addStyleToInputs();
		initializeAll();
		initializeAllMoneyFields();
	
		if ($F("isEditQuotation") == "1") {		
			enableButton("btnMortgageeInformation");
			enableMenu("quoteInformation"); // addedBy irwin march 3, 2011
			enableButton("btnMaintainAssured");	
			$("allowMultipleAssuredSw").value = "true"; // Added by Bonok 12/01/11 
			//enableButton("btnGenerateBankDtls");
			refreshQuotationMenu(); // added by mark jm 04.14.2011 @UCPBGEN
	 	}else if($F("isEditQuotation").blank()){ 	 
	 		//$("quoteInformation").addClassName("disabledButton");
	 		disableMenu("quoteInformation"); // addedBy irwin march 3, 2011
	 		disableMenu("bondPolicyData");
	 		disableMenu("quoteCarrierInfo");
	 		disableMenu("quoteEngineeringInfo");
	 		disableButton("btnMortgageeInformation");
	 	 }
		
		$("validDate").setStyle("border: none; width: 148px; margin: 0;");
		$("validDate").up("div", 0).setStyle("border: 1px solid gray; background-color: #fff; padding: 0; width: 176px;");
		/* mark jm
		$("doi").setStyle("border: none; width: 150px; margin: 0;");
		$("doi").up("span", 0).setStyle("float: left; border: 1px solid gray; padding: 0; background-color: #fff; width: 178px;");
		$("doi").up("span", 0).next().setStyle("margin-left: 5px;");
	
		$("doe").setStyle("border: none; width: 150px; margin: 0;");
		$("doe").up("span", 0).setStyle("float: left; border: 1px solid gray; padding: 0; background-color: #fff; width: 178px;");
		$("doe").up("span", 0).next().setStyle("margin-left: 5px;");
		*/
	/*
		if (modules.all(function (mod) {return mod != 'GIIMM018';})) {
			$("btnMortgageeInformation").hide();
		}
	
		if (modules.all(function (mod) {return mod != 'GIISS006B';})) {
			$("btnMaintainAssured").hide();
		}*/ 
		
		//$("btnMaintainAssured").observe("click", function () {
		observeAccessibleModule(accessType.BUTTON, "GIISS006B", "btnMaintainAssured", function() {	
			exitCtr = 1;
			assuredMaintainExitCtr = 2;
			showAssuredListingTableGrid(); // by bonok - test case 01.02.2012
			//maintainAssured("contentsDiv", $F("assuredNo"));
		});
	
		//observeAccessibleModule(accessType.BUTTON, "GIISS204", "btnMaintainReason", showMaintainReasonForm);
		observeAccessibleModule(accessType.BUTTON, "GIISS204", "btnMaintainReason", showMaintainReasonFormTableGrid);
	
		checkRequiredSelect();
	
		//$("inAccountOf").setStyle("border: none; floa	t: left;"); // <-- commented by mark jm 04.09.2011
		/* //$("inAccountOf").stopObserving(); // <-- commented by mark jm 04.09.2011 */
	
		$("assuredName").setStyle("border: none; float: left;");
		//$("assuredName").stopObserving();
	
		//initializeChangeTagBehavior(createNewQuotation);
		
		//modified by jdiago 07.09.2014 replaced showEditor with showOverlayEditor
		$("editHeader").observe("click", function () {
			//showEditor("header", 2000); 
			showOverlayEditor("header", 2000, $("header").hasAttribute("readonly"));
		});
	
		$("editFooter").observe("click", function () {
			//showEditor("footer", 2000);
			showOverlayEditor("footer", 2000, $("footer").hasAttribute("readonly"));
		});
	
		$("editRemarks").observe("click", function () {
			//showEditor("remarks", 4000);
			showOverlayEditor("remarks", 2000, $("remarks").hasAttribute("readonly"));
		});
		initializeChangeTagBehavior(createNewQuotation); // added by irwin
	}catch(e){
		
	}
	
	/* $("assuredName").observe("change", function(){
		$("allowMultipleAssuredSw").value = "false";
		changeTag = 1;
	}); */
	
	$("gimmExit").stopObserving("click"); // andrew - 02.09.2012
	$("gimmExit").observe("click", function(){
		var src; 
		
		if($("src") == null)
			src = "";
		else
			src = $F("src");
		
		//checkChangeTagBeforeCancel();
		//added change tag function - irwin
		if(changeTag == 1) {
			if (changeTagFunc == null || changeTagFunc == undefined || changeTagFunc == ""){
				changeTag = 0;
				changeTagFunc = "";
			}else{
				showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
						function(){
							//$("allowMultipleAssuredSw").value = "false";
							validateBeforeSave();
							changeTagFunc(); 
							saveSw = 1;
							if (changeTag == 0){
								changeTagFunc = "";
							}
							changeTag = 1;
						}, 
						function(){
							changeTag = 0;
							changeTagFunc = "";

							if (src == "") {
								createQuotationFromLineListing();
							} else {
								new Ajax.Updater("mainContents", src, {
									asynchronous: true,
									evalScripts: true,
									onCreate: showNotice("Getting list, please wait..."),
									onComplete: function ()	{
										hideNotice("");
										initializeAll();
										Effect.Fade($("mainContents").down("div", 0), {
											duration: .5,
											afterFinish: function () {
												Effect.Appear($("mainContents").down("div", 0), {
													duration: .3
												});
											}
										});
									}
								});
							}
							
						}, 
						"");
			}	
		}else{
			if (src == "") {
				createQuotationFromLineListing();
			} else {
				new Ajax.Updater("mainContents", src, {
					asynchronous: true,
					evalScripts: true,
					onCreate: showNotice("Getting list, please wait..."),
					onComplete: function ()	{
						hideNotice("");
						initializeAll();
						Effect.Fade($("mainContents").down("div", 0), {
							duration: .5,
							afterFinish: function () {
								Effect.Appear($("mainContents").down("div", 0), {
									duration: .3
								});
							}
						});
					}
				});
			}
			
		}
		//showQuotationListing();
	});
	
	
	setDocumentTitle("Create Quotation"); // andrew - 02.23.2012 //emsy09052012 ~ edited document title
</script>