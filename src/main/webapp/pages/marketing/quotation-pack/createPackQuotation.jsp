<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<input type="hidden" value="${editPackQuotation}" id="editPackQuotation" name="editPackQuotation" />
<div id="contentsDiv" style="margin-top: 1px;" >
	<div changeTagAttr="true">
	<input type="hidden" id="src" name="src" value="${src}" />
		<form id="createPackQuotationForm">
			<input id="mortgTag" name="mortgTag" type="hidden"/>
			<input id="mortgChanges" name="mortgChanges" type="hidden"/>
			<input id="lineCd" 		name="lineCd" 	type="hidden" value="<c:if test="${not empty gipiPackQuote}">${gipiPackQuote.lineCd}</c:if><c:if test="${not empty lineCd}">${lineCd}</c:if>" />
			<input id="lineName" 	name="lineName" type="hidden" value="<c:if test="${not empty gipiPackQuote}">${gipiPackQuote.lineName}</c:if><c:if test="${not empty lineName}">${lineName}</c:if>" />
			<input id="packQuoteId" name="packQuoteId" value="${gipiPackQuote.packQuoteId}" type="hidden"/>
			<input id="ora2010Sw" name="ora2010Sw" type="hidden" value="${ora2010Sw}" />
			<jsp:include page="/pages/marketing/quotation-pack/subPages/packQuotationInformation.jsp"></jsp:include>
			<jsp:include page="/pages/marketing/quotation-pack/subPages/poi.jsp"></jsp:include>
			<jsp:include page="/pages/marketing/quotation-pack/subPages/otherDetails.jsp"></jsp:include>
			<div id=quotePackMortgagee name="quotePackMortgagee" style="margin-top: 1px; display: none;"></div>
		</form>
	</div>
	<div class="buttonsDiv">
		<input type="button" id="btnPackLineSubline" name="btnPackLineSubline" class="disabledButton" value="Package Line/Subline" title="Package Line/Subline" disabled="disabled" style="width: 150px;" />
		<input type="button" id="btnMortgageeInformation" name="btnMortgageeInformation" class="button" value="Mortgagee" title="Mortgagee Information" style="width: 80px;" />
		<input type="button" id="btnMaintainAssured" name="btnMaintainAssured" class="button" value="Maintain Assured">
		<input type="button" class="button" id="btnMaintainReason" value="Maintain Reason" title="Maintain Reason" style="width: 120px;" />
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
<div id="packQuoteDynamicDiv" name="packQuoteDynamicDiv" style="margin-top: 1px;">
	
</div>

<script type="text/javascript">
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	changeTag = 0; // added for change tag. Irwin
	disableButton("btnMaintainAssured");
	strParametersPackMortg = '';
	var onExit = false;	//Gzelle 12.11.2013
	if ($F("editPackQuotation") == "1") {		
		//enableButton("btnMortgageeInformation");
		enableMenu("quoteInformation"); // addedBy irwin march 3, 2011
		enableButton("btnMaintainAssured");		
		enableButton("btnPackLineSubline");	
		refreshQuotationMenu(); // added by mark jm 04.14.2011 @UCPBGEN
		//updatePackQuotationParameters();
		
 	}else if($F("editPackQuotation").blank()){ 	 
 		//$("quoteInformation").addClassName("disabledButton");
 		disableMenu("quoteInformation"); // addedBy irwin march 3, 2011
 		disableMenu("bondPolicyData");
 		disableMenu("quoteCarrierInfo");
 		disableMenu("quoteEngineeringInfo");
 		enableButton("btnGenerateBankDtls");
 	 }
	if (objMKTG.giimm001QouteInfo.toPopulateQuoteInfo) {//added by steven 1/30/2013
		populateQuoteInfo(); 
		objMKTG.giimm001QouteInfo.toPopulateQuoteInfo = false;
	}
	/*
	checkIfExistingQuotations();
	function checkIfExistingQuotations(){
	};*/
	
	$("btnMortgageeInformation").observe("click", function () {
		updatePackQuotationParameters();
		new Ajax.Updater("quotePackMortgagee", contextPath+ "/GIPIQuotationMortgageeController?action=getPackQuotationMortagee", { 
			method : "GET",
			parameters : {
				packQuoteId 	: $F("packQuoteId"),
				issCd: objMKGlobal.issCd
			},
			asynchronous 	: true,
			evalScripts 	: true,
			onCreate: function() {
				showNotice("Loading Mortgagee Information, please wait...");
			},
			onComplete : function(){
				hideNotice();	
				Effect.Appear("quotePackMortgagee", {
					duration : 1
				});
			}
		}
		);
	});

	$("btnPackLineSubline").observe("click", function(){
		if (changeTag == "1"){
			showConfirmBox3("Save Changes", "The changes made must be saved first.", "Ok", "Cancel", createNewQuotation, "");
		}else{
			showPackQuoteLineSubline();
		}
	});
	
	$("btnSave").observe("click", createNewQuotation);
	
	function createNewQuotation(){
		try{
			if(validateBeforeSave()){
				savePackQuotation();
			}else{
				showMessageBox('A field may have been invalid.', imgMessage.ERROR);
			}
		}catch(e){
			showErrorMessage("createNewQuotation", e);
		}		
	}
	
	function savePackQuotation(){
		try{
			new Ajax.Updater("mkQuotationParameters", contextPath+"/GIPIPackQuoteController?action=savePackQuotation&accountOfSW=" + objGIIMM001A.chkboxSW,{
				method: "POST",
				evalScripts: true,
				asynchronous: false,
				postBody: Form.serialize("createPackQuotationForm")+"&prorateFlag="+$("prorateFlag").value,
				onCreate: function() {
					showNotice("Saving Package Quotation, please wait...");
					$("createPackQuotationForm").disable();
				},
				onComplete: function(response){
					if (checkErrorOnResponse(response)){
						hideNotice(response.responseText);
						//updatePackQuotationParameters();		
						$("createPackQuotationForm").enable();
						//$("quotationNo").value = $F("quoteNo");objMKGlobal.quotationNo
						//$("quotationNo").value =objMKGlobal.quotationNo;
						$("mkQuotationParameters").update(response.responseText);
						if ($F("editPackQuotation")!='1'){
							var sublineName = $("subline").options[$("subline").selectedIndex].text;
							var issName = $("issSource").options[$("issSource").selectedIndex].text; //marco - 04.22.2013
							changeContainers("text");
							$("packQuoteId").value = $("globalPackQuoteId").value; //added by: nica 05.30.2012 - to assign value for packQuoteId when quotation is newly created
							$("quotationNo").value = formatNumberDigits($("globalQuotationNo").value, 6);
							$("subline").value = sublineName;
							$("issSource").value = issName;
						}
						$("editPackQuotation").value ='1';
						//enableButton("btnMortgageeInformation");
						enableMenu("quoteInformation"); 
						enableButton("btnMaintainAssured");		
						enableButton("btnPackLineSubline");	
						if($F("mortgTag") == "Y"){ // CHECKS IF THE MORTGAGEE PANEL IS LOADED
							if($F("mortgChanges") == "Y"){ // to prevent saving of mortgagee to continue if the mortgagee section is loaded and no changes have been made to the mortgagee/s
								savePackQuotationMortgagee();
							}else{
								//showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
								showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
									if (onExit) {
										creationPackQuotationFromListing();
									}
								});
							}
						}else{
							//showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
							showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
								if (onExit) {
									creationPackQuotationFromListing();
								}
							});
						}
						changeTag=0;
						$("createPackQuotationForm").enable();
						//marco - 04.22.2013 - added ternary operator
						//$("issSource").value = nvl(objMKGlobal.issName, "") == "" ? issName : objMKGlobal.issName; //added by steven 10/31/2012
					}else{
						showMessageBox(response.responseText, imgMessage.ERROR);
						$("createPackPARForm").enable();
					}
				}
			});
		}catch(e){
			showErrorMessage("savePackQuotation", e);
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
			$('subline').focus();
			showMessageBox(objCommonMessage.REQUIRED, imgMessage.INFO);
		}else if($F("issSource")=="" || $F("issSource").empty()){
			result = false;
			$('issSource').focus();
			showMessageBox(objCommonMessage.REQUIRED, imgMessage.INFO);
		} else if ($F('validDate')=='' || $F("validDate").empty()) {
			result = false;
			$('validDate').focus();
			showMessageBox(objCommonMessage.REQUIRED, imgMessage.INFO);
		} else if ($F("editPackQuotation").blank() && Math.ceil((eff-today)/1000/24/60/60)<30){ // nilagyan ng addtl condition para pag edit di mag-error
			result = false;
			showMessageBox('Validity date should be at least 30 days after system date.', imgMessage.ERROR);
			$('validDate').focus();
		} /*else if ($F('assuredName')=='' || $F('assuredName').empty()){   // removed by Irwin.
			result = false;
			$F('assuredName').focus;
			showMessageBox('Assured Name is Required.', imgMessage.ERROR);		
		} */else if ($F('doi')=='' || $F('doi').empty()) {
			result = false;
			$('doi').focus();
			showMessageBox(objCommonMessage.REQUIRED, imgMessage.INFO);
		} else if ($F('doe')=='') {
			result = false;
			$('doe').focus();
			showMessageBox(objCommonMessage.REQUIRED, imgMessage.INFO);
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
		} else if ($F('prorateFlag')=='3' && (	$F('shortRatePercent') == '' || 
												$F("shortRatePercent").blank()/* ||
												parseFloat($F('shortRatePercent')) <= 0 || 
												parseFloat($F('shortRatePercent')) > 100*/)) {
			result = false;
			$('shortRatePercent').focus();
			
			showMessageBox(objCommonMessage.REQUIRED, imgMessage.INFO);

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
		}*/
		
		return result;
	}

	$$("select").each(function (s) {
		s.setStyle("padding: 3px;");
	});

	$$(".rightAligned").each(function (td)	{
		td.setStyle("text-align: right; padding-right: 5px;");
	});
	
	
	<c:choose>
		<c:when test="${not empty gipiPackQuote}">
			$("reloadForm").observe("click", function ()	{
				editPackQuotation($F("lineName"),$F("lineCd"),$F("packQuoteId"));
			});
		</c:when>
		<c:otherwise>
			$("reloadForm").observe("click", function ()	{
				//observeReloadForm("reloadForm", createPackQuotation); Gzelle 12.11.2013
				if(changeTag == 1) {
					showConfirmBox("Confirmation", objCommonMessage.RELOAD_WCHANGES, "Yes", "No",
							createPackQuotation, "");
				} else {
					createPackQuotation();
				}
			});
		</c:otherwise>
	</c:choose>

	$("validDate").setStyle("border: none; width: 148px; margin: 0;");
	$("validDate").up("div", 0).setStyle("border: 1px solid gray; background-color: #fff; padding: 0; width: 176px;");

	//$("btnMaintainAssured").observe("click", function () {
	observeAccessibleModule(accessType.BUTTON, "GIISS006B", "btnMaintainAssured", function() {	
		maintainAssured("contentsDiv", $F("assuredNo"));
	});

	observeAccessibleModule(accessType.BUTTON, "GIISS204", "btnMaintainReason", showMaintainReasonFormTableGrid);

	checkRequiredSelect();

	$("assuredName").setStyle("border: none; float: left;");
	$("editHeader").observe("click", function(){
		showOverlayEditor("header", 2000, $("header").hasAttribute("readonly"));
	});

	$("editFooter").observe("click", function(){
		showOverlayEditor("footer", 2000, $("footer").hasAttribute("readonly"));
	});
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("remarks", 4000, $("remarks").hasAttribute("readonly"));
	});	

	$("btnCancel").observe("click", function () {
		var src = $F("src");
		//checkChangeTagBeforeCancel();
		//added change tag function - irwin
		if(changeTag == 1) {
			onExit = true;
			if (changeTagFunc == null || changeTagFunc == undefined || changeTagFunc == ""){
				changeTag = 0;
				changeTagFunc = "";
			}else{
				showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
						function(){
							//changeTagFunc(); 
							createNewQuotation();
							if (changeTag == 0){
								changeTagFunc = "";
							}
							changeTag = 0;
						}, 
						function(){
							changeTag = 0;
							changeTagFunc = "";

							if (src == "") {
								creationPackQuotationFromListing();
								onExit = false;
							} else {
								onExit = false;
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
				clearPackQuotationParameters();
				creationPackQuotationFromListing();
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
	function checkPackQuotationSize(){
		if (objGIPIPackQuotations.size() == 0) {
			disableButton("btnMortgageeInformation");
		}
	}
	setTimeout(checkPackQuotationSize, 200);
	
	
	initializeChangeTagBehavior(createNewQuotation); // added by irwin
	$("gimmExit").stopObserving("click"); // andrew - 02.09.2012
	$("gimmExit").observe("click", function(){
		if (changeTag == 1) {
			onExit = true;
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", createNewQuotation, function() {
				changeTag = 0;
				creationPackQuotationFromListing();
			},"");
		}else {
			creationPackQuotationFromListing();
		}
	});
	
</script>