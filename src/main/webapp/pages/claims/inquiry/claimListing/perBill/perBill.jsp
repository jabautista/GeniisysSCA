<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="perBillMainDiv" name="perBillMainDiv" style="float: left; margin-bottom: 50px;">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv">	
		<div id="innerDiv" name="innerDiv">
	   		<label>Claim Listing per Bill</label>
	   	</div>
	</div>	
	<div class="sectionDiv" style="height: 150px;">
		<div style="margin: 5px; margin-left: 10px; width: 550px; float: left; height: 135px;">
			<table id="primaryFields" border="0" style="margin-left: 30px; margin-top:15px; float: left;">
				<tr>
					<td class="rightAligned"><span style="width:80px; text-align: right;">Payee</span></td>
					<td>
						<input type="text" class="required" id="txtPayeeNo" name="txtPayeeNo" tabindex="101" style="float:left;  border:1px solid gray; height: 14px; margin:0; width:50px; text-align: right;"/>
						<input type="hidden" id="hidPayeeNo" name="hidPayeeNo" value=""/>	
					</td>
					<td colspan="3" class="primeInput" style="border: 1px solid gray;" class="required" >
						<input type="text" class="required" id="txtPayeeName" name="txtPayeeName" readonly="readonly" tabindex="102" ignoreDelKey="1" style="float: left; height: 14px; margin: 0; border:none; width:350px;">
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchPayee" name="imgSearchPayee" alt="Go" style="float: right;" tabindex="103"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned"><span style="text-align: right;">Payee Class</span></td>
					<td>
						<input type="text" id="txtPayeeClassNo" class="required" name="txtPayeeClassNo" tabindex="104" style="float:left; height: 14px; margin:0; border:1px solid gray; width:50px; text-align: right;"/>
						<input type="hidden" id="hidPayeeClassNo" name="hidPayeeClassNo" value=""/>	
					</td>
					<td colspan="3" class="primeInput" class="required" style="border: 1px solid gray; background-color: cornsilk;">
						<input id="txtPayeeClass" class="required" type="text" ignoreDelKey="1" style="float: left; height: 14px; margin: 0; border:none; width:350px;" tabindex="105" name="txtPayeeClass" readonly="readonly">
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchPayeeClass" name="imgSearchPayeeClass" alt="Go" style="float: right;" tabindex="106"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned"><span style="text-align: right;">Doc Type</span></td>
					<td>
						<input type="text" id="txtDocTypeNo" name="txtDocTypeNo" readonly="readonly" tabindex="107" style="float:left; height: 14px; margin:0; border:1px solid gray; width:50px; text-align: right;"/>
					</td>
					<td>
						<input type="text" id="txtDocType" name="txtDocType" readonly="readonly" tabindex="108" style="float:left; height: 14px; margin:0; border:1px solid gray;"/>
					</td>
					<td class="rightAligned"><span style="text-align: right;">Doc Number</span></td>
					<td>
						<input type="text" id="txtDocNumber" class="required" readonly="readonly" name="txtDocNumber" tabindex="109" style="float:left; height: 14px; margin:0; border:1px solid gray;"/>
						<input type="hidden" id="hidDocNumber" name="hidDocNumber" value=""/>	
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchDocNumber" name="imgSearchDocNumber" alt="Go" style="float: right;" tabindex="106"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned"><span>Bill Amount</span></td>
					<td colspan="2">
						<input type="text" id="txtBillAmt" ignoreDelKey="1" readonly="readonly" name="txtBillAmt" tabindex="110" style="float:left; height: 14px; width:191px; text-align: right; margin:0; border:1px solid gray; text-align: right;"/>
					</td>
					<td class="rightAligned"><span>Bill Date</span></td>
					<td>
						<input type="text" id="txtBillDate" name="txtBillDate" ignoreDelKey="1" readonly="readonly" tabindex="111" style="float:left; height: 14px; margin:0; border:1px solid gray;"/>
					</td>
				</tr>
			</table>
		</div>
		<div>
			<fieldset style="height: 92px; width: 300px; float: right; margin-right: 30px; margin-top: 16px;">
				<legend>Search By</legend>
				<table style="width: 120px; float: left;">
					<tr>
						<td class="rightAligned">
							<input type="radio" name="searchBy" id="rdoClaimFileDate" style="float: left; margin: 3px 2px 3px 3px;" tabindex="112"/>
							<label for="rdoClaimFileDate" style="float: left; height: 20px; padding-top: 3px;" title="Claim File Date">Claim File Date</label>
						</td>
					</tr><tr>
						<td class="rightAligned">
							<input type="radio" name="searchBy" id="rdoLossDate" style="float: left; margin: 3px 2px 3px 3px;" tabindex="113"/>
							<label for="rdoLossDate" style="float: left; height: 20px; padding-top: 3px;" title="Loss Date">Loss Date</label>
						</td>
					</tr>
				</table>
				<table style="width: 180px; float: right;">
					<tr>
						<td class="rightAligned"><input type="radio" name="byDate" id="rdoAsOf" title="As of" style="float: left;" tabindex="114"/><label for="rdoAsOf" title="As of" style="float: left; height: 20px; padding-top: 3px;">As of</label></td>
						<td class="leftAligned">
						<div style="float: left; width: 100px;" class="withIconDiv">
							<input type="text" id="txtAsOfDate" name="txtAsOfDate" class="withIcon" readonly="readonly" style="width: 75px;" tabindex="115"/>
							<img id="hrefAsOfDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="As of Date" tabindex="116"/>
						</div>
					</td>
					</tr><tr>
						<td class="rightAligned"><input type="radio" name="byDate" id="rdoFrom" title="From" style="float: left;" tabindex="117"/><label for="rdoFrom" style="float: left; height: 20px; padding-top: 3px;">From</label></td>
						<td class="leftAligned">
						<div style="float: left; width: 100px;" class="withIconDiv">
							<input type="text" id="txtFromDate" name="txtFromDate" class="withIcon" readonly="readonly" style="width: 75px;" tabindex="118"/>
							<img id="hrefFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="From Date" tabindex="119"/>
						</div>
						</td>
					</tr><tr>
						<td class="rightAligned"><label for="rdoFrom" style="float: left; height: 20px; padding-top: 3px; margin-left: 35px;">To</label></td>
						<td class="leftAligned">
						<div style="float: left; width: 100px;" class="withIconDiv">
							<input type="text" id="txtToDate" name="txtToDate" class="withIcon" readonly="readonly" style="width: 75px;" tabindex="120"/>
							<img id="hrefToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="To Date" tabindex="121"/>
						</div>
						</td>
					</tr>
				</table>
			</fieldset>
		</div>
	</div>
	<div class="sectionDiv">
		<div id="perBillTableDiv" style="padding: 10px 0 0 10px;">
			<div id="perBillTable" style="height: 340px"></div>
		</div>
		<div class="sectionDiv" style="margin: 10px; float: left; width: 97.5%;">
			<table style="margin: 5px; float: left;">
				<tr>
					<td class="rightAligned">Claim No</td>
					<td class="leftAligned"><input type="text" id="txtClaimNo" style="width: 400px;" readonly="readonly" tabindex="301"/></td>
					<td class="rightAligned" style="width: 110px;">Assured Name</td>
					<td class="leftAligned"><input type="text" id="txtAssured" style="width: 250px;" readonly="readonly" tabindex="304"/></td>
				</tr>
				<tr>
					<td class="rightAligned">Policy No</td>
					<td class="leftAligned"><input type="text" id="txtPolicyNo" style="width: 400px;" readonly="readonly" tabindex="302"/></td>
					<td class="rightAligned">Loss Date</td>
					<td class="leftAligned"><input type="text" id="txtLossDate" style="width: 250px;" readonly="readonly" tabindex="305"/></td>
				</tr>
				<tr>
					<td class="rightAligned" >Claim Status</td>
					<td class="leftAligned"><input type="text" id="txtClaimStatus" style="width: 400px;" readonly="readonly" tabindex="303"/></td>
					<td class="rightAligned">Claim File Date</td>
					<td class="leftAligned"><input type="text" id="txtClaimFileDate" style="width: 250px;" readonly="readonly" tabindex="306"/></td>
				</tr>
				<tr>
					<input type="hidden" id="hidSearchBy" name="hidSearchBy" value=""/>				
				</tr>			
			</table>
		</div>
		<div style="float: left; width: 100%; margin-bottom: 10px;" align="center">
		</div>
	</div>
</div>
<script type="text/javascript">
	initializeAll();
	setModuleId("GICLS272");
	setDocumentTitle("Claim Listing Per Bill");
	filterOn = false;
	
	//perBill Table
	var jsonClmListPerBill = JSON.parse('${jsonClmListPerBill}');	
	perBillTableModel = {
			url : contextPath+"/GICLClaimListingInquiryController?action=showClaimListingPerBill&refresh=1",
			options: {
				toolbar: {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter : function(){
						setDetailsForm(null);
						tbgClaimsPerBill.keys.removeFocus(tbgClaimsPerBill.keys._nCurrentFocus, true);
						tbgClaimsPerBill.keys.releaseKeys();
						filterOn = true;
					}
				},
				width: '900px',
				pager: {
				},
				onCellFocus : function(element, value, x, y, id) {
					setDetailsForm(tbgClaimsPerBill.geniisysRows[y]);					
					tbgClaimsPerBill.keys.removeFocus(tbgClaimsPerBill.keys._nCurrentFocus, true);
					tbgClaimsPerBill.keys.releaseKeys();
				},
				prePager: function(){
					setDetailsForm(null);
					tbgClaimsPerBill.keys.removeFocus(tbgClaimsPerBill.keys._nCurrentFocus, true);
					tbgClaimsPerBill.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id){					
					setDetailsForm(null);
				},
				onSort : function(){
					setDetailsForm(null);
					tbgClaimsPerBill.keys.removeFocus(tbgClaimsPerBill.keys._nCurrentFocus, true);
					tbgClaimsPerBill.keys.releaseKeys();	
				},
				onRefresh : function(){
					setDetailsForm(null);
					tbgClaimsPerBill.keys.removeFocus(tbgClaimsPerBill.keys._nCurrentFocus, true);
					tbgClaimsPerBill.keys.releaseKeys();
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
					id : "itemTitle",
					title: "Item",
					width: '180px',
					filterOption : true,
					align : "left",
					titleAlign : "left"
				},				
				{
					id : "perilName",
					title: "Peril",
					width: '220px',
					filterOption : true,
					align : "left",
					titleAlign : "left"
				},
				{
					id : "leStatDesc",
					title: "Status",
					width: '140px',
					filterOption : true,
				},
				{
					id : "paidAmt", 
					title: "Loss Paid Amt",
					width: '114px',
					filterOption : true,
					align : "right",
					titleAlign : "right",
					filterOptionType: 'number',
					geniisysClass: 'money'
				},
				{
					id : "netAmt",
					title: "Loss Net Amt",
					width: '114px',
					filterOption : true,
					align : "right",
					titleAlign : "right",
					filterOptionType: 'number',
					geniisysClass: 'money'
				},
				{
					id : "adviseAmt",
					title: "Loss Advise Amt",
					width: '114px',
					filterOption : true,
					titleAlign : "right",
					align : 'right',
					filterOptionType: 'number',
					geniisysClass: 'money'
				}
			],
			rows: [] //jsonClmListPerBill.rows
		};
	
	tbgClaimsPerBill = new MyTableGrid(perBillTableModel);
	//tbgClaimsPerBill.pager = jsonClmListPerBill;
	tbgClaimsPerBill.render('perBillTable');
	
	function setDetailsForm(rec){
		try{
			$("txtClaimNo").value 		= rec == null ? "" : unescapeHTML2(rec.claimNo);
			$("txtAssured").value		= rec == null ? "" : unescapeHTML2(rec.assdName);
			$("txtPolicyNo").value		= rec == null ? "" : (rec.policyNo);
			$("txtLossDate").value		= rec == null ? "" : dateFormat(rec.lossDate, "mm-dd-yyyy");
			$("txtClaimStatus").value	= rec == null ? "" : unescapeHTML2(rec.clmStatDesc);
			$("txtClaimFileDate").value = rec == null ? "" : dateFormat(rec.clmFileDate, "mm-dd-yyyy");
		} catch(e){	
			showErrorMessage("setDetailsForm", e);
		}
	}
	
	function setFieldOnSearch() {
		validateDate();
		if (validateDate()) {
			toggleDateFields();
			toggleSearchBy();
			setTbgParametersPerDate();
			disableInputField("txtPayeeNo");
			disableInputField("txtPayeeName");
			disableInputField("txtPayeeClassNo");
			disableInputField("txtPayeeClass");
			disableInputField("txtDocTypeNo");
			disableInputField("txtDocType");
			disableInputField("txtDocNumber");
			disableInputField("txtBillAmt");
			disableInputField("txtBillDate");
			disableToolbarButton("btnToolbarExecuteQuery");
	 		if (tbgClaimsPerBill.geniisysRows.length == 0) {
				customShowMessageBox("Query caused no records to be retrieved. Re-enter.", imgMessage.INFO, "txtPayeeName");
				executeQuery = false;
			}
		}
	}
	
	function resetHeaderForm(){
		try{
			if($F("txtPayeeNo") != "" || $F("txtPayeeName") != "" || $F("txtPayeeClassNo") != ""  || $F("txtPayeeClass") != "" || $F("txtDocNumber") != "" || $F("txtDocTypeNo") != "" || $F("txtDocType") != "" || $F("txtBillAmt") != "" || $F("txtBillDate") != ""){
				$("txtPayeeNo").value = "";
				$("hidPayeeNo").value = "";
				$("txtPayeeName").value = "";
				$("txtPayeeClassNo").value = "";
				$("hidPayeeClassNo").value = "";
				$("txtPayeeClass").value = "";
				$("txtDocTypeNo").value = "";
				$("txtDocType").value = "";
				$("txtDocNumber").value = "";
				$("hidDocNumber").value = "";
				$("txtBillAmt").value = "";
				$("txtBillDate").value = "";
				enableInputField("txtPayeeNo");
				enableInputField("txtPayeeName");
				enableInputField("txtPayeeClassNo");
				enableInputField("txtPayeeClass");
				enableInputField("txtDocTypeNo");
				//enableInputField("txtDocType");
				enableInputField("txtDocNumber");
				enableInputField("txtBillAmt");
				enableInputField("txtBillDate");
				setClaimListingPerBill();
				tbgClaimsPerBill.url = contextPath+"/GICLClaimListingInquiryController?action=showClaimListingPerBill&refresh=1&payeeNo="+$F("hidPayeeNo")+"&payeeClassNo="+$F("hidPayeeClassNo")+"&docNumber="+$F("hidDocNumber");
				tbgClaimsPerBill._refreshList();
				$("txtPayeeName").focus();
				executeQuery = false;
			}
		} catch(e){
			showErrorMessage("resetHeaderForm", e);
		}
	}
	
	function toggleSearchBy() {
		if ($("rdoClaimFileDate").checked == true) {
			$("hidSearchBy").value = "claimFileDate";
		}else {
			$("hidSearchBy").value = "lossDate";
		}
	} 
	
	function setTbgParametersPerDate() {
		if ($("rdoAsOf").checked == true) {
			tbgClaimsPerBill.url = contextPath +"/GICLClaimListingInquiryController?action=showClaimListingPerBill&refresh=1&searchBy="+ $F("hidSearchBy")+"&asOfDate="+$F("txtAsOfDate")+"&payeeNo="+$F("hidPayeeNo")+"&payeeClassNo="+$F("hidPayeeClassNo")+"&docNumber="+$F("hidDocNumber");
			tbgClaimsPerBill._refreshList();
		}
		
		if ($("rdoFrom").checked == true) {
			tbgClaimsPerBill.url = contextPath +"/GICLClaimListingInquiryController?action=showClaimListingPerBill&refresh=1&searchBy="+ $F("hidSearchBy") +"&fromDate="+$F("txtFromDate")+"&toDate="+$F("txtToDate")+"&payeeNo="+$F("hidPayeeNo")+"&payeeClassNo="+$F("hidPayeeClassNo")+"&docNumber="+$F("hidDocNumber");
			tbgClaimsPerBill._refreshList();
		}
	}
	 	
	//Toggling of Date Fields, Calendar, Print button
	function toggleDateFields() {
		if ($("rdoAsOf").checked == true) {
			disableDate("hrefAsOfDate");
			$("rdoAsOf").disabled 		= true;
			$("rdoFrom").disabled 		= true;
			$("txtAsOfDate").disabled 	= true;
		} else if ($("rdoFrom").checked == true) {
			disableDate("hrefFromDate");
			disableDate("hrefToDate");
			$("rdoFrom").disabled 		= true;
			$("rdoAsOf").disabled 		= true;
			$("txtFromDate").disabled 	= true;
			$("txtToDate").disabled 	= true;
		}
	}
	
	function toggleCalendar(enable){
		if (nvl(enable,false) == true){
			$("txtAsOfDate").value 		= "";
			$("txtAsOfDate").disabled 	= true;
			$("txtFromDate").disabled 	= false;
			$("txtToDate").disabled 	= false;
			disableDate("hrefAsOfDate");
			enableDate("hrefFromDate");
			enableDate("hrefToDate");
		}else{	
			$("txtAsOfDate").value 		= getCurrentDate();
			$("txtFromDate").value 		= "";
			$("txtToDate").value 		= "";
			$("txtAsOfDate").disabled 	= false;
			$("txtFromDate").disabled 	= true;
			$("txtToDate").disabled 	= true;
			enableDate("hrefAsOfDate");
			disableDate("hrefFromDate");
			disableDate("hrefToDate");
		}
	}
	
	//default setting
	function setClaimListingPerBill() {
		$("rdoClaimFileDate").checked 	= true;
		$("rdoAsOf").checked 			= true;
		$("rdoFrom").disabled 			= false;
		$("rdoAsOf").disabled 			= false;
		enableDate("hrefAsOfDate");
		enableDate("hrefFromDate");
		enableDate("hrefToDate");
		enableSearch("imgSearchPayee");
		enableSearch("imgSearchPayeeClass");
		enableSearch("imgSearchDocNumber");
		disableToolbarButton("btnToolbarPrint");
		disableToolbarButton("btnToolbarExecuteQuery");
		disableToolbarButton("btnToolbarEnterQuery");
		toggleCalendar(false);
	}
	
	//Date Validation
	function validateDate() {
		if ($("rdoFrom").checked == true) {
			if ($("txtFromDate").value == "") {
				customShowMessageBox("Required fields must be entered.", imgMessage.INFO, "txtFromDate");
				enableToolbarButton("btnToolbarExecuteQuery");
				executeQuery = false;
				return false;
			}
			if ($("txtToDate").value == "") {
				customShowMessageBox("Required fields must be entered.", imgMessage.INFO, "txtToDate");
				enableToolbarButton("btnToolbarExecuteQuery");
				executeQuery = false;
				return false;
			}
		}
		return true; 
	}
	
	//Payees LOV
	function showGICLS272PayeeLOV(payeeNo, payeeName){
		try{
			LOV.show({
				controller: "ClaimsLOVController",
				urlParameters: {action : "getClaimsBillPayeeNamesLOV",
								page : 1,
								payeeClassNo : $("hidPayeeClassNo").value,
								docNumber : $("hidDocNumber").value,
								payeeNo : payeeNo,
								payeeName : payeeName
				},
				title: "List of Payees",
				width: 403,
				height: 386,
				columnModel:[	
				             	{	id : "payeeNo",
									title: "Payee no.",
									width: '70px',
									type: 'number'
								},
								{	id : "payeeName",
									title: "Payee Name",
									width: '318px'
								} 
							],
				draggable: true,
				autoSelectOneRecord: true,
				onSelect : function(row){
					$("txtPayeeNo").value = unescapeHTML2(row.payeeNo);
					$("hidPayeeNo").value = unescapeHTML2(row.payeeNo);
					$("txtPayeeName").value = unescapeHTML2(row.payeeName);
					enableToolbarButton("btnToolbarEnterQuery");
					if($("hidPayeeClassNo").value == ""){
						showGICLS272PayeeClassLOV($("txtPayeeClassNo").value,$("txtPayeeClass").value);
					}
				},
				onShow: function(){$(this.id + "_txtLOVFindText").focus();}
			});
		}catch(e){
			showErrorMessage("showGICLS272PayeeLOV",e);
		}
	}
	
	//Payees Class LOV
	function showGICLS272PayeeClassLOV(payeeClassNo, payeeClass){
		try{
			LOV.show({
				controller: "ClaimsLOVController",
				urlParameters: {action : "getClaimsBillPayeeClassLOV",
								page : 1,
								payeeNo : $("hidPayeeNo").value,
								docNumber : $("hidDocNumber").value,
								payeeClassNo : payeeClassNo,
								payeeClass : payeeClass
				},
				title: "List of Payee Classes",
				width: 403,
				height: 386,
				columnModel:[	
				             	{	id : "payeeClassCd",
									title: "Class Code",
									width: '70px',
									type: 'number'
								},
								{	id : "payeeClass",
									title: "Class Name",
									width: '318px'
								} 
							],
				draggable: true,
				autoSelectOneRecord: true,
				onSelect : function(row){
					$("txtPayeeClassNo").value = unescapeHTML2(row.payeeClassCd);
					$("hidPayeeClassNo").value = unescapeHTML2(row.payeeClassCd);
					$("txtPayeeClass").value = unescapeHTML2(row.payeeClass);
					enableToolbarButton("btnToolbarEnterQuery");
					if($("hidPayeeNo").value == ""){
						showGICLS272PayeeLOV($("txtPayeeNo").value,$("txtPayeeName").value);
					} 
				},
				onShow: function(){$(this.id + "_txtLOVFindText").focus();}
			});
		}catch(e){
			showErrorMessage("showGICLS272PayeeClassLOV",e);
		}
	}
	
	//Doc Number LOV
	function showGICLS272DocNumberLOV(docTypeNo, docType, docNumber, billAmt, billDate){
		try{
			LOV.show({
				controller: "ClaimsLOVController",
				urlParameters: {action : "getClaimsBillDocNumberLOV",
								page : 1,
								payeeNo : $("hidPayeeNo").value,
								payeeClassNo : $("hidPayeeClassNo").value,
								docTypeNo : docTypeNo,
								docType : docType,
								docNumber : docNumber,
								billAmt : billAmt,
								billDate : billDate
				},
				title: "List of Document Number",
				width: 530,
				height: 386,
				columnModel:[	
				             	{	id : "docNumber",
									title: "Document Number",
									width: '120px',
								},
								{	id : "amount",
									title: "Amount",
									width: '90px',
								},
								{	id : "billDate",
									title: "Bill Date",
									width: '90px',
									renderer : function(value) {
								    	return formatDateToDefaultMask(value);
								    } 
								},
								{	id : "docType",
									title: "Document Type",
									width: '100px',
								},
								{	id : "rvMeaning",
									title: "Document",
									width: '90px',
								}
								
							],
				draggable: true,
				autoSelectOneRecord: true,
				onSelect : function(row){
					$("txtDocTypeNo").value = unescapeHTML2(row.docType);
					$("txtDocType").value = unescapeHTML2(row.rvMeaning);
					$("txtDocNumber").value = unescapeHTML2(row.docNumber);
					$("txtBillAmt").value = unescapeHTML2(formatCurrency(row.amount));
					$("txtBillDate").value = row.billDate == null ? "" : unescapeHTML2(dateFormat(row.billDate, "mm-dd-yyyy"));
					$("hidDocNumber").value = unescapeHTML2(row.docNumber);
					enableToolbarButton("btnToolbarExecuteQuery");
					enableToolbarButton("btnToolbarEnterQuery");
				},
				onShow: function(){$(this.id + "_txtLOVFindText").focus();}
			});
		}catch(e){
			showErrorMessage("showGICLS272DocNumberLOV",e);
		}
	}
	
	function execute() {
		tbgClaimsPerBill.url = contextPath +"/GICLClaimListingInquiryController?action=showClaimListingPerBill&refresh=1&searchBy="+ $F("hidSearchBy") +"&fromDate="+$F("txtFromDate")+"&toDate="+$F("txtToDate") +"&payeeNo="+$F("hidPayeeNo")+"&payeeClassNo="+$F("hidPayeeClassNo")+"&docNumber="+$F("hidDocNumber");
		setFieldOnSearch();	
		//disableToolbarButton("btnToolbarExecuteQuery");
	};
	
	function validatePayee() {
		new Ajax.Request(contextPath + "/GICLClaimListingInquiryController", {
			method: "POST",
			parameters: {
				action : "validatePayees",
				payeeNo : $("txtPayeeNo").value,
				payeeName : $("txtPayeeName").value
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				if (response.responseText == 0) {
					$("txtPayeeNo").value = "";
					$("txtPayeeName").value = "";
					customShowMessageBox("There is no record of this Payee", imgMessage.INFO, "txtPayeeName");
				} else if(response.responseText == 1) {
					showGICLS272PayeeLOV($("txtPayeeNo").value,$("txtPayeeName").value);
					enableToolbarButton("btnToolbarEnterQuery");
					/* if ($("txtPayeeNo").value != "" || $("txtPayeeName").value != "") {
						enableToolbarButton("btnToolbarExecuteQuery");
					}else {
						disableToolbarButton("btnToolbarExecuteQuery");
					} */
				} else if (response.responseText.include("Sql Exception")) {
					showGICLS272PayeeLOV($("txtPayeeNo").value,$("txtPayeeName").value);
					enableToolbarButton("btnToolbarEnterQuery");
				}
			}
		});			
	}
	
	function validatePayeeClass() {
		new Ajax.Request(contextPath + "/GICLClaimListingInquiryController", {
			method: "POST",
			parameters: {
				action : "validatePayeeClass",
				payeeClassNo : $("txtPayeeClassNo").value,
				payeeClass : $("txtPayeeClass").value
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				if (response.responseText == 0) {
					$("txtPayeeClassNo").value = "";
					$("txtPayeeClass").value = "";
					customShowMessageBox("There is no record of this Payee Class", imgMessage.INFO, "txtPayeeClass");
				} else if(response.responseText == 1) {
					showGICLS272PayeeClassLOV($("txtPayeeClassNo").value,$("txtPayeeClass").value);
					enableToolbarButton("btnToolbarEnterQuery");
					/* if ($("txtPayeeClassNo").value != "" || $("txtPayeeClass").value != "") {
						enableToolbarButton("btnToolbarExecuteQuery");
					}else {
						disableToolbarButton("btnToolbarExecuteQuery");
					} */
				} else if (response.responseText.include("Sql Exception")) {
					showGICLS272PayeeClassLOV($("txtPayeeClassNo").value,$("txtPayeeClass").value);
					enableToolbarButton("btnToolbarEnterQuery");
				}
			}
		});			
	}
	
	function validateDocNumber() {
		new Ajax.Request(contextPath + "/GICLClaimListingInquiryController", {
			method: "POST",
			parameters: {
				action : "validateDocNumber",
				docNumber : $("txtDocNumber").value
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				if (response.responseText == 0) {
					$("txtDocNumber").value = "";
					customShowMessageBox("There is no record of this Document", imgMessage.INFO, "txtDocNumber");
				} else if(response.responseText == 1) {
					showGICLS272DocNumberLOV($("txtDocTypeNo").value,$("txtDocType").value,$("txtDocNumber").value,$("txtBillAmt").value,$("txtBillDate").value);
					enableToolbarButton("btnToolbarEnterQuery");
					if ($("txtDocNumber").value != "") {
						enableToolbarButton("btnToolbarExecuteQuery");
					}else {
						disableToolbarButton("btnToolbarExecuteQuery");
					}
				} else if (response.responseText.include("Sql Exception")) {
					showGICLS272DocNumberLOV($("txtDocTypeNo").value,$("txtDocType").value,$("txtDocNumber").value,$("txtBillAmt").value,$("txtBillDate").value);
					enableToolbarButton("btnToolbarEnterQuery");
				}
			}
		});			
	}
	
	$$("input[name='searchBy']").each(function(btn) {
		btn.observe("click", function() {
			toggleSearchBy(); 
			if ($("txtPayeeNo").value != "" && $("txtPayeeName").value != "" && $("txtPayeeClassNo").value != "" && $("txtPayeeClass").value != "" && executeQuery==true) {
				execute();
			}
		});
	});
	
	observeBackSpaceOnDate("txtAsOfDate");
	observeBackSpaceOnDate("txtFromDate");
	observeBackSpaceOnDate("txtToDate");
	
	//date field validations
	$("txtFromDate").observe("focus", function(){
		if ($("hrefFromDate").disabled == true) return;
		var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g,"/")) : "";
		var sysdate = new Date();
		if (fromDate > sysdate && fromDate != ""){
			customShowMessageBox("Date should not be greater than the current date.", "I", "txtFromDate");
			$("txtFromDate").clear();
			return false;
		}
	});
	
	$("txtToDate").observe("focus", function(){
		if ($("hrefToDate").disabled == true) return;
		var toDate = $F("txtToDate") != "" ? new Date($F("txtToDate").replace(/-/g,"/")) :"";
		var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g,"/")) :"";
		var sysdate = new Date();
		if (toDate > sysdate && toDate != ""){
			customShowMessageBox("Date should not be greater than the current date.", "I", "txtToDate");
			$("txtToDate").clear();
			return false;
		}
		if (toDate < fromDate && toDate != ""){
			customShowMessageBox("TO Date should not be less than the FROM date.", "I", "txtToDate");
			$("txtToDate").clear();
			return false;
		}
	});
	
	$("txtAsOfDate").observe("focus", function(){
		if ($("hrefAsOfDate").disabled == true) return;
		var asOfDate = $F("txtAsOfDate") != "" ? new Date($F("txtAsOfDate").replace(/-/g,"/")) :"";
		var sysdate = new Date();
		if (asOfDate > sysdate && asOfDate != ""){
			customShowMessageBox("Date should not be greater than the current date.", "I", "txtAsOfDate");
			$("txtAsOfDate").clear();
			return false;
		}
	});
	
	//calendar icon setting per radio btn
	$("rdoFrom").observe("click", function() {
		toggleCalendar(true);
	});
	$("rdoAsOf").observe("click", function() {
		toggleCalendar(false);
	});
	
	//date fields calendar
	$("hrefFromDate").observe("click", function() {
		if ($("hrefFromDate").disabled == true) return;
		scwShow($('txtFromDate'),this, null);
	});
	$("hrefToDate").observe("click", function() {
		if($("hrefToDate").disabled == true) return;
		scwShow($('txtToDate'),this, null);
	});
	$("hrefAsOfDate").observe("click", function() {
		if ($("hrefAsOfDate").disabled == true) return;
		scwShow($('txtAsOfDate'),this, null);
	});
	
	$("btnToolbarExit").observe("click", function(){
		document.stopObserving("keyup");
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
	});
	
	//LOV btn
	$("imgSearchPayee").observe("click", function() {
		//showGICLS272PayeeLOV($("txtPayeeNo").value,$("txtPayeeName").value);
		showGICLS272PayeeLOV("","");
	});
	$("imgSearchPayeeClass").observe("click", function() {
		//showPayorClassLOV("GICLS272");
		//showGICLS272PayeeClassLOV($("txtPayeeClassNo").value,$("txtPayeeClass").value);
		temp = $("hidPayeeNo").value;
		$("hidPayeeNo").value = "";
		showGICLS272PayeeClassLOV("","");
	});
	$("imgSearchDocNumber").observe("click", function() {
		if($F("txtPayeeNo").trim()==""){
			customShowMessageBox("Required fields must be entered.", "I", "txtPayeeNo");
		} else {
			if($F("txtPayeeClassNo").trim()==""){
				customShowMessageBox("Required fields must be entered.", "I", "txtPayeeClassNo");
			} else{
				showGICLS272DocNumberLOV("","","","","");
			}
		}
	});

	//toolbar buttons
	$("btnToolbarEnterQuery").observe("click", resetHeaderForm);
	$("btnToolbarExecuteQuery").observe("click", function() {
		if ($("txtPayeeNo").value != "" || $("txtPayeeName").value != "" || $("txtPayeeClassNo").value != "" || $("txtPayeeClass").value != "" || $("txtDocNumber").value != "" ) {
			setFieldOnSearch();	
			executeQuery = true;
			disableSearch("imgSearchPayee");
			disableSearch("imgSearchPayeeClass");
			disableSearch("imgSearchDocNumber");
		}
	});
	
	//field onchange
 	$("txtDocNumber").observe("change", function() {
 		if($F("txtPayeeNo").trim()==""){
			customShowMessageBox("Required fields must be entered.", "I", "txtPayeeNo");
		} else {
			if($F("txtPayeeClassNo").trim()==""){
				customShowMessageBox("Required fields must be entered.", "I", "txtPayeeClassNo");
			} else{
				if ($("txtDocNumber").value != "") {
					enableToolbarButton("btnToolbarExecuteQuery");
					enableToolbarButton("btnToolbarEnterQuery");
				}
				else if ($("txtDocNumber").value == ""){
					disableToolbarButton("btnToolbarExecuteQuery");
					enableToolbarButton("btnToolbarEnterQuery");
				}
			}
		}
	}); 
	
	//field onchange
 	$("txtPayeeNo").observe("change", function() {
		if ($("txtPayeeNo").value != "") {
			validatePayee();
			enableToolbarButton("btnToolbarEnterQuery");
			$("hidPayeeNo").value = "";
		}
		else if ($("txtPayeeNo").value == ""){
			disableToolbarButton("btnToolbarExecuteQuery");
			enableToolbarButton("btnToolbarEnterQuery");
			$("hidPayeeNo").value = "";
			$("txtPayeeName").value == "";
		}
	});
	
	//field onchange
 	$("txtPayeeName").observe("change", function() {
		if ($("txtPayeeName").value != "") {
			validatePayee();
			enableToolbarButton("btnToolbarEnterQuery");
			$("hidPayeeNo").value = "";
		}
		else if ($("txtPayeeName").value == ""){
			disableToolbarButton("btnToolbarExecuteQuery");
			enableToolbarButton("btnToolbarEnterQuery");
			$("hidPayeeNo").value = "";
		}
	});
	
 	//field onchange
 	$("txtPayeeClassNo").observe("change", function() {
		if ($("txtPayeeClassNo").value != "") {
			validatePayeeClass();
			enableToolbarButton("btnToolbarEnterQuery");
			$("hidPayeeClassNo").value = "";
		}
		else if ($("txtPayeeClassNo").value == ""){
			disableToolbarButton("btnToolbarExecuteQuery");
			enableToolbarButton("btnToolbarEnterQuery");
			$("hidPayeeClassNo").value = "";
			$("txtPayeeClass").value == "";
		}
	});
 	
 	//field onchange
 	$("txtPayeeClass").observe("change", function() {
		if ($("txtPayeeClass").value != "") {
			validatePayeeClass();
			enableToolbarButton("btnToolbarEnterQuery");
			$("hidPayeeClassNo").value = "";
		}
		else if ($("txtPayeeClass").value == ""){
			disableToolbarButton("btnToolbarExecuteQuery");
			enableToolbarButton("btnToolbarEnterQuery");
			$("hidPayeeClassNo").value = "";
		}
	});
 	
 	//field onchange
 	$("txtDocNumber").observe("change", function() {
		if ($("txtDocNumber").value != "") {
			validateDocNumber();
			enableToolbarButton("btnToolbarEnterQuery");
			$("hidDocNumber").value = "";
		}
		else if ($("txtDocNumber").value == ""){
			disableToolbarButton("btnToolbarExecuteQuery");
			enableToolbarButton("btnToolbarEnterQuery");
			$("hidDocNumber").value = "";
		}
	});
 	
 	$("txtAsOfDate").observe("blur", function(){
		if($("txtAsOfDate").value == ""){
			$("txtAsOfDate").value = getCurrentDate();
		}
	});

	$("txtPayeeName").focus();
	setClaimListingPerBill();
	initializeAccordion();
</script>