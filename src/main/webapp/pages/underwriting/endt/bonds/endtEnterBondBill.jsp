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
<div class="sectionDiv" id="enterBondBillInformationDiv" changeTagAttr="true">
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
	
	<div id="parInformationHeader" style="margin: 10px;">
		<table width="80%" align="center" cellspacing="1" border="0">
 			<tr>
				<td class="rightAligned" style="width: 103px;">Par No.</td>
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

<div class="sectionDiv" id="invoiceInformationDiv" changeTagAttr="true">	
	<div id="invoiceInformationHeader" style="margin: 10px;">
		<table width="80%" align="center" cellspacing="1" border="0">
 			<tr>
				<td class="rightAligned" style="width: 150px;">Total Bond Amount</td>
				<td class="leftAligned"><input id="bondTotalAmt" style="width: 150px;" type="text" value="${invoiceInfo.bondTsiAmt}" class="money" /></td>
				<td class="rightAligned" style="width: 150px;">Total Tax Amount</td>
				<td class="leftAligned"><input id="bondTotalTaxAmt" type="text" style="width: 150px;" readonly="readonly"  value="${invoiceInfo.taxAmt}"  class="money" /></td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 150px;">Total Bond Rate</td>
				<td class="leftAligned"><input id="bondRateTotal" style="width: 150px;" type="text" value="${invoiceInfo.bondRate}" class="moneyRate" /></td>
				<td class="rightAligned" style="width: 150px;">Total Amount Due</td>
				<td class="leftAligned"><input id="bondTotalAmtDue" type="text" style="width: 150px;" value="${invoiceInfo.totalAmountDue}" readonly="readonly" class="money" /></td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 150px;">Annual TSI</td>
				<td class="leftAligned"><input id="annTsi" style="width: 150px;" type="text" value="" class="money" readonly="readonly" /></td>
				<td class="rightAligned" style="width: 150px;">Annual Prem Amt</td>
				<td class="leftAligned"><input id="annPremAmt" type="text" style="width: 150px;" value="" readonly="readonly" class="money" /></td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 150px;">Total Premium Amount</td>
				<td class="leftAligned"><input id="bondPremTotal" style="width: 150px;" type="text" value="${invoiceInfo.premAmt}" class="money" /></td>
				<td class="rightAligned" style="width: 150px;"><label style="float: right; display: none;" id="lblRiCommAmt">RI Comm Amount</label></td>
				<td class="leftAligned"><input id="bondRiCommAmt" type="text" style="width: 150px; display: none;" value="${invoiceInfo.riCommAmt}" class="money" lastValidValue=""/></td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 150px;"><label style="float: right; display: none;" id="lblRiCommRt">RI Comm Rate</label></td>
				<td class="leftAligned"><input id="bondRiCommRt" style="width: 150px; display: none;" type="text" value="${invoiceInfo.riCommRt}" class="moneyRate" lastValidValue=""/></td>
				<td class="rightAligned" style="width: 150px;"><label style="float: right; display: none;" id="lblRiCommVat">RI Comm VAT</label></td>
				<td class="leftAligned"><input id="bondRiCommVat" type="text" style="width: 150px; display: none;" value="${invoiceInfo.riCommVat}" readonly="readonly" class="money" lastValidValue=""/></td>
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
		<jsp:include page="subPages/endtEnterBondBillTakeUpListing.jsp"></jsp:include>
	</div>	
	<div id="invoiceInformationFooterHeader" style="margin: 10px;" changeTagAttr="true">
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
				<td class="leftAligned"><input id="takeupBondAmtDue" type="text" style="width: 150px;" value="" readonly="readonly" class="money" lastValidValue=""/></td>
			</tr>
			<tr>
				<td class="rightAligned">Due Date</td>
				<td class="leftAligned">
				  	<div style="float:left; border: solid 1px gray; width: 69%; height: 21px; margin-right:3px;" class="required">
				      <input type="text" style="border: none; width: 83%" id="takeupBondDueDate" name="takeupBondDueDate" value="" class="required" lastValidValue=""/>
				      <img id="hrefDueDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Due Date" />
				    </div>
		 		</td>
		 		<td class="rightAligned">
		 			<label style="float: right; display: none;" id="lblTakeupRiCommRt">RI Comm. Rt.</label>
		 		</td>
		 		<td class="leftAligned">
		 			<input id="takeupRiCommRt" type="text" style="width: 150px; display: none;" value="" class="moneyRate" lastValidValue=""/>
		 		</td>
			</tr>
			<tr>
				<td class="rightAligned">Reference Invoice No.</td>
				<td class="leftAligned"><input id="takeupBondrefInvNo" style="width: 150px;" type="text" value="" maxlength="30"/></td>
				<td class="rightAligned">
		 			<label style="float: right; display: none;" id="lblTakeupRiCommAmt">RI Comm. Amount</label>
		 		</td>
		 		<td class="leftAligned">
		 			<input id="takeupRiCommAmt" type="text" style="width: 150px; display: none;" value="" class="money" lastValidValue=""/>
		 		</td>
			</tr>
			<tr>
				<td></td>
				<td></td>
				<td class="rightAligned">
		 			<label style="float: right; display: none;" id="lblTakeupRiCommVat">RI Comm. VAT</label>
		 		</td>
		 		<td class="leftAligned">
		 			<input id="takeupRiCommVat" type="text" style="width: 150px; display: none;" value="" class="money" lastValidValue=""/>
		 		</td>
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
	
<div id="outerDiv" name="outerDiv">
  <div id="innerDiv" name="innerDiv">
     <label>Tax Information</label> 
      <span class="refreshers" style="margin-top: 0;"> 
       <label id="testRecStat" name="gro" style="margin-left: 5px;">Hide</label> 
      </span>
  </div>
</div>
	
<div class="sectionDiv" id="taxInformationDiv" changeTagAttr="true">
	<div style="width: 100%;" id="taxInformationList" class="tableContainer" style="margin-top: 10px;">
		<jsp:include page="subPages/endtEnterBondBillTaxInformationListing.jsp"></jsp:include>
	</div>
	<div id="taxInformationHeader" style="margin: 10px;"">
		<table width="50%" align="center" cellspacing="1" border="0">
			<tr>
				<td class="rightAligned" style="width: 150px;">Tax Description</td>
				<td colspan="3" class="leftAligned">
					<select id="bondTaxDesc" name="bondTaxDesc" style="width: 188px; padding-top: 2px;" class="">
							<option value="" taxCd="">Select..</option>
					</select>
					<input id="txtBondTaxDesc" name="txtBondTaxDesc" type="text" style="display: none; width: 180px; padding-top: 2px;">
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 150px;">Tax Amount</td>
				<td colspan="3" class="leftAligned"><input id="bondTaxAmount" style="width: 180px;" type="text" value="" class="money" maxlength="16"/></td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 150px; display: none;">Tax Allocation</td>
				<td colspan="3" class="leftAligned">
					<select id="bondTaxAlloc" name="bondTaxAlloc" style="width: 188px; padding-top: 2px; display: none;" class="">
								<option value="F">FIRST</option>
								<option value="S">SPREAD</option>
								<option value="L">LAST</option>
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
	setModuleId("GIPIS165B");
	setDocumentTitle("Enter Bond Bill");	
	
	var currRecordIndex = 0;
	var listSize = 0;
	var objArray = JSON.parse('${gipiWInvoiceJSON}'.replace(/\\/g, '\\\\'));
	var objTaxDtlsArray = eval('${bondTaxChargesListingJSON}');
	var objPayTerms = eval('${payTermsJSON}');
	var objBookingDateArray = eval('${bookingDateJSON}');
	var takeupTerm = '${takeupTerm}';
	var annualPremAmt = '${annualValues.annPremAmt}';
	var annualTsi = '${annualValues.annTsi}';
	var updateBooking = ('${updateBooking}');
	var createInvoiceTag = 0;
	var binderExist = "N";
	var vatTag = '${vatTag}';
	var bondAutoPrem = '${bondAutoPrem}'; //added by robert GENQA SR 4828 08.27.15
	var premAmtChanged = "N"; //added by robert GENQA SR 4828 08.27.15
	var updateBondAutoPrem = "N"; //added by robert GENQA SR 4828 08.27.15
	// jhing 12.07.2014 FULLWEBSIT SR0003749
	var selTaxCd = null; 
	var selTaxId = null;
	var prodTakeUp = '${prodTakeUp}';
	var issueDate = Date.parse('${issueDate}');
	
	if(nvl(updateBooking, "Y") == "N"){
		$("bondBookingDate").disable(); // added by: Nica 05.25.2012 - Per Ms VJ, booking month LOV should be disabled if UPDATE_BOOKING is equal to N.
	}
	formatMoneyRateValues();
	showTakeupTermList(objArray);
	showTaxInformationList(objArray);
	populateTaxDtls(objTaxDtlsArray, 0);
	populatePayTermDtls(objPayTerms, 0);
	populateBookingDtls(objBookingDateArray, 0);
	setTaxAloccation();
	changeTag = 0;
	
	//belle 07.18.2012 as per Mam VJ booking mth is disabled if takeup term is ST and MT.
	if(takeupTerm == "ST" || takeupTerm == "MT" ){ // pansamantalang disable muna ung sa package ginagawa palang ung sa takeupterm
		$("bondBookingDate").disabled = true;
	}else{
		$("bondBookingDate").disabled = false;
	}  
	
	$("bondRateTotal").value = formatToNthDecimal($F("bondRateTotal"), 9);
	
	$("annPremAmt").value = formatCurrency(parseFloat(annualPremAmt) + unformatCurrency("bondPremTotal"));
	$("annTsi").value = formatCurrency(parseFloat(annualTsi) + unformatCurrency("bondTotalAmt"));
	
	$("editTakeupBondRemarks").observe("click", function () {
		//showEditor("takeupBondRemarks", 4000);
		showOverlayEditor("takeupBondRemarks", 4000, $("takeupBondRemarks").hasAttribute("readonly"), null);
	});
	//added by robert GENQA SR 4828 08.27.15
	function checkAutoBondPrem(){
		var check = true;
		if(premAmtChanged == "Y"){
			check = false;
			showConfirmBox("Confirmation", "User has altered the premium amount computed for extension of duration. Continue anyway?", "Yes", "No", function(){
				premAmtChanged = "N";
				updateBondAutoPrem = "Y";
				fireEvent($("createInvoiceBtn"), "click");
			}, "");	
		}
		return check;
	}
	//end robert GENQA SR 4828 08.27.15
	$("createInvoiceBtn").observe("click", function() {
		if(checkAutoBondPrem()){ //added by robert GENQA SR 4828 08.27.15
		new Ajax.Request(contextPath + "/GIPIWinvoiceController?action=getTempTakeupList", {
			method: "GET",
			parameters: {
				parId: $F("globalParId"),
				lineCd: objUWGlobal.lineCd,
				issCd: $F("bondIssCd"),
				bondTsiAmt: unformatCurrency("bondTotalAmt"),
				premAmt: unformatCurrency("bondPremTotal"),
				riCommRt: $F("bondRiCommRt").replace(/\s/g, ""), // parseFloat($F("bondRiCommRt")),
				bondRate: $F("bondRateTotal").replace(/\s/g, ""), //parseFloat($F("bondRateTotal")),
				riCommAmt: unformatCurrency("bondRiCommAmt")
			},
			evalScripts: true,
			asynchronous: true,
			onCreate: showNotice("Processing, please wait..."),
			onComplete: function (response) {
				hideNotice();
				var result = response.responseText;
				
				objArray = {}; //modified by robert 02.24.2014
				objArray = JSON.parse(response.responseText);
				refreshDivs();
				showTakeupTermList(objArray);
				showTaxInformationList(objArray);
				$("newWinvoiceFlag").value = 'Y';
				disableButton("createInvoiceBtn");
				deleteWDistTables(); // bonok :: 12.10.2013 :: delete record from distribution working tables upon clicking Create Invoice

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
								}	  	
							});			
						}	
					);
					saveFuncMain();
				}
		});
		} //added by robert GENQA SR 4828 08.27.15
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
	
	$("bondTotalAmt").observe("focus", function(){
		if(binderExist == "Y"){
			showMessageBox("PAR has posted binders. Modification of TSI and/or premium amount  is not allowed.", "E");
		}
	});
	$("bondTotalAmt").observe("change", function() {
		if(unformatCurrency("bondTotalAmt") < 0) {
			if((unformatCurrency("bondTotalAmt")+unformatCurrency("annTsi")) < 0) {
				showMessageBox("Entered bond amount will result to negative annual TSI.", imgMessage.ERROR);
				resetBondTotals();
				$("bondTotalAmt").value = formatCurrency(0);
				return;
			}
		}
		
		showConfirmBox("Message", "This will recompute premium and tax amounts. Do you want to continue?", "Ok", "Cancel", bondTotalAmtOk, bondTotalAmtCancel);	
	});
	
	function bondTotalAmtCancel(){
		$("bondTotalAmt").value = formatCurrency(0);
		$("bondRateTotal").value = formatToNthDecimal(0, 9);;
		$("annTsi").value = formatCurrency(0);;
		$("bondPremTotal").value = formatCurrency(0);;
		$("bondTotalTaxAmt").value = formatCurrency(0);;
		$("bondTotalAmtDue").value = formatCurrency(0);;
		$("annPremAmt").value = formatCurrency(0);;
	}
	
	function bondTotalAmtOk(){
		if ($F("bondTotalAmt") != null && !isNaN($F("bondTotalAmt").replace(/,/g, "")) && unformatCurrency("bondTotalAmt") != 0){
			$("bondTotalAmt").value = unformatCurrency("bondTotalAmt");
			if (validateInput("bondTotalAmt")) {
				resetBondTotals();
				new Ajax.Request(contextPath + "/GIPIWinvoiceController?action=getFixedFlag", {
					method: "GET",
					parameters: {
						parId: $F("globalParId"),
						premAmt: unformatCurrency("bondPremTotal"),
						bondRate:  ($F("bondRateTotal").replace(/\s/g,"") == "" ? 0 : parseFloat(($F("bondRateTotal").replace(/\s/g,"")))), //adpascual - 03.06.2012 - replaced and commented this line -> //,$F("bondRateTotal") parseFloat(nvl($F("bondRateTotal"),"0"))
						bondAmt: unformatCurrency("bondTotalAmt"),
						issCd: objGIPIWPolbas.issCd,
						issueYy: objGIPIWPolbas.issueYy,
						polSeqNo: objGIPIWPolbas.polSeqNo,
						renewNo: objGIPIWPolbas.renewNo
					},
					evalScripts: true,
					asynchronous: false,
					onComplete: function (response){
						var result = response.responseText.toQueryParams();
						$("bondPremTotal").value = formatCurrency(result.premAmt);
						if(formatCurrency(parseFloat(annualPremAmt) + parseFloat(result.premAmt)) < 0) {
							showMessageBox("Entered bond amount will result to negative annual Premium Amount.", imgMessage.ERROR);
							resetBondTotals();
							$("bondTotalAmt").value = formatCurrency(0);
							return;
						}
						$("bondRateTotal").value = formatToNthDecimal(result.bondRate, 9);
						$("bondTotalAmt").value = formatCurrency($F("bondTotalAmt"));
						$("annPremAmt").value = formatCurrency(parseFloat(annualPremAmt) + parseFloat(result.annPremAmt)); //unformatCurrency("bondPremTotal")); replaced by robert GENQA SR 4825 08.19.15
						$("annTsi").value = formatCurrency(parseFloat(annualTsi) + unformatCurrency("bondTotalAmt"));
						if ((result.message != null || result.message != "") && result.message.length > 1) {
							showMessageBox(result.message);
						}
						if(bondAutoPrem == "Y"){ premAmtChanged = "Y"; } //added by robert GENQA SR 4828 08.27.15
					}
				});
				
				if ($F("bondIssCd") == $F("issCdRI") || $F("bondIssCd") == 'RB'){
					$("bondRiCommAmt").value = formatCurrency(parseFloat($F("bondRiCommRt")) * (unformatCurrency("bondPremTotal")/100));
					$("bondTotalAmtDue").value = formatCurrency(unformatCurrency("bondPremTotal") + unformatCurrency("bondTotalTaxAmt") - unformatCurrency("bondRiCommAmt") - unformatCurrency("bondRiCommVat"));
				}else{
					$("bondTotalAmtDue").value = formatCurrency(unformatCurrency("bondPremTotal") + unformatCurrency("bondTotalTaxAmt"));
				}
		
				$("bondRiCommVat").value = formatCurrency(unformatCurrency("bondRiCommAmt") * parseFloat($F("bondInputVatRate") == "" ? 0 : $F("bondInputVatRate")) / 100);
				enableButton("createInvoiceBtn");
				createInvoiceTag = 1;
			}else{
				customShowMessageBox("Field must be of form 9,999,999,990.99.", imgMessage.INFO, "bondTotalAmt");
			}
		}else{
			showMessageBox("Please input total bond amount.");
			resetBondTotals();
			$("bondTotalAmt").value = formatCurrency(0);
		}
	}
	
	$("bondPremTotal").observe("focus", function(){
		if(binderExist == "Y"){
			showMessageBox("PAR has posted binders. Modification of TSI and/or premium amount  is not allowed.", "E");
		}
	});
	$("bondPremTotal").observe("change", function() {
		/* adpascual
		 * 02.29.2012 
		 * modified condition from unformatCurrency("bondPremTotal") > 0
		   to unformatCurrency("bondPremTotal") != 0
		   total prem. amount should allow negative values the same w/ c/s version
		 */
		//if ($F("bondPremTotal") != null && !isNaN($F("bondPremTotal").replace(/,/g, "")) && unformatCurrency("bondPremTotal") != 0){  
		if ($F("bondPremTotal") != null && !isNaN($F("bondPremTotal").replace(/,/g, ""))){ // bonok :: 10.22.2012 :: as per mam jhing, 0 value should be allowed
			$("bondPremTotal").value = unformatCurrency("bondPremTotal");
			if (validateInput("bondPremTotal")) {
				enableButton("createInvoiceBtn");
				createInvoiceTag = 1;
				if(unformatCurrency("bondTotalAmt") == 0){
					$("bondRateTotal").value = formatToNthDecimal(0, 9);
				} /*else*/ //commented by d.alcantara, 03-29-2012, for sr9110
				
				if((parseFloat(annualPremAmt) + unformatCurrency("bondPremTotal")) < 0) {
					showMessageBox("Entered bond amount will result to negative annual Premium Amount.", imgMessage.ERROR);
					$("bondPremTotal").value = formatCurrency(0);
					$("bondRateTotal").value = formatToNthDecimal(0, 9);
					return;
				}
				
				if((parseFloat(annualTsi) + unformatCurrency("bondTotalAmt")) < 0) {
					showMessageBox("Entered bond amount will result to negative annual TSI.", imgMessage.ERROR);
					$("bondPremTotal").value = formatCurrency(0);
					$("bondRateTotal").value = formatToNthDecimal(0, 9);
					return;
				}
				
				if ($F("bondIssCd") == $F("issCdRI") || $F("bondIssCd") == 'RB'){
					$("bondRiCommAmt").value = formatCurrency(parseFloat($F("bondRiCommRt")) * (unformatCurrency("bondPremTotal")/100));
					$("bondTotalAmtDue").value = formatCurrency(unformatCurrency("bondPremTotal") + unformatCurrency("bondTotalTaxAmt") - unformatCurrency("bondRiCommAmt") - unformatCurrency("bondRiCommVat"));
				}else{
					$("bondTotalAmtDue").value = formatCurrency(unformatCurrency("bondPremTotal") + unformatCurrency("bondTotalTaxAmt"));
				}
		
			  	if (unformatCurrency("bondTotalAmt") != 0){
				  	$("bondRateTotal").value = formatToNthDecimal(100 * unformatCurrency("bondPremTotal") / unformatCurrency("bondTotalAmt"), 9);
			  	}
	
			  	$("annPremAmt").value = formatCurrency(parseFloat(annualPremAmt) + unformatCurrency("bondPremTotal"));
			  	$("annTsi").value = formatCurrency(parseFloat(annualTsi) + unformatCurrency("bondTotalAmt"));
				
				
				$("bondRiCommVat").value = formatCurrency(unformatCurrency("bondRiCommAmt") * parseFloat($F("bondInputVatRate") == "" ? 0 : $F("bondInputVatRate")) / 100);
				
				/* adpascual
				 * 03.01.2012 
				 * added the Math.abs function to compare premium to total amount in its absolute value
				   applicable if both values are negative
				 */
				if (unformatCurrency("bondTotalAmt") != 0 && (Math.abs(unformatCurrency("bondPremTotal")) > Math.abs(unformatCurrency("bondTotalAmt")))){
					showMessageBox("Premium amount cannot be higher than bond amount", imgMessage.INFO);
					$("bondPremTotal").value = formatCurrency(0);
					$("bondRateTotal").value = formatToNthDecimal(0, 9);
				}
			}else {
				customShowMessageBox("Field must be of form 9,999,999,990.99.", imgMessage.INFO, "bondPremTotal");
			}
		}else {
			showMessageBox("Please input total premium amount.");
			$("bondPremTotal").value = formatCurrency(0);
			$("bondRateTotal").value = formatToNthDecimal(0, 9);
		}	
	
		$("bondPremTotal").value = formatCurrency($F("bondPremTotal"));
	});
	
	$("bondRateTotal").observe("focus", function(){
		if(binderExist == "Y"){
			showMessageBox("PAR has posted binders. Modification of TSI and/or premium amount  is not allowed.", "E");
		}
	});
	$("bondRateTotal").observe("change", function () {
		if (parseFloat($F("bondRateTotal")) <= 100 && parseFloat($F("bondRateTotal")) >= 0) {
			/* replaced by robert GENQA SR 4825 08.03.15
			 $("bondPremTotal").value = formatCurrency(unformatCurrency("bondTotalAmt") * (parseFloat($F("bondRateTotal") / 100)));
			 $("bondRateTotal").value = formatToNthDecimal($F("bondRateTotal"), 9);
			 $("bondTotalAmtDue").value = formatCurrency(unformatCurrency("bondPremTotal") + unformatCurrency("bondTotalTaxAmt") - unformatCurrency("bondRiCommAmt") - unformatCurrency("bondRiCommVat"));
			 $("annPremAmt").value = formatCurrency(parseFloat(annualPremAmt) + unformatCurrency("bondPremTotal"));
			 $("annTsi").value = formatCurrency(parseFloat(annualTsi) + unformatCurrency("bondTotalAmt")); */
 			new Ajax.Request(contextPath + "/GIPIWinvoiceController?action=getFixedFlag", {
				method: "GET",
				parameters: {
					parId: $F("globalParId"),
					premAmt: unformatCurrency("bondPremTotal"),
					bondRate:  ($F("bondRateTotal").replace(/\s/g,"") == "" ? 0 : parseFloat(($F("bondRateTotal").replace(/\s/g,"")))), 
					bondAmt: unformatCurrency("bondTotalAmt"),
					issCd: objGIPIWPolbas.issCd,
					issueYy: objGIPIWPolbas.issueYy,
					polSeqNo: objGIPIWPolbas.polSeqNo,
					renewNo: objGIPIWPolbas.renewNo
				},
				evalScripts: true,
				asynchronous: false,
				onComplete: function (response){
					var result = response.responseText.toQueryParams();
					$("bondPremTotal").value = formatCurrency(result.premAmt);
					$("bondRateTotal").value = formatToNthDecimal(result.bondRate, 9);
					$("annPremAmt").value = formatCurrency(parseFloat(annualPremAmt) + parseFloat(result.annPremAmt));
					$("annTsi").value = formatCurrency(parseFloat(annualTsi) + unformatCurrency("bondTotalAmt"));
					$("bondTotalAmtDue").value = formatCurrency(unformatCurrency("bondPremTotal") + unformatCurrency("bondTotalTaxAmt") - unformatCurrency("bondRiCommAmt") - unformatCurrency("bondRiCommVat"));
				}
			});
			 //end robert GENQA SR 4825 08.03.15
			enableButton("createInvoiceBtn");
			createInvoiceTag = 1;
		} else {
			showMessageBox("Must be in the range 0.000000000 to 100.000000000.");
		}
	});
	
	//marco - added lines below - 11.07.2013
	initializeAllMoneyFields();
	
	function checkDateGIPIS165B(dateField){ //copied from common.js
		var inputDate = $(dateField);
		var reLong = /\b\d{1,2}[\/-]\d{1,2}[\/-]\d{4}\b/;
		
		if (reLong.test(inputDate.value)){
			var delimChar = (inputDate.value.indexOf("/") != -1) ? "/" : "-";
			var monthfield=inputDate.value.split(delimChar)[0];
			var dayfield=inputDate.value.split(delimChar)[1];
			var yearfield=inputDate.value.split(delimChar)[2];
			
			var testDate = new Date(yearfield, monthfield-1, dayfield);
				if (testDate.getDate() == dayfield) {
		        	if (testDate.getMonth() + 1 == monthfield) {
						if (testDate.getFullYear() == yearfield) {
			                inputDate.value = monthfield + "-" + dayfield + "-" + yearfield;
			                return true;
			            } else {
			            	showWaitingMessageBox("Invalid year.", imgMessage.INFO, function(){
			            		$("takeupBondDueDate").value = $("takeupBondDueDate").getAttribute("lastValidValue");
			            	});
			            }
			        } else {
			        	showWaitingMessageBox("Month must be between 1 and 12.", imgMessage.INFO, function(){
		            		$("takeupBondDueDate").value = $("takeupBondDueDate").getAttribute("lastValidValue");
		            	});
			        }
			    } else {
			    	showWaitingMessageBox("Day must be between 1 and last of month.", imgMessage.INFO, function(){
	            		$("takeupBondDueDate").value = $("takeupBondDueDate").getAttribute("lastValidValue");
	            	});
			    }
		}else{
			showWaitingMessageBox("Date must be entered in a format like MM-DD-RRRR", imgMessage.INFO, function(){
        		$("takeupBondDueDate").value = $("takeupBondDueDate").getAttribute("lastValidValue");
        	});
			return false;
		}
	}
	
	function setLastValidValues(){
		$("bondRiCommAmt").setAttribute("lastValidValue", $F("bondRiCommAmt"));
		$("bondRiCommRt").setAttribute("lastValidValue", $F("bondRiCommRt"));
		$("bondTotalAmtDue").setAttribute("lastValidValue", $F("bondTotalAmtDue"));
		$("bondRiCommVat").setAttribute("lastValidValue", $F("bondRiCommVat"));
	}
	
	function setTakeupLastValidValues(){
		$("takeupRiCommAmt").setAttribute("lastValidValue", $F("takeupRiCommAmt"));
		$("takeupRiCommRt").setAttribute("lastValidValue", $F("takeupRiCommRt"));
		$("takeupBondAmtDue").setAttribute("lastValidValue", $F("takeupBondAmtDue"));
		$("takeupRiCommVat").setAttribute("lastValidValue", $F("takeupRiCommVat"));
	}
	
	function computeRiComm(field){
		var bondPremTotal = parseFloat(unformatCurrencyValue($F("bondPremTotal")));
		var bondRiCommRt = parseFloat($F("bondRiCommRt"));
		var bondInputVatRate = parseFloat($F("bondInputVatRate"));
		var bondTotalTaxAmt = parseFloat(unformatCurrencyValue($F("bondTotalTaxAmt")));

		if(field == "bondRiCommRt"){
			$("bondRiCommAmt").value = formatCurrency(bondPremTotal * (bondRiCommRt / 100));
		}else if(field == "bondRiCommAmt"){
			$("bondRiCommRt").value = Math.abs(formatToNthDecimal((parseFloat(unformatCurrencyValue($F("bondRiCommAmt"))) / bondPremTotal) * 100, 9)); //edgar 10/03/2014 : added Math.abs() to get the absolute value.
		}else if(field == "bondRiCommVat"){
			$("bondTotalAmtDue").value = formatCurrency(bondPremTotal + bondTotalTaxAmt - parseFloat(unformatCurrencyValue($F("bondRiCommAmt"))) - parseFloat(unformatCurrencyValue($F("bondRiCommVat"))));
			return;
		}
		$("bondRiCommVat").value = formatCurrency(parseFloat(unformatCurrencyValue($F("bondRiCommAmt"))) * (bondInputVatRate / 100));
		$("bondTotalAmtDue").value = formatCurrency(bondPremTotal + bondTotalTaxAmt - parseFloat(unformatCurrencyValue($F("bondRiCommAmt"))) - parseFloat(unformatCurrencyValue($F("bondRiCommVat"))));
		
		if(parseFloat(unformatCurrencyValue($F("bondTotalAmtDue"))) < 0 && (bondPremTotal > 0)){ //edgar 10/03/2014 added condition for positive Prem
			showWaitingMessageBox("Resulting Total Amount Due should not be negative.", "E", function(){
				$("bondRiCommAmt").value = $("bondRiCommAmt").getAttribute("lastValidValue");
				$("bondRiCommRt").value = $("bondRiCommRt").getAttribute("lastValidValue");
				$("bondTotalAmtDue").value = $("bondTotalAmtDue").getAttribute("lastValidValue");
				$("bondRiCommVat").value = $("bondRiCommVat").getAttribute("lastValidValue");
			});
		}
	}
	
	function computeTakeupRiComm(field){
		var takeupPremAmt = parseFloat(unformatCurrencyValue($F("takeupPremAmt")));
		var takeupRiCommRt = parseFloat($F("takeupRiCommRt"));
		var bondInputVatRate = parseFloat($F("bondInputVatRate"));
		var takeupTaxTotal = parseFloat(unformatCurrencyValue($F("takeupTaxTotal")));
		
		if(field == "takeupRiCommRt"){
			$("takeupRiCommAmt").value = formatCurrency(takeupPremAmt * (takeupRiCommRt / 100));
		}else if(field == "takeupRiCommAmt"){
			$("takeupRiCommRt").value = formatToNthDecimal((parseFloat(unformatCurrencyValue($F("takeupRiCommAmt"))) / takeupPremAmt) * 100, 9);
		}else if(field == "takeupRiCommVat"){
			$("takeupBondAmtDue").value = formatCurrency(takeupPremAmt + takeupTaxTotal - parseFloat(unformatCurrencyValue($F("takeupRiCommAmt"))) - parseFloat(unformatCurrencyValue($F("takeupRiCommVat"))));
			return;
		}
		$("takeupRiCommVat").value = formatCurrency(parseFloat(unformatCurrencyValue($F("takeupRiCommAmt"))) * (bondInputVatRate / 100));
		$("takeupBondAmtDue").value = formatCurrency(takeupPremAmt + takeupTaxTotal - parseFloat(unformatCurrencyValue($F("takeupRiCommAmt"))) - parseFloat(unformatCurrencyValue($F("takeupRiCommVat"))));
		
		
		if(parseFloat(unformatCurrencyValue($F("takeupBondAmtDue"))) < 0){
			showWaitingMessageBox("Resulting Total Amount Due should not be negative.", "E", function(){
				$("takeupRiCommAmt").value = $("takeupRiCommAmt").getAttribute("lastValidValue");
				$("takeupRiCommRt").value = $("takeupRiCommRt").getAttribute("lastValidValue");
				$("takeupBondAmtDue").value = $("takeupBondAmtDue").getAttribute("lastValidValue");
				$("takeupRiCommVat").value = $("takeupRiCommVat").getAttribute("lastValidValue");
			});
		}
	}
	
	function checkDueDate(){
		var takeupDueDates = [];
		$$("div#takeupTableContainer div[name='takeUpRow']").each(function(row){
			if(row.hasClassName("selectedRow")){
				takeupDueDates.push($F("takeupBondDueDate"));
			}else{
				takeupDueDates.push(row.down("label", 2).innerHTML);
			}
		});
		
		for(var i = 0; i < takeupDueDates.length; i++){
			if(i+1 < takeupDueDates.length){
				if(ignoreDateTime(Date.parse(takeupDueDates[i])) > ignoreDateTime(Date.parse(takeupDueDates[i+1]))){
					$("takeupBondDueDate").value = $("takeupBondDueDate").getAttribute("lastValidValue");
					showMessageBox("Due date schedule must be in proper sequence", "E");
					return;
				}
			}
		}
		
		/* apollo cruz 10.09.2015 GENQA 4967 */
		var dueDate = Date.parse($F("takeupBondDueDate"));
		var effDate = Date.parse(nvl($F("globalEffDate"), objUWParList.effDate));
		var prodTakeUpDate = issueDate;
		var strDate = "issue date";
		
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
			customShowMessageBox("Due date schedule must not be earlier than the " + strDate + " of the policy.", "I", "takeupBondDueDate");
			$("takeupBondDueDate").value = $("takeupBondDueDate").getAttribute("lastValidValue");
			$("takeupBondDueDate").focus();
		} else if(compareDatesIgnoreTime(dueDate, Date.parse(nvl($F("globalExpiryDate"), objUWParList.expiryDate))) == -1/* && objUW.allowExpiredPolIssuance == "N"*/){
			customShowMessageBox("Due date schedule must not be later than the expiry date of the policy.", "I", "takeupBondDueDate");
			$("takeupBondDueDate").value = $("takeupBondDueDate").getAttribute("lastValidValue");
			$("takeupBondDueDate").focus();
		} else {
			$("takeupBondDueDate").setAttribute("lastValidValue", $F("takeupBondDueDate"));
		}
		
		/* if(ignoreDateTime(Date.parse($F("takeupBondDueDate"))) < ignoreDateTime(Date.parse(nvl($F("globalEffDate"), objUWParList.effDate)))){
			$("takeupBondDueDate").value = $("takeupBondDueDate").getAttribute("lastValidValue");
			showMessageBox("Due date schedule must not be earlier than the inception date of the policy.", "E");
		}else if(ignoreDateTime(Date.parse($F("takeupBondDueDate"))) > ignoreDateTime(Date.parse(nvl($F("globalExpiryDate"), objUWParList.expiryDate)))){
			$("takeupBondDueDate").value = $("takeupBondDueDate").getAttribute("lastValidValue");
			showMessageBox("Due date schedule must not be later  than the expiry date of the policy.", "E");
		}else{
			$("takeupBondDueDate").setAttribute("lastValidValue", $F("takeupBondDueDate"));
		} */
	}
	
	$("hrefDueDate").observe("click", function(){
		$("takeupBondDueDate").setAttribute("lastValidValue", $F("takeupBondDueDate"));
		scwNextAction = checkDueDate.runsAfterSCW(this, null);
		scwShow($('takeupBondDueDate'),this, null);
	});
	
	$("takeupBondDueDate").observe("focus", function(){
		$("takeupBondDueDate").setAttribute("lastValidValue", $F("takeupBondDueDate"));
	});
	
	$("takeupBondDueDate").observe("change", function(){
		if($F("takeupBondDueDate") != "" && checkDateGIPIS165B("takeupBondDueDate")){
			checkDueDate();
			$("takeupBondDueDate").value = dateFormat($F("takeupBondDueDate"), 'mm-dd-yyyy');
		}
	});
	
	$w("bondRiCommRt bondRiCommAmt bondRiCommVat").each(function(e){
		$(e).observe("focus", setLastValidValues);
	});
	
	$w("takeupRiCommRt takeupRiCommAmt takeupRiCommVat").each(function(e){
		$(e).observe("focus", setTakeupLastValidValues);
	});
	
	$("bondRiCommRt").observe("change", function(){
		//if(nvl($F("bondRiCommRt"), "") != "" && (parseFloat($F("bondRiCommRt")) <= 0 || parseFloat($F("bondRiCommRt")) > 100)){//commented out edgar 10/03/2014
		var prevBondRICommRt = $("bondRiCommRt").getAttribute("lastValidValue");//edgar 10/03/2014
		if(nvl($F("bondRiCommRt"), "") != "" && (parseFloat($F("bondRiCommRt")) < 0 || parseFloat($F("bondRiCommRt")) > 100)){//edgar 10/03/2014 allows zero ri_comm_rate
			showWaitingMessageBox("Invalid RI Comm. Rt. Valid value should be from 0.000000000 to 100.000000000.", "E", function(){//edgar 10/03/2014 changed from 0.000000001 to 0.000000000 
				$("bondRiCommRt").value = /*$("bondRiCommRt").getAttribute("lastValidValue")*/prevBondRICommRt;//edgar 10/03/2014
				$("bondRiCommRt").focus();
			});
			return;
		}else if($F("bondRiCommRt") == ""){
			$("bondRiCommRt").value = "0";
		}
		computeRiComm("bondRiCommRt");
		enableButton("createInvoiceBtn");//edgar 10/03/2014
		createInvoiceTag = 1;//edgar 10/03/2014
	});
	
	$("bondRiCommAmt").observe("change", function(){
		//if($F("bondRiCommAmt") == ""){
		//	$("bondRiCommAmt").value = "0.00";
		//} //commented out edgar 10/03/2014
		//added validation on ri_comm_amt edgar 10/03/2014 Prem amount and ri comm amount should have same sign
		var prevBondRICommAmt = $("bondRiCommAmt").getAttribute("lastValidValue");
		if ((nvl($F("bondRiCommAmt"), "") != "" && parseFloat($F("bondRiCommAmt")) < 0 && parseFloat(unformatCurrencyValue($F("bondPremTotal"))) > 0)||
		    (nvl($F("bondRiCommAmt"), "") != "" && parseFloat($F("bondRiCommAmt")) > 0 && parseFloat(unformatCurrencyValue($F("bondPremTotal"))) < 0)){
			showWaitingMessageBox("Entered Comm. Amount will result to invalid RI Rate.", "E", function(){
				$("bondRiCommAmt").value = prevBondRICommAmt;
				$("bondRiCommAmt").focus();
			});
			return;
		}else if($F("bondRiCommAmt") == ""){
			$("bondRiCommAmt").value = "0.00";
		}else if (unformatCurrency("bondRiCommAmt") > unformatCurrency("bondPremTotal")){//added edgar 01/27/2015
			$("bondRiCommAmt").value = formatCurrency(parseFloat($F("bondRiCommRt")*(unformatCurrency("bondPremTotal")/100)));
			showMessageBox("RI Comm Amt must not be greater than Total Premium Amount.", imgMessage.INFO);
			return;
		}
		//ended edgar 10/03/2014
		computeRiComm("bondRiCommAmt");
		enableButton("createInvoiceBtn");//edgar 10/03/2014
		createInvoiceTag = 1;//edgar 10/03/2014
	});
	
	$("bondRiCommVat").observe("change", function(){
		if($F("bondRiCommVat") == ""){
			$("bondRiCommAmt").value = "0.00";
		}
		computeRiComm("bondRiCommVat");
	});
	
	$("takeupRiCommRt").observe("change", function(){
		if(nvl($F("takeupRiCommRt"), "") != "" && (parseFloat($F("takeupRiCommRt")) <= 0 || parseFloat($F("takeupRiCommRt")) > 100) ||
			isNaN($F("takeupRiCommRt"))){
			showWaitingMessageBox("Invalid RI Comm. Rt. Valid value should be from 0.000000001 to 100.000000000.", "E", function(){
				$("takeupRiCommRt").value = $("takeupRiCommRt").getAttribute("lastValidValue");
				$("takeupRiCommRt").focus();
			});
			return;
		}else if($F("takeupRiCommRt") == ""){
			$("takeupRiCommRt").value = "0";
			$("takeupRiCommRt").setAttribute("lastValidValue", "0.000000000");
		}
		computeTakeupRiComm("takeupRiCommRt");
	});
	
	$("takeupRiCommAmt").observe("change", function(){
		if (unformatCurrency("takeupRiCommAmt") > unformatCurrency("takeupPremAmt")){//edgar 01/27/2015
			$("takeupRiCommAmt").value = formatCurrency(parseFloat($F("takeupRiCommRt")*(unformatCurrency("takeupPremAmt")/100)));
			showMessageBox("RI Comm Amt must not be greater than Total Premium Amount.", imgMessage.INFO);
			return;
		}
		if(nvl($F("takeupRiCommAmt"), "") != "" && (parseFloat($F("takeupRiCommAmt")) < 0 || parseFloat($F("takeupRiCommAmt")) > 999999999999.99) ||
			parseFloat($F("takeupRiCommAmt")) >	parseFloat($F("takeupPremAmt")) ||
			isNaN($F("takeupRiCommAmt"))){
			showWaitingMessageBox("Invalid RI Comm Amount. Valid value is from 0.00 to 999,999,999,999.99 and must not be greater than Total Premium Amount.", "E", function(){
				$("takeupRiCommAmt").value = $("takeupRiCommAmt").getAttribute("lastValidValue");
				$("takeupRiCommAmt").focus();
			});
			return;
		}else if($F("takeupRiCommAmt") == ""){
			$("takeupRiCommAmt").value = "0.00";
			$("takeupRiCommAmt").setAttribute("lastValidValue", "0.00");
		}
		computeTakeupRiComm("takeupRiCommAmt");
	});
	
	$("takeupRiCommVat").observe("change", function(){
		if(nvl($F("takeupRiCommVat"), "") != "" && (parseFloat($F("takeupRiCommVat")) < 0 || parseFloat($F("takeupRiCommVat")) > 9999999999.99) ||
			parseFloat($F("takeupRiCommVat")) >	parseFloat($F("takeupPremAmt")) ||
			parseFloat($F("takeupRiCommVat")) >	parseFloat($F("takeupRiCommAmt")) ||
			isNaN($F("takeupRiCommVat"))){
			showWaitingMessageBox("Invalid RI Comm VAT Valid value is from 0.00 to 9,999,999,999.99 and must not be greater than Total Premium Amount and RI Comm Amt.", "E", function(){
				$("takeupRiCommVat").value = $("takeupRiCommVat").getAttribute("lastValidValue");
				$("takeupRiCommVat").focus();
			});
			return;
		}else if($F("takeupRiCommVat") == ""){
			$("takeupRiCommVat").value = "0.00";
			$("takeupRiCommVat").setAttribute("lastValidValue", "0.00");
		}
		computeTakeupRiComm("takeupRiCommVat");
	});
	//end - 11.07.2013
	
	function validateInput(paramField){
		var isValid = true;
		var decimalLength = getDecimalLength($F(paramField));
		var locCurrAmtLength = unformatCurrency(paramField).toString().length - (decimalLength + 1);//(Math.round((unformatCurrency(paramField))*100)/100).toString().length;
		if (decimalLength > 2) {
			isValid = false;
			return isValid;
		}
		if (locCurrAmtLength > 10 || isNaN($F(paramField)) || $F(paramField) == "" ){ //|| unformatCurrency(paramField) < 0
			isValid = false;
		}
	
		return isValid;
	}
	
	function resetBondTotals(){
		$("bondRateTotal").value = formatToNthDecimal(0, 9);
		$("bondPremTotal").value = formatCurrency(0);
		$("bondTotalTaxAmt").value = formatCurrency(0);
		$("bondTotalAmtDue").value = formatCurrency(0);
		$("bondRiCommRt").value = formatToNthDecimal(0, 9);
		$("bondRiCommVat").value = formatCurrency(0);
		//$("bondTotalAmt").value = formatCurrency(0);
	}
	
	$("btnBondSave").observe("click", function() {
		if(changeTag == 0){showMessageBox(objCommonMessage.NO_CHANGES ,imgMessage.INFO); return;}
		if(createInvoiceTag == 1){
			customShowMessageBox("Please press the Create Invoice/s button.", "I", "createInvoiceBtn");
			return false;
		}
		saveFuncMain();
	});
	
	function saveFuncMain(){
			if ($F("bondTotalAmt") != null && !isNaN($F("bondTotalAmt").replace(/,/g, "")) /*&& unformatCurrency("bondTotalAmt") != 0*/){  //d.alcantara, 04.26.2012, commented this code to allow saving of 0 bond total
				//belle 09012012 get booking MM and YY of takeupseqno = 1 used to update gipi_wpolbas
				$$("div#takeupTableContainer div[name='takeUpRow']").each(function(row){
			 		if (row.down("label", 0).innerHTML == 1){
						bookingDate = (row.down("label", 1).innerHTML).replace(/&nbsp;/g, "").split("-");
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
						bondTsiAmt: unformatCurrency("bondTotalAmt"),
						premAmt: unformatCurrency("bondPremTotal"),
						riCommRt: $F("bondRiCommRt").replace(/\s/g, ""), //parseFloat($F("bondRiCommRt")),
						bondRate: roundExpNumber($F("bondRateTotal"),9), //$F("bondRateTotal").replace(/\s/g, ""), // parseFloat($F("bondRateTotal")) replaced by robert GENQA SR 4825 08.19.15
						riCommAmt: unformatCurrency("bondRiCommAmt"),
						newInvoiceMarker: $F("newWinvoiceFlag"),
						payTerm: $F("takeupPayTerm") == "" ? "COD" : $F("takeupPayTerm"),
						taxAmt: unformatCurrency("bondTotalTaxAmt"),
						parType: "E",
						updateBondAutoPrem: updateBondAutoPrem, //added by robert GENQA SR 4828 08.27.15
						annTsiAmt: unformatCurrency("annTsi"),
						annPremAmt: unformatCurrency("annPremAmt"),
						bookingMm: bookingMm,
						bookingYy: bookingYy 
					},
					evalScripts: true,
					asynchronous: false,
					onCreate: showNotice("Saving, please wait..."),
					onComplete: function (response){
						hideNotice();
						showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
						$("newWinvoiceFlag").value = 'N';
						changeTag = 0;
						updateParParameters();
						createInvoiceTag = 0;
					}
				});
			} else {
				changeTag = 0;
				updateParParameters();
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
			//showMessageBox("prepareParameters: "+ e.message);
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
				if (objArray[i].taxCodes[j].recordStatus == 0){ //added nvl by robert 02.24.2014
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
	
	// jhing 12.05.2014 added for FULLWEBSIT SR0003749 for the computation of correct tax amount 12.05.2014 when selecting tax in LOV
	function getBondsCompTaxAmt() { 
		try {			 
			var result = null;
			
			new Ajax.Request(contextPath + "/GIPIWinvoiceController", {
				parameters : {action : "getBondsCompTaxAmt",
							  taxCd : selTaxCd,
							  taxId :  selTaxId,
							  parId :  $F("globalParId"),
							  itemGrp : 1 /* bonds has only one bill group */,
							  takeupSeqNo :  $F("bondTakeUpSeqNo")
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
			showErrorMessage("getBondsCompTaxAmt",e);
		}
	}	
	
	// jhing 12.09.2014 added new function for the validation of changes in tax amount. Created
	// function to handle checking in the backend for possible changes in setup esp. related to parameters.
	function validateBondsTaxEntry(){
		try {
			var origTaxAmtVal = parseFloat(unformatCurrencyValue($("bondTaxAmount").value ));		
			var isValid = false;
			new Ajax.Request(contextPath + "/GIPIWinvoiceController?action=validateBondsTaxEntry" , {
				method: "GET",
				parameters: {
					parId :  $F("globalParId"),
					itemGrp : 1 /* bonds has only one bill group */,
					takeupSeqNo : $F("bondTakeUpSeqNo"),
					taxAmt: origTaxAmtVal,
					origTaxAmt: origTaxAmtVal,  
					taxCd: selTaxCd,
					taxId: selTaxId
				},
				evalscripts: true,
				asynchronous: false,
				onComplete : function(response){
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						isValid = false;
						var result = response.responseText;
						if (result != "SUCCESS"){							
							showMessageBox(result, imgMessage.ERROR);
							
						}else {
							isValid = true;
						}
							
					}
				 }
			   });
			  return isValid;				

		} catch (e) {
			showErrorMessage("validateBondsTaxEntry",e);
		}
	}
	
	
	// jhing 12.07.2014 FULLWEBSIT SR0003749 added function for the validation of tax amount fired when pressing add or update
	function validateTaxAmtForAddUpdate(action){
		var isValid = false;
		var bondAmount =unformatCurrencyValue($("bondTaxAmount").value );	
		if (bondAmount != null || bondAmount != "" ){ 
			if (action == 'Add'){
				selTaxCd = $("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("listTaxCd");
				selTaxId = $("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("listTaxId");	
			}else {
				selTaxCd =$("hiddenTaxCd").value;
				selTaxId = $F("hiddenTaxId"); 
			}	
			isValid = validateBondsTaxEntry() ;			
		}else{
			isValid = false;	
			customShowMessageBox('Required field must be entered', imgMessage.ERROR, "bondTaxAmount");			
		}
		
		return isValid;
	}	
	
	$("btnBondAdd").observe("click", function () {
		var itemTable = $("taxInformationTableContainer");
		var newDiv = new Element("div");
		if($F("btnBondAdd") == "Add") {
			if (validateTaxEntries()){		
				if (validateTaxAmtForAddUpdate("Add")) {
					var taxCd = $("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("listTaxCd");
					var taxDesc = $("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].text;
					var taxAmt = $F("bondTaxAmount");
					var taxAlloc = $("bondTaxAlloc").options[$("bondTaxAlloc").selectedIndex].text;
					var taxId = $("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("listTaxId"); 
								
					newDiv.setAttribute("id", "rowTax"+ $("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("listTaxCd") + "" + $F("bondTakeUpSeqNo"));
					newDiv.setAttribute("taxCd", taxCd);
					newDiv.setAttribute("taxId", taxId); //
					newDiv.setAttribute("name", "taxInformationRow");
					newDiv.addClassName("tableRow");	
					
					var content = '<label style="width: 85px; text-align: center; margin-left: 25px;" name="lblTaxInfo" id="lblTaxInfoTaxCd'+$F("bondTakeUpSeqNo")+'">'+taxCd+'</label>'+
					  '<label style="width: 180px; text-align: left; margin-left: 40px;" name="lblTaxInfo" id="lblTaxInfoTaxDesc'+$F("bondTakeUpSeqNo")+'">'+(taxDesc == null ? "-" : taxDesc)+'</label>'+
					  '<label style="width: 120px; text-align: right; margin-left: 25px;" name="lblTaxInfo" id="lblTaxInfoTaxAmt'+$F("bondTakeUpSeqNo")+'">'+(taxAmt == null ? formatCurrency(0) : formatCurrency(taxAmt))+'</label>'+
					  '<label style="width: 50px; text-align: left; margin-left: 60px;" name="lblTaxInfo" id="lblTaxInfoTaxAlloc'+$F("bondTakeUpSeqNo")+'">'+(taxAlloc == null ? "-" : taxAlloc)+'</label>'+
					  '<input type="hidden" name="hiddenTaxInfoTaxCd" value="'+(taxCd == null ? "" : taxCd)+'" />' +
					  '<input type="hidden" name="hiddenTaxInfoTaxDesc" value="'+(taxDesc == null ? "" : taxDesc)+'" />'+
					  '<input type="hidden" name="hiddenTaxInfoTaxAmt" value="'+(taxAmt == null ? formatCurrency(0) : formatCurrency(taxAmt))+'" />'+
					  '<input type="hidden" name="hiddenTaxInfoTaxAlloc" value="'+(taxAlloc == null ? "" : taxAlloc)+'" />'+
					//  '<input type="hidden" name="hiddenTaxInfoTaxId" value="'+($("hiddenTaxId").value  == null ? "" : $("hiddenTaxId").value)+'" />';  	 // jhing 12.09.2014 replaced with:
					  '<input type="hidden" name="hiddenTaxInfoTaxId" value="'+ (taxId == null ? "" : taxId) +'" />';  // jhing 12.09.2014
					newDiv.update(content);
					itemTable.insert({bottom : newDiv}); 	
					divEvents(newDiv);
					
					recomputeTaxes("add");
					setGIPIWinvTax();		
					
					// jhing 12.09.2014 FULLWEBSIT SR0003749
					resetTaxInformation();
					checkTableIfEmpty("taxInformationRow", "enterBondBillTaxInformationListingTable");	 
				}
			}	
		} else {            
			if (validateTaxAmtForAddUpdate("Update")) {
				//Added by Apollo Cruz - 12.05.2014 - assured with zero vat must not be allowed to update VAT
				if(vatTag == 2 && $F("hiddenTaxCd") == '${evatParamValue}') {
					showMessageBox("This assured is zero VAT rated.", imgMessage.ERROR);
					return false;
				}
				
			    $$("div[name='taxInformationRow']").each(function (row)	{
						if (row.hasClassName("selectedRow"))	{
							markTaxRecordAsDeleted(row.down("input", 0).value);
							recomputeTaxes("delete");
							row.remove();	
							checkTableIfEmpty("taxInformationRow", "enterBondBillTaxInformationListingTable");						
						}
				});
					
				var taxAmt = $F("bondTaxAmount");
				var taxCd = $("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("listTaxCd");
				var taxAmt = $F("bondTaxAmount");
					
				newDiv.setAttribute("id", "rowTax"+ $("hiddenTaxCd").value + "" + $F("bondTakeUpSeqNo"));
				newDiv.setAttribute("taxCd", $("hiddenTaxCd").value);
				newDiv.setAttribute("name", "taxInformationRow");
				newDiv.addClassName("tableRow");	
					
				var allocDesc = "";
				if ($("hiddenTaxAlloc").value == "F") {
					allocDesc = "FIRST";
				}else if ($("hiddenTaxAlloc").value == "L") {
					allocDesc = "LAST";
				}else if ($("hiddenTaxAlloc").value == "S") {
						allocDesc = "SPREAD";
				}else {
						allocDesc = null;
				}
					
				var content = '<label style="width: 85px; text-align: center; margin-left: 25px;" name="lblTaxInfo" id="lblTaxInfoTaxCd'+$F("bondTakeUpSeqNo")+'">'+$("hiddenTaxCd").value+'</label>'+
					  '<label style="width: 180px; text-align: left; margin-left: 40px;" name="lblTaxInfo" id="lblTaxInfoTaxDesc'+$F("bondTakeUpSeqNo")+ $("hiddenTaxCd").value +'">'+($("hiddenTaxDesc").value == null ? "-" : $("hiddenTaxDesc").value)+'</label>'+
					  '<label style="width: 120px; text-align: right; margin-left: 25px;" name="lblTaxInfo" id="lblTaxInfoTaxAmt'+$F("bondTakeUpSeqNo")+ $("hiddenTaxCd").value +'">'+(taxAmt == null ? formatCurrency(0) : formatCurrency(taxAmt))+'</label>'+
					  '<label style="width: 50px; text-align: left; margin-left: 60px;" name="lblTaxInfo" id="lblTaxInfoTaxAlloc'+$F("bondTakeUpSeqNo")+ $("hiddenTaxCd").value +'">'+(allocDesc == null ? "-" : allocDesc) +'</label>'+
					  '<input type="hidden" name="hiddenTaxInfoTaxCd" value="'+($("hiddenTaxCd").value == null ? "" : $("hiddenTaxCd").value)+'" />' +
					  '<input 	type="hidden" name="hiddenTaxInfoTaxDesc" value="'+($("hiddenTaxDesc").value == null ? "" : $("hiddenTaxDesc").value)+'" />'+
					  '<input type="hidden" name="hiddenTaxInfoTaxAmt" value="'+(taxAmt == null ? formatCurrency(0) : formatCurrency(taxAmt))+'" />'+
					  '<input type="hidden" name="hiddenTaxInfoTaxAlloc" value="'+($("hiddenTaxAlloc").value == null ? "" : $("hiddenTaxAlloc").value)+'" />'+
					  '<input type="hidden" name="hiddenTaxInfoTaxId" value="'+($("hiddenTaxId").value  == null ? "" : $("hiddenTaxId").value)+'" />';	
			  
				newDiv.update(content);
				itemTable.insert({bottom : newDiv}); 	
				divEvents(newDiv);
					
				recomputeTaxes("add");
				setGIPIWinvTax2();		
				
				// jhing 12.08.2014 FULLWEBSIT SR0003749
				resetTaxInformation();	
				checkTableIfEmpty("taxInformationRow", "enterBondBillTaxInformationListingTable");	
			}	
			
		}
		
		// commented out jhing 12.08.2014
		//resetTaxInformation();	
		//checkTableIfEmpty("taxInformationRow", "enterBondBillTaxInformationListingTable");	
			
			/*
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
					$("bondTaxDesc").value =  newDiv.down("input", 1).value;
					$("bondTaxAmount").value =  formatCurrency(newDiv.down("input", 2).value);
					$("bondTaxAlloc").value = newDiv.down("input", 3).value;
					//showTaxInfoButton(true);
					//$("btnBondAdd").value = "Update";
					showTaxInfoButton(false);
					enableButton("btnBondDelete");
				} else {
					showTaxInfoButton(true);
					//resetTaxInformation();
				}	  
			});	   */
			//setTaxAloccation();
	});
	
	
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

				$("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].text =  newDiv.down("input", 1).value;
				$("bondTaxAmount").value =  formatCurrency(newDiv.down("input", 2).value);
				$("bondTaxAlloc").value = newDiv.down("input", 3).value;
				showTaxInfoButton(true);
				$("btnBondAdd").value = "Update";
				enableButton("btnBondDelete");
				
				//marco - added lines below - 11.13.2013
				$("bondTaxDesc").hide();
				$("txtBondTaxDesc").show();
				$("txtBondTaxDesc").value = newDiv.down("input", 1).value;
				//setInvoiceTaxDisabled(Math.sign(unformatCurrencyValue($F("takeupPremAmt"))) == -1); //added by robert SR 4844 09.21.15
			} else {
				$("bondTaxDesc").value = null;
				$("txtBondTaxDesc").value = "";
				$("bondTaxDesc").show();
				$("txtBondTaxDesc").hide();
				//end
				
				showTaxInfoButton(true);
				$("bondTaxDesc").options[0].text = null;
				resetTaxInformation();
				//setInvoiceTaxDisabled(Math.sign(unformatCurrencyValue($F("takeupPremAmt"))) == -1); //added by robert SR 4844 09.21.15
			}	  
		});	   
	}
	
	$("btnBondDelete").observe("click", function ()	{ 
		$$("div[name='taxInformationRow']").each(function (row)	{
			if (row.hasClassName("selectedRow"))	{
				if(row.getAttribute("primarySw") == "Y"){ //marco - added condition - 11.13.2013
					showMessageBox("You cannot delete this record.", "I");
				}else{
					Effect.Fade(row, {
						duration: .2,
						afterFinish: function ()	{
							markTaxRecordAsDeleted(row.down("input", 0).value);
							row.remove();	
							recomputeTaxes("delete");
							resetTaxInformation();	
							checkTableIfEmpty("taxInformationRow", "enterBondBillTaxInformationListingTable");						
						}
					});
				}
			}
		});
	});	
	 
	$("bondTaxDesc").observe("change", function () {
		// $("bondTaxAmount").value = formatCurrency(Math.round((unformatCurrency("takeupPremAmt") * (parseFloat($("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("listTaxRt"))/100))*100)/100); // jhing 12.07.2014 FULLWEBSIT SR0003749-  commented out 

	    // jhing 12.07.2014 FULLWEBSIT SR0003749 -  added codes for recomputation of tax amounts ( which now considers the tax types)
		expTaxAmt = 0 ;
		selTaxCd = $("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("listTaxCd");
		selTaxId = $("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("listTaxId");	
		
		expTaxAmt = parseFloat(nvl(getBondsCompTaxAmt(),0)); 
		$("bondTaxAmount").value = formatCurrency(expTaxAmt);
		if(vatTag == 2 && selTaxCd == '${evatParamValue}') {
			showMessageBox("This assured is zero VAT rated.", imgMessage.INFO);
		}
	});
	
	//added by robert 01.07.2013 validation for Tax Amount
	var initBondTaxAmount;
	
	$("bondTaxAmount").observe("focus", function () {
		if ($F("bondTaxAmount") != ""){
			initBondTaxAmount = $F("bondTaxAmount");
		}
	});
	
	$("bondTaxAmount").observe("keyup", function(){
		if($F("bondTaxAmount").charAt(0) == '-'){
			if(isNaN($F("bondTaxAmount").replace(/-/, ''))){
				$("bondTaxAmount").value = nvl(initBondTaxAmount,"");
				$("bondTaxAmount").select();
			}else if ($F("bondTaxAmount") != ""){
				initBondTaxAmount = $F("bondTaxAmount");
			}
		}else{
			if(isNaN($F("bondTaxAmount"))){
				$("bondTaxAmount").value = nvl(initBondTaxAmount,"");
				$("bondTaxAmount").select();
			}else if ($F("bondTaxAmount") != ""){
				initBondTaxAmount = $F("bondTaxAmount");
			}
		}
	});
	
	$("bondTaxAmount").observe("change", function () {
		if ($F("bondTaxAmount") == null || $F("bondTaxAmount") == ""){
			showWaitingMessageBox("Required fields must be entered", "E", function(){
				$("bondTaxAmount").value = initBondTaxAmount;
				$("bondTaxAmount").focus();
			});
		}else{
			if(parseInt(initBondTaxAmount) > 9999999999.99 || parseInt(initBondTaxAmount) < -9999999999.99){
				showWaitingMessageBox("Invalid Tax Amount. Value should be from -9,999,999,999.99 to 9,999,999,999.99.", "E", function(){
					$("bondTaxAmount").value = formatCurrency(0);
					$("bondTaxAmount").select();
				});
			}else{
				$("bondTaxAmount").value = formatCurrency(nvl(initBondTaxAmount,0));
			}
		}
	});
	//end robert 01.07.2013
	
	$("btnTakeupUpdate").observe("click", function(){
		if(checkAllRequiredFieldsInDiv("invoiceInformationFooterHeader")){ //marco - 11.12.2013
			updateTakeupTermList(objArray, $F("bondTakeUpSeqNo"));
			changeTag = 1;
		}
	});
	
	$("btnTakeupCancel").observe("click", function() {
		showTakeupButton(false);
		removeSelectedTaxInformation();
		removeSelectedTakeUpInformation();
		resetToDefaultValues();
		hideTaxInformation();
	});
	
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
					//setInvoiceTaxDisabled(Math.sign(unformatCurrencyValue($F("takeupPremAmt"))) == -1); //added by robert SR 4844 09.21.15
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
	
	function updateTakeupTermList(objArray, seqNo){
		
		for (var i=0; i<objArray.length; i++){
			if (objArray[i].takeupSeqNo == seqNo){			
				//Set object values 
				objArray[i].recordStatus = 1;
				//objArray[i].dueDate = Date.parse($F("takeupBondDueDate"));
				objArray[i].dueDate = $F("takeupBondDueDate");
				objArray[i].refInvNo = $F("takeupBondrefInvNo");
				objArray[i].remarks = $F("takeupBondRemarks");
				objArray[i].multiBookingYY = $("bondBookingDate").options[$("bondBookingDate").selectedIndex].getAttribute("bookingYear");
				objArray[i].multiBookingMM = $("bondBookingDate").options[$("bondBookingDate").selectedIndex].getAttribute("bookingMonth");
				objArray[i].paytTerms = $F("takeupPayTerm");
				
				//marco - added lines below
				objArray[i].riCommAmt = unformatCurrencyValue($F("takeupRiCommAmt"));
				objArray[i].riCommVat = unformatCurrencyValue($F("takeupRiCommVat"));
				objArray[i].riCommRt = $F("takeupRiCommRt");
				objArray[i].amountDue = unformatCurrencyValue($F("takeupBondAmtDue"));
				
				//objArray[i].
				//Set display values
				$("lblTakeupDueDate"+objArray[i].takeupSeqNo).innerHTML = $F("takeupBondDueDate");
				$("lblTakeupBookingDate"+objArray[i].takeupSeqNo).innerHTML = objArray[i].multiBookingYY + "-" + objArray[i].multiBookingMM; 
				
				showTakeupButton(false);
				removeSelectedTaxInformation();
				removeSelectedTakeUpInformation();
				resetToDefaultValues();
				hideTaxInformation();
				
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
				totalTax = totalTax + parseFloat(objArray[i].taxAmt);
				newDiv.setAttribute("id", "row"+objArray[i].takeupSeqNo);
				newDiv.setAttribute("name", "takeUpRow");
				newDiv.addClassName("tableRow");
				
				newDiv.update(content);
				itemTable.insert({bottom : newDiv});	
			}
			$("bondTotalTaxAmt").value = formatCurrency(totalTax);
			//$("bondTotalAmtDue").value = formatCurrency(totalTax + unformatCurrency("bondPremTotal")); //commented out edgar 10/03/2014
			$("bondTotalAmtDue").value = formatCurrency(parseFloat(unformatCurrencyValue($F("bondPremTotal"))) + parseFloat(unformatCurrencyValue($F("bondTotalTaxAmt"))) - parseFloat(unformatCurrencyValue($F("bondRiCommAmt"))) - parseFloat(unformatCurrencyValue($F("bondRiCommVat")))); // edgar 10/03/2014 corrected computation
			//checkIfToResizeTable("takeupTableContainer", "takeUpRow");
			var divSize = $$("div[name='takeUpRow']").size();  
			if (divSize <= 1){
				$("takeupTableContainer").setStyle("height: 35px; overflow-y: auto; width: 100%;");
			}else{
				checkIfToResizeTable("takeupTableContainer", "takeUpRow");
			}
			checkTableIfEmpty("takeUpRow", "enterBondBillTakeUpListingTable");
		} catch (e) {
			showErrorMessage("showTakeupTermList", e);
			//showMessageBox("showItemList : " + e.message);
		}
	}
	
	function prepareTakeupListInfo(obj){
		try {		
			var bookingDate = (obj.multiBookingYY + "&nbsp;-&nbsp;" + obj.multiBookingMM);
			var takeupListInfo  = '<label style="width: 40px; text-align: right; margin-left: 43px;" id="lblTakeupSeqNo'+obj.takeupSeqNo+'">'+obj.takeupSeqNo+'</label>' +						
							'<label style="width: 118px; text-align: left; margin-left: 65px;" title="'+bookingDate+'" id="lblTakeupBookingDate'+obj.takeupSeqNo+'">'+bookingDate+'</label>'+
							'<label style="width: 75px; text-align: left; margin-left: 14px;" id="lblTakeupDueDate'+obj.takeupSeqNo+'">'+ obj.dueDate +'</label>'+
							'<label style="width: 120px; text-align: right; margin-left: 0px;" id="lblTakeupBondAmount'+obj.takeupSeqNo+'">'+(obj.bondTsiAmt == null ? formatCurrency(0) : formatCurrency(obj.bondTsiAmt))+'</label>'+
							'<label style="width: 120px; text-align: right; margin-left: 12px;" id="lblTakeupBondPremAmt'+obj.takeupSeqNo+'">'+(obj.premAmt == null ? formatCurrency(0) : formatCurrency(obj.premAmt))+'</label>'+
							'<label style="width: 120px; text-align: right; margin-left: 12px;" id="lblTakeupBondTaxAmt'+obj.takeupSeqNo+'">'+(obj.taxAmt == null ? formatCurrency(0) : formatCurrency(obj.taxAmt))+'</label>'+
							'<label style="width: 120px; text-align: right; margin-left: 12px;" id="lblTakeupBondTotalAmtDue'+obj.takeupSeqNo+'">'+(obj.amountDue == null ? formatCurrency(0) : formatCurrency(obj.amountDue))+'</label>'+
							'<input type="hidden" name="hiddenTakeupSeqNo" value="'+obj.takeupSeqNo+'" />';
	
			return takeupListInfo;
		} catch (e) {
			showErrorMessage("prepareTakeupListInfo", e);
			//showMessageBox("prepareTakeupListInfo : " + e.message);
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
						newDiv.setAttribute("primarySw", objArray[i].taxCodes[j].primarySw); //marco - 11.13.2013
						newDiv.addClassName("tableRow");
						newDiv.update(content);
						itemTable.insert({bottom : newDiv});
						divEvents(newDiv);
						newDiv.hide();
					}
				}
					
			}
			//checkIfToResizeTable("taxInformationTableContainer", "taxInformationRow");
			checkTableIfEmpty("taxInformationTableContainer", "enterBondBillTaxInformationListingTable");
		} catch (e) {
			showErrorMessage("showTaxInformationList", e);
			//showMessageBox("showItemList : " + e.message);
		}
	}
	
	function prepareTaxInformationListInfo(obj){
		try {				
			var taxInformationListInfo  = '<label style="width: 85px; text-align: center; margin-left: 25px;" name="lblTaxInfo" id="lblTaxInfoTaxCd'+obj.takeupSeqNo+'">'+obj.taxCd+'</label>'+
										  '<label style="width: 180px; text-align: left; margin-left: 40px;" name="lblTaxInfo" id="lblTaxInfoTaxDesc'+obj.takeupSeqNo+'">'+(obj.taxDesc == null ? "-" : obj.taxDesc)+'</label>'+
										  '<label style="width: 120px; text-align: right; margin-left: 25px;" name="lblTaxInfo" id="lblTaxInfoTaxAmt'+obj.takeupSeqNo+'">'+(obj.taxAmt == null ? formatCurrency(0) : formatCurrency(obj.taxAmt))+'</label>'+
										  '<label style="width: 50px; text-align: left; margin-left: 60px;" name="lblTaxInfo" id="lblTaxInfoTaxAlloc'+obj.takeupSeqNo+'">'+(obj.taxAllocation == null ? "-" : obj.taxAllocation)+'</label>'+
										  '<input type="hidden" name="hiddenTaxInfoTaxCd" value="'+(obj.taxCd == null ? "" : obj.taxCd)+'" />' +
										  '<input type="hidden" name="hiddenTaxInfoTaxDesc" value="'+(obj.taxDesc == null ? "" : obj.taxDesc)+'" />'+
										  '<input type="hidden" name="hiddenTaxInfoTaxAmt" value="'+(obj.taxAmt == null ? formatCurrency(0) : formatCurrency(obj.taxAmt))+'" />'+
										  '<input type="hidden" name="hiddenTaxInfoTaxAlloc" value="'+(obj.taxAllocation == null ? "" : obj.taxAllocation)+'" />' +
										  '<input type="hidden" name="hiddenTaxInfoTaxId" value="'+(obj.taxId == null ? "" : obj.taxId)+'" />' + 
										  '<input type="hidden" name="hiddenTaxInfoNoRateTag" value="'+ obj.noRateTag +'" />' +
										  '<input type="hidden" name="hiddenTaxInfoTaxRate" value="'+ obj.rate +'" />';							
	
			return taxInformationListInfo;
		} catch (e) {
			showErrorMessage("prepareTaxInformationListInfo", e);
			//showMessageBox("prepareTaxInformationListInfo : " + e.message);
		}
	}
	
	function chkIfTaxExist(taxCd){
		var exist = false;
		$$("div[name='taxInformationRow']").each(function (div) {
			if (div.getAttribute("taxCd") == taxCd){
				exist = true;
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
				options+= '<option value="'+obj[i].taxDesc+'" listFixedAllocation="'+obj[i].fixedTaxAllocation+'" listTaxId="'+obj[i].taxId+'" listTaxCd="'+obj[i].taxCd + '" listTaxRt="'+obj[i].rate+'">'+obj[i].taxDesc+'</option>'; 
			}
		}
		$("bondTaxDesc").insert({bottom: options}); 
		$("bondTaxDesc").selectedIndex = value;
	}
	
	function populatePayTermDtls(obj, value){
		$("takeupPayTerm").update('<option value="" payterm="" paytermDesc=""></option>');
		var options = "";
		for(var i=0; i<obj.length; i++){						
			options+= '<option value="'+obj[i].paytTerms+'" paytermDesc="'+obj[i].paytTermsDesc+'">'+obj[i].paytTermsDesc+'</option>';
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
				//var dDate = dateFormat(objArray[i].dueDate, "mm-dd-yyyy");
				var bookingDate = (objArray[i].multiBookingYY + " - " + objArray[i].multiBookingMM);
				
				$("bondTakeUpSeqNo").value = objArray[i].takeupSeqNo;
				//$("bondBookingDate").options[0].value = bookingDate;
				//$("bondBookingDate").options[0].text = bookingDate;
				$("bondBookingDate").value = bookingDate;
				$("takeupBondDueDate").value = dDate.format("mm-dd-yyyy");
				$("takeupBondAmt").value = (objArray[i].bondTsiAmt == null ? formatCurrency(0) : formatCurrency(objArray[i].bondTsiAmt));  
				$("takeupPremAmt").value = (objArray[i].premAmt == null ? formatCurrency(0) : formatCurrency(objArray[i].premAmt));
				$("takeupTaxTotal").value = (objArray[i].taxAmt == null ? formatCurrency(0) : formatCurrency(objArray[i].taxAmt));
				$("takeupBondAmtDue").value = (objArray[i].amountDue == null ? formatCurrency(0) : formatCurrency(objArray[i].amountDue));
				$("takeupBondRt").value = (objArray[i].bondRate == null ? formatToNthDecimal(0, 9) : formatToNthDecimal(objArray[i].bondRate, 9));
				$("takeupPayTerm").value =  (objArray[i].paytTerms == null ? "" : objArray[i].paytTerms);
				//$("takeupPayTerm").options[0].text =  row.down("input", 8).value;
				$("takeupBondrefInvNo").value = (objArray[i].refInvNo == null ? "" : objArray[i].refInvNo);
				$("takeupBondRemarks").value = (objArray[i].remarks == null ? "" : objArray[i].remarks);
				
				//marco - added lines below
				$("takeupRiCommRt").value = objArray[i].riCommRt == null ? formatToNthDecimal(0, 9) : formatToNthDecimal(objArray[i].riCommRt, 9);
				$("takeupRiCommAmt").value = objArray[i].riCommAmt == null ? formatCurrency(0) : formatCurrency(objArray[i].riCommAmt);
				$("takeupRiCommVat").value = objArray[i].riCommVat == null ? formatCurrency(0) : formatCurrency(objArray[i].riCommVat);
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
			m.value = (m.value == "" ? formatToNthDecimal(0, 9) :formatToNthDecimal(m.value, 9));
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
		$("takeupBondRt").value = formatToNthDecimal(0, 9);
		$("takeupPayTerm").value =  null;
		//$("takeupPayTerm").options[0].text =  "Select..";
		$("takeupBondrefInvNo").value = null;
		$("takeupBondRemarks").value = null;
		
		//marco - added lines below
		$("takeupRiCommRt").value = formatToNthDecimal(0, 9);
		$("takeupRiCommAmt").value = "0.00";
		$("takeupRiCommVat").value = "0.00";
		
		resetTaxInformation();
		showTaxInfoButton(false);
	}
	
	function resetTaxInformation(){  
		$("bondTaxDesc").value = null;
		$("bondTaxAmount").value = formatCurrency(0);
		$("bondTaxAlloc").selectedIndex = 0;
		//$("btnBondAdd").value = "Add";
		disableButton("btnBondDelete");
		$("btnBondAdd").value = "Add";
		enableButton("btnBondAdd");
		populateTaxDtls(objTaxDtlsArray, 0);
		// jhing 12.09.2014 added codes 
		$("txtBondTaxDesc").value = null;
		$("txtBondTaxDesc").hide();
		$("bondTaxDesc").show();
	}	
	
	function hideTaxInformation(){
		$$("div[name='taxInformationRow']").each(function (div) {
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
		var taxAmt = $F("bondTaxAmount");
		var taxAlloc = $("bondTaxAlloc").options[$("bondTaxAlloc").selectedIndex].value;
		var taxId = $("bondTaxDesc").options[$("bondTaxDesc").selectedIndex].getAttribute("listTaxId");
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
					newObj.rate 		= 	objArray[i].rate;
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
			//showMessageBox("setGIPIWinvTax : " + e.message);
		}
	}
	
	function setGIPIWinvTax2(){
		var newObj = new Object();	
		var taxCd = $F("hiddenTaxCd");
		var taxAmt = $F("bondTaxAmount");
		var taxAlloc = $F("hiddenTaxAlloc");
		var taxId = $F("hiddenTaxId");
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
					newObj.rate 		= 	objArray[i].rate;
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
	
	function recomputeTaxes(trans){
		var totalTaxAmount = unformatCurrency("bondTotalTaxAmt");
		var totalAmtDue = unformatCurrency("bondTotalAmtDue");
		var taxAmt = trans == "add" ? unformatCurrency("bondTaxAmount") : unformatCurrency("hiddenTaxAmt");
		
		if (trans == "add"){
			totalTaxAmount += taxAmt;
			totalAmtDue += taxAmt;
		}else{
			totalTaxAmount -= taxAmt;
			totalAmtDue -= taxAmt;
		}
		
		$("bondTotalTaxAmt").value = Math.round(totalTaxAmount*100)/100;
		$("bondTotalAmtDue").value = Math.round(totalAmtDue*100)/100;
		$("takeupTaxTotal").value = $("bondTaxAmount").value;
		
		for(var i=0; i<objArray.length; i++) {	
			if (objArray[i].takeupSeqNo == $F("bondTakeUpSeqNo")) {	
				if (trans == "add"){
					objArray[i].taxAmt = Math.round((parseFloat(objArray[i].taxAmt == null ? 0 : objArray[i].taxAmt) + (taxAmt))*100)/100;
					objArray[i].amountDue = Math.round((parseFloat(objArray[i].amountDue == null ? 0 : objArray[i].amountDue) + (taxAmt))*100)/100;
					objArray[i].dueDate = $F("takeupBondDueDate");
				}else{
					objArray[i].taxAmt = Math.round((parseFloat(objArray[i].taxAmt == null ? 0 : objArray[i].taxAmt) - (taxAmt))*100)/100;
					objArray[i].amountDue = Math.round((parseFloat(objArray[i].amountDue == null ? 0 : objArray[i].amountDue) - taxAmt)*100)/100;
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
		/*}else if ($("bondTaxAlloc").selectedIndex == 0){
			showMessageBox("There is no tax allocation entered for this invoice.");
			isValid = false;*/
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
			$("lblRiCommRt").innerHTML =  "RI Comm. Rt.";
			$("lblRiCommVat").innerHTML = "RI Comm. VAT";
			$("bondRiCommRt").show();
			$("bondRiCommAmt").show();
			$("bondRiCommVat").show();
			
			//marco - added codes below
			$("lblRiCommAmt").show();
			$("lblRiCommRt").show();
			$("lblRiCommVat").show();
			$("lblTakeupRiCommAmt").show();
			$("lblTakeupRiCommRt").show();
			$("lblTakeupRiCommVat").show();
			$("takeupRiCommRt").show();
			$("takeupRiCommAmt").show();
			$("takeupRiCommVat").show();
		}else{
			$("lblRiCommAmt").innerHTML = "";
			$("lblRiCommRt").innerHTML =  "";
			$("lblRiCommVat").innerHTML = "";
		}	
	}
	
	$("btnBondCancel").observe("click", 
		function () {
			if(changeTag != 0){
				showConfirmBox3("Cancel Facultative", objCommonMessage.WITH_CHANGES , "Yes", "No", function () {saveFuncMain();}, goBackToParListing); 
			}else {
				goBackToParListing();
			}
		}
	);
	
	/* $("reloadForm").observe("click", function () {
		showConfirmBox("CONFIRMATION", "Reloading form will disregard all changes. Proceed?", "Yes", "No", function () {
																												showBillPremium();
																													changeTag = 0;
																											}, "");
	}); */
	
	observeReloadForm("reloadForm", showBillPremium);
	
	if (unformatCurrency("bondTotalAmt") == 0){
		enableButton("createInvoiceBtn");
	}else{
		disableButton("createInvoiceBtn");
	}
	
	if (takeupTerm == "MTH") {
		$("takeupPayTerm").disabled = true;
	}
	
	if(objGIPIWPolbas.cancelType == 1 || objGIPIWPolbas.cancelType == 2 || objGIPIWPolbas.cancelType == 3 || objGIPIWPolbas.cancelType == 4){
		$("bondTotalAmt").setAttribute("readonly", "readonly");
		$("bondRateTotal").setAttribute("readonly", "readonly");
		$("bondPremTotal").setAttribute("readonly", "readonly");
		if($("issCdRI").value == "RI" || $("issCdRI").value == "RB"){
			$("bondRiCommRt").setAttribute("readonly", "readonly");
			$("bondRiCommAmt").setAttribute("readonly", "readonly");
			$("bondRiCommVat").setAttribute("readonly", "readonly");
		}
		showMessageBox("This is a cancellation type of endorsement, update/s of any details will not be allowed.", "I");
	}
	
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
	//added by robert GENQA SR 4825 08.19.15
	function roundExpNumber(number, decimals) {
		var newnumber = new Number(number+'').toFixed(parseInt(decimals));
		return parseFloat(newnumber);
	}
	// end robert GENQA SR 4825 08.19.15
 	//added by robert SR 4844 09.21.15
 	// requested to be commented out by ma'am vj - apollo cruz 10.15.2015
 	/* function setInvoiceTaxDisabled(negPrem){	 		
 		if (negPrem){
 			$$("div#taxInformationDiv input[type='text'], textarea").each(function(obj){
 				obj.readOnly = true;
 			});
 			
 			$$("div#taxInformationDiv input[type='button']").each(function(obj){		
 				if(obj.id != "btnCancel" && obj.id != "btnSave")
 					disableButton(obj.id);
 			});
 			
 			$$("div#taxInformationDiv input[type='disabledButton']").each(function(obj){		
 				if(obj.id != "btnCancel" && obj.id != "btnSave")
 					disableButton(obj.id);
 			});
 			
 			$$("div#taxInformationDiv select, input[type='checkbox']").each(function(obj){
 				obj.disable();
 			});
 		}
 	} */
 	//end robert SR 4844 09.21.15
	checkForPostedBinders();
	hideNotice();
	setInitialProperties();
	initializeAccordion();
	initializeChangeTagBehavior(saveFuncMain);
</script>