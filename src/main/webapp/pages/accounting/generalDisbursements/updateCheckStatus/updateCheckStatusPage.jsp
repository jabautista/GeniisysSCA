<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="customContents" style="text-align: center;" name="customContents">
</div>
<div id="updateCheckStatusMainDiv" name="updateCheckStatusMainDiv" style="width:100%; float: left; margin-bottom: 0px;">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Check Status</label> 
		</div>
	</div>
	<div class="sectionDiv" id="updateCheckStatusHeader"> 
		<table width="96%" align="center" style="margin: 15px;">
			<tr>
				<td class="rightAligned">Company</td>
				<td class="leftAligned">
					<span class="lovSpan required" style="width: 80px;">
						<input type="hidden" id="txtFundCd" name="txtFundCd"/>
						<input type="text" id="txtCompany" name="txtCompany" class="required allCaps" ignoreDelKey="" style="width: 55px; float: left; border: none; height: 13px; margin: 0;" tabindex="101" lastValidValue=""/>								
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchCompany" name="searchCompany" alt="Go" style="float: right;" tabindex="102"/>
					</span>
					<input type="text" id="txtCompanyName" name="txtCompanyName" style="width: 270px; float: left; margin: 0 0 0 4px; height: 13.5px;" tabindex="103" readonly="readonly"/>
				</td>
				<td class="rightAligned">Branch</td>
				<td class="leftAligned">
					<span class="lovSpan required" style="width: 80px;">
						<input type="hidden" id="txtBranchCd"/>
						<input type="text" id="txtBranch" name="txtBranch" class="required allCaps" ignoreDelKey="" style="width: 55px; float: left; border: none; height: 13px; margin: 0;" tabindex="104" lastValidValue=""/>								
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBranch" name="searchBranch" alt="Go" style="float: right;" tabindex="105"/>
					</span>
					<input type="text" id="txtBranchName" name="txtBranchName" style="width: 270px; float: left; margin: 0 0 0 4px; height: 13.5px;" tabindex="106" readonly="readonly"/>
				</td>
			</tr>
		</table>
	</div>
	<div class="sectionDiv" >
		<div id="periodCoveredDiv" name="periodCoveredDiv" style=" width: 80%;  margin: 10px 0px 0px 0px;" " align="center">
			<table style="width: 80%; margin: 10px 0px 0px 0px;" >
				<tr>
					<td class="rightAligned">Period Covered</td>
					<td class="leftAligned" style="width: 160px;">
						<div class="withIconDiv required" style="float: left; width: 155px;">
							<input id="txtCoveredFromDate" class="withIcon required" ignoreDelKey="" type="text" readonly="readonly" style="width: 130px;" tabindex="107"/>
							<img id="hrefCoveredFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Period Covered" tabindex="108"/>
						</div>
					</td>
					<td class="rightAligned">to</td>
					<td class="leftAligned" style="width: 160px;">
						<div class="withIconDiv required" style="float: left; width: 155px;">
							<input id="txtCoveredToDate" class="withIcon required" ignoreDelKey="" type="text"  readonly="readonly" style="width: 130px;" tabindex="109"/>
							<img id="hrefCoveredToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="To" tabindex="110"/>
						</div>
					</td>
				</tr>
			</table>
		</div>
		<div class="sectionDiv" id="StatusMainDiv" name="StatusMainDiv" style=" width: 80%;margin: 10px 0px 15px 90px;">
			<label align="center" style="margin:5px 0px 5px 350px; font-weight:bold;">Status</label>
			<div class="sectionDiv" id="StatusDiv" name="StatusDiv" style="width: 98.3%; margin: 0px 5px 5px 5px;" align="center">
				<table>
					<tr>
						<td width="130px"><input type="radio" checked="checked" name="byStatus" id="rdoAll" title="All" style="float: left;" tabindex="111"/><label for="rdoAll" style="float: left; height: 20px; padding-top: 3px;" tabindex="112">All</label></td>
						<td width="130px"><input type="radio" name="byStatus" id="rdoRelease" title="Release" style="float: left;" tabindex="113"/><label for="rdoRelease" style="float: left; height: 20px; padding-top: 3px;" tabindex="114">Released</label></td>
						<td width="130px"><input type="radio" name="byStatus" id="rdoUnrelease" title="Unrelease" style="float: left;" tabindex="115"/><label for="rdoUnrelease" style="float: left; height: 20px; padding-top: 3px;" tabindex="116">Unreleased</label></td>
						<td width="130px"><input type="radio" name="byStatus" id="rdoOutstanding" title="Outstanding" style="float: left;" tabindex="117"/><label for="rdoOutstanding" style="float: left; height: 20px; padding-top: 3px;" tabindex="118">Outstanding</label></td>
						<td width="130px"><input type="radio" name="byStatus" id="rdoCleared" title="Cleared" style="float: left;" tabindex="119"/><label for="rdoCleared" style="float: left; height: 20px; padding-top: 3px;" tabindex="120">Cleared</label></td>
					</tr>
				</table>
			</div>
		</div>
	</div>
	<div class="sectionDiv" id="bankAccountMainDiv" name="bankAccountMainDiv">
		<div id="bankAccountTable" name="bankAccountTable" style="padding: 15px 0 15px 195px; height: 180px;">
		</div>
	</div>
	<div class="sectionDiv" id="chkDisbursementMainDiv" name="chkDisbursementMainDiv">
		<div id="chkDisbursementTable" style="padding: 15px 0 5px 100px; height: 225px;">
		</div>
		<div id="chkDisbursementFields" style="width: 90%;" align="center">
			<table style="width: 80%; margin: 30px 0px 0px 50px;">
				<tr>
					<td class="rightAligned">Check No.</td>
					<td class="leftAligned">
						<input id="txtCheckPrefSuf" type="text" style="width: 58px; padding-right: 2px;" readonly="readonly">
						<input id="txtCheckNo" type="text" style="width: 110px;" readonly="readonly">
					</td>
					<td class="rightAligned">Check Date</td>
					<td class="leftAligned">
						<input id="txtCheckDate" type="text" style="width: 180px;" readonly="readonly">
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Payee</td>
					<td class="leftAligned">
						<input id="txtPayee" type="text" style="width: 180px;" readonly="readonly">
					</td>
					<td class="rightAligned">Amount</td>
					<td class="leftAligned">
						<input id="txtAmount" type="text" style="width: 180px; text-align: right;" readonly="readonly">
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Release Date</td>
					<td class="leftAligned">
						<input id="txtCheckReleaseDate" type="text" style="width: 180px;" readonly="readonly">
					</td>
					<td class="rightAligned">Clearing Date</td>
					<td class="leftAligned" style="width: 160px;">
						<div class="withIconDiv" style="float: left; width: 185px;">
							<input id="txtClearingDate" class="withIcon" ignoreDelKey="" type="text"  readonly="readonly" style="width: 160px;" tabindex="109"/>
							<img id="hrefClearingDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="To" tabindex="110"/>
						</div>
					</td>
				</tr>
			</table>
		</div>
		<div style="margin: 10px;" align = "center">
			<input type="button" class="button" id="btnAdd" value="Update" tabindex="107">
		</div>
		<div class="buttonDiv" id="updateCheckStatusButtonDiv" align="center" style="margin: 10px; padding: 10px; border-top: 1px solid #E0E0E0; margin-bottom: 0;">
			<input type="button" class="button" id="btnCheckReleaseInfo" name="btnCheckReleaseInfo" value="Check Release Info" style="width: 140px;" tabindex="121"/>
			<input type="button" class="button" id="btnPrint" name="btnPrint" value="Print" style="width: 90px;" tabindex="122"/>
		</div>
	</div>
	<div class="buttonsDiv">
		<input type="button" class="button" id="btnCancelGIACS047" value="Cancel" tabindex="229">
		<input type="button" class="button" id="btnSaveGIACS047" value="Save" tabindex="230">
	</div>
</div>

<script  type="text/javascript">
	initializeAll();
	setModuleId("GIACS047");
	setDocumentTitle("Check Status");
	newFormInstance();	
	var paramHolder = new Object();
	var executeQuery = false;
	var invalidClearingDate = false;
	disableButton("btnPrint");
	disableButton("btnCheckReleaseInfo");
	disableButton("btnAdd");
	$("txtClearingDate").readOnly = true;
	disableDate("hrefClearingDate");
	$("customContents").hide();
	var selectedIndex = null;
	var xIndex = null;
	changeTag = 0;
	objGIACS047 = new Object();
	objGIACS047.exitPage = null;
	objACGlobal.callingForm = null;
	objACGlobal.gaccTranId = null;
	objACGlobal.branchCd = null;
	objACGlobal.fundCd = null;
	objACGlobal.fundName = null;
	objACGlobal.branchName = null;
	
	function resetAllFields() {
		paramHolder = new Object();
		executeQuery = false;
		disableButton("btnPrint");
		disableButton("btnCheckReleaseInfo");
		selectedIndex = null;
		xIndex = null;
		changeTag = 0;
		objGIACS047.exitPage = null;
		objACGlobal.callingForm = null;
		objACGlobal.gaccTranId = null;
		objACGlobal.branchCd = null;
		objACGlobal.fundCd = null;
		objACGlobal.fundName = null;
		objACGlobal.branchName = null;
	}
	
	
	try {
		var jsonBankAccount = JSON.parse('${jsonBankAccount}');
		var objBankAcct = null;
		bankAccountTableModel = {
			url : contextPath+ "/GIACUpdateCheckStatusController?action=showBankAccount",
			id: "bankAccount",
		    options : {
				width : '530px',
				height : '180px',
				pager : {},
				beforeClick: function(){
					if(changeTag == 1){
 						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
 						return false;
 					}
				},
				onCellFocus : function(element, value, x, y, id) {
					var obj = tbgBankAccount.geniisysRows[y];
					objBankAcct = tbgBankAccount.geniisysRows[y];
					showDisbursementInfo(obj);
					tbgBankAccount.keys.releaseKeys();
					observeDisbursementTableGrid(false);
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					showDisbursementInfo(null);
					tbgBankAccount.keys.releaseKeys();
					observeDisbursementTableGrid(false);
					objBankAcct = null;
				},
				beforeSort : function(){
					if(changeTag == 1){
 						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
 						return false;
 					}
					tbgBankAccount.keys.releaseKeys();
				},
				onSort : function(){
					showDisbursementInfo(null);
					tbgBankAccount.keys.releaseKeys();
					observeDisbursementTableGrid(false);
					objBankAcct = null;
				},
				prePager: function(){
					if(changeTag == 1){
 						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
 						return false;
 					}
					showDisbursementInfo(null);
					tbgBankAccount.keys.releaseKeys();
				},
				onFilter : function(){
					showDisbursementInfo(null);
					tbgBankAccount.keys.releaseKeys();
					observeDisbursementTableGrid(false);
					objBankAcct = null;
				},
				onRefresh : function(){
					showDisbursementInfo(null);
					tbgBankAccount.keys.releaseKeys();
					observeDisbursementTableGrid(false);
					objBankAcct = null;
				},
				toolbar : {
					elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
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
					id : "bankName",
					title : "Bank Name",
					width : '200px',
					filterOption : true
				}, 
				{
					id : "bankAcctNo",
					title : "Account No.",
					width : '300px',
					filterOption : true
				}
			],
			rows : jsonBankAccount.rows
		};
		tbgBankAccount = new MyTableGrid(bankAccountTableModel);
		tbgBankAccount.pager = jsonBankAccount;
		tbgBankAccount.render('bankAccountTable');
	} catch (e) {
		showErrorMessage("bankAccountTableModel", e);
	}
	
	try {
		var origClearingDate = null;
		var objChkDisbursement = null;
		var jsonChkDisbursement = JSON.parse('${jsonChkDisbursement}');
		chkDisbursementTableModel = {
			url : contextPath+ "/GIACUpdateCheckStatusController?action=showDisbursementAccount&branchCd="+$F("txtBranchCd"),
			id: "disbursement",
			options : {
				hideColumnChildTitle: true,
				width : '720px',
				height : '250px',
				pager : {},
				onCellFocus : function(element, value, x, y, id) {
					selectedIndex = y;
					observeDisbursementTableGrid(true);
					objChkDisbursement = tbgChkDisbursement.geniisysRows[y];
					setFieldValues(objChkDisbursement);
					var clearingDate = tbgChkDisbursement.geniisysRows[y].clearingDate;
					var checkReleaseDate = tbgChkDisbursement.geniisysRows[y].checkReleaseDate;
					objACGlobal.fundCd = $F("txtCompany");
					objACGlobal.branchCd = tbgChkDisbursement.geniisysRows[y].gibrBranchCd;
					objACGlobal.fundName = $F("txtCompanyName");
					objACGlobal.branchName = tbgChkDisbursement.geniisysRows[y].branchName;
					objACGlobal.gaccTranId  = tbgChkDisbursement.geniisysRows[y].gaccTranId;
					xIndex = x;
					if (checkReleaseDate == null && clearingDate == null){
						disableDate("hrefClearingDate");
						disableButton("btnAdd");
					}else if(clearingDate != null && nvl(tbgChkDisbursement.geniisysRows[y].recordStatus,"") == ""){
						disableDate("hrefClearingDate");
						disableButton("btnAdd");
					}else{
						enableDate("hrefClearingDate");
						enableButton("btnAdd");
					}
					tbgChkDisbursement.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					objACGlobal.fundCd = null;
					objACGlobal.branchCd = null;
					objACGlobal.gaccTranId = null;
					observeDisbursementTableGrid(false);
					tbgChkDisbursement.keys.releaseKeys();
					setFieldValues(null);
				},
				onCellBlur: function(element, value, x, y, id) {
					tbgChkDisbursement.keys.releaseKeys();
				},
				beforeSort : function(){
					if(changeTag == 1){
 						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
 						return false;
 					}
				},
				prePager: function(){
					if(changeTag == 1){
 						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
 						return false;
 					}
				},
				postPager : function() {
					setFieldValues(null);
					observeDisbursementTableGrid(false);
					tbgChkDisbursement.keys.releaseKeys();
				},
				onSort : function(){
					setFieldValues(null);
					observeDisbursementTableGrid(false);
					tbgChkDisbursement.keys.releaseKeys();
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
				onRefresh : function(){
					setFieldValues(null);
					observeDisbursementTableGrid(false);
					tbgChkDisbursement.keys.releaseKeys();
				},
				onFilter : function(){
					setFieldValues(null);
					observeDisbursementTableGrid(false);
					tbgChkDisbursement.keys.releaseKeys();
				},
				toolbar : {
					elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
				}
			},
			columnModel : [ 
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
					id : "checkPrefSuf checkNo",
					title : "Check No.",
					width : 140,
					children: [
				    	   	    {	id: 'checkPrefSuf',
				    	   	    	width: 80, //100,
				    	   	    	title : 'Check Pref. Suf.',
							    	filterOption : true,
							    },
							    {	id: 'checkNo',
							    	width: 130, // 50
							    	title : 'Check No.',
							    	filterOptionType: 'integer',
							    	filterOption : true,
							    	align: 'right'
							    }
			    	          ]
				}, 
				{
					id : "checkDate",
					title : "Check Date",
					titleAlign: "center",
					filterOptionType: 'formattedDate',
					align : "center",
					width : '80px',
					filterOption : true,
					renderer: function(value) {
						return nvl(value, "") == '' ? '' : dateFormat(value, 'mm-dd-yyyy');
					}
				},
				{
					id : "payee",
					title : "Payee",
					width : '180px',
					filterOption : true
				}, 
				{
					id : "amount",
					title : "Amount",
					titleAlign: "right",
					align : "right",
					filterOptionType: 'number',
					width : '80px',
					filterOption : true,
					renderer: function(value){
			    		return nvl(value,'') == '' ? '0.00' : formatCurrency(nvl(value, 0));
			    	}
				}, 
				{
					id : "checkReleaseDate",
					title : "Release Date",
					titleAlign: "center",
					filterOptionType: 'formattedDate',
					align : "center",
					width : '95px',
					filterOption : true,
					renderer: function(value) {
						return nvl(value, "") == '' ? '' : dateFormat(value, 'mm-dd-yyyy');
					}
				}, 
				{
					id : "clearingDate",
					title : "Clearing Date",
					titleAlign: "center",
					filterOptionType: 'formattedDate',
					align : "center",
					width : '95px',
					filterOption : true,
					format: 'mm-dd-yyyy',
					renderer: function(value) {
						return nvl(value, "") == '' ? '' : dateFormat(value, 'mm-dd-yyyy');
					}
				}, 
				{
					id : "gaccTranId",
					width : '0',
					visible : false
				}, 
				
			],
			rows : jsonChkDisbursement.rows
		};
		tbgChkDisbursement = new MyTableGrid(chkDisbursementTableModel);
		tbgChkDisbursement.pager = jsonChkDisbursement;
		tbgChkDisbursement.render('chkDisbursementTable');
	} catch (e) {
		showErrorMessage("chkDisbursementTableModel", e);
	}
	
	function setFieldValues(rec){
		try{
			$("txtCheckPrefSuf").value = (rec == null ? "" : unescapeHTML2(rec.checkPrefSuf));
			$("txtCheckNo").value = (rec == null ? "" : rec.checkNo);
			$("txtCheckDate").value = (rec == null ? "" : rec.checkDate);
			$("txtPayee").value = (rec == null ? "" : unescapeHTML2(rec.payee));
			$("txtAmount").value = (rec == null ? "" : formatCurrency(rec.amount));
			$("txtCheckReleaseDate").value = (rec == null ? "" : rec.checkReleaseDate);
			$("txtClearingDate").value = (rec == null ? "" : rec.clearingDate); 
			origClearingDate = (rec == null ? "" : rec.clearingDate); 
			
			rec == null ? disableButton("btnAdd") : enableButton("btnAdd");
			if (rec == null){
				$("txtClearingDate").readOnly = true;
				disableDate("hrefClearingDate");
			}
			objChkDisbursement = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.clearingDate = $F("txtClearingDate");
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try {
			if (nvl(origClearingDate,"") == nvl($F("txtClearingDate"),"")) {
				showMessageBox("There are no changes to update.","I");
				return;
			}
			changeTagFunc = saveChkDisbursement;
			var dept = setRec(objChkDisbursement);
			tbgChkDisbursement.updateVisibleRowOnly(dept, selectedIndex, false);
			changeTag = 1;
			setFieldValues(null);
			tbgChkDisbursement.keys.removeFocus(tbgChkDisbursement.keys._nCurrentFocus, true);
			tbgChkDisbursement.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}	
	
	function saveChkDisbursement() {
		try {
			if(changeTag == 0) {
				showMessageBox(objCommonMessage.NO_CHANGES, "I");
				return;
			}
			var objParam = new Object();
			objParam.setClearingDate = getAddedAndModifiedJSONObjects(tbgChkDisbursement.geniisysRows);
			new Ajax.Request(contextPath+"/GIACUpdateCheckStatusController?action=saveChkDisbursement",{
				method: "POST",
				asynchronous: false,
				evalScripts: true,
				parameters:{
					params: JSON.stringify(objParam),
				},
				onCreate: function(){
					showNotice("Saving Check Status, please wait...");
				},
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response) ){
						changeTagFunc = "";
						showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
							if(objGIACS047.exitPage != null) {
								tbgChkDisbursement.refresh();
								tbgBankAccount.keys.releaseKeys();
								objGIACS047.exitPage();
							} else {
// 								resetAllFields();
								tbgChkDisbursement.refresh();
								tbgBankAccount.keys.releaseKeys();
								
							}
						});
						
						changeTag = 0;
						xIndex = null;
					}	
				}
			});
		} catch (e) {
			showErrorMessage("saveChkDisbursement",e);
		}
	}
	function observeDisbursementTableGrid(cond) {
		if(cond){
			enableButton("btnPrint");
			enableButton("btnCheckReleaseInfo");
			enableToolbarButton("btnToolbarPrint");
		}else{
			selectedIndex = null;
			disableButton("btnPrint");
			disableButton("btnCheckReleaseInfo");
			disableToolbarButton("btnToolbarPrint");
		}
		if ($("rdoAll").checked) {
			disableButton("btnPrint");
			disableToolbarButton("btnToolbarPrint");
		}else{
			if (objBankAcct != null){
				enableButton("btnPrint");
				enableToolbarButton("btnToolbarPrint");
			}
		}
	}
	function showDisbursementInfo(obj) {
		try {
			var statusValue = null;
			executeQuery = false;
			if(obj != null){
				if ($("rdoAll").checked){
					statusValue = 1;
				}else if ($("rdoRelease").checked){
					statusValue = 2;
				}else if ($("rdoUnrelease").checked){
					statusValue = 3;
				}else if ($("rdoOutstanding").checked){
					statusValue = 4;
				}else if ($("rdoCleared").checked){
					statusValue = 5;
				}
			executeQuery = true;
			}
			paramHolder.bankCd	 	= (obj) == null ? "" : nvl(obj.bankCd,"");
			paramHolder.bankAcctCd 	= (obj) == null ? "" : nvl(obj.bankAcctCd,"");
			var bankCd 				= (obj) == null ? "" : nvl(obj.bankCd,"");
			var bankAcctCd 			= (obj) == null ? "" : nvl(obj.bankAcctCd,"");
			var fromDate 			= (obj) == null ? "" : nvl($F("txtCoveredFromDate"),"");
			var toDate 				= (obj) == null ? "" : nvl($F("txtCoveredToDate"),"");
			var status 				= (obj) == null ? "" : nvl(statusValue,"");
			tbgChkDisbursement.url = contextPath+ "/GIACUpdateCheckStatusController?action=showDisbursementAccount&bankCd="+bankCd+
																												  "&bankAcctCd="+bankAcctCd+
																												  "&fromDate="+fromDate+
																												  "&toDate="+toDate+
																												  "&status="+status
																												  +"&branchCd="+$F("txtBranchCd");
			tbgChkDisbursement._refreshList();
		} catch (e) {
			showErrorMessage("showDisbursementInfo",e);
		}
	}
	
	function printCheckStatus() {
		try {
			var fileType = ""; //$("rdoPdf").checked ? "PDF" : "XLS"; // replaced by codes below : shan 07.15.2014			
			$$("input[name='fileType']").each(function(rdo){
				if (rdo.checked){
					fileType = rdo.value == "EXCEL" ? "XLS" : rdo.value;
				}
			});
			
			var reportId = "";
			
			var pNull = "";
			var pCleared = "";
			// shan 11.19.2014
			var fromDate = "";
			var toDate = "";
			var asOfDate = $F("txtCoveredToDate");
			// end 11.19.2014
			if ($("rdoRelease").checked || $("rdoOutstanding").checked || $("rdoCleared").checked) {
				reportId = "GIACR186";//for GIACR186 report
			} else if($("rdoUnrelease").checked) {
				reportId = "GIACR185";//for GIACR185 report
			}
			if($("rdoRelease").checked){
				pNull = '0';
				pCleared = 'N';
				// shan 11.19.2014
				fromDate = $F("txtCoveredFromDate");
				toDate = $F("txtCoveredToDate");
				asOfDate = "";
				// end 11.19.2014
			}else if($("rdoOutstanding").checked){
				pNull = '1';
				pCleared = 'N';
			}else if($("rdoCleared").checked){
				pNull = '0';
				pCleared = 'Y';
			}
			var content = contextPath+"/GeneralDisbursementPrintController?action=printGIACS184Reports"
			+"&noOfCopies="+$F("txtNoOfCopies")
			+"&printerName="+$F("selPrinter")
			+"&destination="+$F("selDestination")
			+"&cutOffDate="+$F("txtCoveredToDate")
			+"&reportId="+reportId	
			+"&fromDate="+fromDate //+$F("txtCoveredFromDate")	
			+"&toDate="+toDate //+$F("txtCoveredToDate")
			+"&asOfDate="+asOfDate //$F("txtCoveredToDate") //(reportId == "GIACR186" ? $F("txtCoveredToDate") : null)
			+"&branchCd="+$F("txtBranchCd")
			+"&bankCd="+paramHolder.bankCd
			+"&bankAcctCd="+paramHolder.bankAcctCd
			+"&paramNull="+pNull
			+"&paramCleared="+pCleared
			+"&moduleId=GIACS047"
			+"&fileType="+fileType;
			printGenericReport(content, "Released Checks"); 
		} catch (e) {
			showErrorMessage("printCheckStatus",e);
		}
	}
	function newFormInstance() {
		try {
			disableSearch("searchBranch");
			$("txtBranch").readOnly = true;
			$("txtCompany").focus();
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
			disableToolbarButton("btnToolbarPrint");
		} catch (e) {
			showErrorMessage("newFormInstance",e);
		}
	}

	function executeQueryFields() {
		$("txtCompany").readOnly = true;
		$("txtBranch").readOnly = true;
		disableSearch("searchCompany");
		disableSearch("searchBranch");
		disableDate("hrefCoveredFromDate");
		disableDate("hrefCoveredToDate");
		disableToolbarButton("btnToolbarExecuteQuery");
	}
	
	function notAllowedKey(keyCode) {
		if(keyCode==32 || keyCode==8 || keyCode==46 || (keyCode>=48 && keyCode<=90) || (keyCode>=96 && keyCode<=111) || (keyCode>=186 && keyCode<=222)){
			return true;
		}
		return false;
	}
	
	function exitPage(){
		objACGlobal.callingForm = null;
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	}
	
	function showCheckReleaseInfo() {
		try {
			if(checkUserModule("GIACS046")){
				new Ajax.Request(contextPath + "/GIACInquiryController", {
					parameters : {
						action : "showCheckReleaseInfo"
					},
					asynchronous: false,
					evalScripts: true,
					onComplete : function(response) {
						objACGlobal.callingForm = "GIACS047";
						$("customContents").update(response.responseText);
						$("updateCheckStatusMainDiv").hide();
						$("customContents").show();
						hideAccountingMainMenus();
						objGIACS047.objChkDisbursement = objChkDisbursement;
					}
				});
			}else{
				showMessageBox("User has no access to this module.","E");
			}
		} catch (e) {
			showErrorMessage("showCheckReleaseInfo", e);
		}
	}
	
	 /* observe */
	observeBackSpaceOnDate("txtClearingDate");
	$$("div#StatusDiv input[type='radio']").each(function (a) {
			$(a).observe("change",function(){
				observeDisbursementTableGrid(false);
				var obj = new Object();
				obj.bankCd	 	= (paramHolder) == null ? "" : nvl(paramHolder.bankCd,"");
				obj.bankAcctCd 	= (paramHolder) == null ? "" : nvl(paramHolder.bankAcctCd,"");
				if (executeQuery) {
					showDisbursementInfo(obj);
				}
			});
		});
	$("btnToolbarPrint").observe("click", function(){
		showGenericPrintDialog("Print Check Status",printCheckStatus,null,true);
	});
	$("btnPrint").observe("click", function(){
		$("btnToolbarPrint").click();
	});
	$("btnCheckReleaseInfo").observe("click", function(){
		if(changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No","Cancel", 
					function(){
						objGIACS047.exitPage = showCheckReleaseInfo;
						saveChkDisbursement();
					}, function(){
						changeTag = 0;
						showCheckReleaseInfo();
						tbgChkDisbursement.refresh();
					}, "");
		}else{
			showCheckReleaseInfo();
		}
	});
	$("btnToolbarExecuteQuery").observe("click",function(){
		if (checkAllRequiredFieldsInDiv("periodCoveredDiv")) {
			executeQueryFields();
			tbgBankAccount.url = contextPath+ "/GIACUpdateCheckStatusController?action=showBankAccount&branchCd="+$F("txtBranchCd");
			tbgBankAccount._refreshList();
			if (tbgBankAccount.geniisysRows.length == 0){
				showMessageBox("Query caused no records to be retrieved. Re-enter.","I");
			};
		}
	});
	$("btnToolbarEnterQuery").observe("click",function(){
		if(changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No","Cancel", 
					function(){
						objGIACS047.exitPage = showUpdateCheckStatus;
						saveChkDisbursement();
					}, function(){
						changeTag = 0;
						tbgChkDisbursement.keys.releaseKeys();
						showUpdateCheckStatus();
					}, "");
		}else{
			tbgChkDisbursement.keys.releaseKeys();
			showUpdateCheckStatus();
		}
	});
	$("searchCompany").observe("click", function() {
		var findText2 = $("txtCompany").readAttribute("lastValidValue").trim() != $F("txtCompany").trim() ? $F("txtCompany").trim() : "%";
		showGIACS003CompanyLOV(findText2,'GIACS047');
	});
	$("txtCompany").observe("change", function() {
		if($F("txtCompany").trim() == "") {
			$("txtFundCd").clear();
			$("txtBranchCd").clear();
			$("txtBranch").clear();
			$("txtCompanyName").clear();
			$("txtCompany").setAttribute("lastValidValue", "");
			$("txtBranch").setAttribute("lastValidValue", "");
			$("txtBranch").readOnly = true;
			disableSearch("searchBranch");
			disableToolbarButton("btnToolbarExecuteQuery");
			disableToolbarButton("btnToolbarEnterQuery");
		} else {
			if($F("txtCompany").trim() != "" && $F("txtCompany") != unescapeHTML2($("txtCompany").readAttribute("lastValidValue"))) {
				var findText2 = $("txtCompany").readAttribute("lastValidValue").trim() != $F("txtCompany").trim() ? $F("txtCompany").trim() : "%";
				showGIACS003CompanyLOV(findText2,'GIACS047');
			}
		}
	});
	$("searchBranch").observe("click", function() {
		var findText2 = $("txtBranch").readAttribute("lastValidValue").trim() != $F("txtBranch").trim() ? $F("txtBranch").trim() : "%";
		showGIACS003BranchLOV('GIACS047',$F("txtFundCd"),findText2);
	});
	$("txtBranch").observe("change", function() {
		if($F("txtBranch").trim() == "") {
			$("txtBranchCd").clear();
			$("txtBranchName").clear();
			$("txtBranch").setAttribute("lastValidValue", "");
			disableToolbarButton("btnToolbarExecuteQuery");
		} else {
			if($F("txtBranch").trim() != "" && $F("txtBranch") != unescapeHTML2($("txtBranch").readAttribute("lastValidValue"))) {
				var findText2 = $("txtBranch").readAttribute("lastValidValue").trim() != $F("txtBranch").trim() ? $F("txtBranch").trim() : "%";
				showGIACS003BranchLOV('GIACS047',$F("txtFundCd"),findText2);
			}
		}
	});
	$("hrefCoveredFromDate").observe("click", function(){
		scwShow($('txtCoveredFromDate'),this, null);
	});
	$("hrefCoveredToDate").observe("click", function(){
		scwShow($('txtCoveredToDate'),this, null);
	});
	observeBackSpaceOnDate("txtCoveredFromDate",function(){disableToolbarButton("btnToolbarExecuteQuery");});
	observeBackSpaceOnDate("txtCoveredToDate",function(){disableToolbarButton("btnToolbarExecuteQuery");});
	$("txtCoveredFromDate").observe("focus", function(){
		if ($("txtCoveredToDate").value != "" && this.value != "") {
			if (compareDatesIgnoreTime(Date.parse($F("txtCoveredFromDate")),Date.parse($("txtCoveredToDate").value)) == -1) {
				customShowMessageBox("From Date should not be later than To Date.","I","txtCoveredFromDate");
				this.clear();
				return;
			}
			enableToolbarButton("btnToolbarExecuteQuery");
		}
	});
	$("txtCoveredToDate").observe("focus", function(){
		if ($("txtCoveredFromDate").value != ""&& this.value != "") {
			if (compareDatesIgnoreTime(Date.parse($F("txtCoveredFromDate")),Date.parse($("txtCoveredToDate").value)) == -1) {
				customShowMessageBox("From Date should not be later than To Date.","I","txtCoveredToDate");
				this.clear();
				return;
			}
			enableToolbarButton("btnToolbarExecuteQuery");
		}
	});
	$("hrefClearingDate").observe("click", function(){
		scwShow($('txtClearingDate'),this, null);
	});
	$("txtClearingDate").observe("focus", function(){
		if (this.value != "") {
			if (compareDatesIgnoreTime(Date.parse($F("txtCheckReleaseDate")),Date.parse(this.value)) == -1) {
				customShowMessageBox("Release Date should not be later than Clearing Date.","I","txtClearingDate");
				this.clear();
				return;
			}
			if (compareDatesIgnoreTime(Date.parse(this.value),new Date()) == -1) {
				customShowMessageBox("Clearing Date should not be later than Current Date.","I","txtClearingDate");
				this.clear();
				return;
			}
		}
	});
	$("btnToolbarExit").observe("click", function(){
 		if(changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No","Cancel", 
					function(){
						objGIACS047.exitPage = exitPage;
						saveChkDisbursement();
					}, function(){
						changeTag = 0;
						exitPage();
					}, "");
		}else{
			exitPage();
		}
	});
	
	$("btnCancelGIACS047").observe("click", function(){
		$("btnToolbarExit").click();
	});
	$("btnAdd").observe("click", addRec);
	observeSaveForm("btnSaveGIACS047", saveChkDisbursement);
	$("logout").observe("mousedown",function(){
		tbgChkDisbursement._blurCellElement(tbgChkDisbursement.keys._nCurrentFocus == null ? tbgChkDisbursement.keys._nOldFocus : tbgChkDisbursement.keys._nCurrentFocus);
	});
	
	hideToolbarButton("btnToolbarPrint");	// shan 08.15.2014
</script>