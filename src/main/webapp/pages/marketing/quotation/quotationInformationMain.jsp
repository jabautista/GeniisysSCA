<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" %>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<%	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="quotationInformationMainDiv" name="quotationInformationMainDiv" style="display: none; margin-top: 1px;" changeTagAttr="true"> <!-- Patrick - Added changeTagAttr - 02.14.2012 -->
	<form id="quotationInformationForm" name="quotationInformationForm">
		<input type="hidden" id="quoteId" name="quoteId" value=""/>
		<jsp:include page="subPages/quotationInformation2.jsp"></jsp:include>
		<input type="hidden" id="itemOpenedTag" name="itemOpenedTag" value="F"/>
		<jsp:include page="subPages/itemInformation.jsp"></jsp:include>
		<div id="otherInformationDiv" name="otherInformationDiv" style="">
			<div id="outerDiv" name="outerDiv" class="optionalInformation additionalInformation">	
				<div id="innerDiv" name="innerDiv">
			   		<label>Additional Information </label>
			   		<span class="refreshers" style="margin-top: 0;">
						<label id='additionalInfoAccordionLbl' class='accordionLabel'>Show</label>
			   		</span>
			</div></div>

			<div id="additionalInformationMotherDiv" name="additionalInformationMotherDiv" class="optionalInformation additionalInformation">
				<c:choose>
					<c:when test="${lineCd eq 'FI'}">
						<jsp:include page="/pages/marketing/quotation/subPages/quotationInformation/quoteFireItemInfoAdditional.jsp"></jsp:include>
					</c:when>
					<c:when test="${lineCd eq 'MC'}">
						<jsp:include page="/pages/marketing/quotation/subPages/quotationInformation/quoteMotorItemInfoAdditional.jsp"></jsp:include>
					</c:when>
					<c:when test="${lineCd eq 'MN' or lineCd eq 'MR'}">
						<jsp:include page="/pages/marketing/quotation/subPages/quotationInformation/marineCargoAdditionalInformation.jsp"></jsp:include>
					</c:when>
					<c:when test="${lineCd eq 'AC' or lineCd eq 'PA'}">
						<jsp:include page="/pages/marketing/quotation/subPages/quotationInformation/accidentAdditionalInformation.jsp"></jsp:include>
					</c:when>
					<c:when test="${lineCd eq 'AV'}">
						<jsp:include page="/pages/marketing/quotation/subPages/quotationInformation/aviationAdditionalInformation.jsp"></jsp:include>
					</c:when>
					<c:when test="${lineCd eq 'CA'}">
						<jsp:include page="/pages/marketing/quotation/subPages/quotationInformation/casualtyAdditionalInformation.jsp"></jsp:include>
					</c:when>
					<c:when test="${lineCd eq 'EN'}">
						<jsp:include page="/pages/marketing/quotation/subPages/quotationInformation/engineeringAdditionalInformation.jsp"></jsp:include>
					</c:when>
					<c:when test="${lineCd eq 'MH'}">
						<jsp:include page="/pages/marketing/quotation/subPages/quotationInformation/marineHullAdditionalInformation.jsp"></jsp:include>
					</c:when>
				</c:choose>
			</div>
				<jsp:include page="subPages/perilInformation.jsp"></jsp:include>
				
			<div id="outerDiv" name="outerDiv" changeTagAttr="true" class="deductibleInformation optionalInformation">
				<div id="innerDiv" name="innerDiv" changeTagAttr="true">
					<input type="hidden" name="deductibleIsShown" 	id="deductibleIsShown" 	value="N" />
			  		<label>Deductible Information </label>
			   		<span class="refreshers" style="margin-top: 0;">
			   			<label id='deductibleAccordionLbl' class='accordionLabel'>Show</label>
			   		</span>
				</div>
			</div>
			<div id="deductibleInformationMotherDiv" name="deductibleInformationMotherDiv" class="deductibleInformation optionalInformation" style="display: none;"></div>			
		
			<div id="outerDiv" name="outerDiv" class="optionalInformation mortgageeInformation">	
				<div id="innerDiv" name="innerDiv">
			   		<label>Mortgagee Information </label>
			   		<span class="refreshers" style="margin-top: 0;">
			   			<label id='mortgageeAccordionLbl' class='accordionLabel'>Show</label>
			   		</span>
			</div></div>
			<div id="mortgageeInformationMotherDiv"  name="mortgageeInformationMotherDiv" class="optionalInformation mortgageeInformation">	</div>
			
			<div id="outerDiv" name="outerDiv" class="optionalInformation invoiceInformation">
				<div id="innerDiv" name="innerDiv">
			   		<label>Invoice Information </label>
			   		<span class="refreshers" style="margin-top: 0;">
			   			<label id="invoiceAccordionLbl" class='accordionLabel'>Show</label>
			   		</span>
				</div>
			</div>
			<div id="invoiceInformationMotherDiv" name="invoiceInformationMotherDiv" class="optionalInformation invoiceInformation"></div>
			
			<div id="outerDiv" name="outerDiv" class="optionalInformation attachedMedia">	
				<div id="innerDiv" name="innerDiv">
					<label>Attached Media</label>
			  		<span class="refreshers" style="margin-top: 0;">
				  		<label id='mediaAccordionLbl'  class='accordionLabel'>Show</label>
			  		</span>
				</div>
			</div>
			<div id="attachedMediaMotherDiv" name="attachedMediaMotherDiv" class="optionalInformation attachedMedia">	</div>
		</div>	
	</form>
	
	<div class="buttonsDiv">
		<input type="button" class="button" id="btnEditQuotation" name="btnEditQuotation" value="Edit Basic Quotation Info" />
		<input type="button" class="button" id="btnSaveQuotation" name="btnSaveQuotation" value="Save" />
		<input type="button" class="disabledButton" id="btnPrintQuotation" name="btnPrintQuotation" value="Print" disabled="disabled" style="display:none;"/>
	</div>
	
	<input id="lineCdHidden" name="lineCdHidden" type="hidden" value="">
</div>
<script type="text/javascript">
	//$("btnAddPeril").hide = true;
	
	 
	
	$("lineCdHidden").value = '${lineCd}';//gets the lineCd value - Patrick 01/18/2012
	
	/* if($("lineCdHidden").value == 'CA'){
		disableSubpage("perilInformationDiv");
	} */
	
	/** CHECK IF STILL NECESSARY (since this option is also accessible as an object)- =\
	 */
	var exitCtr = 0;
	
	function setPerilDeductibleLov(){
		var deductiblesPerItem = $("deductiblesPerItem");
		var ded = null;
		for(var i=0; i<objItemPerilDeductibleLov.length; i++){
			var newDiv =  new Element("div");
			ded = objItemPerilDeductibleLov[i];
			newDiv.setAttribute("id", "perilDeductibleRow" + ded.itemNo);
			newDiv.setAttribute("name","perilDeductibleRow");
			newDiv.update(
				'<input type="hidden" id="perilDedItemNo"  name="perilDedItemNo"  value="' + ded.itemNo + '"/>' + 
				'<input type="hidden" id="perilDedPerilCd" name="perilDedPerilCd" value="' + ded.perilCd + '"/>' +
				'<input type="hidden" id="perilDedQuoteId" name="perilDedQuoteId" value="' + ded.quoteId + '"/>');
			deductiblesPerItem.insert({bottom: newDiv});
		}
	}
	
	// LOV'S setup 
	function saveAllQuotationInformation(){
		if($("selIntermediary") != null){$("selIntermediary").removeAttribute("changed");} // added by: Nica 06.08.2012 - to disregard changes in intermediary select box
		
		if(checkPendingRecordChanges()){ // Patrick 02.14.2012
			var lineCd = getLineCdMarketing();
			// do not include unmodified subpages to parameters when saving to speed up saving
			instantiateNullListings();
		
			var addedItemRows = getAddedJSONObjectList(objGIPIQuoteItemList);
			var modifiedItemRows = getModifiedJSONObjects(objGIPIQuoteItemList);
			var delItemRows = getDeletedJSONObjects(objGIPIQuoteItemList);
			var setItemRows	= addedItemRows.concat(modifiedItemRows);
			
			var proceed = true;
			// CHECK ITEM TYPE
			if(lineCd == "MC"){
				if(hasAdditionalInformation(objGIPIQuoteItemList)){
					proceed = true;
				}else{
					proceed = false;
					// error message
				}
			}
			
			if(proceed){
				var addedPerilRows = getAddedJSONObjectList(objGIPIQuoteItemPerilSummaryList);
				var modifiedPerilRows = getModifiedJSONObjects(objGIPIQuoteItemPerilSummaryList);
				var delPerilRows = getDeletedJSONObjects(objGIPIQuoteItemPerilSummaryList);
				var setPerilRows = addedPerilRows.concat(modifiedPerilRows);
				
				// added by: Nica 09.05.2011
				var addedDeductibleRows = getAddedJSONObjectList(objGIPIQuoteDeductiblesSummaryList);
				var modifiedDeductibleRows = getModifiedJSONObjects(objGIPIQuoteDeductiblesSummaryList);
				var delDeductibleRows = getDeletedJSONObjects(objGIPIQuoteDeductiblesSummaryList);
				var setDeductibleRows = addedDeductibleRows.concat(modifiedDeductibleRows);
				
				var addedMortgageeRows = getAddedJSONObjectList(objGIPIQuoteMortgageeList);
				var modifiedMortgageeRows = getModifiedJSONObjects(objGIPIQuoteMortgageeList);
				var delMortgageeRows = getDeletedJSONObjects(objGIPIQuoteMortgageeList);
				var setMortgageeRows = addedMortgageeRows.concat(modifiedMortgageeRows);
			
				var addedInvoiceRows = getAddedJSONObjectList(objGIPIQuoteInvoiceList);
				var modifiedInvoiceRows = getModifiedJSONObjects(objGIPIQuoteInvoiceList);
				var delInvoiceRows = getDeletedJSONObjects(objGIPIQuoteInvoiceList);
				var setInvoiceRows = addedInvoiceRows.concat(modifiedInvoiceRows);
				
				var objParameters = new Object();
				
				objParameters.setItemRows 		= prepareJsonAsParameter(setItemRows);
				objParameters.delItemRows 		= prepareJsonAsParameter(delItemRows);
				objParameters.setPerilRows		= prepareJsonAsParameter(setPerilRows);
				objParameters.delPerilRows		= prepareJsonAsParameter(delPerilRows);
				objParameters.setDeductibleRows	= prepareJsonAsParameter(setDeductibleRows);
				objParameters.delDeductibleRows	= prepareJsonAsParameter(delDeductibleRows);
				objParameters.setMortgageeRows 	= prepareJsonAsParameter(setMortgageeRows);
				objParameters.delMortgageeRows	= prepareJsonAsParameter(delMortgageeRows);
				objParameters.setInvoiceRows	= prepareJsonAsParameter(setInvoiceRows);
				objParameters.delInvoiceRows	= prepareJsonAsParameter(delInvoiceRows);
				objParameters.gipiQuote			= prepareJsonAsParameter(objGIPIQuote); // added by roy 06/13/2011
				
				new Ajax.Request(contextPath + "/GIPIQuotationInformationController?action=saveQuotationInformationJSON",{	
					method: "POST",		//postBody: Form.serialize("quotationInformationForm"),
					onCreate: function(){
						/* 	disableButton("btnEditQuotation"); disableButton("btnSaveQuotation"); 
							disableButton("btnPrintQuotation"); $("quotationInformationForm").disable(); */
						showNotice("Saving, please wait..."); 
					},
					parameters:{
						quoteId: 		objGIPIQuote.quoteId,
						parameters : 	JSON.stringify(objParameters),
						lineCd:			getLineCdMarketing()
					},
					onComplete: function(response){
						/*	$("quotationInformationForm").enable();	enableButton("btnEditQuotation");
						enableButton("btnSaveQuotation"); enableButton("btnPrintQuotation"); */ // Patrick 02.14.2012
						if (checkErrorOnResponse(response)){
							hideNotice(response.responseText);
							if (response.responseText == "SUCCESS"){
								showMessageBox(objCommonMessage.SUCCESS,imgMessage.SUCCESS);
								enableButton("btnEditQuotation");
								enableButton("btnSaveQuotation");
								enableButton("btnPrintQuotation");
								quoteInfoSaveIndicator = 1;
								deleteExecutedRecordStats();
								changeTag = 0; // Patrick - 02.14.2012	
								lastAction(); // Patrick - 02.13.2012
								lastAction = "";
							}
						}
						enableQuotationMainButtons();
						showAccordionLabelsOnQuotationMain();
						delRemovedDeductibles();
					}
				});
			}
		}
	}
	
	try{
		// Ajax.Responders.register(quotationMainResponder);
		objGIPIQuote = JSON.parse('${gipiQuoteObj}'); //.replace(/\\/g, '\\\\')); 		// andrew - 01.17.2012 - comment out replace, handle '\n' using ESCAPE_VALUE function in database procedure
		// FOR PERIL INFORMATION // BLOCK3
		objItemPerilLov = JSON.parse('${perilLovJSON}'); //.replace(/\\/g, '\\\\')); 		// andrew - 01.17.2012 - comment out replace, handle '\n' using ESCAPE_VALUE function in database procedure
		objItemPerilDeductibleLov = JSON.parse('${perilDeductiblesLovJSON}'); //.replace(/\\/g, '\\\\')); 		// andrew - 01.17.2012 - comment out replace, handle '\n' using ESCAPE_VALUE function in database procedure
		// NEW -- LIST OF PERILS
		//objGIPIQuoteItemPerilSummaryList = JSON.parse('${gipiQuoteItemPerilList}'.replace(/\\/g, '\\\\'));
		
		$("quoteId").value = objGIPIQuote.quoteId;

		if(isMakeQuotationInformationFormsHidden == 1){
			$("btnEditQuotation").hide();
			$("btnSaveQuotation").hide();
			$("btnPrintQuotation").hide();
			setModuleId("GIIMM005");
		}else{
			setModuleId("GIIMM002");
		}
		
		perilAddActionIndicator = 0;
		
		//$("reloadForm").observe("click", showQuotationInformation); // Patrick 02.14.2012
		
		/* $("btnSaveQuotation").observe("click", function(){
			//Check fields if added before saving - Patrick 01/18/2012
				if(checkPendingRecordChanges()){
					if($$("div#itemInformationDiv [changed=changed]").length > 0){
						fireEvent($("btnAddItem"), "click");
					}
					else{
						clearChangeAttribute("itemInformationDiv");
						saveAllQuotationInformation();
					}
				}
		}); */ //Patrick - 02.14.2012
		
		$("btnSaveQuotation").observe("click", saveAllQuotationInformation);
	
		$("btnEditQuotation").observe("click", function(){
			editQuotation(contextPath+"/GIPIQuotationController?action=editQuotation&quoteId="+$F("quoteId")+"&ajax=1");
		});
		//initializeAccordion();
		showAccordionHeaders();
		hideNotice();
		// in peril
		setPerilDeductibleLov();
		
		$("additionalInfoAccordionLbl").observe("click", function(){
			if(objGIPIQuote.lineCd=="SU"){
				showMessageBox("Additional Information is disabled in this line.", imgMessage.ERROR);
			}else{
				var lineCd = getLineCdMarketing();
				var divId = "";
				if(lineCd == "AV" || lineCd == "CA" || lineCd == "EN" || 
						lineCd == "LI" || lineCd == "MH" || lineCd == "MN"){
					$("additionalInformationDiv").show();
					divId = "additionalInformationSectionDiv";
				}else if(lineCd == "PA" || lineCd == "AC"){
					$("additionalInformationMotherDiv").show();
					$("additionalInformationSectionDiv").show();
					divId = "accidentAdditionalInformationDiv";
				}else if(lineCd == "FI" || lineCd == "MC"){
					$("additionalItemInformationDiv").show();
					divId = "additionalItemInformation";
				}
				try{
					if($("additionalInfoAccordionLbl").innerHTML=="Show"){
						Effect.BlindDown(divId, {
							duration: .3,
							onComplete: function(){
								$("additionalInfoAccordionLbl").innerHTML="Hide";
							}
						});
						$("additionalInfoAccordionLbl").innerHTML="Hide";
					}else{
						Effect.BlindUp(divId, {
							duration: .3,
							onComplete: function(){
								$("additionalInfoAccordionLbl").innerHTML="Show";
							}
						});
						$("additionalInfoAccordionLbl").innerHTML="Show";
					}
				}catch(e){
					showErrorMessage("ERROR: " + e);
				}
			}
		});
	
		$("mortgageeAccordionLbl").observe("click", function(){
			if($("mortgageeAccordionLbl").innerHTML=="Show"){
				showQuoteItemMortgagees();
				Effect.BlindDown("mortgageeInformationSectionDiv", {
					duration: .3
				});
				function hid(){
					$("mortgageeAccordionLbl").innerHTML="Hide";	
				}
				setTimeout(hid,100);
			}else{
				Effect.BlindUp("mortgageeInformationSectionDiv", {
					duration: .3
				});
				function sho(){
					$("mortgageeAccordionLbl").innerHTML="Show";
				}
				setTimeout(sho,100);
			}
		});
	
		$("deductibleAccordionLbl").observe("click", function(){
			if($("addDeductibleForm")==null){ // check if loaded....	
				loadDeductibleSubpage();
			}
			if($("deductibleAccordionLbl").innerHTML == "Show"){
				Effect.BlindDown("deductibleInformationMotherDiv", {
					duration: .3
				});
				function sho(){
					$("deductibleAccordionLbl").innerHTML="Hide";
				}
				setTimeout(sho,100);
			}else{
				Effect.BlindUp("deductibleInformationMotherDiv", {
					duration: .3
				});
				function sho(){
					$("deductibleAccordionLbl").innerHTML="Show";
				}
				setTimeout(sho,100);
			}
		});
		
		$("quoteInfoLbl").observe("click", function(){
			showSubpageContents("quoteInfoLbl", "quotationInformationDiv");
		});
		
		$("itemInfoLbl").observe("click", function(){
			showSubpageContents("itemInfoLbl","itemInformationDiv");
		});
		
		$("invoiceAccordionLbl").observe("click", function(){
			showInvoiceOfSelectedItem();
		});
				
		$("mediaAccordionLbl").observe("click", function(){
			showDetail("mediaAccordionLbl","attachedMediaTopDiv");
		});
	
		$("perilInfoLbl").observe("click", function(){
			showSubpageContents("perilInfoLbl", "perilInformationDiv");
		});
		
	}catch(e){
		showErrorMessage("quotationInformationMainJSON", e);
	}
	
	if($$("div[name='itemRow']").size()>0){
		quoteInfoSaveIndicator = 1;
	}
	
	// detect accessible modules
	if((modules.all(function(mod){ return mod != 'GIIMM017';})) && (objGIPIQuote.lineCd == "MC")){
		$("additionalInformationMotherDiv").hide();
	}
	if(modules.all(function(mod){ return mod != 'GIIMM021';}) && objGIPIQuote.lineCd == "FI"){
		hideElementClass("additionalInformation");
	}
	if(modules.all(function(mod){ return mod != 'GIIMM023';}) && objGIPIQuote.lineCd == "AC"){
		hideElementClass("additionalInformation");
	}
	if(modules.all(function(mod){ return mod != 'GIIMM024';}) && objGIPIQuote.lineCd == "AV"){
		hideElementClass("additionalInformation");
	}
	if(modules.all(function(mod){ return mod != 'GIIMM025';}) && objGIPIQuote.lineCd == "CA"){
		hideElementClass("additionalInformation");
	}
	if(modules.all(function(mod){ return mod != 'GIIMM026';}) && objGIPIQuote.lineCd == "EN"){
		hideElementClass("additionalInformation");
	}
	if(modules.all(function(mod){ return mod != 'GIIMM027';}) && objGIPIQuote.lineCd == "MN"){
		hideElementClass("additionalInformation");
	}
	if(modules.all(function(mod){ return mod != 'GIIMM028';}) && objGIPIQuote.lineCd == "MH"){
		hideElementClass("additionalInformation");
	}
	if(modules.all( function(mod){	return mod != 'GIIMM018';})){
		hideElementClass("mortgageelInformation");
	}
	if(modules.all(function(mod){ return mod != 'GIIMM019';})){
		hideElementClass("invoiceInformation");
	}
	if(modules.all(function(mod){ return mod != 'GIIMM022';})) {
		hideElementClass("attachedMedia");
	}
	if(modules.all(function(mod){ return mod != 'GIIMM020';})){
		//hideElementClass("deductibleInformation");
	}
	if(modules.all(function(mod){return mod != 'GIIMM029';})){
		$("btnPrintQuotation").hide();
	}
	initializeAllMoneyFields();
	initializeChangeAttribute();
	initializeChangeTagBehavior(saveAllQuotationInformation);
	
	if(isMakeQuotationInformationFormsHidden == 1){
		$("reloadForm").observe("click", showQuotationInformation2);
	}else{
		observeReloadForm("reloadForm", showQuotationInformation); // Patrick 02.14.2012
	}
	
	/* 
	function showQuotationListExit(){
		if(exitCtr > 0){
			showQuotationListing();
			exitCtr = 0;
		}else{
			showQuotationListing();
		}
	}
	
	initializeChangeTagBehavior(showQuotationListExit); */
	
	var fromCreateQuote = nvl('${fromCreateQuote}', 'N');
	$("gimmExit").stopObserving("click"); // andrew - 02.09.2012
	$("gimmExit").observe("click", function(){ // Patrick - 02.14.2012
		if(changeTag > 0){
			showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
							function(){
								saveAllQuotationInformation();
								//showQuotationListing(); marco - 06.25.2012
								fromCreateQuote == "Y" ? showCreateQuoteFromQuoteInfo() : showQuotationListing();
							},
							function(){
								//showQuotationListing();
								fromCreateQuote == "Y" ? showCreateQuoteFromQuoteInfo() : showQuotationListing();
							    changeTag = 0;
							}, "");									
		}else{
			//showQuotationListing();
			fromCreateQuote == "Y" ? showCreateQuoteFromQuoteInfo() : showQuotationListing();
		}
	});
	
</script>