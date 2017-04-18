<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="ajax" uri="http://ajaxtags.org/tags/ajax"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="claimPaymentMainDiv" name="claimPaymentMainDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label id="printPageId">Claim Payment</label>
		</div>
	</div>
	<div style="height: 1000px;">
		<input type="hidden" id="tranId" name="tranId" value=""> 
		<input type="hidden" id="claimId" name="claimId" value=""> 
		<input type="hidden" id="adviceId" name="adviceId" value="">
		<div id="clmPaymentDiv" class="sectionDiv">
			<div style="margin-top:10px; margin-right:5px; float: left; width: 510px;">
				<table align="center" cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td class="rightAligned" border="0" style="width: 120px; border: none;">Claim No.</td>
						<td class="leftAligned" style="border: none;">
							<div id="clmLineCdDiv" style="width: 47px; float: left;" class="withIconDiv required">
								<input type="text" id="txtNbtClmLineCd" name="txtNbtClmLineCd"  value="" style="width: 22px;" ignoreDelKey="1" class="withIcon allCaps required" maxlength="2" tabindex="101"> 
								<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtNbtClmLineCdIcon" name="txtNbtClmLineCdIcon" alt="Go" />
							</div>
							<div id="clmsSblineCdDiv" style="width: 89px; float: left;" class="withIconDiv">
								<input type="text" id="txtNbtClmSublineCd" maxlength="7" name="txtNbtClmSublineCd" value="" ignoreDelKey="1" style="width: 64px;" class="withIcon allCaps" tabindex="102"> 
								<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtNbtClmSublineCdIcon" name="txtNbtClmSublineCdIcon" alt="Go" />
							</div>
							<div style="width: 47px; float: left;" class="withIconDiv">
								<input type="text" id="txtNbtClmIssCd" name="txtNbtClmIssCd" value="" style="width: 22px;" class="withIcon allCaps" ignoreDelKey="1" maxlength="2" tabindex="103"> 
								<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtNbtClmIssCdIcon" name="txtNbtClmIssCdIcon" alt="Go" />
							</div> 
							<input type="text" id="txtNbtClmYy" name="txtNbtClmYy" value="" style="width: 20px; float: left;" maxlength="2" class="integerNoNegativeUnformattedNoComma integerUnformatted" tabindex="104" lpad="2">
							<span>
								<input type="text" id="txtNbtClmSeqNo" name="txtNbtClmSeqNo" value="" style="width: 115px; float: left; margin-left: 4px;" class="integerNoNegativeUnformattedNoComma integerUnformatted" tabindex="105" maxlength="7" lpad="7">
							</span>
							<img style="margin-left: 3px; float: right; border: none;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="nbtSearchClmByClmIcon" name="nbtSearchClmByClmIcon" alt="Go" />
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 120px;">Policy No.</td>
						<td class="leftAligned" style="border: none;">
							<div id="lineCdDiv" style="width: 47px; float: left;" class="withIconDiv required">
								<!-- renamed txtNbtLineCd to txtNbtLineCode due to existing name by gab 04.20.2016 SR 21694 -->
								<input type="text" id="txtNbtLineCode" name="txtNbtLineCode" value="" ignoreDelKey="1" style="width: 22px;" class="withIcon allCaps required" maxlength="2" tabindex="201"> 
								<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtNbtLineCdIcon" name="txtNbtLineCdIcon" alt="Go" />
							</div>
							<div id="sublineCdDiv" style="width: 89px;float: left;" class="withIconDiv">
								<input type="text" id="txtNbtSublineCd" name="txtNbtSublineCd" value="" ignoreDelKey="1" style="width: 64px;" class="withIcon allCaps" tabindex="202"> 
								<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtNbtSublineCdIcon" name="txtNbtSublineCdIcon" alt="Go" />
							</div>
							<div style="width: 47px; float: left;" class="withIconDiv">
								<input type="text" id="txtNbtPolIssCd" name="txtNbtPolIssCd" value="" ignoreDelKey="1" style="width: 22px;" class="withIcon allCaps" maxlength="2" tabindex="203"> 
								<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtNbtPolIssCdIcon" name="txtNbtPolIssCdIcon" alt="Go" />
							</div> 
							<input type="text" id="txtNbtIssueYy" name="txtNbtIssueYy" value="" style="width: 20px; float: left;" class="integerNoNegativeUnformattedNoComma integerUnformatted" maxlength="2" tabindex="204" lpad="2"> 
							<input type="text" id="txtNbtPolSeqNo" name="txtNbtPolSeqNo" value="" style="width: 71px; float: left; margin-left: 4px;" class="integerNoNegativeUnformattedNoComma integerUnformatted" tabindex="205" maxlength="7" lpad="7">
							<span>
								<input type="text" id="txtNbtRenewNo" name="txtNbtRenewNo" value="" style="width: 33px; float: left; margin-left: 4px;" class="integerNoNegativeUnformattedNoComma integerUnformatted" maxlength="2" tabindex="206" lpad="2">
							</span>
							<img style="margin-left: 3px; float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="nbtSearchPolicyIcon" name="nbtSearchPolicyIcon" alt="Go" />
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 120px;">Assured</td>
						<td class="leftAligned">
						<input style="float: left; width: 370px;" type="text" id="txtNbtAssuredName" name="txtNbtAssuredName" readonly="readonly" tabindex="307"></td>
					</tr>
				</table>
			</div>
			<div style="margin: 10px; margin-right: 50px; margin-left:5px; float: right; width: 330px;">
				<table border="0" align="center" cellpadding="0" cellspacing="0">
					<tr>
						<td class="rightAligned" style="width: 120px;">Loss Category</td>
						<td class="leftAligned" style="width: 230px;"><input
							id="txtLossCategory" style="width: 230px;" type="text" value=""
							readonly="readonly" /></td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 120px;">Loss Date</td>
						<td class="leftAligned" style="width: 230px;"><input
							id="txtLossDate" style="width: 230px;" type="text" value=""
							readonly="readonly" /></td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 120px;">Claim Status</td>
						<td class="leftAligned" style="width: 230px;"><input
							id="txtClmStatus" style="width: 230px;" type="text" value=""
							readonly="readonly" /></td>
					</tr>
				</table>
			</div>
		</div>
		<!-- section for table grid -->
		<div>
			<div class="sectionDiv" style="height: 220px;">
				<div id="claimPaymentTableGrid" style="padding: 5px; height: 210px;">
					<div id="claimPaymentTableGridDiv" style="height: 100%;"></div>
				</div>
			</div>
		</div>
		<!-- end section for table grid -->
		<!-- section for table grid -->
		<div>
			<div class="sectionDiv" style="height: 300px;">
				<div id="claimPaymentAdvTableGrid" style="padding: 5px; height: 280px;">
					<div id="claimPaymentAdvTableGridDiv" style="height: 100%;"></div>
				</div>
			</div>
		</div>
		<!-- section for details -->
		<div class="sectionDiv" style="height: 140px; padding-top: 10px;">
			<table align="center">
				<tr>
					<td>DV Date :</td>
					<td><input type="text" id="refDate" name="dvDate"
						style="float: left; width: 200px;" readonly="readonly" /></td>
					<td width="30"></td>
					<td align="right">Check Date :</td>
					<td><input type="text" id="chckDate" name="chckDate"
						style="float: right; width: 200px;" readonly="readonly" /></td>
				</tr>
				<tr>
					<td>Particulars</td>
					<td colspan="4"><textarea id="particulars" name="particulars"
							rows="5" cols="80" readonly="readonly"
							style="resize: none; width: 600px;"></textarea></td>
				</tr>
			</table>
		</div>
		<div style="float: left; width: 100%; margin-top: 15px;"
			align="center">
			<input id="btnCheckReleaseInfo" class="button" type="button"
				value="Check Release Info" name="btnCheckReleaseInfo" />
		</div>
		<!-- end section for details -->
	</div>
</div>
<script type="text/javascript">
	setModuleId("GICLS261");
	setDocumentTitle("Claim Payment");
	hideToolbarButton("btnToolbarPrint");
	initializeAll();
	initializeAccordion();
	$("txtNbtClmLineCd").focus();
	var selectedRecord = {};
	var executeQuery = false;
	objCheckInfo = new Object();
	disableButton("btnCheckReleaseInfo");
	showClaimPaymentTable();
	
	function showClaimPaymentTable(){
		claimPaymentTableModel = {
				url : contextPath + "/GICLClaimPaymentController?action=showClaimPayment&claimId=&refresh=1",
				options: {
					hideColumnChildTitle: true,
					toolbar: {
						elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
						onFilter : function(){
							tbgClaimPayment.keys.removeFocus(tbgClaimPayment.keys._nCurrentFocus, true);
							tbgClaimPayment.keys.releaseKeys();
							tbgClaimPaymentAdv.url = contextPath + "/GICLClaimPaymentController?action=getClmAdvice&claimId=&adviceId=&clmLossId=&refresh=1";
							tbgClaimPaymentAdv._refreshList();
						}
					},
					width: '900px',
					pager: {
					},
					onCellFocus : function(element, value, x, y, id) {
						selectedRecord = tbgClaimPayment.geniisysRows[y];
						tbgClaimPaymentAdv.url = contextPath + "/GICLClaimPaymentController?action=getClmAdvice&claimId=" + selectedRecord.claimId + "&adviceId=" + selectedRecord.adviceId + "&clmLossId=" + selectedRecord.clmLossId + "&refresh=1";
						tbgClaimPaymentAdv._refreshList();
						tbgClaimPayment.keys.removeFocus(tbgClaimPayment.keys._nCurrentFocus, true);
						tbgClaimPayment.keys.releaseKeys();
					},
					prePager: function(){
						tbgClaimPayment.keys.removeFocus(tbgClaimPayment.keys._nCurrentFocus, true);
						tbgClaimPayment.keys.releaseKeys();
						tbgClaimPaymentAdv.url = contextPath + "/GICLClaimPaymentController?action=getClmAdvice&claimId=&adviceId=&clmLossId=&refresh=1";
						tbgClaimPaymentAdv._refreshList();
					}, 
					onRemoveRowFocus : function(element, value, x, y, id){	
						tbgClaimPaymentAdv.url = contextPath + "/GICLClaimPaymentController?action=getClmAdvice&claimId=&adviceId=&clmLossId=&refresh=1";
						tbgClaimPaymentAdv._refreshList();
						tbgClaimPayment.keys.removeFocus(tbgClaimPayment.keys._nCurrentFocus, true);
						tbgClaimPayment.keys.releaseKeys();
					},
					onSort : function(){
						tbgClaimPayment.keys.removeFocus(tbgClaimPayment.keys._nCurrentFocus, true);
						tbgClaimPayment.keys.releaseKeys();
					}, 
					beforeSort : function(){
						tbgClaimPaymentAdv.url = contextPath + "/GICLClaimPaymentController?action=getClmAdvice&claimId=&adviceId=&clmLossId=&refresh=1";
						tbgClaimPaymentAdv._refreshList();
					}, 
					onRefresh : function(){
						tbgClaimPayment.keys.removeFocus(tbgClaimPayment.keys._nCurrentFocus, true);
						tbgClaimPayment.keys.releaseKeys();
						tbgClaimPaymentAdv.url = contextPath + "/GICLClaimPaymentController?action=getClmAdvice&claimId=&adviceId=&clmLossId=&refresh=1";
						tbgClaimPaymentAdv._refreshList();
					}
				},									
				columnModel: [
					{
					    id: 'recordStatus',
					    title: '',
					    width: '0',	
					    visible: false
					},
					{
						id: 'divCtrId',
						width: '0',
						visible: false 
					},
					{
						id : 'itemNo',
						title : 'Item No',
						filterOption : true,
						width : '0',
						filterOptionType : 'integerNoNegative',
						visible: false 
					}, {
						id : 'itemTitle',
						title : 'Item Title',
						width : '0',
						filterOption : true,
						visible: false 
					},
					{
						id : 'item',
						title : 'Item',
						width : '130px',
						align : 'left',
						titleAlign : 'left',
						filterOption : false,
					},
					{
						id : 'perilCd',
						title : 'Peril Code',
						width : '0',
						filterOptionType : 'integerNoNegative',
						filterOption : true,
						visible: false
					}, 
					{
						id : 'perilSName',
						title : 'Peril Name',
						width : '0',
						filterOption : true,
						visible: false
					},
					{
						id : 'peril',
						title : 'Peril',
						width : '130px',
						align : 'left',
						titleAlign : 'left',
						filterOption : false,
					},
					{
						id : 'payeeType',
						title : 'Payee Type',
						filterOption : true,
						width : '0',
						visible : false
					}, {
						id : 'payeeClassCd',
						title : 'Payee Class Code',
						filterOption : true,
						width : '0',
						filterOptionType : 'integerNoNegative',
						visible : false
					}, {
						id : 'payeeCd',
						title : 'Payee Code',
						filterOption : true,
						width : '0',
						filterOptionType : 'integerNoNegative',
						visible : false
					}, {
						id : 'payeeName',
						title : 'Payee Name',
						filterOption : true,
						width : '0',
						visible : false
					},
					{
						id : 'payee',
						title : 'Payee',
						width : '300px',
						align : 'left',
						titleAlign : 'left',
						filterOption : false,
					},
					{
						id : "netAmt",
						title : "Loss Amount",
						width : '150px',
						align : 'right',
						titleAlign : 'right',
						filterOption : true,
						filterOptionType : 'numberNoNegative',
						geniisysClass : 'money'
					},
					{
						id : "paidAmt",
						title : "Disbursement Amount",
						width : '150px',
						align : 'right',
						titleAlign : 'right',
						filterOption : true,
						filterOptionType : 'numberNoNegative',
						geniisysClass : 'money'
					}
				],
				rows: [] 
			};
		
		tbgClaimPayment = new MyTableGrid(claimPaymentTableModel);
		tbgClaimPayment.render('claimPaymentTableGridDiv');
	}

	var claimPaymentAdvTableModel = {
		id : 20,
		url : contextPath
				+ "/GICLClaimPaymentController?action=getClmAdvice&claimId=&adviceId=&clmLossId=&refresh=1",
		options : {
			toolbar : {
				elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
				onFilter : function() {
					tbgClaimPaymentAdv.keys.removeFocus(
							tbgClaimPaymentAdv.keys._nCurrentFocus, true);
					disableButton("btnCheckReleaseInfo");
					tbgClaimPaymentAdv.keys.releaseKeys();
				}
			},
			width : '910px',
			pager : {},
			onCellFocus : function(element, value, x, y, id) {
				tbgClaimPaymentAdv.selectedClaimPaymentAdv = tbgClaimPaymentAdv.geniisysRows[y];
				setDetailsForm(tbgClaimPaymentAdv.selectedClaimPaymentAdv);
				tbgClaimPaymentAdv.keys.removeFocus(
						tbgClaimPaymentAdv.keys._nCurrentFocus, true);
				tbgClaimPaymentAdv.keys.releaseKeys();
				setCheckInfo(tbgClaimPaymentAdv.geniisysRows[y]);
				enableButton("btnCheckReleaseInfo");
				tbgClaimPaymentAdv.keys.releaseKeys();
			},
			onRemoveRowFocus : function(element, value, x, y, id) {
				setDetailsForm(null);
				setCheckInfo(null);
				disableButton("btnCheckReleaseInfo");
			},
			onSort : function() {
				setDetailsForm(null);
				tbgClaimPaymentAdv.keys.removeFocus(
						tbgClaimPaymentAdv.keys._nCurrentFocus, true);
				tbgClaimPaymentAdv.keys.releaseKeys();
				disableButton("btnCheckReleaseInfo");
				setCheckInfo(null);
			},
			onRefresh : function() {
				setDetailsForm(null);
				tbgClaimPaymentAdv.keys.removeFocus(
						tbgClaimPaymentAdv.keys._nCurrentFocus, true);
				tbgClaimPaymentAdv.keys.releaseKeys();
				disableButton("btnCheckReleaseInfo");
				setCheckInfo(null);
			}
		},
		columnModel : [ {
			id : 'recordStatus',
			title : '',
			width : '0',
			visible : false
		}, {
			id : 'divCtrId',
			width : '0',
			visible : false
		}, {
			id : 'tranId',
			title : '',
			width : '0',
			visible : false
		}, {
			id : 'adviceNo',
			title : 'Advice No.',
			align : 'left',
			titleAlign : 'left',
			filterOption : true,
			width : '176px'
		}, {
			id : 'datePaid',
			title : 'Date Paid',
			filterOption : true,
			filterOptionType : 'formattedDate',
			align : 'center',
			titleAlign : 'center',
			width : '130px'
		}, {
			id : 'refNo',
			title : 'Ref No.',
			filterOption : true,
			align : 'left',
			titleAlign : 'left',
			width : '195px'
		}, {
			id : 'refCheckNo',
			title : 'Check No.',
			align : 'left',
			titleAlign : 'left',
			filterOption : true,
			width : '170px'
		}, {
			id : 'csrNo',
			title : 'CSR No.',
			align : 'left',
			titleAlign : 'left',
			filterOption : true,
			width : '195'
		}, {
			id : 'batchNo',
			title : '',
			width : '0',
			visible : false
		}, {
			id : 'particulars',
			title : '',
			width : '0',
			visible : false
		}, {
			id : 'refDate',
			title : '',
			width : '0',
			visible : false
		}, {
			id : 'chckDate',
			title : '',
			width : '0',
			visible : false
		}, {
			id : 'checkPrefSuf',
			title : '',
			width : '0',
			visible : false
		}, {
			id : 'checkNo',
			title : '',
			width : '0',
			visible : false
		}, {
			id : 'checkReleaseDate',
			title : '',
			width : '0',
			visible : false
		}, {
			id : 'checkReleasedBy',
			title : '',
			width : '0',
			visible : false
		}, {
			id : 'userId',
			title : '',
			width : '0',
			visible : false
		}, {
			id : 'checkReceivedBy',
			title : '',
			width : '0',
			visible : false
		}, {
			id : 'orNo',
			title : '',
			width : '0',
			visible : false
		}, {
			id : 'orDate',
			title : '',
			width : '0',
			visible : false
		}, {
			id : 'lastUpdate',
			title : '',
			width : '0',
			visible : false
		} ],
		onUndefinedRow : function() {
			$("refDate").clear();
			$("chckDate").clear();
			$("particulars").clear();
			$("batchNo").clear();
			disableButton("btnCheckReleaseInfo");
			ShowMessageBox("No record selected", "I");
		},
		rows : []
	};

	tbgClaimPaymentAdv = new MyTableGrid(claimPaymentAdvTableModel);
	tbgClaimPaymentAdv.render("claimPaymentAdvTableGridDiv");

	function showClaimPayment() {
		tbgClaimPayment.url = contextPath
				+ "/GICLClaimPaymentController?action=showClaimPayment&refresh=1&claimId="
				+ $("claimId").value;
		tbgClaimPayment._refreshList();
	}
	function setDetailsForm(rec) {
		try {
			$("refDate").value = rec == null ? "" : rec.refDate;
			$("chckDate").value = rec == null ? ""
					: unescapeHTML2(rec.chckDate);
			$("particulars").value = rec == null ? ""
					: unescapeHTML2(rec.particulars);
		} catch (e) {
			showErrorMessage("setDetailsForm", e);
		}
	}
	function setCheckInfo(rec) {
		try {
			objCheckInfo.checkPrefSuf = rec == null ? "" : rec.checkPrefSuf;
			objCheckInfo.checkNo = rec == null ? "" : rec.checkNo;
			objCheckInfo.checkReleaseDate = rec == null ? ""
					: rec.checkReleaseDate;
			objCheckInfo.checkReleasedBy = rec == null ? ""
					: rec.checkReleasedBy;
			objCheckInfo.userId = rec == null ? "" : rec.userId;
			objCheckInfo.checkReceivedBy = rec == null ? ""
					: rec.checkReceivedBy;
			objCheckInfo.orNo = rec == null ? "" : rec.orNo;
			objCheckInfo.orDate = rec == null ? "" : rec.orDate;
			objCheckInfo.lastUpdate = rec == null ? "" : rec.lastUpdate;
			objCheckInfo.tranId = rec == null ? "" : rec.tranId;
		} catch (e) {
			showErrorMessage("setCheckInfo", e);
		}
	}

	function resetFields() {
		$$("input[type='text']").each(function(x) {
			x.clear();
		});
		$$("textarea").each(function(x) {
			x.clear();
		});
		objCLMGlobal.claimId = "";
		$("claimId").value = "";
		disableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
		disableButton("btnCheckReleaseInfo");
		$("txtNbtClmLineCd").focus();
		tbgClaimPayment.url = contextPath
				+ "/GICLClaimPaymentController?action=showClaimPayment&refresh=1&claimId=";
		tbgClaimPayment._refreshList(); 
	}

	function resetForm() {
		resetFields();
		$("txtNbtClmLineCd").readOnly = false;
		$("txtNbtClmSublineCd").readOnly = false;
		$("txtNbtClmIssCd").readOnly = false;
		$("txtNbtClmYy").readOnly = false;
		$("txtNbtClmSeqNo").readOnly = false;
		$("txtNbtLineCode").readOnly = false;
		$("txtNbtSublineCd").readOnly = false;
		$("txtNbtPolIssCd").readOnly = false;
		$("txtNbtIssueYy").readOnly = false;
		$("txtNbtPolSeqNo").readOnly = false;
		$("txtNbtRenewNo").readOnly = false;
		enableSearch("txtNbtClmLineCdIcon");
		enableSearch("txtNbtClmSublineCdIcon");
		enableSearch("txtNbtClmIssCdIcon");
		enableSearch("nbtSearchClmByClmIcon");
		enableSearch("txtNbtLineCdIcon");
		enableSearch("txtNbtSublineCdIcon");
		enableSearch("txtNbtPolIssCdIcon");
		enableSearch("nbtSearchPolicyIcon");
	}

	function checkClmRequiredFields() {
		enableToolbarButton("btnToolbarEnterQuery");
		if (!trim($("txtNbtClmLineCd").value)) {
			showWaitingMessageBox(objCommonMessage.REQUIRED, imgMessage.INFO,
					function() {
						$("txtNbtClmLineCd").focus();
						$("txtNbtClmSublineCd").value = "";
						$("txtNbtClmIssCd").value = "";
						$("txtNbtClmYy").value = "";
						$("txtNbtClmSeqNo").value = "";
					});
			return false;
		}
		return true;
	}

	function checkPolRequiredFields() {
		enableToolbarButton("btnToolbarEnterQuery");
		if (!trim($("txtNbtLineCode").value)) {
			showWaitingMessageBox(objCommonMessage.REQUIRED, imgMessage.INFO,
					function() {
						$("txtNbtLineCode").focus();
						$("txtNbtSublineCd").value = "";
						$("txtNbtPolIssCd").value = "";
						$("txtNbtIssueYy").value = "";
						$("txtNbtPolSeqNo").value = "";
						$("txtNbtRenewNo").value = "";
					});
			return false;
		}
		return true;
	}

	//contains observe, initial setups
	function setClaimPayment() {
		try {
			$("btnToolbarExit").observe( "click", function() {
				if(objCLMGlobal.callingForm == "GICLS260"){
					$("claimPaymentMainDiv").hide();
					$("claimInfoListingMainDiv").show();
					objCLMGlobal.claimId = "";
				}else if(objCLMGlobal.callingForm == "GIPIS100"){ //considered GIPIS100 by robert SR 21694 03.28.16
					showGIPIS100ClaimInfoListing(objCLMGlobal.claimId);
				} else {
					document.stopObserving("keyup");
					goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
				}
			});

			//start input on claim initiation
			//claim line code
			$("txtNbtClmLineCdIcon").observe("click", function() {
				showClaimLineCdLOV("GICLS261", "");
			});

			$("txtNbtClmLineCd").observe("change", function() {
				//validation here
			});

			$("txtNbtClmSublineCd").observe("change", function(event) {
				checkClmRequiredFields();
			});

			$("txtNbtClmSublineCdIcon").observe(
					"click",
					function() {
						if (trim($("txtNbtClmLineCd").value) == "") {
							$("txtNbtClmSublineCd").clear();
							customShowMessageBox(objCommonMessage.REQUIRED,
									imgMessage.INFO, "txtNbtClmLineCd");
							return false;
						}
						showClaimSublineCdLOV("GICLS261",
								$("txtNbtClmLineCd").value,
								$("txtNbtClmSublineCd").value);
					});

			$("txtNbtClmIssCd").observe("change", function(event) {
				checkClmRequiredFields();
			});

			$("txtNbtClmIssCdIcon").observe(
					"click",
					function() {
						if (trim($("txtNbtClmLineCd").value) == "") {
							$("txtNbtClmIssCd").clear();
							customShowMessageBox(objCommonMessage.REQUIRED,
									imgMessage.INFO, "txtNbtClmLineCd");
							return false;
						}
						showClaimIssCdLOV("GICLS255", $F("txtNbtClmIssCd"),
								$("txtNbtClmLineCd").value);
					});

			$("txtNbtClmYy").observe(
					"change",
					function(event) {
						if (trim($("txtNbtClmLineCd").value) == "") {
							$("txtNbtClmYy").clear();
							customShowMessageBox(objCommonMessage.REQUIRED,
									imgMessage.INFO, "txtNbtClmLineCd");
							return false;
						}
					});
			$("txtNbtClmSeqNo").observe(
					"change",
					function(event) {
						if (trim($("txtNbtClmLineCd").value) == "") {
							$("txtNbtClmSeqNo").clear();
							customShowMessageBox(objCommonMessage.REQUIRED,
									imgMessage.INFO, "txtNbtClmLineCd");
							return false;
						}
					});
			$("nbtSearchClmByClmIcon").observe("click", function() {
				if (checkClmRequiredFields()) {
					showClmPolLOV("GICLS255");
				}
			});
			//start input on policy initiation
			$("txtNbtLineCode").observe("change", function(event) {
				//validation here
			});
			$("txtNbtLineCdIcon").observe("click", function() {
				try {
					showPolicyLineCdLOV("GICLS261", "");
				} catch (e) {
					showErrorMessage("claimPayment", e);
				}
			});
			$("txtNbtSublineCd").observe("change", function(event) {
				checkPolRequiredFields();
			});
			$("txtNbtSublineCdIcon").observe(
					"click",
					function() {
						if (trim($("txtNbtLineCode").value) == "") {
							$("txtNbtSublineCd").clear();
							customShowMessageBox(objCommonMessage.REQUIRED,
									imgMessage.INFO, "txtNbtLineCode");
							return false;
						}
						showPolicySublineCdLOV($("txtNbtLineCode").value, "",
								"GICLS261");
					});
			$("txtNbtPolIssCd").observe("change", function(event) {
				checkPolRequiredFields();
			});
			$("txtNbtPolIssCdIcon").observe(
					"click",
					function() {
						if (trim($("txtNbtLineCode").value) == "") {
							$("txtNbtPolIssCd").clear();
							customShowMessageBox(objCommonMessage.REQUIRED,
									imgMessage.INFO, "txtNbtLineCode");
							return false;
						}
						showClmIssCdLOV2("GICLS261", $F("txtNbtLineCode"),
								$F("txtNbtSublineCd"));
					});
			$("txtNbtIssueYy").observe(
					"change",
					function(event) {
						if (trim($("txtNbtLineCode").value) == "") {
							$("txtNbtIssueYy").clear();
							customShowMessageBox(objCommonMessage.REQUIRED,
									imgMessage.INFO, "txtNbtLineCode");
							return false;
						}
					});
			$("txtNbtPolSeqNo").observe(
					"change",
					function(event) {
						if (trim($("txtNbtLineCode").value) == "") {
							$("txtNbtPolSeqNo").clear();
							customShowMessageBox(objCommonMessage.REQUIRED,
									imgMessage.INFO, "txtNbtLineCode");
							return false;
						}
					});
			$("txtNbtRenewNo").observe(
					"change",
					function(event) {
						if (trim($("txtNbtLineCode").value) == "") {
							$("txtNbtRenewNo").clear();
							customShowMessageBox(objCommonMessage.REQUIRED,
									imgMessage.INFO, "txtNbtLineCode");
							return false;
						}
					});
			$("nbtSearchPolicyIcon").observe(
					"click",
					function() {
						if (checkPolRequiredFields()) {
							showPolicyLOV("GICLS261", $("txtNbtLineCode").value,
									$("txtNbtSublineCd").value,
									$("txtNbtPolIssCd").value,
									$("txtNbtIssueYy").value,
									$("txtNbtPolSeqNo").value,
									$("txtNbtRenewNo").value);
						}
					});
			$("btnToolbarEnterQuery").observe("click", resetForm);
			$("btnToolbarExecuteQuery").observe("click", function() {
				disableToolbarButton("btnToolbarExecuteQuery");
				enableToolbarButton("btnToolbarEnterQuery");
				disableFields();
				showClaimPayment();
			});

			$("btnCheckReleaseInfo").observe("click", function() {
				showCheckReleaseInfo();
			});
		} catch (e) {
			showErrorMessage("claimPayment", e);
		}
	}

	function checkWhenUserTypes(event) {
		if (event.keyCode == 0 || event.keyCode == 8) {
			$("txtNbtAssuredName").clear();
			enableToolbarButton('btnToolbarEnterQuery');
			disableToolbarButton("btnToolbarExecuteQuery");
		}
	}

	function initializeGICLS261() {
		disableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
		setClaimPayment();
		
		if(objCLMGlobal.callingForm == "GICLS260" || objCLMGlobal.callingForm == "GIPIS100"){ //considered GIPIS100 by robert SR 21694 03.21.16
			$("claimId").value = objCLMGlobal.claimId;
			showClmPolLOV("GICLS261");
		} 
	}
	function disableFields() {
		disableSearch("txtNbtClmLineCdIcon");
		disableSearch("txtNbtClmSublineCdIcon");
		disableSearch("txtNbtClmIssCdIcon");
		disableSearch("nbtSearchClmByClmIcon");
		disableSearch("txtNbtLineCdIcon");
		disableSearch("txtNbtSublineCdIcon");
		disableSearch("txtNbtPolIssCdIcon");
		disableSearch("nbtSearchPolicyIcon");
		$("txtNbtClmLineCd").readOnly = true;
		$("txtNbtClmSublineCd").readOnly = true;
		$("txtNbtClmIssCd").readOnly = true;
		$("txtNbtClmYy").readOnly = true;
		$("txtNbtClmSeqNo").readOnly = true;
		$("txtNbtLineCode").readOnly = true;
		$("txtNbtSublineCd").readOnly = true;
		$("txtNbtPolIssCd").readOnly = true;
		$("txtNbtIssueYy").readOnly = true;
		$("txtNbtPolSeqNo").readOnly = true;
		$("txtNbtRenewNo").readOnly = true;
	}

	function showCheckReleaseInfo() {
		try {
			overlayCheckReleaseInfo = Overlay.show(contextPath
					+ "/GICLClaimPaymentController", {
				urlContent : true,
				urlParameters : {
					action : "getCheckInfo",
					tranId : objCheckInfo.tranId,
					checkPrefSuf : objCheckInfo.checkPrefSuf,
					checkNo : objCheckInfo.checkNo,
					checkReleaseDate : objCheckInfo.checkReleaseDate,
					checkReleasedBy : objCheckInfo.checkReleasedBy,
					userId : objCheckInfo.userId,
					checkReceivedBy : objCheckInfo.checkReceivedBy,
					orNo : objCheckInfo.orNo,
					orDate : objCheckInfo.orDate,
					lastUpdate : objCheckInfo.lastUpdate || getCurrentDate()
				},
				title : "Check Release Info",
				height : 170,
				width : 820,
				draggable : true
			});
		} catch (e) {
			showErrorMessage("overlay error: ", e);
		}
	}

	//validate claim and policy search
	/* function validateEntries() {
		new Ajax.Request(contextPath + "/GICLClaimPaymentController", {
			method : "POST",
			parameters : {
				action : "validateEntries",
				moduleId : moduleId,
				clmLineCd : $F("txtNbtClmLineCd"),
				clmSublineCd : $F("txtNbtClmSublineCd"),
				lineCd : $F("txtNbtLineCode"),
				sublineCd : $F("txtNbtSublineCd"),
				issCd : $F("txtNbtClmIssCd"),
				polIssCd : $F("txtNbtPolIssCd"),
				clmYy : $F("txtNbtClmYy"),
				issueYy : $F("txtNbtIssueYy"),
				clmSeqNo : $F("txtNbtClmSeqNo"),
				polSeqNo : $F("txtNbtPolSeqNo"),
				renewNo : $F("txtNbtRenewNo")
			},
			asynchronous : false,
			evalScripts : true,
			onComplete : function(response) {
				if (response.responseText == 0) {
					//customShowMessageBox("There is no such record.", imgMessage.INFO, "txtNbtClmLineCd");
					resetFields();
				} else if (response.responseText == 1 && (($("claimId").value != "" && $("claimId").value != null) && (objCLMGlobal.claimId != "" && objCLMGlobal.claimId != null))) {
					showClmPolLOV("GICLS261");
				}
			}
		});
	} */

	function toggleSearchFields(sw) {
		$("txtNbtClmLineCd").readOnly = !sw;
		$("txtNbtClmSublineCd").readOnly = !sw;
		$("txtNbtClmIssCd").readOnly = !sw;
		$("txtNbtClmYy").readOnly = !sw;
		$("txtNbtClmSeqNo").readOnly = !sw;
		$("txtNbtLineCode").readOnly = !sw;
		$("txtNbtSublineCd").readOnly = !sw;
		$("txtNbtPolIssCd").readOnly = !sw;
		$("txtNbtIssueYy").readOnly = !sw;
		$("txtNbtPolSeqNo").readOnly = !sw;
		$("txtNbtRenewNo").readOnly = !sw;
		if (sw) {
			enableSearch("txtNbtClmLineCdIcon");
			enableSearch("txtNbtClmSublineCdIcon");
			enableSearch("txtNbtClmIssCdIcon");
			enableSearch("txtNbtLineCdIcon");
			enableSearch("txtNbtSublineCdIcon");
			enableSearch("txtNbtPolIssCdIcon");
			enableSearch("nbtSearchClmByClmIcon");
			enableSearch("nbtSearchPolicyIcon");
		} else {
			disableSearch("txtNbtClmLineCdIcon");
			disableSearch("txtNbtClmSublineCdIcon");
			disableSearch("txtNbtClmIssCdIcon");
			disableSearch("txtNbtLineCdIcon");
			disableSearch("txtNbtSublineCdIcon");
			disableSearch("txtNbtPolIssCdIcon");
			disableSearch("nbtSearchClmByClmIcon");
			disableSearch("nbtSearchPolicyIcon");
		}
	}

	function showClmPolLOV(moduleId) {
		try {
			LOV
					.show({
						controller : "ClaimsLOVController",
						urlParameters : {
							action : "getClmPolLOV",
							moduleId : moduleId,
							clmLineCd : $F("txtNbtClmLineCd"),
							clmSublineCd : $F("txtNbtClmSublineCd"),
							lineCd : $F("txtNbtLineCode"),
							sublineCd : $F("txtNbtSublineCd"),
							issCd : $F("txtNbtClmIssCd"),
							polIssCd : $F("txtNbtPolIssCd"),
							clmYy : $F("txtNbtClmYy"),
							issueYy : $F("txtNbtIssueYy"),
							clmSeqNo : $F("txtNbtClmSeqNo"),
							polSeqNo : $F("txtNbtPolSeqNo"),
							renewNo : $F("txtNbtRenewNo"),
							claimId : $F("claimId")
						},
						title : "Claim Listing",
						width : 535,
						height : 390,
						hideColumnChildTitle : true,
						//filterVersion : "2",
						columnModel : [ {
							id : 'recordStatus',
							title : '',
							width : '0',
							visible : false,
							editor : 'checkbox'
						}, {
							id : 'divCtrId',
							width : '0',
							visible : false
						}, {
							id : 'claimId',
							width : '0',
							visible : false
						}, {
							id : 'claimStatus',
							width : '0',
							visible : false
						}, {
							id : 'claimNo',
							title : 'Claim No.',
							titleAlign : 'center',
							width : 205,
							children : [ {
								id : 'clmLineCd',
								title : 'Claim Line Code',
								width : 30,
								filterOption : true,
								editable : false
							}, {
								id : 'clmSublineCd',
								title : 'Claim Subline Code',
								width : 50,
								filterOption : true,
								editable : false
							}, {
								id : 'issCd',
								title : 'Claim Issue Code',
								width : 30,
								filterOption : true,
								editable : false
							}, {
								id : 'clmYy',
								title : 'Claim Year',
								type : 'number',
								align : 'right',
								width : 30,
								filterOption : true,
								renderer : function(value) {
									return formatNumberDigits(value, 2);
								},
								editable : false
							}, {
								id : 'clmSeqNo',
								title : 'Claim Sequence No.',
								type : 'number',
								align : 'right',
								width : 60,
								filterOption : true,
								renderer : function(value) {
									return formatNumberDigits(value, 7);
								},
								editable : false
							} ]
						}, {
							id : 'assuredName',
							title : 'Assured Name',
							titleAlign : 'left',
							width : '300px',
							filterOption : true,
							editable : false
						}, {
							id : 'lossCategory',
							title : 'Loss Category',
							titleAlign : 'left',
							width : '0px',
							editable : false,
							visible : false
						}, {
							id : 'lossDate',
							title : 'Loss Date',
							titleAlign : 'left',
							width : '0px',
							editable : false,
							visible : false
						} ],
						draggable : true,
						autoSelectOneRecord : true,
						onSelect : function(row) {
							if (row != undefined) {
								//assigning of values
								$("txtNbtClmLineCd").value = row.clmLineCd;
								$("txtNbtClmSublineCd").value = row.clmSublineCd;
								$("txtNbtClmIssCd").value = row.issCd;
								$("txtNbtClmYy").value = formatNumberDigits(
										row.clmYy, 2);
								$("txtNbtClmSeqNo").value = formatNumberDigits(
										row.clmSeqNo, 7);
								$("txtNbtLineCode").value = row.lineCd;
								$("txtNbtSublineCd").value = row.sublineCd;
								$("txtNbtPolIssCd").value = row.polIssCd;
								$("txtNbtIssueYy").value = formatNumberDigits(
										row.issueYy, 2);
								$("txtNbtPolSeqNo").value = formatNumberDigits(
										row.polSeqNo, 7);
								$("txtNbtRenewNo").value = formatNumberDigits(
										row.renewNo, 2);
								$("txtNbtAssuredName").value = unescapeHTML2(row.assuredName);
								$("txtLossCategory").value = unescapeHTML2(row.lossCategory);
								$("txtLossDate").value = unescapeHTML2(row.lossDate);
								$("txtClmStatus").value = row.claimStatus;
								$("claimId").value = row.claimId;
								objCLMGlobal.claimId = row.claimId;
								enableToolbarButton("btnToolbarEnterQuery");
								enableToolbarButton("btnToolbarExecuteQuery");
								toggleSearchFields(false);
								if(objCLMGlobal.callingForm == "GICLS260" || objCLMGlobal.callingForm == "GIPIS100"){ //considered GIPIS100 by robert SR 21694 03.21.16
									fireEvent($("btnToolbarExecuteQuery"), "click");
									disableToolbarButton("btnToolbarEnterQuery");
									disableToolbarButton("btnToolbarExecuteQuery");
								}
							}
						},
						onCancel : function() {
							$("txtNbtAssuredName").clear();
							$("txtLossCategory").clear();
							$("txtLossDate").clear();
							$("txtClmStatus").clear();
						},
						onUndefinedRow : function() {
							$("txtNbtClmLineCd").clear();
							$("txtNbtClmSublineCd").clear();
							$("txtNbtClmIssCd").clear();
							$("txtNbtClmYy").clear();
							$("txtNbtClmSeqNo").clear();
							$("txtNbtLineCode").clear();
							$("txtNbtSublineCd").clear();
							$("txtNbtPolIssCd").clear();
							$("txtNbtIssueYy").clear();
							$("txtNbtPolSeqNo").clear();
							$("txtNbtRenewNo").clear();
							$("txtLossCategory").clear();
							$("txtLossDate").clear();
							$("txtClmStatus").clear();
							customShowMessageBox("No record selected", "I",
									$("txtNbtClmLineCd"));
						}
					});
		} catch (e) {
			showErrorMessage("showClmPolLOV", e);
		}

	}
	initializeGICLS261();
</script>