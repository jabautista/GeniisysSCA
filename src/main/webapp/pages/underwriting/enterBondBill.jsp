<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="outerDiv" name="outerDiv">
  <div id="innerDiv" name="innerDiv">
     <label>PAR Information</label> 
      <span class="refreshers" style="margin-top: 0;"> 
       <label name="gro" style="margin-left: 5px;">Hide</label> 
       <label id="reloadForm" name="reloadForm">Reload Form</label>
      </span>
  </div>
</div>
<div class="sectionDiv" id="enterBondBillInformationDiv">
	<input type="hidden" id="newWinvoiceFlag" value="N" />
	<input type="hidden" id="issCdRI" value="${issCdRI}" />
	<input type="hidden" id="bondIssCd" value="${bondHeaderDtls.issCd}" />
	<input type="hidden" id="bondInputVatRate" value="${invoiceInfo.inputVatRate}" />
	<input type="hidden" id="hiddenTaxCd" />
	<input type="hidden" id="hiddenTaxDesc" />
	<input type="hidden" id="hiddenTaxAmt" />
	<input type="hidden" id="hiddenTaxAlloc" />
	<input type="hidden" id="hiddenTaxId" />
	<input type="hidden" id="hiddenNoRateTag" />
	<input type="hidden" id="hiddenTaxRate" />
	<input type="hidden" id="hiddenDueDate" />
	<input type="hidden" id="hiddenPrimarySw" />
	<input type="hidden" id="hiddenEffDate" />
	<input type="hidden" id="hiddenExpiryDate" />
	<input type="hidden" id="hiddenIssueDate" value="${bondHeaderDtls.issueDate}" /> 

	<div id="parInformationHeader" style="margin: 10px;">
		<table width="80%" align="center" cellspacing="1" border="0">
 			<tr>
				<td class="rightAligned" style="width: 103px;">PAR No.</td>
				<td class="leftAligned"><input id="bondParNo" style="width: 210px;" type="text" value="${bondHeaderDtls.parNo}" readonly="readonly" class="list" /></td>
				<td class="rightAligned" style="width: 103px;">Principal</td>
				<td class="leftAligned"><input id="bondAssdName" type="text" style="width: 210px;" value="${bondHeaderDtls.assdName}" readonly="readonly" class="list" /></td>
			</tr>
		</table>
	</div>
</div>	 
	
<div id="outerDiv" name="outerDiv">
  <div id="innerDiv" name="innerDiv">
     <label>Invoice Information</label> 
      <span class="refreshers" style="margin-top: 0;"> 
       <label name="gro" style="margin-left: 5px;">Hide</label> 
       
      </span>
  </div>
</div>
<div id="bondBillMainContainerDiv">	
	<div class="sectionDiv" id="invoiceInformationDiv">	
		<div id="invoiceInformationHeader" style="margin: 10px;">
			<table width="80%" align="center" cellspacing="1" border="0">
	 			<tr>
					<td class="rightAligned" style="width: 150px;" >Total Bond Amount</td> 
					<td class="leftAligned"><input id="bondTotalAmt" name="bondTotalAmt" style="width: 150px;" type="text" value="${invoiceInfo.bondTsiAmt}" class="money required" /></td>
					<td class="rightAligned" style="width: 150px;">Total Tax Amount</td>
					<td class="leftAligned"><input id="bondTotalTaxAmt" type="text" style="width: 150px;" readonly="readonly"  value="${invoiceInfo.taxAmt}"  class="money" /></td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 150px;" for="bondRateTotal">Total Bond Rate</td>
					<td class="leftAligned"><input id="bondRateTotal" style="width: 150px;" type="text" value="${invoiceInfo.bondRate}" class="moneyRate required" /></td>
					<td class="rightAligned" style="width: 150px;">Total Amount Due</td>
					<td class="leftAligned"><input id="bondTotalAmtDue" type="text" style="width: 150px;" value="${invoiceInfo.totalAmountDue}" readonly="readonly" class="money" /></td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 150px;" for="bondPremTotal">Total Premium Amount</td>
					<td class="leftAligned"><input id="bondPremTotal" style="width: 150px;" type="text" value="${invoiceInfo.premAmt}" class="money required" /></td>
					<!-- <td class="rightAligned" style="width: 150px;"><label style="float: right; " id="lblRiCommAmt">RI Comm Amount</label></td> -->
					<td class="rightAligned" style="width: 150px;" id="lblRiCommAmt" for="bondRiCommAmt">RI Comm Amount</td>
					<td class="leftAligned"><input id="bondRiCommAmt" type="text" style="width: 150px; display: none;" value="${invoiceInfo.riCommAmt}" class="money" /></td>
				</tr>
				<tr>
					<!-- <td class="rightAligned" style="width: 150px;"><label style="float: right;" id="lblRiCommRt" for="bondRiCommRt" >RI Comm Rate</label></td> -->
					<td class="rightAligned" style="width: 150px;" id="lblRiCommRt" for="bondRiCommRt">RI Comm Rate</td>
					<td class="leftAligned"><input id="bondRiCommRt" style="width: 150px; display: none;" type="text" value="${invoiceInfo.riCommRt}" class="money required" /></td>
					<!-- <td class="rightAligned" style="width: 150px;"><label style="float: right;" id="lblRiCommVat">RI Comm VAT</label></td> -->
					<td class="rightAligned" style="width: 150px;" id="lblRiCommVat" for="bondRiCommVat">RI Comm VAT </td>
					<td class="leftAligned"><input id="bondRiCommVat" type="text" style="width: 150px; display: none;" value="${invoiceInfo.riCommVat}" class="money"  readonly = "readonly"/></td>
				</tr>
				<tr>
					<td style="margin-top: 40px; height: 20px;"></td>
				</tr>
				<tr>
					<td colspan="4" align="center"> <input type="button" class="disabledButton" id="createInvoiceBtn" name="createInvoice" value="Create Invoice/s" style="width: 110px;" /></td>
				</tr>
			</table>
		</div>
	</div>	
	<div class="sectionDiv" id="invoiceInformationFooterDiv">
		<div style="width: 100%;" id="invoiceInformationTableList" class="tableContainer" style="margin-top: 10px;">
			<jsp:include page="subPages/enterBondBillTakeUpListing.jsp"></jsp:include>
		</div>	
		<div id="invoiceInformationFooterHeader" style="margin: 10px;">
			<table width="80%" align="center" cellspacing="1" border="0">
	 			<tr>
					<td class="rightAligned" style="width: 150px;">Takeup Sequence No.</td>
					<td class="leftAligned" style="width: 110px;" ><input id="bondTakeUpSeqNo" style="width: 150px; text-align: right;" type="text" value="" readonly="readonly" /></td>
					<td class="rightAligned" style="width: 124px;">Booking Date</td>
					<td class="leftAligned" style=";">
						<select id="bondBookingDate" name="bondBookingDate" style="width: 157px; padding-top: 2px;" class="required" >
							<option value="">Select..</option>
						</select>	
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Bond Amount</td>
					<td class="leftAligned"><input id="takeupBondAmt" style="width: 150px;" type="text" value="" class="money" readonly="readonly" /></td>
					<td class="rightAligned">Premium Amount</td>
					<td class="leftAligned"><input id="takeupPremAmt" type="text" style="width: 150px;" value="" readonly="readonly" class="money" /></td>
				</tr>
				<tr>
					<td class="rightAligned">Bond Rate</td>
					<td class="leftAligned"><input id="takeupBondRt" style="width: 150px;" type="text" value="" readonly="readonly" class="moneyRate" /></td>
					<td class="rightAligned">Total Tax</td>
					<td class="leftAligned"><input id="takeupTaxTotal" type="text" style="width: 150px;" value="" readonly="readonly" class="money" /></td>
				</tr>
				<tr>
					<td class="rightAligned">Payment Terms</td>
					<td class="leftAligned">
						<select id="takeupPayTerm" name="takeupPayTerm" style="width: 158px; margin-right: 70px; padding-top: 2px;" >
								<option value="">Select..</option>
						</select>
					</td>
					<td class="rightAligned">Total Amount Due</td>
					<td class="leftAligned"><input id="takeupBondAmtDue" type="text" style="width: 150px;" value="" readonly="readonly" class="money" /></td>
				</tr>
				<tr>
					<td class="rightAligned">Due Date</td>
					<td class="leftAligned">
					  	<div style="float:left; border: solid 1px gray; width: 69%; height: 21px; margin-right:3px;">
					      <input type="text" style="border: none; width: 83%" id="takeupBondDueDate" name="takeupBondDueDate" value="" triggerChange="Y" class="formattedDate"/>
					      <img id="hrefDueDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('takeupBondDueDate'),this, null);" alt="Due Date" />
					    </div>
			 		</td>
			 		
			 		<td class="rightAligned" style="width: 124px;" id="lblTakeupRiCommRt" for="takeupBondRiCommRt">RI Comm. Rate</td>
					<td class="leftAligned"><input id="takeupBondRiCommRt" type="text" style="width: 150px;" class="moneyRate"/></td>
				</tr>
				<tr>
					<td class="rightAligned">Reference Invoice No.</td>
					<td class="leftAligned"><input id="takeupBondrefInvNo" style="width: 150px;" type="text" value="" maxlength="30"/></td>
					
					<td class="rightAligned" style="width: 124px;" id="lblTakeupRiCommAmt" for="takeupBondRiCommAmt">RI Comm. Amt.</td>
					<td class="leftAligned"><input id="takeupBondRiCommAmt" type="text" style="width: 150px;" class="money"/></td>
				</tr>
				<tr>
					<td class="rightAligned" colspan="3" style="width: 124px;" id="lblTakeupRiCommVat" for="takeupBondRiCommVat">RI Comm. VAT</td>
					<td class="leftAligned"><input id="takeupBondRiCommVat" type="text" style="width: 150px;" class="money"/></td>
				</tr>
				<tr>
					<td class="rightAligned">Remarks</td>
					<td colspan=3 >  
						<div style="border: 1px solid gray; height: 20px; width: 91.9%; margin-left: 4px;">
							<input type="text" id="takeupBondRemarks" style="width: 94%; border: none; height: 12px; float: left;" class="list" maxlength="4000">
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editTakeupBondRemarks" />
						</div>
					</td>	
				</tr>
			</table>		
		</div>	
		<div class="buttonsDiv" style="float:left; width: 100%; margin-bottom: 15px; margin-left: 17px;" >			
			<input type="button" style="width: 65px;" id="btnTakeupUpdate" name="btnTakeupUpdate" class="disabledButton" value="Update" />
			<input type="button" style="width: 65px;" id="btnTakeupCancel" name="btnTakeupCancel"	class="disabledButton" value="Cancel" />
		</div> 
	</div>
</div>
	
<div id="outerDiv" name="outerDiv">
  <div id="innerDiv" name="innerDiv">
     <label>Tax Information</label> 
      <span class="refreshers" style="margin-top: 0;"> 
       <label id="testRecStat" name="gro" style="margin-left: 5px;">Hide</label> 
      </span>
  </div>
</div>
	
<div class="sectionDiv" id="taxInformationDiv">
	<div style="width: 100%;" id="taxInformationList" class="tableContainer" style="margin-top: 10px;">
		<jsp:include page="subPages/enterBondBillTaxInformationListing.jsp"></jsp:include>
	</div>
	<div id="taxInformationHeader" style="margin: 10px;"">
		<table width="50%" align="center" cellspacing="1" border="0">
			<tr>
				<td class="rightAligned" style="width: 150px;">Tax Description</td>
				<td colspan="3" class="leftAligned">
					<input type="text" id="txtBondTaxDesc" name="txtBondTaxDesc" class="" readonly="readonly" style="display: none; width: 180px;">
					<select id="bondTaxDesc" name="bondTaxDesc" style="width: 188px; padding-top: 2px;" class="">
							<option value="" taxCd="">Select..</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 150px;" for="bondTaxAmount">Tax Amount</td>
				<td colspan="3" class="leftAligned"><input id="bondTaxAmount" style="width: 180px;" type="text" value="" class="applyDecimalRegExp" regExpPatt="pDeci1402" min="0.01" max="99999999999999.99" hasOwnChange="Y" /></td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 150px; display: none;">Tax Allocation</td>
				<td colspan="3" class="leftAligned">
					<select id="bondTaxAlloc" name="bondTaxAlloc" style="width: 188px; padding-top: 2px; display: none;" class="">
								<!-- <option value="F">FIRST</option>
								<option value="S">SPREAD</option>
								<option value="L">LAST</option> -->
								<option value="F">F</option>
								<option value="S">S</option>
								<option value="L">L</option>
					</select>
				</td>
			</tr>
			<tr>
				<td></td>
				<td style="float: left; margin-top: 10px;">	
					<input style="margin-left: 20px; float: left;" type="button" style="width: 70px;" id="btnBondAdd" name="btnBondAdd" class="disabledButton" value="Add" />
					<input style="margin-left: 4px;" type="button" style="width: 70px;" id="btnBondDelete" name="btnBondDelete"	class="disabledButton" value="Delete" />
				</td>
			</tr>
		</table>
	</div>	
</div>	
<div class="buttonsDiv" style="float:left; width: 100%;">	
	<input type="button" style="width: 80px; margin-left: 35px;" id="btnBondCancel" name="btnBondCancel"	class="button" value="Cancel" />
	<input type="button" style="width: 80px;" id="btnBondSave" name="btnBondSave" class="button" value="Save" />
</div> 

<script>
	setModuleId("GIPIS017B");
	setDocumentTitle("Enter Bond Bill");
	var currRecordIndex = 0;
	var listSize = 0;
    objArray = JSON.parse('${gipiWInvoiceJSON}'); 
    var objTaxDtlsArray = eval('${bondTaxChargesListingJSON}');
	var objPayTerms = eval('${payTermsJSON}');
	var objBookingDateArray = eval('${bookingDateJSON}');
	var takeupTerm = '${takeupTerm}';
	var docStampsParam = '${docStampsParam}';
	var vatTag = '${vatTag}';	
	var bookingYear2 = null;
	var bookingMonth2 = null;
	var updateBooking = ('${updateBooking}');
	var defPayTerm = '${defPayTerm}'; 
	var createInvoiceTag = 0;
	var binderExist = "N";
	
	//added by Gzelle 10272014 from invoiceTax (Policy)
	var allowUpdateTaxEndtCancellation = '${CheckUpdateTaxEndtCancellation}';
	var allowTaxGreaterThanPremium = '${allowTaxGreaterThanPremium}';
    objTaxChargesParam = JSON.parse('${giisTaxCharges}'.replace(/\\/g, '\\\\'));
    var parTypeCond = (objUWGlobal.parType != null ? objUWGlobal.parType : $F("globalParType"));
	var polFlag = objUWParList.packParId == null ? $F("globalPolFlag"): objUWGlobal.polFlag;
	
	// added by jhing 11.11.2014 for the validation of tax amount
	var selTaxCd	= null;
	var selTaxId	= null;
	
	if(nvl(updateBooking, "Y") == "N"){
		$("bondBookingDate").disable(); // added by: Nica 05.25.2012 - Per Ms VJ, booking month LOV should be disabled if UPDATE_BOOKING is equal to N.
	} else {	
		//belle 07.18.2012 as per Mam VJ booking mth is disabled if takeup term is ST else enabled
		if(takeupTerm == "ST" ){//|| isPack == 'Y'){ //pansamantalang disable muna ung sa package ginagawa palang ung sa takeupterm
			$("bondBookingDate").disabled = true;
		}else{
			$("bondBookingDate").disabled = false;
		}
	}
		
	formatMoneyRateValues();
	showTakeupTermList(objArray);
	showTaxInformationList(objArray);
	populateTaxDtls(objTaxDtlsArray, 0);
	populatePayTermDtls(objPayTerms, 0);
	populateBookingDtls(objBookingDateArray, 0);
	observeReloadForm("reloadForm", showBillPremium); 
	changeTag = 0;
	$("bondRateTotal").value = formatToNthDecimal($F("bondRateTotal"), 9);
	$("bondRiCommRt").value  = formatToNthDecimal($F("bondRiCommRt"), 9);
	
	
	/**
	 * @Rey
	 * @date 11-16-2011
	 * edited by irwin tabisora, date : feb. 09, 2012
	 * edited by belle 07.23.2012 
	 * 		from bookingDate to bookingDatePolbas - booking date in polbas
	 * 		from multiBookingMonth,multiBookingYear to bookingDate - user input
	 * edited by belle 08.30.2012
	 *	    validate using validation used in other lines (bill premiums/gipis026_validate_bookingdate)	
	 */
		 
	function validateBookingDate(){
		var isValid = false;
		var effDate = dateFormat(objArray[0].effDate, "mm-dd-yyyy"); 
		var expDate = dateFormat(objArray[0].wpolbasExpiryDate, "mm-dd-yyyy"); 
		var selBookingDate = dateFormat($F("bondBookingDate"), "mm-dd-yyyy");
		var oldBookingDate = dateFormat(objArray[0].inceptDate, "mm-dd-yyyy"); 
		var nxtBookingDate = "";
		var prevBookingDate = ""; 
		var nxtTakeupNo    = (parseInt(nvl($F("bondTakeUpSeqNo"),0)) + 1 ); 
		var prevTakeupNo   = (parseInt(nvl($F("bondTakeUpSeqNo"),0)) - 1 ); 
	
	 	$$("div#takeupTableContainer div[name='takeUpRow']").each(function(row){
	 		if (row.down("label", 0).innerHTML == nxtTakeupNo){
				nxtBookingDate = dateFormat(row.down("label", 1).innerHTML, "mm-dd-yyyy");
			}else if (row.down("label", 0).innerHTML == prevTakeupNo){
				prevBookingDate = dateFormat(row.down("label", 1).innerHTML, "mm-dd-yyyy");
			}
		});
	
		new Ajax.Request(contextPath + "/GIPIWinvoiceController?action=validateBookingDate3" , {
			method: "POST",
			parameters: {
				ajax:           2, 
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
				if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
					isValid = true;
				}
			}
		});
		return isValid;
	}

	function getBondsCompTaxAmt() { //added by jhing 11.11.2014
		try {
			var result = null;
			new Ajax.Request(contextPath + "/GIPIWinvoiceController", {
				parameters : {action : "getBondsCompTaxAmt",
							  taxCd : selTaxCd,
							  taxId :  selTaxId,
							  parId :  $F("globalParId"),
							  itemGrp : 1 /* bonds has only one bill group */,
							  takeupSeqNo :  $F("bondTakeUpSeqNo")/*,
							  takeupAllocTag :$("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("takeupAllocTag")*/},
			  	asynchronous: false,
			    evalScripts: true,
				onComplete : function(response){
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						result = nvl(response.responseText,'0');
					}
				}
			});
			return result;
		} catch (e) {
			showErrorMessage("getBondsCompTaxAmt",e);
		}
	}	


	
	function validateTaxAmtForAddUpdate(action){
		var isValid = true;
		var noRateTag = "";
		var origTaxAmt = 0;
		var primarySw = "";
		var prevTotTaxAmt = formatCurrency($("bondTaxAmount").getAttribute("pre-text"));
		var expTaxAmt = 0 ;
		var selTaxType = null ;  // jhing 11.18.2014

		if ($F("bondTaxAmount") != null && $F("bondTaxAmount") != "" ){
			if (action == 'Add'){
				noRateTag = $("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("noRateTag");
				origTaxAmt = Math.round((unformatCurrency("takeupPremAmt") * (parseFloat($("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("listTaxRt"))/100))*100)/100;
				selTaxCd = $("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("listTaxCd");
				selTaxId = $("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("listTaxId");	
				selTaxType = $("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("taxType"); // jhing 11.18.2014
			}else {
				primarySw = $F("hiddenPrimarySw");	
				noRateTag = $F("hiddenNoRateTag");
				origTaxAmt = Math.round((unformatCurrency("takeupPremAmt") * (parseFloat($F("hiddenTaxRate"))/100))*100)/100;
				selTaxCd =$("hiddenTaxCd").value;
				selTaxId = $("hiddenTaxId").value; 
				selTaxType = $("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("taxType"); // jhing 11.18.2014
			}
			
			//Added by Apollo Cruz - 12.05.2014 - assured with zero vat must not be allowed to update VAT
			if(vatTag == 2 && $F("hiddenTaxCd") == '${evatParamValue}') {
				showMessageBox("This assured is zero VAT rated.", imgMessage.ERROR);
				return false;
			}
			
			// jhing 11.11.2014 for no_rate_tag taxes it is better to validate amounts upon clicking of Update/Add since we need to recompute
			// tax amounts considering the other tax types (range and fixed amount). We also need to consider takeup allocation. Added the enhancement
			// on the validation of tax amount vs premium amount

			if(Math.abs(parseFloat(unformatCurrency("bondTaxAmount"))) > Math.abs(parseFloat(unformatCurrency("bondPremTotal"))) 
					 && /*taxType*/selTaxType == "A" && allowTaxGreaterThanPremium != "Y" ){	
				isValid = false;
				customShowMessageBox('Invalid Tax Amount. Tax Amount should not be greater than the Premium.', imgMessage.ERROR, "bondTaxAmount"); 				
			}else if (noRateTag == 'N'){ 
				expTaxAmt = parseFloat(nvl(getBondsCompTaxAmt(),0)); // added by jhing 11.11.2014
				//if (unformatCurrency("bondTaxAmount") > Math.ceil(origTaxAmt) || unformatCurrency("bondTaxAmount") < Math.floor(origTaxAmt)){   // replaced condition by jhing 11.11.2014
			    if (unformatCurrency("bondTaxAmount") > expTaxAmt || unformatCurrency("bondTaxAmount") < expTaxAmt ){  
					isValid = false;
					//customShowMessageBox('Tax Amount must not be less than ' + formatCurrency(Math.floor(origTaxAmt)) + ' and must not exceed ' + formatCurrency(Math.ceil(origTaxAmt)) + '.', imgMessage.ERROR, "bondTaxAmount"); // replaced by reiko 11.11.2014
					customShowMessageBox('Tax Amount must not be less than ' + formatCurrency(expTaxAmt) + ' and must not exceed ' + formatCurrency(expTaxAmt) + '.', imgMessage.ERROR, "bondTaxAmount"); 
					//$("bondTaxAmount").value = prevTotTaxAmt; 
					$("bondTaxAmount").value = formatCurrency(nvl(prevTotTaxAmt,expTaxAmt));  // jhing added nvl 11.11.2014 
				}	
			}else if (noRateTag == 'Y') {
				if (unformatCurrency("bondTaxAmount") < 0){
					isValid = false;
					customShowMessageBox('Tax Amount must not be less than 0.', imgMessage.ERROR, "bondTaxAmount");
					$("bondTaxAmount").value = prevTotTaxAmt; 
				}
			}
			
		}else{
			isValid = false;
			customShowMessageBox('Required field must be entered', imgMessage.ERROR, "bondTaxAmount");
		}

		return isValid;
	}
	
	//edited by marj: added amtLength parameter so it can be used for different locCurrAmtLength
	function validateInput(paramField, amtLength){
		var isValid = true;
		var decimalLength = getDecimalLength($F(paramField));
		var locCurrAmtLength = unformatCurrency(paramField).toString().length - (decimalLength + 1);//(Math.round((unformatCurrency(paramField))*100)/100).toString().length;
		if (decimalLength > 2) {
			isValid = false;
			return isValid;
		}
		//amtLength was previously 10
		if (locCurrAmtLength > amtLength || isNaN($F(paramField)) || $F(paramField) == "" ){ //|| unformatCurrency(paramField) < 0
			isValid = false;
		}
	
		return isValid;
	}
	
	function resetBondTotals(){
		$("bondRateTotal").value = formatToNthDecimal(0, 9);
		$("bondPremTotal").value = formatCurrency(0);
		$("bondTotalTaxAmt").value = formatCurrency(0);
		$("bondTotalAmtDue").value = formatCurrency(0);
		if ($F("bondIssCd") == $F("issCdRI") || $F("bondIssCd") == 'RB'){
			$("bondRiCommAmt").value = formatCurrency(0); // replaced bondRiCommRt with bondRiCommAmt - irwin
			$("bondRiCommVat").value = formatCurrency(0);
		}
	}
	
	function saveFuncMain(){
		if (checkPendingRecordChanges()){ 
			if(changeTag == 0){
				showMessageBox(objCommonMessage.NO_CHANGES ,imgMessage.INFO); 
				return;
			}else{
				if ($F("bondTotalAmt") != null && !isNaN($F("bondTotalAmt").replace(/,/g, "")) ){
	
					//belle 09012012 get booking MM and YY of takeupseqno = 1 used to update gipi_wpolbas
					$$("div#takeupTableContainer div[name='takeUpRow']").each(function(row){
				 		if (row.down("label", 0).innerHTML == 1){
							bookingDate = (row.down("label", 1).innerHTML).split("-");
							bookingYy   = bookingDate[0].trim();
							bookingMm   = bookingDate[1].trim();
						}
					});
					
					new Ajax.Request(contextPath + "/GIPIWinvoiceController?action=saveBondBillDtls", {
						method: "POST",
						parameters: {
							parameters: prepareParameters(),
							parId: $F("globalParId"),
							lineCd: objUWGlobal.lineCd,
							issCd: $F("bondIssCd"),
							bondTsiAmt: $F("bondTotalAmt").replace(/,/g, ""), 
							premAmt: unformatCurrency("bondPremTotal"),
							riCommRt: $F("bondRiCommRt"), 
							bondRate: roundExpNumber($F("bondRateTotal"),9), //modified by Gzelle 01062015 
							riCommAmt: unformatCurrency("bondRiCommAmt"),
							newInvoiceMarker: $F("newWinvoiceFlag"),
							payTerm: $F("takeupPayTerm") == "" ? "COD" : $F("takeupPayTerm"),
							taxAmt: unformatCurrency("bondTotalTaxAmt"),
							parType: "P",
							bookingMm: bookingMm,
							bookingYy: bookingYy
						},
						evalScripts: true,
						asynchronous: false,
						onComplete: function (response){
							if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
								$("newWinvoiceFlag").value = 'N';
								updateParParameters();
								showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, showBillPremium);
								changeTag = 0;
								//showBillPremium();
								createInvoiceTag = 0;
							}
						}
					});
				} else {
					changeTag = 0;
					createInvoiceTag = 0;
					updateParParameters();
				}
			}
		}
	}

	function prepareParameters(){
		try {			
			var setTakeUpRows		= getAddedModifiedTakeUpInfoJSONObject();
			var delTakeUpRows		= getDeletedTakeUpInfoJSONObject();
			var setTaxInfoRows		= getAddedModifiedTaxInfoJSONObject();
			var delTaxInfoRows		= getDeletedTaxInfoJSONObject();
	
			// Sets the parameters
			var objParameters = new Object();
			objParameters.addModifiedTakeUp	  = setTakeUpRows;
			objParameters.deletedTakeUp		  = delTakeUpRows;
			objParameters.addModifiedTaxInfo  = setTaxInfoRows;
			objParameters.deletedTaxInfo 	  = delTaxInfoRows;
			
			return JSON.stringify(objParameters);
		} catch (e) {
			showErrorMessage("prepareParameters", e);
		}
	}
	
	function getAddedModifiedTakeUpInfoJSONObject(){
		var tempObjArray = new Array();
		
		for(var i=0; i<objArray.length; i++) {	
			if (nvl(objArray[i].recordStatus,0) == 0){ //added nvl by robert 02.24.2014
				tempObjArray.push(objArray[i]);
			}else if (objArray[i].recordStatus == 1){
				tempObjArray.push(objArray[i]);
			}
		}
		
		return tempObjArray;
	}
	
	function getDeletedTakeUpInfoJSONObject(){
		var tempObjArray = new Array();
		
		for(var i=0; i<objArray.length; i++) {	
			if (objArray[i].recordStatus == -1){
				tempObjArray.push(objArray[i]);
			}
		}
		
		return tempObjArray;
	}
	
	function getAddedModifiedTaxInfoJSONObject(){
		var tempObjArray = new Array();

		for(var i=0; i<objArray.length; i++) {		
			for(var j=0; j<objArray[i].taxCodes.length; j++){
				if (objArray[i].taxCodes[j].recordStatus == 0){ //added nvl by robert 02.24.2014 //remove nvl by steven 10.14.2014
					tempObjArray.push(objArray[i].taxCodes[j]);
				}
			}
		}			
		
		return tempObjArray;
	}
	
	function getDeletedTaxInfoJSONObject(){
		var tempObjArray = new Array();
	
		for(var i=0; i<objArray.length; i++) {		
			for(var j=0; j<objArray[i].taxCodes.length; j++){
				if (objArray[i].taxCodes[j].recordStatus == -1){
					tempObjArray.push(objArray[i].taxCodes[j]);
				}
			}
		}			
		
		return tempObjArray;
	}
	
	// on-click tax
	function divEvents(newDiv) {
		newDiv.observe("mouseover", function ()	{
			newDiv.addClassName("lightblue");
		});
		
		newDiv.observe("mouseout", function ()	{
			newDiv.removeClassName("lightblue");
		});
		
		newDiv.observe("click", function ()	{
			selectedRowId = newDiv.getAttribute("id");
			newDiv.toggleClassName("selectedRow");
			if (newDiv.hasClassName("selectedRow"))	{
				$$("div[name='taxInformationRow']").each(function (r)	{
					if (newDiv.getAttribute("id") != r.getAttribute("id"))	{
						r.removeClassName("selectedRow");
					}
			    });
				$("hiddenTaxCd").value = newDiv.down("input", 0).value;
				$("hiddenTaxDesc").value = newDiv.down("input", 1).value;
				$("hiddenTaxAmt").value = newDiv.down("input", 2).value;
				$("hiddenTaxAlloc").value = newDiv.down("input", 3).value;
				$("hiddenTaxId").value = newDiv.down("input", 4).value;
				$("hiddenNoRateTag").value = newDiv.down("input", 5).value;
				$("hiddenTaxRate").value = newDiv.down("input", 6).value;
				$("hiddenPrimarySw").value = newDiv.down("input", 7).value;
				$("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].text =  newDiv.down("input", 1).value;
				$("bondTaxAmount").value =  formatCurrency(newDiv.down("input", 2).value);
				$("bondTaxAlloc").value = newDiv.down("input", 3).value;
				
				//showTaxInfoButton(false);
				$("btnBondAdd").value = "Update";
				enableButton("btnBondDelete");
				
				//belle 10022012
				$("bondTaxDesc").hide();
				$("txtBondTaxDesc").show();
				$("txtBondTaxDesc").value = newDiv.down("input", 1).value;
				var taxCd = newDiv.down("input", 0).value;
				
				if((taxCd == 8 && vatTag == 2)){ 
					$("bondTaxAmount").readOnly = true; 
				}else{
					$("bondTaxAmount").readOnly = false; 
				}
			} else {
				$("btnBondAdd").value = "Add";
				$("bondTaxDesc").options[0].text = ''; //changed by steven 10.14.2014
				$("bondTaxAmount").value = null; 
				$("bondTaxDesc").show();
				$("txtBondTaxDesc").hide();
				$("txtBondTaxDesc").value = null;
				disableButton("btnBondDelete");
	
			}	  
		});	   
	}
	
	$$("div[name='takeUpRow']").each(
		function (row)	{
			row.observe("mouseover", function ()	{
				row.addClassName("lightblue");
			});
			row.observe("mouseout", function ()	{
				row.removeClassName("lightblue");
			});
			row.observe("click", function ()	{
				selectedRowId = row.getAttribute("id");
				row.toggleClassName("selectedRow");
				if (row.hasClassName("selectedRow"))	{
					$$("div[name='takeUpRow']").each(function (r)	{
						if (row.getAttribute("id") != r.getAttribute("id"))	{
							r.removeClassName("selectedRow");
						}	
				     });
					
					displayTakeupValues(objArray, row.down("input", 0).value);
					removeSelectedTaxInformation();
					hideTaxInformation();
					showTakeupButton(true);
					showTaxInfoButton(true);
					checkTableIfEmpty("taxInformationRow", "enterBondBillTaxInformationListingTable");
					try{
						for(var i=0; i<objArray.length; i++) {	
							if (objArray[i].takeupSeqNo == $F("bondTakeUpSeqNo")){	
								for(var j=0; j<objArray[i].taxCodes.length; j++){
									if ($F("bondTakeUpSeqNo") == objArray[i].taxCodes[j].takeupSeqNo){
										$("rowTax"+objArray[i].taxCodes[j].taxCd + "" + $F("bondTakeUpSeqNo")).show();
									}	
								}
							}
						}		
					}catch(e){
						//do nothing if div does not have a value
					}	
				} else {
					showTakeupButton(false);
					removeSelectedTaxInformation();
					resetToDefaultValues();
					hideTaxInformation();
					checkTableIfEmpty("taxInformationTableContainer", "enterBondBillTaxInformationListingTable");
					($$("div#invoiceInformationFooterHeader [changed=changed]")).invoke("removeAttribute", "changed"); 				
				}	  	
				
			});			
		}	
	);
	
	function updateTakeupTermList(objArray, seqNo){
		for (var i=0; i<objArray.length; i++){		
			if (objArray[i].takeupSeqNo == seqNo){	
				objArray[i].recordStatus = 1;
				objArray[i].dueDate = $F("takeupBondDueDate");
				objArray[i].refInvNo = $F("takeupBondrefInvNo");
				objArray[i].remarks = $F("takeupBondRemarks");
				objArray[i].multiBookingYY = $("bondBookingDate").options[$("bondBookingDate").selectedIndex].getAttribute("bookingYear");
				objArray[i].multiBookingMM = $("bondBookingDate").options[$("bondBookingDate").selectedIndex].getAttribute("bookingMonth");
				objArray[i].paytTerms = $F("takeupPayTerm");
				
				objArray[i].riCommRt = $F("takeupBondRiCommRt");
				objArray[i].riCommAmt = unformatCurrency("takeupBondRiCommAmt"); 
				objArray[i].riCommVat = unformatCurrency("takeupBondRiCommVat"); 
				//Set display values
				$("lblTakeupDueDate"+objArray[i].takeupSeqNo).innerHTML = $F("takeupBondDueDate");
				$("lblTakeupBookingDate"+objArray[i].takeupSeqNo).innerHTML = objArray[i].multiBookingYY + " - " + objArray[i].multiBookingMM;
				
				showTakeupButton(false);
				removeSelectedTaxInformation();
				removeSelectedTakeUpInformation();
				resetToDefaultValues();
				hideTaxInformation();
				hideTaxInformationList();
				
			}
		}
	}
	
	function updateTaxInformationList(){
		$("rowTax"+$F("bondTakeUpSeqNo")).show();
	}
	
	function showTakeupTermList(objArray){
		try {
			var itemTable = $("takeupTableContainer");
			var totalTax = 0;
			
			for(var i=0; i<objArray.length; i++) {				
				var content = prepareTakeupListInfo(objArray[i]);										
				var newDiv = new Element("div");
				totalTax = totalTax + parseFloat(nvl(objArray[i].taxAmt,0));
				newDiv.setAttribute("id", "row"+objArray[i].takeupSeqNo);
				newDiv.setAttribute("name", "takeUpRow");
				newDiv.addClassName("tableRow");
				
				newDiv.update(content);
				itemTable.insert({bottom : newDiv});	
			}
			
			//belle 11.07.2012
			if ($F("bondIssCd") == "RI" || $F("bondIssCd") == "RB"){
				$("bondTotalTaxAmt").value = formatCurrency(totalTax);
				$("bondTotalAmtDue").value = formatCurrency(unformatCurrency("bondPremTotal") + unformatCurrency("bondTotalTaxAmt") - unformatCurrency("bondRiCommAmt") - unformatCurrency("bondRiCommVat"));
			}else{
				$("bondTotalTaxAmt").value = formatCurrency(totalTax);
				$("bondTotalAmtDue").value = formatCurrency(totalTax + unformatCurrency("bondPremTotal"));
			}

			var divSize = $$("div[name='takeUpRow']").size();  
			if (divSize <= 1){
				$("takeupTableContainer").setStyle("height: 35px; overflow-y: auto; width: 100%;");
			}else{
				checkIfToResizeTable("takeupTableContainer", "takeUpRow");
			}
			checkTableIfEmpty("takeUpRow", "enterBondBillTakeUpListingTable");
		} catch (e) {
			showErrorMessage("showTakeupTermList", e);
		}
	}
	
	function prepareTakeupListInfo(obj){
		try {		
			bookingYear2 = obj.multiBookingYY;
			bookingMonth2 = obj.multiBookingMM;
			if (obj.paytTerms == null){ //added by robert
				enableButton("createInvoiceBtn");
				createInvoiceTag = 1;
			}
			var bookingDate = (obj.multiBookingYY + " - " + obj.multiBookingMM);
			var takeupListInfo  = '<label style="width: 40px; text-align: right; margin-left: 43px;" id="lblTakeupSeqNo'+obj.takeupSeqNo+'">'+obj.takeupSeqNo+'</label>' +						
							'<label style="width: 118px; text-align: left; margin-left: 65px;" title="'+bookingDate+'" id="lblTakeupBookingDate'+obj.takeupSeqNo+'">'+bookingDate+'</label>'+
							'<label style="width: 75px; text-align: left; margin-left: 14px;" id="lblTakeupDueDate'+obj.takeupSeqNo+'">'+ obj.dueDate +'</label>'+
							'<label style="width: 120px; text-align: right; margin-left: 0px;" id="lblTakeupBondAmount'+obj.takeupSeqNo+'">'+(obj.bondTsiAmt == null ? formatCurrency(0) : formatCurrency(obj.bondTsiAmt))+'</label>'+
							'<label style="width: 120px; text-align: right; margin-left: 12px;" id="lblTakeupBondPremAmt'+obj.takeupSeqNo+'">'+(obj.premAmt == null ? formatCurrency(0) : formatCurrency(obj.premAmt))+'</label>'+
							'<label style="width: 120px; text-align: right; margin-left: 12px;" id="lblTakeupBondTaxAmt'+obj.takeupSeqNo+'">'+(obj.taxAmt == null ? formatCurrency(0) : formatCurrency(obj.taxAmt))+'</label>'+
							'<label style="width: 120px; text-align: right; margin-left: 12px;" id="lblTakeupBondTotalAmtDue'+obj.takeupSeqNo+'">'+(obj.amountDue == null ? formatCurrency(0) : formatCurrency(obj.amountDue))+'</label>'+
							'<input type="hidden" name="hiddenTakeupSeqNo" value="'+obj.takeupSeqNo+'" />' +
							'<input type="hidden" name="hiddenEffDate" value="'+obj.effDate+'" />' +
							'<input type="hidden" name="hiddenExpiryDate" value="'+obj.wpolbasExpiryDate+'" />';
	
			return takeupListInfo;
		} catch (e) {
			showErrorMessage("prepareTakeupListInfo", e);
		}
	}
	
	function showTaxInformationList(objArray){
		try {
			var itemTable = $("taxInformationTableContainer");
			for(var i=0; i<objArray.length; i++) {		
				for(var j=0; j<objArray[i].taxCodes.length; j++){
					if (objArray[i].taxCodes[j].takeupSeqNo == objArray[i].takeupSeqNo){
						var content = prepareTaxInformationListInfo(objArray[i].taxCodes[j]);										
						var newDiv = new Element("div");
						newDiv.setAttribute("id", "rowTax"+ objArray[i].taxCodes[j].taxCd + "" + objArray[i].takeupSeqNo);
						newDiv.setAttribute("name", "taxInformationRow");
						newDiv.setAttribute("taxCd", objArray[i].taxCodes[j].taxCd);
						newDiv.addClassName("tableRow");
						
						newDiv.update(content);
						itemTable.insert({bottom : newDiv});
						divEvents(newDiv);
						newDiv.hide();
					}
				}
					
			}
			checkTableIfEmpty("taxInformationTableContainer", "enterBondBillTaxInformationListingTable");
		} catch (e) {
			showErrorMessage("showTaxInformationList", e);
		}
	}
	
	function prepareTaxInformationListInfo(obj){
		try {				
			var taxInformationListInfo  = '<label style="width: 85px; text-align: center; margin-left: 25px;" name="lblTaxInfo" id="lblTaxInfoTaxCd'+obj.takeupSeqNo+ obj.taxCd +'">'+obj.taxCd+'</label>'+
										  '<label style="width: 180px; text-align: left; margin-left: 40px;" name="lblTaxInfo" id="lblTaxInfoTaxDesc'+obj.takeupSeqNo+ obj.taxCd +'">'+(obj.taxDesc == null ? "-" : obj.taxDesc)+'</label>'+
										  '<label style="width: 120px; text-align: right; margin-left: 25px;" name="lblTaxInfo" id="lblTaxInfoTaxAmt'+obj.takeupSeqNo+ obj.taxCd +'">'+(obj.taxAmt == null ? formatCurrency(0) : formatCurrency(obj.taxAmt))+'</label>'+
										  '<label style="width: 50px; text-align: left; margin-left: 60px;" name="lblTaxInfo" id="lblTaxInfoTaxAlloc'+obj.takeupSeqNo+ obj.taxCd +'">'+(obj.taxAllocation == null ? "-" : obj.taxAllocation)+'</label>'+
										  '<input type="hidden" name="hiddenTaxInfoTaxCd" value="'+(obj.taxCd == null ? "" : obj.taxCd)+'" />' +
										  '<input type="hidden" name="hiddenTaxInfoTaxDesc" value="'+(obj.taxDesc == null ? "" : obj.taxDesc)+'" />'+
										  '<input type="hidden" name="hiddenTaxInfoTaxAmt" value="'+(obj.taxAmt == null ? formatCurrency(0) : formatCurrency(obj.taxAmt))+'" />'+
										  '<input type="hidden" name="hiddenTaxInfoTaxAlloc" value="'+(obj.taxAllocation == null ? "" : obj.taxAllocation)+'" />' +
										  '<input type="hidden" name="hiddenTaxInfoTaxId" value="'+(obj.taxId == null ? "" : obj.taxId)+'" />' + 
										  '<input type="hidden" name="hiddenTaxInfoNoRateTag" value="'+ obj.noRateTag +'" />' +
										  '<input type="hidden" name="hiddenTaxInfoTaxRate" value="'+ obj.rate +'" />' +
										  '<input type="hidden" name="hiddenTaxInfoPrimarySw" value="'+ obj.primarySw +'" />';							
	
			return taxInformationListInfo;
		} catch (e) {
			showErrorMessage("prepareTaxInformationListInfo", e);
		}
	}
	
	function chkIfTaxExist(taxCd){
		var exist = false;
		$$("div[name='taxInformationRow']").each(function (div) {
			if (div.getAttribute("taxCd") == taxCd){
				exist = true;
			}
		
			if (vatTag == 1){
				if (div.getAttribute("taxCd") == taxCd){
					exist = true;
				}
			}
		});
		
		return exist;
	}
	
	function populateTaxDtls(obj, value){
		$("bondTaxDesc").length = 0;
		$("bondTaxDesc").update('<option value="" listTaxCd=""></option>');
		var options = "";
		
		for(var i=0; i<obj.length; i++){
			if (!chkIfTaxExist(obj[i].taxCd)){					
				// jhing 11.12.2014 temporary comment out no need to add tax amount since it will be retrieved or recomputed by function..with this code sometimes function on computeFixedTaxAmt is not called
				//options+= '<option value="'+obj[i].taxDesc+'" listFixedAllocation="'+obj[i].fixedTaxAllocation+'" listTaxId="'+obj[i].taxId+'" listTaxCd="'+obj[i].taxCd+'" listTaxRt="'+obj[i].rate+'" noRateTag="'+obj[i].noRateTag+'" primarySw="'+obj[i].primarySw+'" allocationTag="'+obj[i].allocationTag
				//			+'" taxAmount="'+obj[i].taxAmount+'" taxType="'+obj[i].taxType +'" takeupAllocTag="'+obj[i].takeupAllocTag+'">'+obj[i].taxDesc+'</option>'; //added by steven 10.14.2014 - 'allocationTag'	--Gzelle 10302014 taxAmount & taxType -- jhing 11.09.2014 added takeupAllocTag

				options+= '<option value="'+obj[i].taxDesc+'" listFixedAllocation="'+obj[i].fixedTaxAllocation+'" listTaxId="'+obj[i].taxId+'" listTaxCd="'+obj[i].taxCd+'" listTaxRt="'+obj[i].rate+'" noRateTag="'+obj[i].noRateTag+'" primarySw="'+obj[i].primarySw+'" allocationTag="'+obj[i].allocationTag
				+'" taxType="'+obj[i].taxType +'" takeupAllocTag="'+obj[i].takeupAllocTag+'">'+obj[i].taxDesc+'</option>'; //added by steven 10.14.2014 - 'allocationTag'	--Gzelle 10302014 taxAmount & taxType -- jhing 11.09.2014 added takeupAllocTag
			
			}
		}
		$("bondTaxDesc").insert({bottom: options}); 
		$("bondTaxDesc").selectedIndex = value;
	}
	
	function populatePayTermDtls(obj, value){
		$("takeupPayTerm").update('<option value="" payterm="" paytermDesc=""></option>');
		var options = "";
		for(var i=0; i<obj.length; i++){						
			options+= '<option value="'+obj[i].paytTerms+'" paytermDesc="'+obj[i].paytTermsDesc+'" noOfDays="'+obj[i].noOfDays+'" onInceptTag="'+obj[i].onInceptTag+'" annualSw="'+obj[i].annualSw+'" noOfPayt="'+obj[i].noOfPayt+'" noPaytDays="'+obj[i].noPaytDays+'">'+obj[i].paytTermsDesc+'</option>';
		}
		$("takeupPayTerm").insert({bottom: options}); 
		$("takeupPayTerm").selectedIndex = value;
	}
	
	function populateBookingDtls(obj, value){
		$("bondBookingDate").update('<option value="" bookingMonth="" bookingYear=""></option>');
		var options = "";
		for(var i=0; i<obj.length; i++){						
			options+= '<option value="'+(obj[i].bookingYear + " - " + obj[i].bookingMonth)+'" bookingMonth="'+obj[i].bookingMonth+'" bookingYear="'+obj[i].bookingYear+'">'+(obj[i].bookingYear + " - " + obj[i].bookingMonth)+'</option>';
		}
		$("bondBookingDate").insert({bottom: options}); 
		$("bondBookingDate").selectedIndex = value;
	}
	
	function displayTakeupValues(objArray, seqNo){
		for (var i=0; i<objArray.length; i++){
			if (seqNo == objArray[i].takeupSeqNo){
				var dDate = new Date(Date.parse(objArray[i].dueDate));
				var effDate = new Date(Date.parse(objArray[i].effDate));
				var expiryDate = new Date(Date.parse(objArray[i].wpolbasExpiryDate));
				var bookingDate = (objArray[i].multiBookingYY + " - " + objArray[i].multiBookingMM);
				var origDueDate = null; 
				var origPayTerm = null;
				
				$("bondTakeUpSeqNo").value = objArray[i].takeupSeqNo;
				$("bondBookingDate").value = bookingDate;
				$("takeupBondDueDate").value = dDate.format("mm-dd-yyyy");
				$("hiddenDueDate").value = dDate.format("mm-dd-yyyy");
				$("takeupBondAmt").value = (objArray[i].bondTsiAmt == null ? formatCurrency(0) : formatCurrency(objArray[i].bondTsiAmt)); 
				$("takeupPremAmt").value = (objArray[i].premAmt == null ? formatCurrency(0) : formatCurrency(objArray[i].premAmt));
				$("takeupTaxTotal").value = (objArray[i].taxAmt == null ? formatCurrency(0) : formatCurrency(objArray[i].taxAmt));
				$("takeupBondAmtDue").value = (objArray[i].amountDue == null ? formatCurrency(0) : formatCurrency(objArray[i].amountDue));
				$("takeupBondRt").value = (objArray[i].bondRate == null ? formatToNthDecimal(0, 7) : formatToNthDecimal(objArray[i].bondRate, 7));
				$("takeupPayTerm").value =  (objArray[i].paytTerms == null ? "" : objArray[i].paytTerms);
				$("takeupBondrefInvNo").value = (objArray[i].refInvNo == null ? "" : unescapeHTML2(objArray[i].refInvNo));
				$("takeupBondRemarks").value = (objArray[i].remarks == null ? "" : unescapeHTML2(objArray[i].remarks)); 
				$("hiddenEffDate").value = effDate.format("mm-dd-yyyy");
				$("hiddenExpiryDate").value = expiryDate.format("mm-dd-yyyy");
				$("takeupBondRiCommRt").value = (objArray[i].riCommRt == null ? formatToNthDecimal(0, 9) : formatToNthDecimal(objArray[i].riCommRt, 9));
				$("takeupBondRiCommAmt").value = (objArray[i].riCommAmt == null ? formatCurrency(0) : formatCurrency(objArray[i].riCommAmt));
				$("takeupBondRiCommVat").value = (objArray[i].riCommVat == null ? formatCurrency(0) : formatCurrency(objArray[i].riCommVat));
				
				origDueDate = $F("takeupPayTerm"); 
				origPayTerm = $F("takeupBondDueDate");
				
			}
			
		}
	}
	
	function showTakeupButton(param){
		if(param){			
			enableButton("btnTakeupCancel");
			enableButton("btnTakeupUpdate");
		} else {
			disableButton("btnTakeupUpdate");
			disableButton("btnTakeupCancel");
		}
	}
	
	function showTaxInfoButton(param){
		if(param){			
			enableButton("btnBondAdd");
		} else {
			disableButton("btnBondAdd");
		}
	}
	
	function formatMoneyRateValues(){
		$$("input[type='text'].money, input[type='hidden'].money").each(function (m) {
			m.value = (m.value == "" ? formatCurrency(0) :formatCurrency(m.value));
		});
		
		$$("input[type='text'].moneyRate, input[type='hidden'].moneyRate").each(function (m) {
			m.value = (m.value == "" ? formatToNthDecimal(0, 7) :formatToNthDecimal(m.value, 7));
		});
	}
	
	function resetToDefaultValues(){
		$("bondTakeUpSeqNo").value = null;
		$("bondBookingDate").value =  null;
		$("bondBookingDate").options[0].text = "";
		$("takeupBondDueDate").value = null;
		$("takeupBondAmt").value = formatCurrency(0);  
		$("takeupPremAmt").value = formatCurrency(0);
		$("takeupTaxTotal").value = formatCurrency(0);
		$("takeupBondAmtDue").value = formatCurrency(0);
		$("takeupBondRt").value = formatToNthDecimal(0, 7);
		$("takeupPayTerm").value =  null;
		$("takeupBondrefInvNo").value = null;
		$("takeupBondRemarks").value = null;
		//added by christian 03/18/2013
		$("takeupBondRiCommRt").value = formatToNthDecimal(0, 9);
		$("takeupBondRiCommAmt").value = formatCurrency(0);
		$("takeupBondRiCommVat").value = formatCurrency(0);
		resetTaxInformation();
		showTaxInfoButton(false);
	}
	
	function resetTaxInformation(){
		$("bondTaxDesc").value = null;
		$("bondTaxAmount").value = formatCurrency(0);
		$("bondTaxAlloc").selectedIndex = 0;
		$("btnBondAdd").value = "Add";
		disableButton("btnBondDelete");
		enableButton("btnBondAdd");
		populateTaxDtls(objTaxDtlsArray, 0);
		hideTaxInformationList();
		$("txtBondTaxDesc").value = null;
		$("txtBondTaxDesc").hide();
		$("bondTaxDesc").show();
	}
	
	function hideTaxInformation(){
		$$("div[name='taxInformationRow']").each(function (div) {
			div.hide();
		});
	}
	
	//added by marj: hiding of tax header/column
	function hideTaxInformationList(){
		$$("div[name='enterBondBillTaxInformationListingTable']").each(function(div){
			div.hide();
		});
	}
	
	function removeSelectedTaxInformation(){
		$$("div[name='taxInformationRow']").each( function (row) {
			row.removeClassName("selectedRow");
		});
	}
	
	function removeSelectedTakeUpInformation(){
		$$("div[name='takeUpRow']").each( function (row) {
			row.removeClassName("selectedRow");
		});
	}
	
	
	function markTaxRecordAsDeleted(taxCd){
		for(var i=0; i<objArray.length; i++) {		
			for(var j=0; j<objArray[i].taxCodes.length; j++){
				if (objArray[i].taxCodes[j].takeupSeqNo == objArray[i].takeupSeqNo && objArray[i].taxCodes[j].taxCd == taxCd){
					objArray[i].taxCodes[j].recordStatus = -1;
					objArray[i].taxCodes[j].parId = $F("globalParId");
				}
			}
		}			
	}
	
	function setGIPIWinvTax(){
		var newObj = new Object();	
		var taxCd = $("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("listTaxCd");
		var taxAmt = unformatCurrency("bondTaxAmount");//$F("bondTaxAmount");
		//var taxAlloc = $("bondTaxAlloc").options[$("bondTaxAlloc").selectedIndex].value;
		var taxAlloc = $("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("allocationtag"); //added by steven 10.14.2014
		var taxId = $("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("listTaxId");
		var rate = $("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("listTaxRt"); 
		if ($("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("taxType") == "A") {	//added by Gzelle 10302014
			rate = 0;	
		}
		try{
			for (var i=0; i < objArray.length; i++){
				if ($F("bondTakeUpSeqNo") == objArray[i].takeupSeqNo){
					newObj.parId  		= 	objArray[i].parId;
					newObj.itemGrp 		=   objArray[i].itemGrp;
					newObj.taxCd 		= 	taxCd;
					newObj.lineCd 		= 	$F("globalLineCd");
				    newObj.taxAllocation 	=	taxAlloc;
					newObj.fixedTaxAllocation 	= 	'N';
					newObj.issCd 		=	$F("globalIssCd");
					newObj.taxAmt 		= 	taxAmt;
					newObj.taxId 		= 	taxId;
					newObj.rate 		= 	rate;
					newObj.takeupSeqNo  = 	objArray[i].takeupSeqNo;	
					newObj.recordStatus =   0;
					
					for(var i=0; i<objArray.length; i++) {	
						if (objArray[i].takeupSeqNo == $F("bondTakeUpSeqNo")){	
							objArray[i].taxCodes.push(newObj);
							break;
						}
					}
				}
			}		
			
			return newObj;			    			
		}catch(e){
			showErrorMessage("setGIPIWinvTax", e);
		}
	}
	
	function setGIPIWinvTax2(){
		var newObj = new Object();	
		var taxCd = $F("hiddenTaxCd");
		var taxAmt = unformatCurrency("hiddenTaxAmt"); //$F("hiddenTaxAmt"); replaced by: Nica 12.19.2012
		var taxAlloc = $F("hiddenTaxAlloc");
		var taxId = $F("hiddenTaxId");
		var rate = $F("hiddenTaxRate");
		if ($("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("taxType") == "A") {	//added by Gzelle 10302014
			rate = 0;	
		}
		try{
			for (var i=0; i < objArray.length; i++){
				if ($F("bondTakeUpSeqNo") == objArray[i].takeupSeqNo){
					newObj.parId  		= 	objArray[i].parId;
					newObj.itemGrp 		=   objArray[i].itemGrp;
					newObj.taxCd 		= 	taxCd;
					newObj.lineCd 		= 	$F("globalLineCd");
				    newObj.taxAllocation 	=	taxAlloc;
					newObj.fixedTaxAllocation 	= 	'N';
					newObj.issCd 		=	$F("globalIssCd");
					newObj.taxAmt 		= 	taxAmt;
					newObj.taxId 		= 	taxId;
					newObj.rate 		= 	rate;
					newObj.takeupSeqNo  = 	objArray[i].takeupSeqNo;	
					newObj.recordStatus =   0;
					
					for(var i=0; i<objArray.length; i++) {	
						if (objArray[i].takeupSeqNo == $F("bondTakeUpSeqNo")){	
							objArray[i].taxCodes.push(newObj);
							break;
						}
					}
				}
			}		
			
			return newObj;			    			
		}catch(e){
			showErrorMessage("setGIPIWinvTax", e);
		}
	}
	
	//edited by marj
	function recomputeTaxes(trans){
		var totalTaxAmount = unformatCurrency("bondTotalTaxAmt");
		var totalAmtDue = unformatCurrency("bondTotalAmtDue");
		var taxAmt = unformatCurrency("bondTaxAmount");
 
		if (trans == "add"){
			totalTaxAmount += taxAmt;
			totalAmtDue += taxAmt;						
		}else{
			totalTaxAmount = (totalTaxAmount - parseFloat($("lblTaxInfoTaxAmt" + $F("bondTakeUpSeqNo") + $F("hiddenTaxCd")).innerHTML.replace(/,/g, ""))); 
			totalAmtDue = (totalAmtDue - parseFloat($("lblTaxInfoTaxAmt" + $F("bondTakeUpSeqNo") + $F("hiddenTaxCd")).innerHTML.replace(/,/g, ""))); 
		}
		$("bondTotalTaxAmt").value = formatCurrency(totalTaxAmount);
		$("bondTotalAmtDue").value = formatCurrency(totalAmtDue);
		
		for(var i=0; i<objArray.length; i++) {	
			if (objArray[i].takeupSeqNo == $F("bondTakeUpSeqNo")) {	
				if (trans == "add"){
					//objArray[i].taxAmt = parseFloat(objArray[i].taxAmt) + unformatCurrency("bondTaxAmount");  // jhing 11.13.2014 original code replaced with:
					objArray[i].taxAmt = (parseFloat(objArray[i].taxAmt == null ? 0 : objArray[i].taxAmt) )+ unformatCurrency("bondTaxAmount");   // jhing 11.13.2014 new code handled scenario wherein all taxes are non-required
					objArray[i].amountDue = parseFloat(objArray[i].amountDue) + unformatCurrency("bondTaxAmount");
					objArray[i].dueDate = $F("takeupBondDueDate");
				}else{
					objArray[i].taxAmt = Math.round((parseFloat(objArray[i].taxAmt == null ? 0 : objArray[i].taxAmt) - parseFloat($("lblTaxInfoTaxAmt" + $F("bondTakeUpSeqNo") + $F("hiddenTaxCd")).innerHTML.replace(/,/g, "")))*100)/100;   
					objArray[i].amountDue = Math.round((parseFloat(objArray[i].amountDue == null ? 0 : objArray[i].amountDue) - parseFloat($("lblTaxInfoTaxAmt" + $F("bondTakeUpSeqNo") + $F("hiddenTaxCd")).innerHTML.replace(/,/g, "")))*100)/100;
					objArray[i].dueDate = $F("takeupBondDueDate");
				}
					objArray[i].recordStatus = 	1;
					setNewLblTextAmts(objArray[i].taxAmt, objArray[i].amountDue);
					break;
			}	
		}
	}
	
	function setNewLblTextAmts(taxAmt, amtDue){
		$$("div[name='takeUpRow']").each(function (div)	{
			if (div.down("label", 0).innerHTML == $F("bondTakeUpSeqNo")) {
				div.down("label", 5).innerHTML = formatCurrency(taxAmt);
				div.down("label", 6).innerHTML = formatCurrency(amtDue);
				$("takeupTaxTotal").value = formatCurrency(taxAmt);
				$("takeupBondAmtDue").value = formatCurrency(amtDue);
			}
		});
	}
	
	function setTaxAloccation(){
		$$("div[name='taxInformationRow']").each(function (div)	{
			if (div.down("label", 3).innerHTML == 'F')	{
				div.down("label", 3).innerHTML = "FIRST";
			}else if (div.down("label", 3).innerHTML == 'S') {
				div.down("label", 3).innerHTML = "SPREAD";
			}else{
				div.down("label", 3).innerHTML = "LAST";
			}
		});
	}
	
	function validateTaxEntries(){
		var isValid = true;
		var taxCd = $("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("listTaxCd");
		var str = "rowTax" + taxCd + "" + $F("bondTakeUpSeqNo");
		var count = $$("div[id='"+str+"']").size();
		if ($("bondTaxDesc").selectedIndex == 0){
			showMessageBox("There is no tax code entered for this invoice.");
			isValid = false;
		}else if (count > 0){
			showMessageBox("Tax already exist in list.");
			isValid = false;
		}
		
		return isValid;
	}
	
	function refreshDivs(){
		$$("div[name='takeUpRow']").each(function (r)	{
			r.remove();
		});
		$$("div[name='taxInformationRow']").each(function (r)	{
			r.remove();
		});
	}
	
	function setInitialProperties(){
		if ($F("bondIssCd") == "RI" || $F("bondIssCd") == "RB"){
			$("lblRiCommAmt").innerHTML = "RI Comm. Amt.";
			$("lblRiCommRt").innerHTML =  "RI Comm. Rate";
			$("lblRiCommVat").innerHTML = "RI Comm. VAT";
			$("bondRiCommRt").show();
			$("bondRiCommAmt").show();
			$("bondRiCommVat").show();
			$("lblTakeupRiCommAmt").innerHTML = "RI Comm. Amt.";
			$("lblTakeupRiCommRt").innerHTML =  "RI Comm. Rate";
			$("lblTakeupRiCommVat").innerHTML = "RI Comm. VAT";
			$("takeupBondRiCommRt").show();
			$("takeupBondRiCommAmt").show();
			$("takeupBondRiCommVat").show();
		}else{
			$("lblRiCommAmt").innerHTML = "";
			$("lblRiCommRt").innerHTML =  "";
			$("lblRiCommVat").innerHTML = "";
			$("bondRiCommRt").hide();
			$("bondRiCommAmt").hide();
			$("bondRiCommVat").hide();
			$("lblTakeupRiCommAmt").innerHTML = "";
			$("lblTakeupRiCommRt").innerHTML =  "";
			$("lblTakeupRiCommVat").innerHTML = "";
			$("takeupBondRiCommRt").hide();
			$("takeupBondRiCommAmt").hide();
			$("takeupBondRiCommVat").hide();
		}	
	}
	
	if (unformatCurrency("bondTotalAmt") == 0){
		enableButton("createInvoiceBtn");
	}
	
	if (takeupTerm == "MTH") { 
		$("takeupPayTerm").disabled = true;
	}
	
	//added by marj: manual date entry validation
	function validateDate(value){
		var reLong = /\b\d{1,2}[\/-]\d{1,2}[\/-]\d{4}\b/;
		if (reLong.test(value)){
			var delimChar = "-";
			var monthfield=value.split(delimChar)[0];
			var dayfield=value.split(delimChar)[1];
			var yearfield=value.split(delimChar)[2];

			var testDate = new Date(yearfield, monthfield-1, dayfield);
			if (testDate != "Invalid Date"){
				if (testDate.getDate() == dayfield) {
		        	if (testDate.getMonth() + 1 == monthfield) {
						if (testDate.getFullYear() == yearfield) {
			                return true;
			            } else {
			            	customShowMessageBox('Date must be entered in a format like MM-DD-RRRR.', imgMessage.INFO, "takeupBondDueDate");
			            	return false;
			            }
			        } else {
			        	customShowMessageBox('Month must be between 1 and 12.', imgMessage.INFO, "takeupBondDueDate");
			        	return false;
			        }
			    } else {
			    	customShowMessageBox('Day must be between 1 and last of month.', imgMessage.INFO, "takeupBondDueDate");
			    	return false;
			    }
			}else{
				customShowMessageBox('Date must be entered in a format like MM-DD-RRRR.', imgMessage.INFO, "takeupBondDueDate");
				$("takeupBondDueDate").value = "";
				return false;
			}
		}else{
			customShowMessageBox('Date must be entered in a format like MM-DD-RRRR.', imgMessage.INFO, "takeupBondDueDate");
			return false;
		}
	}
	
	//added by marj: computation of days of validity (expiry - incept)
	function computeNoOfDays()	{
		var inceptDate = objUWGlobal.inceptDate;
		var iDateArray = inceptDate.split("-");
		var iDate = new Date();
		var date = parseInt(iDateArray[1], 10);
		var month = parseInt(iDateArray[0], 10);
		var year = parseInt(iDateArray[2], 10);
		iDate.setFullYear(year, month-1, date);

		var expiryDate = $("hiddenExpiryDate").value;
		var eDateArray = expiryDate.split("-");
		var eDate = new Date();
		var edate = parseInt(eDateArray[1], 10);
		var emonth = parseInt(eDateArray[0], 10);
		var eyear = parseInt(eDateArray[2], 10);
		eDate.setFullYear(eyear, emonth-1, edate);

		var oneDay = 1000*60*60*24;
		var noOfDays = Math.floor((parseInt(Math.floor(eDate.getTime() - iDate.getTime()))/oneDay));
		
		return noOfDays;
	}
	
	//belle 09022012
	function validateB4Update(){
		if($F("takeupBondDueDate")=="" || $F("takeupBondDueDate")==null || $F("bondBookingDate")=="" || $F("bondBookingDate")==null){
			showMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR); 			
			return false;
		}
		
		updateTakeupTermList(objArray, $F("bondTakeUpSeqNo")); 
		changeTag = 1; 
		($$("div#invoiceInformationFooterHeader [changed=changed]")).invoke("removeAttribute", "changed"); 
	}
	//added function isDueDateValid  by robert SR 19785 07.20.15
	function isDueDateValid(){
		var isValid = true;
		var effDate = nvl($("hiddenEffDate").value,dateFormat(objGIPIWPolbas.formattedInceptDate, "mm-dd-yyyy"));
		var issueDate = $F("hiddenIssueDate");
		var expiryDate = nvl($("hiddenExpiryDate").value,dateFormat(objGIPIWPolbas.formattedExpiryDate, "mm-dd-yyyy"));
		var selDueDate = $F("takeupBondDueDate");
		var nxtDueDate = "";
		var prevDueDate = ""; 
		var nxtTakeupNo    = (parseInt(nvl($F("bondTakeUpSeqNo"),0)) + 1 ); 
		var prevTakeupNo   = (parseInt(nvl($F("bondTakeUpSeqNo"),0)) - 1 ); 
		
	 	$$("div#takeupTableContainer div[name='takeUpRow']").each(function(row){
	 		if (row.down("label", 0).innerHTML == nxtTakeupNo){
	 			nxtDueDate = dateFormat(row.down("label", 2).innerHTML, "mm-dd-yyyy");
			}else if (row.down("label", 0).innerHTML == prevTakeupNo){
				prevDueDate = dateFormat(row.down("label",2).innerHTML, "mm-dd-yyyy");
			}
		});
	 		  
		new Ajax.Request(contextPath+"/GIPIWinvoiceController", {
			method: "GET",
			parameters: {
				action: "validateBondDueDate",
				selDueDate: selDueDate,
				effDate: effDate,
				issueDate : issueDate,
				expiryDate: expiryDate,
				nxtDueDate: nxtDueDate,
			    prevDueDate: prevDueDate,
			    changeDueDate: changeDueDate
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				if(checkErrorOnResponse(response)) {
					var res = JSON.parse(response.responseText);
					var message = nvl(res.message, "");
 					
					if(!(message == "" || message == null || message == "null")) {
						createInvoiceTag = 0;
						if (changeDueDate == 1){
							customShowMessageBox(message, imgMessage.ERROR, "takeupBondDueDate");
							$("takeupBondDueDate").value = $F("hiddenDueDate");
							isValid = false;
						}else{
							customShowMessageBox(message, imgMessage.ERROR, "takeupBondDueDate");
							$("takeupBondDueDate").value = nvl(res.selDueDate,selDueDate);
							isValid = false;
						}
					}
				}
			}
		});
		return isValid; 
	}
	//end robert SR 19785 07.20.15
	//belle 11.07.2012
	function validateDueDate(){
		var effDate = $("hiddenEffDate").value;
		var issueDate = $F("hiddenIssueDate");
		var expiryDate = $("hiddenExpiryDate").value;
		var selDueDate = $F("takeupBondDueDate");
		var nxtDueDate = "";
		var prevDueDate = ""; 
		var nxtTakeupNo    = (parseInt(nvl($F("bondTakeUpSeqNo"),0)) + 1 ); 
		var prevTakeupNo   = (parseInt(nvl($F("bondTakeUpSeqNo"),0)) - 1 ); 
		
	 	$$("div#takeupTableContainer div[name='takeUpRow']").each(function(row){
	 		if (row.down("label", 0).innerHTML == nxtTakeupNo){
	 			nxtDueDate = dateFormat(row.down("label", 2).innerHTML, "mm-dd-yyyy");
			}else if (row.down("label", 0).innerHTML == prevTakeupNo){
				prevDueDate = dateFormat(row.down("label",2).innerHTML, "mm-dd-yyyy");
			}
		});
	 		  
		new Ajax.Request(contextPath+"/GIPIWinvoiceController", {
			method: "GET",
			parameters: {
				action: "validateBondDueDate",
				selDueDate: selDueDate,
				effDate: effDate,
				issueDate : issueDate,
				expiryDate: expiryDate,
				nxtDueDate: nxtDueDate,
			    prevDueDate: prevDueDate,
			    changeDueDate: changeDueDate
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				if(checkErrorOnResponse(response)) {
					var res = JSON.parse(response.responseText);
					var message = nvl(res.message, "");
 					
					if(!(message == "" || message == null || message == "null")) {
						if (changeDueDate == 1){
							customShowMessageBox(message, imgMessage.ERROR, "takeupBondDueDate");
							$("takeupBondDueDate").value = $F("hiddenDueDate");
						}else{
							customShowMessageBox(message, imgMessage.ERROR, "takeupBondDueDate");
							$("takeupBondDueDate").value = res.selDueDate;
						}
					}
				}
			}
		});
	}
	
	function checkGiisTaxCharges() {	//added by Gzelle 10302014
		var ret = false;
		for ( var x = 0; x < objTaxChargesParam.length; x++) {
			if (objTaxChargesParam[x].taxCd == selTaxCd && objTaxChargesParam[x].taxId == selTaxId) {
			//if (objTaxChargesParam[x].taxCd == objUW.taxCd && objTaxChargesParam[x].taxId == objUW.taxId) {		
				if (/*objTaxChargesParam[x].noRateTag == "Y" && */ objTaxChargesParam[x].taxType == "A") { // jhing 11.11.2014 commented out checking in no_rate_tag
					ret = true;
				} else if (objTaxChargesParam[x].taxType == "R") { //added by gab for fixed rate 07.14.2016 SR 21333
					ret = true;
				}
			}
		}
		return ret;
	}	
///**************************START OBSERVE ITEMS************************************///
	
	$("editTakeupBondRemarks").observe("click", function () {
		showEditor3("takeupBondRemarks", 4000);
	});
	
	$("takeupBondRemarks").observe("focus", function () {
		limitText($("takeupBondRemarks"), 4000);
	}); 
	
	$("createInvoiceBtn").observe("click", function() {
		// as consulted with sansy, bondTotalAmt should not be 0 - irwin
		if ($F("bondTotalAmt") != null && !isNaN($F("bondTotalAmt").replace(/,/g, "")) && unformatCurrency("bondTotalAmt") > 0 && isDueDateValid()){ //added isDueDateValid by robert SR 19785 07.20.15
			
			new Ajax.Request(contextPath + "/GIPIWinvoiceController?action=getTempTakeupList", {
				method: "GET",
				parameters: {
					parId: $F("globalParId"),
					lineCd: objUWGlobal.lineCd,
					issCd: $F("bondIssCd"),
					bondTsiAmt: $F("bondTotalAmt").replace(/,/g, ""), 
					premAmt: unformatCurrency("bondPremTotal"),
					riCommRt: $F("bondRiCommRt") == "" ? 0 : $F("bondRiCommRt"), 
					bondRate: parseFloat($F("bondRateTotal")),
					riCommAmt: unformatCurrency("bondRiCommAmt")
				},
				evalScripts: true,
				asynchronous: true,
				onComplete: function (response) {
					var result = response.responseText;
					
					objArray = {}; //modified by robert 02.24.2014
					objArray = JSON.parse(response.responseText);
					
					refreshDivs();
					showTakeupTermList(objArray);
					showTaxInformationList(objArray);
					$("newWinvoiceFlag").value = 'Y';
					disableButton("createInvoiceBtn");
					changeTag = 1; 
					deleteWDistTables(); // bonok :: 12.10.2013 :: delete record from distribution working tables upon clicking Create Invoice
					
					($$("div#invoiceInformationHeader [changed=changed]")).invoke("removeAttribute", "changed"); 
					$$("div[name='takeUpRow']").each(
							function (row)	{
								row.observe("mouseover", function ()	{
									row.addClassName("lightblue");
								});
								row.observe("mouseout", function ()	{
									row.removeClassName("lightblue");
								});
								row.observe("click", function ()	{
									populateTaxDtls(objTaxDtlsArray, 0);
									selectedRowId = row.getAttribute("id");
									row.toggleClassName("selectedRow");
									if (row.hasClassName("selectedRow"))	{
										$$("div[name='takeUpRow']").each(function (r)	{
											if (row.getAttribute("id") != r.getAttribute("id"))	{
												r.removeClassName("selectedRow");
											}	
									     });
		
										displayTakeupValues(objArray, row.down("input", 0).value);
										removeSelectedTaxInformation();
										hideTaxInformation();
										showTakeupButton(true);
										showTaxInfoButton(true);
										checkTableIfEmpty("taxInformationRow", "enterBondBillTaxInformationListingTable");
										try{
											for(var i=0; i<objArray.length; i++) {	
												if (objArray[i].takeupSeqNo == $F("bondTakeUpSeqNo")){	
													for(var j=0; j<objArray[i].taxCodes.length; j++){
														if ($F("bondTakeUpSeqNo") == objArray[i].taxCodes[j].takeupSeqNo){
															$("rowTax"+objArray[i].taxCodes[j].taxCd + "" + $F("bondTakeUpSeqNo")).show();
														}	
													}
												}
											}		
										}catch(e){
											//do nothing if div does not have a value
										}	
									} else {
										showTakeupButton(false);
										removeSelectedTaxInformation();
										resetToDefaultValues();
										hideTaxInformation();
										checkTableIfEmpty("taxInformationTableContainer", "enterBondBillTaxInformationListingTable");
									}	  	
								});			
							}	
						);
					//added by robert SR 19785 07.23.15
					$$("div#takeupTableContainer div[name='takeUpRow']").each(function(row){
				 		if (row.down("label", 0).innerHTML == 1){
				 			fireEvent(row, "click");
						}
					});
					if(isDueDateValid()){saveFuncMain();};
					//end robert SR 19785 07.23.15
				}
			});
		}else{
			customShowMessageBox(objCommonMessage.REQUIRED, "E", "bondTotalAmt");
		}	
	});
	
	// bonok :: 12.10.2013 :: delete record from distribution working tables upon clicking Create Invoice
	function deleteWDistTables(){
		new Ajax.Request(contextPath + "/GIPIWinvoiceController?action=deleteWDistTables", {
			method: "GET",
			parameters: {
				parId: $F("globalParId")
			},
			evalScripts: true,
			asynchronous: true,
			onComplete: function (response) {
				
			}
		});
	}
	
	//belle 12.17.12
	$("bondTotalAmt").observe("focus", function(){
		$("bondTotalAmt").value = $F("bondTotalAmt").replace(/,/g, "");
		$("bondTotalAmt").setAttribute("lastValidValue", this.value);
		if(binderExist == "Y"){
			showMessageBox("PAR has posted binders. Modification of TSI and/or premium amount  is not allowed.", "E");
		}
	});
	
	$("bondTotalAmt").observe("keyup", function(){
		if($("bondTotalAmt").value.include("-")){
			customShowMessageBox("Invalid Total Bond Amount. Valid value should be from 0.01 to 99,999,999,999,999.99", imgMessage.ERROR, "bondTotalAmt");
			$("bondTotalAmt").value = formatCurrency($("bondTotalAmt").getAttribute("lastValidValue"));
		}else if(isNaN(parseInt($F("bondTotalAmt").replace(/,/g, "")))){
			$("bondTotalAmt").value = "";
		}
	});
	
	$("bondTotalAmt").observe("blur", function(){
		if (!(validateLength($F("bondTotalAmt"), 14))){
			customShowMessageBox("Invalid Total Bond Amount. Valid value should be from 0.01 to 99,999,999,999,999.99", imgMessage.ERROR, "bondTotalAmt");
			$("bondTotalAmt").value = formatCurrency($("bondTotalAmt").getAttribute("lastValidValue"));
		}
		$("bondTotalAmt").value = formatCurrency($("bondTotalAmt").value);
	});
	 
	
	$("bondPremTotal").observe("focus", function(){
		$("bondPremTotal").value = $F("bondPremTotal").replace(/,/g, "");
		$("bondPremTotal").setAttribute("lastValidValue", this.value);
		if(binderExist == "Y"){
			showMessageBox("PAR has posted binders. Modification of TSI and/or premium amount  is not allowed.", "E");
		}
	});
		
	$("bondPremTotal").observe("keyup", function(){
		if($("bondPremTotal").value.include("-")){
			customShowMessageBox("Invalid Premium Amount. Valid value should be from 0.00 to 9,999,999,999.99 and must not be greater than TSI Amt.", imgMessage.ERROR, "bondPremTotal");
			$("bondPremTotal").value = formatCurrency($("bondPremTotal").getAttribute("lastValidValue"));
		}else if(isNaN(parseInt($F("bondPremTotal").replace(/,/g, "")))){
			$("bondPremTotal").value = "";
		}
	});
	
	$("bondPremTotal").observe("blur", function(){
		if (!(validateLength($F("bondPremTotal"), 10))){
			customShowMessageBox("Invalid Premium Amount. Valid value should be from 0.00 to 9,999,999,999.99 and must not be greater than TSI Amt.", imgMessage.ERROR, "bondPremTotal");
			$("bondPremTotal").value = formatCurrency($("bondPremTotal").getAttribute("lastValidValue"));
		}
		$("bondPremTotal").value = formatCurrency($("bondPremTotal").value);
	});
	
	
	$("bondRateTotal").observe("focus", function(){
		$("bondRateTotal").value = $F("bondRateTotal").replace(/,/g, "");
		$("bondRateTotal").setAttribute("lastValidValue", this.value);
		if(binderExist == "Y"){
			showMessageBox("PAR has posted binders. Modification of TSI and/or premium amount  is not allowed.", "E");
		}
	});
		
	$("bondRateTotal").observe("keyup", function(){
		if($("bondRateTotal").value.include("-")){
			customShowMessageBox("Invalid Bond Rate. Valid value should be from 0.000000001 to 100.000000000.", imgMessage.ERROR, "bondRateTotal");
			$("bondRateTotal").value = $("bondRateTotal").getAttribute("lastValidValue");
		}else if(isNaN(parseInt($F("bondRateTotal").replace(/,/g, "")))){
			$("bondRateTotal").value = "";
		}
	});
	
	$("bondRateTotal").observe("blur", function(){
		if ($F("bondRateTotal") == "" && $F("bondRateTotal") == null){
			customShowMessageBox("Invalid Bond Rate. Valid value should be from 0.000000001 to 100.000000000.", imgMessage.ERROR, "bondRateTotal");
			$("bondRateTotal").value = $("bondRateTotal").getAttribute("lastValidValue");
		}
	});
	
	
	$("bondRiCommRt").observe("focus", function(){
		$("bondRiCommRt").value = $F("bondRiCommRt").replace(/,/g, "");
		$("bondRiCommRt").setAttribute("lastValidValue", this.value);
	});
		
	$("bondRiCommRt").observe("keyup", function(){
		if($("bondRiCommRt").value.include("-")){
			customShowMessageBox("Invalid RI Comm Rate. Valid value should be from 0.000000001 to 100.000000000.", imgMessage.ERROR, "bondRiCommRt");
			$("bondRiCommRt").value = $("bondRiCommRt").getAttribute("lastValidValue");
		}else if(isNaN(parseInt($F("bondRiCommRt").replace(/,/g, "")))){
			$("bondRiCommRt").value = "";
		}
	});
	
	$("bondRiCommRt").observe("blur", function(){
		if ($F("bondRiCommRt") == "" && $F("bondRiCommRt") == null){
			customShowMessageBox("Invalid RI Comm Rate. Valid value should be from 0.000000001 to 100.000000000.", imgMessage.ERROR, "bondRiCommRt");
			$("bondRiCommRt").value = $("bondRiCommRt").getAttribute("lastValidValue");
		}
	});
	
	
	$("bondRiCommAmt").observe("focus", function(){
		$("bondRiCommAmt").value = $F("bondRiCommAmt").replace(/,/g, "");
		$("bondRiCommAmt").setAttribute("lastValidValue", this.value);
	});
		
	$("bondRiCommAmt").observe("keyup", function(){
		if($("bondRiCommAmt").value.include("-")){
			customShowMessageBox("Invalid RI Comm Amount. Valid value should be from 0.00 to 999,999,999,999.99.", imgMessage.ERROR, "bondRiCommAmt");
			$("bondRiCommAmt").value = formatCurrency($("bondRiCommAmt").getAttribute("lastValidValue"));
		}else if(isNaN(parseInt($F("bondRiCommAmt").replace(/,/g, "")))){
			$("bondRiCommAmt").value = "";
		}
	});
	
	$("bondRiCommAmt").observe("blur", function(){
		if (!(validateLength($F("bondRiCommAmt"), 12))){
			customShowMessageBox("Invalid RI Comm Amount. Valid value should be from 0.00 to 999,999,999,999.99.", imgMessage.ERROR, "bondRiCommAmt");
			$("bondRiCommAmt").value = formatCurrency($("bondRiCommAmt").getAttribute("lastValidValue"));
		}
	});
	//belle
	
	//$("bondTotalAmt").observe("blur", function() {
	$("bondTotalAmt").observe("change",function(){ // replaced 'blur' with 'change' Nica 06.26.2012
		if ($F("bondTotalAmt") != "" && $F("bondTotalAmt") != null ){//&& !isNaN($F("bondTotalAmt").replace(/,/g, ""))){ 
			if (unformatCurrency("bondTotalAmt") > 0){	
				if (validateLength($F("bondTotalAmt"), 14)) {
					$("bondTotalAmt").value = $F("bondTotalAmt").replace(/,/g, ""), 
					resetBondTotals();
					new Ajax.Request(contextPath + "/GIPIWinvoiceController?action=getFixedFlagGIPIS017B", {
						method: "GET",
						parameters: {
							parId: $F("globalParId"),
							premAmt: unformatCurrency("bondPremTotal"),
							bondRate: parseFloat(nvl($F("bondRateTotal"), "0")),
							bondAmt: unformatCurrency("bondTotalAmt")
						},
						evalScripts: true,
						asynchronous: false,
						onComplete: function (response){
							var result = response.responseText.toQueryParams();
							$("bondPremTotal").value = formatCurrency(result.premAmt);
							$("bondRateTotal").value = formatToNthDecimal(result.bondRate, 9);
							$("bondTotalAmt").value = formatCurrency($F("bondTotalAmt"));
							if ((result.message != null || result.message != "") && result.message.length > 1) {
								showMessageBox(result.message);
								//$("bondRateTotal").readOnly = true; removed by robert 
							}
							
							if ($F("bondIssCd") == $F("issCdRI") || $F("bondIssCd") == 'RB'){
								$("bondRiCommAmt").value = formatCurrency(parseFloat($F("bondRiCommRt")) * (unformatCurrency("bondPremTotal")/100));
								$("bondRiCommVat").value = formatCurrency(unformatCurrency("bondRiCommAmt") * parseFloat($F("bondInputVatRate") == "" ? 0 : $F("bondInputVatRate")) / 100);
								$("bondTotalAmtDue").value = formatCurrency(unformatCurrency("bondPremTotal") + unformatCurrency("bondTotalTaxAmt") - unformatCurrency("bondRiCommAmt") - unformatCurrency("bondRiCommVat"));
							}else{
								$("bondTotalAmtDue").value = formatCurrency(unformatCurrency("bondPremTotal") + unformatCurrency("bondTotalTaxAmt"));
							}
							enableButton("createInvoiceBtn");
							createInvoiceTag = 1;
						}
					});
				}else{
					customShowMessageBox("Invalid Total Bond Amount. Valid value should be from 0.01 to 99,999,999,999,999.99.", imgMessage.ERROR, "bondTotalAmt");
					$("bondTotalAmt").value = formatCurrency($("bondTotalAmt").getAttribute("lastValidValue")); 
				}
			}else{
				customShowMessageBox("Invalid Total Bond Amount. Valid value should be from 0.01 to 99,999,999,999,999.99.", imgMessage.ERROR, "bondTotalAmt");
				$("bondTotalAmt").value = formatCurrency($("bondTotalAmt").getAttribute("lastValidValue")); 
			}
	   }else{
			$("bondTotalAmt").value = formatCurrency($("bondTotalAmt").getAttribute("lastValidValue"));
		}
	});
	
	function checkForPostedBinders(){
		new Ajax.Request(contextPath + "/GIPIWinvoiceController?action=checkForPostedBinders", {
			method: "GET",
			parameters: {
				parId: $F("globalParId")
			},
			evalScripts: false,
			asynchronous: true,
			onComplete: function (response) {
				if(response.responseText == "Y"){
					binderExist = "Y";
					$("bondTotalAmt").setAttribute("readonly", "readonly");
					$("bondPremTotal").setAttribute("readonly", "readonly");
					$("bondRateTotal").setAttribute("readonly", "readonly");
				}
			}
		});
	}
	
	//$("bondPremTotal").observe("blur", function() {
	$("bondPremTotal").observe("change",function(){ // replaced 'blur' with 'change' Nica 06.26.2012
		checkForPostedBinders();
		if ($F("bondPremTotal") != "" && $F("bondPremTotal") != null && !isNaN($F("bondPremTotal").replace(/,/g, "")) ){//&& unformatCurrency("bondPremTotal") > 0){
			$("bondPremTotal").value = unformatCurrency("bondPremTotal");
			if (validateLength($F("bondPremTotal"), 10)) {
				enableButton("createInvoiceBtn");
				createInvoiceTag = 1;
				var origBondRateTotal = parseFloat($F("bondRateTotal")); // to by pass area1, added by irwin, 5.25.2012
				if(unformatCurrency("bondTotalAmt") == 0){
					$("bondRateTotal").value = formatToNthDecimal(0, 9);
				}else{
					if ($F("bondIssCd") == $F("issCdRI") || $F("bondIssCd") == 'RB'){
						$("bondRiCommAmt").value = formatCurrency(parseFloat($F("bondRiCommRt")) * (unformatCurrency("bondPremTotal")/100));
						$("bondTotalAmtDue").value = formatCurrency(unformatCurrency("bondPremTotal") + unformatCurrency("bondTotalTaxAmt") - unformatCurrency("bondRiCommAmt") - unformatCurrency("bondRiCommVat"));
					}else{
						$("bondTotalAmtDue").value = formatCurrency(unformatCurrency("bondPremTotal") + unformatCurrency("bondTotalTaxAmt"));
					}
			
					// this is area1
				  	if (unformatCurrency("bondTotalAmt") != 0){
					  	$("bondRateTotal").value = formatToNthDecimal(100 * unformatCurrency("bondPremTotal") / unformatCurrency("bondTotalAmt"), 9);
				  	}
				}
				
				$("bondRiCommVat").value = formatCurrency(unformatCurrency("bondRiCommAmt") * parseFloat($F("bondInputVatRate") == "" ? 0 : $F("bondInputVatRate")) / 100);
				
				if ( unformatCurrency("bondPremTotal") > unformatCurrency("bondTotalAmt")){
					$("bondRateTotal").value = formatToNthDecimal(origBondRateTotal, 9);
				 	//$("bondPremTotal").value = formatCurrency(0);  //bond rate should not reset and bondPremTotal should be recomputed  based on the previous rate - irwin
					//$("bondRateTotal").value = formatToNthDecimal(0, 9);
				 	$("bondRateTotal").value = formatToNthDecimal(origBondRateTotal, 9);
					$("bondPremTotal").value = formatCurrency(unformatCurrency("bondTotalAmt") * (parseFloat($F("bondRateTotal") / 100)));
					$("bondTotalAmtDue").value = formatCurrency(unformatCurrency("bondPremTotal") + unformatCurrency("bondTotalTaxAmt") - unformatCurrency("bondRiCommAmt") - unformatCurrency("bondRiCommVat"));
					showMessageBox("Premium amount cannot be higher than bond amount", imgMessage.INFO);
					if ($F("bondIssCd") == $F("issCdRI")){
						$("bondRiCommAmt").value = formatCurrency(parseFloat($F("bondRiCommRt")) * (unformatCurrency("bondPremTotal")/100));
						$("bondRiCommVat").value = formatCurrency(unformatCurrency("bondRiCommAmt") * parseFloat($F("bondInputVatRate") == "" ? 0 : $F("bondInputVatRate")) / 100);	
						$("bondTotalAmtDue").value = formatCurrency(unformatCurrency("bondPremTotal") + unformatCurrency("bondTotalTaxAmt") - unformatCurrency("bondRiCommAmt") - unformatCurrency("bondRiCommVat"));
					}
				}
			}else {
				customShowMessageBox("Invalid Premium Amount. Valid value should be from 0.00 to 9,999,999,999.99 and must not be greater than TSI Amt.", imgMessage.ERROR, "bondPremTotal");
				$("bondPremTotal").value = formatCurrency($("bondPremTotal").getAttribute("lastValidValue"));
			}
		}else if(isNaN($F("bondPremTotal").replace(/,/g, ""))){
			customShowMessageBox("Invalid Premium Amount. Valid value should be from 0.00 to 9,999,999,999.99 and must not be greater than TSI Amt.", imgMessage.ERROR, "bondPremTotal");
			$("bondPremTotal").value = formatCurrency($("bondPremTotal").getAttribute("lastValidValue"));
		}else {
			$("bondPremTotal").value = formatCurrency($("bondPremTotal").getAttribute("lastValidValue"));
		}	
		$("bondPremTotal").value = formatCurrency($F("bondPremTotal"));
	});
	
	$("bondRateTotal").observe("change", function () {
		if($F("bondRateTotal") != "" && $F("bondRateTotal") != null && !isNaN($F("bondRateTotal"))){ //
			if (parseFloat($F("bondRateTotal")) <= 100 && parseFloat($F("bondRateTotal")) >= 0) {
				/* replaced by robert GENQA SR 4825 08.03.15
				 $("bondPremTotal").value = formatCurrency(unformatCurrency("bondTotalAmt") * ($("bondRateTotal").value / 100));
				 $("bondRateTotal").value = formatToNthDecimal($F("bondRateTotal"), 9);
				 $("bondTotalAmtDue").value = formatCurrency(unformatCurrency("bondPremTotal") + unformatCurrency("bondTotalTaxAmt") - unformatCurrency("bondRiCommAmt") - unformatCurrency("bondRiCommVat"));
				 if ($F("bondIssCd") == $F("issCdRI")){ 
				 	 $("bondRiCommAmt").value = formatCurrency(parseFloat($F("bondRiCommRt")) * (unformatCurrency("bondPremTotal")/100));
					 $("bondRiCommVat").value = formatCurrency(unformatCurrency("bondRiCommAmt") * parseFloat($F("bondInputVatRate") == "" ? 0 : $F("bondInputVatRate")) / 100);	
					 $("bondTotalAmtDue").value = formatCurrency(unformatCurrency("bondPremTotal") + unformatCurrency("bondTotalTaxAmt") - unformatCurrency("bondRiCommAmt") - unformatCurrency("bondRiCommVat"));
				}  */
				new Ajax.Request(contextPath + "/GIPIWinvoiceController?action=getFixedFlagGIPIS017B", {
					method: "GET",
					parameters: {
						parId: $F("globalParId"),
						premAmt: unformatCurrency("bondPremTotal"),
						bondRate: $F("bondRateTotal"),
						bondAmt: unformatCurrency("bondTotalAmt")
					},
					evalScripts: true,
					asynchronous: false,
					onComplete: function (response){
						var result = response.responseText.toQueryParams();
						$("bondPremTotal").value = formatCurrency(result.premAmt);
						$("bondRateTotal").value = formatToNthDecimal(result.bondRate, 9);
						if ($F("bondIssCd") == $F("issCdRI") || $F("bondIssCd") == 'RB'){
							$("bondRiCommAmt").value = formatCurrency(parseFloat($F("bondRiCommRt")) * (unformatCurrency("bondPremTotal")/100));
							$("bondRiCommVat").value = formatCurrency(unformatCurrency("bondRiCommAmt") * parseFloat($F("bondInputVatRate") == "" ? 0 : $F("bondInputVatRate")) / 100);
							$("bondTotalAmtDue").value = formatCurrency(unformatCurrency("bondPremTotal") + unformatCurrency("bondTotalTaxAmt") - unformatCurrency("bondRiCommAmt") - unformatCurrency("bondRiCommVat"));
						}else{
							$("bondTotalAmtDue").value = formatCurrency(unformatCurrency("bondPremTotal") + unformatCurrency("bondTotalTaxAmt"));
						}
					}
				});
				// end robert GENQA SR 4825 08.03.15
				enableButton("createInvoiceBtn");
				createInvoiceTag = 1;
			}else {
				$("bondRateTotal").value = $("bondRateTotal").getAttribute("lastValidValue");
				customShowMessageBox("Invalid Bond Rate. Valid value should be from 0.000000001 to 100.000000000.", imgMessage.ERROR, "bondRateTotal");
			}
		}else if(isNaN($F("bondRateTotal").replace(/,/g, ""))){
			$("bondRateTotal").value = $("bondRateTotal").getAttribute("lastValidValue");
			customShowMessageBox("Invalid Bond Rate. Valid value should be from 0.000000001 to 100.000000000.", imgMessage.ERROR, "bondRateTotal");
		}else{
			$("bondRateTotal").value = $("bondRateTotal").getAttribute("lastValidValue");
		}
		
	});
	
	var bondTaxAmount;
	
	$("bondTaxAmount").observe("focus", function () {
		if ($F("bondTaxAmount") != ""){
			bondTaxAmount = $F("bondTaxAmount");
		}
	});
	
	//$("bondTaxAmount").observe("blur",function(){
	$("bondTaxAmount").observe("change",function(){ // replaced 'blur' with 'change' Nica 06.26.2012
		if ($F("bondTaxAmount") != null && $F("bondTaxAmount") != "" && !isNaN($F("bondTaxAmount").replace(/,/g, "")) && unformatCurrency("bondTaxAmount") > -1){
			if(parseFloat(unformatCurrency("bondTaxAmount")) > parseFloat(unformatCurrency("bondPremTotal")) && nvl('${endtTax}', 'N') != 'Y'){	//added by Gzelle 10302014
				if (polFlag != "4") {
					if (allowTaxGreaterThanPremium == "Y" && parTypeCond == "P" && checkGiisTaxCharges()) {
						$("bondTaxAmount").value = formatCurrency($F("bondTaxAmount"));
					}else if (checkGiisTaxCharges()) { // jhing 11.11.2014 instead of else used else if checkGiisTaxCharges to prevent firing of validation for non-fixed amount tax type
						showWaitingMessageBox("Invalid Tax Amount. Tax Amount should not be greater than the Premium.", "E", function(){ 
							$("bondTaxAmount").value = formatCurrency(bondTaxAmount);
							$("bondTaxAmount").select();
						});
					}
				}
			}else{
				$("bondTaxAmount").value = formatCurrency($F("bondTaxAmount"));
			}
		}else{
			customShowMessageBox('Required field must be entered', imgMessage.ERROR, "bondTaxAmount"); 
		}			
	});
	
	//$("bondRiCommAmt").observe("blur", function() {
	$("bondRiCommAmt").observe("change",function(){ // replaced 'blur' with 'change' Nica 06.26.2012
		if ($F("bondRiCommAmt") != "" && $F("bondRiCommAmt") != null && !isNaN($F("bondRiCommAmt").replace(/,/g, "")) && unformatCurrency("bondRiCommAmt") > 0){
			if (validateLength($F("bondRiCommAmt"), 14)){
				if($F("bondIssCd") == "RB" || $F("bondIssCd") == "RI") {
					//belle 11.08.2012
					if (unformatCurrency("bondRiCommAmt") > unformatCurrency("bondPremTotal")){
						$("bondRiCommAmt").value = formatCurrency(parseFloat($F("bondRiCommRt")*(unformatCurrency("bondPremTotal")/100)));
						showMessageBox("RI Comm Amt must not be greater than Total Premium Amount", imgMessage.INFO);
					}else{
						enableButton("createInvoiceBtn");
						$("bondRiCommVat").value = formatCurrency(unformatCurrency("bondRiCommAmt") * parseFloat($F("bondInputVatRate") == "" ? 0 : $F("bondInputVatRate")) / 100);
						$("bondTotalAmtDue").value = formatCurrency(unformatCurrency("bondPremTotal") + unformatCurrency("bondTotalTaxAmt") - unformatCurrency("bondRiCommAmt") - unformatCurrency("bondRiCommVat"));
						if(unformatCurrency("bondPremTotal") > 0) {
							$("bondRiCommRt").value = formatToNthDecimal((unformatCurrency("bondRiCommAmt")*100)/unformatCurrency("bondPremTotal"), 7);;
						}
					}
				} else {
					$("bondTotalAmtDue").value = formatCurrency(unformatCurrency("bondPremTotal") + unformatCurrency("bondTotalTaxAmt"));
				}
				$("bondRiCommAmt").value = formatCurrency(formatCurrency($F("bondRiCommAmt")));
				
			}else{
				customShowMessageBox("Invalid RI Comm Amount. Valid value should be from 0.00 to 999,999,999,999.99.", imgMessage.ERROR, "bondRiCommAmt");
				$("bondRiCommAmt").value = formatCurrency($("bondRiCommAmt").getAttribute("lastValidValue"));
			}
		}else{
			$("bondRiCommAmt").value = formatCurrency($("bondRiCommAmt").getAttribute("lastValidValue"));
		}
		
	});
	
	//$("bondRiCommRt").observe("blur", function() {
	$("bondRiCommRt").observe("change",function(){ // replaced 'blur' with 'change' Nica 06.26.2012
		if ($F("bondRiCommRt") != "" && $F("bondRiCommRt") != null && !isNaN($F("bondRiCommRt"))){
			if (parseFloat($F("bondRiCommRt")) <= 100 && parseFloat($F("bondRiCommRt")) >= 0) {
				$("bondRiCommAmt").value = formatCurrency(parseFloat($F("bondRiCommRt")*(unformatCurrency("bondPremTotal")/100)));
				$("bondRiCommVat").value = formatCurrency(unformatCurrency("bondRiCommAmt")*parseFloat($F("bondInputVatRate"))/100);
				$("bondRiCommRt").value = formatToNthDecimal($F("bondRiCommRt"), 9);
				$("bondTotalAmtDue").value = formatCurrency(unformatCurrency("bondPremTotal") + unformatCurrency("bondTotalTaxAmt") - unformatCurrency("bondRiCommAmt") - unformatCurrency("bondRiCommVat")); //belle 11.07.2012 nilipat ko lang ndi nakikita ung ricommvat e
				enableButton("createInvoiceBtn");
			}else {
				$("bondRiCommRt").value = $("bondRiCommRt").getAttribute("lastValidValue");
				customShowMessageBox("Invalid RI Comm Rate. Valid value should be from 0.000000001 to 100.000000000.", imgMessage.ERROR, "bondRiCommRt");
			}
		}else if(isNaN($F("bondRiCommRt").replace(/,/g, ""))){
			$("bondRiCommRt").value =  $("bondRiCommRt").getAttribute("lastValidValue");
			customShowMessageBox("Invalid RI Comm Rate. Valid value should be from 0.000000001 to 100.000000000.", imgMessage.ERROR, "bondRiCommRt");
		}else{
			$("bondRiCommRt").value = $("bondRiCommRt").getAttribute("lastValidValue");
		}
	});
	
	//$("bondRiCommVat").observe("blur",function(){
	$("bondRiCommVat").observe("change",function(){ // replaced 'blur' with 'change' Nica 06.26.2012
		if ($F("bondRiCommVat") != null && !isNaN($F("bondRiCommVat").replace(/,/g, "")) && unformatCurrency("bondRiCommVat") > -1){
			if (validateLength($F("bondRiCommVat"), 14)){
				$("bondRiCommVat").value = formatCurrency($F("bondRiCommVat"));
		 	}else{
				customShowMessageBox(getNumberFieldErrMsg($("bondRiCommVat"), true), imgMessage.ERROR, "bondRiCommVat"); 
			} 
			
		}else{
			customShowMessageBox(getNumberFieldErrMsg($("bondRiCommVat"), true), imgMessage.ERROR, "bondRiCommVat");
		}			
	});
	
	//start - added by christian 03/21/2013
	$("takeupBondRiCommAmt").observe("focus", function(){
		$("takeupBondRiCommAmt").value = $F("takeupBondRiCommAmt").replace(/,/g, "");
		$("takeupBondRiCommAmt").setAttribute("lastValidValue", this.value);
	});
		
	$("takeupBondRiCommAmt").observe("change", function(){
		var takeupBondRiCommAmt = parseFloat(unformatCurrency("takeupBondRiCommAmt"));
		if(Math.abs(takeupBondRiCommAmt) > 999999999999.99 || isNaN(takeupBondRiCommAmt)){
			customShowMessageBox("Field must be of form 999,999,999,999.99.", imgMessage.ERROR, "takeupBondRiCommAmt");
			$("takeupBondRiCommAmt").value = formatCurrency($("takeupBondRiCommAmt").getAttribute("lastValidValue"));
		}
		if($F("bondIssCd") == "RB" || $F("bondIssCd") == "RI") {
			if (unformatCurrency("takeupBondRiCommAmt") > unformatCurrency("takeupPremAmt")){
				$("takeupBondRiCommAmt").value = formatCurrency(parseFloat($F("takeupBondRiCommRt")*(unformatCurrency("takeupPremAmt")/100)));
				showMessageBox("RI Comm Amt must not be greater than Total Premium Amount", imgMessage.INFO);
			}else{
				$("takeupBondRiCommVat").value = formatCurrency(unformatCurrency("takeupBondRiCommAmt") * parseFloat($F("bondInputVatRate") == "" ? 0 : $F("bondInputVatRate")) / 100);
				$("takeupBondAmtDue").value = formatCurrency(unformatCurrency("takeupPremAmt") + unformatCurrency("takeupTaxTotal") - unformatCurrency("takeupBondRiCommAmt") - unformatCurrency("takeupBondRiCommVat"));
				if(unformatCurrency("takeupPremAmt") > 0) {
					$("takeupBondRiCommRt").value = formatToNthDecimal((unformatCurrency("takeupBondRiCommAmt")*100)/unformatCurrency("takeupPremAmt"), 7);;
				}
			}
		}
		$("takeupBondRiCommAmt").value = formatCurrency($("takeupBondRiCommAmt").value);
	});
	
	$("takeupBondRiCommVat").observe("focus", function(){
		$("takeupBondRiCommVat").value = $F("takeupBondRiCommVat").replace(/,/g, "");
		$("takeupBondRiCommVat").setAttribute("lastValidValue", this.value);
	});
		
	$("takeupBondRiCommVat").observe("change", function(){
		var takeupBondRiCommAmt = parseFloat(unformatCurrency("takeupBondRiCommVat"));
		if(Math.abs(takeupBondRiCommAmt) > 999999999999.99 || isNaN(takeupBondRiCommAmt)){
			customShowMessageBox("Field must be of form 999,999,999,999.99.", imgMessage.ERROR, "takeupBondRiCommVat");
			$("takeupBondRiCommVat").value = formatCurrency($("takeupBondRiCommVat").getAttribute("lastValidValue"));
		}
		$("takeupBondRiCommVat").value = formatCurrency($("takeupBondRiCommVat").value);
	});
	
	$("takeupBondRiCommRt").observe("focus", function(){
		$("takeupBondRiCommRt").value = $F("takeupBondRiCommRt");
		$("takeupBondRiCommRt").setAttribute("lastValidValue", this.value);
	});
	
	$("takeupBondRiCommRt").observe("change", function(){
		if (parseFloat($F("takeupBondRiCommRt")) > 100 || parseFloat($F("takeupBondRiCommRt")) < 0) {
			$("takeupBondRiCommRt").value = $("takeupBondRiCommRt").getAttribute("lastValidValue");
			customShowMessageBox("Field must be of form 990.999999999", imgMessage.ERROR, "takeupBondRiCommRt");
		}
		$("takeupBondRiCommRt").value  = formatToNthDecimal($F("takeupBondRiCommRt"), 9);
	});
	
	$("takeupBondRiCommRt").observe("change",function(){
		if(isNaN($F("takeupBondRiCommRt").replace(/,/g, ""))){
			$("takeupBondRiCommRt").value =  $("takeupBondRiCommRt").getAttribute("lastValidValue");
			customShowMessageBox("Invalid RI Comm Rate. Valid value should be from 0.000000001 to 100.000000000.", imgMessage.ERROR, "takeupBondRiCommRt");
		}
		if (parseFloat($F("takeupBondRiCommRt")) <= 100 && parseFloat($F("takeupBondRiCommRt")) >= 0) {
			$("takeupBondRiCommAmt").value = formatCurrency(parseFloat($F("takeupBondRiCommRt")*(unformatCurrency("takeupPremAmt")/100)));
			$("takeupBondRiCommVat").value = formatCurrency(unformatCurrency("takeupBondRiCommAmt")*parseFloat($F("bondInputVatRate"))/100);
			$("takeupBondRiCommRt").value = formatToNthDecimal($F("takeupBondRiCommRt"), 9);
			$("takeupBondAmtDue").value = formatCurrency(unformatCurrency("takeupPremAmt") + unformatCurrency("takeupTaxTotal") - unformatCurrency("takeupBondRiCommAmt") - unformatCurrency("takeupBondRiCommVat"));
		}else {
			$("takeupBondRiCommRt").value = $("takeupBondRiCommRt").getAttribute("lastValidValue");
			customShowMessageBox("Field must be of form 990.999999999", imgMessage.ERROR, "takeupBondRiCommRt");
		}
	});
	//end - added by christian
	
	$("btnBondSave").observe("click", function() {
		if(objArray.length > 0){
			if(createInvoiceTag == 1){
				customShowMessageBox("Please press the Create Invoice/s button.", "I", "createInvoiceBtn");
				return false;
			}else if(isDueDateValid()){ //added by robert SR 19785 07.23.15
			saveFuncMain();
			}
		}else{
			showMessageBox("Saving is not allowed. Please press Create Invoice/s button first to recreate the invoice.");
		}
		
	});
	
	$("btnBondAdd").observe("click", function () {
		var itemTable = $("taxInformationTableContainer");
		var newDiv = new Element("div");
		if ($("btnBondAdd").value == "Add"){
			if (validateTaxAmtForAddUpdate("Add")){
				if (validateTaxEntries()){					
					var taxCd = $("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("listTaxCd");
					var taxDesc = $("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].text;
					var taxAmt = unformatCurrencyValue($F("bondTaxAmount"));
					var taxAlloc = $("bondTaxAlloc").options[$("bondTaxAlloc").selectedIndex].text;
					//var taxAllocValue = $("bondTaxAlloc").options[$("bondTaxAlloc").selectedIndex].value;
					var taxAllocValue = $("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("allocationTag"); //added by steven 10.14.2014
					var taxId = $("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("listTaxId");
					var taxRate = $("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("listTaxRt");
					var noRateTag = $("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("noRateTag");
					var primarySw = $("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("primarySw");
					if ($("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("taxType") == "A") {	//added by Gzelle 10302014
						taxRate = 0;	
					}else if ($("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("taxType") == "N") {	//added by Jhing 11.09.2014
						taxRate = 0;	
					}
					newDiv.setAttribute("id", "rowTax"+ $("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("listTaxCd") + "" + $F("bondTakeUpSeqNo"));
					newDiv.setAttribute("taxCd", taxCd);
					newDiv.setAttribute("name", "taxInformationRow");
					newDiv.addClassName("tableRow");	
					
					var content = '<label style="width: 85px; text-align: center; margin-left: 25px;" name="lblTaxInfo" id="lblTaxInfoTaxCd'+$F("bondTakeUpSeqNo")+'">'+taxCd+'</label>'+
					  '<label style="width: 180px; text-align: left; margin-left: 40px;" name="lblTaxInfo" id="lblTaxInfoTaxDesc'+$F("bondTakeUpSeqNo")+ taxCd +'">'+(taxDesc == null ? "-" : taxDesc)+'</label>'+
					  '<label style="width: 120px; text-align: right; margin-left: 25px;" name="lblTaxInfo" id="lblTaxInfoTaxAmt'+$F("bondTakeUpSeqNo")+ taxCd +'">'+(taxAmt == null ? formatCurrency(0) : formatCurrency(taxAmt))+'</label>'+
					  '<label style="width: 50px; text-align: left; margin-left: 60px;" name="lblTaxInfo" id="lblTaxInfoTaxAlloc'+$F("bondTakeUpSeqNo")+ taxCd +'">'+(taxAlloc == null ? "-" : taxAllocValue)+'</label>'+
					  '<input type="hidden" name="hiddenTaxInfoTaxCd" value="'+(taxCd == null ? "" : taxCd)+'" />' +
					  '<input type="hidden" name="hiddenTaxInfoTaxDesc" value="'+(taxDesc == null ? "" : taxDesc)+'" />'+
					  '<input type="hidden" name="hiddenTaxInfoTaxAmt" value="'+(taxAmt == null ? formatCurrency(0) : formatCurrency(taxAmt))+'" />'+
					  '<input type="hidden" name="hiddenTaxInfoTaxAlloc" value="'+(taxAllocValue == null ? "" : taxAllocValue)+'" />' + 
					  '<input type="hidden" name="hiddenTaxInfoTaxId" value="'+(taxId == null ? "" : taxId)+'" />' +
					  '<input type="hidden" name="hiddenTaxInfoNoRateTag" value="'+ noRateTag +'" />' +
					  '<input type="hidden" name="hiddenTaxInfoTaxRate" value="'+ taxRate +'" />' +
					  '<input type="hidden" name="hiddenTaxInfoPrimarySw" value="'+ primarySw +'" />';
		
					newDiv.update(content);
					itemTable.insert({bottom : newDiv}); 	
					divEvents(newDiv);

					recomputeTaxes("add");  
					setGIPIWinvTax();
					resetTaxInformation();	
					checkTableIfEmpty("taxInformationRow", "enterBondBillTaxInformationListingTable");
					changeTag = 1; 
					($$("div#taxInformationHeader [changed=changed]")).invoke("removeAttribute", "changed"); 
				}	
			}
		
		}else {
			if (validateTaxAmtForAddUpdate("Update")){
				$("hiddenTaxAmt").value = unformatCurrencyValue($F("bondTaxAmount"));
			
				$$("div[name='taxInformationRow']").each(function (row)	{
					if (row.hasClassName("selectedRow"))	{
						markTaxRecordAsDeleted(row.down("input", 0).value);
						recomputeTaxes("delete");
						row.remove();	
						checkTableIfEmpty("taxInformationRow", "enterBondBillTaxInformationListingTable");						
					}
				});
				
				newDiv.setAttribute("id", "rowTax"+ $("hiddenTaxCd").value + "" + $F("bondTakeUpSeqNo"));
				newDiv.setAttribute("taxCd", $("hiddenTaxCd").value);
				newDiv.setAttribute("name", "taxInformationRow");
				newDiv.addClassName("tableRow");	
				
				var content = '<label style="width: 85px; text-align: center; margin-left: 25px;" name="lblTaxInfo" id="lblTaxInfoTaxCd'+$F("bondTakeUpSeqNo")+'">'+$("hiddenTaxCd").value+'</label>'+
				  '<label style="width: 180px; text-align: left; margin-left: 40px;" name="lblTaxInfo" id="lblTaxInfoTaxDesc'+$F("bondTakeUpSeqNo")+ $("hiddenTaxCd").value +'">'+($("hiddenTaxDesc").value == null ? "-" : $("hiddenTaxDesc").value)+'</label>'+
				  '<label style="width: 120px; text-align: right; margin-left: 25px;" name="lblTaxInfo" id="lblTaxInfoTaxAmt'+$F("bondTakeUpSeqNo")+ $("hiddenTaxCd").value +'">'+($("hiddenTaxAmt").value == null ? formatCurrency(0) : formatCurrency($("hiddenTaxAmt").value))+'</label>'+
				  '<label style="width: 50px; text-align: left; margin-left: 60px;" name="lblTaxInfo" id="lblTaxInfoTaxAlloc'+$F("bondTakeUpSeqNo")+ $("hiddenTaxCd").value +'">'+($("hiddenTaxAlloc").value == null ? "-" : $("hiddenTaxAlloc").value) +'</label>'+
				  '<input type="hidden" name="hiddenTaxInfoTaxCd" value="'+($("hiddenTaxCd").value == null ? "" : $("hiddenTaxCd").value)+'" />' +
				  '<input type="hidden" name="hiddenTaxInfoTaxDesc" value="'+($("hiddenTaxDesc").value == null ? "" : $("hiddenTaxDesc").value)+'" />'+
				  '<input type="hidden" name="hiddenTaxInfoTaxAmt" value="'+($("hiddenTaxAmt").value == null ? formatCurrency(0) : formatCurrency($("hiddenTaxAmt").value))+'" />'+
				  '<input type="hidden" name="hiddenTaxInfoTaxAlloc" value="'+($("hiddenTaxAlloc").value == null ? "" : $("hiddenTaxAlloc").value)+'" />' +
				  '<input type="hidden" name="hiddenTaxInfoTaxId" value="'+($("hiddenTaxId").value  == null ? "" : $("hiddenTaxId").value)+'" />' +
				  '<input type="hidden" name="hiddenTaxInfoNoRateTag" value="'+$("hiddenNoRateTag").value+'" />' +
				  '<input type="hidden" name="hiddenTaxInfoTaxRate" value="'+ $("hiddenTaxRate").value +'" />' +
				  '<input type="hidden" name="hiddenTaxInfoPrimarySw" value="'+ $("hiddenPrimarySw").value +'" />';	
				  
				newDiv.update(content);
				itemTable.insert({bottom : newDiv}); 	
				divEvents(newDiv);
		
				recomputeTaxes("add");
				setGIPIWinvTax2();
				resetTaxInformation();	
				checkTableIfEmpty("taxInformationRow", "enterBondBillTaxInformationListingTable");	
				changeTag = 1;
				($$("div#taxInformationHeader [changed=changed]")).invoke("removeAttribute", "changed"); 
			}
		}	
	});
	
	$("btnBondDelete").observe("click", function ()	{
		$$("div[name='taxInformationRow']").each(function (row)	{
			if (row.hasClassName("selectedRow"))	{
				if($F("hiddenPrimarySw") == 'Y'){
					showMessageBox("You cannot delete this record.");
				}else{
					markTaxRecordAsDeleted(row.down("input", 0).value);
					recomputeTaxes("delete");
					row.remove();	
					resetTaxInformation();	
					checkTableIfEmpty("taxInformationRow", "enterBondBillTaxInformationListingTable");
					changeTag = 1; 
				}
			}
		});
	});

	function getRangeAmount() { //added by jhing 11.09.2014
		try {
			var result = null;
			new Ajax.Request(contextPath + "/GIPIWinvoiceController", {
				parameters : {action : "getBondsRangeAmount",
							  taxCd :  $("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("listTaxCd"),
							  taxId :  $("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("listTaxId"),
							  parId :  $F("globalParId"),
							  premAmt : 0 /*prem recomp in the func*/ ,
							  itemGrp : 1 /* bonds has only one bill group */,
							  takeupSeqNo : $F("bondTakeUpSeqNo"),
							  takeupAllocTag :  $("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("takeupAllocTag")},
			  	asynchronous: false,
			    evalScripts: true,
				onComplete : function(response){
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						result = nvl(response.responseText,'0');
					}
				}
			});
			return result;
		} catch (e) {
			showErrorMessage("getRangeAmount",e);
		}
	}
	
	function getRateAmount() { //added by jhing 11.09.2014
		try {
			var result = null;
			new Ajax.Request(contextPath + "/GIPIWinvoiceController", {
				parameters : {action : "getBondsRateAmount",
							  taxCd :  $("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("listTaxCd"),
							  taxId :  $("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("listTaxId"),
							  parId :  $F("globalParId"),
							  itemGrp : 1 /* bonds has only one bill group */,
							  takeupSeqNo : $F("bondTakeUpSeqNo")},
			  	asynchronous: false,
			    evalScripts: true,
				onComplete : function(response){
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						result = nvl(response.responseText,'0');
					}
				}
			});
			return result;
		} catch (e) {
			showErrorMessage("getRangeAmount",e);
		}
	}

	function getDocStampsTaxAmt() { //added by jhing 11.09.2014
		try {
			var result = null;
			new Ajax.Request(contextPath + "/GIPIWinvoiceController", {
				parameters : {action : "getBondsDocStampsTaxAmt",
							  taxCd : $("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("listTaxCd"),
							  taxId :  $("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("listTaxId"),
							  parId : $F("globalParId"),
							  premAmt : 0 /*prem recomp in the func*/ ,
							  itemGrp : 1 /* bonds has only one bill group */,
							  takeupSeqNo : $F("bondTakeUpSeqNo"),
							 // takeupAllocTag : nvl($F("taxAllocation"),'F') // temporary
							  takeupAllocTag : $("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("takeupAllocTag")
							  },
			  	asynchronous: false,
			    evalScripts: true,
				onComplete : function(response){
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						result = nvl(response.responseText,'0');
					}
				}
			});
			return result;
		} catch (e) {
			showErrorMessage("getDocStampsTaxAmt",e);
		}
	}	
	
	function getFixedAmountTax() { //added by jhing 11.09.2014
		try {
			var result = null;
			new Ajax.Request(contextPath + "/GIPIWinvoiceController", {
				parameters : {action : "getBondsFixedAmountTax",
							  taxCd : $("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("listTaxCd"),
							  taxId :  $("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("listTaxId"),
							  parId :  $F("globalParId"),
							  premAmt : 0 /*prem recomp in the func*/,
							  tempTaxAmt : parseFloat(nvl($("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("taxAmount"), "0")),
							  itemGrp : 1 /* bonds has only one bill group */,
							  takeupSeqNo :  $F("bondTakeUpSeqNo"),
							  takeupAllocTag :$("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("takeupAllocTag")},
			  	asynchronous: false,
			    evalScripts: true,
				onComplete : function(response){
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						result = nvl(response.responseText,'0');
					}
				}
			});
			return result;
		} catch (e) {
			showErrorMessage("getFixedAmountTax",e);
		}
	}		
	
    //edited by marj: different computation of eVAT from other taxes 
	$("bondTaxDesc").observe("change", function () {
		var taxDesc = $("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].text;
		var taxCd = $("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("listTaxCd");
		var premAmt = unformatCurrency("bondPremTotal");
		var taxType = $("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("taxType");
		
		function continueBondTaxDesc() {
		//if(taxCd == 8 && vatTag == 2){ //belle 10022012 changed taxDesc == "EXPANDED VAT" // commented out jhing 11.09.2014 
			if(taxCd == '${evatParamValue}' && vatTag == 2){  
				showMessageBox("This assured is zero VAT rated.");
				$("bondTaxAmount").value = formatCurrency(0);
				$("bondTaxAmount").readOnly = true; 
			}else{
				$("bondTaxAmount").readOnly = false; 
				
				// jhing 11.09.2014 commented out code. Will use function to retrieve computed tax amounts.
				/*if(taxDesc == "DOCUMENTARY STAMPS" && docStampsParam == "Y"){
					$("bondTaxAmount").value = formatCurrency(Math.round((unformatCurrency("takeupPremAmt") / 4) * (0.5)) + (0.5));
				}else if (taxType == "A"){
					$("bondTaxAmount").value = formatCurrency(parseFloat(nvl($("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("taxAmount"), "0")));
				}else{
					$("bondTaxAmount").value = formatCurrency(Math.round((unformatCurrency("takeupPremAmt") * (parseFloat($("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("listTaxRt"))/100))*100)/100);	
				}*/

				// jhing 11.09.2014 new tax computation 
				if(taxCd == '${docStampsParamValue}'){
					$("bondTaxAmount").value = formatCurrency(getDocStampsTaxAmt ());
				}else if (taxType == 'A') { 
					$("bondTaxAmount").value = formatCurrency(getFixedAmountTax ());
				}else if (taxType == 'N'){
					$("bondTaxAmount").value = formatCurrency(getRangeAmount ());
				}else {
					$("bondTaxAmount").value = formatCurrency(getRateAmount ());
				}				
			}
		}
		if((nvl($("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("taxAmount"), "0")) > premAmt && nvl('${endtTax}', 'N') != 'Y'){	//added by Gzelle 1022014
			if (polFlag != "4") {	//
				if (allowTaxGreaterThanPremium == "Y" && parTypeCond == "P" && checkGiisTaxCharges()) {
					continueBondTaxDesc();
				}else if (checkGiisTaxCharges()) { // jhing 11.11.2014 instead of else used else if checkGiisTaxCharges to prevent firing of validation for non-fixed amount tax type
					showWaitingMessageBox("Invalid Tax Amount. Tax Amount should not be greater than the Premium.", "E", function(){ 
						$("bondTaxAmount").value = nvl($("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("tempTaxAmt"), "0");
						$("bondTaxAmount").select();
					});
				}
			}
		}else {
			continueBondTaxDesc();
		}
	});
	
	$("btnTakeupUpdate").observe("click", function(){
		if(isDueDateValid()){ //added isDueDateValid by robert SR 19785 07.20.15
			if (changeBookingDate == 1){
				if (validateBookingDate()){
					validateB4Update();
				}
			}else{
				validateB4Update();
			}
		} //end robert SR 19785 07.20.15
			
	});
	
	$("btnTakeupCancel").observe("click", function() {
		showTakeupButton(false);
		removeSelectedTaxInformation();
		removeSelectedTakeUpInformation();
		resetToDefaultValues();
		hideTaxInformation();
	});
	
	$("btnBondCancel").observe("click", 
			function () {
				if(changeTag != 0){
					showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function () {saveFuncMain();goBackToParListing();}, goBackToParListing, "");
				}else {
					goBackToParListing();
				}
			}
		);
	
	//belle 11.07.2012
	var changeDueDate = 0;
	$("takeupBondDueDate").observe("change", function () {
		if($F("takeupBondDueDate")=="" || $F("takeupBondDueDate")==null){
			showMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR); 	
			return false;
		}else{
			changeDueDate = 1;
			if(validateDate($F("takeupBondDueDate"))){
				validateDueDate();
			}
		}
	});
	
	//belle 09022012  
	var changeBookingDate = 0;
	$("bondBookingDate").observe("change", function(){
		if (makeDate(objGIPIWPolbas.formattedExpiryDate) < makeDate(objGIPIWPolbas.issueDate)){ 
			if (nvl(objUW.hidObjGIPIS017.allowIssueExpiredBond, "N") == "N"){
				changeBookingDate = 1;  
				validateBookingDate();
			}
		}else {
			changeBookingDate = 1;  
			validateBookingDate();
		}
	});
	
	//belle 09102012
	$("takeupPayTerm").observe("change", function () {
		var noOfDays = $("takeupPayTerm").options[$("takeupPayTerm").selectedIndex].getAttribute("noOfDays");
		var onInceptTag = $("takeupPayTerm").options[$("takeupPayTerm").selectedIndex].getAttribute("onInceptTag");
		
		if (onInceptTag == "N"){
			var newDate = Date.parse($("hiddenDueDate").value);
			newDate.setDate(newDate.getDate() + parseInt(nvl(noOfDays, 0)));
			$("takeupBondDueDate").value = newDate.format("mm-dd-yyyy");
			validateDueDate();
		}else {
			$("takeupBondDueDate").value = $("hiddenDueDate").value;
		} 
	});
	
	///**************************END OBSERVE ITEMS************************************///
	
	//format a number to a specified number of decimal places
	//used to handle exponential values
	function roundExpNumber(number, decimals) {
		var newnumber = new Number(number+'').toFixed(parseInt(decimals));
		return parseFloat(newnumber);
	}
	
	checkForPostedBinders();
	setInitialProperties();
	initializeAccordion();
	initializeAll();
	initializeChangeTagBehavior(saveFuncMain);
	initializeChangeAttribute(); 
	hideNotice();
</script>
