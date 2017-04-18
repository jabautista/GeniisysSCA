<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="chengePayTermMainDiv" style="margin-bottom: 50px; float: left;">
	<!-- <div id="changePayTermExitDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="changePayTermExit">Exit</a>
					</li>
				</ul>
			</div>
		</div>
	</div> -->
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div style="width: 922px;"></div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Policy Information</label>
			<span class="refreshers"style="margin-top: 0;">
				<label id="lblShowPolicy" name="gro" style="margin-left: 5px;">Hide</label>
				<label id="lblReloadForm" name="reloadForm">Reload Form</label>
			</span>
		</div>
	</div>
	
	<div id="toolbarPolicy" name="toolbarPolicy" style="height: 110px;">
		<div class="sectionDiv" id="policyInfoDiv" name="policyInfoDiv" > 
			<div id="policyInfo" style="margin-top: 10px;" >
				<table align="center" >
					<tr>
						<td class="rightAligned">Policy No.</td>
						<td>
							<div style="border: 1px solid gray; height: 19px; float: right; width: 45px;">
								<input class="upper required" id="txtLineCd" type="text" title="Line Code" name="txtLineCd" value="" maxlength="2" style="width: 20px; height: 11px; border: none; float: left;" lastValidValue=""/>
								<img id="hrefLineCd" alt="Go" name="hrefLineCd" src="/Geniisys/images/misc/searchIcon.png" style="width: 17px; height: 16px;"> 
							 </div>
						</td>
						<td>
							<div style="border: 1px solid gray; height: 19px; float: right; width: 85px;">
								<input class="upper" id="txtSublineCd" type="text" title="Subline Code" name="txtSublineCd" value="" maxlength="6" style="width: 60px; height: 11px; border: none; float: left;" lastValidValue=""/>
								<img id="hrefSublineCd" alt="Go" name="hrefSublineCd" src="/Geniisys/images/misc/searchIcon.png" style="width: 17px; height: 16px;"> 
							 </div>
						</td>
						<td>
							<div style="border: 1px solid gray; height: 19px; float: right; width: 45px;">
								<input class="upper" id="txtIssCd" type="text" title="Issue Code" name="txtIssCd" value="" maxlength="2" style="width: 20px; height: 11px; border: none; float: left;" lastValidValue=""/>
								<img id="hrefIssCd" alt="Go" name="hrefIssCd" src="/Geniisys/images/misc/searchIcon.png" style="width: 17px; height: 16px;"> 
							 </div>
						</td>
						<td>
							<input class="upper integerNoNegativeUnformattedNoComma" type="text" name="txtIssueYy" id="txtIssueYy" style="width:25px; text-align: right;" title="Issue Year" maxlength="2"/>
							<input class="upper integerNoNegativeUnformattedNoComma" type="text" name="txtPolSeqNo" id="txtPolSeqNo" style="width:55px; text-align: right;" title="Policy Sequence No" maxlength="7"/>
							<input class="upper integerNoNegativeUnformattedNoComma" type="text" name="txtRenewNo" id="txtRenewNo" style="width:25px; text-align: right;" title="Renew No" maxlength="2"/>
						</td>
						<td valign="top">
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="hrefPolicyNo" name="hrefPolicyNo" alt="Go" style="width: 18px; height: 17px;"/>
						</td>
						<td class="rightAligned" style="padding-left: 10px;">Endt No.</td>
						<td>
							<input class="upper" id="txtEndtLineCd" type="text" readonly="readonly" title="Endt Line Code" name="txtEndtLineCd" value="" maxlength="2" style="width: 20px;"/>
						</td>
						<td>
							<input class="upper" id="txtEndtSublineCd" type="text" readonly="readonly" title="Endt Subline Code" name="txtEndtSublineCd" value="" maxlength="6" style="width: 60px;"/>
						</td>
						<td>
							<div style="border: 1px solid gray; height: 19px; float: right; width: 45px;">
								<input class="upper" id="txtEndtIssCd" type="text" title="Endt Issue Code" name="txtEndtIssCd" value="" maxlength="2" style="width: 20px; height: 11px; border: none; float: left;" lastValidValue=""/>
								<img id="hrefEndtIssCd" alt="Go" name="hrefEndtIssCd" src="/Geniisys/images/misc/searchIcon.png" style="width: 17px; height: 16px;"> 
							 </div>
						</td>
						<td>
							<input class="upper integerNoNegativeUnformattedNoComma" type="text" name="txtEndtYy" id="txtEndtYy" style="width:25px; text-align: right;" title="Issue Year" maxlength="2"/>
							<input class="upper integerNoNegativeUnformattedNoComma" type="text" name="txtEndtSeqNo" id="txtEndtSeqNo" style="width:45px; text-align: right;" title="Policy Sequence No" maxlength="6"/>
						</td>
					</tr>
				</table>
			</div>
			<div style="padding-left: 8px; padding-bottom: 5px;">
				<table align="center" >
					<td class="rightAligned">Assured</td>
					<td>
						<input id="txtAssured" type="text" readonly="readonly" value=""  name="txtAssured" style="width: 655px;"/>
					</td>
				</table>				
			</div>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Invoice Information</label>
			<span class="refreshers"style="margin-top: 0;">
				<label id="lblShowInvoice" name="gro" style="margin-left: 5px;">Hide</label>
			</span>
		</div>
	</div>
	
	<div class="sectionDiv" id="changePayTermDiv" name="changePayTermDiv" > 
	<div id="invoiceTG" name="invoiceTG" style="margin-left: 10px; margin-top: 10px; margin-bottom: 10px; height: 245px;"></div>
		<div id="changePayTerm" style="margin-top: 10px; margin-bottom: 10px;" >
			<table align="left" style="margin-left: 63px;">
				<tr>
					<td class="rightAligned">Invoice No.</td>
					<td class="leftAligned">
						<input id="txtInvIssCd" type="text" readonly="readonly" value=""  name="txtInvIssCd" style="width: 65px;"/>
						<input id="txtInvPremSeqNo" type="text" readonly="readonly" value=""  name="txtInvPremSeqNo" style="width: 121px; text-align: right;"/>
					</td>
					<td class="rightAligned" style="padding-left: 27px;">Premium</td>
					<td class="leftAligned">
						<input id="txtPremium" type="text" readonly="readonly" value=""  name="txtPremium" style="width: 237px; text-align: right;"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Item Group</td>
					<td class="leftAligned">
						<input id="txtInvItemGrp" type="text" readonly="readonly" value=""  name="txtInvItemGrp" style="width: 198px; text-align: right;"/>
					</td>
					<td class="rightAligned" style="padding-left: 27px;">Total Tax</td>
					<td class="leftAligned">
						<input id="txtTotalTax" type="text" readonly="readonly" value=""  name="txtTotalTax" style="width: 237px; text-align: right;"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Property/ Item</td>
					<td class="leftAligned">
						<input id="txtPropertyItem" type="text" readonly="readonly" value=""  name="txtPropertyItem" style="width: 285px;"/>
					</td>
					<td class="rightAligned" style="padding-left: 27px;">Other Charges</td>
					<td class="leftAligned">
						<input id= "txtOtherCharges" type="text" readonly="readonly" value=""  name="txtOtherCharges" style="width: 237px; text-align: right;"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Payterm</td>
					<td>
						<table>
							<tr>
								<td>
									<div style="border: 1px solid gray; height: 19px; float: right; width: 220px;">
										<input id="txtPayTerm" readonly="readonly" type="text" name="txtPayTerm" value="" style="width: 195px; border: none; float: left; height: 11px;"/>
										<img id="hrefPayTerm" alt="Go" name="hrefPayTerm" src="/Geniisys/images/misc/searchIcon.png" style="width: 17px; height: 16px;"/>
									</div>
								<td>
									<input id="txtPayTermNo" readonly="readonly" type="text" value=""  name="txtPaytermNo" style="width: 60px; text-align: right;"/>
								</td>
							</tr>
						</table>
						 	
					</td>
					<td class="rightAligned" style="padding-left: 27px;">Notarial Fee</td>
					<td class="leftAligned">
						<input id="txtNotarialFee" type="text" readonly="readonly" value=""  name="txtNotarialFee" style="width: 237px; text-align: right;"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Due Date</td>
					<td class="leftAligned">
						<input id="txtDueDate" type="text" value=""  name="txtDueDate" style="width: 285px;"/>
					</td>
					<td class="rightAligned" style="padding-left: 27px;">Total Amount</td>
					<td class="leftAligned">
						<input id="txtTotalAmount" readonly="readonly" type="text" readonly="readonly" value=""  name="txtTotalAmount" style="width: 237px; text-align: right;"/>
					</td>
				</tr>
				<tr>
				<td class="rightAligned">Remarks</td>
				<td class="leftAligned" colspan="3">
					<div style="border: 1px solid gray; height: 19px; width: 661px;">
						<textarea id="txtRemarks" readonly="readonly" name="txtRemarks" style="border: none; height: 12px; resize: none; width: 626px; vertical-align: text-top;" maxlength="4000"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="EditRemark" id="editRemarksText" tabindex=206/>
					</div>
				</td>
				</tr>
			</table>
			<div align="center">
				<input type="button" class="button" style="width: 130px; margin-top: 10px;" id="btnApply" name="btnApply" value="Apply" />
			</div>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Tax Allocation</label>
			<span class="refreshers"style="margin-top: 0;">
				<label id="lblTaxAllocation" name="gro" style="margin-left: 5px;">Hide</label>
			</span>
		</div>
	</div>
	<jsp:include page="/pages/accounting/cashReceipts/utilities/changeInPaymentTerm/subPages/taxAllocation.jsp"></jsp:include>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Payment Schedule</label>
			<span class="refreshers"style="margin-top: 0;">
				<label id="lblPaymentSchedule" name="gro" style="margin-left: 5px;">Hide</label>
			</span>
		</div>
	</div>
	<jsp:include page="/pages/accounting/cashReceipts/utilities/changeInPaymentTerm/subPages/invoiceInformation.jsp"></jsp:include>
	
	<div align="center">
		<input type="button" class="button" style="width: 130px; margin-top: 10px;" id="btnCancel" name="btnCancel" value="Cancel" />
		<input type="button" class="button" style="width: 130px; margin-top: 10px;" id="btnSave" name="btnSave" value="Save" />
	</div>
	<input id="txtOldPayDesc" type="hidden" value=""/>
	<input id="txtOldNoOfPayt" type="hidden" value=""/>
</div>

<script type="text/javascript">
	setModuleId("GIUTS022");
	setDocumentTitle("Change in Payment Term");
	initializeAll();
	initializeAccordion();
	initializeAllMoneyFields();
	makeInputFieldUpperCase();
	objNewPaySched = new Object();
	objNewPaySched.newSched = [];
	objNewPaySched.commitSw = null;
	objNewPaySched.premAmt = null;
	policyId = null;
	incept = null;
	expiry = null;
	var policyRecord = null;
	//showToolbarButton("btnToolbarSave");
	selRow = null;
	objGiuts022 = {};
	objGiuts022.exitPage = null;
	var changeTerm = "";
	var changeNoTerm = "";
	var changeTermtag = 0;
	
	/////LOV
	function showPolicyListingForGIUTS022() {
		LOV.show({
			controller 	  	: "AccountingLOVController",
			urlParameters 	: {
				action 		: "showGIUTS022PolicyLOV",
				lineCd 		: $F("txtLineCd"),
				sublineCd 	: $F("txtSublineCd"),
				issCd 		: $F("txtIssCd"),
				issueYy 	: $F("txtIssueYy"),
				polSeqNo 	: $F("txtPolSeqNo"),
				renewNo 	: $F("txtRenewNo"),
				endtIssCd 	: $F("txtEndtIssCd"),
				endtYy 		: $F("txtEndtYy"),
				endtSeqNo 	: $F("txtEndtSeqNo")
			},
			title : "List of Policies",
			width : 900,
			height : 390,
			autoSelectOneRecord : true,
			columnModel : [ {
				id 		: 'policyId',
				width 	: '0px',
				visible : false
			}, {
				id 		: 'lineCd',
				width 	: '0px',
				visible : false
			}, {
				id 		: 'sublineCd',
				width 	: '0px',
				visible : false
			}, {
				id 		: 'issCd',
				width 	: '0px',
				visible : false
			}, {
				id 		: 'issueYy',
				width 	: '0px',
				visible : false
			}, {
				id 		: 'polSeqNo',
				width 	: '0px',
				visible : false
			}, {
				id 		: 'renewNo',
				width 	: '0px',
				visible : false
			}, {
				id 		: 'endtIssCd',
				width 	: '0px',
				visible : false
			}, {
				id 		: 'endtYy',
				width 	: '0px',
				visible : false
			}, {
				id 		: 'endtSeqNo',
				width 	: '0px',
				visible : false
			}, {
				id 		: 'policyNo',
				title 	: 'Policy No.',
				width 	: '200px'
			}, {
				id 		: 'endtNo',
				title 	: 'Endt No.',
				width 	: '200px'
			}, {
				id 		: 'assdName',
				title 	: 'Assured Name',
				width 	: '460px'
			} ],
			draggable : true,
			onSelect : function(row) {
				$("txtLineCd").value 		= row.lineCd;
				$("txtSublineCd").value 	= row.sublineCd;
				$("txtIssCd").value 		= row.issCd;
				$("txtIssueYy").value 		= formatNumberDigits(row.issueYy, 2);
				$("txtPolSeqNo").value 		= formatNumberDigits(row.polSeqNo, 6);
				$("txtRenewNo").value 		= formatNumberDigits(row.renewNo, 2);
				$("txtEndtLineCd").value 	= row.lineCd;
				$("txtEndtSublineCd").value = row.sublineCd;
				$("txtEndtIssCd").value 	= row.endtIssCd;
				$("txtEndtYy").value 		= formatNumberDigits(row.endtYy, 2);
				$("txtEndtSeqNo").value 	= formatNumberDigits(row.endtSeqNo, 2);
				$("txtAssured").value 		= unescapeHTML2(row.assdName);
				policyId 					= row.policyId;
				applyTag = 0;
				enableToolbarButton("btnToolbarExecuteQuery");
				enableToolbarButton("btnToolbarEnterQuery");
				policyRecord = true;
			}
		});
	}
	
	function showLineLOV022(isIconClicked) {
		try {
			var searchString = isIconClicked ? "%" : ($F("txtLineCd").trim() == "" ? "%" : $F("txtLineCd"));
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getLineGIUTS022LOV",
					search : searchString + "%"
				},
				title: "List of Lines",
				width : 405,
				height : 386,
				autoSelectOneRecord : true,
				filterText : searchString,
				columnModel : [
				{
					id : "lineCd",
					title : "Line Code",
					width : '80px'
				},
				{
					id : "lineName",
					title : "Line Name",
					width : '310px'
				}],
				draggable : true,
				onSelect : function(row) {
					$("txtLineCd").value = unescapeHTML2(row.lineCd);
					$("txtLineCd").setAttribute("lastValidValue", $F("txtLineCd"));
					$("txtSublineCd").focus();
					enableToolbarButton("btnToolbarEnterQuery");
				},
				onUndefinedRow : function() {
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtLineCd");
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
				},
				onCancel : function() {
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
					$("txtLineCd").focus();
				}
			});
		} catch (e) {
			showErrorMessage("showLineLOV022", e);
		}
	}

	function showSublineLOV022(isIconClicked) {
		try {
			var searchString = isIconClicked ? "%" : ($F("txtSublineCd").trim() == "" ? "%" : $F("txtSublineCd"));
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters 	: {
					action 		: "getSublineGIUTS022LOV",
					lineCd 		: $F("txtLineCd"),
					search 		: searchString + "%",
					page 		: 1
				},
				title: "List of Sublines",
				width : 405,
				height : 386,
				autoSelectOneRecord : true,
				filterText : searchString,
				columnModel : [{
					id : "sublineCd",
					title : "Subline Code",
					width : '80px'
				},
				{
					id : "sublineName",
					title : "Subline Name",
					width : '310px'
				}],
				draggable : true,
				onSelect : function(row) {
					$("txtSublineCd").value = unescapeHTML2(row.sublineCd);
					$("txtSublineCd").setAttribute("lastValidValue", $F("txtSublineCd"));
					$("txtIssCd").focus();
					enableToolbarButton("btnToolbarEnterQuery");
				},
				onUndefinedRow : function() {
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtSublineCd");
					$("txtSublineCd").value = $("txtSublineCd").readAttribute("lastValidValue");
				},
				onCancel : function() {
					$("txtSublineCd").value = $("txtSublineCd").readAttribute("lastValidValue");
					$("txtSublineCd").focus();
				}
			});
		} catch (e) {
			showErrorMessage("showSublineLOV022", e);
		}
	}
	
	function showIssLOV022(isIconClicked, action, search, next, focus) {
		try {
			var searchString = isIconClicked ? "%" : (search.value.trim() == "" ? "%" : search.value);
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters 	: {
					action 		: action,
					search 		: searchString + "%",
					page 		: 1
				},
				title: "List of Issue Sources",
				width : 405,
				height : 386,
				autoSelectOneRecord : true,
				filterText : searchString,
				columnModel : [ {
					id 		: "issCd",
					title 	: "Iss Code",
					width 	: '80px'
				}, {
					id 		: "issName",
					title 	: "Iss Name",
					width 	: '310px'
				} ],
				draggable : true,
				onSelect : function(row) {
					search.value = unescapeHTML2(row.issCd);
					search.setAttribute("lastValidValue", search.value);
					next.focus();
					enableToolbarButton("btnToolbarEnterQuery");
				},
				onUndefinedRow : function() {
					showMessageBox("No record selected.", imgMessage.INFO);
					search.value = search.readAttribute("lastValidValue");
				},
				onCancel : function() {
					search.value = search.readAttribute("lastValidValue");
					$("txtSublineCd").focus();
				}
			});
		} catch (e) {
			showErrorMessage("showIssLOV022", e);
		}
	}
	
	function showPaytermLOV022() {
		try {
			LOV.show({
				controller 		: "AccountingLOVController",
				urlParameters 	: {
					action 		: "getPaytermGIUTS022LOV",
					page 		: 1
				},
				title : "List of Payment Terms",
				width : 405,
				height : 386,
				columnModel : [ {
					id 		: "paytTermsDesc",
					title 	: "Payment Terms",
					width 	: '310px'
				}, {
					id 		: "noOfPayt",
					title 	: "Payments",
					width 	: '80px'
				}, {
					id 		: "paytTerms",
					width 	: '0px',
					visible : false
				} ],
				draggable : true,
				onSelect : function(row) {
					$("txtPayTerm").value   = unescapeHTML2(row.paytTermsDesc);
					$("txtPayTermNo").value = row.noOfPayt;
					objInvLists.paytTerms = row.paytTerms;
					changeTerm = unescapeHTML2(row.paytTermsDesc);
					changeNoTerm = row.noOfPayt;
					invTableGrid.updateVisibleRowOnly(objInvLists, selRow, true);
					invInfoListTableGrid.clear();
					getDueDate(policyId, row.paytTerms); //carlo SR 5928 02-14-2017
					if ($("txtOldPayDesc").value == $("txtPayTerm").value) {
						disableButton("btnApply");
					} else {
						enableButton("btnApply");
						changeTermtag = 1;
					}
				},
				onCancel : function() {
					$("txtPayTerm").focus();
				}
			});
		} catch (e) {
			showErrorMessage("showPaytermLOV022", e);
		}
	}
	
	function getDueDate(policyId, payTerm){ //carlo SR 5928 02-14-2017
		var dueDate;
		try{
			new Ajax.Request(contextPath + "/GIUTSChangeInPaymentTermController?action=getDueDate", {
				parameters : {
					policyId    : policyId,
					paytTerm 	: payTerm,
					premSeqNo 	: $("txtInvPremSeqNo").value
				},
				asynchronous : false,
				evalScripts : true,
				onComplete : function(response) {
					var obj = JSON.parse(response.responseText);
					$("txtDueDate").value = nvl(dateFormat(obj.dueDate, 'mm-dd-yyyy'), "");
				}
			});
		} catch (e) {
			showErrorMessage("getDueDate", e);
		}
	}

	/* function resultGet() {		commented by: kenneth L. 06.14.2013
		new Ajax.Request(contextPath + "/GIUTSChangeInPaymentTermController?refresh=1", {
			method 			: "POST",
			parameters 		: {
				action 		: "showChangeInPaymentTerm",
				policyId 	: policyId
			},
			asynchronous : true,
			evalScripts : true,
			onComplete : function(response) {
				if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
					var invoice = JSON.parse(response.responseText);
					invTableGrid.refreshURL(invTableGrid);
					invTableGrid.refresh(); 
					
					populateInvoiceField(invoice);

					invInfoListTableGrid.url = contextPath + "/GIUTSChangeInPaymentTermController?action=getInstallmentDetails&refresh=1"
												+ "&issCd=" + invoice.issCd + "&premSeqNo=" + invoice.premSeqNo;
					invInfoListTableGrid.refreshURL(invInfoListTableGrid);
					invInfoListTableGrid.refresh();

					taxAllocationTableGrid.url = contextPath + "/GIUTSChangeInPaymentTermController?action=getTaxAllocation&refresh=1"
												+ "&issCd=" + invoice.issCd + "&premSeqNo=" + invoice.premSeqNo;
					taxAllocationTableGrid.refreshURL(taxAllocationTableGrid);
					taxAllocationTableGrid.refresh();

				}
			}
		});
	} */

	function populateInvoiceField(invoice) {
		$("txtInvIssCd").value 		= invoice == null ? "" : invoice.issCd;
		$("txtInvPremSeqNo").value 	= invoice == null ? "" : formatNumberDigits(invoice.premSeqNo, 12);
		$("txtInvItemGrp").value 	= invoice == null ? "" : formatNumberDigits(invoice.itemGrp, 4);
		$("txtPropertyItem").value 	= invoice == null ? "" : unescapeHTML2(invoice.property);
		$("txtRemarks").value 		= invoice == null ? "" : unescapeHTML2(invoice.remarks);
		$("txtPremium").value 		= invoice == null ? "" : formatCurrency(invoice.premAmt);
		$("txtTotalTax").value 		= invoice == null ? "" : formatCurrency(invoice.taxAmt);
		$("txtOtherCharges").value 	= invoice == null ? "" : formatCurrency(invoice.otherCharges);
		$("txtNotarialFee").value  	= invoice == null ? "" : formatCurrency(invoice.notarialFee);
		$("txtDueDate").value 		= invoice == null ? "" : dateFormat(invoice.dueDate, 'mm-dd-yyyy'),
		/* $("txtPayTerm").value 		= invoice == null ? "" : unescapeHTML2(invoice.paytTermsDesc); removed by kenneth L. 03.13.2014
		$("txtPayTermNo").value 	= invoice == null ? "" : invoice.noOfPayt; */
		$("txtTotalAmount").value 	= invoice == null ? "" : formatCurrency(invoice.totalAmt);
		/* $("txtOldPayDesc").value 	= invoice == null ? "" : unescapeHTML2(invoice.paytTermsDesc);removed by kenneth L. 03.13.2014
		$("txtOldNoOfPayt").value 	= invoice == null ? "" : invoice.noOfPayt; */
		if(changeTermtag == 0){	//added by kenneth L. 03.13.2014
			$("txtPayTerm").value 		= invoice == null ? "" : unescapeHTML2(invoice.paytTermsDesc);
			$("txtPayTermNo").value 	= invoice == null ? "" : invoice.noOfPayt;
			$("txtOldPayDesc").value 	= invoice == null ? "" : unescapeHTML2(invoice.paytTermsDesc);
			$("txtOldNoOfPayt").value 	= invoice == null ? "" : invoice.noOfPayt;
		}else{
			$("txtPayTerm").value 		= invoice == null ? "" : unescapeHTML2(changeTerm);
			$("txtPayTermNo").value 	= invoice == null ? "" : changeNoTerm;
			$("txtOldPayDesc").value 	= invoice == null ? "" : unescapeHTML2(changeTerm);
			$("txtOldNoOfPayt").value 	= invoice == null ? "" : changeNoTerm;
		}
		origPayTerms   				= invoice == null ? "" : invoice.paytTerms;
		objNewPaySched.premAmt 		= invoice == null ? "" : invoice.premAmt;
		issCd2 						= invoice == null ? "" : invoice.issCd;
		premSeqNo2 					= invoice == null ? "" : invoice.premSeqNo;
	}

	function saveChanges() {
		if (changeTag == 1) {
			if (objNewPaySched.commitSw == 0) {
				objTaxAllocation.saveAllocation();
				saveChangeInPaymentMode();
				//showMessageBox(objCommonMessage.SUCCESS, "S");
				showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
					if(objGiuts022.exitPage != null) {
						objGiuts022.exitPage();
					} else {
						invTableGrid._refreshList();
					}
				});
			} else if (objNewPaySched.commitSw == 1) {
				saveChangeInPaymentMode();
				objNewPaySched.commitSw = 1;
				objChangePayTerm.updateDueDate();
				objTaxAllocation.saveAllocation();
			} else if (objNewPaySched.commitSw == 2) {
				objChangePayTerm.updateDueDate();
				objTaxAllocation.saveAllocation();
			} else if (objNewPaySched.commitSw == 3) {
				objChangePayTerm.updateDueDate();
				objTaxAllocation.saveAllocation();
			}
			changeTag  = 0;
			saveChange = 0;
			changeTermtag = 0;
			changeTagFunc = "";
			applyTag   = null;
			applyTax   = null;
			objTax     = null;
			objNewPaySched.commitSw = null;
			objNewPaySched.clearFields();
			invInfoListTableGrid.refresh();
			taxAllocationTableGrid.refresh();
			invTableGrid._refreshList();
		} else {
			showMessageBox(objCommonMessage.NO_CHANGES, imgMessage.INFO);
		}
	}
	
	objNewPaySched.saveAllChanges = saveChanges;

	function saveChangeInPaymentMode() {
		new Ajax.Request(contextPath + "/GIUTSChangeInPaymentTermController?", {
			parameters : {
				action 			: "updatePaymentTerm",
				issCd 			: $("txtIssCd").value,
				premSeqNo 		: $("txtInvPremSeqNo").value,
				itemGrp 		: $("txtInvItemGrp").value,
				policyId 		: policyId,
				dueDate 		: dateFormat($("txtDueDate").value, 'mm-dd-yyyy'),
				paytTermsDesc 	: $("txtPayTerm").value,
				premAmt 		: unformatNumber($("txtPremium").value),
				otherCharges 	: unformatNumber($("txtOtherCharges").value),
				notarialFee 	: unformatNumber($("txtNotarialFee").value),
				taxAmt 			: unformatNumber($("txtTotalTax").value),
				commitChanges 	: "Y"
			},
			asynchronous : false,
			evalScripts : true,
			onComplete : function(response) {
				disableButton("btnSave");
			}
		});
	}

	/*moved to invoiceInformation.jsp kenneth L. 06.19.2013
 	function getInceptExpiry() {
		new Ajax.Request(contextPath + "/GIUTSChangeInPaymentTermController?action=getDates", {
			parameters : {
				lineCd 		: $("txtLineCd").value,
				sublineCd 	: $("txtSublineCd").value,
				issCd 		: $("txtIssCd").value,
				issueYy 	: unformatNumber($("txtIssueYy").value),
				polSeqNo 	: unformatNumber($("txtPolSeqNo").value),
				renewNo 	: unformatNumber($("txtRenewNo").value),
				invDueDate	: makeDate("01-01-1990")
			},
			asynchronous : false,
			evalScripts : true,
			onComplete : function(response) {
				var res = JSON.parse(response.responseText);
				incept  = JSON.stringify(res.inceptDate);
				expiry  = JSON.stringify(res.expiryDate);
				enableSearch("hrefPayTerm"); 
				
			}
		});
	}; */

	function onOk() {
		new Ajax.Request(contextPath + "/GIUTSChangeInPaymentTermController?", {
			parameters : {
				action 			: "updatePaymentTerm",
				issCd 			: $("txtInvIssCd").value,
				premSeqNo 		: $("txtInvPremSeqNo").value,
				itemGrp 		: $("txtInvItemGrp").value,
				policyId 		: policyId,
				dueDate 		: dateFormat($("txtDueDate").value, 'mm-dd-yyyy'),
				paytTermsDesc 	: $("txtPayTerm").value,
				premAmt 		: unformatNumber($("txtPremium").value),
				otherCharges 	: unformatNumber($("txtOtherCharges").value),
				notarialFee 	: unformatNumber($("txtNotarialFee").value),
				taxAmt 			: unformatNumber($("txtTotalTax").value),
				commitChanges 	: "N"
			},
			asynchronous : true,
			evalScripts : true,
			onComplete : function(response) {
				if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
					objNewPaySched.commitSw = 0;
					changeTag = 1;
					applyTag = 1;
					applyTax = 2;
					updateNew = JSON.parse(response.responseText);
					invInfoListTableGrid.empty();
					for ( var i = updateNew.newItems.length - 1; i > -1; i--) {
						invInfoListTableGrid.createNewRow(updateNew.newItems[i]);
					}
					
					objNewPaySched.newSched = invInfoListTableGrid.getNewRowsAdded();
					objChangePayTerm.updateTotal();
					
					disableButton("btnApply"); //marco - 07.21.2014
					enableButton("btnSave");
				}
			}
		});
		$("txtOldPayDesc").value  = $("txtPayTerm").value;
		$("txtOldNoOfPayt").value = $("txtPayTermNo").value;
	}

	function onCancel() {
		changeTagFunc = "";
		$("txtPayTerm").value   = $("txtOldPayDesc").value;
		$("txtPayTermNo").value = $("txtOldNoOfPayt").value;
		objInvLists.paytTerms = origPayTerms;
		invTableGrid.updateVisibleRowOnly(objInvLists, selRow, true);
		changeTermtag = 0;
	}
	

	function checkIfCanChange() {
		new Ajax.Request(contextPath + "/GIUTSChangeInPaymentTermController?action=checkIfCanChange", {
			parameters : {
				lineCd 		: $("txtLineCd").value,
				policyId 	: policyId,
				issCd 		: $("txtInvIssCd").value,
				premSeqNo 	: $("txtInvPremSeqNo").value
			},
			asynchronous : false,
			evalScripts : true,
			onComplete : function(response) {
				if (response.responseText == '0') {
					customShowMessageBox("Error in getting value from giis_parameters for parameter ri_iss_cd", imgMessage.INFO, "txtPayTerm");
					disableSearch("hrefPayTerm");
				} else if (response.responseText == '1') {
					customShowMessageBox("This bill " + ($("txtInvIssCd").value + " - " + $("txtInvPremSeqNo").value) + " is fully paid. You cannot change the payment term of a fully paid invoice.", imgMessage.INFO, "txtPayTerm"); /*EDITED "paid, You" to "paid. You" MarkS SR-5524 */
					disableSearch("hrefPayTerm");
				} else if (response.responseText == '2') {
					customShowMessageBox("This bill " + ($("txtInvIssCd").value + " - " + $("txtInvPremSeqNo").value) + " has partial payments, reverse all payments thru JV before modifying this bill.", imgMessage.INFO, "txtPayTerm");
					disableSearch("hrefPayTerm");
				} else if (response.responseText == '3') {
					customShowMessageBox("This bill " + ($("txtInvIssCd").value + " - " + $("txtInvPremSeqNo").value) + " is fully paid. You cannot change the payment term of a fully paid invoice.", imgMessage.INFO, "txtPayTerm"); /*EDITED "paid, You" to "paid. You" MarkS SR-5524 */                               
					disableSearch("hrefPayTerm");
				} else if (response.responseText == '4') {
					customShowMessageBox("This bill " + ($("txtInvIssCd").value + " - " + $("txtInvPremSeqNo").value) + " has partial payments, reverse payment first thru JV before modifying this bill.", imgMessage.INFO, "txtPayTerm");
					disableSearch("hrefPayTerm");
				} else {
					showPaytermLOV022();
				}
			}
		});
	};

	function newOne() {
		showConfirmBox("Information Message", "Changing this payment term will recreate payment schedule for this invoice. Do you want to continue?", "Continue", "Cancel", onOk, onCancel, null);
		changeTagFunc = saveChanges;
	}

	observeReloadForm("lblReloadForm", function() {
		new Ajax.Request(contextPath + "/GIUTSChangeInPaymentTermController", {
			parameters : {
				action : "showChangeInPaymentTerm"
			},
			onComplete : function(response) {
				try {
					if (checkErrorOnResponse(response)) {
						$("dynamicDiv").update(response.responseText);
					}
				} catch (e) {
					showErrorMessage("showChangeInPaymentTerm", e);
				}
			}
		});
	});

	function clearFields() {
		$("txtInstNo").value     = "";
		$("txtTaxAmount").value  = "";
		$("txtSharePct").value   = "";
		$("txtPremAmnt").value   = "";
		$("txtInvDueDate").value = "";
		$("txtTaxCd").value 	 = "";
		$("txtTaxAmt").value     = "";
		$("txtTaxDesc").value    = "";
		$("dDnTaxAlloc").value   = "First";
	}

	objNewPaySched.clearFields   = clearFields;

	/* observeCancelForm("btnCancel", saveChanges, function() {
		changeTag = 0;
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");
	}); */

	$("btnCancel").observe("click", cancelChangeInPaymentMode);
	
	/* observeCancelForm("changePayTermExit", saveChanges, function() {
		changeTag = 0;
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");
	}); */

	observeCancelForm("btnToolbarExit", saveChanges, function() {
		changeTag = 0;
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");
	});

	$("txtIssueYy").observe("change", function() {
		$("txtIssueYy").value = $F("txtIssueYy") != "" ? Number($F("txtIssueYy")).toPaddedString(2) : "";
	});

	$("txtPolSeqNo").observe("change", function() {
		$("txtPolSeqNo").value = $F("txtPolSeqNo") != "" ? Number($F("txtPolSeqNo")).toPaddedString(7) : "";
	});

	$("txtRenewNo").observe("change", function() {
		$("txtRenewNo").value = $F("txtRenewNo") != "" ? Number($F("txtRenewNo")).toPaddedString(2) : "";
	});

	$("txtEndtSeqNo").observe("change", function() {
		$("txtEndtSeqNo").value = $F("txtEndtSeqNo") != "" ? Number($F("txtEndtSeqNo")).toPaddedString(6) : "";
	});

	$("txtEndtYy").observe("change", function() {
		$("txtEndtYy").value = $F("txtEndtYy") != "" ? Number($F("txtEndtYy")).toPaddedString(2) : "";
	});

	$("txtLineCd").observe("change", function(e) {
		enableToolbarButton("btnToolbarEnterQuery");
		$("txtEndtLineCd").value = $F("txtLineCd");
	});

	$("txtSublineCd").observe("change", function(e) {
		enableToolbarButton("btnToolbarEnterQuery");
		$("txtEndtSublineCd").value = $F("txtSublineCd");
	});

	$("btnToolbarExecuteQuery").observe("click", function() {
		if(policyRecord == false){
			showMessageBox("Record does not exist.", "I");
		}else{
			//resultGet();		commented by : kenneth L. 06.14.2013 
			//getInceptExpiry();
			invTableGrid.url = contextPath + "/GIUTSChangeInPaymentTermController?action=showChangeInPaymentTerm&refresh=1"
										+ "&policyId=" + policyId;
			//invTableGrid.refreshURL(invTableGrid);
			invTableGrid._refreshList();
			disableButton("btnInvApply");
			disableButton("btnApply");
			disableButton("btnSave");
			disableButton("btnInvUpdate");
			disableInputField("txtLineCd");
			disableInputField("txtSublineCd");
			disableInputField("txtIssCd");
			disableInputField("txtIssueYy");
			disableInputField("txtPolSeqNo");
			disableInputField("txtRenewNo");
			disableInputField("txtEndtIssCd");
			disableInputField("txtEndtYy");
			disableInputField("txtEndtSeqNo");
			disableToolbarButton("btnToolbarExecuteQuery");
			disableSearch("hrefPolicyNo");
			disableSearch("hrefLineCd");
			disableSearch("hrefSublineCd");
			disableSearch("hrefIssCd");
			disableSearch("hrefEndtIssCd");
			disableSearch("hrefPayTerm"); //changed to disabeled by: kenneth L. 06.20.2013
		}
	});

	$("hrefPolicyNo").observe("click", function() {
		if ($("txtLineCd").value == "") {
			customShowMessageBox(objCommonMessage.REQUIRED, "I", "txtLineCd");
		}else{
			showPolicyListingForGIUTS022();
		}
	});
	
	$("hrefLineCd").observe("click", function() {
		showLineLOV022(true);
	});

	$("txtLineCd").observe("change", function() {
		if (this.value != "") {
			showLineLOV022(false);
		} else {
			$("txtLineCd").value = "";
			$("txtLineCd").setAttribute("lastValidValue", "");
		}
	});
	
	$("hrefSublineCd").observe("click", function() {
		showSublineLOV022(true);
	});

	$("txtSublineCd").observe("change", function() {
		if (this.value != "") {
			showSublineLOV022(false);
		} else {
			$("txtSublineCd").value = "";
			$("txtSublineCd").setAttribute("lastValidValue", "");
		}
	});
	
	$("hrefIssCd").observe("click", function() {
		showIssLOV022(true, "getIssGIUTS022LOV", $("txtIssCd"), $("txtIssueYy"), "txtIssCd");
	});

	$("txtIssCd").observe("change", function() {
		if (this.value != "") {
			showIssLOV022(false, "getIssGIUTS022LOV", $("txtIssCd"), $("txtIssueYy"), "txtIssCd");
		} else {
			$("txtIssCd").value = "";
			$("txtIssCd").setAttribute("lastValidValue", "");
		}
	});
	
	$("hrefEndtIssCd").observe("click", function() {
		showIssLOV022(true, "getIssGIUTS022LOV", $("txtEndtIssCd"), $("txtEndtYy"), "txtEndtIssCd");
	});

	$("txtEndtIssCd").observe("change", function() {
		if (this.value != "") {
			showIssLOV022(false, "getIssGIUTS022LOV", $("txtEndtIssCd"), $("txtEndtYy"), "txtEndtIssCd");
		} else {
			$("txtEndtIssCd").value = "";
			$("txtEndtIssCd").setAttribute("lastValidValue", "");
		}
	});
	
	/* $("hrefLineCd").observe("click", function() {
		showLineLOV022();
	}); 

	$("hrefSublineCd").observe("click", function() {
		showSublineLOV022();
	});

	$("hrefIssCd").observe("click", function() {
		showIssLOV022("getIssGIUTS022LOV", $("txtIssCd"), $("txtIssueYy"), "txtIssCd");
	});

	$("hrefEndtIssCd").observe("click", function() {
		showIssLOV022("getIssGIUTS022LOV", $("txtEndtIssCd"), $("txtEndtYy"), "txtEndtIssCd");
	});*/

	$("hrefPayTerm").observe("click", function() {
		checkIfCanChange();
	});

	$("btnApply").observe("click", function() {
		newOne();
		//disableButton("btnApply"); //marco - 07.21.2014 - moved to onOk function
		//enableButton("btnSave");
		objNewPaySched.clearFields();
	});

	$("editRemarksText").observe("click", function() {
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"),
		function() {
			limitText($("txtRemarks"), 4000);
		});
	});

	$("txtRemarks").observe("keyup", function() {
		limitText(this, 4000);
	});

	$("btnToolbarEnterQuery").observe("click", function() {
		if (changeTag == 1) {
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
			return false;
		} else {
			fireEvent($("lblReloadForm"), "click");
		}
	});

	$("btnSave").observe("click", saveChanges);
	//$("btnToolbarSave").observe("click", saveChanges);
	disableButton("btnApply");
	disableButton("btnSave");
	disableButton("btnInvUpdate");
	disableButton("btnInvApply");
	hideToolbarButton("btnToolbarPrint");
	disableToolbarButton("btnToolbarEnterQuery");
	disableToolbarButton("btnToolbarExecuteQuery");
	//disableToolbarButton("btnToolbarSave");
	disableSearch("hrefPayTerm");
	$("txtLineCd").focus();
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	}	
	
	function cancelChangeInPaymentMode(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGiuts022.exitPage = exitPage;
						changeTagFunc = saveChanges;
						saveChanges();
					}, function(){
						goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		}
	}
	
	$$("div#policyInfo input[type='text']").each(function (a) {
		$(a).observe("change",function(e){
			
			var checkFields = true;
			$$("div#policyInfo input[type='text']").each(function (o) {
				if (o.value.blank()){
					checkFields = false;
				}
			});
				if (checkFields) {
					checkIfPolicyExists();
					enableToolbarButton("btnToolbarExecuteQuery");
				} else{
					disableToolbarButton("btnToolbarExecuteQuery");
					$("txtAssured").value = "";
					policyRecord = false;
				} 
	});
	});
	
	function checkIfPolicyExists() {
		new Ajax.Request(contextPath + "/GIUTSChangeInPaymentTermController?", {
			parameters : {
				action 		: "showGIUTS022PolicyLOV",
				lineCd 		: $F("txtLineCd"),
				sublineCd 	: $F("txtSublineCd"),
				issCd 		: $F("txtIssCd"),
				issueYy 	: $F("txtIssueYy"),
				polSeqNo 	: $F("txtPolSeqNo"),
				renewNo 	: $F("txtRenewNo"),
				endtIssCd 	: $F("txtEndtIssCd"),
				endtYy 		: $F("txtEndtYy"),
				endtSeqNo 	: $F("txtEndtSeqNo")
			},
			asynchronous : true,
			evalScripts : true,
			onComplete : function(response) {
				if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
					updateNew = JSON.parse(response.responseText);
					if(updateNew.rows.length == 0){
						policyRecord = false;
						$("txtAssured").value = "";
					}else{
						showPolicyListingForGIUTS022();
						policyRecord = true;
					}
				}
			}
		});
	}
	
	//added invoice list table grid to handle issue if there are two or more invoice in a policy kenneth L. 06.14.2013
	try {
		var objInvList = new Object();
		objInvList.objInvListing = [];
		objInvList.InvDetail = objInvList.objInvListing.rows || [];
		var invoiceTG = {
			url : contextPath + "/GIUTSChangeInPaymentTermController?action=showChangeInPaymentTerm",
			options : {
				width : '900px',
				height : '220px',
				hideColumnChildTitle: true,
				onCellFocus : function(elemsent, value, x, y, id) {
					objInvLists = invTableGrid.geniisysRows[y];
					populateInvoiceField(objInvLists);
					selRow = y;
					invInfoListTableGrid.url = contextPath + "/GIUTSChangeInPaymentTermController?action=getInstallmentDetails&refresh=1"
												+ "&issCd=" + objInvLists.issCd + "&premSeqNo=" + objInvLists.premSeqNo 
												+ "&itemGrp=" + objInvLists.itemGrp;
					invInfoListTableGrid.refreshURL(invInfoListTableGrid);
					invInfoListTableGrid.refresh();

					taxAllocationTableGrid.url = contextPath + "/GIUTSChangeInPaymentTermController?action=getTaxAllocation&refresh=1"
												+ "&issCd=" + objInvLists.issCd + "&premSeqNo=" + objInvLists.premSeqNo
												+ "&itemGrp=" + objInvLists.itemGrp;;
					taxAllocationTableGrid.refreshURL(taxAllocationTableGrid);
					taxAllocationTableGrid.refresh(); 
					
					//getInceptExpiry(); -----commented  kenneth L.06.19.2013
					enableSearch("hrefPayTerm");	//added by: Kenneth L.  06.19.2013
					invTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus : function() {
					if (changeTermtag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							invTableGrid.selectRow(selRow);
						});
						return false;
            		}else { 
            		 	populateInvoiceField(null);
						invTableGrid.keys.releaseKeys();
						invInfoListTableGrid.url = contextPath+"/GIUTSChangeInPaymentTermController?action=getInstallmentDetails&refresh=1";
						invInfoListTableGrid._refreshList();
						
						taxAllocationTableGrid.url = contextPath + "/GIUTSChangeInPaymentTermController?action=getTaxAllocation&refresh=1";
						taxAllocationTableGrid._refreshList(); 
						
						objChangePayTerm.populateInstallment(null);
						objTaxAllocation.populateTaxAllocation(null);  
						
						disableSearch("hrefPayTerm");	//added by: Kenneth L.  06.19.2013
            		}
				},
				beforeClick: function(){ //marco - 07.21.2014
					if(changeTermtag == 1){
 						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
 						return false;
 					}
				},
				 beforeSort: function(){
					 if (changeTermtag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					} else {
						invTableGrid.onRemoveRowFocus();
					}
	            },
				onSort : function() {
					populateInvoiceField(null);
					invInfoListTableGrid.keys.releaseKeys();
				},
				prePager: function(){
					if (changeTermtag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
                	} else {
                		invTableGrid.onRemoveRowFocus();
                	}
                },
                checkChanges: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailRequireSaving: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailValidation: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetail: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailSaveFunc: function() {
					return (changeTag == 1 ? true : false);
				},
				masterDetailNoFunc: function(){
					return (changeTag == 1 ? true : false);
				},
				onRefresh : function() {
					invTableGrid.onRemoveRowFocus();
				},
				toolbar : {
					elements : [ MyTableGrid.REFRESH_BTN,MyTableGrid.FILTER_BTN ],
					onFilter : function() {
						invTableGrid.onRemoveRowFocus();
					} 
				}
			},
			columnModel : [ {
				id 			 : 'recordStatus',
				width 		 : '0',
				visible 	 : false,
				editor 		 : 'checkbox'
			}, {
				id 			 : 'divCtrId',
				width 		 : '0',
				visible 	 : false
			}, {
				id 			 : "issCd premSeqNo",
				title		 : "Invoice No.",
				children	 : [
					{
						id : "issCd",
						title: "Issue Code",
						width: 60,
						align: 'left'
					}, {
						id : "premSeqNo",
						title: "Premium Sequence No",
						width: 90,
						align: 'right',
						renderer: function(value) {
								  	return formatNumberDigits(value, 12);
						   		  }
					}
				]
			}, {
				id 			 : 'itemGrp',
				title 		 : 'Item Group',
				width 		 : '80px',
				align	     : 'right',
				titleAlign   : 'right',
				filterOption : true,
				filterOptionType : 'integerNoNegative',
				renderer 	 : function(value) {
								return formatNumberDigits(value, 4);
							   }
			}, {
				id 			 : 'property',
				title 		 : 'Property/ Item',
				width 		 : '200px'
			} , {
				id 			 : 'paytTerms',
				title 		 : 'Payterm',
				width 		 : '100px'
			}, {
				id 			 : 'dueDate',
				title 		 : 'Due Date',
				width 		 : '100px',
				align		 : 'center',
				titleAlign   : 'center',
				filterOption : true,
				filterOptionType : 'formattedDate',
				renderer 	 : function(value) {
							   	return dateFormat(value, 'mm-dd-yyyy');
				   			   }
			} , {
				id 			 : 'premAmt',
				title 		 : 'Premium',
				width 		 : '100px',
				align	     : 'right',
				titleAlign   : 'right',
				filterOption : true,
				filterOptionType: 'number',
				renderer 	 : function(value) {
								return formatCurrency(value);
							   }
			}, {
				id 			 : 'taxAmt',
				title 		 : 'Total Tax',
				width 		 : '100px',
				align	     : 'right',
				titleAlign   : 'right',
				renderer 	 : function(value) {
								return formatCurrency(value);
							   },
				filterOption : true,
				filterOptionType: 'number'
			}, {
				id 			 : 'otherCharges',
				title 		 : 'Other Charges',
				width 		 : '100px',
				align	     : 'right',
				titleAlign   : 'right',
				renderer 	 : function(value) {
								return formatCurrency(value);
							   },
				filterOption : true,
				filterOptionType: 'number'
			} , {
				id 			 : 'notarialFee',
				title 		 : 'Notarial Fee',
				width 		 : '100px',
				align	     : 'right',
				titleAlign   : 'right',
				renderer 	 : function(value) {
								return formatCurrency(value);
							   },
				filterOption : true,
				filterOptionType: 'number'
			}, {
				id 			 : 'totalAmt',
				title 		 : 'Total Amount',
				width 		 : '100px',
				align	     : 'right',
				titleAlign   : 'right',
				renderer 	 : function(value) {
								return formatCurrency(value);
							   },
				filterOption : true,
				filterOptionType: 'number'
			} ],
			rows : objInvList.InvDetail
		};
		invTableGrid = new MyTableGrid(invoiceTG);
		invTableGrid.pager = objInvList.objInvListing;
		invTableGrid.render('invoiceTG');

	} catch (e) {
		showErrorMessage("Invoice List Tablegrid", e);
	}
	
</script>