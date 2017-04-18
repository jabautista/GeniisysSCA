<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="ajax" uri="http://ajaxtags.org/tags/ajax" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<%-- <div id="dcbAcctEntriesDiv" name="dcbAcctEntriesDiv" style="margin-top: 1px;">
	<jsp:include page="subPages/orInfoAcEntries.jsp"></jsp:include>
	<div class="sectionDiv" style="border-top: none;" id="accountingEntriesDiv" name="accountingEntriesDiv"  changeTagAttr="true">
		<div id="acctEntriesTableMainDiv" name="acctEntriesTableMainDiv" style="width: 100%; margin-top: 20px;">
			<div id="acctEntriesTable" name="acctEntriesTable" style="width: 100%; text-align: center; display: block;">
				<div class="tableHeader" style="font-size: 11px;">
					<label style="width: 215px; text-align: left; margin-left: 1px; border: 1px solid #E0E0E0;">GL Account Code</label>
		 	        <label style="width: 280px; text-align: left; margin-left: 3px; border: 1px solid #E0E0E0;">GL Account Name</label>
		        	<label style="width: 140px; text-align: left; margin-left: 3px; border: 1px solid #E0E0E0;">SL Name</label>	 
		        	<label style="width: 120px; text-align: center; margin-left: 8px; border: 1px solid #E0E0E0;">Debit Amount</label>
		        	<label style="width: 120px; text-align: center; margin-left: 3px; border: 1px solid #E0E0E0;">Credit Amount</label>
				</div>
			</div>
			<div id="acctEntriesListing" name="acctEntriesListing"></div>
			<div id="acctTotalsMainDiv" style="width: 100%; display: block; margin-top: 5px; margin-bottom: 10px;">
				<div id="acctTotalsDiv" style="height: 20px; padding-top: 5px;">
					<input type="hidden" id="tranFlag" name="tranFlag" value="${tranFlag}" />
					<input type="button" class="button" style="width:11%; float: left; margin-left: 3%" id="closeTrans" name="closeTrans" value="Close Trans"/>
					<input type="button" class="button" style="width:13%; float: left; margin-left: 1%" id="viewGlBal" name="viewGlBal" value="View GL Balance" />
					<label style="text-align: right; width: 28%; margin-left: 20px; font-size: 11px;">Total:</label>
					<div style="width: 34%; float: left; border-bottom: 1px solid #E0E0E0; margin-left: 55px; padding-bottom: 2px; font-size: 11px;">
						<label id="lblDebitTotals" class="money" style="width: 125px; margin-left: 48px; text-align: right;"></label>
						<label id="lblCreditTotals" class="money" style="width: 125px; margin-left: 3px; text-align: right"></label>
					</div>
					
				</div>
				<div id="acctDifDiv" style="height: 20px; padding-top: 5px; font-size: 11px; margin-left: 40%;">
					<label style="text-align: right; width: 150px; margin-left: 50px; ">Difference:</label>
					<label id="lblDifference" class="money" style="width: 20%; margin-left: 85px; text-align: right;"></label>
				</div>
			</div>
		</div>
		
		<table align="center" style="margin-top: 10px; margin-bottom:10px;">
			<tbody>
				<tr>
					<td class="rightAligned" style="width: 130px;">GL Account Code</td>
					<td class="leftAligned" style="width: 400px;">
						<div id="glCodeDiv" style="float: left;">
							<input type="hidden" id="inputGlAcctId" name="inputGlAcctId" value="" />
							<input type="text" style="width: 22px;" id="inputGlAcctCtgy" 	name="inputGlAcctCtgy"	value="" class="rightAligned list required" readonly="readonly"/>
							<input type="text" style="width: 22px;" id="inputGlCtrlAcct" 	name="inputGlCtrlAcct" 	value="" class="rightAligned list required" readonly="readonly"/>
							<input type="text" style="width: 22px;" id="inputSubAcct1" 		name="inputSubAcct1" 	value="" class="rightAligned list required" readonly="readonly"/>
							<input type="text" style="width: 22px;" id="inputSubAcct2" 		name="inputSubAcct2"	value="" class="rightAligned list required" readonly="readonly"/>
							<input type="text" style="width: 22px;" id="inputSubAcct3"		name="inputSubAcct3" 	value="" class="rightAligned list required" readonly="readonly"/>
							<input type="text" style="width: 22px;" id="inputSubAcct4"		name="inputSubAcct4" 	value="" class="rightAligned list required" readonly="readonly"/>
							<input type="text" style="width: 22px;" id="inputSubAcct5"		name="inputSubAcct5" 	value="" class="rightAligned list required" readonly="readonly"/>
							<input type="text" style="width: 22px;" id="inputSubAcct6"		name="inputSubAcct6" 	value="" class="rightAligned list required" readonly="readonly"/>
							<input type="text" style="width: 22px;" id="inputSubAcct7"		name="inputSubAcct7" 	value="" class="rightAligned list required" readonly="readonly"/>
						</div>
				
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 130px;">GL Account Name</td>
					<td class="leftAligned" style="width: 400px;">
						<div style="float: left; width: 326px; border: 1px solid gray; height: 20px;" class="required">
							<input type="text" style="width: 295px; float: left; border: none; height: 15px; padding-top: 0px;" id="inputGlAcctName" name="inputGlAcctName" value="" class="required"/>
							<img id="searchGlAcct" name="searchGlAcct" alt="Go" style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png">
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 130px;">SL Name</td>
					<td class="leftAligned" style="width: 400px;">
						<input type="hidden" id="hidGenType" value="" />
						<input type="hidden" id="hidSlTypeCd" value="" />
						<input type="text" style="width: 320px; display: none;" id="txtSlName" readonly="readonly" name="txtSlName" slCd="" value="" />
						<div id="selectSlDiv" style="float: left; width: 326px; border: 1px solid gray; height: 20px;">
							<input type="hidden" id="inputSlCd" name="inputSlCd" value="" />
							<input type="text" id="inputSlName" name="inputSlName" style="width: 295px; float: left; border: none; height: 15px; padding-top: 0px;" value="" />
							<img id="searchSlCd" name="searchSlCd" alt="Go" style="float: right" src="${pageContext.request.contextPath}/images/misc/searchIcon.png">
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 130px;">Debit Amount</td>
					<td class="leftAligned" style="width: 400px;">
						<input type="text" style="width: 320px;" id="inputDebitAmt" name="inputDebitAmt" class="rightAligned list money2 required" maxlength="15" />
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 130px;">Credit Amount</td>
					<td class="leftAligned" style="width: 400px;">
						<input type="text" style="width: 320px;" id="inputCreditAmt" name="inputCreditAmt" class="rightAligned list money2 required" maxlength="15" />
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 130px;">Remarks</td>
					<td class="leftAligned" style="width: 400px;">
						<div style="border: 1px solid gray; height: 20px; width: 81.7%; ">
							<textarea id="inputEntryRemarks" name="inputEntryRemarks" style="width: 91% ; border: none; height: 13px;"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="EditRemark" id="editRemarksText" />
						</div>
					</td>
				</tr>
			</tbody>
		</table>
		<div style="margin-bottom: 10px; margin-top: 10px;">
			<input type="button" class="button" style="width: 60px;" id="btnAddEntry" name="btnAddEntry" value="Add" />
			<input type="button" class="disabledButton" style="width: 60px;" id="btnDelEntry" name="btnDelEntry" value="Delete" disabled="disabled" />
		</div>
	</div>
	<div class="buttonsDiv" id="acctEntriesButtonsDiv" changeTagAttr="true">
		<input type="button" class="button noChangeTagAttr" style="width: 90px;" id="btnCancelEntry" name="btnCancelEntry" value="Cancel" />
		<input type="button" class="button noChangeTagAttr" style="width: 90px;" id="btnSaveEntry" name="btnSaveEntry" value="Save" />
	</div>
</div> --%> <!-- dren 08.03.2015 : SR 0017729 - Comment out to rework jsp - Start -->

	<jsp:include page="subPages/orInfoAcEntries.jsp"></jsp:include>   <!-- dren 08.03.2015 : SR 0017729 - Added to display Accounting Entries - Start -->
	<div class="sectionDiv" style="border-top: none;" id="accountingEntriesDiv" name="accountingEntriesDiv">			
		<!-- HIDDEN FIELDS -->
		<input type="hidden" id="tranFlag" name="tranFlag" value="${tranFlag}" />
		<input type="hidden" id="hiddenAcctEntryId" name="hiddenAcctEntryId" value="" />
		<input type="hidden" id="hiddenGlAcctId" name="hiddenGlAcctId" value="" />
		<input type="hidden" id="hiddenGenType" name="hiddenGenType" value="" />
		<input type="hidden" id="hiddenSlTypeCd" name="hiddenSlTypeCd" value="" />
		<input type="hidden" id="hiddenSlCd" name="hiddenSlCd" value="" />
		<input type="hidden" id="hiddenFundCd" name="hiddenFundCd" value="" />
		<input type="hidden" id="hiddenBranchCd" name="hiddenBranchCd" value="" />
		<input type="hidden" id="hiddenSlSourceCd" name="hiddenSlSourceCd" value="" />
		<input type="hidden" id="hiddenTranClass" name="hiddenTranClass" value="${gacc.tranClass}" />
		<input type="hidden" id="hiddenDvFlag" name="hiddenDvFlag" value="${gacc.dvFlag}" />
		<!-- END HIDDEN FIELDS -->
		
		<div id="accountingEntriesTableGridDiv" style= "padding: 11px 10px 10px 10px;">
			<div id="accountingEntriesTableGrid" style="height: 285px;"></div>
		</div>
		<div id="acctTotalsMainDiv" style="width: 900px; display: block; margin:0 auto; padding-top: 10px; padding-bottom: 10px;">
			<div id="acctTotalsDiv" style="height: 100px;">				
				<table align="right">
					<tr>
						<td style="text-align:right; padding-right:10px;">Total Debit Amount</td>
						<td>
							<input type="text" id="txtDebitTotal" class="money" style="width: 125px; text-align: right;" readonly="readonly" tabindex=203/>
						</td>
					</tr>
					<tr>
						<td style="text-align:right; padding-right:10px;">Total Credit Amount</td>
						<td>
							<input type="text" id="txtCreditTotal" class="money" style="width: 125px; text-align: right;" readonly="readonly" tabindex=204/>					
						</td>
					</tr>
					<tr>
						<td style="text-align:right; padding-right:10px;">Difference</td>
						<td>
							<input type="text" id="txtDifference" class="difference" style="width: 125px; text-align: right;" readonly="readonly" tabindex=205/>
						</td>
					</tr>
				</table>
			</div>
		</div>
			
		<div id="acctEntriesFormDiv" name="acctEntriesFormDiv" changetagattr="true" >
			<table style="margin: 10px 0 10px 165px;">
				<tbody>
					<tr>
						<td class="rightAligned" style="width: 101px;">GL Account Code</td>
						<td class="leftAligned" style="width: 445px;">
							<div id="glCodeDiv" style="float: left;">
								<input type="text" style="width: 22px;" id="inputGlAcctCtgy" 	value="" class="glAC applyWholeNosRegExp" regExpPatt="pDigit01" maxlength="1" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="9" customLabel="GL Account Code" tabindex=206 readonly="readonly"/>
								<input type="text" style="width: 22px;" id="inputGlCtrlAcct" 	name="glAccountCode" 	value="" class="glAC applyWholeNosRegExp" regExpPatt="pDigit02" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Account Code" tabindex=207 readonly="readonly"/>
								<input type="text" style="width: 22px;" id="inputSubAcct1" 		name="glAccountCode" 	value="" class="glAC applyWholeNosRegExp" regExpPatt="pDigit02" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Account Code" tabindex=208 readonly="readonly"/>
								<input type="text" style="width: 22px;" id="inputSubAcct2" 		name="glAccountCode"	value="" class="glAC applyWholeNosRegExp" regExpPatt="pDigit02" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Account Code" tabindex=209 readonly="readonly"/>
								<input type="text" style="width: 22px;" id="inputSubAcct3"		name="glAccountCode" 	value="" class="glAC applyWholeNosRegExp" regExpPatt="pDigit02" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Account Code" tabindex=210 readonly="readonly"/>
								<input type="text" style="width: 22px;" id="inputSubAcct4"		name="glAccountCode" 	value="" class="glAC applyWholeNosRegExp" regExpPatt="pDigit02" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Account Code" tabindex=211 readonly="readonly"/>
								<input type="text" style="width: 22px;" id="inputSubAcct5"		name="glAccountCode" 	value="" class="glAC applyWholeNosRegExp" regExpPatt="pDigit02" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Account Code" tabindex=212 readonly="readonly"/>
								<input type="text" style="width: 22px;" id="inputSubAcct6"		name="glAccountCode" 	value="" class="glAC applyWholeNosRegExp" regExpPatt="pDigit02" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Account Code" tabindex=213 readonly="readonly"/>
								<input type="text" style="width: 22px;" id="inputSubAcct7"		name="glAccountCode" 	value="" class="glAC applyWholeNosRegExp" regExpPatt="pDigit02" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Account Code" tabindex=214 readonly="readonly"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 101px;">GL Account Name</td>
						<td class="leftAligned" style="width: 445px;">
							<input type="text" style="width: 451px; float: left; border: 1px solid gray; height: 20px; padding-top: 0px;" id="inputGlAcctName" name="inputGlAcctName" value="" readonly="readonly" tabindex=215/>								
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 101px;">SL Name</td>
						<td class="leftAligned" style="width: 445px;">
							<input type="text" id="inputSlName" name="inputSlName" style="width: 451px; float: left; border: border: 1px solid gray; height: 20px; padding-top: 0px;" value="" readonly="readonly" tabindex=217/>
						</td>
					</tr>
					<tr>
						<!-- <td class="rightAligned" style="width: 101px;">Debit Amount</td>
						<td class="leftAligned" style="width: 320px;">
							<input type="text" style="width: 320px;" id="inputDebitAmt" name="inputDebitAmt" class="rightAligned list money required" maxlength="15" tabindex=219/>
						</td>
						<td class="rightAligned" style="width: 101px;">Credit Amount</td>
						<td class="leftAligned" style="width: 320px;">
							<input type="text" style="width: 320px;" id="inputCreditAmt" name="inputCreditAmt" class="rightAligned list money required" maxlength="15" tabindex=220/>
						</td> -->
						<td class="rightAligned" style="width: 101px;" for="inputDebitAmt">Debit Amount</td>
						<td class="leftAligned" style="width: 160px;">
							<input type="text" style="width: 160px;" id="inputDebitAmt" name="inputDebitAmt" class="rightAligned applyDecimalRegExp" 
								 regExpPatt="pDeci1002" min="0" max="9999999999.99" hasOwnChange="Y" hasOwnBlur="Y" maxlength="15" tabindex=219 readonly="readonly"/>
							<div class="rightAligned" style="width: 280px; float:right;">
								<span class="rightAligned" style="width: 120px;">Credit Amount</span>
								<input type="text" style="width: 160px; margin-left:5px;" id="inputCreditAmt" name="inputCreditAmt" class="rightAligned applyDecimalRegExp" 
								 regExpPatt="pDeci1002" min="0" max="9999999999.99" hasOwnChange="Y" hasOwnBlur="Y" maxlength="15" tabindex=220 customLabel="Credit Amount" readonly="readonly"/>
							</div>
						</td>
						<!-- <td class="rightAligned" style="width: 81px;" for="inputCreditAmt">Credit Amount</td>
						<td class="leftAligned" style="width: 160px;">
							<input type="text" style="width: 160px; margin-left:5px;" id="inputCreditAmt" name="inputCreditAmt" class="rightAligned required applyDecimalRegExp" 
								 regExpPatt="pDeci1002" min="0" max="9999999999.99" hasOwnChange="Y" hasOwnBlur="Y" maxlength="15" tabindex=220/>
						</td> -->
					</tr>
					<tr>
						<td class="rightAligned" style="width: 101px;">Remarks</td>
						<td class="leftAligned" style="width: 445px;">
							<div style="border: 1px solid gray; height: 20px; width:457px; ">
								<input type="text" id="inputEntryRemarks" name="inputEntryRemarks" style="width: 94% ; border: none; height: 12px;" maxlength="4000" tabindex=221 readonly="readonly"/>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="EditRemark" id="editRemarksText" name="editText" tabindex=222/>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
	<div class="buttonsDiv" id="acctEntriesButtonsDiv">
		<input type="button" style="width: 90px;" id="btnCancelEntry" name="btnCancelEntry" value="Cancel" tabindex=227 class="button"/>
	</div> <!-- dren 08.03.2015 : SR 0017729 - Added to display Accounting Entries - Start -->
	
<script type="text/javascript">

/* 	setModuleId("GIACS042");
setDocumentTitle("Accounting Entries");
var acctEntObjArray = ""   //JSON.parse('${acctEntries}'.replace(/\\/g, '\\\\'));	
var checkEntry = JSON.parse('${checkManualEntry}');

//var objArrayTemp = acctEntObjArray;
var newEntryId = 1000000;
var selectedEntry = null;
var deletedEntries = new Array();
var addedEntries = new Array();
changeTag = 0;

if($F("gaccTranFlag") == "P" || $F("gaccTranFlag") == "C" ||
		$F("gaccTranFlag") == "D" || $F("gaccTranFlag") == "") {
	disableButton("closeTrans");
	
} else {
	enableButton("closeTrans");
}

function createAcctEntriesRow(objArray) {
	var tableContainer = $("acctEntriesListing");
	var testRow = null;
	for(var i=0; i<objArray.length; i++) {
		testRow = objArray[i];
		var content = prepareAccountEntries(objArray[i]);
		var newRow = new Element("div");
		newRow.setAttribute("id", 	"acEnRow" + objArray[i].acctEntryId);
		newRow.setAttribute("name", "acEnRow");
		newRow.setAttribute("class","tableRow");
		newRow.setStyle({fontSize: '10px'});	

		newRow.update(content);
		tableContainer.insert({bottom:newRow});

		newRow.observe("mouseover", function(){
			newRow.addClassName("lightblue");
		});

		newRow.observe("mouseout", function(){
			newRow.removeClassName("lightblue");
		});

		newRow.observe("click", function() {
			clickEntry(newRow, objArray);
		});
		
		checkIfToResizeTable("acctEntriesListing", "acEnRow");
		checkTableIfEmpty("acEnRow", "acctEntriesTableMainDiv");
	}
}

function prepareAccountEntries(obj) {
	var entry = "";
	try {
		entry = '<input type="hidden" id="acctEntryId'+ obj.acctEntryId +'" name="acctEntryId" value='+ obj.acctEntryId +' />' +
				'<input type="hidden" id="glAcctId" name="glAcctId" value='+ obj.glAcctID +' />' +
				'<label style="width: 220px; text-align: left; margin-left: 1px;" name="glAcctCd">'+ 
					(obj.glAcctCategory) + '-' + 
					(obj.glControlAcct) + '-' + 
					(obj.glSubAcct1) + '-' +
					(obj.glSubAcct2) + '-' +
					(obj.glSubAcct3) + '-' +
					(obj.glSubAcct4) + '-' +
					(obj.glSubAcct5) + '-' +
					(obj.glSubAcct6) + '-' +
					(obj.glSubAcct7) + '</label>' +
				'<label style="width: 280px; text-aligh: left" margin-left: 3px;>'+(obj.glAcctName==null? "---" : obj.glAcctName.truncate(42, "..."))+'</label>' +
				'<label style="width: 140px; text-align: left; margin-left: 5px;" name="slName">'+ (obj.slName==null ? "---" : obj.slName.truncate(21,"...")) +'</label>' +	
				'<label style="width: 120px; text-align: right; margin-left: 3px;" name="debitAmt">'+ formatCurrency(obj.debitAmt) +'</label>' +
				'<label style="width: 120px; text-align: right; margin-left: 3px;" name="creditAmt">'+ formatCurrency(obj.creditAmt) +'</label>';
		return entry;
	}  catch(e) {
		showErrorMessage("prepareAccountEntries", e);
	}
}

$("inputDebitAmt").observe("blur", function() {
	if(parseFloat(($F("inputDebitAmt")).replace(/,/g, "")) > 9999999999.99) {
		showMessageBox("Maximum value for Debit Amount is 9,999,999,999.99");
		$("inputDebitAmt").clear();
		$("inputDebitAmt").focus();
	} else if(isNaN(parseFloat($F("inputDebitAmt")))) {
		showMessageBox("Field must be of form 9,999,999,990.99.");
		$("inputDebitAmt").clear();
		$("inputDebitAmt").focus();
	} else if(parseFloat(($F("inputDebitAmt")).replace(/,/g, "")) < 0) {
		showMessageBox("Negative Amounts are not Allowed.");
		$("inputDebitAmt").clear();
		$("inputDebitAmt").focus();
	} 
});

$("inputCreditAmt").observe("blur", function() {
	if(parseFloat(($F("inputCreditAmt")).replace(/,/g, "")) > 9999999999.99) {
		showMessageBox("Maximum value for Credit Amount is 9,999,999,999.99");
		$("inputCreditAmt").clear();
		$("inputCreditAmt").focus();
	} else if(isNaN(parseFloat($F("inputCreditAmt")))) {
		showMessageBox("Field must be of form 9,999,999,990.99.");
		$("inputCreditAmt").clear();
		$("inputCreditAmt").focus();
	} else if(parseFloat(($F("inputCreditAmt")).replace(/,/g, "")) < 0) {
		showMessageBox("Negative Amounts are not Allowed.");
		$("inputCreditAmt").clear();
		$("inputCreditAmt").focus();
	} 
});

function clickEntry(row, objArray) {
	row.toggleClassName("selectedRow");
	if(row.hasClassName("selectedRow")) {
		var temp = row.down("input", 0).value;
		for(var i=0; i<objArray.length; i++) {
			if(objArray[i].acctEntryId == temp) {
				selectedEntry = objArray[i];
				break;
			}
		}
		setSelectedAcctEntry(selectedEntry);

		$$("div#acctEntriesTableMainDiv div[name='acEnRow']").each(function(a) {
			if(row.getAttribute("id") != a.getAttribute("id")) {
				a.removeClassName("selectedRow");
			}
		});
	} else {
		setSelectedAcctEntry(null);
	}
}

function setSelectedAcctEntry(obj) {
	try {
		if(obj==null) {
			$("txtSlName").clear();
			$("txtSlName").hide();
			$("selectSlDiv").show();
			$("inputSlName").removeClassName("required");
			$("selectSlDiv").removeClassName("required");

			$("inputSlName").removeAttribute("readonly");
			$("inputGlAcctName").removeAttribute("readonly");
		} else {
			$("selectSlDiv").hide();
			$("txtSlName").show();

			$("inputSlName").setAttribute("readonly", "readonly");
			$("inputGlAcctName").setAttribute("readonly", "readonly");
		}
		$("hidSlTypeCd").value = "";
		curEntryId = obj == null ? "" : (obj.acctEntryId);
		$("inputGlAcctCtgy").value = obj == null ? "" : (obj.glAcctCategory);
		$("inputGlCtrlAcct").value = obj == null ? "" : (obj.glControlAcct);
		$("inputSubAcct1").value = obj == null ? "" : (obj.glSubAcct1);
		$("inputSubAcct2").value = obj == null ? "" : (obj.glSubAcct2);
		$("inputSubAcct3").value = obj == null ? "" : (obj.glSubAcct3);
		$("inputSubAcct4").value = obj == null ? "" : (obj.glSubAcct4);
		$("inputSubAcct5").value = obj == null ? "" : (obj.glSubAcct5);
		$("inputSubAcct6").value = obj == null ? "" : (obj.glSubAcct6);
		$("inputSubAcct7").value = obj == null ? "" : (obj.glSubAcct7);
			
		$("inputGlAcctName").value = (obj == null ? "" : obj.glAcctName);
		$("inputDebitAmt").value = formatCurrency(obj == null ? "" : obj.debitAmt);
		$("inputCreditAmt").value = formatCurrency(obj == null ? "" : obj.creditAmt);
		$("inputEntryRemarks").value = (obj == null ? "" : (obj.remarks == null ? "" : 
			changeSingleAndDoubleQuotes(fixTildeProblem(obj.remarks))));
		$("inputSlName").value = (obj == null ? "" : obj.slName);
		$("txtSlName").value = (obj == null ? "" : unescapeHTML2(obj.slName));
		$("txtSlName").setAttribute("slCd", obj == null ? "" : (obj.slCd == null ? "" : obj.slCd));
		$("btnAddEntry").value = (obj == null ? "Add" : "Update");
		(obj == null ? disableButton($("btnDelEntry")) : enableButton($("btnDelEntry")));
	} catch(e) {
		showErrorMessage("setSelectedAcctEntry", e);
	}
}

function addAcctEntry() {
	try {
		var newObj = new Object();
		var tableContainer = $("acctEntriesListing");
		if($F("btnAddEntry") == "Add") {
			newEntryId += 1;
			newObj = setAcctEntryObj(0);
		} else {
			newObj = setAcctEntryObj(1);
		}
		var checkInput = checkInputs(newObj);			
		if(checkInput) {
			var content = prepareAccountEntries(newObj);
			if($F("btnAddEntry")=="Update") {
				$("acEnRow"+curEntryId).update(content);
				addModifiedAcctEntries(newObj, acctEntObjArray);
			} else {									
				var newRow = new Element("div");
				newRow.setAttribute("id", 	"acEnRow" + newObj.acctEntryId);
				newRow.setAttribute("name", "acEnRow");
				newRow.setAttribute("class","tableRow");
				newRow.setStyle({fontSize: '10px'});

				newRow.update(content);
				tableContainer.insert({bottom:newRow});

				newRow.observe("mouseover", function(){
					newRow.addClassName("lightblue");
				});

				newRow.observe("mouseout", function(){
					newRow.removeClassName("lightblue");
				});

				newRow.observe("click", function() {
					clickEntry(newRow, acctEntObjArray);
				});

				checkIfToResizeTable("acctEntriesListing", "acEnRow");
				checkTableIfEmpty("acEnRow", "acctEntriesTableMainDiv");

				addNewAcctEntries(newObj, acctEntObjArray);
			}
			computeTotalsAE();	
			changeTag = 1;
			setSelectedAcctEntry(null);
		}
	} catch(e) {
		showErrorMessage("addAcctEntry", e);
	}		
}

function delAcctEntry(obj) {
	try {
		
		var acctEntry = obj.acctEntryId;
		$$("div[name='acEnRow']").each(function(row) {
			if(row.down("input", 0).value == acctEntry) {
				Effect.Fade(row, {
					duration: .2,
					afterFinish: function() {
						row.remove();
						addToDeletedAcctEntries(obj, acctEntObjArray);
						setSelectedAcctEntry(null);

						checkIfToResizeTable("acctEntriesListing", "acEnRow");
						checkTableIfEmpty("acEnRow", "acctEntriesTableMainDiv");
						computeTotalsAE();
						changeTag = 1;
					}
				});
			}
		});
		
	} catch(e) {
		showErrorMessage("delAcctEntry", e);
	}
}

function computeTotalsAE() {
	var totalDebit = 0;
	for(var i=0; i<acctEntObjArray.length; i++) {
		totalDebit += parseFloat(acctEntObjArray[i].debitAmt);
		
	}
	$("lblDebitTotals").innerHTML = formatCurrency(totalDebit);

	var totalCredit=0;
	for(var i=0; i<acctEntObjArray.length; i++) {
		totalCredit += parseFloat(acctEntObjArray[i].creditAmt);
		
	}
	$("lblCreditTotals").innerHTML = formatCurrency(totalCredit);

	var difference = totalCredit - totalDebit;
	if(difference < 0) {
		difference = difference * -1;
	}
	$("lblDifference").innerHTML = formatCurrency(difference);
}

function addToDeletedAcctEntries(obj, objArray) {
	for(var i=0; i<objArray.length; i++) {
		if(obj.acctEntryId == objArray[i].acctEntryId) {
			if(obj.acctEntryId < 1000000) {
				deletedEntries.push(obj);
			}
			acctEntObjArray.splice(i, 1);				
		}
	}

	for(var i=0; i<addedEntries.length; i++) {
		if(obj.acctEntryId == addedEntries[i].acctEntryId) {
			addedEntries.splice(i, 1);
		}
	}
}

function addNewAcctEntries(obj, objArray) {
	var exists = false;
	for(var i=0; i<objArray.length; i++) {
		if(obj.acctEntryId == objArray[i].acctEntryId) {
			exists = true;
			break;
		} 
	}
	if(exists) {
		showMessageBox("Accounting Entry - " + obj.acctEntryId + " has already been added... ");
	} else {
		acctEntObjArray.push(obj);
		addedEntries.push(obj);
	}
}

function addModifiedAcctEntries(obj) {
	for (var i=0; i<acctEntObjArray.length; i++) {
		if(acctEntObjArray[i].acctEntryId == obj.acctEntryId){
			acctEntObjArray.splice(i, 1);
		}
	}
	acctEntObjArray.push(obj);
	for(var i=0; i<addedEntries.length; i++) {
		if(obj.acctEntryId == addedEntries[i].acctEntryId) {
			addedEntries.splice(i, 1);
		}
	}
	addedEntries.push(obj);
}	

function saveAcctEntries(reload) {
	try {
		var objParameter = new Object();
		objParameter.addedEntries = prepareJsonAsParameter(addedEntries);
		objParameter.delEntries = prepareJsonAsParameter(deletedEntries);
		objParameter = JSON.stringify(objParameter);
		new Ajax.Request(contextPath+"/GIACAcctEntriesController?action=saveAcctEntries", {
			method: "GET",
			parameters: {gaccTranId: objACGlobal.gaccTranId,
						 parameters: objParameter},
			onCreate: function() {
				disableButton($("btnAddEntry"));
				disableButton($("btnDelEntry"));
				disableButton($("btnSaveEntry"));
				disableButton($("btnCancelEntry"));
				showNotice("Saving Accounting Entries, please wait...");
			},
			onComplete: function(response) {
				hideNotice();
				enableButton($("btnAddEntry"));
				enableButton($("btnSaveEntry"));
				enableButton($("btnCancelEntry"));
				if(checkErrorOnResponse(response)) {
					if(response.responseText == "SUCCESS") {
						showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
						changeTag = 0;
						if(reload) showDcbAcctEntries();
					} else {
						showMessageBox(response.responseText.replace("Error occured. ",""),imgMessage.ERROR);
					}
				}
			}
		});
	} catch(e) {
		showErrorMessage("saveAcctEntries", e);
	}
}

function checkInputs(newObj) {
	var glCodeTemp = "" + newObj.glAcctCategory + newObj.glControlAcct + newObj.glSubAcct1 +
	  newObj.glSubAcct2 + newObj.glSubAcct3 + newObj.glSubAcct4 +
	  newObj.glSubAcct5 + newObj.glSubAcct6 + newObj.glSubAcct7;
	var exists = false;
	
	if(newObj.generationType != "X") {
		showMessageBox("Update not allowed for this record.");
		return false;
	} else if($F("inputGlAcctCtgy").blank()) {
		showMessageBox("GL Account Category is Required.");
		$("inputGlAcctCtgy").focus();
		return false;
	} else if($F("inputGlCtrlAcct").blank()) {
		showMessageBox("Control Account is Required.");
		$("inputGlCtrlAcct").focus();
		return false;
	} else if($F("inputSubAcct1").blank()) {
		showMessageBox("GL Sub Account 1 is Required.");
		$("inputSubAcct1").focus();
		return false;
	} else if($F("inputSubAcct2").blank()) {
		showMessageBox("GL Sub Account 2 is Required.");
		$("inputSubAcct2").focus();
		return false;
	} else if($F("inputSubAcct3").blank()) {
		showMessageBox("GL Sub Account 3 is Required.");
		$("inputSubAcct3").focus();
		return false;
	} else if($F("inputSubAcct4").blank()) {
		showMessageBox("GL Sub Account 4 is Required.");
		$("inputSubAcct4").focus();
		return false;
	} else if($F("inputSubAcct5").blank()) {
		showMessageBox("GL Sub Account 5 is Required.");
		$("inputSubAcct5").focus();
		return false;
	} else if($F("inputSubAcct6").blank()) {
		showMessageBox("GL Sub Account 6 is Required.");	
		$("inputSubAcct6").focus();
		return false;
	} else if($F("inputSubAcct7").blank()) {
		showMessageBox("GL Sub Account 7 is Required.");
		$("inputSubAcct7").focus();
		return false;

	} else if(parseFloat(($F("inputDebitAmt")).replace(/,/g, "")) > 9999999999.99) {
		showMessageBox("Maximum value for Debit Amount is 9,999,999,999.99");
		return false;
	} else if(parseFloat(($F("inputCreditAmt")).replace(/,/g, "")) > 9999999999.99) {
		showMessageBox("Maximum value for Credit Amount is 9,999,999,999.99");
		return false;
	} else if(parseFloat(($F("inputDebitAmt")).replace(/,/g, "")) < 0 ||
			parseFloat(($F("inputCreditAmt")).replace(/,/g, "")) < 0) {
		showMessageBox("Negative Amounts are not Allowed.");
		return false;
	} else if($F("inputDebitAmt").blank() && $F("inputCreditAmt").blank()) {
		showMessageBox("Either debit or credit must have a value.");
		return false;
	} else if(isNaN(parseFloat(newObj.debitAmt))) {
		showMessageBox("Field must be of form 9,999,999,990.99.");
		return false;
	} else if(isNaN(parseFloat(newObj.creditAmt))) {
		showMessageBox("Field must be of form 9,999,999,990.99.");
		return false;
	} else if(!($F("hidSlTypeCd") == null || $F("hidSlTypeCd") == "") && 
			($F("txtSlName") == "" || $F("txtSlName") == null)) {
		showMessageBox("Sl Code/Name must be entered.");
		return false;
	} else {	
		return true;
	}
}

function closeTrans() {
	try {
		if(parseFloat(($("lblDifference").innerHTML).replace(/,/g, "")) != 0) {
			showMessageBox("Unable to Close Transaction. Debit and Credit Amounts are not Equal.");
		} else {
			new Ajax.Request(contextPath + "/GIACAcctEntriesController?action=closeTrans", {
				method: "POST",
				parameters: {gaccTranId: objACGlobal.gaccTranId},
				onCreate: function() {
					disableButton($("btnAddEntry"));
					disableButton($("btnDelEntry"));
					disableButton($("btnSaveEntry"));
					disableButton($("btnCancelEntry"));
					showNotice("Closing the transaction, please wait...");
				},
				onComplete: function(response) {
					hideNotice();
					enableButton($("btnAddEntry"));
					enableButton($("btnDelEntry"));
					enableButton($("btnSaveEntry"));
					enableButton($("btnCancelEntry"));
					if(checkErrorOnResponse(response)) {
						disableButton($("closeTrans"));
						showMessageBox("SUCCESS", imgMessage.SUCCESS);
					}
				}
			});
		}
	} catch(e) {
		showErrorMessage("closeTrans", e);
	}
}

function setAcctEntryObj(type) {
	// type = 0 -> add; type = 1 -> update
	try {
		var newObj = new Object();
		newObj.gaccTranId = $F("gaccTranId");
		newObj.gaccGfunFundCd = $F("gaccGfunFundCd");
		newObj.gaccGibrBranchCd = $F("gaccGibrBranchCd");
		if(type == 0) {
			newObj.acctEntryId = newEntryId == null ? 0 : newEntryId;
			newObj.generationType = "X";
			newObj.slCd = $("inputSlCd").value;	
			newObj.slTypeCd = $F("hidSlTypeCd");
			newObj.slSourceCd = 1;
			newObj.glAcctId = $F("inputGlAcctId");
		} else {
			newObj.acctEntryId = selectedEntry.acctEntryId;
			newObj.generationType = selectedEntry.generationType;
			newObj.slCd = selectedEntry.slCd;	
			newObj.slTypeCd = selectedEntry.slTypeCd;
			newObj.slSourceCd = selectedEntry.slSourceCd;
			newObj.glAcctId = selectedEntry.glAcctId;
		}
		newObj.glAcctCategory = formatToTwoDecimal(parseFloat($F("inputGlAcctCtgy")));
		newObj.glControlAcct = formatToTwoDecimal(parseFloat($F("inputGlCtrlAcct")));
		newObj.glSubAcct1 = formatToTwoDecimal(parseFloat($F("inputSubAcct1")));
		newObj.glSubAcct2 = formatToTwoDecimal(parseFloat($F("inputSubAcct2")));
		newObj.glSubAcct3 = formatToTwoDecimal(parseFloat($F("inputSubAcct3")));
		newObj.glSubAcct4 = formatToTwoDecimal(parseFloat($F("inputSubAcct4")));
		newObj.glSubAcct5 = formatToTwoDecimal(parseFloat($F("inputSubAcct5")));
		newObj.glSubAcct6 = formatToTwoDecimal(parseFloat($F("inputSubAcct6")));
		newObj.glSubAcct7 = formatToTwoDecimal(parseFloat($F("inputSubAcct7")));
		
		newObj.debitAmt = $F("inputDebitAmt") == null ? 0 : ($F("inputDebitAmt") == "" ? 0 : parseFloat($F("inputDebitAmt").replace(/,/g, "")));
		newObj.creditAmt = $F("inputCreditAmt") == null ? 0 : ($F("inputCreditAmt") == "" ? 0 : parseFloat($F("inputCreditAmt").replace(/,/g, "")));
		
		newObj.remarks = changeSingleAndDoubleQuotes($F("inputEntryRemarks")).escapeHTML();
		newObj.sapText = "";

		newObj.glAcctName = $F("inputGlAcctName");
		newObj.slName = $F("txtSlName") == "" ? null : $F("txtSlName");
		return newObj;			
	} catch(e) {
		showErrorMessage("setAcctEntryObj", e);
	}
}

function formatToTwoDecimal(num) {
	num = parseInt(num);
	return num.toPaddedString(2);
}

function showCloseTransError() {
	showMessageBox("Unable to close transaction when there are unsaved records.");
	return false;
}


createAcctEntriesRow(acctEntObjArray);
computeTotalsAE();

$("btnAddEntry").observe("click", function() {
	if(acctEntObjArray.length >= 1) {
		if($F("gaccTranFlag") == "C" || $F("gaccTranFlag") == "P") {
			showMessageBox("Insertion of record is not allowed for "+$F("dspTranFlag")+" transaction.");
			setSelectedAcctEntry(null);
		}
	} else {
		addAcctEntry();
	}
});

$("btnDelEntry").observe("click", function() {
	if(acctEntObjArray.length >= 1 && ($F("gaccTranFlag") == "C" || $F("gaccTranFlag") == "P")) { 
		showMessageBox("Deletion of record is not allowed for "+$F("dspTranFlag")+" transaction.");
		setSelectedAcctEntry(null);
	} else {
		delAcctEntry(selectedEntry);
	}
});

$("viewGlBal").observe("click", function() {
	showOverlayContent2(contextPath+"/GIACAcctEntriesController?action=viewGlBalance&gaccTranId="+
			objACGlobal.gaccTranId, "Accounting Entries", 800, "");
});
$("closeTrans").observe("click", function() {
	if(changeTag ==1) {
		showConfirmBox2("Confirmation", "There are unsaved records. Do you want to save them first?", "Yes", "No", 
				function() {
					saveAcctEntry();
					closeTrans();
				}
				, showCloseTransError);
	} else {
		closeTrans();
	}
});

$("searchGlAcct").observe("click", function() {
	if($F("hidGenType")=="X" || $F("hidGenType").blank()) {
		var keyword = $F("inputGlAcctName");
		var acctIdObj = new Object();
		showOverlayContent2(contextPath+"/GIACAcctEntriesController?action=showChartOfAccts&pageNo=1&gaccTranId="+
				objACGlobal.gaccTranId+"&acctIdObj="+JSON.stringify(acctIdObj)+"&act=0&keyword="+keyword,	//act = 0 > load overlay, 1 > go to page
				"Giac Chart of Accounts", 800, "");
	} else {
		showMessageBox("Update not allowed for this record.");
		return false;
	} 
});

$("searchSlCd").observe("click", function() {
	var slTypeCd = $F("hidSlTypeCd");
	if(slTypeCd == null || slTypeCd == "") {
		showMessageBox("No records.");
	} else {
		showSlListLOV(slTypeCd);
	}
});

$("editRemarksText").observe("click", function () {
	showEditor("inputEntryRemarks", 4000);
});

$("inputEntryRemarks").observe("keyup", function () {
	limitText(this, 4000);
});

$("inputGlAcctCtgy").observe("keyup", function() {
	limitText(this, 1);
});
$("inputGlCtrlAcct").observe("keyup", function() {
	limitText(this, 2);
});
$("inputSubAcct1").observe("keyup", function() {
	limitText(this, 2);
});
$("inputSubAcct2").observe("keyup", function() {
	limitText(this, 2);
});
$("inputSubAcct3").observe("keyup", function() {
	limitText(this, 2);
});
$("inputSubAcct4").observe("keyup", function() {
	limitText(this, 2);
});
$("inputSubAcct5").observe("keyup", function() {
	limitText(this, 2);
});
$("inputSubAcct6").observe("keyup", function() {
	limitText(this, 2);
});
$("inputSubAcct7").observe("keyup", function() {
	limitText(this, 2);
});

function clearGlCodeInputs() {
	$("inputGlAcctCtgy").clear();
	$("inputGlCtrlAcct").clear();
	$("inputSubAcct1").clear();
	$("inputSubAcct2").clear();
	$("inputSubAcct3").clear();
	$("inputSubAcct4").clear();
	$("inputSubAcct5").clear();
	$("inputSubAcct6").clear();
	$("inputSubAcct7").clear();
	$("inputGlAcctName").clear();
	
	$("inputSlName").clear();
	$("inputSlName").removeClassName("required");
	$("selectSlDiv").removeClassName("required");
}

$("inputGlAcctName").observe("keyup", function(e) {
	if (objKeyCode.BACKSPACE == e.keyCode && 
			document.getElementById("inputGlAcctName").getAttribute("readonly") == "readonly"
				){
		if($F("hidGenType")=="X" || $F("hidGenType").blank() ||  $F("hidGenType") == "") {
			clearGlCodeInputs();
			$("inputGlAcctName").removeAttribute("readonly");
		}
	}	
});

$("inputSlName").observe("keyup", function(e) {
	if (objKeyCode.BACKSPACE == e.keyCode && 
			document.getElementById("inputSlName").getAttribute("readonly") == "readonly"
				){
			$("inputSlName").clear();
			$("inputSlName").removeAttribute("readonly");
	}	
});

observeSaveForm("btnSaveEntry", function(){saveAcctEntries(true);});	
observeCancelForm("btnCancelEntry", function(){saveAcctEntries(false);}, editDCBInformation);
changeTag = 0;
initializeChangeTagBehavior(saveAcctEntries);
hideNotice();	 */ // dren 08.03.2015 : SR 0017729 - Comment out to rework jsp

	hideNotice();	// dren 08.03.2015 : SR 0017729 - Added to display Accounting Entries - Start -->
	setModuleId("GIACS042");
	setDocumentTitle("Accounting Entries");
	var checkEntry = JSON.parse('${checkManualEntry}');
	
	var sapSw = '${sapSw}' == null ? "N" : '${sapSw}';
	var userId = '${userId}';
	
	$("txtDebitTotal").value = formatCurrency('${totalDebitAmt}');
	$("txtCreditTotal").value = formatCurrency('${totalCreditAmt}');
	
	if(objACGlobal.previousModule == "GIACS003" && objACGlobal.callingForm == "ACCT_ENTRIES" && $("fundCd").value == ""){
		formatAcctEntriesField();
	}else if(objACGlobal.previousModule == "GIACS070" && objACGlobal.callingForm == "ACCT_ENTRIES" && $("fundCd").value == ""){
		formatAcctEntriesField();
	}
	
	var newEntryId = 100000;
	var prevCredit = 0;
	var prevDebit = 0;
	
	computeTotalsAE(0, 0);
	
	try{
		var objAcctEntriesArray = [];
		var objAccountingEntries = new Object();
		objAccountingEntries.objAccountingEntriesTableGrid = JSON.parse('${acctEntriesJSON}');
		objAccountingEntries.acctEntriesList = objAccountingEntries.objAccountingEntriesTableGrid.rows || [];
	
		var tableModel = {
				url: contextPath+"/GIACAcctEntriesController?action=showAcctEntriesTableGrid&refresh=1&gaccTranId="+objACGlobal.gaccTranId,
				options:{
					title: '',
					height: '270px',
					onCellFocus: function(element, value, x, y, id) {
						accountingEntriesTableGrid.keys.releaseKeys();
						var obj = accountingEntriesTableGrid.geniisysRows[y];
						populateAcctEntries(obj);
					},
					onRemoveRowFocus: function(){
						accountingEntriesTableGrid.keys.releaseKeys();
						populateAcctEntries(null);
					},
					onSort: function () {
						accountingEntriesTableGrid.keys.releaseKeys();
						populateAcctEntries(null);
					},
					beforeSort: function(){
						if(changeTag == 1){
							showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
									function(){
										showCloseDcbAcctEntries();
									}, 
									function(){
										showCloseDcbAcctEntries();
										changeTag = 0;
									}, "");
							return false;
						}else{
							return true;
						}
					},
					postPager: function () {
						accountingEntriesTableGrid.keys.releaseKeys();
						populateAcctEntries(null);
					},
					toolbar : {
						elements : [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN ],
						onRefresh: function(){
							accountingEntriesTableGrid.keys.releaseKeys();
							populateAcctEntries(null);
						},
						onFilter: function(){
							accountingEntriesTableGrid.keys.releaseKeys();
							populateAcctEntries(null);
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
						{	id: 'divCtrId',
							width: '0',
							visible: false
						},
						{	id: 'acctCode',
							title: 'GL Account Code',
							width: '230px',
							sortable: true,
			 			    filterOption : true
						},
						{	id: 'glAcctName',
							title: 'GL Account Name',
							width: '230px',
							sortable: true,
			 			    filterOption : true
						},
						{	id: 'slName',
							title: 'SL Name',
							width: '200px',
							sortable: true,
			 			    filterOption : true
						},
						{	id: 'debitAmt',
							title: 'Debit Amount',
							width: '100px',
							align: 'right',
							sortable: true,
			 			    filterOption : true,
						    renderer: function(value){
		            			return formatCurrency(value);
		            	    }
						},
						{	id: 'creditAmt',
							title: 'Credit Amount',
							width: '100px',
							align: 'right',
			 			    filterOption : true,
			 			    sortable: true,
						    renderer: function(value){
		            			return formatCurrency(value);
		            	    }
						},
						{	id: 'glAcctId',
							width: '0',
							visible: false
						},
						{	id: 'slCd',
							width: '0',
							visible: false
						},
						{	id: 'slTypeCd',
							width: '0',
							visible: false
						},
						{	id: 'generationType',
							width: '0',
							visible: false
						}
			],
			rows: objAccountingEntries.acctEntriesList
		};
		
		accountingEntriesTableGrid = new MyTableGrid(tableModel);
		accountingEntriesTableGrid.pager = objAccountingEntries.objAccountingEntriesTableGrid;
		accountingEntriesTableGrid.render('accountingEntriesTableGrid');
		accountingEntriesTableGrid.afterRender = function(){
			objAcctEntriesArray = accountingEntriesTableGrid.geniisysRows;
			totalDebitAmt = 0;
			totalCreditAmt = 0;
			
			if(objAcctEntriesArray.length != 0){
				totalDebitAmt = objAcctEntriesArray[0].totalDebitAmt;
				totalCreditAmt = objAcctEntriesArray[0].totalCreditAmt;
			}
	
			$("txtDebitTotal").value = formatCurrency(totalDebitAmt);
			$("txtCreditTotal").value = formatCurrency(totalCreditAmt);
			computeTotalsAE(0, 0);
		};
	}catch (e) {
		showErrorMessage("accountingEntries.jsp",e);
	}
	
	function computeTotalsAE(debitAmt, creditAmt) {
		try{
			var totalDebit = unformatCurrency("txtDebitTotal");
			var totalCredit= unformatCurrency("txtCreditTotal");
			
			totalDebit = parseFloat(totalDebit) - prevDebit + (parseFloat(debitAmt));
			totalCredit = parseFloat(totalCredit) - prevCredit + (parseFloat(creditAmt));
			
			$("txtDebitTotal").value = formatCurrency(totalDebit);
			$("txtCreditTotal").value = formatCurrency(totalCredit);
			
			var difference = parseFloat(totalDebit) - parseFloat(totalCredit);
			difference = roundNumber(parseFloat(difference), 2);
			
			if(difference < 0) {
				$("txtDifference").value = "<"+formatCurrency(Math.abs(difference))+">"
			} else {
				$("txtDifference").value = formatCurrency(difference);
			}
		}catch(e){
			showErrorMessage("computeTotalsAE", e);
		}
	}
	
	function populateAcctEntries(obj){
		if(obj == null){			
			resetFields();			
		}else{
			prevCredit = obj.creditAmt;
			prevDebit = obj.debitAmt;			
			$("inputGlAcctCtgy").value 	= parseInt(obj.glAcctCategory);
			$("inputGlCtrlAcct").value 	= parseInt(obj.glControlAcct).toPaddedString(2);
			$("inputSubAcct1").value 	= parseInt(obj.glSubAcct1).toPaddedString(2);
			$("inputSubAcct2").value 	= parseInt(obj.glSubAcct2).toPaddedString(2);
			$("inputSubAcct3").value 	= parseInt(obj.glSubAcct3).toPaddedString(2);
			$("inputSubAcct4").value 	= parseInt(obj.glSubAcct4).toPaddedString(2);
			$("inputSubAcct5").value 	= parseInt(obj.glSubAcct5).toPaddedString(2);
			$("inputSubAcct6").value 	= parseInt(obj.glSubAcct6).toPaddedString(2);
			$("inputSubAcct7").value 	= parseInt(obj.glSubAcct7).toPaddedString(2);				
			$("inputGlAcctName").value 	= unescapeHTML2(obj.glAcctName);
			$("inputSlName").value 		= unescapeHTML2(obj.slName);
			$("inputDebitAmt").value 	= formatCurrency(obj.debitAmt);
			$("inputCreditAmt").value 	= formatCurrency(obj.creditAmt);
			$("inputEntryRemarks").value = unescapeHTML2(obj.remarks);			
			$("hiddenAcctEntryId").value = obj.acctEntryId;
			$("hiddenGlAcctId").value	= obj.glAcctId;
			$("hiddenSlCd").value 		= obj.slCd;
			$("hiddenGenType").value 	= obj.generationType;
			$("hiddenSlTypeCd").value 	= obj.slTypeCd;
			$("hiddenFundCd").value 	= obj.gaccGfunFundCd;
			$("hiddenBranchCd").value 	= obj.gaccGibrBranchCd;
			$("hiddenSlSourceCd").value = obj.slSourceCd;
		
			if (obj.slName == "" || obj.slName == null || objAC.fromMenu == "cancelOR" || objAC.fromMenu == "cancelOtherOR" || objAC.tranFlagState == "C" || objACGlobal.queryOnly == "Y"){
				$("inputSlName").removeClassName("required");
				$("selectSlDiv").removeClassName("required");
				$("inputSlName").style.backgroundColor = "#FFFFFF";
			}else{
				$("inputSlName").addClassName("required");
				$("selectSlDiv").addClassName("required");
				$("inputSlName").style.backgroundColor = "#FFFACD";
			}			
			$("inputGlAcctCtgy").setAttribute("readonly", "readonly");
			$$("input[type='text'].glAC").each(function (m) {
				m.setAttribute("readonly", "readonly");
			});
		}
	}
	
	function resetFields(){
		$("inputGlAcctCtgy").value 	 = "";
		$("inputGlCtrlAcct").value 	 = "";
		$("inputSubAcct1").value 	 = "";
		$("inputSubAcct2").value 	 = "";
		$("inputSubAcct3").value 	 = "";
		$("inputSubAcct4").value 	 = "";
		$("inputSubAcct5").value 	 = "";
		$("inputSubAcct6").value 	 = "";
		$("inputSubAcct7").value 	 = "";
		$("inputGlAcctName").value 	 = "";
		$("inputDebitAmt").value 	 = "";
		$("inputCreditAmt").value 	 = "";
		$("inputEntryRemarks").value = "";
		$("inputSlName").value 		 = "";		
		$("hiddenGlAcctId").value 	 = "";
		$("hiddenSlCd").value 		 = "";
		$("hiddenSlTypeCd").value 	 = "";
	}
			
	$("reloadForm").stopObserving("click")
	$("reloadForm").observe("click", function(){
		showCloseDcbAcctEntries();
	});		

	$("btnCancelEntry").stopObserving("click")
	$("btnCancelEntry").observe("click", function(){
		editDCBInformation();
	});	
				
	$("acExit").stopObserving("click");
	$("acExit").observe("click", function(){
		updateMainContentsDiv("/GIACAccTransController?action=showDCBListing", "Retrieving DCB list, please wait...");
		hideAccountingMainMenus();
	});			
	
	window.scrollTo(0,0); 
	populateAcctEntries(null);
	changeTag = 0;
	
	initializeAll();
	addStyleToInputs();
	initializeAllMoneyFields();	// dren 08.03.2015 : SR 0017729 - Added to display Accounting Entries - End -->
</script>