<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" %>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<%	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="packQuotationInformationMainDiv" name="packQuotationInformationMainDiv" style="display: none">
	<jsp:include page="/pages/marketing/quotation-pack/packQuotationCommon/packQuotationInfoHeader.jsp"></jsp:include>
	<jsp:include page="/pages/marketing/quotation-pack/quotationInformation-pack/subPages/packSubQuoteListing.jsp"></jsp:include>
	<jsp:include page="/pages/marketing/quotation-pack/quotationInformation-pack/subPages/quotationItemInformation.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv" class="optionalInformation additionalInformation">	
		<div id="innerDiv" name="innerDiv">
	   		<label>Additional Information</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id='additionalInfoAccordionLbl' class='accordionLabel'>Show</label>
	   		</span>
	</div></div>

	<div id="additionalInformationMotherDiv" name="additionalInformationMotherDiv" class="optionalInformation additionalInformation">
		<jsp:include page="/pages/marketing/quotation-pack/quotationInformation-pack/subPages/packAdditionalInformation.jsp"></jsp:include>
	</div>
	
	<jsp:include page="/pages/marketing/quotation-pack/quotationInformation-pack/subPages/quotationPerilInformation.jsp"></jsp:include>
	
	<div id="outerDiv" name="outerDiv" class="optionalInformation deductibleInformation">	
		<div id="innerDiv" name="innerDiv">
	  		<label>Deductible Information </label>
	   		<span class="refreshers" style="margin-top: 0;">
	   			<label id='deductibleAccordionLbl' class='accordionLabel'>Show</label>
	   		</span>
	</div></div>
	<div id="deductibleInformationMotherDiv" name="deductibleInformationMotherDiv" class="optionalInformation deductibleInformation"></div>			

	<div id="outerDiv" name="outerDiv" class="optionalInformation mortgageeInformation">	
		<div id="innerDiv" name="innerDiv">
	   		<label>Mortgagee Information </label>
	   		<span class="refreshers" style="margin-top: 0;">
	   			<label id='mortgageeAccordionLbl' class='accordionLabel'>Show</label>
	   		</span>
		</div>
	</div>
	<div id="mortgageeInformationMotherDiv"  name="mortgageeInformationMotherDiv" class="optionalInformation mortgageeInformation">	</div>
	
	<div id="outerDiv" name="outerDiv" class="optionalInformation invoiceInformation">
		<div id="innerDiv" name="innerDiv">
	   		<label>Invoice Information </label>
	   		<span class="refreshers" style="margin-top: 0;">
	   			<label id="invoiceAccordionLbl" class='accordionLabel'>Show</label>
	   		</span>
		</div>
	</div>
	<div id="invoiceInformationMotherDiv" name="invoiceInformationMotherDiv" class="optionalInformation invoiceInformation"> </div>
	
	<!-- <div id="outerDiv" name="outerDiv" class="optionalInformation attachedMedia">	
		<div id="innerDiv" name="innerDiv">
			<label>Attached Media</label>
	  		<span class="refreshers" style="margin-top: 0;">
		  		<label id='mediaAccordionLbl'  class='accordionLabel'>Show</label>
	  		</span>
		</div>
	</div>
	<div id="attachedMediaMotherDiv" name="attachedMediaMotherDiv" class="optionalInformation attachedMedia"></div> -->
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnAttachMedia" name="btnAttachMedia" value="Attach Media" /> <!-- SR-5931 JET FEB-9-2017 -->
	<input type="button" class="button" id="btnEditQuotation" name="btnEditQuotation" value="Edit Package Quotation" />
	<input type="button" class="button" id="btnSaveQuotation" name="btnSaveQuotation" value="Save" />
	<input type="button" class="disabledButton" id="btnPrintQuotation" name="btnPrintQuotation" value="Print" disabled="disabled" style="display:none;"/>
</div>	

<script type="text/javascript">
	hideNotice();
	setModuleId("GIIMM002");
	changeTag = 0;
	objCurrPackQuote = null;
	objPackQuoteDeductiblesList = null;
	objPackQuoteMortgageeList = null;
	objPackQuoteInvoiceList = null;

	objPackQuoteList = JSON.parse('${objPackQuoteList}'.replace(/\\/g, '\\\\'));
	objPackQuoteItemList = JSON.parse('${objPackQuoteItemList}'.replace(/\\/g, '\\\\'));
	objPackQuoteLines = JSON.parse('${objPackLines}'.replace(/\\/g, '\\\\'));

	for(var i=0; i<objPackQuoteLines.length; i++){
		if(objPackQuoteLines[i].lineCd == "MC" || objPackQuoteLines[i].menuLineCd == "MC"){
			var objMotorTypeLOV = JSON.parse('${allMotorTypesLOV}'.replace(/\\/g, '\\\\'));
			var objSublineTypesLOV = JSON.parse('${allSublineTypesLOV}'.replace(/\\/g, '\\\\'));
			setPackMotorTypesLOV(objMotorTypeLOV);
			setPackSublineTypesLOV(objSublineTypesLOV);
			break;
		}
	}
	
	loadPackQuoteDeductibleSubpage();
	loadPackQuoteInvoiceSubpage();
	showQuoteItemList(objPackQuoteItemList);
	setQuoteItemInfoForm(null);
	showPackQuoteAccordionHeaders();
	observePackQuoteChildRecords();

	observeReloadForm($("reloadForm"), showPackQuotationInformation);
	
	$$("div[name='quoteRow']").each(function(row){
		setPackQuoteListRowObserver(row);
		var lineCd = row.getAttribute("lineCd");
		var menuLineCd = row.getAttribute("menuLineCd");
		var quoteId = row.getAttribute("quoteId");
		
		if(lineCd == "MH" || menuLineCd == "MH"){
			checkIfQuoteVesAirRecExist(quoteId, row);
		}else if(lineCd == "MN" || menuLineCd == "MN"){
			checkIfQuoteVesAirRecExist(quoteId, row);
			setPackGeogDescLOV(quoteId);
			setPackCarrierLOV(quoteId);
		}	
	});

	$("btnSaveQuotation").observe("click", function(){
		if(changeTag == 0){
			showMessageBox(objCommonMessage.NO_CHANGES, imgMessage.INFO);
		}else{
			savePackageQuotation();
		}
	});

	$("btnEditQuotation").observe("click", function(){
		function goToBasicQuotationInfo(){
			editPackQuotation(objMKGlobal.lineName, objMKGlobal.lineCd, objMKGlobal.packQuoteId);
		}
		if(changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", savePackageQuotation, goToBasicQuotationInfo, "");
		}else{
			goToBasicQuotationInfo();
		}
	});

	$("additionalInfoAccordionLbl").observe("click", function(){
		var lineCd = objCurrPackQuote.lineCd;
		var menuLineCd = objCurrPackQuote.menulineCd;

		if(lineCd=="SU" || menuLineCd=="SU" ){
			showMessageBox("Additional Information is disabled in this line.", imgMessage.ERROR);
		}else if((lineCd=="MR" || menuLineCd=="MR" || lineCd=="MN" || menuLineCd=="MN")  //change by steven from: "MH"  to:"MR" base on SR 0011201
		 	&& getSelectedRow("quoteRow").getAttribute("isQuoteVesAirExist") == "N"  
			&& $("additionalInfoAccordionLbl").innerHTML == "Show"){
			showWaitingMessageBox("Carrier Information should be entered first.", imgMessage.INFO,function(){
																												if(changeTag == 1){
																													showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", savePackageQuotation, showPackCarrierInfoPage, "");
																												}else{
																													showPackCarrierInfoPage();
																												}
																											}); //added by steven 11/8/2012 - "showPackCarrierInfoPage" para mapunta sa Carrier Info na page
		}else{
			observePackQuoteSubpages("additionalInfoAccordionLbl", "additionalInformationMotherDiv");
		}
	});

	$("deductibleAccordionLbl").observe("click", function(){
		observePackQuoteSubpages("deductibleAccordionLbl", "deductibleInformationMotherDiv");
	});

	$("mortgageeAccordionLbl").observe("click", function(){
		if($("addMortgageeForm")==null){	
			loadPackQuoteMortgageeSubpage();
		}
		observePackQuoteSubpages("mortgageeAccordionLbl", "mortgageeInformationMotherDiv");
	});

	$("invoiceAccordionLbl").observe("click", function(){
		var selectedItem = getSelectedRow("row").getAttribute("itemNo");
		
		if(!checksIfQuoteItemHasPerils(objCurrPackQuote.quoteId, selectedItem)){
			showMessageBox("Item has no perils.", imgMessage.ERROR);
		}else if(quotePerilChangeTag == 1){	
			showMessageBox("Records has been updated. Please save changes first.", imgMessage.INFO);
		}else{
			observePackQuoteSubpages("invoiceAccordionLbl", "invoiceInformationMotherDiv");
		}
	});

	// SR-5931 JET FEB-9-2017
	/* $("mediaAccordionLbl").observe("click", function(){
		if($("attachedMediaForm")==null){	
			loadPackQuoteAttachedMediaSubpage();
		}
		observePackQuoteSubpages("mediaAccordionLbl", "attachedMediaMotherDiv");
	}); */
	
	$("btnAttachMedia").observe("click", function() {
		if (getSelectedRow("row") != null) {
			var quoteId = getSelectedRow("row").getAttribute("quoteId");
			var itemNo = getSelectedRow("row").getAttribute("itemNo");
			
			if (checksIfQuoteItemHasPerils(quoteId, itemNo)) {
				openAttachMediaOverlay2("packQuotation", quoteId, itemNo);
			} else {
				showMessageBox("Item has no perils.");
			}
		} else {
			showMessageBox("Please select an item.");
		}
	});

	initializeChangeTagBehavior(savePackageQuotation);
	
	var fromCreatePackQuote = nvl('${fromCreatePackQuote}', 'N');
	$("gimmExit").stopObserving("click"); // andrew - 02.09.2012
	$("gimmExit").observe("click", function(){
		//showPackQuotationListing(); - marco - 06.25.2012
		//objQuote.fromGIIMM001A == "Y" ? showCreatePackQuoteFromQuoteInfo() : showPackQuotationListing();
		fromCreatePackQuote == "Y" ? showCreatePackQuoteFromQuoteInfo() : showPackQuotationListing();
	});
</script>