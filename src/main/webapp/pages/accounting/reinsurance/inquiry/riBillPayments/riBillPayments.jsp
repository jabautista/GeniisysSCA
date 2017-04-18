<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="riBillPaymentMainDiv" name="riBillPaymentMainDiv" style="width: 100%; float: left; margin-bottom: 30px;">
	<div id="toolbarDiv" name="toolbarDiv">
		<div class="toolButton">
			<span style="background: url(${pageContext.request.contextPath}/images/toolbar/enterQuery.png) left center no-repeat;" id="btnToolbarEnterQuery">Enter Query</span>
			<span style="display: none; background: url(${pageContext.request.contextPath}/images/toolbar/enterQueryDisabled.png) left center no-repeat;" id="btnToolbarEnterQueryDisabled">Enter Query</span>
		</div>
		<div class="toolButton">
			<span style="background: url(${pageContext.request.contextPath}/images/toolbar/executeQuery.png) left center no-repeat;" id="btnToolbarExecuteQuery">Execute Query</span>
			<span style="display: none; background: url(${pageContext.request.contextPath}/images/toolbar/executeQueryDisabled.png) left center no-repeat;" id="btnToolbarExecuteQueryDisabled">Execute Query</span>
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
	<%-- <jsp:include page="/pages/toolbar.jsp"></jsp:include> --%>
	<div id="riBillPaymentBodyDiv" class="sectionDiv">
		<table cellspacing="0" width="100%" align="center" style="margin: 30px 10px 20px 10px">
			<tr>
				<td class="rightAligned">Bill No.</td>
				<td class="leftAligned" style="width: 340px">
					<span class="lovSpan" style="border: none; width: 45px; height: 21px; margin: 0 0 0 0; float: left;">
						<input class="leftAligned billNoReq allCaps required" type="text" id="txtBillIssCd" name="txtBillIssCd" maxlength="2" style="width: 35px; float: left; height: 15px;"readonly="readonly" tabindex="101" />
					</span>
					<span class="lovSpan required" style="width: 268px; height: 21px; margin: 2px 2px 0 2px; float: left;">
						<input class="rightAligned billNoReq integerUnformatted required" lpad="12" type="text" id="txtPremSeqNo" name="txtPremSeqNo" maxlength="12" style="width: 231px; float: left; border: none; height: 13px;" tabindex="102" />
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="sRiBillNo" name="sRiBillNo" alt="Go" style="float: right;" />
					</span>
				</td>
				<td class="rightAligned" style="width: 110px;">Due Date</td>
				<td class="leftAligned">
					<div style="float: left; width: 202px;" class="withIconDiv">
						<input type="text" id="txtDueDate" name="txtDueDate" class="withIcon disableDelKey" readonly="readonly" style="width: 177px;" tabindex="103" />
						<img id="hrefDueDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Due Date" onclick="scwShow($('txtDueDate'),this, null);" />
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Reinsurer</td>
				<td colspan="3" class="leftAligned">
					<span class="lovSpan" style="width: 70px; height: 21px; margin: 2px 2px 0 0; float: left;">
						<input type="text" id="txtRiCd" name="txtRiCd" style="width: 43px; float: left; border: none; height: 13px;" class="disableDelKey integerUnformatted" lpad="5" maxlength="5" tabindex="104" />
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchRiNo" name="searchRiNo" alt="Go" style="float: right;" />
					</span>
					<span class="lovSpan" style="border: none; width: 581px; height: 21px; margin: 0 2px 0 2px; float: left;">
						<input type="text" id="txtRiName" name="txtRiName" style="width: 578px; float: left; height: 15px;" class="disableDelKey allCaps" maxlength="50" tabindex="105" readonly="readonly"  />
					</span>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Assured</td>
				<td colspan="3" class="leftAligned">
					<span class="lovSpan" style="width: 70px; height: 21px; margin: 2px 2px 0 0; float: left;">
						<input type="text" id="txtAssuredNo" name="txtAssuredNo" style="width: 43px; float: left; border: none; height: 13px;" class="disableDelKey integerUnformatted" lpad="6" maxlength="12" tabindex="106" />
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchAssuredNo" name="searchAssuredNo" alt="Go" style="float: right;">
					</span> 
					<span class="lovSpan" style="border: none; width: 581px; height: 21px; margin: 0 2px 0 2px; float: left;">
						<input type="text" id="txtAssuredName" name="txtAssuredName" style="width: 578px; float: left; height: 15px;" class="disableDelKey allCaps" maxlength="500" tabindex="107" readonly="readonly" />
					</span>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Policy No.</td>
				<td class="leftAligned" style="border: none;">
					<input class="polNoReq allCaps" type="text" id="txtPolLineCd" name="txtPolLineCd" style="width: 34px; float: left; margin: 2px 4px 0 0" maxlength="2" tabindex="108" />
					<input class="polNoReq allCaps" type="text" id="txtPolSublineCd" name="txtPolSublineCd" style="width: 70px; float: left; margin: 2px 4px 0 0" maxlength="7" tabindex="109" />
					<input class="polNoReq allCaps" type="text" id="txtPolIssCd" name="txtPolIssCd" style="width: 30px; float: left; margin: 2px 4px 0 0" maxlength="2" readonly="readonly" tabindex="110" />
					<input class="polNoReq integerUnformatted" lpad="2" type="text" id="txtPolIssueYy" name="txtPolIssueYy" style="width: 30px; float: left; margin: 2px 4px 0 0" maxlength="3" tabindex="111" />
					<input class="polNoReq integerUnformatted" lpad="7" type="text" id="txtPolSeqNo" name="txtPolSeqNo" style="width: 65px; float: left; margin: 2px 4px 0 0" maxlength="8" tabindex="112" />
					<input class="polNoReq integerUnformatted" lpad="2" type="text" id="txtPolRenewNo" name="txtPolRenewNo" style="width: 24px; float: left;" maxlength="3" tabindex="113" />
					<span class="lovSpan" style="border: none; height: 21px;">
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="sPolicyNo" name="sPolicyNo" alt="Go" style="margin: 2px 0 4px 0; float: left;" />
					</span>
				</td>
				<td class="rightAligned">
					<label class="rightAligned" id="lblEndtNo" style="width: 110px;">Endorsement No.</label>
				</td>
				<td>
					<input class="allCaps" type="text" id="txtEndtIssCd" name="txtEndtIssCd" style="width: 30px; float: left; margin: 2px 4px 0 4px" maxlength="2" tabindex="114" />
					<input class="integerUnformatted" lpad="2" type="text" id="txtEndtIssueYy" name="txtEndtIssueYy" style="width: 30px; float: left; margin: 2px 4px 0 0" maxlength="3" tabindex="115" />
					<input class="integerUnformatted" lpad="6" type="text" id="txtEndtSeqNo" name="txtEndtSeqNo" style="width: 65px; float: left; margin: 2px 4px 0 0" maxlength="7" tabindex="116" />
					<input class="allCaps" type="text" id="txtEndtType" name="txtEndtType" style="width: 35px; float: left;" maxlength="1" tabindex="117" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Package Policy</td>
				<td class="leftAligned">
					<input class="allCaps" type="text" id="txtPackLineCd" name="txtPackLineCd" style="width: 34px;" maxlength="2" tabindex="118" />
					<input class="allCaps" type="text" id="txtPackSublineCd" name="txtPackSublineCd" style="width: 70px;" maxlength="7" tabindex="119" />
					<input class="allCaps" type="text" id="txtPackIssCd" name="txtPackIssCd" style="width: 30px;" maxlength="2" tabindex="120" />
					<input class="integerUnformatted" lpad="2" type="text" id="txtPackIssueYy" name="txtPackIssueYy" style="width: 30px;" maxlength="3" tabindex="121" />
					<input class="integerUnformatted" lpad="7" type="text" id="txtPackSeqNo" name="txtPackSeqNo" style="width: 65px;" maxlength="8" tabindex="122" />
					<input class="integerUnformatted" lpad="2" type="text" id="txtPackRenewNo" name="txtPackRenewNo" style="width: 24px;" maxlength="3" tabindex="123" />
				</td>
				<td class="rightAligned">Endorsement No.</td>
				<td>
					<input class="allCaps" type="text" id="txtPackEndtIssCd" name="txtPackEndtIssCd" style="width: 30px; float: left; margin: 2px 4px 0 4px" maxlength="2" tabindex="124" />
					<input class="integerUnformatted" lpad="2" type="text" id="txtPackEndtIssueYy" name="txtPackEndtIssueYy" style="width: 30px; float: left; margin: 2px 4px 0 0" maxlength="3" tabindex="125" />
					<input class="integerUnformatted" lpad="6" type="text" id="txtPackEndtSeqNo" name="txtPackEndtSeqNo" style="width: 65px; float: left; margin: 2px 4px 0 0" maxlength="7" tabindex="126" />
					<input class="allCaps" type="text" id="txtPackEndtType" name="txtPackEndtType" style="width: 35px; float: left;" maxlength="1" tabindex="127" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Inception Date</td>
				<td class="leftAligned">
					<div style="margin: 0 4px 0 0; float: left; width: 110px;" class="withIconDiv">
						<input type="text" id="txtInceptionDate" name="txtInceptionDate" class="withIcon disableDelKey" readonly="readonly" style="width: 86px;" tabindex="128" />
						<img id="hrefInceptionDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Inception Date" onclick="scwShow($('txtInceptionDate'),this, null);" />
					</div>
					<label class="rightAligned" style="margin: 5px 5px 0 20px;">Expiry Date</label>
					<div style="margin: 0; float: left; width: 110px;" class="withIconDiv">
						<input type="text" id="txtExpiryDate" name="txtExpiryDate" class="withIcon disableDelKey" readonly="readonly" style="width: 86px;" tabindex="129" />
						<img id="hrefExpiryDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Expiry Date" onclick="scwShow($('txtExpiryDate'),this, null);" />
					</div>
				</td>
				<td class="rightAligned">
					<label class="toLocal rightAligned" id="lblPremAmt" style="width: 110px;">Premium Amount</label>
				</td>
				<td class="leftAligned">
					<input class="rightAligned toLocal" type="text" id="txtLocalPrem" name="txtLocalPrem" style="margin: 0 4px 0 0; width: 196px;" readonly="readonly" tabindex="130" />
					<input class="rightAligned" type="text" id="txtForeignPrem" name="txtForeignPrem" style="width: 194px; display: none;" readonly="readonly"  tabindex="131"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Issue Date</td>
				<td class="leftAligned">
					<div id="issueDateDiv" style="margin: 0 4px 0 0; float: left; width: 110px; margin: 3px 0 3px 0" class="withIconDiv">
						<input type="text" id="txtIssueDate" name="txtIssueDate" class="withIcon disableDelKey" readonly="readonly" style="width: 86px;" tabindex="132" />
						<img id="hrefIssueDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Issue Date" onclick="scwShow($('txtIssueDate'),this, null);" />
					</div>
						<label class="rightAligned" style="margin: 5px 5px 0 18px;">Policy Status</label>
						<input class="allCaps" type="text" id="txtPolFlag" name="txtPolFlag" style="width: 10px;" maxlength="1" tabindex="133" />
						<input type="text" id="txtPolStatus" name="txtPolStatus" style="width: 82px;" readonly="readonly" maxlength="30" tabindex="134" />
				</td>
				<!-- <td class="rightAligned">
							<label class="rightAligned toLocal" id = "lblTaxAmt" style="width: 110px;">Tax Amount</label>
						</td>
						<td class="leftAligned">
							<input class="rightAligned toLocal" type="text" id="txtLocalTax" name="txtLocalTax" style="width: 196px;"  readonly="readonly"/>
							<input class="rightAligned" type="text" id="txtForeignTax" name="txtForeignTax" style="width: 196px; display: none;"  readonly="readonly"/>
						</td> -->
				<td class="rightAligned">
					<label class="rightAligned" id="lblCommissionAmount" style="width: 110px;">Commission Amount</label>
				</td>
				<td class="leftAligned">
					<input class="rightAligned toLocal" type="text" id="txtLocalComm" name="txtLocalComm" style="margin: 0 4px 0 0; width: 196px;" readonly="readonly" tabindex="135" />
					<input class="rightAligned" type="text" id="txtForeignComm" name="txtForeignComm" style="width: 196px; display: none;" readonly="readonly" tabindex="136" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Property</td>
				<td class="leftAligned">
					<input class="allCaps" type="text" id="txtProperty" name="txtProperty" style="margin: 0 4px 2px 0; width: 312px;" maxlength="100" tabindex="137" />
				</td>
				<!-- <td class="rightAligned">
							<label class="rightAligned toLocal" id = "lblOtherCharges" style="width: 110px;">Other Charges</label>
						</td>
						<td class="leftAligned">
							<input class="rightAligned toLocal" type="text" id="txtLocalCharges" name="txtLocalCharges" style="width: 196px;"  readonly="readonly"/>
							<input class="rightAligned" type="text" id="txtForeignCharges" name="txtForeignCharges" style="width: 196px; display: none;"  readonly="readonly"/>
						</td> -->
				<td class="rightAligned">
					<label class="rightAligned toLocal" id="lblVatOnComm" style="width: 110px;">Vat on Comm</label>
				</td>
				<td class="leftAligned">
					<input class="rightAligned" type="text" id="txtLocalCommVat" name="txtLocalCommVat" style="margin: 0 4px 2px 0; width: 196px;" readonly="readonly" tabindex="138" />
					<input class="rightAligned" type="text" id="txtForeignCommVat" name="txtForeignCommVat" style="width: 196px; display: none;" readonly="readonly"  tabindex="139"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Payment Terms</td>
				<td class="leftAligned"><input class="allCaps" type="text" id="txtPaytTerm" name="txtPaytTerm" style="margin: 0 4px 0 0; width: 312px;" maxlength="3" tabindex="140" />
				</td>
				<!-- <td class="rightAligned">
							<label class="rightAligned toLocal" id = "lblCommissionAmount" style="width: 110px;">Commission Amount</label>
						</td>
						<td class="leftAligned">
							<input class="rightAligned toLocal" type="text" id="txtLocalComm" name="txtLocalComm" style="width: 196px;" readonly="readonly"/>
							<input class="rightAligned" type="text" id="txtForeignComm" name="txtForeignComm" style="width: 196px; display: none;" readonly="readonly"/>
						</td> -->
				<td class="rightAligned">
					<label class="rightAligned" id="lblTotalAmountDue" style="width: 110px;">Total Amount Due</label>
				</td>
				<td class="leftAligned">
					<input class="rightAligned toLocal" type="text" id="txtLocalTotalAmountDue" name="txtLocalTotalAmountDue" style="margin: 0 4px 0 0; width: 196px;" readonly="readonly" tabindex="141" />
					<input class="rightAligned" type="text" id="txtForeignTotalAmountDue" name="txtForeignTotalAmountDue" style="width: 196px; display: none;" readonly="readonly"  tabindex="142"/>
				</td>
			</tr>
			<tr>
				<td></td>
				<td></td>
				<!-- <td class="rightAligned">
							<label class="rightAligned toLocal" id = "lblVatOnComm" style="width: 110px;">Vat on Comm</label>
						</td>
						<td class="leftAligned">
							<input class="rightAligned toLocal" type="text" id="txtLocalCommVat" name="txtLocalCommVat" style="width: 196px;" readonly="readonly"/>
							<input class="rightAligned" type="text" id="txtForeignCommVat" name="txtForeignCommVat" style="width: 196px; display: none;" readonly="readonly"/>
						</td> -->
			</tr>
			<tr>
				<td colspan="4" align="center">
					<input type="button" class="button" id="btnTaxes" name="btnTaxes" value="Taxes" style="width: 95px; display: none;" />
					<input type="button" class="button" id="btnCurrencyInfo" name="btnCurrencyInfo" value="Currency Information" style="width: 150px; margin: 20px 0 0 0px;" />
				</td>
				<!-- <td class="rightAligned">
							<label class="rightAligned toLocal" id = "lblTotalAmountDue" style="width: 110px;">Total Amount Due</label>
						</td>
						<td class="leftAligned">
							<input class="rightAligned toLocal" type="text" id="txtLocalTotalAmountDue" name="txtLocalTotalAmountDue" style="width: 196px;" readonly="readonly"/>
							<input class="rightAligned" type="text" id="txtForeignTotalAmountDue" name="txtForeignTotalAmountDue" style="width: 196px; display: none;" readonly="readonly"/>
						</td> -->
			</tr>
		</table>
		<input type="text" id="txtCurrencyDesc" name="txtCurrencyDesc" style="width: 196px; display: none;" readonly="readonly" />
		<input type="text" id="txtCurrencyRt" name="txtCurrencyRt" style="width: 196px; display: none;" readonly="readonly" />
	</div>
	<div id="billPaymentTableDiv" class="sectionDiv">
		<div id="billPaymentTable" style="padding: 15px 20px 5px 20px; height: 190px;"></div>
		<div id="billPaymentTableTotalDiv" style="float: right; width: 100%; margin: 0 20px 30px 20px;">
			<table align="right" cellspacing="0">
				<tr>
					<td class="rightAligned">Total Amount</td>
					<td>
						<input class="rightAligned" type="text" id="txtcollectionTotal" name="txtcollectionTotal" style="width: 150px; margin: 0 20px 0 0;" readonly="readonly" tabindex="301" />
					</td>
					<td class="rightAligned">Total Foreign Amount</td>
					<td><input class="rightAligned" type="text" id="txtforeignTotal" name="txtforeignTotal" style="width: 150px;" readonly="readonly"  tabindex="303"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Balance Amount</td>
					<td>
						<input class="rightAligned" type="text" id="txtbalanceAmt" name="txtbalanceAmt" style="width: 150px;" readonly="readonly" tabindex="302"/>
					</td>
					<td class="rightAligned">Foreign Balance Amount</td>
					<td>
						<input class="rightAligned" type="text" id="txtforeignBalance" name="txtforeignBalance" style="width: 150px;" readonly="readonly" tabindex="304"/>
					</td>
				</tr>
			</table>
		</div>
	</div>
</div>

<script>
	initializeAll();
	setModuleId("GIACS270");
	setDocumentTitle("View Payments per Bill");
	giacs270GipiInvoice = [];
	foreignAmountOverlay = [];
	$("txtPremSeqNo").focus();

	try {
		//var jsonBillPayment = JSON.parse('${jsonGiacInwfaculPremCollnsTg}');
		billPaymentTableModel = {
			url : contextPath + "/GIACReinsuranceInquiryController?action=showRiBillPayment&refresh=1",
			options : {
				height : '180px',
				pager : {},
				onCellFocus : function(element, value, x, y, id) {
					tbgBillPayment.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					tbgBillPayment.keys.releaseKeys();
				},
				onSort : function() {
					tbgBillPayment.keys.releaseKeys();
				},
				postPager : function() {
					tbgBillPayment.keys.releaseKeys();
				},
				toolbar : {
					elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
					onFilter : function() {
						tbgBillPayment.keys.releaseKeys();
					},
					onRefresh : function() {
						tbgBillPayment.keys.releaseKeys();
					}
				}
			},
			columnModel : [ {
				id : 'recordStatus',
				width : '0',
				visible : false
			}, {
				id : 'divCtrId',
				width : '0',
				visible : false
			}, {
				id : "branchCd",
				title : "Branch",
				width : '50px',
				filterOption : true
			}, {
				id : "tranClass",
				title : "Class",
				width : '50px',
				altTitle : "Transaction Class",
				filterOption : true
			}, {
				id : "tranClassNo",
				title : "Class No.",
				width : '65px',
				align : "right",
				titleAlign : "right",
				filterOption : true,
				renderer : function(value) {
					return value == '' ? '' : formatNumberDigits(value, 10);
				}
			}, {
				id : "jvNo",
				title : "JV No.",
				width : '50px',
				align : "right",
				titleAlign : "right",
				filterOption : true
			}, {
				id : "tranYear",
				title : "Year",
				width : '50px',
				titleAlign : "right",
				align : "right",
				filterOptionType : 'number',
				titleAlign : "right",
				filterOption : true
			}, {
				id : "tranMonth",
				title : "Month",
				width : '50px',
				align : "right",
				titleAlign : "right",
				filterOptionType : 'number',
				filterOption : true,
				renderer : function(value) {
					return value == '' ? '' : formatNumberDigits(value, 2);
				}
			}, {
				id : "tranSeqNo",
				title : "Seq No.",
				width : '50px',
				align : "right",
				titleAlign : "right",
				filterOptionType : 'number',
				filterOption : true,
				renderer : function(value) {
					return value == '' ? '' : formatNumberDigits(value, 6);
				}
			}, {
				id : "tranDateChar",
				title : "Tran Date",
				width : '70px',
				align : "center",
				titleAlign : "center",
				filterOptionType : 'formattedDate',
				altTitle : "Transaction Date",
				filterOption : true
			}, {
				id : "refNo",
				title : "Reference No.",
				width : '115px',
				align : "left",
				filterOption : true
			}, {
				id : "transactionType",
				title : "Type",
				width : '30px',
				align : "center",
				titleAlign : "center",
				altTitle : "Transaction Type"
			//filterOption : true
			}, {
				id : "collectionAmt",
				title : "Amount",
				align : "right",
				titleAlign : "right",
				width : '130px',
				filterOptionType : 'number',
				filterOption : true,
				renderer : function(value) {
					return formatCurrency(value);
				}
			}, {
				id : "currencyDesc",
				title : "Currency",
				align : "left",
				titleAlign : "left",
				width : '60px'
			}, {
				id : "convertRate",
				title : "Rate",
				width : '100px',
				align : "right",
				titleAlign : "right",
				filterOptionType : 'number',
				filterOption : true,
				/*renderer : function(value) {
					return formatCurrency(value);
				}*/
			}, {
				id : "foreignCurrAmt",
				title : "Foreign Amount",
				align : "right",
				titleAlign : "right",
				width : '130px',
				filterOptionType : 'number',
				filterOption : true,
				renderer : function(value) {
					return formatCurrency(value);
				}
			}, ],
			rows : []
		};
		tbgBillPayment = new MyTableGrid(billPaymentTableModel);
		//tbgBillPayment.pager = jsonBillPayment;
		tbgBillPayment.render('billPaymentTable');
	} catch (e) {
		showErrorMessage("riBillPayments.jsp", e);
	}

	function getBillPaymentTbg(issCd, premSeqNo) {
		try {
			tbgBillPayment.url = contextPath
					+ "/GIACReinsuranceInquiryController?action=getGIACS270GiacInwfaculPremCollns&issCd="
					+ issCd + "&premSeqNo=" + premSeqNo;
			tbgBillPayment._refreshList();

			populateTotal(tbgBillPayment.geniisysRows);
		} catch (e) {
			showErrorMessage("getBillPaymentTbg", e);
		}
	}

	function getGipiInvoiceRiInfo(moduleId, billIssCd, premSeqNo) {
		try {
			new Ajax.Request(
					contextPath + "/GIACReinsuranceInquiryController",
					{
						method : "POST",
						parameters : {
							action : "getGIACS270GipiInvoice",
							moduleId : moduleId,
							issCd : billIssCd,
							premSeqNo : premSeqNo,
							objFilter : JSON.stringify(setGipiInvoiceInfoFilter())
						},
						asynchronous : true,
						evalScripts : true,
						onCreate : function() {
							showNotice("Loading, please wait...");
						},
						onComplete : function(response) {
							hideNotice();
							if (checkErrorOnResponse(response)) {
								var result = JSON.parse(response.responseText);
								giacs270GipiInvoice = result.rows[0];
								if (result.rows.length > 0) {
									populateGipiInvoiceRi(giacs270GipiInvoice);
									//getBillPaymentTbg(giacs270GipiInvoice.billIssCd, giacs270GipiInvoice.premSeqNo);
									$$("div#riBillPaymentMainDiv input[type='button']").each(function(a) {
										enableButton(a);
									});
									toggleFields(true);
									toggleCalendar(false);
									disableAllFields(false);
								} else {
									disableToolbarButton("btnToolbarExecuteQuery");
									showMessageBox( "Query caused no records to be retrieved. Re-enter.", "I");
								}
							}
						}
					});
		} catch (e) {
			showErrorMessage("getGipiInvoiceRiInfo", e);
		}
	}
	function populateGipiInvoiceRi(obj) {
		try {	
			$("txtBillIssCd").value 			= obj == null ? "" : nvl(obj.issCd, "");
			$("txtPremSeqNo").value 			= obj == null ? "" : lpad(nvl(obj.premSeqNo, ""), 12, '0');
			$("txtDueDate").value 				= obj == null ? "" : nvl(obj.dueDateChar, "");
			$("txtRiCd").value 					= obj == null ? "" : lpad(nvl(obj.riCd, ""), 5, '0');
			$("txtRiName").value 				= obj == null ? "" : nvl(obj.riName, "");
			$("txtAssuredNo").value 			= obj == null ? "" : lpad(nvl(obj.assdNo, ""), 6, '0');
			$("txtAssuredName").value 			= obj == null ? "" : unescapeHTML2(nvl(obj.assdName, ""));
			$("txtPolLineCd").value 			= obj == null ? "" : nvl(obj.lineCd, "");
			$("txtPolSublineCd").value 			= obj == null ? "" : nvl(obj.sublineCd,"");
			$("txtPolIssCd").value 				= obj == null ? "" : nvl(obj.issCd, "");
			$("txtPolIssueYy").value 			= obj == null ? "" : lpad(nvl(obj.issueYy, ""), 2, '0');
			$("txtPolSeqNo").value 				= obj == null ? "" : lpad(nvl(obj.polSeqNo, ""), 7, '0');
			$("txtPolRenewNo").value 			= obj == null ? "" : lpad(nvl(obj.renewNo, ""), 2, '0');
			$("txtEndtIssCd").value 			= obj == null ? "" : nvl(obj.endtIssCd, "");
			$("txtEndtIssueYy").value 			= obj == null ? "" : obj.endtYy == null ? "" : lpad(obj.endtYy, 2, '0');
			$("txtEndtSeqNo").value 			= obj == null ? "" : obj.endtSeqNo == null ? "" : lpad(obj.endtSeqNo, 6, '0');
			$("txtEndtType").value 				= obj == null ? "" : nvl(obj.endtType, "");
			$("txtPackLineCd").value 			= obj == null ? "" : nvl(obj.packLineCd, "");
			$("txtPackSublineCd").value 		= obj == null ? "" : nvl(obj.packSublineCd, "");
			$("txtPackIssCd").value 			= obj == null ? "" : nvl(obj.packIssCd, "");
			$("txtPackIssueYy").value 			= obj == null ? "" : obj.packIssueYy == null ? "" : lpad(obj.packIssueYy, 2, '0');
			$("txtPackSeqNo").value 			= obj == null ? "" : obj.packPolSeqNo == null ? "" : lpad(obj.packPolSeqNo, 7, '0');
			$("txtPackRenewNo").value 			= obj == null ? "" : obj.packRenewNo == null ? "" : lpad(obj.packRenewNo, 2, '0');
			$("txtPackEndtIssCd").value 		= obj == null ? "" : nvl(obj.packEndtIssCd, "");
			$("txtPackEndtIssueYy").value 		= obj == null ? "" : obj.packEndtYy == null ? "" : lpad(obj.packEndtYy, 2, '0');
			$("txtPackEndtSeqNo").value 		= obj == null ? "" : obj.packEndtSeqNo == null ? "" : lpad(obj.packEndtSeqNo, 6, '0');
			$("txtInceptionDate").value 		= obj == null ? "" : nvl(obj.inceptDateChar, "");
			$("txtExpiryDate").value 			= obj == null ? "" : nvl(obj.expiryDateChar, "");
			$("txtIssueDate").value 			= obj == null ? "" : nvl(obj.issueDateChar, "");
			$("txtPolFlag").value 				= obj == null ? "" : unescapeHTML2(nvl(obj.polFlag, ""));
			$("txtPolStatus").value 			= obj == null ? "" : unescapeHTML2(nvl(obj.policyStatus, ""));
			$("txtProperty").value 				= obj == null ? "" : unescapeHTML2(nvl(obj.property, ""));
			$("txtPaytTerm").value 				= obj == null ? "" : unescapeHTML2(nvl(obj.paytTerms, ""));
			$("txtLocalPrem").value 			= obj == null ? "" : formatCurrency(nvl(obj.localPrem, ""));
			//$("txtLocalTax").value  			= obj  			== null ? "" : formatCurrency(nvl(obj.localTax,""));
			//$("txtLocalCharges").value  		= obj  			== null ? "" : formatCurrency(nvl(obj.localCharges,""));
			$("txtLocalComm").value 			= obj == null ? "" : formatCurrency(nvl(obj.localComm, ""));
			$("txtLocalCommVat").value 			= obj == null ? "" : formatCurrency(nvl(obj.localCommVat, ""));
			$("txtLocalTotalAmountDue").value 	= obj == null ? "" : formatCurrency(nvl(obj.localtotalAmtDue, ""));
			$("txtForeignPrem").value 			= obj == null ? "" : formatCurrency(nvl(obj.foreignPrem, ""));
			//$("txtForeignTax").value  			= obj  			== null ? "" : formatCurrency(nvl(obj.foreignTax,""));
			//$("txtForeignCharges").value  		= obj  			== null ? "" : formatCurrency(nvl(obj.foreignCharges,""));
			$("txtForeignComm").value 			= obj == null ? "" : formatCurrency(nvl(obj.foreignComm, ""));
			$("txtForeignCommVat").value 		= obj == null ? "" : formatCurrency(nvl(obj.foreignCommVat, ""));
			$("txtForeignTotalAmountDue").value = obj == null ? "" : formatCurrency(nvl(obj.foreignTotAmtDue, ""));
			$("txtCurrencyDesc").value 			= obj == null ? "" : unescapeHTML2(nvl(obj.currDesc, ""));
			$("txtCurrencyRt").value 			= obj == null ? "" : formatCurrency(nvl(obj.currencyRt, ""));
		} catch (e) {
			showErrorMessage("populateGipiInvoiceRi", e);
		}
	}
	
	function populateTotal(obj) {
		try {
			obj = obj[obj.length - 1];
			$("txtcollectionTotal").value 	= obj == null ? "0.00" : formatCurrency(nvl(obj.totalCollnAmt, 0));
			$("txtbalanceAmt").value 		= obj == null ? $("txtLocalTotalAmountDue").value : formatCurrency(nvl(obj.balanceDue, 0));
			$("txtforeignBalance").value 	= obj == null ? $("txtForeignTotalAmountDue").value : formatCurrency(nvl(obj.foreignBalanceDue, 0));
			$("txtforeignTotal").value 		= obj == null ? "0.00" : formatCurrency(nvl(obj.totalForeignCollnAmt));
		} catch (e) {
			showErrorMessage("populateTotal", e);
		}
	}
	function setGipiInvoiceInfoFilter() {
		try {
			var obj = new Object();
			obj.dueDate 		= $F("txtDueDate").trim();
			obj.riCd 			= $F("txtRiCd").trim();
			obj.riName 			= $F("txtRiName").trim();
			obj.assdNo 			= $F("txtAssuredNo").trim();
			obj.assdName 		= $F("txtAssuredName").trim();
			obj.lineCd 			= $F("txtPolLineCd").trim();
			obj.sublineCd 		= $F("txtPolSublineCd").trim();
			obj.issCd 			= $F("txtPolIssCd").trim();
			obj.issueYy 		= $F("txtPolIssueYy").trim();
			obj.polSeqNo 		= $F("txtPolSeqNo").trim();
			obj.renewNo 		= $F("txtPolRenewNo").trim();
			obj.endtIssCd 		= $F("txtEndtIssCd").trim();
			obj.endtYy 			= $F("txtEndtIssueYy").trim();
			obj.endtSeqNo 		= $F("txtEndtSeqNo").trim();
			obj.endtType 		= $F("txtEndtType").trim();
			obj.packLineCd 		= $F("txtPackLineCd").trim();
			obj.packSublineCd 	= $F("txtPackSublineCd").trim();
			obj.packIssCd 		= $F("txtPackIssCd").trim();
			obj.packIssueYy 	= $F("txtPackIssueYy").trim();
			obj.packPolSeqNo 	= $F("txtPackSeqNo").trim();
			obj.packRenewNo 	= $F("txtPackRenewNo").trim();
			obj.packEndtIssCd 	= $F("txtPackEndtIssCd");
			obj.packEndtYy 		= $F("txtPackEndtIssueYy");
			obj.packEndtSeqNo 	= $F("txtPackEndtSeqNo");
			obj.inceptDateChar 	= $F("txtInceptionDate").trim();
			obj.expiryDateChar 	= $F("txtExpiryDate").trim();
			obj.issueDateChar 	= $F("txtIssueDate").trim();
			obj.polFlag 		= $F("txtPolFlag").trim();
			obj.property 		= $F("txtProperty").trim();
			obj.paytTerms 		= $F("txtPaytTerm").trim();
			return obj;
		} catch (e) {
			showErrorMessage("setGipiInvoiceInfoFilter", e);
		}
	}
	function newFormInstance() {
		try {
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
			$("txtcollectionTotal").value 	= "0.00";
			$("txtbalanceAmt").value 		= "0.00";
			$("txtforeignBalance").value 	= "0.00";
			$("txtforeignTotal").value 		= "0.00";
			$("txtBillIssCd").value 		= '${issCdRi}';
			$("txtPolIssCd").value 			= '${issCdRi}';

			$$("div#riBillPaymentMainDiv input[type='button']").each(
					function(a) {
						disableButton(a);
					});
		} catch (e) {
			showErrorMessage("newFormInstance", e);
		}
	}
	function checkBillNo() {
		var isOk = true;
		$$("div#riBillPaymentBodyDiv input[type='text'].billNoReq").each(
				function(a) {
					if ($F(a).trim() == "") {
						isOk = false;
						return isOk;
					}
				});
		return isOk;
	}
	function checkPolicyNo() {
		var isOk = true;
		$$("div#riBillPaymentBodyDiv input[type='text'].polNoReq").each(
				function(a) {
					if ($F(a).trim() == "") {
						isOk = false;
						return isOk;
					}
				});
		return isOk;
	}
	function disableAllFields(disable) {
		try {
			if (disable != false) disableToolbarButton("btnToolbarExecuteQuery");
			$$("div#riBillPaymentBodyDiv input[type='text']").each(function(a) {
				$(a).readOnly = "true";
			});
			$$("div#riBillPaymentBodyDiv img").each(function(img) {
				var src = img.src;
				if (nvl(img, null) != null) {
					if (src.include("searchIcon.png")) {
						disableSearch(img);
					} else if (src.include("but_calendar.gif")) {
						disableDate(img);
					}
				}
			});
		} catch (e) {
			showErrorMessage("disableAllFields", e);
		}
	}
	function showBillNoLOV(findBillNo, premSeqNo, riCd, assdNo, lineCd, id) {
		try {
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getRiBillNoLOV",
					riCd : riCd,
					assdNo : assdNo,
					lineCd : lineCd,
					premSeqNo : premSeqNo,
					findBillNo : findBillNo,
					dueDate:	$F("txtDueDate") == "" ? "" : $F("txtDueDate"),
					inceptDate:	$F("txtInceptionDate") == "" ? "" : $F("txtInceptionDate"),
					issueDate:	$F("txtIssueDate") == "" ? "" : $F("txtIssueDate"),
					expiryDate:	$F("txtExpiryDate") == "" ? "" : $F("txtExpiryDate"),
					page : 1
				},
				title : "Bill No. List",
				width : 370,
				height : 400,
				columnModel : [ {
					id : "issCd",
					title : "Issue Cd",
					width : '85px',
					sortable : false,
					align : 'left'
				}, {
					id : "premSeqNo",
					title : "Prem Seq No",
					width : '270px',
					sortable : true,
					align : 'right',
					titleAlign : "right"
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText : findBillNo,
				onSelect : function(row) {
					if (row != undefined) {
						$("txtBillIssCd").value = unescapeHTML2(row.issCd);
						$("txtPremSeqNo").value = lpad(row.premSeqNo, 12, '0');
						getGipiInvoiceRiInfo("GIACS270", $F("txtBillIssCd"), $F("txtPremSeqNo"));
						enableToolbarButton("btnToolbarEnterQuery");
						enableToolbarButton("btnToolbarExecuteQuery");
					}
				},
				onCancel : function() {
					$(id).focus();
				}
			});
		} catch (e) {
			showErrorMessage("showBillNoLOV", e);
		}
	}
	function showReinsurerLOV(findReinsurer, assdNo, lineCd, id) {
		try {
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getReinsurerLOV",
					assdNo : assdNo,
					lineCd : lineCd,
					findReinsurer : findReinsurer,
					page : 1
				},
				title : "List of Reinsurers",
				width : 400,
				height : 400,
				columnModel : [ {
					id : 'riCd',
					title : 'Reinsurer Code',
					width : '100px',
					align : 'right'
				}, {
					id : 'riName',
					title : 'Reinsurer Name',
					width : '285.5px',
					align : 'left'
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText : findReinsurer,
				onSelect : function(row) {
					if (row != undefined) {
						$("txtRiCd").value = lpad(row.riCd, 5, '0');
						$("txtRiName").value = unescapeHTML2(row.riName);
						enableToolbarButton("btnToolbarEnterQuery");
						//enableToolbarButton("btnToolbarExecuteQuery");
					}
				},
				onCancel : function() {
					$(id).focus();
				}
			});
		} catch (e) {
			showErrorMessage("showReinsurerLov", e);
		}
	}
	function showGiisAssuredLov2(findAssured, riCd, lineCd, id) {
		try {
			LOV
					.show({
						controller : "AccountingLOVController",
						urlParameters : {
							action : "getGiisAssuredLov2",
							riCd : riCd,
							lineCd : lineCd,
							findAssured : findAssured,
							page : 1
						},
						title : "List of Assureds",
						width : 400,
						height : 400,
						columnModel : [ {
							id : 'assdNo',
							title : 'Assured No.',
							width : '100px',
							align : 'right',
							titleAlign : 'right'
						}, {
							id : 'assdName',
							title : 'Assured Name',
							width : '285.5px',
							align : 'left'
						} ],
						draggable : true,
						autoSelectOneRecord: true,
						filterText : findAssured,
						onSelect : function(row) {
							if (row != undefined) {
								$("txtAssuredNo").value = lpad(row.assdNo, 6, '0');
								$("txtAssuredName").value = unescapeHTML2(row.assdName);
								enableToolbarButton("btnToolbarEnterQuery");
								//enableToolbarButton("btnToolbarExecuteQuery");
							}
						},
						onCancel : function() {
							$(id).focus();
						}
					});
		} catch (e) {
			showErrorMessage("showGiisAssuredLov2", e);
		}
	}
	function showPolicyNoLOV(findPolicyNo, riCd, assdNo, lineCd, sublineCd, id, issueYy, polSeqNo, renewNo) {
		try {
			LOV
					.show({
						controller : "AccountingLOVController",
						urlParameters : {
							action : "getPolicyNoLOV2",
							riCd : riCd,
							assdNo : assdNo,
							lineCd : lineCd,
							sublineCd : sublineCd,
							issueYy : issueYy,
							polSeqNo : polSeqNo,
							renewNo : renewNo,
							findPolicyNo : findPolicyNo,
							page : 1
						},
						title : "List of Policies",
						width : 400,
						height : 400,
						columnModel : [ {
							id : 'policyNo',
							title : 'Policy No. / Endt No.',
							width : '220px',
							align : 'left'
						}, {
							id : 'billNo',
							title : 'Invoice No.',
							width : '165px',
							align : 'left',
						} ],
						draggable : true,
						autoSelectOneRecord: true,
						filterText : findPolicyNo,
						onSelect : function(row) {
							if (row != undefined) {
								$("txtPolLineCd").value = unescapeHTML2(row.lineCd);
								$("txtPolSublineCd").value = unescapeHTML2(row.sublineCd);
								$("txtPolIssueYy").value = lpad(row.issueYy, 2, '0');
								$("txtPolSeqNo").value = lpad(row.polSeqNo, 7, '0');
								$("txtPolRenewNo").value = lpad(row.renewNo, 2, '0');
								$("txtEndtIssCd").value = unescapeHTML2(row.endtIssCd);
								$("txtEndtIssueYy").value = lpad(row.endtYy, 2, '0');
								$("txtEndtSeqNo").value = lpad(row.endtSeqNo, 6, '0');
								$("txtEndtType").value = unescapeHTML2(row.endtType);
								$("txtPremSeqNo").value = lpad(row.premSeqNo, 12, '0');
								getGipiInvoiceRiInfo("GIACS270", $F("txtBillIssCd"), $F("txtPremSeqNo"));
								enableToolbarButton("btnToolbarEnterQuery");
								enableToolbarButton("btnToolbarExecuteQuery");
							}
						},
						onCancel : function() {
							$(id).focus();
						}
					});
		} catch (e) {
			showErrorMessage("showPolicyNoLOV", e);
		}
	}
	function showCurrencyInfoOverlay() {
		currencyInfoOvlerlay = Overlay.show(contextPath + "/GIACReinsuranceInquiryController", {
			urlContent : true,
			urlParameters : {action : "showCurrencyInfoOverlay"},
			title : "Currency Information",
			height : 250,
			width : 400,
			draggable : true
		});
	}
	$("btnToolbarEnterQuery").observe("click", function() {
		showRiBillPayment(null, null, null);
	});
	$("btnToolbarExecuteQuery").observe(
			"click",
			function() {
				if (checkPolicyNo() || checkBillNo()) {
					disableAllFields();
					//getGipiInvoiceRiInfo("GIACS270", $F("txtBillIssCd"), $F("txtPremSeqNo"));
					getBillPaymentTbg(giacs270GipiInvoice.billIssCd, giacs270GipiInvoice.premSeqNo);
				} else {
					showMessageBox("Please enter Bill Number or Policy Number first.", "I");
				}
			});
	$("searchAssuredNo").observe(
			"click",
			function() {
				var findAssured = $F("txtAssuredNo") 		== "" ? "%" : $F("txtAssuredNo");
				var riCd 		= $F("txtRiCd") 			== "" ? "%" : $F("txtRiCd");
				var lineCd 		= $F("txtPolLineCd").trim() == "" ? "%" : $F("txtPolLineCd");
				showGiisAssuredLov2(findAssured, riCd, lineCd, "txtAssuredNo");
			});
	$("sRiBillNo")
			.observe(
					"click",
					function() {
						var findBillNo 	= $F("txtPremSeqNo") 		== "" ? "%" : $F("txtPremSeqNo");
						var riCd 		= $F("txtRiCd")				== "" ? "%" : $F("txtRiCd");
						var assdNo 		= $F("txtAssuredNo") 		== "" ? "%" : $F("txtAssuredNo");
						var lineCd		= $F("txtPolLineCd").trim() == "" ? "%" : $F("txtPolLineCd");
						var premSeqNo	= $F("txtPremSeqNo") == "" ? "%" : $F("txtPremSeqNo")	;
						showBillNoLOV(findBillNo, premSeqNo, riCd, assdNo, lineCd, "txtPremSeqNo");
					});
	$("searchRiNo").observe(
			"click",
			function() {
				var findReinsurer 	= $F("txtRiCd") 			== "" ? "%" : $F("txtRiCd");
				var assdNo 			= $F("txtAssuredNo") 		== "" ? "%" : $F("txtAssuredNo");
				var lineCd 			= $F("txtPolLineCd").trim() == "" ? "%" : $F("txtPolLineCd");
				showReinsurerLOV(findReinsurer, assdNo, lineCd, "txtRiCd");
			});
	$("sPolicyNo").observe(
			"click",
			function() {
				var findPolicyNo 	= $F("txtPolLineCd") 		== "" ? "%" : $F("txtPolLineCd");
				var riCd 			= $F("txtRiCd") 			== "" ? "%" : $F("txtRiCd");
				var assdNo			= $F("txtAssuredNo") 		== "" ? "%" : $F("txtAssuredNo");
				var lineCd 			= $F("txtPolLineCd").trim() == "" ? "%" : $F("txtPolLineCd");
				var sublineCd 		= $F("txtPolSublineCd") 	== "" ? "%" : $F("txtPolSublineCd");
				var issueYy 		= $F("txtPolIssueYy") 		== "" ? "%" : $F("txtPolIssueYy");
				var polSeqNo 		= $F("txtPolSeqNo") 		== "" ? "%" : $F("txtPolSeqNo");
				var renewNo 		= $F("txtPolRenewNo") 		== "" ? "%" : $F("txtPolRenewNo");
				showPolicyNoLOV(findPolicyNo, riCd, assdNo, lineCd, sublineCd, "txtPolLineCd", issueYy, polSeqNo, renewNo);
			});
	$("btnToolbarExit").observe(
			"click",
			function() {
				objACGlobal.callingForm = null;
				objACGlobal.issCd = null;
				objACGlobal.premSeqNo = null;
				goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
			});
	$$("div#riBillPaymentBodyDiv input[type='text'].integerUnformatted").each(
			function(a) {
				$(a).setStyle({
					textAlign : 'right'
				});
			});
	$$("div#riBillPaymentBodyDiv input[type='text']").each(function(a) {
		$(a).observe("change", function(e) {
			if($(a).value != ""){
				enableToolbarButton("btnToolbarEnterQuery");
			}
			else{
				disableToolbarButton("btnToolbarEnterQuery");
			}
			//enableToolbarButton("btnToolbarExecuteQuery");
		});
		$(a).setAttribute("ignoreDelKey", "1");
	});
	$$("div#riBillPaymentBodyDiv input[type='text'].disableDelKey").each(
			function(a) {
				$(a).observe("keydown", function(e) {
					if ($(a).readOnly && e.keyCode === 46) {
						$(a).blur();
					}
				});
			});
	$("btnCurrencyInfo").observe("click", function() {
		showCurrencyInfoOverlay();
	});
	
	$("txtAssuredNo").observe("change", function() {
		if($("txtAssuredNo").value == ""){
			$("txtAssuredName").clear();	
		}
		else{
			
		}
	});
	
	$("txtRiCd").observe("change", function() {
		if($("txtRiCd").value == ""){
			$("txtRiName").clear();	
		}
		else{
			
		}
	});
	
	function toggleCalendar(toggle){
		if(toggle){
			enableDate("hrefDueDate");
			enableDate("hrefInceptionDate");
			enableDate("hrefExpiryDate");
			enableDate("hrefIssueDate");
		}
		else{
			disableDate("hrefDueDate");
			disableDate("hrefInceptionDate");
			disableDate("hrefExpiryDate");
			disableDate("hrefIssueDate");
		}
	}
	function toggleFields(toggle){
		$("txtRiCd").readOnly = toggle;
		$("txtAssuredNo").readOnly = toggle;
		
		//policy no
		$("txtPolLineCd").readOnly = toggle;
		$("txtPolSublineCd").readOnly = toggle;
		$("txtPolIssCd").readOnly = toggle;
		$("txtPolIssueYy").readOnly = toggle;
		$("txtPolSeqNo").readOnly = toggle;
		$("txtPolRenewNo").readOnly = toggle;
		
		//endt no.
		$("txtEndtIssCd").readOnly = toggle;
		$("txtEndtIssueYy").readOnly = toggle;
		$("txtEndtSeqNo").readOnly = toggle;
		$("txtEndtType").readOnly = toggle;
		
		//package pol no.
		$("txtPackLineCd").readOnly = toggle;
		$("txtPackSublineCd").readOnly = toggle;
		$("txtPackIssCd").readOnly = toggle;
		$("txtPackIssueYy").readOnly = toggle;
		$("txtPackSeqNo").readOnly = toggle;
		$("txtPackRenewNo").readOnly = toggle;
		
		//package endt no.
		$("txtPackEndtIssCd").readOnly = toggle;
		$("txtPackEndtIssueYy").readOnly = toggle;
		$("txtPackEndtSeqNo").readOnly = toggle;
		$("txtPackEndtType").readOnly = toggle;
		
		//property and payment term
		$("txtProperty").readOnly = toggle;
		$("txtPaytTerm").readOnly = toggle;
	}
	
	newFormInstance();
</script>