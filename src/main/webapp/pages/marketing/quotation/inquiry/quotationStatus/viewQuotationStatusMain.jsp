<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" %>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="quotationInformationMainDiv" name="quotationInformationMainDiv" style="display: none; margin-top: 1px;">
	<div  changeTagAttr="true">
	<form id="quotationInformationForm" name="quotationInformationForm">
		<jsp:include page="/pages/marketing/quotation/inquiry/quotationStatus/viewQuotationInformation.jsp"></jsp:include>
		<jsp:include page="/pages/marketing/quotation/inquiry/quotationStatus/viewItemInformation.jsp"></jsp:include>
		<div id="otherInformationDiv" name="otherInformationDiv">
				<div id="outerDiv" name="outerDiv">	
					<div id="innerDiv" name="innerDiv">
				   		<label>Additional Information </label>
				   		<span class="refreshers" style="margin-top: 0;">
							<label id='additionalInfoAccordionLbl' name="gro">Show</label>
				   		</span>
					</div>
				</div>
				<c:choose>
					<c:when test="${lineCd eq 'AC' or lineCd eq 'PA'}">
						<jsp:include page="/pages/marketing/quotation/inquiry/quotationStatus/additionalInfo/viewAdditionalInfoAC.jsp"></jsp:include>
					</c:when>
					<c:when test="${lineCd eq 'AV'}">
						<jsp:include page="/pages/marketing/quotation/inquiry/quotationStatus/additionalInfo/viewAdditionalInfoAV.jsp"></jsp:include>
					</c:when>
					<c:when test="${lineCd eq 'CA'}">
						<jsp:include page="/pages/marketing/quotation/inquiry/quotationStatus/additionalInfo/viewAdditionalInfoCA.jsp"></jsp:include>
					</c:when>
					<c:when test="${lineCd eq 'EN'}">
						<jsp:include page="/pages/marketing/quotation/inquiry/quotationStatus/additionalInfo/viewAdditionalInfoEN.jsp"></jsp:include>
					</c:when>
					<c:when test="${lineCd eq 'FI'}">
						<jsp:include page="/pages/marketing/quotation/inquiry/quotationStatus/additionalInfo/viewAdditionalInfoFI.jsp"></jsp:include>
					</c:when>
					<c:when test="${lineCd eq 'MC'}">
						<jsp:include page="/pages/marketing/quotation/inquiry/quotationStatus/additionalInfo/viewAdditionalInfoMC.jsp"></jsp:include>
					</c:when>
					<c:when test="${lineCd eq 'MH'}">
						<jsp:include page="/pages/marketing/quotation/inquiry/quotationStatus/additionalInfo/viewAdditionalInfoMH.jsp"></jsp:include>
					</c:when>
					<c:when test="${lineCd eq 'MN'}">
						<jsp:include page="/pages/marketing/quotation/inquiry/quotationStatus/additionalInfo/viewAdditionalInfoMN.jsp"></jsp:include>
					</c:when>
				</c:choose>			

			<div id="outerDiv" name="outerDiv">	
				<div id="innerDiv" name="innerDiv">
			   		<label>Peril Information</label>
			   		<span class="refreshers" style="margin-top: 0;">
						<label id='perilInfoAccordionLbl' name="gro" >Show</label>
			   		</span>
				</div>
			</div>
			<div id="perilInformationMotherDiv" name="perilInformationMotherDiv" style="display: none;">
				<jsp:include page="/pages/marketing/quotation/inquiry/quotationStatus/peril/viewPerilInformation.jsp"></jsp:include>
			</div>
		
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
					<label>Deductible Information</label> 
					<span class="refreshers" style="margin-top: 0;"> 
						<label id="deductibleInfoLbl" name="gro">Show</label>
					</span>
				</div>
			</div>
			<div id="deductibleInformationMotherDiv" name="deductibleInformationMotherDiv" style="display: none;">
				<jsp:include page="/pages/marketing/quotation/inquiry/quotationStatus/deductible/viewDeductibleInformation.jsp"></jsp:include>
			</div>	
			
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
					<label>Mortgagee Information</label> <span class="refreshers"
						style="margin-top: 0;"> <label id="showMortgagee" name="gro"
						style="margin-left: 5px">Show</label>
					</span>
				</div>
			</div>
			<div id="mortgageeInformationMotherDiv"  name="mortgageeInformationMotherDiv" style="display: none;">	
					<jsp:include page="/pages/marketing/quotation/inquiry/quotationStatus/mortgagee/viewMortgagee.jsp"></jsp:include>
			</div>
			
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
					<label>Attached Files</label>
					<span class="refreshers" style="margin-top: 0;">
						<label id="showAttachments" name="gro" style="margin-left: 5px">Show</label>
					</span>
				</div>
			</div>
			<div id="attachedFilesParentDiv" name="attachedFilesParentDiv" style="display: none;">
				<jsp:include page="/pages/marketing/quotation/inquiry/quotationStatus/attachments/viewAttachments.jsp"></jsp:include>
			</div>
		</div>
	
		<input id="lineCdHidden" name="lineCdHidden" type="hidden">
		<input id="quoteId" name="quoteId" type="hidden">
		<input id="itemNoHid" name="itemNoHid" type="hidden">
		<input id="vesAirQuoteId" name="vesAirQuoteId" type="hidden">
	</form>
	</div>
	<div class="buttonsDiv">
		<input type="button" class="button" id="btnViewInvoice" name="btnViewInvoice" value="Invoice" style="width: 75px;" tabindex="801"/>
	</div>
</div>
<script type="text/javascript">
	objGIPIQuote = JSON.parse('${gipiQuoteObj}');
	objQuoteGlobal.lineCd = '${lineCd}';
	$("lineCdHidden").value = '${lineCd}';
	$("vesAirQuoteId").value = '${vesAirQuoteId}';
	objQuoteGlobal.selected = false;
	objQuote.addtlInfo = 'N';
	
	$("btnViewInvoice").observe("click", function(){
		if(objQuote.selectedItemInfoRow != ""){
			if(objQuote.objPeril.length > 0){
				showInvoiceOverlay();
			}else{
				showMessageBox("Item has no perils.", "I");
			}
		}else{
			showMessageBox("Please select an item.", "I");
		}
	});
	
	function showInvoiceOverlay(){
		invoiceOverlay = Overlay.show(contextPath+"/GIPIQuoteInvoiceController", {
			urlContent: true,
			draggable: true,
			urlParameters: {
				action     : "showViewInvoiceOverlay",
				quoteId    : objGIPIQuote.quoteId,
				currencyCd : objQuote.selectedItemInfoRow.currencyCd
			},
		    title: "Invoice",
		    height: 490,
		    width: 755
		});
	}
	
	function showDeductibleInfoTG(show){
		try{	
			var quoteId = show ? objGIPIQuote.quoteId : 0;
			var itemNo = show ? objQuote.selectedItemInfoRow.itemNo : 0;
			var perilCd = show ? objQuote.selectedPerilInfoRow.perilCd : 0;
			var lineCd = show ? objGIPIQuote.lineCd : "";
			var sublineCd = show ? objGIPIQuote.sublineCd : "";
			deductibleInfoGrid.url = contextPath+"/GIPIQuoteDeductiblesController?action=getDeductibleInfoTG&quoteId="+ quoteId
									+"&itemNo="+ itemNo
									+"&perilCd="+ perilCd
									+"&lineCd="+ lineCd
									+"&sublineCd="+ sublineCd;
			deductibleInfoGrid._refreshList();
		}catch(e){
			showErrorMessage("showDeductibleInfoTG",e);
		}
	}
	
	function requireMcCompany(){
		if('${requireMcCompany}' == "Y" && objQuoteGlobal.lineCd == "MC"){
			$("txtDspCarCompanyCd").addClassName("required");
			//$("txtDspCarCompanyCd").up("div",0).addClassName("required"); commented out by reymon 02192013
		}
	}
	
	if(objQuoteGlobal.lineCd == "SU"){
		disableSubpage("additionalInfoAccordionLbl");
	}
	
	objQuoteGlobal.showDeductibleInfoTG = showDeductibleInfoTG;
	
	requireMcCompany();
	addStyleToInputs();
	initializeAll();
	initializeChangeAttribute();
	initializeAllMoneyFields();
</script>