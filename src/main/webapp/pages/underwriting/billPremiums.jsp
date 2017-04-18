<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="billPremiumsMainDiv">
<jsp:include page="subPages/parInformation.jsp"></jsp:include>
<c:choose>
	<c:when test="${isPack == 'Y'}">
		<jsp:include page="/pages/underwriting/packPar/packCommon/packParPolicyListingTable.jsp"></jsp:include>
	</c:when>
</c:choose>
<input type="hidden" id="origPaytype" value="A"/>
<input type="hidden" id="lastIndex" value="1"/>
<input type="hidden" id="initialParId" value="${parId}"/>
<input type="hidden" id="initialLineCd" value="${lineCd}"/>
<div id="outerDiv">
	<div id="innerDiv">
		<label>Invoice Information</label> 
		<span class="refreshers" style="margin-top: 0;"> 
			<label name="gro" style="margin-left: 5px;">Hide</label> 
		</span>
	</div>
</div>

<div id="billMainDiv" style="margin-top: 1px;">
<form id="WInvoiceForm" name="WInvoiceForm">

<div class="sectionDiv" id="invoiceInformationDiv">
	<jsp:include page="subPages/billPremiumsListing.jsp"></jsp:include>
   <div id="invoiceInformation" style="margin: 10px; margin-top: 20px;">
     <table width="90%" align="center" style="margin-left: 25px;" cellspacing="1" border="0">
	   <tr>
		<td class="rightAligned" width="150px">Item Group
		  <input type="hidden" id="parId" name="parId" value="" /> 
		  <input type="hidden" id="issCd" name="issCd" /> 
		  <input type="hidden" id="insured" name="insured" />
		  <input type="hidden" id="hiddenCredExpirydate" value="<fmt:formatDate value="${credGIPIWPolbas.expiryDate}" pattern="yyyy-MM-dd" />" /> 
		  <input type="hidden" id="hiddenEffDate" value="<fmt:formatDate value="${credGIPIWPolbas.effDate}" pattern="yyyy-MM-dd" />" />
		  <input type="hidden" id="hiddenIssueDate" value="<fmt:formatDate value="${credGIPIWPolbas.issueDate}" pattern="MM-dd-yyyy" />" /> 
		</td>
		<td class="leftAligned" width="200px">
		  	<input type="text" id="itemGrp"	name="itemGrp" style="text-align: left" readonly="readonly" value="" /> 
		</td>
		<td class="rightAligned" width="250px">Take Up</td>
		<td class="leftAligned" >
			<input type="text" id="takeupSeqNo"	name="takeupSeqNo" style="text-align: left" readonly="readonly" value="" /> 
		</td>
		<td class="rightAligned" width="170px">Premium</td>
		<td class="leftAligned"><input type="text" id="premAmt"	name="premAmt" style="text-align: right" readonly="readonly" class="money" value="" /></td>
	</tr>
	<tr>
		<td class="rightAligned">Property/Item</td>
		<td class="leftAligned"><input type="text" id="property" name="property" value="" maxlength="100" /></td>
		<td class="rightAligned">Multi-booking Date</td>
		<td class="leftAligned" readonly="readonly">
			<select id="selMultiBookingMM" name="selMultiBookingMM" style="width: 87%" >
				<option value=""></option>
				<c:forEach var="bookedMonth" items="${bookingMonth}">
					<option value="${bookedMonth.bookingYear} - ${bookedMonth.bookingMonth}" bookingYear="${bookedMonth.bookingYear}" bookingMonth="${bookedMonth.bookingMonth}"> 
						${bookedMonth.bookingYear} - ${bookedMonth.bookingMonth}
					</option>
				</c:forEach>
			</select> 
			<input id="changedTag" type="checkbox" style="width: 1%" disabled /></td>

		<td class="rightAligned">Total Tax</td>
		<td class="leftAligned">
		<input type="text" id="taxAmt" name="taxAmt" style="text-align: right" class="money" value="" readOnly="readonly" /></td>
	</tr>
	<c:choose>
	  <c:when test="${issCd == 'RI'}">
		<tr>
		<td class="rightAligned">Pay Term</td>
		<td class="leftAligned">
			<select class="required" id="selPaytTerms" name="selPaytTerms"
						style="width: 122px; height: 23px;">
				<option></option>		
				<c:forEach var="payterm" items="${paytTerms}">
					<option annualSw="${payterm.annualSw}"	noOfPayt="${payterm.noOfPayt}" noOfDays="${payterm.noOfDays}" onInceptTag="${payterm.onInceptTag}" value="${payterm.paytTerms}"	>
						${payterm.paytTermsDesc}
					</option>
				</c:forEach>
			  </select> 
			  <input id="noOfPayt" name="noOfPayt" type="text" readonly="readonly" 	style="width: 24px; text-align: right;" value="" /> 
			  <input type="hidden" 	id="annualSw" name="annualSw" style="width: 27px; text-align: right;" />
		</td>
		<td class="rightAligned">Reference Invoice No</td>
		<td class="leftAligned"><input type="text" id="refInvNo" name="refInvNo" value="" maxLength="30"></td>
		<td class="rightAligned">Comm. Amt</td>
		<td class="leftAligned">
			<input type="text" id="otherCharges" name="otherCharges" readonly="readonly" style="text-align: right; display: none;" class="money" value="" />
		 	<input type="text" id="commAmt" name="commAmt" readonly="readonly" style="text-align: right" class="money" value="" /></td>	
	  </tr>
	  <tr>
		<td class="rightAligned">Due Date</td>
		<td class="leftAligned">
		<div style="float:left; border: solid 1px gray; width: 97%; height: 21px; margin-right:3px;" class="required">
		   <input type="text" style="border: none;width:82%; height: 13px;" id="dueDate"	name="dueDate" value=""  triggerChange="Y" class="required" readonly="readonly" />
		   <img id="hrefDueDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('dueDate'),this, null);" alt="Due Date" />
		</div>
		</td>
		<td class="rightAligned">Payment Type</td>
		<td class="leftAligned">
			<select class="required" id="selPayType" name="selPayType" style="width: 100%; height: 25px;">
				<option></option>
				<option value="A">Cash</option>
			     <option value="R">Credit</option>
			</select> 
			<input type="hidden" id="payType" name="payType" value="" />
		</td>
		<td class="rightAligned">RI Comm VAT</td>
		<td class="leftAligned">
			<input type="text" id="riCommVat" name="riCommVat" style="text-align: right" class="money" readonly="readonly" value="" /></td>
 	 </tr>
	  <tr>
		<td class="rightAligned">Remarks</td>
		 <td colspan=3 style=""> 
			<div style="border: 1px solid gray; height: 20px; width: 98.7%; margin-left: 4px;">
				<textarea id="remarks" style="width: 93%; border: none; height: 13px; float: left;" class="list"></textarea>
				<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" />
			</div>
		</td>
		<td class="rightAligned">Amount Due</td>
		<td class="leftAligned">
			<input type="text" id="amountDue" name="amountDue" style="text-align: right" class="money" readonly="readonly" value="" /></td>
	  </tr>
	  <tr>
	  	<td class="rightAligned"></td>
	  	<td colspan="3" class="leftAligned"></td>
	  	<td class="rightAligned">Currency</td>
		<td class="leftAligned">
			<input type="text" id="policyCurrency" name="policyCurrency" style="width: 112px;" readonly="readonly" value="" /> 
			<input type="checkbox" id="currCheckbox" name="currCheckbox" value="0" />
			<input type="hidden" id="showPaySched" name="showPaySched" value="N">
		</td>
	  
	  </tr>
	 </c:when>
	<c:otherwise>
	  <tr>
		<td class="rightAligned">Pay Term</td>
		<td class="leftAligned">
			<select class="required" id="selPaytTerms" name="selPaytTerms"
						style="width: 122px; height: 23px;">
				<option></option>		
				<c:forEach var="payterm" items="${paytTerms}">
					<option annualSw="${payterm.annualSw}"	noOfPayt="${payterm.noOfPayt}" noOfDays="${payterm.noOfDays}" onInceptTag="${payterm.onInceptTag}" value="${payterm.paytTerms}"	>
						${payterm.paytTermsDesc}
					</option>
				</c:forEach>
			  </select> 
			  <input id="noOfPayt" name="noOfPayt" type="text" readonly="readonly" 	style="width: 24px; text-align: right;" value="" /> 
			  <input type="hidden" 	id="annualSw" name="annualSw" style="width: 27px; text-align: right;" />
		</td>
		<td class="rightAligned">Reference Invoice No.</td>
		<td class="leftAligned"><input type="text" id="refInvNo" name="refInvNo" value="" maxLength="30"></td>
		<td class="rightAligned">Other Charges</td>
		<td class="leftAligned">
		 	<input type="text" id="otherCharges" name="otherCharges" readonly="readonly" style="text-align: right" class="money" value="" /></td>
	  </tr>
	  <tr>
		<td class="rightAligned">Due Date</td>
		<td class="leftAligned">
		<div style="float:left; border: solid 1px gray; width: 97%; height: 21px; margin-right:3px;" class="required">
		   <input type="text" style="border: none;width:82%; height: 13px;" id="dueDate"	name="dueDate" value=""  triggerChange="Y" class="required" readonly="readonly"/>
		   <img id="hrefDueDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('dueDate'),this, null);" alt="Due Date" />
		</div>
		</td>
		<td class="rightAligned">Payment Type</td>
		<td class="leftAligned">
			<select class="required" id="selPayType" name="selPayType" style="width: 100%; height: 25px;">
				<option></option>
				<option value="A">Cash</option>
			     <option value="R">Credit</option>
			</select> 
			<input type="hidden" id="payType" name="payType" value="" />
		</td>
		<td class="rightAligned">Amount Due</td>
		<td class="leftAligned">
			<input type="text" id="amountDue" name="amountDue" style="text-align: right" class="money" readonly="readonly" value="" /></td>
 	 </tr>
	  <tr>
		<td class="rightAligned">Remarks</td>
		<!-- 
		<td colspan="3" class="leftAligned">
			<input type="text" id="remarks"	name="remarks"  style="width: 98.2%;" maxLength="4000">
		</td>
		 -->
		 <td colspan=3 style=""> 
			<div style="border: 1px solid gray; height: 20px; width: 98.7%; margin-left: 4px;">
				<textarea id="remarks" style="width: 93%; border: none; height: 13px; float: left;" class="list"></textarea>
				<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" />
			</div>
		</td>
		<td class="rightAligned">Currency</td>
		<td class="leftAligned">
			<input type="text" id="policyCurrency" name="policyCurrency" style="width: 112px;" readonly="readonly" value="" /> 
			<input type="checkbox" id="currCheckbox" name="currCheckbox" value="0" />
			<input type="hidden" id="showPaySched" name="showPaySched" value="N">
		</td>
	  </tr>
    </c:otherwise>		
   </c:choose>
</table>
	<div class="buttonsDiv" style="float:left; width: 100%; margin-bottom: 10px;" changeTagAttr="true">			
		<input style="margin-left: 25px;" type="button" style="width: 100px;" id="btnUpdate" name="btnUpdate"  class="button" value="Update" />
		<input type="button" id="hiddenButtonUpdate" style="display: none;"/>
	</div> 
</div>
</div>
</form>
</div>
<div id="outerDiv" style="width: 100%; margin-bottom: 1px;">
	<div id="innerDiv" >
   		<label>Tax Information</label>
   		<span class="refreshers" style="margin-top: 0;">
   			<label name="gro" style="margin-left: 5px;">Hide</label>
   		</span>
   	</div>
</div>

<div class="sectionDiv" id="taxInformationDiv" name="taxInformationDiv" changeTagAttr="true"> 
	<!-- tax info goes here -->
</div>

<div id="installmentInfo">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv"><label>Payment Schedule</label>
			<span class="refreshers" style="margin-top: 0;"> 
				<label id="paymentSchedLbl" name="gro" style="margin-left: 5px;">Show</label> 
			</span>
		</div>
	</div>
	<div class="sectionDiv" id="winstallmentInfoDiv" style="display: none;" changeTagAttr="true">
		 <jsp:include page="pop-ups/installment.jsp"></jsp:include>
	</div>
</div>
<div id="itemGroupInfo" style="display: none;">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv"><label>Item Group Summary</label> 
			<span class="refreshers" style="margin-top: 0;"> 
				<label id="itmGrpLbl" name="gro" style="margin-left: 5px;">Show</label> 
			</span>
		</div>
	</div>
	<div class="sectionDiv" id="itemGroupSummaryDiv">
		<!--  item group summary info goes here-->
	</div>
</div>

<div class="buttonsDiv" style="float:left; width: 100%;">			
	<input type="button" style="width: 70px; margin-left: 35px;" id="btnCancel" name="btnCancel"	class="button" value="Cancel" toEnable="true"/>
	<input type="button" style="width: 70px;" id="btnSave" name="btnSave" class="button" value="Save" toEnable="true"/>  <!--added by steven 10/08/2012 "toEnable" even if the endt. is cancel it is still enabled-->	
</div> 
</div>
<script type="text/javascript">

	setModuleId("GIPIS026");	
	setDocumentTitle("Enter Bill Premiums");
	
	objUW = new Object();
	objUW.takeupListDtls = JSON.parse('${gipiWInvoiceJSON}'.replace(/\\/g, '\\\\'));
	objUW.takeupInstallmentDtls = JSON.parse('${gipiWInstallmentJSON}'.replace(/\\/g, '\\\\'));	
	objUW.inceptDate = '${inceptDate}';
	objUW.expiryDate = '${expiryDate}';
	objUW.effDate = '${effDate}';
	objUW.endtExpiryDate = '${endtExpiryDate}';
	//objUW.credExpiryDate = dateFormat('${credGIPIWPolbas.expiryDate}', 'yyyy-mm-dd');
	//objUW.credEffDate = dateFormat('${credGIPIWPolbas.effDate}', 'yyyy-mm-dd');
	objUW.credExpiryDate = $F("hiddenCredExpirydate");
	objUW.credEffDate = $F("hiddenEffDate");
	objUW.cancelType = '${credGIPIWPolbas.cancelType}'; //Apollo Cruz 12.11.2014
	
	objUW.recomputeInstallment = false;
	objUW.defPayTerm = '${defPayTerm}';	
	objUW.otherChargesTaxCd = '${otherChargesTaxCd}';
	objUW.allowBookingInAdvance = '${allowBookingInAdvance}'; // andrew - 09.08.2011
	objUW.allowUpdate = true; // andrew - 09.19.2011
	objUW.bookingDates = '${bookingMonth}';
	objUW.issCd = '${issCd}';
	objUW.evat = '${evat}'; 
	//objUW.initialParId = '${parId}';
	//parPolicyList = JSON.parse('${parPolicyList}'.replace(/\\/g, '\\\\'));
	objGIPIParList = JSON.parse('${parPolicyList}'.replace(/\\/g, '\\\\'));
	objUW.allowExpiredPolIssuance = nvl('${allowExpiredPolIssuance}','N');  //added by robert SR 19785 07.20.15
	
    var takeupTerm = '${takeupTerm}';
    var propertyInvalid = false;
	var oldBookingValue = "";
	recCount = '${recCount}'; //apollo cruz 02.16.2015 - declared as global variable to be used in invoiceTax.jsp
	var isPack = "${isPack}";
	var updateBooking = ('${updateBooking}');
	
	if(nvl(updateBooking, "Y") == "N"){
		$("selMultiBookingMM").disable(); // added by: Nica 05.25.2012 - Per Ms VJ, booking month LOV should be disabled if UPDATE_BOOKING is equal to N.
	}

	$("selPaytTerms").value = objUW.defPayTerm;
	$("noOfPayt").value = $("selPaytTerms").options[$("selPaytTerms").selectedIndex].getAttribute("noOfPayt");
	var parTypeCond = (objUWGlobal.parType != null ? objUWGlobal.parType : $F("globalParType")); //added by steven 10/08/2012
	var polFlag = objUWParList.packParId == null ? $F("globalPolFlag"): objUWGlobal.polFlag;
	//objUW.allowUpdateTaxEndtCancellation = '${allowUpdateTaxEndtCancellation}';		//Gzelle 07272015 SR4819 //removed by robert SR 4844 09.21.15
	objUW.allowUpdateTaxEndtCancellation = 'N'; //parameter is no longer considered -- robert SR 4844 09.21.15
	if("4" == polFlag && parTypeCond == "E" && objUW.allowUpdateTaxEndtCancellation == "N"){ 	//Gzelle 07272015 SR4819
		disableButton("btnUpdate");
	}else{
		enableButton("btnUpdate");
	}
	if (isPack == 'Y'){
		showPackagePARPolicyList(objGIPIParList);
		loadPackageParPolicyRowObserver();
	}
	
/*********** JSON MODIFICATION/MANIPULATION ******************/	
	function getAddedModifiedInstallment(obj){
		var tempObjArray = new Array();
		if (obj != null) {
			for(var i=0; i<obj.length; i++) {	
				tempObjArray.push(obj[i]);
			}
		}
		return tempObjArray;
	}
	
	//function getAddedModified 
	function getAddedModifiedJSONObject(obj){
		var tempObjArray = new Array();
		if (obj != null) {
			for(var i=0; i<obj.length; i++) {	
				if(obj == objUW.takeupListDtls){ //added by robert
					if(!obj[i].recordStatus){ // for automatically generated records in Invoice Information block
						tempObjArray.push(obj[i]);
					}
				}
				if (obj[i].recordStatus == 0){
					tempObjArray.push(obj[i]);
				}else if (obj[i].recordStatus == 1){
					tempObjArray.push(obj[i]);
				}
			}
		}
		
		return tempObjArray;
	}
	
	//function getDeleted 
	function getDeletedJSONObject(obj){
		var tempObjArray = new Array();
		if (obj != null) {
			for(var i=0; i<obj.length; i++) {	
				if (obj[i].recordStatus == -1){
					tempObjArray.push(obj[i]);
				}
			}
		}
		return tempObjArray;
	}
	
	function setModifiedWinvoice(){
		var newObj = new Object();
		var selItemGrp = $F("itemGrp");
		var selTakeup  = $F("takeupSeqNo");
		try{
			for (var i=0; i<objUW.takeupListDtls.length; i++){
				if(objUW.takeupListDtls[i].itemGrp == selItemGrp && objUW.takeupListDtls[i].takeupSeqNo == selTakeup){
					objUW.takeupListDtls[i].parId  		= $F("initialParId");//objUWParList.parId;
					objUW.takeupListDtls[i].itemGrp  	= selItemGrp;
					objUW.takeupListDtls[i].takeupSeqNo  = selTakeup;
					objUW.takeupListDtls[i].property		= $F("property");
					objUW.takeupListDtls[i].refInvNo		= $F("refInvNo");	
					objUW.takeupListDtls[i].remarks		= $F("remarks");
					objUW.takeupListDtls[i].multiBookingMM	= $("selMultiBookingMM").options[$("selMultiBookingMM").selectedIndex].getAttribute("bookingMonth");
					objUW.takeupListDtls[i].multiBookingYY = $("selMultiBookingMM").options[$("selMultiBookingMM").selectedIndex].getAttribute("bookingYear");
					objUW.takeupListDtls[i].otherCharges = unformatCurrency("otherCharges");
					objUW.takeupListDtls[i].taxAmt		= unformatCurrency("taxAmt");
					objUW.takeupListDtls[i].premAmt		= unformatCurrency("premAmt");
					objUW.takeupListDtls[i].paytTerms    = $F("selPaytTerms");
					objUW.takeupListDtls[i].payType		= $("selPayType").options[$("selPayType").selectedIndex].value;//== "Cash" ? "A" : "R";
					objUW.takeupListDtls[i].dueDate		= $F("dueDate");
					objUW.takeupListDtls[i].amountDue	= $F("amountDue");
					objUW.takeupListDtls[i].policyCurrency = $("currCheckbox").checked ? "Y" : null;
					if (objUW.issCd == 'RI'){
						objUW.takeupListDtls[i].riCommAmt	= unformatCurrency("commAmt");
						objUW.takeupListDtls[i].riCommVat	= unformatCurrency("riCommVat");
					}
					$("lblAmountDue" + objUW.takeupListDtls[i].itemGrp + "" + objUW.takeupListDtls[i].takeupSeqNo).innerHTML = formatCurrency($F("amountDue"));
					$("lblOtherCharges" + objUW.takeupListDtls[i].itemGrp + "" + objUW.takeupListDtls[i].takeupSeqNo).innerHTML = formatCurrency($F("otherCharges"));
					$("lblTaxAmt" + objUW.takeupListDtls[i].itemGrp + "" + objUW.takeupListDtls[i].takeupSeqNo).innerHTML = formatCurrency($F("taxAmt"));
					$("lblPremAmt" + objUW.takeupListDtls[i].itemGrp + "" + objUW.takeupListDtls[i].takeupSeqNo).innerHTML = formatCurrency($F("premAmt"));
					//$("lblMultiBookingYY" + objUW.takeupListDtls[i].itemGrp + "" + objUW.takeupListDtls[i].takeupSeqNo).innerHTML =formatCurrency("amountDue");
					$("lblMultiBookingYY" + objUW.takeupListDtls[i].itemGrp + "" + objUW.takeupListDtls[i].takeupSeqNo).innerHTML = $("selMultiBookingMM").options[$("selMultiBookingMM").selectedIndex].getAttribute("bookingYear") + " - " + $("selMultiBookingMM").options[$("selMultiBookingMM").selectedIndex].getAttribute("bookingMonth");
					objUW.takeupListDtls[i].recordStatus		= 1;
				}
			}
			
			return newObj;			    			
		}catch(e){
			showErrorMessage("setModifiedWinvoice", e);
			//showMessageBox("setModifiedWinvoice : " + e.message);
		}
	}			
	
	/*********** END JSON MODIFICATION/MANIPULATION ******************/

/************** RESETTING VALUES ******************/
	
	function resetDisplayValues(){
		$("txtTaxDesc").value = "";
		$("txtTaxDesc").hide();
		$("selTaxDesc").show();
		$("selTaxDesc").selectedIndex = 0;
		$("selTaxDesc").options[$("selTaxDesc").selectedIndex].text = "";
		$("taxChargeAmt").value = formatCurrency(0);
		$("taxAllocation").selectedIndex = 0;
		$("taxAllocation").enable(); //added by steven 07.18.2014
		$("btnAddTax").value = "Add";
		$("selPaytTerms").value = objUW.defPayTerm;
		$("noOfPayt").value = $("selPaytTerms").options[$("selPaytTerms").selectedIndex].getAttribute("noOfPayt");
		//enableButton("btnAddTax");
		disableButton("btnDeleteTax");
		$("selTaxDesc").disabled = false;
		objUW.primarySw = "";
	}


	function refreshList(){
		$$("div[name='billPremiumRow']").each(function (r) {
			r.remove();
		});
		if (objUW.taxItems != null){
			showTaxList(objUW.taxItems);
		}
	}

	function refreshInstallmentDiv(){
		$$("div[name='installmentDtlsRow']").each(function (r) {
			r.remove();
		});
	}
	
	function clearValues(){
		try {
			//added by steven  08.04.2014
			$("installmentInstNo").value = null;
			$("installmentDueDate").value = null;
			$("installmentTotalDue").value = null;
			//end
			$("itemGrp").value = null;
			$("takeupSeqNo").value = null;
			$("premAmt").value = null;
			$("taxAmt").value = null;
			$("otherCharges").value = null;
			if (objUW.issCd == 'RI'){
				$("commAmt").value = null;
				$("riCommVat").value = null;
			}	
			$("amountDue").value = null;
			$("dueDate").value = null;
			$("selPayType").value = "Cash";
			$("selMultiBookingMM").value = null;
			$("refInvNo").value = null;
			$("remarks").value = null;
			$("policyCurrency").value = null;
			$("property").value = null;
			$("currCheckbox").checked = false;
			//$("installmentInfo").style.display = "none";
			$("itemGroupInfo").style.display = "none";
			disableButton("btnUpdate");
			$$("div[name='billPremiumsDtlsRow']").each(function (r) {
				r.removeClassName("selectedRow");
			});
			 refreshInstallmentDiv();
			 $("winstallmentInfoDiv").hide();
			 $("divTotals").hide();
			 $("totalSharePct").innerHTML = "0";
			 $("totalPremAmt").innerHTML =  "0";
			 $("totalTaxAmt").innerHTML = "0";
			 $("totalAmountDue").innerHTML = "0";
			 $("paymentSchedLbl").innerHTML = "Show";
			 $("currCheckbox").value = 0;
			 $("selPaytTerms").value = objUW.defPayTerm;
			 $("noOfPayt").value = $("selPaytTerms").options[$("selPaytTerms").selectedIndex].getAttribute("noOfPayt");
			 checkIfToResizeTable("installmentTableListingContainer", "installmentDtlsRow");
			 checkTableIfEmpty("installmentDtlsRow", "installmentListingTable");
			
			 //Added by Apollo Cruz 12.22.2014
			 setBillPremiumsCancellation(false,objUW.allowUpdateTaxEndtCancellation);	//Gzelle 07272015 SR4819
		}catch(e){
			showErrorMessage("clearValues", e);
		}
	}
	
	/************** END RESETTING VALUES ******************/

/***********DIV EVENTS******************/
	function loadPackageParPolicyRowObserver(){
		try{
			$$("div#packageParPolicyTable div[name='rowPackPar']").each(function(row){
				setPackParPolicyObserver(row);				
			});
		}catch(e){
			showErrorMessage("loadPackageParPolicyRowObserver", e);
		}
	}
	
	function setPackParPolicyObserver(row){
		try{
			loadRowMouseOverMouseOutObserver(row);
	
			row.observe("click", function(){
				row.toggleClassName("selectedRow");
				if(row.hasClassName("selectedRow")){												
					($$("div#packageParPolicyTable div:not([id='" + row.id + "'])")).invoke("removeClassName", "selectedRow");			
					if (changeTag == 0){
						$("initialParId").value = row.getAttribute("parId");
						$("initialLineCd").value = row.getAttribute("lineCd");
						showBillPremium();
					}else {
						showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function (){
																												saveFuncMain(); //edited by d.alcantara, placed save before reassigning value to initial par id to save proper values in package
																												$("initialParId").value = row.getAttribute("parId");
																												showBillPremium();
																											  }, function () {
																												    $("initialParId").value = row.getAttribute("parId");
																												 	showBillPremium();
																											  }, function () {
																												  	$$("div#packageParPolicyTable div[name='rowPackPar']").each(function(row){
																														if (row.getAttribute("parId") == $F("initialParId")){
																															row.addClassName("selectedRow");
																														}else{
																															row.removeClassName("selectedRow");
																														}				
																													});
																											  });
					}
				}else{
					clearValues();
					refreshList();
					$("invoiceInformationDiv").hide();
					$("winstallmentInfoDiv").hide();
					$("taxInformationDiv").hide();
				}			
			});
		}catch(e){
			showErrorMessage("setPackParPolicyRowObserver", e);
		}
	}	
	function divEventsTax(div) {
		div.observe("mouseover", function () {
			div.addClassName("lightblue");
		});
		
		div.observe("mouseout", function ()	{
			div.removeClassName("lightblue");
		});

		div.observe("click", function () {
			selectedRowId = div.getAttribute("id");
			div.toggleClassName("selectedRow");
			if (div.hasClassName("selectedRow"))	{
				$$("div[name='billPremiumRow']").each(function (r)	{
					if (div.getAttribute("id") != r.getAttribute("id"))	{
						r.removeClassName("selectedRow");
					}else{	
						//$("selTaxDesc").options[$("selTaxDesc").selectedIndex].text = r.getAttribute("taxDesc");
						$("selTaxDesc").hide();
						$("txtTaxDesc").show();
						$("txtTaxDesc").value = unescapeHTML2(r.getAttribute("taxDesc")); //added by robert 11.21.2013
						$("taxChargeAmt").value = formatCurrency(r.getAttribute("taxAmt"));
						$("taxAllocation").value = r.getAttribute("taxAllocation");
						//added by robert 03.12.2013 sr12494
						var fixedTaxAllocation = r.getAttribute("fixedTaxAllocation");
						if(fixedTaxAllocation=="Y"){
							$("taxAllocation").disable();
						}else{
							$("taxAllocation").enable();
						}
						//end robert
						$("btnAddTax").value = "Update";
						$("selTaxDesc").disabled = true;
						enableButton("btnDeleteTax");
						objUW.origTaxAmt = r.getAttribute("taxAmt").replace(/,/g, "");
						objUW.taxCd = r.getAttribute("taxCd");
						objUW.taxId = r.getAttribute("taxId");
						objUW.primarySw = r.getAttribute("primarySw");
						objUW.rate = r.getAttribute("rate");
						objUW.taxType = r.getAttribute("taxType"); //Apollo Cruz 02.17.2015
						objUW.noRateTag = r.getAttribute("noRateTag");
						$("taxChargeAmt").setAttribute("lastValidValue", $F("taxChargeAmt")); //Apollo Cruz 02.17.2015
						var polFlag = objUWParList.packParId == null ? $F("globalPolFlag"): objUWGlobal.polFlag; // start - Gzelle 07272015 SR4819
						objUW.allowUpdateTaxEndtCancellation = '${allowUpdateTaxEndtCancellation}';
						if(nvl(polFlag, null) != null){ 
							var parType = (objUWGlobal.parType != null ? objUWGlobal.parType : $F("globalParType"));
							if(parType == "E" && polFlag == "4" && objUW.allowUpdateTaxEndtCancellation == "N"){
								disableButton("btnDeleteTax");
							}
						}	//end - Gzelle 07272015 SR4819
					}
			    });		
			}else{
				resetDisplayValues();
			} 
			//added by steven 10/08/2012
			//var parTypeCond = (objUWGlobal.parType != null ? objUWGlobal.parType : $F("globalParType")); -- removed, rendundant, causes element is null in endt - irwin
			if(objUW.allowUpdateTaxEndtCancellation != "Y"){ 
				checkIfCancelledEndorsement(); // added by: steven 10/08/2012 - to check if to disable fields if PAR is a cancelled endt	
			}
			//Apollo Cruz
			setBillPremiumsCancellation(false,objUW.allowUpdateTaxEndtCancellation);	//Gzelle 072772015 SR4819
			//setInvoiceTaxDisabled(Math.sign(unformatCurrencyValue($F("premAmt"))) == -1); //added by robert GENQA 4844 09.21.15
		});
	}

	function divEventsInstallment(div) {
		div.observe("mouseover", function () {
			div.addClassName("lightblue");
		});
		
		div.observe("mouseout", function ()	{
			div.removeClassName("lightblue");
		});

		div.observe("click", function () {
			selectedRowId = div.getAttribute("id");
			div.toggleClassName("selectedRow");
			if (div.hasClassName("selectedRow"))	{
				$$("div[name='installmentDtlsRow']").each(function (r)	{
					if (div.getAttribute("id") != r.getAttribute("id"))	{
						r.removeClassName("selectedRow");
					}else{
						$("tableHeaderInstallment").setStyle("background-color:" + $("taxTableHeader").getStyle("background-color"));
						$("installmentInstNo").value = r.getAttribute("instNo");
						$("installmentDueDate").value = nvl(r.getAttribute("dueDate"),""); //added by PJD 8.29.2013 to display blank instead of null SR 0013796 
						$("installmentTotalDue").value = r.getAttribute("amountDue");
						enableButton("btnInstUpdate");
						var polFlag = objUWParList.packParId == null ? $F("globalPolFlag"): objUWGlobal.polFlag; //added by steven 1.29.2013;base on SR 0012056
						objUW.allowUpdateTaxEndtCancellation = '${allowUpdateTaxEndtCancellation}'; //Gzelle 07292015 SR4819
						if(nvl(polFlag, null) != null){ 
							var parType = (objUWGlobal.parType != null ? objUWGlobal.parType : $F("globalParType"));
							if(parType == "E" && polFlag == "4" && objUW.allowUpdateTaxEndtCancellation == "N"){	//Gzelle 07272015 SR4819
								disableDate("hrefDueDate2");
								$("installmentDueDate").readOnly = true;
								disableButton("btnInstUpdate");
							}
						}
					}
			    });		
			}else{
				$("installmentInstNo").value = null;
				$("installmentDueDate").value = null;
				$("installmentTotalDue").value = null;
				disableButton("btnInstUpdate");
			}
			//Apollo Cruz
			setBillPremiumsCancellation(false,objUW.allowUpdateTaxEndtCancellation);	//Gzelle 07272015 SR4819
		});		
	}
	
	function divEventsTakeupDtls(div) {
		try{
		div.observe("mouseover", function () {
			div.addClassName("lightblue");
		});
		
		div.observe("mouseout", function ()	{
			div.removeClassName("lightblue");
		});

		div.observe("click", function () { //pje
			selectedRowId = div.getAttribute("id");
			div.toggleClassName("selectedRow");
			resetDisplayValues(); //added by steven 07.23.2014
			if (div.hasClassName("selectedRow"))	{
				$$("div[name='billPremiumsDtlsRow']").each(function (r)	{
					if (div.getAttribute("id") != r.getAttribute("id"))	{
						r.removeClassName("selectedRow");
					}else{
						$("itemGrp").value = r.getAttribute("itmGrp");
						$("takeupSeqNo").value = r.getAttribute("takeupSeqNo");
						$("totalSharePct").innerHTML = "0";
						$("totalPremAmt").innerHTML =  "0";
						$("totalTaxAmt").innerHTML = "0";
						$("totalAmountDue").innerHTML = "0";
						populateValues(objUW.takeupListDtls);
						objUW.origDueDate  = $F("dueDate");
						populateTaxDtls(objUW.taxCharges, 0);
						objUW.getTaxList(r.getAttribute("itmGrp")); //added by steven 07.22.2014
						var parTypeCond = (objUWGlobal.parType != null ? objUWGlobal.parType : $F("globalParType")); //added by steven 10/08/2012
						var polFlag = objUWParList.packParId == null ? $F("globalPolFlag"): objUWGlobal.polFlag;
						objUW.allowUpdateTaxEndtCancellation = '${allowUpdateTaxEndtCancellation}';	//Gzelle 07292015 SR4819
						if(parTypeCond == "E" && "4" == polFlag && objUW.allowUpdateTaxEndtCancellation == "N"){ 	//Gzelle 07272015 SR4819
							disableButton("btnUpdate");	
						}else{
							enableButton("btnUpdate");
						}
						$("currCheckbox").value = 0;
						showInstallmentDtls(objUW.takeupInstallmentDtls);
						$("winstallmentInfoDiv").hide();
						$("divTotals").show();
						$("paymentSchedLbl").innerHTML = "Show";
					}
			    });
				//Added by Apollo Cruz
				setBillPremiumsCancellation(false,objUW.allowUpdateTaxEndtCancellation);	//Gzelle 07272015 SR4819
				//setInvoiceTaxDisabled(Math.sign(unformatCurrencyValue($F("premAmt"))) == -1); //added by robert GENQA 4844 09.21.15
			}else{
				clearValues();
				refreshList();
				($$("div#invoiceInformation [changed=changed]")).invoke("removeAttribute", "changed"); //belle 09022012
			} 
		});
		}catch (e){
			showErrorMessage("divEventsTakeupDtls", e);
		}
	}
	
	/************** END DIV EVENTS ******************/

	/*********** Loading listing for  Invoice Information ******************/
	function prepareParameters(){
		try {			
			//added by christian 03/01/2013
			for (var i=0; i<objUW.takeupListDtls.length; i++){
					objUW.takeupListDtls[i].property  	= unescapeHTML2(objUW.takeupListDtls[i].property);
					objUW.takeupListDtls[i].remarks  	= unescapeHTML2(objUW.takeupListDtls[i].remarks);
			}
				
			var modifiedWInvoice	= getAddedModifiedJSONObject(objUW.takeupListDtls);
			var addedModifiedWinvTax = getAddedModifiedJSONObject(objUW.taxItems);
			var deletedWinvTax = getDeletedJSONObject(objUW.taxItems);
			var addedModifiedInstallment = getAddedModifiedInstallment(objUW.takeupInstallmentDtls);
			// Sets the parameters			
			var objParameters = new Object();			
			objParameters.modifiedWInvoice	 = modifiedWInvoice;
			objParameters.addedModifiedWinvTax = addedModifiedWinvTax;
			objParameters.deletedWinvTax = deletedWinvTax;
			objParameters.addedModifiedInstallment = addedModifiedInstallment;
			objParameters.allWInvoiceDtls = objUW.takeupListDtls;
			return JSON.stringify(objParameters);
		} catch (e) {
			showErrorMessage("prepareParameters", e);
		}
	}
	
	function doPaytermComputation() {
		new Ajax.Updater("winstallmentInfoDiv", contextPath + "/GIPIWinvoiceController", {
			method : "POST",
			parameters : {
				parId : $F("initialParId"),
				lineCd : objUWParList.lineCd,//$F("globalLineCd"),
				dueDate : $F("dueDate"),
				itemGrp : $F("itemGrp"),
				takeupSeqNo : $F("takeupSeqNo"),
				paytTerms : $F("selPaytTerms"),
				version : 1,
				taxAmt : $("taxAmt") == null ? null : unformatCurrency("taxAmt"),
				otherCharges : $("otherCharges") == null ? null : unformatCurrency("otherCharges"),		
			    parameters : prepareParameters(),
				action : "doPaytermComputation2"
			},
			evalScripts : true,
			asynchronous : true,
			onComplete: function (response) {
				objUW.recomputeInstallment = false;
			}
		});
	}
	
	function setInitialPaymentDtls(){
		try {
			objUW.takeupInstallmentDtls.length = 0;
			$("itemGrp").value = objUW.takeupListDtls[0].itemGrp;
			$("takeupSeqNo").value = objUW.takeupListDtls[0].takeupSeqNo;
			$("dueDate").value = objUW.takeupListDtls[0].dueDate;
			$("selPaytTerms").value = $("selPaytTerms").value == null ? objUW.defPayTerm : null;
			$("noOfPayt").value = $("selPaytTerms").options[$("selPaytTerms").selectedIndex].getAttribute("noOfPayt");
			doPaytermComputation();
			clearValues();
		} catch(e){
			showErrorMessage("setInitialPaymentDtls", e);
		}
	}

	function showTakeupDtls(objArray){
		try {
			var itemTable = $("billPremiumsTableListingContainer");
			if (objArray[0].paytTerms == null ){
				objUW.recomputeInstallment = true;
			}
			
			for(var i=0; i<objArray.length; i++) {					
				var content = prepareTakeupDtlsInfo(objArray[i]);										
				var newDiv = new Element("div");
				newDiv.setAttribute("id", "row"+objArray[i].itemGrp+ "" +objArray[i].takeupSeqNo);
				newDiv.setAttribute("name", "billPremiumsDtlsRow");
				newDiv.setAttribute("itmGrp", objArray[i].itemGrp);
				newDiv.setAttribute("takeupSeqNo", objArray[i].takeupSeqNo);
				newDiv.addClassName("tableRow");
				
				newDiv.update(content);
				itemTable.insert({bottom : newDiv});
				divEventsTakeupDtls(newDiv);
			}
			if (objUW.recomputeInstallment == true) {
				setInitialPaymentDtls();
				objUW.recomputeInstallment = false;
			}
			checkIfToResizeTable("billPremiumsTableListingContainer", "billPremiumsDtlsRow");
			checkTableIfEmpty("billPremiumsDtlsRow", "billPremiumsListingTable");
		} catch (e) {
			showErrorMessage("showTakeupDtls", e);
		}
	}
	
	function prepareTakeupDtlsInfo(obj){
		try {		
			
			var itemTaxInfo =   
			  	'<label style="margin-left: 28px; text-align:center; width: 65px;" id="lblItemGrp'+obj.itemGrp + "" + obj.takeupSeqNo+'">'+ obj.itemGrp +'</label>'+
				'<label style="margin-left: 42px; text-align:center; width: 65px;" id="lblTakeupSeqNo'+obj.itemGrp + "" + obj.takeupSeqNo+'">' + obj.takeupSeqNo + '</label>' +
				'<label style="margin-left: 47px; text-align:left; width: 120px;"  id="lblMultiBookingYY'+obj.itemGrp + "" + obj.takeupSeqNo+'">' + (obj.multiBookingYY + " - " + obj.multiBookingMM) + '</label>' +
				'<label style="margin-left: 9px; text-align:right; width: 110px;;" id="lblPremAmt'+obj.itemGrp + "" + obj.takeupSeqNo+'">' + formatCurrency(obj.premAmt) + '</label>' +
				'<label style="margin-left: 14px; text-align:right; width: 110px;;" id="lblTaxAmt'+obj.itemGrp + "" + obj.takeupSeqNo+'">' + (obj.taxAmt == null ? formatCurrency(0) : formatCurrency(obj.taxAmt)) + '</label>' +
				'<label style="margin-left: 16px; text-align:right; width: 110px;;" id="lblOtherCharges'+obj.itemGrp + "" + obj.takeupSeqNo+'">' + (objUW.issCd != 'RI' ? (formatCurrency(obj.otherCharges) == "" ? "0.00" : (formatCurrency(obj.otherCharges) == "" ? "0.00" : formatCurrency(obj.otherCharges))) : formatCurrency(obj.riCommAmt)) + '</label>' +
				'<label style="margin-left: 16px; text-align:right; width: 110px;;" id="lblAmountDue'+obj.itemGrp + "" + obj.takeupSeqNo+'">' + (obj.amountDue == null ? formatCurrency(0) : formatCurrency(obj.amountDue)) + '</label>';
                
				
			if (obj.paytTerms == null){
				obj.recordStatus = 1;
				obj.paytTerms = "COD";
			}	
			
			return itemTaxInfo;
		} catch (e) {
			showErrorMessage("prepareTakeupDtlsInfo", e);
		}
	}
	
	//belle 07.18.2012 as per Mam VJ booking mth is disabled if takeup term is ST else enabled.
	if(takeupTerm == "ST" || isPack == 'Y'){ // pansamantalang disable muna ung sa package ginagawa palang ung sa takeupterm
		$("selMultiBookingMM").disabled = true;
	}else{
		$("selMultiBookingMM").disabled = false;
	} 
	/*********** END Loading listing for  Invoice Information ******************/

	if (objUW.takeupListDtls.length > 0) {
		objUW.lastTakeupDueDate = Date.parse(objUW.takeupListDtls[objUW.takeupListDtls.length-1].dueDate);
		showTakeupDtls(objUW.takeupListDtls);
	}
	if (recCount == 0){
    	changeTag = 1;
	}else {
		changeTag = 0;
	}	

	/*********** Loading Page Details ******************/
	
	function populateTaxDtls(obj, index){
		var options = "";
		$("selTaxDesc").length = 0;
		$("selTaxDesc").update('<option value="" issCd="" lineCd="" primarySw="" taxId="" rate="" taxDesc="" taxCd="" taxAmt=""></option>');
		for(var i=0; i<obj.length; i++){			
			if (!chkIfTaxExist(obj[i].taxCd)){		
				options+= '<option value="'+obj[i].taxCd+'" taxType="'+obj[i].taxType+'"  tempTaxAmt="'+nvl(obj[i].tempTaxAmt,"0")+'" allocationTag="'+obj[i].allocationTag+'" rate="'+obj[i].rate+'" taxAmt="'+obj[i].taxAmt+'" issCd="'+obj[i].issCd+'" lineCd="'+obj[i].lineCd+'" primarySw="'+obj[i].primarySw+'" taxId="'+obj[i].taxId+'" rate="'+obj[i].rate+'" taxDesc="'+obj[i].taxDesc+'" taxCd="'+obj[i].taxCd+'">'+obj[i].taxDesc+'</option>';
			}
		}
		$("selTaxDesc").insert({bottom: options}); 
		$("selTaxDesc").selectedIndex = index;
	}

	function refreshMultiBooking(bookingMonth, bookingYear) {
		var options = "";
		$("selMultiBookingMM").remove(0);		
		options+= '<option bookingMonth="" bookingYear="" value=""></option>'
				+ '<option bookingMonth="'+ bookingMonth +'" bookingYear="'+ bookingYear +'" value="'+bookingYear + " - " + bookingMonth +'">'+bookingYear + " - " + bookingMonth +'</option>';
		$("selMultiBookingMM").insert({top: options}); 
	}

	function populateValues(obj){
		for(var i=0; i<obj.length; i++){
			if (obj[i].itemGrp == $F("itemGrp") && obj[i].takeupSeqNo == $F("takeupSeqNo")){
				$("selPaytTerms").value = obj[i].paytTerms;
				$("noOfPayt").value = $("selPaytTerms").options[$("selPaytTerms").selectedIndex].getAttribute("noofpayt");//obj[i].noOfPayt;
				$("premAmt").value = formatCurrency(obj[i].premAmt);				
				$("taxAmt").value = obj[i].taxAmt == null ? formatCurrency(0) : formatCurrency(obj[i].taxAmt);
				$("otherCharges").value = obj[i].otherCharges == null ? formatCurrency(0) : formatCurrency(obj[i].otherCharges);
				$("amountDue").value = formatCurrency(obj[i].amountDue);
				//added by gab 04.04.2016 SR 22069
				if ($("selPaytTerms").value == 'COD'){
					var noOfDays = $("selPaytTerms").options[$("selPaytTerms").selectedIndex].getAttribute("noOfDays");
					var onInceptTag = $("selPaytTerms").options[$("selPaytTerms").selectedIndex].getAttribute("onInceptTag");
					if (obj[i].dueDate != objUW.origDueDate){
						if (onInceptTag == "N"){
							var newDate = new Date(Date.parse(obj[i].dueDate)) ; 
							newDate.setDate(newDate.getDate() + parseInt(nvl(noOfDays,0)));
							obj[i].dueDate = newDate.format("mm-dd-yyyy");
						}
					}
				}
				$("dueDate").value = obj[i].dueDate;
				$("selPayType").value = obj[i].payType; //== "R" ? "Credit" : "Cash";
				$("selMultiBookingMM").value = obj[i].multiBookingYY + " - " + obj[i].multiBookingMM;
				oldBookingValue = obj[i].multiBookingYY + " - " + obj[i].multiBookingMM;
				$("refInvNo").value = obj[i].refInvNo;
				$("remarks").value = unescapeHTML2(obj[i].remarks); //added unescapeHTML2 - christian 03/01/2013
				$("policyCurrency").value = obj[i].currencyDesc;
				$("property").value = unescapeHTML2(obj[i].property); //added unescapeHTML2 - christian 03/01/2013
				$("origPaytype").value = obj[i].payType;
				$("currCheckbox").checked = obj[i].policyCurrency == "Y" ? true : false;
				if (objUW.issCd == 'RI'){
					$("commAmt").value = formatCurrency(obj[i].riCommAmt);
					$("riCommVat").value = formatCurrency(obj[i].riCommVat);
				}

				if ($("selMultiBookingMM").value == ""){
					refreshMultiBooking(obj[i].multiBookingMM, obj[i].multiBookingYY);
					$("selMultiBookingMM").value = obj[i].multiBookingYY + " - " + obj[i].multiBookingMM;
				}
				
				refreshList();
				//$("cardName"+$F("itemGrp")+$F("selTakeupSeqNo")).value = obj[i].cardName;
				//$("cardNo"+$F("itemGrp")+$F("selTakeupSeqNo")).value = obj[i].cardNo;
				//$("cardExpiryDate"+$F("itemGrp")+$F("selTakeupSeqNo")).value = obj[i].expiryDate; 
				//$("approvalCd"+$F("itemGrp")+$F("selTakeupSeqNo")).value = obj[i].approvalCd;
				break;
			}
		}
	}

	/*********** END Loading Page Details ******************/

	/*********** Loading listing for   Tax Information ******************/
	
	function showTaxList(objArray){
		try {
			var itemTable = $("billPremiumsTableContainer");
			for(var i=0; i<objArray.length; i++) {	
				if ($F("itemGrp") == objArray[i].itemGrp && $F("takeupSeqNo") == objArray[i].takeupSeqNo && parseInt(objArray[i].recordStatus) != -1){			
					var content = prepareTaxListInfo(objArray[i]);									
					var newDiv = new Element("div");
					newDiv.setAttribute("id", "row"+objArray[i].itemGrp+ "" +objArray[i].takeupSeqNo + objArray[i].taxCd);
					newDiv.setAttribute("name", "billPremiumRow");
					newDiv.setAttribute("taxId", objArray[i].taxId);
					newDiv.setAttribute("taxCd", objArray[i].taxCd);
					newDiv.setAttribute("taxAmt", objArray[i].taxAmt);
					newDiv.setAttribute("rate", objArray[i].rate);
					newDiv.setAttribute("taxAllocation", objArray[i].taxAllocation);
					newDiv.setAttribute("primarySw", objArray[i].primarySw);
					newDiv.setAttribute("taxDesc", objArray[i].taxDesc);
					newDiv.setAttribute("fixedTaxAllocation", objArray[i].fixedTaxAllocation); //robert 03.12.2013 sr12494
					newDiv.setAttribute("taxType", objArray[i].taxType); //Apollo Cruz 02.17.2015
					newDiv.setAttribute("noRateTag", objArray[i].noRateTag);
					newDiv.addClassName("tableRow");
					
					newDiv.update(content);
					itemTable.insert({bottom : newDiv});
					checkIfToResizeTable("billPremiumsTableContainer", "billPremiumRow");
					divEventsTax(newDiv);
				}	
					
			}
			checkTableIfEmpty("billPremiumRow", "billPremiumsTable");
		} catch (e) {
			showErrorMessage("showTaxList", e);
			//showMessageBox("showTaxList : " + e.message);
		}
	}
	
	function prepareTaxListInfo(obj){
		try {		
			var itemTaxInfo =   
			  	'<label style="padding-left:3%; width:10%; text-align:right; ">'+ obj.taxCd +'</label>'+
				'<label style="padding-left:11%; width:25%; text-align:left; ">' + obj.taxDesc + '</label>' +
				'<label style="width:20%; text-align:right; margin-left: 13px;" class="money" id="lblTaxAmount'+ obj.itemGrp + obj.takeupSeqNo + obj.taxCd +'" >' + formatCurrency(obj.taxAmt)+ '</label>' +
				'<label style="padding-left:10%; width:16%; text-align:left; " id="lblTaxAllocation'+ obj.itemGrp + obj.takeupSeqNo + obj.taxCd +'">' + obj.taxAllocation + '</label>';
				
			return itemTaxInfo;
		} catch (e) {
			showErrorMessage("prepareTaxListInfo", e);
			//showMessageBox("prepareTaxListInfo : " + e.message);
		}
	}

	/*********** END Loading listing for   Tax Information ******************/	

	/*********** Loading listing for Payment Schedule ******************/
	
	function showInstallmentDtls(objArray){
		try {
			var selItemGrp = $F("itemGrp");
			var selTakeup  = $F("takeupSeqNo");
			var itemTable = $("installmentTableListingContainer");
			
			refreshInstallmentDiv();

			for(var i=0; i<objArray.length; i++) {					
				if(objArray[i].itemGrp == selItemGrp && objArray[i].takeupSeqNo == selTakeup){
					var content = prepareInstallmentDtlsInfo(objArray[i]);										
					var newDiv = new Element("div");
					newDiv.setAttribute("id", "row"+objArray[i].itemGrp+ "" +objArray[i].takeupSeqNo + "" + objArray[i].instNo);
					newDiv.setAttribute("name", "installmentDtlsRow");
					newDiv.setAttribute("itmGrp", objArray[i].itemGrp);
					newDiv.setAttribute("takeupSeqNo", objArray[i].takeupSeqNo);
					newDiv.setAttribute("instNo", objArray[i].instNo);
					newDiv.setAttribute("dueDate", objArray[i].dueDate);
					newDiv.setAttribute("amountDue", formatCurrency(parseFloat(objArray[i].premAmt) + parseFloat(objArray[i].taxAmt)));
					newDiv.addClassName("tableRow");
					
					newDiv.update(content);
					itemTable.insert({bottom : newDiv});
					divEventsInstallment(newDiv);
				}
			}

			$("totalSharePct").innerHTML = formatCurrency($("totalSharePct").innerHTML);
			$("totalPremAmt").innerHTML =  formatCurrency(parseFloat($("totalPremAmt").innerHTML));
			$("totalTaxAmt").innerHTML = formatCurrency(parseFloat($("totalTaxAmt").innerHTML));
			$("totalAmountDue").innerHTML = formatCurrency(parseFloat($("totalAmountDue").innerHTML));
			
			checkIfToResizeTable("installmentTableListingContainer", "installmentDtlsRow");
			checkTableIfEmpty("installmentDtlsRow", "installmentListingTable");
			
		} catch (e) {
			showErrorMessage("showInstallmentDtls", e);
			//showMessageBox("showInstallmentDtls : " + e.message);
		}
	}
	
	function prepareInstallmentDtlsInfo(obj){
		try {		
			var selItemGrp = $F("itemGrp");
			var selTakeup  = $F("takeupSeqNo");
			if (obj.itemGrp == selItemGrp && obj.takeupSeqNo == selTakeup){
				var margin = "25px";           //added by PJD 08.29.2013 
				if(nvl(obj.dueDate, "") == ""){//to adjust the margin if 
					margin = "170px";          //due date value is null.SR 0013796 
				}

				var itemTaxInfo =   		
				  	'<label style="width: 10%; text-align: right;">'+ obj.instNo +'</label>'+
					'<label style="width: 13%; text-align: right; margin-left: 29px;" id="lblInstallmentDueDate'+ selItemGrp + selTakeup + obj.instNo +'">' + nvl(obj.dueDate, "") + '</label>' +
					//'<label style="width: 13%; text-align: right; margin-left: 25px;" >' + obj.sharePct + '</label>' +
					'<label style="width: 13%; text-align: right; margin-left: ' + margin + ';" >' + obj.sharePct + '</label>' +
					'<label style="width: 13%; text-align: right; margin-left: 65px;">' + formatCurrency(obj.premAmt) + '</label>' +
					'<label style="width: 13%; text-align: right; margin-left: 36px;">' + formatCurrency(obj.taxAmt) + '</label>' +
					'<label style="width: 13%; text-align: right; margin-left: 45px;">' + formatCurrency(parseFloat(obj.premAmt) + parseFloat(obj.taxAmt)) + '</label>';
				
					$("totalSharePct").innerHTML = parseFloat($("totalSharePct").innerHTML.replace(/,/g, ""))  + parseFloat(obj.sharePct);
					$("totalPremAmt").innerHTML =  parseFloat($("totalPremAmt").innerHTML.replace(/,/g, "")) +  parseFloat(obj.premAmt);
					$("totalTaxAmt").innerHTML =   parseFloat($("totalTaxAmt").innerHTML.replace(/,/g, "")) + parseFloat(obj.taxAmt);
					$("totalAmountDue").innerHTML = parseFloat($("totalAmountDue").innerHTML.replace(/,/g, "")) + (parseFloat(obj.premAmt) + parseFloat(obj.taxAmt));
					
				return itemTaxInfo;
			}	
		} catch (e) {
			showErrorMessage("prepareInstallmentDtlsInfo", e);
			//showMessageBox("prepareInstallmentInfo : " + e.message);
		}
	}
	
	/*********** END Loading listing for Payment Schedule ******************/	
	
	/************** AJAX CALLS ******************/
	function showCreditCardInfo() {
		$("cardInfo").setStyle( {
			display : ""
		});
		new Ajax.Updater("creditCardInfoDiv", contextPath
				+ "/GIPIWinvoiceController", {
			method : "GET",
			parameters : {
				parId : $F("initialParId"),//$F("globalParId"),
				action : "showCreditCardInfo"
			},
			evalScripts : true,
			asynchronous : true,
			onComplete : function() {
				hideNotice("Done!");
				Effect.Appear("billMainDiv", {
					duration : 1
				});
			}
		});
	
	}
	
	function showPaymentSchedule() {
		try{
			$("installmentInfo").setStyle( {
				display : "block"
			});
			new Ajax.Updater("winstallmentInfoDiv", contextPath
					+ "/GIPIWInstallmentController", {
				method : "GET",
				parameters : {
					parId : $F("globalParId"),
					itemGrp : $F("itemGrp"),
					takeupSeqNo : $F("takeupSeqNo"),
					action : "showPaymentSchedule"
				},
				evalScripts : true,
				asynchronous : false,
				onComplete : function() {
					hideNotice("Done!");
					$("paymentSchedLbl").innerHTML = "Show";
					$("winstallmentInfoDiv").hide();
				}
			});
		}catch(e){
			showErrorMessage("showPaymentSchedule", e);
		}
	}	
	
	function saveFuncMain(){
		//validateInvoices(); //belle 07.25.2012
		/* if (isValid == false){
			validateBookingDate();
		}else{
			fireEvent($("btnUpdate"), "click"); */ //belle 09022012
		if(checkPendingRecordChanges()){		
			//belle 09012012 get booking MM and YY of takeupseqno = 1 used to update gipi_wpolbas
			if(changeTag == 0){showMessageBox(objCommonMessage.NO_CHANGES ,imgMessage.INFO); return;}
			$$("div#billPremiumsTableListingContainer div[name='billPremiumsDtlsRow']").each(function(row){
		 		if (row.getAttribute("takeupSeqNo") == 1){
					bookingDate = (row.down("label", 2).innerHTML).split("-");
					bookingYy   = bookingDate[0].trim();
					bookingMm   = bookingDate[1].trim();
				}
			});
			
			var assured = escapeHTML2($F("assuredName").truncate(50, "")); // nica 09.11.2012 temporary solution to truncate assured name to 50 chars beacuse GIPI_WINVOICE.insured is only 50 characters
			
			if(objUW.allowUpdate){ // andrew- 09.14.2011
				new Ajax.Request(contextPath + "/GIPIWinvoiceController?action=saveWInvoice" , {
					method: "POST",
					parameters: {
						billPremiumsParams: prepareParameters(),
						parId : $F("initialParId"),//objUWParList.parId,
						//packParId: objUWParList.packParId, // andrew - 07.18.2011 - changed to objUWGlobal.packParId
						packParId: objUWGlobal.packParId,
						//globalPackParId: objUWParList.packParId == "0" ? null : objUWParList.packParId, // andrew - 07.18.2011 - changed to objUWGlobal.packParId
						globalPackParId: objUWGlobal.packParId == "0" ? null : objUWGlobal.packParId,
						itemGrp: $F("itemGrp") == "" ? 1 : $F("itemGrp") ,
						takeupSeqNo: $F("takeupSeqNo") == "" ? 1 : $F("takeupSeqNo"),
						riCommVat: 0,
						lineCd : objUWParList.lineCd,
						dueDate : objUW.takeupListDtls[0].dueDate,
						paytTerms : $F("selPaytTerms"),
						insured: assured, //escapeHTML2($F("assuredName")),
						version : 1,
						bookingYy : bookingYy, //belle 09012012
						bookingMm : bookingMm
					},
					asynchronous: false,
					evalScripts: true,
					onCreate : showNotice("Processing, please wait..."),
					onComplete: function (response) {
						hideNotice();
						var result = response.responseText;
						if (result == "SUCCESS"){
							//showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
							showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, showBillPremium); // andrew - 09.21.2011
							//enableMenu("enterInvoiceCommission");
							if(objUWGlobal.packParId != null || objUWGlobal.packParId != undefined){ // andrew - 07.08.2011 - to update na package par parameters
								updatePackParParameters();						
							} else {
								updateParParameters();
							}
							if (objUWParList.issCd == 'RI') {
								disableMenu("enterInvoiceCommission");
							}
							changeTag = 0; // andrew - 09.21.2011
						}
					}
			    });
			}
		}
	}
	
	/************** END AJAX CALLS ******************/
	
	
	/************** Validation CALLS ******************/
	
	/* function validateDueDate(){
		var credExpiryDate = objUW.credExpiryDate;
		var credEffDate = objUW.credEffDate;
		var newDate = dateFormat(Date.parse($("dueDate").value), "yyyy-mm-dd");	
		//var dateSplit = newDate.split('-');
		var isValid = true;
		if  (newDate < credEffDate)  {
			customShowMessageBox("Due date schedule must not be earlier than the inception date of the policy.", imgMessage.ERROR, "dueDate");
			isValid = false;
		}else if  (newDate  > credExpiryDate && objUW.allowExpiredPolIssuance == "N") { //added allowExpiredPolIssuance by robert SR 19785 07.20.15
	    	customShowMessageBox("Due date schedule must not be later than the expiry date of the policy.", imgMessage.ERROR, "dueDate");
	    	isValid = false;
		}
		
		return isValid; 
	} */
	
	function chkIfTaxExist(taxCd){
		var exist = false;

		for (var i=0; i<objUW.taxItems.length; i++){
			if (objUW.taxItems[i].taxCd == taxCd && objUW.taxItems[i].recordStatus != -1){
				exist = true;
				//break;
			}
		}
		return exist;
	}

	function validateEntries(){	
		var isValid = true;
		
		/*if (objUW.allowBookingInAdvance == "N" && validateBookingDate()){ // andrew - 07.24.2012 - moved this validation to onChange event of selMultiBookingMM select element
			objUW.allowUpdate = false;
			return false;
		} else */
		if (objUW.allowBookingInAdvance == "N" && !validateDueDate($F("dueDate"))) {
			objUW.allowUpdate = false;
			return false;
		}
		objUW.allowUpdate = true;
		return isValid;
	}
	
	objUW.validateEntries =	validateEntries; // andrew - 09.22.2011
	
	function validateBookingDate(){
		var isValid = false;
		var effDate = dateFormat(objUW.effDate, "mm-dd-yyyy"); 
		var expDate = dateFormat(objUW.expiryDate, "mm-dd-yyyy");
		var selBookingDate = dateFormat($F("selMultiBookingMM"), "mm-dd-yyyy");
		var oldBookingDate = dateFormat(objUW.inceptDate, "mm-dd-yyyy"); 
		var nxtBookingDate = "";
		var prevBookingDate = ""; //belle 09012012
		var nxtTakeupNo    = (parseInt(nvl($F("takeupSeqNo"),0)) + 1 ); 
		var prevTakeupNo   = (parseInt(nvl($F("takeupSeqNo"),0)) - 1 ); //belle 09012012
		
		/* for (var i=0; i<objUW.takeupListDtls.length; i++){
			if(objUW.takeupListDtls[i].itemGrp == $F("itemGrp") && objUW.takeupListDtls[i].takeupSeqNo == nxtTakeupNo){
				nxtBookingDate = dateFormat(objUW.takeupListDtls[i].multiBookingDate, "mm-dd-yyyy");
			}
		}*/ //belle 09012012 replaced by codes below
		
	 	$$("div#billPremiumsTableListingContainer div[name='billPremiumsDtlsRow']").each(function(row){
	 		if (row.getAttribute("takeupSeqNo") == nxtTakeupNo){
				nxtBookingDate = dateFormat(row.down("label", 2).innerHTML, "mm-dd-yyyy");
			}else if (row.getAttribute("takeupSeqNo") == prevTakeupNo){
				prevBookingDate = dateFormat(row.down("label", 2).innerHTML, "mm-dd-yyyy");
			}
		});
	
		new Ajax.Request(contextPath + "/GIPIWinvoiceController?action=validateBookingDate3" , {
			method: "POST",
			parameters: {
				ajax:           1,
				effDate:		effDate,
				expDate: 		expDate,  
				selBookingDate: selBookingDate,
				oldBookingDate: oldBookingDate,
				nxtBookingDate: nxtBookingDate,
				prevBookingDate: prevBookingDate
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function (response){
				if (checkCustomErrorOnResponse(response)){
					isValid = true;
				}
			}
			
		});
		return isValid;
	}

	function checkPolicyCurrency() {
		var parId;
		var currencyDesc;
		new Ajax.Request(
				contextPath + "/GIPIWinvoiceController",
				{
					method : "POST",
					parameters : {
						parId : $F("initialParId"),//$F("globalParId"), robert 10.17.2012
						currencyDesc : $F("policyCurrency"),
						action : "checkPolicyCurrency"
					},
					evalScripts : true,
					asynchronous : true,
					onComplete : function(response) {
						if (response.responseText == 'Y') {
							$("currCheckbox").checked = false;
							showMessageBox('You are allowed to tag this option only for a single-currency Policy.', imgMessage.INFO);
						} else {
							showMessage(response.responseText, imgMessage.ERROR);
						}
					}
				});
	}
	
	//belle 07.25.2012
	function validateB4Update(){
		if (validateEntries()) {
			if ($("selMultiBookingMM").selectedIndex != 0){
				if (propertyInvalid == false) {
					setModifiedWinvoice();
					if (objUW.recomputeInstallment == true){
						objUW.takeupInstallmentDtls.length = 0;
						doPaytermComputation();
						objUW.recomputeInstallment = false;
					}
					clearValues(); 
					refreshList();
				}else {
					showMessageBox("There is no value entered on property/item for item group(s) " + $F("itemGrp")+ ". Please enter a value.", imgMessage.ERROR);
					isValid = false;
				}
			}
		}else{
			showMessageBox("Please select a booking date.", imgMessage.ERROR);
				isValid = false;
		}
	}
			
	/************** End Validation CALLS ******************/	
	
	/*******************OBSERVE ITEMS ****************************/

	$("btnSave").observe("click", function () {
		/* if(changeTag == 0){showMessageBox(objCommonMessage.NO_CHANGES ,imgMessage.INFO); return;} */
		//if(validateDueDate()){ //added by robert SR 19785 07.20.15
			//added by PJD 08.29.2013 to not allow saving if there are due dates that has no value in the due date fields.SR 0013796 
			var proceed = true;
			for(var i = 0; i < objUW.takeupInstallmentDtls.length; i++){
				if(nvl(objUW.takeupInstallmentDtls[i].dueDate, "") == ""){
					proceed = false;
				} else {
					proceed = validateDueDate(objUW.takeupInstallmentDtls[i].dueDate);
				}
			}
			
			if(proceed){
				saveFuncMain();
			}else{
				showMessageBox("Please complete due dates in Payment Schedule block.", "I");
			} 
		//} //end robert SR 19785 07.20.15
		//changeTag = 0; // andrew - 09.21.2011
	});

	$("selPayType").observe("click", function() {
		if ($F("lastIndex") != 0) {
			$("selPayType").selectedIndex = 0;
			$("lastIndex").value = 0;
		}
	});

	$("selPayType").observe("change", function() {
		if ($("selPayType").options[$("selPayType").selectedIndex].value != "A"){
			showOverlayContent2(contextPath+"/GIPIWinvoiceController?action=showCreditCardInfo&parId=" + $F("initialParId") //objUWParList.parId
								 , "Credit Card Information", 400, "", 100);			
		}

		if ($("selPayType").value == "A") {
			$("selCreditCard").options[$("selCreditCard").selectedIndex].value = null;
			$("creditCardNo").value = null;
			$("creditCardExpiryDate").value = null;
			$("creditCardApprovalCd").value = null;
		}
	});
	
	//belle 07.24.2012
	var changeBookingDate = 0;
	var isValid = true; 
	$("selMultiBookingMM").observe("change", function(){
		if(validateBookingDate()){
			isValid = true;
		}else{
			isValid = false;
		}
		changeBookingDate = 1;  
	});
	
	$("btnUpdate").observe("click", function (){
		if (changeBookingDate == 1){ 
			if (validateBookingDate()){
				validateB4Update();
				($$("div#invoiceInformation [changed=changed]")).invoke("removeAttribute", "changed");
			}else{
				isValid = false;
			}
		}else{
			if(validateDueDate($F("dueDate"))){ //added by robert SR 19785 07.20.15
				validateB4Update(); 
				($$("div#invoiceInformation [changed=changed]")).invoke("removeAttribute", "changed"); 
			} // end robert SR 19785 07.20.15
		} 
	}); //belle 09022012
	
	/*$("selMultiBookingMM").observe("change", function(){
		validateBookingDate(); 
	});
	
	$("btnUpdate").observe("click", function (){
		if (validateBookingDate()){
			validateB4Update();
			changeTag = 1; 
			($$("div#invoiceInformation [changed=changed]")).invoke("removeAttribute", "changed"); 
		}
	});*/
	
	$("hiddenButtonUpdate").observe("click", function (){
		if (validateEntries()) {
			setModifiedWinvoice();
			objUW.takeupInstallmentDtls.length = 0;
			doPaytermComputation();
			//clearValues();
		}
	});

	$("paymentSchedLbl").observe("click", function(){ 
		if ($("paymentSchedLbl").innerHTML == "Show"){
			Effect.toggle('winstallmentInfoDiv', 'appear', { duration: .5 });
		}else{
			Effect.toggle('winstallmentInfoDiv', 'blind', { duration: .5 });
		}
	});

	$("selPaytTerms").observe("change", function () {
		var noOfDays = $("selPaytTerms").options[$("selPaytTerms").selectedIndex].getAttribute("noOfDays");
		var onInceptTag = $("selPaytTerms").options[$("selPaytTerms").selectedIndex].getAttribute("onInceptTag");
		
		objUW.recomputeInstallment = true;
		$("noOfPayt").value = $("selPaytTerms").options[$("selPaytTerms").selectedIndex].getAttribute("noOfPayt");
		if (onInceptTag == "N"){
			var newDate = new Date(Date.parse(objUW.origDueDate)) ; 
			newDate.setDate(newDate.getDate() + parseInt(noOfDays));
			$("dueDate").value = newDate.format("mm-dd-yyyy");
		}else {
			$("dueDate").value = objUW.origDueDate;
		}
	});
	
	/*$("dueDate").observe("change", function () { 
		var dueDate = Date.parse(this.value);
		var expiryDate = Date.parse(objUWParList.strExpiryDate);
		var inceptDate = Date.parse(objUWParList.strInceptDate);
	
		
		if(compareDatesIgnoreTime(dueDate, inceptDate) == 1){
			customShowMessageBox("Due date schedule must not be earlier than the inception date of the policy.","I","dueDate");
			this.value = scwOriginalDate;
			this.focus();
			return false;
		}else if(compareDatesIgnoreTime(dueDate, expiryDate) == -1 && objUW.allowExpiredPolIssuance == "N"){ //added allowExpiredPolIssuance by robert SR 19785 07.20.15
			customShowMessageBox("Due date schedule must not be later than the expiry date of the policy.","I","dueDate");
			this.value = scwOriginalDate;
			this.focus();
			return false;
		}else{
			objUW.recomputeInstallment = true;	
		}
		
	});*/
	
	// apollo cruz 09.03.2015 - sr#19975
	// modified codes to consider prod_take_up parameter in giac_parameters
	function validateDueDate(inDueDate) {
		var dueDate = Date.parse(inDueDate);
		var issueDate = Date.parse($F("hiddenIssueDate"));
		var effDate = Date.parse($F("hiddenEffDate"));
		var prodTakeUp = '${prodTakeUp}';
		var prodTakeUpDate = issueDate;
		var strDate = "issue date";
		
		/*if(prodTakeUp == "1" || prodTakeUp == "3") {
			prodTakeUpDate = issueDate;
			strDate = "issue date";
		} else {
			if(compareDatesIgnoreTime(issueDate, effDate) == -1) {
				prodTakeUpDate = issueDate;
				strDate = "issue date";
			}				
			else {
				prodTakeUpDate = effDate;
				strDate = "effectivity date";
			}				
		}*/
		
		/* apollo cruz 10.09.2015 GENQA 5044 */
		if(prodTakeUp == "1") {
			prodTakeUpDate = issueDate;
			strDate = "issue date";
		} else if (prodTakeUp == "2") {
			prodTakeUpDate = effDate;
			strDate = "effectivity date";
		} else {
			if(compareDatesIgnoreTime(issueDate, effDate) == -1) {
				prodTakeUpDate = issueDate;
				strDate = "issue date";
			}				
			else {
				prodTakeUpDate = effDate;
				strDate = "effectivity date";
			}	
		}
		
		if(compareDatesIgnoreTime(dueDate, prodTakeUpDate) == 1){
			customShowMessageBox("Due date schedule must not be earlier than the " + strDate + " of the policy.","I","dueDate");
			$("dueDate").value = scwOriginalDate;
			$("dueDate").focus();
			return false;
		}else if(compareDatesIgnoreTime(dueDate, Date.parse(objUW.credExpiryDate)) == -1 && objUW.allowExpiredPolIssuance == "N"){ //changed to objUW.credExpiryDate kenneth SR 22090 04.08.2016
			customShowMessageBox("Due date schedule must not be later than the expiry date of the policy.","I","dueDate");
			$("dueDate").value = scwOriginalDate;
			$("dueDate").focus();
			return false;
		}
		
		return true;
	}
	
	// apollo cruz 09.03.2015 - sr#19975
	// modified codes to consider prod_take_up parameter in giac_parameters
	$("dueDate").observe("change", function () {		
		if (validateDueDate(this.value))
			objUW.recomputeInstallment = true;				
	});
	
	$("editRemarks").observe("click", function () {
		showOverlayEditor("remarks", 4000, $("remarks").hasAttribute("readonly"));
	});

	$("currCheckbox").observe("change", function() {
		if ($("currCheckbox").value == 0) {
			$("currCheckbox").checked = true;
			$("currCheckbox").value = 1;
			checkPolicyCurrency();
		} else {
			$("currCheckbox").value = 0;
			$("currCheckbox").checked = false;
		}
	});
	
	function exitBillPremiums() {
		if (isPack == "Y") {
			goBackToPackagePARListing();
		}else{
			goBackToParListing();
		}
	}

	$("btnCancel").observe("click", function () {
		//fireEvent($("parExit"), "click");
		// added by d.alcantara, fireEvent does not work when in package if the user went to the item info screen first
		if(changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					/* function(){saveFuncMain();exitBillPremiums();}, exitBillPremiums, ""); */ //belle 07.25.2012
					function(){if (isValid == true){ 
							   		saveFuncMain();
									exitBillPremiums();
							   }else{
								  validateBookingDate();
							   }
					}, 
					exitBillPremiums,
					"");
		} else {
			exitBillPremiums();
		}
	});

	$("reloadForm").observe("click", function () {
		if(changeTag == 1){
			showConfirmBox("CONFIRMATION", "Reloading form will disregard all changes. Proceed?", "Yes", "No", function () {
																													showBillPremium();
																														changeTag = 0;
																												}, "");
		} else {
			showBillPremium();
		}
	});
	
	$("property").observe("change", function () {
		if ($F("property") == ""){
			propertyInvalid = true;
		}else {
			propertyInvalid = false;
		}
	});

	if (takeupTerm == "MTH") {
		$("selPaytTerms").disabled = true;
	}
	
	/*************************************************************/
 	$$("div#packageParPolicyTable div[name='rowPackPar']").each(function(row){
		if (row.getAttribute("parId") == $F("initialParId")){
			row.addClassName("selectedRow");
		}				
	});
	//initializeAccordion();
 	// added by robert GENQA 4844 09.21.15
 	// requested to be commented out by ma'am vj - apollo cruz 10.15.2015
 	/* function setInvoiceTaxDisabled(negPrem){
 		 		
 		if (negPrem){
 			$$("div#invoiceTaxMainDiv input[type='text'], textarea").each(function(obj){
 				obj.readOnly = true;
 			});
 			
 			$$("div#invoiceTaxMainDiv input[type='button']").each(function(obj){		
 				if(obj.id != "btnCancel" && obj.id != "btnSave")
 					disableButton(obj.id);
 			});
 			
 			$$("div#invoiceTaxMainDiv select, input[type='checkbox']").each(function(obj){
 				obj.disable();
 			});
 		}
 	}  */
 	// end robert GENQA 4844 09.21.15
	initializeAll();
	initializeAllMoneyFields();
	initializeChangeTagBehavior(saveFuncMain);
	initializeChangeAttribute(); //belle 09022012
</script>

