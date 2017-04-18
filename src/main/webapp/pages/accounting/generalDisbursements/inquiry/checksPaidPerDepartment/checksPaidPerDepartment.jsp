<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-chache");
	response.setHeader("Pragma","no-cache");
%>
<div id="checksPaidPerDeptMainDiv" name="checksPaidPerDeptMainDiv" style="height: 680px;">
	<div id="checksPaidPerDeptDiv" name="checksPaidPerDeptDiv">
		<jsp:include page="/pages/toolbar.jsp"></jsp:include>
		<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
			<div id="innerDiv" name="innerDiv">
				<label>View Checks Paid per Department</label>
 				<span class="refreshers" style="margin-top: 0;">
					<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
					<label id="reloadChecksPaidPerDept" name="reloadChecksPaidPerDept">Reload Form</label>
				</span>
			</div>
		</div>
		<div id="checksPaidPerDeptHeaderDiv">			
			<div class="sectionDiv" id="headerFormDiv" style="float: left; width: 100%;">
				<table style="margin-top: 10px; margin-bottom: 0px; float: left;" >
					<tr style="margin: 0px;">
						<td class="rightAligned" width="90px">Company</td>
						<td>
							<div id="fundCdDiv" style="float: left; width: 70px; height: 19px; margin-left: 5px; border: 1px solid gray;" class="required">
								<input id="txtFundCd" name="Company" title="Fund Code" type="text" maxlength="3" class="required" style="float: left; height: 13px; width: 45px; margin: 0px; border: none;" tabindex="101" ignoreDelKey="1">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgFundCdLOV" name="imgFundCdLOV" alt="Go" style="float: right;" tabindex="102"/>
							</div>
						</td>
						<td>
							<input type="text" id="txtFundDesc" style="width: 275px; margin-top: 3x;" readonly="readonly" tabindex="103"/>
						</td>
						<td class="rightAligned" width="60px">Branch</td>
						<td>
							<div id="branchCdDiv" class="required" style="float: left; width: 70px; height: 19px; margin-left: 5px; border: 1px solid gray;">
								<input id="txtBranchCd" name="Branch" title="Branch Code" type="text" maxlength="2" class="required" style="float: left; height: 13px; width: 45px; margin: 0px; border: none;" tabindex="104" ignoreDelKey="1">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgBranchCdLOV" name="imgBranchCdLOV" alt="Go" style="float: right;" tabindex="105"/>
							</div>
						</td>
						<td>
							<input type="text" id="txtBranchName" style="width: 275px; margin-top: 3x;" readonly="readonly" tabindex="106"/>
						</td>
					</tr>
				</table>
				<table style="float: left; margin-bottom: 10px;">
					<tr style="margin: 0px;">
						<td class="rightAligned" width="90px">Department</td>
						<td>
							<div id="oucIdDiv" class="required" style="float: left; width: 70px; height: 19px; margin-left: 5px; border: 1px solid gray;">
								<input id="txtOucId" name="Department" title="Ouc Id" type="text" maxlength="4" class="required integerNoNegativeUnformatted" style="float: left; height: 13px; width: 45px; margin: 0px; border: none;" tabindex="107" ignoreDelKey="1">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgOucIdLOV" name="imgOucIdLOV" alt="Go" style="float: right;" tabindex="108"/>
							</div>
						</td>
						<td>
							<input type="text" id="txtOucName" name="txtOucName" style="width: 275px; margin-top: 3x;" readonly="readonly" tabindex="109"/>
						</td>
						<td class="rightAligned" width="60px;">From</td>
						<td class="leftAligned">
							<div style="float: left; width: 155px;" class="withIconDiv required" id="fromDiv">
								<input type="text" id="txtFromDate" name="From date." removeStyle="true" class="withIcon required date" readonly="readonly" style="width: 130px;" tabindex="110" ignoreDelKey="1"/>
								<img id="hrefFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="From Date" tabindex="111"/>
							</div>
						</td>
						<td class="rightAligned" style="width: 30px;">To</td>
						<td class="leftAligned">
							<div style="float: left; width: 155px;" class="withIconDiv required" id="toDiv">
								<input type="text" id="txtToDate" name="To date." removeStyle="true" class="withIcon required date" readonly="readonly" style="width: 130px;" tabindex="112" ignoreDelKey="1"/>
								<img id="hrefToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="To Date" tabindex="113"/>
							</div>
						</td>
					</tr>
				</table>
			</div>
	
			<div class="sectionDiv" style="margin-bottom: 70px;">
				<div id="checksPaidPerDeptTableDiv" style="margin: 10px 0px 10px 10px; float: left;">
					<div id="checksPaidPerDeptTable" style="height: 300px; width: 752px; margin-left: 17%;"></div>
					<table style="margin-left: 54%;">
						<tr> <td class="rightAligned" style="margin-left: 3px;">Total</td>
						<td class="leftAligned">
							<input type="text" class="rightAligned" id="txtTotal" name="txtTotal" style="width: 225px;" readonly="readonly" tabindex="201"/>
						</td>
						</tr>
					</table>
				</div>
				<div class="sectionDiv" id="checksPaidPerDeptFormDiv" style="float: left; clear: both; margin-left: 10px; margin-bottom:10px; width: 97%;">
					<table style="padding-left: 13%; float: left; margin-top: 10px; margin-bottom: 10px;">
						<tr style="margin: 0px;">
							<td class="rightAligned">Payee</td>
							<td colspan="3">
								<input id="txtPayeeCd" name="txtPayeeCd" type="text" style="width: 70px; margin-left: 3px;" readonly="readonly" tabindex="301">
								<input type="text" id="txtPayeeName" name="txtPayeeName" style="width: 513px;" readonly="readonly" tabindex="302"/>
							</td>
						</tr>
						<tr>
							<td class="rightAligned">Particulars</td>
							<td class="leftAligned" colspan="3">
								<div style="border: 1px solid gray; width: 600px;">
									<textarea id="txtParticulars" name="txtParticulars" style="width: 570; border: none; height: 13px; resize: none;" readonly="readonly" tabindex=203></textarea>
									<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="viewParticulars" tabindex="304"/>
								</div>
							</td>	
						</tr>
						<tr>
							<td class="rightAligned">Bank</td>
							<td class="leftAligned">
								<input type="text" id="txtBank" name="txtBank" style="width: 225px;" readonly="readonly" tabindex="305"/>
							</td>
							<td class="rightAligned">Account No.</td>
							<td class="leftAligned" style="width: 195px;">
								<input type="text" id="txtAccountNo" name="txtAccountNo" style="width: 225px;" readonly="readonly" tabindex="306"/>
							</td>
						</tr>
						<tr>
							<td class="rightAligned">User ID</td>
							<td class="leftAligned">
								<input type="text" id="txtUserId" name="txtUserId" style="width: 225px;" readonly="readonly" tabindex="307"/>
							</td>
							<td class="rightAligned">Last Update</td>
							<td class="leftAligned" style="width: 195px;">
								<input type="text" id="txtLastUpdate" name="txtLastUpdate" style="width: 225px;" readonly="readonly" tabindex="308"/>
							</td>
						</tr>
					</table>
				</div>
				<div style="width: 100%; margin-bottom: 10px; float: left; padding-left: 45%;">
					<input type="button" class="disabledButton" id="btnPrint" name="btnPrint" value="Print Report" disabled="disabled" style="width: 100px" tabindex="401"/>
				</div>
			</div>	
		</div>
	</div>
</div>


<script type="text/javascript">
	
	function initializeChecksPaidPerDept() {
		setModuleId("GIACS241");
		setDocumentTitle("View Checks Paid per Department");
		On = "On";
		record = new Array();
		initializeAll();
		initializeAccordion();
		initializeAllMoneyFields();
		disableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
		disableToolbarButton("btnToolbarPrint");
		$("txtFundCd").focus();
	}initializeChecksPaidPerDept();

	var jsonChecksPaidPerDept = JSON.parse('${jsonChecksPaidPerDept}');
	checksPaidPerDeptTableModel = {
			url : contextPath+"/GIACInquiryController?action=showChecksPaidPerDepartment&refresh=1",
			options: {
				toolbar: {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onRefresh: function() {
						populateDetail(null);
						tbgChecksPaidPerDept.keys.releaseKeys();
					},
					onFilter: function() {
						populateDetail(null);
						tbgChecksPaidPerDept.keys.releaseKeys();
					}
				},
				width: '628px',
				height: '275px',
				onCellFocus : function(element, value, x, y, id) {
					populateDetail(tbgChecksPaidPerDept.geniisysRows[y]);					
					tbgChecksPaidPerDept.keys.removeFocus(tbgChecksPaidPerDept.keys._nCurrentFocus, true);
					tbgChecksPaidPerDept.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id){
					populateDetail(null);
					tbgChecksPaidPerDept.keys.releaseKeys();
				},
				prePager : function() {
					populateDetail(null);
					tbgChecksPaidPerDept.keys.releaseKeys();
				},
				onSort : function() {
					populateDetail(null);
					tbgChecksPaidPerDept.keys.releaseKeys();
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
					id : "checkNo",
					title : "Check No.",
					width : '215px',
					filterOption : true
				},
				{
					id : "checkDate",
					title : "Check Date",
					width : '160px',
					align : 'center',
					titleAlign : 'center',
					filterOption : true,
					type: 'date',
					format: 'mm-dd-yyyy',
					titleAlign: 'center',
					filterOptionType : 'formattedDate'
				},
				{
					id : "dvAmount",
					title : "Disbursement Amount",
					width : '220px',
					align : 'right',
					titleAlign : 'right',
					filterOption : true,
					filterOptionType: 'number',
					geniisysClass: 'money'
				}
			],
			rows: jsonChecksPaidPerDept.rows
		};
	
	tbgChecksPaidPerDept = new MyTableGrid(checksPaidPerDeptTableModel);
	tbgChecksPaidPerDept.pager = jsonChecksPaidPerDept;
	tbgChecksPaidPerDept.render('checksPaidPerDeptTable');
	tbgChecksPaidPerDept.afterRender = function(){
		if(tbgChecksPaidPerDept.geniisysRows.length > 0){
			computeTotal();
		} else {
			$("txtTotal").value = "";
		}
	};
	
	function computeTotal() {
		var total  = 0;
		new Ajax.Request(contextPath+"/GIACInquiryController",{
			parameters: {
				action: "getDvAmount",
				fundCd: $F("txtFundCd"),
				branchCd: $F("txtBranchCd"),
				oucId: $F("txtOucId"),
				fromDate: $F("txtFromDate"),
				toDate: $F("txtToDate") 
			},
			method: "POST",
			onComplete : function (response){
				if(checkErrorOnResponse(response)){
					record = JSON.parse(response.responseText);
					for ( var b = 0; b < record.dv.length; b++) {
						total 	= total  + parseFloat(record.dv[b]['dvAmount']);
					}
					$("txtTotal").value  = formatCurrency(parseFloat(nvl(total, "0")));
				}
			}							 
		});	
	}
	
	function showFundLOV(isIconClicked) {
		try {
			var searchString = ((isIconClicked || isIconClicked == null) ? "%" : nvl($F("txtFundCd"), "%"));	
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getFundChecksPaidDeptLOV",
					search : searchString //$("txtFundCd").value
				},
				title : "List of Companies",
				width : 370,
				height : 390,
				autoSelectOneRecord : true,
				filterText : searchString, //$("txtFundCd").value,
				columnModel : [ 
				    {
						id : "fundCd",
						title : "Fund Cd",
						width : '100px'
					}, 
					{
						id : "fundDesc",
						title : "Fund Desc",
						width : '250px'
					}
				],
				draggable : true,
				onSelect : function(row) {
					$("txtFundCd").value = unescapeHTML2(row.fundCd);
					$("txtFundDesc").value = unescapeHTML2(row.fundDesc);
					if ($F("txtFundCd") != "" && $F("txtBranchCd") != "" && $F("txtOucId") != "" && $F("txtFromDate") != "" && $F("txtToDate") != "") {
						enableToolbarButton("btnToolbarExecuteQuery");
					}else {
						enableToolbarButton("btnToolbarEnterQuery");
					}
					$("txtFundCd").setAttribute("lastValidValue", unescapeHTML2(row.fundCd));
					$("txtBranchCd").focus();
				},
				onCancel: function(){
					$("txtFundCd").focus();
					$("txtFundCd").value = $("txtFundCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function() {
					showMessageBox("No record selected.", imgMessage.INFO);
				}
			});
		} catch (e) {
			showErrorMessage("Company LOV", e);
		}
	}

	function showBranchLOV(isIconClicked) {
		try {
			var searchString = ((isIconClicked || isIconClicked == null) ? "%" : nvl($F("txtBranchCd"), "%"));	
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getBranchChecksPaidDeptLOV",
					fundCd : $("txtFundCd").value,
					search : searchString //$("txtBranchCd").value
				},
				title : "List of Branches",
				width : 370,
				height : 390,
				autoSelectOneRecord : true,
				filterText : searchString, //$("txtBranchCd").value,
				columnModel : [ 
				    {
						id : "branchCd",
						title : "Branch Cd",
						width : '100px'
					}, 
					{
						id : "branchName",
						title : "Branch Name",
						width : '250px'
					}
				],
				draggable : true,
				onSelect : function(row) {
					$("txtBranchCd").value = unescapeHTML2(row.branchCd);
					$("txtBranchName").value = unescapeHTML2(row.branchName);
					if ($F("txtFundCd") != "" && $F("txtBranchCd") != "" && $F("txtOucId") != "" && $F("txtFromDate") != "" && $F("txtToDate") != "") {
						enableToolbarButton("btnToolbarExecuteQuery");
					}else {
						enableToolbarButton("btnToolbarEnterQuery");
					}
					$("txtBranchCd").setAttribute("lastValidValue", unescapeHTML2(row.branchCd));
					$("txtOucId").focus();
				},
				onCancel: function(){
					$("txtBranchCd").focus();
					$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function() {
					showMessageBox("No record selected.", imgMessage.INFO);
				}
			});
		} catch (e) {
			showErrorMessage("Branch LOV", e);
		}
	}

	function showOucLOV(isIconClicked) {
		try {
			var searchString = ((isIconClicked || isIconClicked == null) ? "" : $F("txtOucId"));	
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getOucChecksPaidDeptLOV",
					search : searchString //$("txtOucId").value
				},
				title : "List of Departments",
				width : 380,
				height : 390,
				autoSelectOneRecord : true,
				filterText : searchString, //$("txtOucId").value,
				columnModel : [ 
				    {
						id : "oucId",
						title : "Department",
						width : '100px'
					}, 
					{
						id : "oucName",
						title : "Name",
						width : '250px'
					}
				],
				draggable : true,
				onSelect : function(row) {
					$("txtOucId").value = row.oucId;
					$("txtOucName").value = unescapeHTML2(row.oucName);
					if ($F("txtFundCd") != "" && $F("txtBranchCd") != "" && $F("txtOucId") != "" && $F("txtFromDate") != "" && $F("txtToDate") != "") {
						enableToolbarButton("btnToolbarExecuteQuery");
					}else {
						enableToolbarButton("btnToolbarEnterQuery");
					}
					$("txtOucId").setAttribute("lastValidValue", row.oucId);
				},
				onCancel: function(){
					$("txtOucId").focus();
					$("txtOucId").value = $("txtOucId").readAttribute("lastValidValue");
				},
				onUndefinedRow : function() {
					showMessageBox("No record selected.", imgMessage.INFO);
				}
			});
		} catch (e) {
			showErrorMessage("Ouc LOV", e);
		}
	}
	
		
	function populateDetail(row){
		try{
			$("txtPayeeCd").value		= row == null ? "" : unescapeHTML2(row.classDesc);
			$("txtPayeeName").value		= row == null ? "" : unescapeHTML2(row.payeeName);
			$("txtParticulars").value 	= row == null ? "" : unescapeHTML2(row.particulars);
			$("txtBank").value			= row == null ? "" : unescapeHTML2(row.bankName);
			$("txtAccountNo").value	    = row == null ? "" : row.bankAcctNo;
			$("txtUserId").value 		= row == null ? "" : row.userId;
			$("txtLastUpdate").value 	= row == null ? "" : row.lastUpdate;
		} catch(e){
			showErrorMessage("populateDetails", e);
		}
	}
	
	function checkFields() {
		var check = false;
		if ($F("txtFundCd") != "" && $F("txtBranchCd") != "" && $F("txtOucId") != "" && $F("txtFromDate") != "" && $F("txtToDate") != "") {
			check = true;
		}else if ($F("txtFundCd") == "" || $F("txtBranchCd") == "" || $F("txtOucId") == "" || $F("txtFromDate") == "" || $F("txtToDate") == "") {
			showMessageBox(objCommonMessage.REQUIRED, "I");
		}
		return check;
	}
	
	function executeQueryMode(mode) {
		if (mode == On) {
			disableInputField("txtFundCd");
			disableInputField("txtBranchCd");
			disableInputField("txtOucId");
			disableSearch("imgFundCdLOV");
			disableSearch("imgBranchCdLOV");
			disableSearch("imgOucIdLOV");
			disableDate("hrefFromDate");
			disableDate("hrefToDate");
			enableButton("btnPrint");
			enableToolbarButton("btnToolbarPrint");
			disableToolbarButton("btnToolbarExecuteQuery");
			enableToolbarButton("btnToolbarEnterQuery");
			tbgChecksPaidPerDept.url = contextPath+"/GIACInquiryController?action=showChecksPaidPerDepartment&refresh=1&fundCd="+$F("txtFundCd")+"&branchCd="+$F("txtBranchCd")
												  +"&oucId="+$F("txtOucId")+"&fromDate="+$F("txtFromDate")+"&toDate="+$F("txtToDate");
			tbgChecksPaidPerDept._refreshList();
			if (tbgChecksPaidPerDept.geniisysRows.length == 0) {
				customShowMessageBox("Query caused no records to be retrieved. Re-enter.", imgMessage.INFO, "txtFundCd");
				disableButton("btnPrint");
				disableToolbarButton("btnToolbarPrint");
			}
		}else {
			enableInputField("txtFundCd");
			enableInputField("txtBranchCd");
			enableInputField("txtOucId");
			enableSearch("imgFundCdLOV");
			enableSearch("imgBranchCdLOV");
			enableSearch("imgOucIdLOV");
			enableDate("hrefFromDate");
			enableDate("hrefToDate");
			disableButton("btnPrint");
			disableToolbarButton("btnToolbarPrint");
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
			tbgChecksPaidPerDept.url = contextPath+"/GIACInquiryController?action=showChecksPaidPerDepartment&refresh=1";
			tbgChecksPaidPerDept._refreshList();
			populateDetail(null);
			$$("div#headerFormDiv input[type='text']").each(function(field) {
				$(field).value = "";
				if ($(field).hasClassName("required"))$(field).setAttribute("lastValidValue", "");
			});
			$("txtFundCd").focus();
		}
	}

	function checkLov(action, cd, desc, func) {
		if ($(cd).value != "") {
			var output = validateTextFieldLOV("/AccountingLOVController?action=" + action + "&search=" + $(cd).value + "&fundCd=" + $("txtFundCd").value, $(cd).value, "Searching, please wait...");
			if (output == 2) {
				func();
			} else if (output == 0) {
				$(cd).clear();
				customShowMessageBox($(cd).getAttribute("name") + " does not exist.", "I", cd);
			} else {
				func();
			}
		}else {
			$(desc).clear();
		}
	}
	
	function checkAllDates() {
		check = true;
		$$("input[type='text'].date").each(function(m) {
			if (m.value == "") {
				check = false;
				customShowMessageBox("Please enter " + m.name, "I", m.id);
				return false;
			}
		});
		return check;
	}

	function printReport(){
		try {
			var content = contextPath + "/GeneralDisbursementPrintController?action=printGIACR241"
							+"&reportId=GIACR241&oucId="+$F("txtOucId")
							+"&beginDate="+$F("txtFromDate")
							+"&endDate="+$F("txtToDate");
			
			if("screen" == $F("selDestination")){
				showPdfReport(content, "View Checks Paid per Department");
			}else if($F("selDestination") == "printer"){
				new Ajax.Request(content, {
					parameters : {noOfCopies : $F("txtNoOfCopies"),
						  	      printerName : $F("selPrinter")},
					onCreate: showNotice("Processing, please wait..."),				
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							
						}
					}
				});
			}else if("file" == $F("selDestination")){
				new Ajax.Request(content, {
					parameters : {destination : "file",
								  fileType : $("rdoPdf").checked ? "PDF" : "XLS"},
					onCreate: showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							copyFileToLocal(response);
						}
					}
				});
			}else if("local" == $F("selDestination")){
				new Ajax.Request(content, {
					parameters : {destination : "local"},
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							var message = printToLocalPrinter(response.responseText);
							if(message != "SUCCESS"){
								showMessageBox(message, imgMessage.ERROR);
							}
						}
					}
				});
			}
		} catch (e){
			showErrorMessage("printReport", e);
		}
	}
	
	//textfield events
	$("txtFundCd").observe("change", function() {
		//checkLov("getFundChecksPaidDeptLOV", "txtFundCd", "txtFundDesc", showFundLOV);
		if (this.value != ""){
			showFundLOV(false);
		}
		if ($F("txtFundCd") == ""&& $F("txtBranchCd") == "" && $F("txtOucId") == "" && $F("txtFromDate") == "" && $F("txtToDate") == "") {
			disableToolbarButton("btnToolbarEnterQuery");
		}
		if (this.value == ""){
			this.setAttribute("lastValidValue", "");
		}
	});
	
	$("txtBranchCd").observe("change", function() {
		//checkLov("getBranchChecksPaidDeptLOV", "txtBranchCd", "txtBranchName", showBranchLOV);
		if (this.value != ""){
			showBranchLOV(false);
		}
		if ($F("txtFundCd") == ""&& $F("txtBranchCd") == "" && $F("txtOucId") == "" && $F("txtFromDate") == "" && $F("txtToDate") == "") {
			disableToolbarButton("btnToolbarEnterQuery");
		}
		if (this.value == ""){
			this.setAttribute("lastValidValue", "");
		}
	});
	
	$("txtOucId").observe("change", function() {
		//checkLov("getOucChecksPaidDeptLOV", "txtOucId", "txtOucName", showOucLOV);
		if (this.value != ""){
			showOucLOV(false);
		}
		if ($F("txtFundCd") == ""&& $F("txtBranchCd") == "" && $F("txtOucId") == "" && $F("txtFromDate") == "" && $F("txtToDate") == "") {
			disableToolbarButton("btnToolbarEnterQuery");
		}
		if (this.value == ""){
			this.setAttribute("lastValidValue", "");
		}
	});
	
	$("txtFromDate").observe("focus", function(){
		if ($("hrefFromDate").disabled == true) return;
		var toDate = $F("txtToDate") != "" ? new Date($F("txtToDate").replace(/-/g,"/")) :"";
		var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g,"/")) : "";
		if (fromDate > toDate && toDate != ""){
			customShowMessageBox("From Date should not be later than To Date.", "I", "txtFromDate");
			$("txtFromDate").clear();
			return false;
		}
		if ($F("txtFundCd") != "" && $F("txtBranchCd") != "" && $F("txtOucId") != "" && $F("txtFromDate") != "" && $F("txtToDate") != ""
				&& $("hrefFromDate").style.display == "") {	// added by shan : 10.22.2014
			check = true;
			enableToolbarButton("btnToolbarExecuteQuery");
		}else {
			enableToolbarButton("btnToolbarEnterQuery");
		}
		if ($F("txtFundCd") == ""&& $F("txtBranchCd") == "" && $F("txtOucId") == "" && $F("txtFromDate") == "" && $F("txtToDate") == "") {
			disableToolbarButton("btnToolbarEnterQuery");
		}
	});
	
	$("txtToDate").observe("focus", function(){
		if ($("hrefToDate").disabled == true) return;
		var toDate = $F("txtToDate") != "" ? new Date($F("txtToDate").replace(/-/g,"/")) :"";
		var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g,"/")) :"";
		if (toDate < fromDate && toDate != ""){
			customShowMessageBox("From Date should not be later than To Date.", "I", "txtToDate");
			$("txtToDate").clear();
			return false;
		}
		if ($F("txtFundCd") != "" && $F("txtBranchCd") != "" && $F("txtOucId") != "" && $F("txtFromDate") != "" && $F("txtToDate") != ""
				&& $("hrefToDate").style.display == "") {	// added by shan : 10.22.2014
			enableToolbarButton("btnToolbarExecuteQuery");
		}else {
			enableToolbarButton("btnToolbarEnterQuery");
		}
		if ($F("txtFundCd") == ""&& $F("txtBranchCd") == "" && $F("txtOucId") == "" && $F("txtFromDate") == "" && $F("txtToDate") == "") {
			disableToolbarButton("btnToolbarEnterQuery");
		}
	});
	
	$("viewParticulars").observe("click", function() {
		showOverlayEditor("txtParticulars", 2000, $("txtParticulars").hasAttribute("readonly"), "");
	});
	
	//LOV
	$("imgFundCdLOV").observe("click", showFundLOV);
		
	$("imgBranchCdLOV").observe("click", showBranchLOV);
	
	$("imgOucIdLOV").observe("click", showOucLOV);
	
	//date
	$("hrefFromDate").observe("click", function() {
		if ($("hrefFromDate").disabled == true) return;
		scwShow($('txtFromDate'),this, null);
	});
	
	$("hrefToDate").observe("click", function() {
		if($("hrefToDate").disabled == true) return;
		scwShow($('txtToDate'),this, null);
	});

	//toolbar
	$("btnToolbarEnterQuery").observe("click", function() {
		executeQueryMode("Off");
	});
		
	
	$("btnToolbarExecuteQuery").observe("click", function() {
		if (checkFields()) {
			executeQueryMode(On);
		}
	});

	
	$("btnToolbarExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");
	});
		
	//buttons
	$("btnToolbarPrint").observe("click", function(){
		showGenericPrintDialog("Print View Checks Paid per Department", printReport, "", true);
	});
	
	$("btnPrint").observe("click", function(){
		showGenericPrintDialog("Print View Checks Paid per Department", printReport, "", true);
	});	
	
	observeReloadForm("reloadChecksPaidPerDept", showChecksPaidPerDepartment);

</script>