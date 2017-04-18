<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="mainNav" name="mainNav">
	<!-- <div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
		<ul>
			<li><a id="billPaymentExit">Exit</a></li>
		</ul>
	</div> -->
	
</div>
<%-- <jsp:include page="/pages/toolbar.jsp"></jsp:include> --%> <!-- Commented out by Jerome 08.09.2016 SR 5600 -->
<div id="billPaymentMainDiv" name="billPaymentMainDiv" style="width:100%; float: left; margin-bottom: 50px;">
<div id="toolbarDiv" name="toolbarDiv"> <!-- Added by Jerome 08.09.2016 SR 5600 -->
		<div class="toolButton">
			<span style="background: url(${pageContext.request.contextPath}/images/toolbar/enterQuery.png) left center no-repeat;" id="btnToolbarEnterQuery">Enter Query</span>
			<span style="display: none; background: url(${pageContext.request.contextPath}/images/toolbar/enterQueryDisabled.png) left center no-repeat;" id="btnToolbarEnterQueryDisabled">Enter Query</span>
		</div>
		<div class="toolButton" style="float: right;">
			<span style="background: url(${pageContext.request.contextPath}/images/toolbar/exit.png) left center no-repeat;" id="btnToolbarExit">Exit</span>
			<span style="display: none; background: url(${pageContext.request.contextPath}/images/toolbar/exitDisabled.png) left center no-repeat;" id="btnToolbarExitDisabled">Exit</span>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>View Payments per Bill</label> 
		</div>
	</div>
	<div id="billPaymentBodyDiv" class="sectionDiv">
				<table cellspacing="0" width="100%" align="center" style="margin: 20px 0 20px 0">
					<tr>
						<td class="rightAligned">Bill No.</td>
						<td class="leftAligned" style="width: 340px">
							<!-- <input class="leftAligned billNoReq allCaps" type="text" id="txtBillIssCd" name="txtBillIssCd" maxlength="2" style="width: 30px;" tabindex="101"/> 
							<input class="rightAligned billNoReq integerUnformatted" lpad="12" type="text" id="txtPremSeqNo" name="txtPremSeqNo" maxlength="12" style= "width: 270px;" tabindex="102"/> -->
							<span class="lovSpan required" style="float: left; width: 70px; margin-right: 5px; margin-top: 2px; height: 21px;"> <!--lmbelran SR19577 07062015 -->
								<input class="leftAligned billNoReq allCaps editable required" ignoreDelKey="" type="text" id="txtBillIssCd" name="txtBillIssCd" style="width: 45px; float: left; border: none; height: 15px; margin: 0;" maxlength="2" tabindex="101" lastValidValue=""/> 
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIssCd" name="searchIssCd" alt="Go" style="float: right;" />
							</span>
							<span class="lovSpan required" style="float: left; width: 248px; margin-right: 5px; margin-top: 2px; height: 21px;"> <!--lmbelran SR19577 07062015 -->
								<input class="rightAligned billNoReq integerUnformatted required" lpad="12" ignoreDelKey="" type="text" id="txtPremSeqNo" name="txtPremSeqNo" style="width: 220px; float: left; border: none; height: 15px; margin: 0;" maxlength="14" tabindex="102" lastValidValue=""/> 
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBillNo" name="searchBillNo" alt="Go" style="float: right;" tabindex="103"/>
							</span>
						</td>
						<td class="rightAligned" style="width: 110px">Due Date</td>
						<td class="leftAligned">
							<div style="float: left; width: 202px;" class="withIconDiv">
								<input type="text" id="txtDueDate" name="txtDueDate" class="withIcon disableDelKey" readonly="readonly" style="width: 176px;" tabindex="149"/>
								<img id="hrefDueDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Due Date" onclick="scwShow($('txtDueDate'),this, null);" tabindex="150"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Assured</td>
						<td colspan="3" class="leftAligned">
							<span class="lovSpan" style="width: 70px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input type="text" id="txtAssuredNo" name="txtAssuredNo" style="width: 43px; float: left; border: none; height: 13px;" class="disableDelKey integerUnformatted" lpad="6" maxlength="7" tabindex="103" lastValidValue = ""/>								
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchAssuredNo" name="searchAssuredNo" alt="Go" style="float: right;" tabindex="104"/>
							</span>
							<input type="text" id="txtDesignation" name="txtDesignation" style="width: 70px; float: left;" readonly="readonly" tabindex="105"/>
							<span class="lovSpan" style="width: 502px; height: 21px; margin: 2px 0 0 4px; float: left;">
								<input type="text" id="txtAssuredName" name="txtAssuredName" style="width: 472px; float: left; border: none; height: 13px;" class="disableDelKey allCaps" maxlength="500" tabindex="106" lastValidValue = ""/>								
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchAssuredName" name="searchAssuredName" alt="Go" style="float: right;" tabindex="107"/>
							</span>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Policy No.</td>
						<td colspan="3" class="leftAligned">
							<input class="polNoReq" type="hidden" id="hidPolicyId" lastValidValue="">
							<input class="polNoReq allCaps"  type="text" id="txtPolLineCd" name="txtPolLineCd" lastValidValue="" style="width: 60px; float: left; margin: 2px 4px 0 0" maxlength="2" tabindex="108"/>
							<input class="polNoReq allCaps" type="text" id="txtPolSublineCd" name="txtPolSublineCd" lastValidValue="" style="width: 65px; float: left; margin: 2px 4px 0 0" maxlength="7" tabindex="109"/>
							<input class="polNoReq allCaps" type="text" id="txtPolIssCd" name="txtPolIssCd" lastValidValue="" style="width: 30px; float: left; margin: 2px 4px 0 0" maxlength="2" tabindex="110"/>
							<input class="polNoReq integerUnformatted" lpad="2" type="text" id="txtPolIssueYr" lastValidValue="" name="txtPolIssueYr" style="width: 30px; float: left; margin: 2px 4px 0 0" maxlength="3" tabindex="111"/>
							<input class="polNoReq integerUnformatted" lpad="7" type="text" id="txtPolSeqNo" lastValidValue="" name=""txtPolSeqNo"" style="width: 65px; float: left; margin: 2px 4px 0 0" maxlength="8" tabindex="112"/>
							<span class="lovSpan" style="width: 45px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input class="polNoReq integerUnformatted" lpad="2" type="text" id="txtPolRenewNo" name="txtPolRenewNo" lastValidValue="" style="height: 15px; margin: 0px; border: none; width: 20px; float: left;" maxlength="3" tabindex="113"/>							
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchPolicyNo" name="searchPolicyNo" alt="Go" style="float: right;" tabindex="118"/>
							</span> <!-- Dren 06292015 : SR 0004613 - Added LOV for policy no.-->																		
							<label style="float: left; margin-left: 4px; margin-top: 5px;" >-</label>
							<input class="allCaps" type="text" id="txtEndtIssCd" name="txtEndtIssCd" style="width: 30px; float: left; margin: 2px 4px 0 5px" maxlength="2" tabindex="114"/>
							<input class="integerUnformatted" lpad="2" type="text" id="txtEndtIssueYr" name="txtEndtIssueYr" style="width: 30px; float: left; margin: 2px 4px 0 0" maxlength="3" tabindex="115"/>
							<input class="integerUnformatted" lpad="6" type="text" id="txtEndtSeqNo" name="txtEndtSeqNo" style="width: 65px; float: left;" maxlength="7" tabindex="116"/>
							<input type="text" id="txtEndtType" name="txtEndtType" style="width: 30px; float: left; margin-left: 4px;" class="disableDelKey" maxlength="1" tabindex="117" lastValidValue = "" readonly="readonly" />
							<%-- andrew - 08042015 - SR 19643 
							<span class="lovSpan" style="width: 50px; height: 21px; margin: 2px 0 0 4px; float: left;">
								<input type="text" id="txtEndtType" name="txtEndtType" style="width: 20px; float: left; border: none; height: 13px;" class="disableDelKey" maxlength="1" tabindex="117" lastValidValue = ""/>								
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchEndtType" name="searchEndtType" alt="Go" style="float: right;" tabindex="118"/>
							</span> --%>
							<label style="float: left; margin-left: 2px; margin-top: 5px;" >/</label>
							<input class="allCaps" type="text" id="txtRefPolNo" name="txtRefPolNo" style="width: 71px; margin-left: 2px;" maxlength="30" tabindex="119"/> <!-- Dren 06292015 : SR 0004613 - Adjust width to accommodate additional space for LOV -->
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Package Policy/Bill</td>
						<td id="packPolicyNo" colspan="3" class="leftAligned">
							<input class="packPolicyNo" type="hidden" id="hidPackPolicyId" lastValidValue="">
							<input class="packPolicyNo allCaps" type="text" id="txtPackLineCd" name="txtPackLineCd" lastValidValue="" style="width: 60px; float: left; margin: 2px 4px 0 0" maxlength="2" tabindex="120"/>
							<input class="packPolicyNo allCaps" type="text" id="txtPackSublineCd" name="txtPackSublineCd" lastValidValue="" style="width: 65px; float: left; margin: 2px 4px 0 0" maxlength="7" tabindex="121"/>
							<input class="packPolicyNo allCaps" type="text" id="txtPackIssCd" name="txtPackIssCd" lastValidValue="" style="width: 30px; float: left; margin: 2px 4px 0 0" maxlength="2" tabindex="122"/>
							<input class="packPolicyNo integerUnformatted" lpad="2" type="text" id="txtPackIssueYr" lastValidValue="" name="txtPackIssueYr" style="width: 30px; float: left; margin: 2px 4px 0 0" maxlength="3" tabindex="123"/>
							<input class="packPolicyNo integerUnformatted" lpad="7" type="text" id="txtPackSeqNo" lastValidValue="" name="txtPackSeqNo" style="width: 65px; float: left; margin: 2px 4px 0 0" maxlength="8" tabindex="124"/>
							<span class="lovSpan" lpad="2" style="width: 45px; height: 21px; margin: 2px 0 0 0; float: left;">
								<input class="packPolicyNo integerUnformatted disableDelKey" type="text" id="txtPackRenewNo" lastValidValue="" name="txtPackRenewNo" style="width: 20px; float: left; border: none; height: 13px;" maxlength="3" tabindex="125"/>							
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchPackPolicy" name="searchPackPolicy" alt="Go" style="float: right;" tabindex="126"/>
							</span>
							<label style="float: left; margin-top: 5px; margin-left: 5px;" >-</label>
							<input class="allCaps" type="text" id="txtPackEndtIssCd" name="txtEndtIssCd" style="width: 30px; float: left; margin: 2px 4px 0 5px" maxlength="2" tabindex="127"/>
							<input class="integerUnformatted" lpad="2" type="text" id="txtPackEndtIssueYr" name="txtEndtIssueYr" style="width: 30px; float: left; margin: 2px 4px 0 0" maxlength="3" tabindex="128"/>
							<input class="integerUnformatted" lpad="6" type="text" id="txtPackEndtSeqNo" name="txtEndtSeqNo" style="width: 65px; float: left; margin: 2px 4px 0 0" maxlength="7" tabindex="129"/>
							<label style="float: left; margin-top: 5px;" >/</label>
							<input class="allCaps" type="text" id="txtPackBillIssCd" name="txtPackBillIssCd" style="width: 30px; margin-left: 2px; float: left;" maxlength="2" tabindex="130"/>
							<input class="integerUnformatted" lpad="7" type="text" id="txtPackBillPremSeqNo" name="txtPackBillPremSeqNo" maxlength="7" style="width: 72px; float: left; margin: 2px 4px 0 4px" tabindex="131"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Intermediary</td>
						<td colspan="3" class="leftAligned">
							<span class="lovSpan" style="width: 66px; height: 21px; margin: 2px 0 0 0; float: left;">
								<input type="text" id="txtIntmType" name="txtIntmType" style="width: 35px; float: left; border: none; height: 13px;" class="disableDelKey allCaps" maxlength="2" tabindex="131" lastValidValue = ""/>								
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIntmType" name="searchIntmType" alt="Go" style="float: right;" tabindex="132"/>
							</span>
							<span class="lovSpan" style="width: 121px; height: 21px; margin: 2px 0 0 4px; float: left;">
								<input lastValidValue = "" type="text" id="txtIntmNo" name="txtIntmNo" style="width: 90px; float: left; border: none; height: 13px;" class="disableDelKey integerUnformatted rightAligned" lpad="12" maxlength="12" tabindex="133"/>								
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIntmNo" name="searchIntmNo" alt="Go" style="float: right;" tabindex="134"/>
							</span>
							<span class="lovSpan" style="width: 80px; height: 21px; margin: 2px 0 0 4px; float: left;">
								<input lastValidValue = "" type="text" id="txtRefIntmCd" name="txtRefIntmCd" style="width: 50px; float: left; border: none; height: 13px;" class="disableDelKey allCaps" maxlength="10" tabindex="135"/>								
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchRefIntmCd" name="searchRefIntmCd" alt="Go" style="float: right;" tabindex="136"/>
							</span>
							<span class="lovSpan" style="width: 375px; height: 21px; margin: 2px 0 0 4px; float: left;">
								<input lastValidValue = "" type="text" id="txtIntmName" name="txtIntmName" style="width: 345px; float: left; border: none; height: 13px;" class="disableDelKey allCaps" maxlength="240" tabindex="137"/>								
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIntmName" name="searchIntmName" alt="Go" style="float: right;" tabindex="138"/>
							</span>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Inception Date</td>
						<td class="leftAligned">
							<div style="float: left; width: 110px;" class="withIconDiv">
								<input type="text" id="txtInceptionDate" name="txtInceptionDate" class="withIcon disableDelKey" readonly="readonly" style="width: 85px;" tabindex="139"/>
								<img id="hrefInceptionDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Inception Date" onclick="scwShow($('txtInceptionDate'),this, null);" tabindex="140"/>
							</div>
						<label class="rightAligned" style="margin: 5px 5px 0 20px;">Expiry Date</label>
							<div style="float: left; width: 110px;" class="withIconDiv">
								<input type="text" id="txtExpiryDate" name="txtExpiryDate" class="withIcon disableDelKey" readonly="readonly" style="width: 85px;" tabindex="141"/>
								<img id="hrefExpiryDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Expiry Date" onclick="scwShow($('txtExpiryDate'),this, null);" tabindex="142"/>
							</div>
						</td>
						<td class="rightAligned">
							<label class="toLocal rightAligned" id = "lblIssueDate"  style="width: 110px;">Issue Date</label>
							<label class="toForen rightAligned"  id = "lblCurrencyDesc" style="width: 110px; display: none;">Currency</label>
						</td>
						<td class="leftAligned">
							<div id = "issueDateDiv" style="float: left; width: 202px; margin: 3px 0 3px 0 " class="withIconDiv toLocal">
								<input type="text" id="txtIssueDate" name="txtIssueDate" class="withIcon disableDelKey" readonly="readonly" style="width: 176px;" tabindex="151"/>
								<img id="hrefIssueDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Issue Date" onclick="scwShow($('txtIssueDate'),this, null);" tabindex="152"/>
							</div>
							<input class="toForen" type="text" id="txtCurrencyDesc" name="txtCurrencyDesc" style="width: 196px; display: none;"  readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Policy Status</td>
						<td class="leftAligned">
							<input class="allCaps" type="text" id="txtPolFlag" name="txtPolFlag" style="width: 80px;" readonly="readonly" maxlength="1" tabindex="143"/>
							<input type="text" id="txtPolStatus" name="txtPolStatus" style="width: 105px;" readonly="readonly" maxlength="30" tabindex="144"/>
							<input type="text" id="txtRegPolSw" name="txtRegPolSw" style="width: 104px;" readonly="readonly" maxlength="30" tabindex="145"/>
						</td>
						<td class="rightAligned">
							<label class="toLocal rightAligned" id = "lblPremAmt" style="width: 110px;">Premium Amount</label>
							<label class="toForen rightAligned" id = "lblCurrencyRt" style="width: 110px; display: none;">Conversion Rate</label>
						</td>
						<td class="leftAligned">
							<input class="rightAligned toLocal" type="text" id="txtPhpPrem" name="txtPhpPrem" style="width: 196px;"  readonly="readonly"/>
							<input class="rightAligned toForen" type="text" id="txtCurrencyRt" name="txtCurrencyRt" style="width: 196px; display: none;"  readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Insured Name</td>
						<td class="leftAligned">
							<input class="allCaps" type="text" id="txtInsured" name="txtInsured" readonly="readonly" style="width: 313px;" maxlength="50" tabindex="146"/>
						</td>
						<td class="rightAligned">
							<label class="rightAligned toLocal" id = "lblTaxAmt" style="width: 110px;">Tax Amount</label>
							<label class="rightAligned toForen" id = "lblForenPremAmt" style="width: 110px; display: none;">Premium Amount</label>
						</td>
						<td class="leftAligned">
							<input class="rightAligned toLocal" type="text" id="txtPhpTax" name="txtPhpTax" style="width: 196px;"  readonly="readonly"/>
							<input class="rightAligned toForen" type="text" id="txtForenPrem" name="txtForenPrem" style="width: 196px; display: none;"  readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Property</td>
						<td class="leftAligned">
							<input class="allCaps" type="text" id="txtProperty" name="txtProperty" readonly="readonly" style="width: 313px;" maxlength="100" tabindex="147"/>
						</td>
						<td class="rightAligned">
							<label class="rightAligned toLocal" id = "lblOtherCharges" style="width: 110px;">Other Charges</label>
							<label class="rightAligned toForen" id = "lblForenTaxAmt" style="width: 110px; display: none;">Tax Amount</label>
						</td>
						<td class="leftAligned">
							<input class="rightAligned toLocal" type="text" id="txtPhpCharges" name="txtPhpCharges" style="width: 196px;"  readonly="readonly"/>
							<input class="rightAligned toForen" type="text" id="txtForenTax" name="txtForenTax" style="width: 196px; display: none;"  readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Payment Terms</td>
						<td class="leftAligned">
							<input class="allCaps" type="text" id="txtPaytTerm" readonly="readonly" name="txtPaytTerm" style="width: 313px;" maxlength="3" tabindex="148"/>
						</td>
						<td class="rightAligned">
							<label class="rightAligned toLocal" id = "lblTotalAmountDue" style="width: 110px;">Total Amount Due</label>
							<label class="rightAligned toForen" id = "lblForenOtherCharges" style="width: 110px; display: none;">Other Charges</label>
						</td>
						<td class="leftAligned">
							<input class="rightAligned toLocal" type="text" id="txtTotalAmountDue" name="txtTotalAmountDue" style="width: 196px;" readonly="readonly"/>
							<input class="rightAligned toForen" type="text" id="txtForenOtherCharges" name="txtForenOtherCharges" style="width: 196px; display: none;" readonly="readonly"/>
						</td>
					</tr>
					<tr style="height: 45px;">
						<td></td>
						<td class="leftAligned" style="padding: 15px 0 0 20px;">
							<input type="hidden" id="hidCurrencyCd" name="hidCurrencyCd"/>
							<input type="hidden" id="hidCurrencyRt" name="hidCurrencyRt"/>
							<input type="button" class="button" id="btnPremium" name="btnPremium" value="Premium" style="width: 95px;"/>
							<input type="button" class="button" id="btnTaxes" name="btnTaxes" value="Taxes" style="width: 95px;"/>
							<input type="button" class="button" id="btnCommission" name="btnCommission" value="Commission" style="width: 95px;"/>
						</td>
						<td class="rightAligned">
							<label class="rightAligned toLocal" id = "lblNetDue" style="width: 110px;">Net Due</label>
							<label class="rightAligned toForen" id = "lblForenTotalAmountDue" style="width: 110px; display: none; margin-bottom: 18px;">Total Amount Due</label>
						</td>
						<td class="leftAligned">
								<input class="rightAligned toLocal" type="text" id="txtNetDue" name="txtNetDue" style="width: 196px;"  readonly="readonly"/>
								<input class="rightAligned toForen" type="text" id="txtForenTotalAmountDue" name="txtForenTotalAmountDue" style="width: 196px; display: none;  margin-bottom: 18px;" readonly="readonly"/>
						</td>
					</tr>
				</table>
	</div>
	<div id="billPaymentTableDiv" class="sectionDiv">
		<div id="billPaymentTable" style="padding: 15px 20px 5px 20px; height: 250px;">
		</div>
		<div id="billPaymentTable2" style="padding: 15px 20px 5px 20px; height: 250px;">
		</div>
		<div class="buttonDiv" id="billPaymentTableButtonDiv" style="float: left; width: 44%; margin: 22px 0 10px 60px;">
			<input type="button" class="button" id="btnPDCPayment" name="btnPDCPayment" value="PDC Payments" style="width: 130px;"/>
			<input type="button" class="button" id="btnBalance" name="btnBalance" value="Balances" style="width: 110px;"/>
			<input type="button" class="button" id="btnCurrencyInfo" name="btnCurrencyInfo" value="Currency Information" style="width: 150px;"/>
		</div>
		<div id="billPaymentTableTotalDiv" style="float: right; width: 45%; margin: 0 20px 30px 20px;" >
			<table align = "right" cellspacing = "0">
				<tr>
					<td class="rightAligned">Total</td>
					<td class="leftAligned"><input class="rightAligned toForen" type="text" id="forenTotal" name="forenTotal" style="width: 150px;" readonly="readonly"/></td>
					<td class="leftAligned"><input class="rightAligned" type="text" id="collectionTotal" name="collectionTotal" style="width: 150px;" readonly="readonly"/></td>
				</tr>
				<tr>
					<td class="rightAligned">Balance Due</td>
					<td class="leftAligned"><input class="rightAligned toForen" type="text" id="forenBalance" name="forenBalance" style="width: 150px;" readonly="readonly"/></td>
					<td class="leftAligned"><input class="rightAligned" type="text" id="balanceDue" name="balanceDue" style="width: 150px;" readonly="readonly"/></td>
				</tr>
			</table>
		</div>
		<input type="hidden" id="hidToForeign" value="0">
	</div>
</div>

<script>
	//hideToolbarButton("btnToolbarExecuteQuery"); //Commented out by Jerome 08.09.2016 SR 5600
	//$("btnToolbarEnterQuerySep").hide();
	initializeAll();
	setModuleId("GIACS211");
	setDocumentTitle("View Payments per Bill");
	var giacs211GipiInvoice = [];
	
	try {
		var jsonBillPayment = JSON.parse('${jsonGiacDirectPremCollnsTg}');
		billPaymentTableModel = {
			url : contextPath+ "/GIACInquiryController?action=showBillPayment&refresh=1",
			options : {
				height : '250px',
				pager : {},
				onCellFocus : function(element, value, x, y, id) {
					tbgBillPayment.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					tbgBillPayment.keys.releaseKeys();
				},
				onSort : function(){
					tbgBillPayment.keys.releaseKeys();
				},
				postPager : function() {
					tbgBillPayment.keys.releaseKeys();
				},
				toolbar : {
					elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
					onFilter : function(){
						tbgBillPayment.keys.releaseKeys();
					},
					onRefresh : function(){
						tbgBillPayment.keys.releaseKeys();
						populateTotal(tbgBillPayment.geniisysRows);
					}
				}
			},
			columnModel : [ 
				{
				    id: 'recordStatus',
				    width: '0',
				    visible: false
				},
				{
					id: 'divCtrId',
					width: '0',
					visible: false 
				},
				{
					id : "gibrBranchCd",
					title : "Branch",
					width : '70px',
					filterOption : true
				}, 
				{
					id : "tranClass",
					title : "Class",
					width : '70px',
					filterOption : true
				},
				{
					id : "tranClassNo",
					title : "Class No.",
					width : '70px',
					align : "right",
					titleAlign: "right",
					filterOption : true,
					renderer : function(value) {
						return value == '' ? '' : formatNumberDigits(value,5); 
					}
				},
				{
					id : "jvNo",
					title : "JV No.",
					width : '70px',
					align : "right",
					titleAlign: "right",
					filterOption : true
				},
				{
					id : "tranYear",
					title : "Year",
					width : '70px',
					align : "right",
					filterOptionType: 'number',
					titleAlign: "right",
					filterOption : true
				},
				{
					id : "tranMonth",
					title : "Month",
					width : '70px',
					align : "right",
					titleAlign: "right",
					filterOptionType: 'number',
					filterOption : true,
					renderer : function(value) {
						return value == '' ? '' : formatNumberDigits(value,2); 
					}
				},
				{
					id : "tranSeqNo",
					title : "Seq No.",
					width : '70px',
					align : "right",
					titleAlign: "right",
					filterOptionType: 'number',
					filterOption : true,
					renderer : function(value) {
						return value == '' ? '' : formatNumberDigits(value,5); 
					}
				},
				{
					id : "tranDateChar",
					title : "Tran Date",
					width : '80px',
					align : "center",
					titleAlign: "center",
					filterOptionType: 'formattedDate',
					filterOption : true
				},
				{
					id : "dspOrNo",
					title : "Reference No.",
					width : '90px',
					align : "left",
					filterOption : true
				},
				{
					id : "transactionType",
					title : "T",
					width : '30px',
					align : "center",
					titleAlign: "center"
					//filterOption : true
				},
				{
					id : "currDesc2",
					width : '0',
					visible : false
				},
				{
					id : "convRate2",
					width : '0',
					visible : false
				},
				{
					id : "forenColl",
					width : '0',
					visible : false
				},
				{
					id : "collectionAmt",
					title : "Amount",
					align : "right",
					titleAlign: "right",
					width : '130px',
					filterOptionType: 'number',
					filterOption : true,
					renderer : function(value) {
				    	return formatCurrency(value);
				    }
				},
				{
					id : "balanceDue",
					width : '0',
					visible : false
				},
				{
					id : "totalCollAmt",
					width : '0',
					visible : false
				},
				{
					id : "forenBalance",
					width : '0',
					visible : false
				},
				{
					id : "forenTotal2",
					width : '0',
					visible : false
				},
			],
			rows : jsonBillPayment.rows
		};
		tbgBillPayment = new MyTableGrid(billPaymentTableModel);
		tbgBillPayment.pager = jsonBillPayment;
		tbgBillPayment.render('billPaymentTable');
	} catch (e) {
		showErrorMessage("billPayment.jsp", e);
	}
	
	try {
		var jsonBillPayment2 = JSON.parse('${jsonGiacDirectPremCollnsTg}');
		billPaymentTableModel2 = {
			url : contextPath+ "/GIACInquiryController?action=getGIACS211GiacDirectPremCollns&issCd="+$F("txtBillIssCd")+
																						  "&premSeqNo="+$F("txtPremSeqNo")+
																						  "&currencyCd="+$F("hidCurrencyCd")+
																						  "&currencyRt="+$F("hidCurrencyRt"),
			options : {
				width : '881px',
				height : '250px',
				pager : {},
				onCellFocus : function(element, value, x, y, id) {
					tbgBillPayment2.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					tbgBillPayment2.keys.releaseKeys();
				},
				onSort : function(){
					tbgBillPayment2.keys.releaseKeys();
				},
				postPager : function() {
					tbgBillPayment2.keys.releaseKeys();
				},
				toolbar : {
					elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
					onFilter : function(){
						tbgBillPayment2.keys.releaseKeys();
					},
					onRefresh : function(){
						tbgBillPayment2.keys.releaseKeys();
					}
				}
			},
			columnModel : [ 
				{
				    id: 'recordStatus',
				    width: '0',
				    visible: false
				},
				{
					id: 'divCtrId',
					width: '0',
					visible: false 
				},
				{
					id : "gibrBranchCd",
					title : "Branch",
					width : '70px',
					filterOption : true
				}, 
				{
					id : "tranClass",
					title : "Class",
					width : '70px',
					filterOption : true
				},
				{
					id : "tranClassNo",
					title : "Class No.",
					width : '70px',
					align : "right",
					titleAlign: "right",
					filterOption : true,
					renderer : function(value) {
						return value == '' ? '' : formatNumberDigits(value,5); 
					}
				},
				{
					id : "jvNo",
					title : "JV No.",
					width : '70px',
					align : "right",
					titleAlign: "right",
					filterOption : true
				},
				{
					id : "tranYear",
					title : "Year",
					width : '70px',
					align : "right",
					filterOptionType: 'number',
					titleAlign: "right",
					filterOption : true
				},
				{
					id : "tranMonth",
					title : "Month",
					width : '70px',
					align : "right",
					filterOptionType: 'number',
					titleAlign: "right",
					filterOption : true,
					renderer : function(value) {
						return value == '' ? '' : formatNumberDigits(value,2); 
					}
				},
				{
					id : "tranSeqNo",
					width : '0',
					visible : false
				},
				{
					id : "tranDateChar",
					width : '0',
					visible : false
				},
				{
					id : "dspOrNo",
					width : '0',
					visible : false
				},
				{
					id : "transactionType",
					width : '0',
					visible : false
				},
				{
					id : "currDesc2",
					title : "Currency",
					width : '70px',
					filterOption : true
				},
				{
					id : "convRate2",
					title : "Rate",
					align : "right",
					titleAlign: "right",
					width : '70px',
					filterOption : true,
					/*renderer : function(value) {
				    	return formatCurrency(value);
				    }*/
				},
				{
					id : "forenColl",
					title : "Equivalent Amounts",
					align : "right",
					titleAlign: "right",
					filterOptionType: 'number',
					width : '130px',
					filterOption : true,
					renderer : function(value) {
				    	return formatCurrency(value);
				    }
				},
				{
					id : "collectionAmt",
					title : "Amount",
					align : "right",
					titleAlign: "right",
					width : '130px',
					filterOptionType: 'number',
					filterOption : true,
					renderer : function(value) {
				    	return formatCurrency(value);
				    }
				}
			],
			rows : jsonBillPayment2.rows
		};
		tbgBillPayment2 = new MyTableGrid(billPaymentTableModel2);
		tbgBillPayment2.pager = jsonBillPayment2;
		tbgBillPayment2.render('billPaymentTable2');
	} catch (e) {
		showErrorMessage("billPayment.jsp 2nd TableGrid", e);
	}
	
	function showGiisIntermediaryLov(id){
		try{
			LOV.show({
				controller : "ACCreditsAndCollectionInquiryLOVController",
				urlParameters : {
								action   : "getGiisIntermediaryLov",
								moduleId : "GIACS211",
								issCd : $F("txtBillIssCd"),
								premSeqNo : $F("txtPremSeqNo"),
								policyId : $F("hidPolicyId"),
								packPolicyId : $F("hidPackPolicyId"),
								packBillIssCd : $F("txtPackBillIssCd"),
								packBillPremSeqNo : $F("txtPackBillPremSeqNo"),
								assdNo : $F("txtAssuredNo"),
								dueDate : $F("txtDueDate"),
								inceptDate : $F("txtInceptionDate"),
								expiryDate : $F("txtExpiryDate"),
								issueDate : $F("txtIssueDate"),
								intmType : $F("txtIntmType"),
								filterText : ($(id).readAttribute("lastValidValue").trim() != $F(id).trim() ? $F(id).trim() : "%"),
								page : 1
				},
				title: "List of Intermediaries",
				width: 550,
				height: 400,
				columnModel: [
		 			{
						id : 'intmNo',
						title: 'Intm No.',
						width : '80px',
						align: 'right',
						titleAlign : 'right'
					},
					{
						id : 'refIntmCd',
						title: 'Reference Code',
						width : '100px',
						align: 'left'
					},
					{
						id : 'intmName',
						title: 'Intermediary Name',
					    width: '350px',
					    align: 'left'
					}
				],
				draggable: true,
				autoSelectOneRecord: true,
				filterText : ($(id).readAttribute("lastValidValue").trim() != $F(id).trim() ? $F(id).trim() : ""),
				onSelect: function(row) {
					if(row != undefined){
						$("txtIntmNo").value = lpad(row.intmNo,12,'0');
						$("txtRefIntmCd").value = unescapeHTML2(row.refIntmCd);
						$("txtIntmName").value = unescapeHTML2(row.intmName);
						enableToolbarButton("btnToolbarEnterQuery");
						//enableToolbarButton("btnToolbarExecuteQuery"); //Commented out by Jerome 08.09.2016 SR 5600
						$("txtIntmNo").setAttribute("lastValidValue", lpad(row.intmNo,12,'0'));
						$("txtRefIntmCd").setAttribute("lastValidValue", unescapeHTML2(row.refIntmCd));
						$("txtIntmName").setAttribute("lastValidValue", unescapeHTML2(row.intmName));
					}
				},
				onCancel: function (){
					$("txtIntmNo").value = $("txtIntmNo").readAttribute("lastValidValue");
					$("txtRefIntmCd").value = $("txtRefIntmCd").readAttribute("lastValidValue");
					$("txtIntmName").value = $("txtIntmName").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtIntmNo").value = $("txtIntmNo").readAttribute("lastValidValue");
					$("txtRefIntmCd").value = $("txtRefIntmCd").readAttribute("lastValidValue");
					$("txtIntmName").value = $("txtIntmName").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
			});
		}catch(e){
			showErrorMessage("showGiisIntermediaryLov",e);
		}
	}
	
	$("hrefDueDate").observe("click", function () {
	    scwNextAction = function(){
	    					if($F("txtDueDate") != ""){
	    						enableToolbarButton("btnToolbarEnterQuery");	    						
	    					}	    					
	    				}.runsAfterSCW(this, null);
	    
	    scwShow($("txtDueDate"),this, null);
	});
	
	$("hrefInceptionDate").observe("click", function () {
	    scwNextAction = function(){
	    					if($F("txtInceptionDate") != ""){
	    						enableToolbarButton("btnToolbarEnterQuery");	    						
	    					}	    					
	    				}.runsAfterSCW(this, null);
	    
	    scwShow($("txtInceptionDate"),this, null);
	});	
	
	$("hrefExpiryDate").observe("click", function () {
	    scwNextAction = function(){
	    					if($F("txtExpiryDate") != ""){
	    						enableToolbarButton("btnToolbarEnterQuery");	    						
	    					}	    					
	    				}.runsAfterSCW(this, null);
	    
	    scwShow($("txtExpiryDate"),this, null);
	});
	
	$("hrefIssueDate").observe("click", function () {
	    scwNextAction = function(){
	    					if($F("txtIssueDate") != ""){
	    						enableToolbarButton("btnToolbarEnterQuery");	    						
	    					}	    					
	    				}.runsAfterSCW(this, null);
	    
	    scwShow($("txtIssueDate"),this, null);
	});	
	
	function showGiisIntmTypeLov(){
		try{
			LOV.show({
				controller : "ACCreditsAndCollectionInquiryLOVController",
				urlParameters : {
									action   : "getGiisIntmTypeLov",
									moduleId : "GIACS211",
									issCd : $F("txtBillIssCd"),
									premSeqNo : $F("txtPremSeqNo"),
									policyId : $F("hidPolicyId"),
									packPolicyId : $F("hidPackPolicyId"),
									packBillIssCd : $F("txtPackBillIssCd"),
									packBillPremSeqNo : $F("txtPackBillPremSeqNo"),
									assdNo : $F("txtAssuredNo"),
									intmNo : $F("txtIntmNo"),
									dueDate : $F("txtDueDate"),
									inceptDate : $F("txtInceptionDate"),
									expiryDate : $F("txtExpiryDate"),
									issueDate : $F("txtIssueDate"),
									filterText : ($("txtIntmType").readAttribute("lastValidValue").trim() != $F("txtIntmType").trim() ? $F("txtIntmType").trim() : "%"),
									page : 1
				},
				title: "List of Intermediary Types",
				width: 420,
				height: 400,
				columnModel: [
		 			{
						id : 'intmType',
						title: 'Type',
						width : '100px',
						align: 'left'
					},
					{
						id : 'intmDesc',
						title: 'Description',
						width : '300px',
						align: 'left'
					}
				],
				draggable: true,
				autoSelectOneRecord: true,
				filterText : ($("txtIntmType").readAttribute("lastValidValue").trim() != $F("txtIntmType").trim() ? $F("txtIntmType").trim() : ""),
				onSelect: function(row) {
					if(row != undefined){
						$("txtIntmType").value = unescapeHTML2(row.intmType);
						$("txtIntmType").setAttribute("lastValidValue",unescapeHTML2(row.intmType));
						enableToolbarButton("btnToolbarEnterQuery");
						//enableToolbarButton("btnToolbarExecuteQuery"); //Commented out by Jerome 08.09.2016 SR 5600
					}
				},
				onCancel: function (){
					$("txtIntmType").value = $("txtIntmType").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtIntmType").value = $("txtIntmType").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
			});
		}catch(e){
			showErrorMessage("showGiisIntmTypeLov",e);
		}
	}
	
	function showCgRefCodesLov(){
		try{
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
								 action   : "getCgRefCodesLov",
								 findText2 : ($("txtEndtType").readAttribute("lastValidValue").trim() != $F("txtEndtType").trim() ? $F("txtEndtType").trim() : "%"),
								 page : 1
				},
				title: "Valid Values for Endt Type",
				width: 500,
				height: 400,
				columnModel: [
		 			{
						id : 'rvLowValue',
						title: 'Value',
						width : '70px',
						align: 'right',
						titleAlign : 'right'
					},
					{
						id : 'rvMeaning',
						title: 'Meaning',
						width : '230px',
						align: 'left'
					},
					{
						id : 'rvAbbreviation',
						title: 'Abbreviation',
					    width: '100px',
					    align: 'left'
					}
				],
				draggable: true,
				autoSelectOneRecord: true,
				filterText : ($("txtEndtType").readAttribute("lastValidValue").trim() != $F("txtEndtType").trim() ? $F("txtEndtType").trim() : ""),
				onSelect: function(row) {
					if(row != undefined){
						$("txtEndtType").value = unescapeHTML2(row.rvLowValue);
						enableToolbarButton("btnToolbarEnterQuery");
						//enableToolbarButton("btnToolbarExecuteQuery"); //Commented out by Jerome 08.09.2016 SR 5600
						$("txtEndtType").setAttribute("lastValidValue", unescapeHTML2(row.rvLowValue));
					}
				},
				onCancel: function (){
					$("txtEndtType").value = $("txtEndtType").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtEndtType").value = $("txtEndtType").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
			});
		}catch(e){
			showErrorMessage("showCgRefCodesLov",e);
		}
	}
	
	function showGiacs211AssuredLov(id){
		try{
			LOV.show({
				controller : "ACCreditsAndCollectionInquiryLOVController",
				urlParameters : {
								 action   : "showGiacs211AssuredLov",
								 moduleId : "GIACS211",
								 packPolicyId : $F("hidPackPolicyId"),
						         packBillIssCd : $F("txtPackBillIssCd"),
						         packBillPremSeqNo : $F("txtPackBillPremSeqNo"),
						         policyId : $F("hidPolicyId"),
						         intmNo : $F("txtIntmNo"),
						         dueDate : $F("txtDueDate"),
						       	 inceptDate : $F("txtInceptionDate"),
						       	 expiryDate : $F("txtExpiryDate"),
						       	 issueDate : $F("txtIssueDate"),
						       	 billIssCd : $F("txtBillIssCd"),
								 filterText : ($(id).readAttribute("lastValidValue").trim() != $F(id).trim() ? $F(id).trim() : "%"),
								 page : 1
				},
				title: "List of Assured",
				width: 500,
				height: 400,
				columnModel: [
		 			{
						id : 'assdNo',
						title: 'Assured No.',
						width : '80px',
						align: 'right',
						titleAlign: 'right'
					},
					{
						id : 'assdName',
						title: 'Assured Name',
						width : '380px',
						align: 'left'
					}
				],
				draggable: true,
				autoSelectOneRecord: true,
				filterText : ($(id).readAttribute("lastValidValue").trim() != $F(id).trim() ? $F(id).trim() : ""),
				onSelect: function(row) {
					if(row != undefined){
						if($F("txtAssuredNo") != "" && parseInt($F("txtAssuredNo")) != row.assdNo){
							clearFields();
						}
						
						$("txtAssuredNo").value = lpad(row.assdNo,6,'0');
						$("txtAssuredName").value = unescapeHTML2(row.assdName);
						enableToolbarButton("btnToolbarEnterQuery");
						//enableToolbarButton("btnToolbarExecuteQuery"); //Commented out by Jerome 08.09.2016 SR 5600
						
						$("txtAssuredNo").setAttribute("lastValidValue", lpad(row.assdNo,6,'0'));
						$("txtAssuredName").setAttribute("lastValidValue", unescapeHTML2(row.assdName));
					}
				},
				onCancel: function (){
					$("txtAssuredNo").value = $("txtAssuredNo").readAttribute("lastValidValue");
					$("txtAssuredName").value = $("txtAssuredName").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtAssuredNo").value = $("txtAssuredNo").readAttribute("lastValidValue");
					$("txtAssuredName").value = $("txtAssuredName").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
			});
		}catch(e){
			showErrorMessage("showGiacs211AssuredLov",e);
		}
	}
	
	function newFormInstance() {
		try{
			disableToolbarButton("btnToolbarEnterQuery");
			//disableToolbarButton("btnToolbarExecuteQuery"); //Commented out by Jerome 08.09.2016 SR 5600
			$("collectionTotal").value  = "0.00";
			$("balanceDue").value  		= "0.00";
			$("txtBillIssCd").focus();
			$("txtPremSeqNo").readOnly = true;
			disableSearch("searchBillNo");
			hideArray = ["forenTotal","forenBalance","billPaymentTable2"];
			for ( var i = 0; i < hideArray.length; i++) {
				$(hideArray[i]).hide();
			}
			$$("div#billPaymentMainDiv input[type='button']").each(function (a) {
				disableButton(a);
			});
			if(objACGlobal.callingForm == "GIACS221" || objACGlobal.callingForm == "GIACS288"){ //pag tinawag siya ng mga module na yan mag-i-execute query agad.
				getGipiInvoiceInfo(objACGlobal.callingForm, objACGlobal.hideGIACS211Obj.issCd, objACGlobal.hideGIACS211Obj.premSeqNo, objACGlobal.hideGIACS211Obj.intmNo);
				disableAllFields();
			}else if (objACGlobal.callingForm == "GIACS211" && (objACGlobal.issCd != null && objACGlobal.issCd != "") && (objACGlobal.premSeqNo != null && objACGlobal.premSeqNo != "")) {
				disableAllFields();
				enableToolbarButton("btnToolbarEnterQuery");
				getGipiInvoiceInfo("GIACS211", objACGlobal.issCd, objACGlobal.premSeqNo);
			}
			if(objACGlobal.previousModule == "GIACS288"){
				disableToolbarButton("btnToolbarEnterQuery");
			}
		}catch (e) {
			showErrorMessage("newFormInstance",e);
		}
	}
	function setGipiInvoiceInfoFilter() {
		try{
			var obj = new Object();
			obj.dueDate = $F("txtDueDate").trim();
			obj.assdNo = $F("txtAssuredNo").trim();
			obj.assdName = $F("txtAssuredName").trim();
			obj.dspLineCd = $F("txtPolLineCd").trim();
			obj.dspSublineCd = $F("txtPolSublineCd").trim();
			obj.dspIssCd = $F("txtPolIssCd").trim();
			obj.dspIssueYy = $F("txtPolIssueYr").trim();
			obj.dspPolSeqNo = $F("txtPolSeqNo").trim();
			obj.dspRenewNo = $F("txtPolRenewNo").trim();
			obj.dspEndtIssCd = $F("txtEndtIssCd").trim();
			obj.dspEndtYy = $F("txtEndtIssueYr").trim();
			obj.dspEndtSeqNo = $F("txtEndtSeqNo").trim();
			obj.dspEndtType = $F("txtEndtType").trim();
			obj.refPolNo = $F("txtRefPolNo").trim();
			
			obj.packLineCd = $F("txtPackLineCd").trim();
			obj.packSublineCd = $F("txtPackSublineCd").trim();
			obj.packIssCd = $F("txtPackIssCd").trim();
			obj.packIssueYy = $F("txtPackIssueYr").trim();
			obj.packPolSeqNo = $F("txtPackSeqNo").trim();
			obj.packRenewNo = $F("txtPackRenewNo").trim();
			obj.packEndtIssCd = $F("txtPackEndtIssCd");
			obj.packEndtYy = $F("txtPackEndtIssueYr");
			obj.packEndtSeqNo = $F("txtPackEndtSeqNo");
			obj.packBillIssCd = $F("txtPackBillIssCd");
			obj.packBillPremSeqNo = $F("txtPackBillPremSeqNo");
			
			obj.intmType = $F("txtIntmType").trim();
			obj.intrmdryIntmNo = $F("txtIntmNo").trim();
			obj.refIntmCd = $F("txtRefIntmCd").trim();
			obj.intmName = $F("txtIntmName").trim();
			obj.inceptDateChar = $F("txtInceptionDate").trim();
			obj.expiryDateChar = $F("txtExpiryDate").trim();
			obj.issueDateChar = $F("txtIssueDate").trim();
			obj.polFlag = $F("txtPolFlag").trim();
			obj.insured = $F("txtInsured").trim();
			obj.property = $F("txtProperty").trim();
			obj.paytTerms = $F("txtPaytTerm").trim();
			return obj;
		}catch (e) {
			showErrorMessage("setGipiInvoiceInfoFilter",e);
		}
	}
	
	function getGipiInvoiceInfo(moduleId,issCd,premSeqNo,intmNo) { //added by steven 10.28.2014 "intmNo"
		try{
			
			new Ajax.Request(contextPath+"/GIACInquiryController",{
				method: "POST",
				parameters : {action : "getGIACS211GipiInvoice",
					          moduleId : moduleId,
					          issCd : issCd,
					          premSeqNo : premSeqNo,
					          intmNo : nvl(intmNo,""),
					          objFilter : JSON.stringify(setGipiInvoiceInfoFilter())},
				asynchronous: true,
				evalScripts: true,
				onCreate: function (){
					showNotice("Loading, please wait...");
				},
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						var result = JSON.parse(response.responseText);
						giacs211GipiInvoice = result.rows[0];
						if (result.rows.length> 0){
							getBillDetails(giacs211GipiInvoice);
						}
						/* var result = JSON.parse(response.responseText);
						giacs211GipiInvoice = result.rows[0];
						if (result.rows.length> 0) {
							populateGipiInvoice(giacs211GipiInvoice);
							getBillPaymentTbg(giacs211GipiInvoice.issCd,giacs211GipiInvoice.premSeqNo,giacs211GipiInvoice.currencyCd,giacs211GipiInvoice.currencyRt,giacs211GipiInvoice.polFlag,giacs211GipiInvoice.totalAmtDue);
							$$("div#billPaymentMainDiv input[type='button']").each(function (a) {
								enableButton(a);
							});
						} else {
							showMessageBox("Query caused no records to be retrieved. Re-enter.","I");
						} */
					}
				}
			});
		} catch(e){
			showErrorMessage("getGipiInvoiceInfo", e);
		}
	}
	function getBillPaymentTbg(issCd,premSeqNo,currencyCd,currencyRt,polFlag,totalAmtDue) {
		try{
			tbgBillPayment.url = contextPath+ "/GIACInquiryController?action=getGIACS211GiacDirectPremCollns&issCd="+issCd+
																										  "&premSeqNo="+premSeqNo+
																										  "&currencyCd="+currencyCd+
																										  "&currencyRt="+currencyRt+
																										  "&polFlag="+polFlag+
																										  "&totalAmtDue="+totalAmtDue;
			tbgBillPayment._refreshList();
			
			tbgBillPayment2.url = contextPath+ "/GIACInquiryController?action=getGIACS211GiacDirectPremCollns&issCd="+issCd+
																										  "&premSeqNo="+premSeqNo+
																										  "&currencyCd="+currencyCd+
																										  "&currencyRt="+currencyRt+
																										  "&polFlag="+polFlag+
																										  "&totalAmtDue="+totalAmtDue;
			tbgBillPayment2._refreshList();
			populateTotal(tbgBillPayment.geniisysRows);
		} catch(e){
			showErrorMessage("getBillPaymentTbg", e);
		}
	}
	
	function populatePolicyNo(obj){
		try{
			$("hidPolicyId").value = obj == null ? "" : obj.policyId;
			$("hidPolicyId").writeAttribute("lastValidValue", nvl(obj.policyId,""));
			$("txtPolLineCd").value = obj == null ? "" : nvl(obj.dspLineCd,"");
			$("txtPolLineCd").writeAttribute("lastValidValue", nvl(obj.dspLineCd,""));
			$("txtPolSublineCd").value = obj == null ? "" : nvl(obj.dspSublineCd,"");
			$("txtPolSublineCd").writeAttribute("lastValidValue", nvl(obj.dspSublineCd,""));
			$("txtPolIssCd").value = obj == null ? "" : nvl(obj.dspIssCd,"");
			$("txtPolIssCd").writeAttribute("lastValidValue", nvl(obj.dspIssCd,""));
			$("txtPolIssueYr").value = obj == null ? "" : lpad(nvl(obj.dspIssueYy,""),2,'0');
			$("txtPolIssueYr").writeAttribute("lastValidValue", lpad(nvl(obj.dspIssueYy,""),2,'0'));
			$("txtPolSeqNo").value = obj == null ? "" : lpad(nvl(obj.dspPolSeqNo,""),7,'0');
			$("txtPolSeqNo").writeAttribute("lastValidValue", lpad(nvl(obj.dspPolSeqNo,""),7,'0'));
			$("txtPolRenewNo").value = obj == null ? "" : lpad(nvl(obj.dspRenewNo,""),2,'0');
			$("txtPolRenewNo").writeAttribute("lastValidValue", lpad(nvl(obj.dspRenewNo,""),2,'0'));
			$("txtEndtIssCd").value = obj == null ? "" : nvl(obj.dspEndtIssCd,"");
			$("txtEndtIssueYr").value = obj == null ? "" : obj.dspIssueYy == null? "" : lpad(obj.dspEndtYy,2,'0');
			$("txtEndtSeqNo").value = obj == null ? "" : obj.dspEndtSeqNo == null? "" : lpad(obj.dspEndtSeqNo,6,'0');
			$("txtEndtType").value = obj == null ? "" : nvl(obj.dspEndtType,"");
			$("txtRefPolNo").value = obj == null ? "" : nvl(obj.refPolNo,"");
			$("txtEndtType").writeAttribute("lastValidValue", nvl(obj.dspEndtType,""));
		} catch(e){
			showErrorMessage("populatePolicyNo", e);
		}
	}
	
	function populatePackPolicyNo(obj){
		try{
			$("hidPackPolicyId").value = obj == null ? "" : nvl(obj.packPolicyId,"");
			$("hidPackPolicyId").writeAttribute("lastValidValue", nvl(obj.packPolicyId,""));
			$("txtPackLineCd").value = obj == null ? "" : nvl(obj.packLineCd,"");
			$("txtPackLineCd").writeAttribute("lastValidValue", nvl(obj.packLineCd,""));
			$("txtPackSublineCd").value = obj == null ? "" : nvl(obj.packSublineCd,"");
			$("txtPackSublineCd").writeAttribute("lastValidValue", nvl(obj.packSublineCd,""));
			$("txtPackIssCd").value = obj == null ? "" : nvl(obj.packIssCd,"");
			$("txtPackIssCd").writeAttribute("lastValidValue", nvl(obj.packIssCd,""));
			$("txtPackIssueYr").value = obj == null ? "" : obj.packIssueYy == null? "" : lpad(obj.packIssueYy,2,'0');
			$("txtPackIssueYr").writeAttribute("lastValidValue", lpad(obj.packIssueYy,2,'0'));
			$("txtPackSeqNo").value = obj == null ? "" : obj.packPolSeqNo == null? "" : lpad(obj.packPolSeqNo,7,'0');
			$("txtPackSeqNo").writeAttribute("lastValidValue", lpad(obj.packPolSeqNo,7,'0'));
			$("txtPackRenewNo").value = obj == null ? "" :  obj.packRenewNo == null? "" : lpad(obj.packRenewNo,2,'0');
			$("txtPackRenewNo").writeAttribute("lastValidValue", lpad(obj.packRenewNo,2,'0'));
			$("txtPackEndtIssCd").value	= obj == null ? "" : nvl(obj.packEndtIssCd,"");
			$("txtPackEndtIssueYr").value = obj == null ? "" : obj.packEndtYy == null? "" : lpad(obj.packEndtYy,2,'0');
			$("txtPackEndtSeqNo").value = obj == null ? "" : obj.packEndtSeqNo == null? "" : lpad(obj.packEndtSeqNo,6,'0');
			$("txtPackBillIssCd").value = obj == null ? "" : nvl(obj.packBillIssCd,"");
			$("txtPackBillPremSeqNo").value = obj == null ? "" : obj.packBillPremSeqNo == null? "" : lpad(obj.packBillPremSeqNo,7,'0');
		} catch(e){
			showErrorMessage("populatePackPolicyNo", e);
		}
	}	
	
	function clearFields() {
		try{
			$("txtBillIssCd").value	= "";
			$("txtBillIssCd").writeAttribute("lastValidValue", "");
			$("txtPremSeqNo").value	= "";
			$("txtDueDate").value = "";
			$("txtAssuredNo").value = "";
			$("txtAssuredNo").writeAttribute("lastValidValue", "");
			$("txtDesignation").value = "";
			$("txtAssuredName").value = "";
			$("hidPolicyId").value = "";
			$("hidPolicyId").writeAttribute("lastValidValue", "");
			$("txtPolLineCd").value = "";
			$("txtPolSublineCd").value = "";
			$("txtPolIssCd").value = "";
			$("txtPolIssueYr").value = "";
			$("txtPolSeqNo").value = "";
			$("txtPolRenewNo").value = "";
			$("txtEndtIssCd").value = "";
			$("txtEndtIssueYr").value = "";
			$("txtEndtSeqNo").value = "";
			$("txtEndtType").value = "";
			$("txtEndtType").writeAttribute("lastValidValue", "");
			$("txtRefPolNo").value = "";
			
			$("hidPackPolicyId").value = "";
			$("hidPackPolicyId").writeAttribute("lastValidValue", "");
			$("txtPackLineCd").value = "";  
			$("txtPackSublineCd").value = "";
			$("txtPackIssCd").value = "";
			$("txtPackIssueYr").value = "";
			$("txtPackSeqNo").value = "";
			$("txtPackRenewNo").value = "";
			$("txtPackEndtIssCd").value = "";
			$("txtPackEndtIssueYr").value = "";
			$("txtPackEndtSeqNo").value = "";
			$("txtPackBillIssCd").value = "";
			$("txtPackBillPremSeqNo").value = "";
			
			$("txtIntmType").value = "";
			$("txtIntmType").writeAttribute("lastValidValue", "");
			$("txtIntmNo").value = "";
			$("txtIntmNo").writeAttribute("lastValidValue", "");
			$("txtRefIntmCd").value = "";
			$("txtIntmName").value = ""; 
			$("txtInceptionDate").value = "";
			$("txtExpiryDate").value = "";
			$("txtIssueDate").value = "";
		} catch(e){
			showErrorMessage("clearFields", e);
		}
	}
	
	function populateGipiInvoice(obj) {
		try{
			$("txtBillIssCd").value 			= obj			== null ? "" : nvl(obj.issCd,"");
			$("txtPremSeqNo").value 			= obj			== null ? "" : lpad(nvl(obj.premSeqNo,""),12,'0');
			$("txtDueDate").value 				= obj			== null ? "" : nvl(obj.dueDateChar,"");
			$("txtAssuredNo").value 			= obj			== null ? "" : lpad(nvl(obj.assdNo,""),6,'0');
			$("txtDesignation").value 			= obj			== null ? "" : unescapeHTML2(nvl(obj.designation,""));
			$("txtAssuredName").value 			= obj			== null ? "" : unescapeHTML2(nvl(obj.assdName,""));
			$("hidPolicyId").value  			= obj			== null ? "" : obj.policyId;
			$("txtPolLineCd").value 			= obj			== null ? "" : nvl(obj.dspLineCd,"");
			$("txtPolSublineCd").value 			= obj			== null ? "" : nvl(obj.dspSublineCd,"");
			$("txtPolIssCd").value 				= obj 	 		== null ? "" : nvl(obj.dspIssCd,"");
			$("txtPolIssueYr").value			= obj  			== null ? "" : lpad(nvl(obj.dspIssueYy,""),2,'0');
			$("txtPolSeqNo").value  			= obj  			== null ? "" : lpad(nvl(obj.dspPolSeqNo,""),7,'0');
			$("txtPolRenewNo").value  			= obj  			== null ? "" : lpad(nvl(obj.dspRenewNo,""),2,'0');
			$("txtEndtIssCd").value 			= obj			== null ? "" : nvl(obj.dspEndtIssCd,"");
			$("txtEndtIssueYr").value 			= obj			== null ? "" : obj.dspIssueYy == null? "" : lpad(obj.dspEndtYy,2,'0');
			$("txtEndtSeqNo").value 			= obj			== null ? "" : obj.dspEndtSeqNo == null? "" : lpad(obj.dspEndtSeqNo,6,'0');
			$("txtEndtType").value 				= obj 	 		== null ? "" : nvl(obj.dspEndtType,"");
			$("txtRefPolNo").value				= obj  			== null ? "" : nvl(obj.refPolNo,"");
			
			$("hidPackPolicyId").value  		= obj  			== null ? "" : nvl(obj.packPolicyId,"");
			$("txtPackLineCd").value  			= obj  			== null ? "" : nvl(obj.packLineCd,"");  
			$("txtPackSublineCd").value  		= obj  			== null ? "" : nvl(obj.packSublineCd,"");
			$("txtPackIssCd").value 			= obj			== null ? "" : nvl(obj.packIssCd,"");
			$("txtPackIssueYr").value 			= obj			== null ? "" : obj.packIssueYy == null? "" : lpad(obj.packIssueYy,2,'0');
			$("txtPackSeqNo").value 			= obj			== null ? "" : obj.packPolSeqNo == null? "" : lpad(obj.packPolSeqNo,7,'0');
			$("txtPackRenewNo").value 			= obj 	 		== null ? "" :  obj.packRenewNo == null? "" : lpad(obj.packRenewNo,2,'0');
			$("txtPackEndtIssCd").value			= obj  			== null ? "" : nvl(obj.packEndtIssCd,"");
			$("txtPackEndtIssueYr").value  		= obj  			== null ? "" : obj.packEndtYy == null? "" : lpad(obj.packEndtYy,2,'0');
			$("txtPackEndtSeqNo").value  		= obj  			== null ? "" : obj.packEndtSeqNo == null? "" : lpad(obj.packEndtSeqNo,6,'0');
			$("txtPackBillIssCd").value 		= obj			== null ? "" : nvl(obj.packBillIssCd,"");
			$("txtPackBillPremSeqNo").value 	= obj			== null ? "" : obj.packBillPremSeqNo == null? "" : lpad(obj.packBillPremSeqNo,7,'0');
			
			$("txtIntmType").value 				= obj			== null ? "" : nvl(obj.intmType,"");
			$("txtIntmNo").value 				= obj 	 		== null ? "" : lpad(nvl(obj.intrmdryIntmNo,""),12,'0');
			$("txtRefIntmCd").value				= obj  			== null ? "" : nvl(obj.refIntmCd,"");
			$("txtIntmName").value  			= obj  			== null ? "" : unescapeHTML2(nvl(obj.intmName,"")); 
			$("txtInceptionDate").value  		= obj  			== null ? "" : nvl(obj.inceptDateChar,"");
			$("txtExpiryDate").value  			= obj  			== null ? "" : nvl(obj.expiryDateChar,"");
			$("txtIssueDate").value  			= obj  			== null ? "" : nvl(obj.issueDateChar,"");
			$("txtPolFlag").value  				= obj  			== null ? "" : unescapeHTML2(nvl(obj.polFlag,""));
			$("txtPolStatus").value  			= obj  			== null ? "" : unescapeHTML2(nvl(obj.policyStatus,""));
			$("txtRegPolSw").value  			= obj  			== null ? "" : unescapeHTML2(nvl(obj.regPolicySw,""));
			$("txtPhpPrem").value  				= obj  			== null ? "" : formatCurrency(nvl(obj.phpPrem,""));
			$("txtInsured").value  				= obj  			== null ? "" : unescapeHTML2(nvl(obj.insured,""));
			$("txtPhpTax").value  				= obj  			== null ? "" : formatCurrency(nvl(obj.phpTax,""));
			$("txtProperty").value  			= obj  			== null ? "" : unescapeHTML2(nvl(obj.property,""));
			$("txtPhpCharges").value  			= obj  			== null ? "" : formatCurrency(nvl(obj.phpCharges,""));
			$("txtPaytTerm").value  			= obj  			== null ? "" : unescapeHTML2(nvl(obj.paytTerms,""));
			$("txtTotalAmountDue").value  		= obj  			== null ? "" : formatCurrency(nvl(obj.totalAmtDue,""));
			$("txtNetDue").value  				= obj  			== null ? "" : formatCurrency(nvl(obj.netPremium,""));
			$("hidCurrencyCd").value  			= obj  			== null ? "" : nvl(obj.currencyCd,"");
			$("hidCurrencyCd").value  			= obj  			== null ? "" : nvl(obj.currencyRt,"");
			$("txtCurrencyDesc").value  		= obj  			== null ? "" : unescapeHTML2(nvl(obj.currDesc,""));
			$("txtCurrencyRt").value  			= obj  			== null ? "" : obj.currencyRt /*formatCurrency(nvl(obj.currencyRt,""))*/;
			$("txtForenPrem").value  			= obj  			== null ? "" : formatCurrency(nvl(obj.forenPrem,""));
			$("txtForenTax").value  			= obj  			== null ? "" : formatCurrency(nvl(obj.forenTax,""));
			$("txtForenOtherCharges").value  	= obj  			== null ? "" : formatCurrency(nvl(obj.forenCharges,""));
			$("txtForenTotalAmountDue").value  	= obj  			== null ? "" : formatCurrency(nvl(obj.forenTotal,""));
			$("txtTotalAmountDue").setAttribute("lastValidValue", obj == null ? "" : nvl(obj.totalAmtDue,""));
		} catch(e){
			showErrorMessage("populateGipiInvoice", e);
		}
	}
	
	function populateTotal(obj) {
		try{
			obj = obj[obj.length -1];
			$("collectionTotal").value  = obj  			== null ? "" : formatCurrency(nvl(obj.totalCollAmt,0));
			$("balanceDue").value  		= obj  			== null ? "" : formatCurrency(nvl(obj.balanceDue,0));
			$("forenBalance").value  	= obj  			== null ? "" : formatCurrency(nvl(obj.forenBalance,0));
			$("forenTotal").value  		= obj  			== null ? "" : formatCurrency(nvl(obj.forenTotal2,0));
			
			if(tbgBillPayment.geniisysRows.length == 1 && tbgBillPayment.geniisysRows[0].gaccTranId == null){
				tbgBillPayment.deleteAllRows();
				tbgBillPayment2.deleteAllRows();
			}
		} catch(e){
			showErrorMessage("populateTotal", e);
		}
	}
	
	function checkBillNo() {
		var isOk = true;
		$$("div#billPaymentBodyDiv input[type='text'].billNoReq").each(function (a) {
			if ($F(a).trim() == "") {
				isOk = false;
				return isOk;
			}
		});
		return isOk;
	}
	function checkPolicyNo() {
		var isOk = true;
		$$("div#billPaymentBodyDiv input[type='text'].polNoReq").each(function (a) {
			if ($F(a).trim() == "") {
				isOk = false;
				return isOk;
			}
		});
		return isOk;
	}
	
	function disableAllFields(disableExecute) {
		try{
			//if (disableExecute != false) disableToolbarButton("btnToolbarExecuteQuery"); //Commented out by Jerome 08.09.2016 SR 5600
			$$("div#billPaymentBodyDiv input[type='text']").each(function (a) {
				$(a).readOnly="true";
			});
			$$("div#billPaymentBodyDiv img").each(function (img) {
				var src = img.src;
				if(nvl(img, null) != null){
					if(src.include("searchIcon.png")){
						disableSearch(img);
					}else if(src.include("but_calendar.gif")){
						disableDate(img); 
					}
				}
			});
		} catch(e){
			showErrorMessage("disableAllFields", e);
		}
	}
	
	function hideAndSeek(toHideClass,toShowClass) {
		$$("div#billPaymentMainDiv input[type='text']."+toShowClass+", div#billPaymentMainDiv label."+toShowClass+", div."+toShowClass).each(function (a) {
			$(a).show();
		});
		$$("div#billPaymentMainDiv input[type='text']."+toHideClass+", div#billPaymentMainDiv label."+toHideClass+", div."+toHideClass).each(function (a) {
			$(a).hide();
		});
	}
	
	function showPremiumOverlay() {
		try{
			overlayPremiumInfo = Overlay.show(contextPath+"/GIACInquiryController?action=showPremiumOverlay&issCd=" + $F("txtBillIssCd") + "&premSeqNo=" + $F("txtPremSeqNo")
									+"&toForeign="+$F("hidToForeign"), 
					{urlContent: true,
					 title: "Premium Details",
					 height: 265,
					 width: 600,
					 draggable: false
					});
		}catch (e) {
			showErrorMessage("showPremiumOverlay",e);
		}
	}
	
	function showTaxesOverlay() {
		try{
			overlayTaxesInfo = Overlay.show(contextPath+"/GIACInquiryController?action=showTaxesOverlay&issCd=" + $F("txtBillIssCd") + "&premSeqNo=" + $F("txtPremSeqNo") +"&currencyRt="+$F("txtCurrencyRt")
									+"&toForeign="+$F("hidToForeign"), 
					{urlContent: true,
					 title: "Taxes Details",
					 height: 265,
					 width: 600,
					 draggable: false
					});
		}catch (e) {
			showErrorMessage("showTaxesOverlay",e);
		}
	}
	
	function showPDCPaymentsOverlay() {
		try{
			overlayPDCPaymentsInfo = Overlay.show(contextPath+"/GIACInquiryController?action=showPDCPaymentsOverlay&issCd=" + $F("txtBillIssCd") + "&premSeqNo=" + $F("txtPremSeqNo")
										+"&toForeign="+$F("hidToForeign"), 
					{urlContent: true,
					 title: "PDC Payments",
					 height: 290,
					 width: 750,
					 draggable: false
					});
		}catch (e) {
			showErrorMessage("showPDCPaymentsOverlay",e);
		}
	}
	
	function showBalancesOverlay() {
		try{
			overlayBalancesInfo = Overlay.show(contextPath+"/GIACInquiryController?action=showBalancesOverlay&issCd=" + $F("txtBillIssCd") + "&premSeqNo=" + $F("txtPremSeqNo")
										+"&toForeign="+$F("hidToForeign"), 
					{urlContent: true,
					 title: "Balance Amount Due",
					 height: 265,
					 width: 600,
					 draggable: false
					});
		}catch (e) {
			showErrorMessage("showBalancesOverlay",e);
		}
	}
	
	function showGIACS211IssCdLov(onLOV){
		var searchString = (onLOV == false ? $F("txtBillIssCd").trim() : "%");
		LOV.show({
			controller: "ACCreditsAndCollectionInquiryLOVController",
			urlParameters: {action : "getGiacs211IssCdLov",
							moduleId : 'GIACS211',
							intmType : $F("txtIntmType"),
							policyId : $F("hidPolicyId"),
							packPolicyId : $F("hidPackPolicyId"),
							packBillIssCd : $F("txtPackBillIssCd"),
							packBillPremSeqNo : $F("txtPackBillPremSeqNo"),
							assdNo : $F("txtAssuredNo"),
							dueDate : $F("txtDueDate"),
							inceptDate : $F("txtInceptionDate"),
							expiryDate : $F("txtExpiryDate"),
							issueDate : $F("txtIssueDate"),
							intmNo : $F("txtIntmNo"),							
							filterText : searchString,
							page : 1},
			title: "List of Issue Codes",
			width: 400,
			height: 400,
			columnModel : [ {
								id: "issCd",
								title: "Issue Code",
								width : '350px',
							}],
				autoSelectOneRecord: true,
				filterText : searchString,
				onSelect: function(row) {
					if($F("txtBillIssCd") != "" && $F("txtBillIssCd") != row.issCd){
						clearFields();
					}
					enableToolbarButton("btnToolbarEnterQuery");
					$("txtBillIssCd").value = unescapeHTML2(row.issCd);
					$("txtBillIssCd").setAttribute("lastValidValue", unescapeHTML2(row.issCd));
					
					$("txtPremSeqNo").setAttribute("lastValidValue", "");
					$("txtPremSeqNo").clear();
					$("txtPremSeqNo").focus();
					$("txtPremSeqNo").readOnly = false;
					enableSearch("searchBillNo");
				},
				onCancel: function (){
					$("txtBillIssCd").value = $("txtBillIssCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtBillIssCd").value = $("txtBillIssCd").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	function getBillDetails(obj){
		try{
			new Ajax.Request(contextPath+"/GIACInquiryController",{
				method: "POST",
				parameters : {action : "getGiacs211BillDetails",
					          issCd : obj.issCd,
					          premSeqNo : obj.premSeqNo
					          },
				onCreate: function (){
					showNotice("Loading, please wait...");
				},
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						giacs211GipiInvoice = JSON.parse(response.responseText);
						populateGipiInvoice(giacs211GipiInvoice);
						enableToolbarButton("btnToolbarEnterQuery");
						getBillPaymentTbg(giacs211GipiInvoice.issCd,giacs211GipiInvoice.premSeqNo,giacs211GipiInvoice.currencyCd,giacs211GipiInvoice.currencyRt,giacs211GipiInvoice.polFlag,giacs211GipiInvoice.totalAmtDue);
						$$("div#billPaymentMainDiv input[type='button']").each(function (a) {
							enableButton(a);
						});
						disableAllFields(false);
					}
				}
			});
		}catch(e){
			showErrorMessage("getBillDetails", e);
		}
	}
	
	function getGipiInvoiceInfoLov(moduleId,issCd,premSeqNo,intmNo,assdNo,policyId) { //added by shan 11.14.2014
		try{
			LOV.show({
				controller: "GIACInquiryController",
				urlParameters: {action : "getGIACS211GipiInvoice",
					          moduleId : moduleId,
					          issCd : issCd,
					          premSeqNo : premSeqNo,
					          policyId : policyId,
					          packPolicyId : $F("hidPackPolicyId"),
					          packBillIssCd : $F("txtPackBillIssCd"),
					          packBillPremSeqNo : $F("txtPackBillPremSeqNo"),
					          assdNo : assdNo,
					          intmNo : intmNo,
					          dueDate : $F("txtDueDate"),
					       	  inceptDate : $F("txtInceptionDate"),
					       	  expiryDate : $F("txtExpiryDate"),
					       	  issueDate : $F("txtIssueDate"),
					          objFilter : JSON.stringify(setGipiInvoiceInfoFilter())},
				title: "List of Bill Numbers",
				width: 450,
				height: 400,
				hideColumnChildTitle: true,
				columnModel : [
	               {
			    	id:'issCd premSeqNo',
			    	title: 'Bill No.',
			    	width: 300,
			    	titleAlign: 'left',
			    	children: [
			    	   	    {	id: 'issCd',
						    	width: 100,
						    	sortable: false,
						    	title: 'Bill Issue Cd',
						    },
						    {	id: 'premSeqNo',
						    	width: 250,
						    	sortable: false,
						    	align: 'right',
						    	title: 'Prem Seq No',
						    	filterOptionType: 'integerNoNegativeUnformatted',
						    	renderer: function(value){
						    		return nvl(value,'') == '' ? '' :formatNumberDigits(nvl(value, 0),12);
						    	}
						    }
			    		]
			    	}/* ,
			    	{
				    	id:'dspLineCd dspSublineCd dspIssCode dspPolSeqNo dspRenewNo',
				    	title: 'Policy No.',
				    	width: 210,
				    	titleAlign: 'left',
				    	children: [
				    	   	    {	id: 'dspLineCd',
							    	width: 30,
							    	sortable: false,
							    	title: 'Line Cd',
							    },
							    {	id: 'dspSublineCd',
							    	width: 50,
							    	sortable: false,
							    	title: 'Subline Cd'
							    },
							    {	id: 'dspIssCd',
							    	width: 30,
							    	sortable: false,
							    	title: 'Pol Issue Cd'
							    },
							    {	id: 'dspPolSeqNo',
							    	width: 50,
							    	align: 'right',
							    	title: 'Pol Seq No',
							    	sortable: false,
							    	titleAlign: 'right',
							    	filterOptionType: 'integerNoNegativeUnformatted',
							    	renderer: function(value){
							    		return nvl(value,'') == '' ? '' :formatNumberDigits(nvl(value, 0),6);
							    	}
							    },
							    {	id: 'dspRenewNo',
							    	width: 50,
							    	align: 'right',
							    	title: 'Renew No',
							    	sortable: false,
							    	titleAlign: 'right',
							    	filterOptionType: 'integerNoNegativeUnformatted',
							    	renderer: function(value){
							    		return nvl(value,'') == '' ? '' :formatNumberDigits(nvl(value, 0),6);
							    	}
							    },        
						]
				    },
				    {
				    	id:'dspEndtIssCd dspEndtYy dspEndtSeqNo',
				    	title: 'Endorsement No.',
				    	width: 150,
				    	titleAlign: 'left',
				    	children: [
				    	   	    {	id: 'dspEndtIssCd',
							    	width: 30,
							    	sortable: false,
							    	title: 'Endt Issue Cd',
							    },
							    {	id: 'dspEndtYy',
							    	width: 40,
							    	sortable: false,
							    	align: 'right',
							    	title: 'Endt Issue Yy',
							    	filterOptionType: 'integerNoNegativeUnformatted',
							    	renderer: function(value){
							    		return nvl(value,'') == '' ? '' :formatNumberDigits(nvl(value, 0),4);
							    	}
							    },
							    {	id: 'dspEndtSeqNo',
							    	width: 80,
							    	sortable: false,
							    	align: 'right',
							    	title: 'Endt Seq No',
							    	filterOptionType: 'integerNoNegativeUnformatted',
							    	renderer: function(value){
							    		return nvl(value,'') == '' ? '' :formatNumberDigits(nvl(value, 0),12);
							    	}
							    }
				    		]
			    	},
			    	{
				    	id:'intrmdryIntmNo intmName',
				    	title: 'Intermediary',
				    	width: 250,
				    	titleAlign: 'left',
				    	children: [
							    {	id: 'intrmdryIntmNo',
							    	width: 80,
							    	sortable: false,
							    	align: 'right',
							    	title: 'Intm No',
							    	filterOptionType: 'integerNoNegativeUnformatted',
							    	renderer: function(value){
							    		return nvl(value,'') == '' ? '' :formatNumberDigits(nvl(value, 0),12);
							    	}
							    },
				    	   	    {	id: 'intmName',
							    	width: 170,
							    	sortable: false,
							    	title: 'Intm Name',
							    }
				    		]
				    },
			    	{
				    	id:'assdNo assdName',
				    	title: 'Assured',
				    	width: 250,
				    	titleAlign: 'left',
				    	children: [
							    {	id: 'assdNo',
							    	width: 80,
							    	sortable: false,
							    	align: 'right',
							    	title: 'Assd No',
							    	filterOptionType: 'integerNoNegativeUnformatted',
							    	renderer: function(value){
							    		return nvl(value,'') == '' ? '' :formatNumberDigits(nvl(value, 0),12);
							    	}
							    },
				    	   	    {	id: 'assdName',
							    	width: 170,
							    	sortable: false,
							    	title: 'Assured Name',
							    } 
				    		]
				    }*/,
			    ],
				autoSelectOneRecord: true,
				filterText : premSeqNo,
				onSelect: function(row) {
					if (row != undefined){
						getBillDetails(row);
					}
				},
				onCancel: function (){
					$("txtBillIssCd").value = $("txtBillIssCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtBillIssCd").value = $("txtBillIssCd").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
			});
		} catch(e){
			showErrorMessage("getGipiInvoiceInfoLov", e);
		}
	}
	/* observe */	
	$("searchIssCd").observe("click", showGIACS211IssCdLov);
	$("txtBillIssCd").observe("change", function(){
		if (this.value.trim() == ""){
			this.setAttribute("lastValidValue", "");
			$("txtPremSeqNo").clear();
		}else{
			showGIACS211IssCdLov(false);
		}
	});

	$("searchBillNo").observe("click", function(){
		getGipiInvoiceInfoLov("GIACS211",$F("txtBillIssCd"),$F("txtPremSeqNo"),$F("txtIntmNo"),$F("txtAssuredNo"),$F("hidPolicyId"));
	});
	$("txtPremSeqNo").observe("change", function(){
		getGipiInvoiceInfoLov("GIACS211",$F("txtBillIssCd"),$F("txtPremSeqNo"),$F("txtIntmNo"),$F("txtAssuredNo"),$F("hidPolicyId"));
	});
	$$("div#billPaymentBodyDiv input[type='text'].integerUnformatted").each(function (a) {
		$(a).setStyle({textAlign: 'right'});
	});
	$$("div#billPaymentBodyDiv input[type='text']").each(function (a) {
		$(a).observe("change",function(e){
			enableToolbarButton("btnToolbarEnterQuery");
			//enableToolbarButton("btnToolbarExecuteQuery"); //Commented out by Jerome 08.09.2016 SR 5600
		});
	});
	$$("div#billPaymentBodyDiv input[type='text'].disableDelKey").each(function (a) {
		$(a).observe("keydown",function(e){
			if($(a).readOnly && e.keyCode === 46){
				$(a).blur();
			}
		});
	});
	$("searchIntmNo").observe("click", function(){
		showGiisIntermediaryLov("txtIntmNo");
	});
	$("searchRefIntmCd").observe("click", function(){
		showGiisIntermediaryLov("txtRefIntmCd");
	});
	$("searchIntmName").observe("click", function(){
		showGiisIntermediaryLov("txtIntmName");
	});
	$("searchIntmType").observe("click",showGiisIntmTypeLov);
	//$("searchEndtType").observe("click", showCgRefCodesLov); // andrew - 08042015 - SR 19643
	$("searchAssuredNo").observe("click", function(){
		showGiacs211AssuredLov("txtAssuredNo");
	});
	$("searchAssuredName").observe("click", function(){
		showGiacs211AssuredLov("txtAssuredName");
	});

	function showPackPolicyNoLOV() { 
		try{
			LOV.show({
				controller: "GIACInquiryController",
				urlParameters: {action : "getGIACS211PackPolicyLov",
					          moduleId : "GIACS211",
					          packLineCd : $F("txtPackLineCd"),
					          packSublineCd : $F("txtPackSublineCd"),
					          packIssCd : $F("txtPackIssCd"),
					          packIssueYy : $F("txtPackIssueYr"),
					          packPolSeqNo : $F("txtPackSeqNo"),
					          packRenewNo : $F("txtPackRenewNo"),
					          packEndtIssCd : $F("txtPackEndtIssCd"),
					          packEndtYy : $F("txtPackEndtIssueYr"),
					          packEndtSeqNo : $F("txtPackEndtSeqNo"),
					          packBillIssCd : $F("txtPackBillIssCd"),
					          packBillPremSeqNo : $F("txtPackBillPremSeqNo"),
					          policyId : $F("hidPolicyId"),
					          assdNo : $F("txtAssuredNo"),
					          intmNo : $F("txtIntmNo"),
					          dueDate : $F("txtDueDate"),
					       	  inceptDate : $F("txtInceptionDate"),
					       	  expiryDate : $F("txtExpiryDate"),
					       	  issueDate : $F("txtIssueDate"),
					       	  billIssCd : $F("txtBillIssCd"),
					       	  findText2 : ($("hidPackPolicyId").readAttribute("lastValidValue").trim() != $F("hidPackPolicyId").trim() ? $F("").trim() : "%"),
					          },
				title: "List of Pack Policy Numbers",
				width: 650,
				height: 400,
				hideColumnChildTitle: true,
				columnModel : [
					{
						id:'packPolicyNo',
						title: 'Pack Policy No.',
						width: 230,
						children: [
						   	    {	id: 'packLineCd',
							    	width: 30,
							    	sortable: false,
							    	title: 'Pack Line Cd',
							    },
							    {	id: 'packSublineCd',
							    	width: 50,
							    	sortable: false,
							    	title: 'Pack Subline Cd'
							    },
							    {	id: 'packIssCd',
							    	width: 30,
							    	sortable: false,
							    	title: 'Pack Issue Cd'
							    },
							    {	id: 'packIssueYy',
							    	width: 30,
							    	sortable: false,
							    	titleAlign: 'right',
							    	title: 'Pack Issue Yr'
							    },							    
							    {	id: 'packPolSeqNo',
							    	width: 60,
							    	align: 'right',
							    	title: 'Pack Pol Seq No',
							    	sortable: false,
							    	titleAlign: 'right',
							    	filterOptionType: 'integerNoNegativeUnformatted',
							    	renderer: function(value){
							    		return nvl(value,'') == '' ? '' :formatNumberDigits(nvl(value, 0),6);
							    	}
							    },
							    {	id: 'packRenewNo',
							    	width: 28,
							    	align: 'right',
							    	title: 'Pack Renew No',
							    	sortable: false,
							    	titleAlign: 'right',
							    	filterOptionType: 'integerNoNegativeUnformatted',
							    	renderer: function(value){
							    		return nvl(value,'') == '' ? '' :formatNumberDigits(nvl(value, 0),2);
							    	}
							    }       
						]
					},
					{
						id:'packEndtNo',
						title: 'Pack Endt No.',
						width: '100px',
						sortable: false,
						children: [
						   	    {	id: 'packEndtIssCd',
							    	width: 30,
							    	sortable: false,
							    	title: 'Pack Endt Iss Cd',
							    },
							    {	id: 'packEndtYy',
							    	width: 30,
							    	sortable: false,
							    	title: 'Pack Endt Yy'
							    },
							    {	id: 'packEndtSeqNo',
							    	width: 60,
							    	align: 'right',
							    	title: 'Pack Endt Seq No',
							    	sortable: false,
							    	titleAlign: 'right',
							    	filterOptionType: 'integerNoNegativeUnformatted',
							    	renderer: function(value){
							    		return nvl(value,'') == '' ? '' :formatNumberDigits(nvl(value, 0),6);
							    	}
							    }
							]
						},
						{
							id:'packBillNo',
							title: 'Pack Bill No.',
							width: '100px',
							children: [
							   	    {	id: 'packBillIssCd',
								    	width: 30,
								    	title: 'Pack Bill Iss Cd',
								    },
								    {	id: 'packBillPremSeqNo',
								    	width: 60,
								    	align: 'right',
								    	title: 'Pack Endt Seq No',
								    	titleAlign: 'right',
								    	filterOptionType: 'integerNoNegativeUnformatted',
								    	renderer: function(value){
								    		return nvl(value,'') == '' ? '' :formatNumberDigits(nvl(value, 0),6);
								    	}
								    }
								]
							}
			    ],
				autoSelectOneRecord: true,
				filterText : ($("hidPackPolicyId").readAttribute("lastValidValue").trim() != $F("hidPackPolicyId").trim() ? $F("hidPackPolicyId").trim() : ""),
				onSelect: function(row) {
				    enableToolbarButton("btnToolbarEnterQuery");					
					if (row != undefined){
						giacs211GipiInvoice = row;
						populatePackPolicyNo(row);
						enableToolbarButton("btnToolbarEnterQuery");	
						$$("div#billPaymentMainDiv input[type='button']").each(function (a) {
							enableButton(a);
						});
					}
				},
				onCancel: function (){
					if($("hidPackPolicyId").value != ""){
						$("txtPackLineCd").value = $("txtPackLineCd").readAttribute("lastValidValue");
						$("txtPackSublineCd").value = $("txtPackSublineCd").readAttribute("lastValidValue");
						$("txtPackIssCd").value = $("txtPackIssCd").readAttribute("lastValidValue");
						$("txtPackIssueYr").value = $("txtPackIssueYr").readAttribute("lastValidValue");
						$("txtPackSeqNo").value = $("txtPackSeqNo").readAttribute("lastValidValue");
						$("txtPackRenewNo").value = $("txtPackRenewNo").readAttribute("lastValidValue");					
						$("hidPackPolicyId").value = $("hidPackPolicyId").readAttribute("lastValidValue");
					} else if($F("hidPackPolicyId") == ""
								&& $F("txtPackLineCd") != "" 
								&& $F("txtPackSublineCd") != ""
								&& $F("txtPackIssCd") != ""
								&& $F("txtPackIssueYr") != ""
								&& $F("txtPackSeqNo") != ""
								&& $F("txtPackRenewNo") != ""){
						$("txtPackLineCd").value = "";
						$("txtPackSublineCd").value = "";
						$("txtPackIssCd").value = "";
						$("txtPackIssueYr").value = "";
						$("txtPackSeqNo").value = "";
						$("txtPackRenewNo").value = "";
						$("hidPackPolicyId").value = "";						
					}
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					if($("hidPackPolicyId").value != ""){
						$("txtPackLineCd").value = $("txtPackLineCd").readAttribute("lastValidValue");
						$("txtPackSublineCd").value = $("txtPackSublineCd").readAttribute("lastValidValue");
						$("txtPackIssCd").value = $("txtPackIssCd").readAttribute("lastValidValue");
						$("txtPackIssueYr").value = $("txtPackIssueYr").readAttribute("lastValidValue");
						$("txtPackSeqNo").value = $("txtPackSeqNo").readAttribute("lastValidValue");
						$("txtPackRenewNo").value = $("txtPackRenewNo").readAttribute("lastValidValue");					
						$("hidPackPolicyId").value = $("hidPackPolicyId").readAttribute("lastValidValue");
					} else if($F("hidPackPolicyId") == ""
								&& $F("txtPackLineCd") != "" 
								&& $F("txtPackSublineCd") != ""
								&& $F("txtPackIssCd") != ""
								&& $F("txtPackIssueYr") != ""
								&& $F("txtPackSeqNo") != ""
								&& $F("txtPackRenewNo") != ""){
						$("txtPackLineCd").value = "";
						$("txtPackSublineCd").value = "";
						$("txtPackIssCd").value = "";
						$("txtPackIssueYr").value = "";
						$("txtPackSeqNo").value = "";
						$("txtPackRenewNo").value = "";
						$("hidPackPolicyId").value = "";
					}
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();},
				draggable: true
			});
		} catch(e){
			showErrorMessage("showPackPolicyNoLOV", e);
		}
	}
	
	$("searchPackPolicy").observe("click", function(){
		showPackPolicyNoLOV();
	});	
	
	// Dren 06292015 : SR 0004613 - Added LOV for policy no. - Start
	$("searchPolicyNo").observe("click", function(){
		showPolicyNoLOV();
	});	

	function showPolicyNoLOV() { 
		try{
			LOV.show({
				controller: "GIACInquiryController",
				urlParameters: {action : "getGIACS211PolicyLov",
					          moduleId : "GIACS211",
					          lineCd : $F("txtPolLineCd"),
					          sublineCd : $F("txtPolSublineCd"),
					          issCd : $F("txtPolIssCd"),
					          issueYy : $F("txtPolIssueYr"),
					          polSeqNo : $F("txtPolSeqNo"),
					          renewNo : $F("txtPolRenewNo"),
					          endtIssCd : $F("txtEndtIssCd"),
					          endtYy : $F("txtEndtIssueYr"),
					          endtSeqNo : $F("txtEndtSeqNo"),
					          endtType : $F("txtEndtType"),
					          refPolNo : $F("txtRefPolNo"),
					          packPolicyId : $F("hidPackPolicyId"),
					          assdNo : $F("txtAssuredNo"),
					          intmNo : $F("txtIntmNo"),
					          dueDate : $F("txtDueDate"),
					       	  inceptDate : $F("txtInceptionDate"),
					       	  expiryDate : $F("txtExpiryDate"),
					       	  issueDate : $F("txtIssueDate"),
					       	  billIssCd : $F("txtBillIssCd"),
					          objFilter : JSON.stringify(setGipiInvoiceInfoFilter())},
				title: "List of Policy Numbers",
				width: 650,
				height: 400,
				hideColumnChildTitle: true,
				columnModel : [
					{
						id:'policyNo',
						title: 'Policy No.',
						width: 230,
						children: [
						   	    {	id: 'dspLineCd',
							    	width: 30,
							    	sortable: false,
							    	title: 'Line Cd',
							    },
							    {	id: 'dspSublineCd',
							    	width: 50,
							    	sortable: false,
							    	title: 'Subline Cd'
							    },
							    {	id: 'dspIssCd',
							    	width: 30,
							    	sortable: false,
							    	title: 'Pol Issue Cd'
							    },
							    {	id: 'dspIssueYy',
							    	width: 30,
							    	sortable: false,
							    	titleAlign: 'right',
							    	title: 'Pol Issue Yr'
							    },							    
							    {	id: 'dspPolSeqNo',
							    	width: 60,
							    	align: 'right',
							    	title: 'Pol Seq No',
							    	sortable: false,
							    	titleAlign: 'right',
							    	filterOptionType: 'integerNoNegativeUnformatted',
							    	renderer: function(value){
							    		return nvl(value,'') == '' ? '' :formatNumberDigits(nvl(value, 0),6);
							    	}
							    },
							    {	id: 'dspRenewNo',
							    	width: 28,
							    	align: 'right',
							    	title: 'Renew No',
							    	sortable: false,
							    	titleAlign: 'right',
							    	filterOptionType: 'integerNoNegativeUnformatted',
							    	renderer: function(value){
							    		return nvl(value,'') == '' ? '' :formatNumberDigits(nvl(value, 0),2);
							    	}
							    }       
						]
					},
					{
						id:'dspEndtIssCd dspEndtYy dspEndtSeqNo',
						title: 'Endt No.',
						width: '120px',
						sortable: false,
						children: [
						   	    {	id: 'dspEndtIssCd',
							    	width: 30,
							    	sortable: false,
							    	title: 'Endt Iss Cd',
							    },
							    {	id: 'dspEndtYy',
							    	width: 30,
							    	sortable: false,
							    	title: 'Endt Yy'
							    },
							    {	id: 'dspEndtSeqNo',
							    	width: 60,
							    	align: 'right',
							    	title: 'Endt Seq No',
							    	sortable: false,
							    	titleAlign: 'right',
							    	filterOptionType: 'integerNoNegativeUnformatted',
							    	renderer: function(value){
							    		return nvl(value,'') == '' ? '' :formatNumberDigits(nvl(value, 0),6);
							    	}
							    },
							    {	id: 'dspEndtType',
							    	width: 30,
							    	sortable: false,
							    	title: 'Endt Type',
							    },
						]
					},
					{
						id:'refPolNo',
						title: 'Ref Pol No.',
						width: '150px'
					}
			    ],
				autoSelectOneRecord: true,
				onSelect: function(row) {
			    enableToolbarButton("btnToolbarEnterQuery");					
					if (row != undefined){
						giacs211GipiInvoice = row;
						populatePolicyNo(row);
						enableToolbarButton("btnToolbarEnterQuery");	
						//enableToolbarButton("btnToolbarExecuteQuery"); //lmbeltran SR19577 07062015 //Commented out by Jerome 08.09.2016 SR 5600
						$$("div#billPaymentMainDiv input[type='button']").each(function (a) {
							enableButton(a);
						});											//end
						//disableAllFields(false);
					}
				},
				onCancel: function (){
					if($("hidPolicyId").value != ""){
						$("txtPolLineCd").value = $("txtPolLineCd").readAttribute("lastValidValue");
						$("txtPolSublineCd").value = $("txtPolSublineCd").readAttribute("lastValidValue");
						$("txtPolIssCd").value = $("txtPolIssCd").readAttribute("lastValidValue");
						$("txtPolIssueYr").value = $("txtPolIssueYr").readAttribute("lastValidValue");
						$("txtPolSeqNo").value = $("txtPolSeqNo").readAttribute("lastValidValue");
						$("txtPolRenewNo").value = $("txtPolRenewNo").readAttribute("lastValidValue");					
						$("hidPolicyId").value = $("hidPolicyId").readAttribute("lastValidValue");
					} else if($F("hidPolicyId") == ""
								&& $F("txtPolLineCd") != "" 
								&& $F("txtPolSublineCd") != ""
								&& $F("txtPolIssCd") != ""
								&& $F("txtPolIssueYr") != ""
								&& $F("txtPolSeqNo") != ""
								&& $F("txtPolRenewNo") != ""){
						$("txtPolLineCd").value = "";
						$("txtPolSublineCd").value = "";
						$("txtPolIssCd").value = "";
						$("txtPolIssueYr").value = "";
						$("txtPolSeqNo").value = "";
						$("txtPolRenewNo").value = "";					
						$("hidPolicyId").value = "";
					}
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					if($("hidPolicyId").value != ""){
						$("txtPolLineCd").value = $("txtPolLineCd").readAttribute("lastValidValue");
						$("txtPolSublineCd").value = $("txtPolSublineCd").readAttribute("lastValidValue");
						$("txtPolIssCd").value = $("txtPolIssCd").readAttribute("lastValidValue");
						$("txtPolIssueYr").value = $("txtPolIssueYr").readAttribute("lastValidValue");
						$("txtPolSeqNo").value = $("txtPolSeqNo").readAttribute("lastValidValue");
						$("txtPolRenewNo").value = $("txtPolRenewNo").readAttribute("lastValidValue");					
						$("hidPolicyId").value = $("hidPolicyId").readAttribute("lastValidValue");
					} else if($F("hidPolicyId") == ""
								&& $F("txtPolLineCd") != "" 
								&& $F("txtPolSublineCd") != ""
								&& $F("txtPolIssCd") != ""
								&& $F("txtPolIssueYr") != ""
								&& $F("txtPolSeqNo") != ""
								&& $F("txtPolRenewNo") != ""){
						$("txtPolLineCd").value = "";
						$("txtPolSublineCd").value = "";
						$("txtPolIssCd").value = "";
						$("txtPolIssueYr").value = "";
						$("txtPolSeqNo").value = "";
						$("txtPolRenewNo").value = "";					
						$("hidPolicyId").value = "";
					}
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();},
				draggable: true
			});
		} catch(e){
			showErrorMessage("showPolicyNoLOV", e);
		}
	}	
	// Dren 06292015 : SR 0004613 - Added LOV for policy no. - End	
	
	$("txtIntmNo").observe("change", function(e) {
		if($F("txtIntmNo").trim() == "") {
			$("txtIntmNo").value = "";
			$("txtRefIntmCd").value = "";
			$("txtIntmName").value = "";
			$("txtIntmNo").setAttribute("lastValidValue", "");
			$("txtRefIntmCd").setAttribute("lastValidValue", "");
			$("txtIntmName").setAttribute("lastValidValue", "");
		} else {
			if($F("txtIntmNo").trim() != "" && $F("txtIntmNo") != $("txtIntmNo").readAttribute("lastValidValue")) {
				showGiisIntermediaryLov("txtIntmNo");
			}
		}
	});
	
	$("txtRefIntmCd").observe("change", function(e) {
		if($F("txtRefIntmCd").trim() == "") {
			$("txtIntmNo").value = "";
			$("txtRefIntmCd").value = "";
			$("txtIntmName").value = "";
			$("txtIntmNo").setAttribute("lastValidValue", "");
			$("txtRefIntmCd").setAttribute("lastValidValue", "");
			$("txtIntmName").setAttribute("lastValidValue", "");
		} else {
			if($F("txtRefIntmCd").trim() != "" && $F("txtRefIntmCd") != $("txtRefIntmCd").readAttribute("lastValidValue")) {
				showGiisIntermediaryLov("txtRefIntmCd");
			}
		}
	});
	
	$("txtIntmName").observe("change", function(e) {
		if($F("txtIntmName").trim() == "") {
			$("txtIntmNo").value = "";
			$("txtRefIntmCd").value = "";
			$("txtIntmName").value = "";
			$("txtIntmNo").setAttribute("lastValidValue", "");
			$("txtRefIntmCd").setAttribute("lastValidValue", "");
			$("txtIntmName").setAttribute("lastValidValue", "");
		} else {
			if($F("txtIntmName").trim() != "" && $F("txtIntmName") != $("txtIntmName").readAttribute("lastValidValue")) {
				showGiisIntermediaryLov("txtIntmName");
			}
		}
	});
	
	$("txtIntmType").observe("change", function(e) {
		if($F("txtIntmType").trim() == "") {
			$("txtIntmType").value = "";
			$("txtIntmType").setAttribute("lastValidValue", "");
		} else {
			if($F("txtIntmType").trim() != "" && $F("txtIntmType") != $("txtIntmType").readAttribute("lastValidValue")) {
				showGiisIntmTypeLov();
			}
		}
	});
	
	$("txtEndtType").observe("change", function(e) {
		if($F("txtEndtType").trim() == "") {
			$("txtEndtType").value = "";
			$("txtEndtType").setAttribute("lastValidValue", "");
		} else {
			if($F("txtEndtType").trim() != "" && $F("txtEndtType") != $("txtEndtType").readAttribute("lastValidValue")) {
				showCgRefCodesLov();
			}
		}
	});
	
	$("txtAssuredNo").observe("change", function(e) {
		if($F("txtAssuredNo").trim() == "") {
			$("txtAssuredNo").value = "";
			$("txtAssuredName").value = "";
			$("txtAssuredNo").setAttribute("lastValidValue", "");
			$("txtAssuredName").setAttribute("lastValidValue", "");
		} else {
			if($F("txtAssuredNo").trim() != "" && $F("txtAssuredNo") != $("txtAssuredNo").readAttribute("lastValidValue")) {
				showGiacs211AssuredLov("txtAssuredNo");
			}
		}
	});
	
	$("txtAssuredName").observe("change", function(e) {
		if($F("txtAssuredName").trim() == "") {
			$("txtAssuredName").value = "";
			$("txtAssuredNo").value = "";
			$("txtAssuredNo").setAttribute("lastValidValue", "");
			$("txtAssuredName").setAttribute("lastValidValue", "");
		} else {
			if($F("txtAssuredName").trim() != "" && $F("txtAssuredName") != $("txtAssuredName").readAttribute("lastValidValue")) {
				showGiacs211AssuredLov("txtAssuredName");
			}
		}
	});
	
	$("btnPremium").observe("click", function(){
		showPremiumOverlay();
	});
	
	$("btnTaxes").observe("click", function(){
		showTaxesOverlay();
	});
	
	$("btnPDCPayment").observe("click", function(){
		showPDCPaymentsOverlay();
	});
	
	$("btnCommission").observe("click", function(){
		//to call the module GIACS221
		if (!checkUserModule("GIACS221")) {
			showMessageBox(objCommonMessage.NO_MODULE_ACCESS,"I");
			return;
		}
		if (objACGlobal.callingForm != "GIACS221" || objACGlobal.previousModule == "GIACS288") {
			objACGlobal.callingForm = "GIACS211";
		}
		objACGlobal.issCd = $F("txtBillIssCd");
		objACGlobal.premSeqNo = $F("txtPremSeqNo");
		showCommissionInquiry(objACGlobal.callingForm,objACGlobal.issCd,objACGlobal.premSeqNo);
	});
	
	$("btnBalance").observe("click", function(){
		showBalancesOverlay();
	});
	
	$("btnCurrencyInfo").observe("click", function(){
		if (this.value == "Currency Information") {
			this.value = "Back";
			$("billPaymentTable").hide();
			$("billPaymentTable2").show();
			hideAndSeek("toLocal", "toForen");
			$("hidToForeign").value = 1;
		}else{
			this.value = "Currency Information";
			$("billPaymentTable2").hide();
			$("billPaymentTable").show();
			hideAndSeek("toForen", "toLocal");
			$("hidToForeign").value = 0;
		}
	});
	
	$("btnToolbarEnterQuery").observe("click", function(){
		showBillPayment(null,null,null);
	});
	
	/* $("btnToolbarExecuteQuery").observe("click", function(){ //Commented out by Jerome 08.09.2016 SR 5600
		if (checkPolicyNo() || checkBillNo()) {
			disableAllFields();
			//getGipiInvoiceInfo("GIACS211",$F("txtBillIssCd"),$F("txtPremSeqNo")); // replaced with codes below : shan 11.14.2014
			getBillPaymentTbg(giacs211GipiInvoice.issCd,giacs211GipiInvoice.premSeqNo,giacs211GipiInvoice.currencyCd,giacs211GipiInvoice.currencyRt,giacs211GipiInvoice.polFlag,giacs211GipiInvoice.totalAmtDue);
			$$("div#billPaymentMainDiv input[type='button']").each(function (a) {
				enableButton(a);
			});
		} else {
			showMessageBox("Please enter Bill Number or Policy Number first.","I");
		}
	}); */
	
	$("btnToolbarExit").observe("click", function(){
		if(objACGlobal.callingForm == "GIACS221"){
			//when called by GIACS221
			showCommissionInquiry(objACGlobal.callingForm,objACGlobal.issCd,objACGlobal.premSeqNo,objACGlobal.intmNo);
		}else if (objACGlobal.callingForm == "GIACS288" || objACGlobal.previousModule == "GIACS288") {
			//showBillsByIntermediary("Y"); //marco
			$("otherModuleDiv").hide();	// replacement for code above : shan 11.12.2014
			$("otherModuleDiv").update();
			$("billsByIntmMainDiv").show();
		}else{
			objACGlobal.callingForm = null;
			objACGlobal.issCd = null;
			objACGlobal.premSeqNo = null;
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		}
	});
	
	newFormInstance();
	
	$$("div#billPaymentBodyDiv input[type='text'].polNoReq").each(function (rec) {
		rec.observe("change", function(){
			if(rec.value.trim() == "" && $F("hidPolicyId") != ""){
				$("txtPolLineCd").value = "";
				$("txtPolLineCd").setAttribute("lastValidValue", "");
				$("txtPolSublineCd").value = "";
				$("txtPolSublineCd").setAttribute("lastValidValue", "");
				$("txtPolIssCd").value = "";
				$("txtPolIssCd").setAttribute("lastValidValue", "");
				$("txtPolIssueYr").value = "";
				$("txtPolIssueYr").setAttribute("lastValidValue", "");
				$("txtPolSeqNo").value = "";
				$("txtPolSeqNo").setAttribute("lastValidValue", "");
				$("txtPolRenewNo").value = "";
				$("txtPolRenewNo").setAttribute("lastValidValue", "");
				$("hidPolicyId").value = "";
				$("hidPolicyId").setAttribute("lastValidValue", "");
			} else if((rec.value != rec.readAttribute("lastValidValue") 
						&& rec.readAttribute("lastValidValue") != "")
							|| ($F("txtPolLineCd") != "" 
								&& $F("txtPolSublineCd") != ""
								&& $F("txtPolIssCd") != ""
								&& $F("txtPolIssueYr") != ""
								&& $F("txtPolSeqNo") != ""
								&& $F("txtPolRenewNo") != "")) {
				showPolicyNoLOV();
			}
		});
	});
	
	$$("td#packPolicyNo input[type='text'].packPolicyNo").each(function (rec) {
		rec.observe("change", function(){
			if(rec.value.trim() == "" && $F("hidPackPolicyId") != ""){
				$("txtPackLineCd").value = "";
				$("txtPackLineCd").setAttribute("lastValidValue", "");
				$("txtPackSublineCd").value = "";
				$("txtPackSublineCd").setAttribute("lastValidValue", "");
				$("txtPackIssCd").value = "";
				$("txtPackIssCd").setAttribute("lastValidValue", "");
				$("txtPackIssueYr").value = "";
				$("txtPackIssueYr").setAttribute("lastValidValue", "");
				$("txtPackSeqNo").value = "";
				$("txtPackSeqNo").setAttribute("lastValidValue", "");
				$("txtPackRenewNo").value = "";
				$("txtPackRenewNo").setAttribute("lastValidValue", "");
				$("hidPackPolicyId").value = "";
				$("hidPackPolicyId").setAttribute("lastValidValue", "");
			} else if((rec.value != rec.readAttribute("lastValidValue") 
						&& rec.readAttribute("lastValidValue") != "") 
							|| ($F("txtPackLineCd") != "" 
									&& $F("txtPackSublineCd") != ""
									&& $F("txtPackIssCd") != ""
									&& $F("txtPackIssueYr") != ""
									&& $F("txtPackSeqNo") != ""
									&& $F("txtPackRenewNo") != "")) {
				showPackPolicyNoLOV();
			}
		});
	});	
</script>