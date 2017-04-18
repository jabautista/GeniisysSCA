<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="perMotorshopMainDiv" name="perMotorshopMainDiv" style="float: left; margin-bottom: 50px;">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Claim Listing per Motorshop</label>
	   	</div>
	</div>	
	<div class="sectionDiv">
		<div style="float: left;">
			<table style="margin: 10px 10px 5px 60px;">
				<tr>
					<td class="rightAligned">Motorshop</td>
					<td class="leftAligned">
						<span class="lovSpan" style="width: 410px; margin-right: 30px;">
							<input type="hidden" id="txtPayeeCdHid" name="txtPayeeCdHid">
							<input type="hidden" id="txtPayeeNoHid" name="txtPayeeNoHid">
							<input type="text" id="txtPayeeName" name="txtPayeeName" style="width: 380px; float: left; border: none; height: 14px; margin: 0;" class="" tabindex="101"/>  
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchPayeeName" name="imgSearchPayeeName" alt="Go" style="float: right;" tabindex="102"/>
						</span>
					</td>
				</tr>
			</table>
			<div style="float: left; margin-left: 134px; margin-bottom: 10px;">
				<fieldset style="width: 386px;">
					<legend>Search By</legend>
					<table>
						<tr>
							<td class="rightAligned">
								<input type="radio" name="searchBy" id="rdoClaimFileDate" style="float: left; margin: 3px 2px 3px 70px;" tabindex="105" />
								<label for="rdoClaimFileDate" style="float: left; height: 20px; padding-top: 3px;" title="Claim File Date">Claim File Date</label>
							</td>
							<td class="rightAligned">
								<input type="radio" name="searchBy" id="rdoLossDate" style="float: left; margin: 3px 2px 3px 50px;" tabindex="106"/>
								<label for="rdoLossDate" style="float: left; height: 20px; padding-top: 3px;" title="Loss Date">Loss Date</label>
							</td>
						</tr>
					</table>
				</fieldset>
			</div>
		</div>
		<div class="sectionDiv" style="float: left; width: 255px; margin: 12px;">
			<table style="margin: 8px;">	
				<tr>
					<td class="rightAligned"><input type="radio" name="byDate" id="rdoAsOf" title="As of" style="float: left;" tabindex="107"/><label for="rdoAsOf" title="As of" style="float: left; height: 20px; padding-top: 3px;">As of</label></td>
					<td class="leftAligned">
						<div style="float: left; width: 165px;" class="withIconDiv">
							<input type="text" id="txtAsOfDate" name="txtAsOfDate" class="withIcon" readonly="readonly" style="width: 140px;" tabindex="108"/>
							<img id="hrefAsOfDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="As of Date" tabindex="109"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned"><input type="radio" name="byDate" id="rdoFrom" title="From" style="float: left;" tabindex="110"/><label for="rdoFrom" style="float: left; height: 20px; padding-top: 3px;">From</label></td>
					<td class="leftAligned">
						<div style="float: left; width: 165px;" class="withIconDiv">
							<input type="text" id="txtFromDate" name="txtFromDate" class="withIcon" readonly="readonly" style="width: 140px;" tabindex="111"/>
							<img id="hrefFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="From Date" tabindex="112"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">To</td>
					<td class="leftAligned">
						<div style="float: left; width: 165px;" class="withIconDiv">
							<input type="text" id="txtToDate" name="txtToDate" class="withIcon" readonly="readonly" style="width: 140px;" tabindex="113"/>
							<img id="hrefToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="To Date" tabindex="114"/>
						</div>
					</td>
				</tr>
			</table>
		</div>	
	</div>
	<div class="sectionDiv">
		<div id="perMotorshopTableDiv" style="padding: 10px 0 0 10px;">
			<div id="perMotorshopTable" style="height: 340px"></div>
		</div>
		<div>
			<table style="margin: 5px; float: right; margin-right: 20px;">
				<tr>
					<td class="rightAligned">Totals</td>
					<td class=""><input type="text" id="txtTotLossResAmt" style="width: 142px; text-align: right;" readonly="readonly" tabindex="201"/></td>
					<td class=""><input type="text" id="txtTotPaidAmt" style="width: 142px; text-align: right;" readonly="readonly" tabindex="202"/></td>
				</tr>
			</table>
		</div>
		<div class="sectionDiv" style="margin: 10px; float: left; width: 97.5%;">
			<table style="margin: 5px; float: left;">
				<tr>
					<td class="rightAligned">Policy No</td>
					<td class="leftAligned"><input type="text" id="txtPolicyNo" style="width: 400px;" readonly="readonly" tabindex="303"/></td>
					<td class="rightAligned">Loss Date</td>
					<td class="leftAligned"><input type="text" id="txtLossDate" style="width: 250px;" readonly="readonly" tabindex="304"/></td>
				</tr>
				<tr>
					<td class="rightAligned">Assured Name</td>
					<td class="leftAligned"><input type="text" id="txtAssured" style="width: 400px;" readonly="readonly" tabindex="305"/></td>	
					<td class="rightAligned">Claim File Date</td>
					<td class="leftAligned"><input type="text" id="txtClaimFileDate" style="width: 250px;" readonly="readonly" tabindex="306"/></td>
				</tr>
				<tr>
					<td class="rightAligned">Loss Category</td>
					<td class="leftAligned" colspan="3"><input type="text" id="txtLossCategory" style="width: 400px;" readonly="readonly" tabindex="301"/></td>
				</tr>
				<tr>
					<input type="hidden" id="txtSearchBy" name="txtSearchBy" value=""/>				
				</tr>			
			</table>
		</div>
		<div style="float: left; width: 100%; margin-bottom: 10px;" align="center">
			<input type="button" class="button" id="btnPrintReport" value="Print Report" tabindex="401"/>
		</div>
	</div>
</div>

<script type="text/javascript">

var notIn;

try{
	initializeAll();
	setModuleId("GICLS253");
	setDocumentTitle("Claim Listing Per Motorshop");
	filterOn = false;
	payeeNameResponse = "";
	
	var jsonClmListPerMotorshop = JSON.parse('${jsonClmListPerMotorshop}');
	
	perMotorshopTableModel = {
			url: contextPath+"/GICLClaimListingInquiryController?action=showClaimListingPerMotorshop&refresh=1",
			options: {
				toolbar:{
				elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
				onFilter : function(){
					setDetailsForm(null);
					tbgClaimsPerMotorshop.keys.removeFocus(tbgClaimsPerMotorshop.keys._nCurrentFocus, true);
					tbgClaimsPerMotorshop.keys.releaseKeys();
					filterOn = true;
				}
			},
			width: '900px',
			pager: {
			},
			onCellFocus : function(element, value, x, y, id) {
				setDetailsForm(tbgClaimsPerMotorshop.geniisysRows[y]);					
				tbgClaimsPerMotorshop.keys.removeFocus(tbgClaimsPerMotorshop.keys._nCurrentFocus, true);
				tbgClaimsPerMotorshop.keys.releaseKeys();
			},
			prePager: function(){
				setDetailsForm(null);
				tbgClaimsPerMotorshop.keys.removeFocus(tbgClaimsPerMotorshop.keys._nCurrentFocus, true);
				tbgClaimsPerMotorshop.keys.releaseKeys();
			},
			onRemoveRowFocus : function(element, value, x, y, id){					
				setDetailsForm(null);
			},
			onSort : function(){
				setDetailsForm(null);
				tbgClaimsPerMotorshop.keys.removeFocus(tbgClaimsPerMotorshop.keys._nCurrentFocus, true);
				tbgClaimsPerMotorshop.keys.releaseKeys();	
			},
			onRefresh : function(){
				setDetailsForm(null);
				tbgClaimsPerMotorshop.keys.removeFocus(tbgClaimsPerMotorshop.keys._nCurrentFocus, true);
				tbgClaimsPerMotorshop.keys.releaseKeys();
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
				id : "claimNumber",
				title: "Claim Number",
				width: '150px',
				filterOption : true,
			},				
			{
				id : "clmStatDesc",
				title: "Claim Status",
				width: '140px',
				filterOption : true
			},
			{
				id : "loaNumber",
				title: "LOA Number",
				width: '140px',
				filterOption : true
			},
			{
				id : "plateNo",
				title: "Plate No.",
				width: '140px',
				filterOption : true,
			},
			{
				id : "lossReserve",
				title: "Loss Reserve",
				width: '150px',
				filterOption : true,
				align : 'right',
				titleAlign : 'right',
				filterOptionType: 'number',
				geniisysClass: 'money'
			},
			{
				id : "paidAmt",
				title: "LOA Amount",
				width: '150px',
				filterOption : true,
				align : 'right',
				titleAlign : 'right',
				filterOptionType: 'number',
				geniisysClass: 'money'
			},
			{
				id: "dspLossDate",
				title: '',
			    width: '0',
			    visible: false
			},
			{
				id: "clmFileDate",
				title: '',
			    width: '0',
			    visible: false
			}
		],
		rows: []//jsonClmListPerMotorshop.rows
	};
	tbgClaimsPerMotorshop = new MyTableGrid(perMotorshopTableModel);
	tbgClaimsPerMotorshop.pager = jsonClmListPerMotorshop;
	tbgClaimsPerMotorshop.render('perMotorshopTable');
	tbgClaimsPerMotorshop.afterRender = function(){
		if(tbgClaimsPerMotorshop.geniisysRows.length > 0){
			if (filterOn == true) {
				computeTotal();
			}else {
				var rec = tbgClaimsPerMotorshop.geniisysRows[0];
	 			$("txtTotLossResAmt").value 	= formatCurrency(rec.totLossReserve);
				$("txtTotPaidAmt").value 		= formatCurrency(rec.totPaidAmt);
			}
		} else {
			$("txtTotLossResAmt").value 	= "";
			$("txtTotPaidAmt").value 		= "";
		}
	};
	
	function computeTotal() {
		var totLossResAmt  = 0;
		var totPaidAmt = 0;

		for (var i = 0; i < tbgClaimsPerMotorshop.geniisysRows.length; i++) {
			totLossResAmt 	= totLossResAmt  + parseFloat(tbgClaimsPerMotorshop.geniisysRows[i].lossReserve);
			totPaidAmt		= totPaidAmt + parseFloat(tbgClaimsPerMotorshop.geniisysRows[i].paidAmt);
		}
		$("txtTotLossResAmt").value  = formatCurrency(parseFloat(nvl(totLossResAmt, "0")));
		$("txtTotPaidAmt").value 	 = formatCurrency(parseFloat(nvl(totPaidAmt, "0")));
	}
	
	function setDetailsForm(rec){
		try{
			$("txtPolicyNo").value		= rec == null ? "" : rec.policyNumber;
			$("txtAssured").value		= rec == null ? "" : unescapeHTML2(rec.assuredName);
			$("txtLossCategory").value 	= rec == null ? "" : rec.lossCatDes;
			$("txtLossDate").value		= rec == null ? "" : dateFormat(rec.dspLossDate, "mm-dd-yyyy");
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
			setTbgParametersPerSearchBy();
			disableSearch("imgSearchPayeeName");
			disableInputField("txtPayeeName");
			disableToolbarButton("btnToolbarExecuteQuery");
			togglePrintButton(true);
	 		if (tbgClaimsPerMotorshop.geniisysRows.length == 0) {
				customShowMessageBox("Query caused no records to be retrieved. Re-enter.", imgMessage.INFO, "txtPayeeName");
				disableButton("btnPrintReport");
			}
		}
	}
	
	function resetHeaderForm(){
		try {
			if($F("txtPayeeCdHid") != "" || $F("txtPayeeName") != ""){
				$("txtPayeeCdHid").value = "";
				$("txtPayeeName").value="";
				enableInputField("txtPayeeName");
				payeeNameResponse = "";
				setClaimListingPerMotorshop();
				tbgClaimsPerMotorshop.url = contextPath+"/GICLClaimListingInquiryController?action=showClaimListingPerMotorshop&refresh=1&payeeCd"
											+$F('txtPayeeCdHid');
				tbgClaimsPerMotorshop._refreshList();
				$("txtPayeeName").focus();
				executeQuery = false;
			}
		} catch (e) {
			showErrorMessage("resetHeaderForm", e);
		}
	}
	
	//set searchby parameter value
	function toggleSearchBy() {
		if ($("rdoClaimFileDate").checked == true) {
			$("txtSearchBy").value = "claimFileDate";
		}else {
			$("txtSearchBy").value = "lossDate";
		}
	}
	
	//set tbg url per selected date params
 	function setTbgParametersPerDate() {
		if ($("rdoAsOf").checked == true) {
			refreshList();
		}
		
		if ($("rdoFrom").checked == true) {
			refreshList();
		}
	}
	
	function refreshList(){
		tbgClaimsPerMotorshop.url = contextPath +"/GICLClaimListingInquiryController?action=showClaimListingPerMotorshop&refresh=1&payeeCd="+$F("txtPayeeCdHid")
												+"&searchBy="+$F("txtSearchBy")+"&asOfDate="+$F("txtAsOfDate") 
												+"&fromDate="+$F("txtFromDate")+"&toDate="+$F("txtToDate");
		tbgClaimsPerMotorshop._refreshList();
	}
	
//  	//set tbg url per selected searchby params
	function setTbgParametersPerSearchBy() {
		if ($("rdoClaimFileDate").checked == true) {
			$("txtSearchBy").value = "claimFileDate";
			refreshList();
		}
		
		if ($("rdoLossDate").checked == true) {
			$("txtSearchBy").value = "lossDate";
			refreshList();
		}
	}
	
	//enable/disable date fields based on selected radio button
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
	
	//enable/disable calendar icon
	function toggleCalendar(enable){
		if (nvl(enable,false) == true){
			//enable asof calendar
			$("txtAsOfDate").value 		= "";
			$("txtAsOfDate").disabled 	= true;
			$("txtFromDate").disabled 	= false;
			$("txtToDate").disabled 	= false;
			disableDate("hrefAsOfDate");
			enableDate("hrefFromDate");
			enableDate("hrefToDate");
			$("txtFromDate").addClassName("required");
			$("txtToDate").addClassName("required");
			$("txtAsOfDate").removeClassName("required");
		}else{	
			//disable asof calendar
			$("txtAsOfDate").value 		= getCurrentDate();
			$("txtFromDate").value 		= "";
			$("txtToDate").value 		= "";
			$("txtAsOfDate").disabled 	= false;
			$("txtFromDate").disabled 	= true;
			$("txtToDate").disabled 	= true;
			enableDate("hrefAsOfDate");
			disableDate("hrefFromDate");
			disableDate("hrefToDate");
			$("txtFromDate").removeClassName("required");
			$("txtToDate").removeClassName("required");
			$("txtAsOfDate").addClassName("required");
		}
	}
	
	//toggle toolbar buttons
	function togglePrintButton(enable) {
		if (nvl(enable,false) == true){
			enableButton("btnPrintReport");
			enableToolbarButton("btnToolbarPrint");
		}else {
			disableButton("btnPrintReport");
			disableToolbarButton("btnToolbarPrint");
		}
	}
	
	//initialize default ClaimListingPerMotorshop settings
	function setClaimListingPerMotorshop() {
		$("rdoClaimFileDate").checked 	= true;
		$("rdoAsOf").checked 			= true;
		$("rdoFrom").disabled 			= false;
		$("rdoAsOf").disabled 			= false;
		enableDate("hrefAsOfDate");
		enableDate("hrefFromDate");
		enableDate("hrefToDate");
		enableSearch("imgSearchPayeeName");
		disableButton("btnPrintReport");
		disableToolbarButton("btnToolbarPrint");
		disableToolbarButton("btnToolbarExecuteQuery");
		disableToolbarButton("btnToolbarEnterQuery");
		toggleCalendar(false);
	}
	
	function validateDate() {
		if ($("rdoFrom").checked == true) {
			if ($("txtFromDate").value == "") {
				customShowMessageBox("Pls. enter FROM date.", imgMessage.INFO, "txtFromDate");
				return false;
			}
			if ($("txtToDate").value == "") {
				customShowMessageBox("Pls. enter TO date.", imgMessage.INFO, "txtToDate");
				return false;
			}
		}
		return true;
	}
	
	function showGICLS253PayeeNameLOV(){
		LOV.show({
			controller : "ClaimsLOVController",
			urlParameters : {
				action : "getGICLS253MotorshopLOV",
				payeeName: $('txtPayeeName').value.length > 0 ? $F('txtPayeeName') : 'null',
				page : 1
			},
			title : "List of Motorshops",
			width : 421,
			height : 386,
			columnModel : [ {
				id : "payeeNo",
				title : "Payee No.",
				width : '60px',
			}, {
				id : "payeeName",
				title : "Payee Name",
				width : '345px'
			} ],
			draggable : true,
			autoSelectOneRecord: true,
			filterText:  $("txtPayeeName").value,
			onSelect : function(row) {
				$("txtPayeeName").value = unescapeHTML2(row.payeeName);
				$("txtPayeeCdHid").value = row.payeeNo;
				enableToolbarButton("btnToolbarExecuteQuery");
				enableToolbarButton("btnToolbarEnterQuery");
			},
			onCancel: function(){
				$("txtPayeeName").focus();
			},
			onShow: function(){
				$(this.id + "_txtLOVFindText").focus();
			}
		});
	}
	
	function validatePayeePerPayeeName(){
		new Ajax.Request(contextPath + "/GICLClaimListingInquiryController", {
			method: "POST",
			parameters: {
				action : "validateMotorshop",
				payeeName : $F("txtPayeeName")
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				if (response.responseText == '0') {
					payeeNameResponse = response.responseText ;
					$("txtPayeeName").value = "";
					customShowMessageBox("There is no record of this Payee in GIIS_PAYEES.", imgMessage.INFO, "txtPayeeName");
				} else if(response.responseText == '1') {
					showGICLS253PayeeNameLOV();
					validateDate();
					if(validateDate()){
						if ($("txtPayeeName").value != "") {
							enableToolbarButton("btnToolbarExecuteQuery");
						}else {
							disableToolbarButton("btnToolbarExecuteQuery");
						}
					}
				} else if (response.responseText.include("Sql Exception")) {
					payeeNameResponse = "Y";
					showGICLS253PayeeNameLOV();
					enableToolbarButton("btnToolbarEnterQuery");
					if ($("txtPayeeName").value != "") {
						enableToolbarButton("btnToolbarExecuteQuery");
					}else {
						disableToolbarButton("btnToolbarExecuteQuery");
					}
				}
			}
		});
	}
	
	//enable backspace on date fields
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
	
	//field onchange
	$("txtPayeeName").observe("change", function() {
		if ($("txtPayeeName").value != "") {
			validatePayeePerPayeeName();
		}
	});
	
// 	tbg setting per searchby radio btn
	$("rdoClaimFileDate").observe("click", function() {
		if ($F("txtPayeeName") != "" && payeeNameResponse != '0' && executeQuery) {
			setTbgParametersPerSearchBy();
		}
	});
	$("rdoLossDate").observe("click", function() {
		if ($F("txtPayeeName") != "" && payeeNameResponse != '0' && executeQuery) {
			setTbgParametersPerSearchBy();
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
	
// 	//toolbar buttons
	$("btnToolbarEnterQuery").observe("click", resetHeaderForm);
	$("btnToolbarExecuteQuery").observe("click", function() {
		if ($("txtPayeeName").value != "") {
			setFieldOnSearch();	
			executeQuery = true;
		}
	});
	$("btnToolbarPrint").observe("click", function(){
		//showMessageBox("The report you are trying to generate is not yet available.", imgMessage.INFO);
		showGenericPrintDialog("Print Claim Listing per Motorshop", printReport, "", true);
		$("csvOptionDiv").show(); //Dren 03.08.2016 SR-5372
	});
	$("btnToolbarExit").observe("click", function(){
		document.stopObserving("keyup");
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
	});
	
// 	//LOV btn
	$("imgSearchPayeeName").observe("click", function() {
		showGICLS253PayeeNameLOV();
	});
	
	$("btnPrintReport").observe("click", function(){
		//showMessageBox("The report you are trying to generate is not yet available.", imgMessage.INFO);
		showGenericPrintDialog("Print Claim Listing per Motorshop", printReport, "", true);
		$("csvOptionDiv").show(); //Dren 03.08.2016 SR-5372		
	});
	
	function printReport(){
 		try {
 			var content = contextPath + "/PrintClaimListingInquiryController?action=printReport"
 							+"&reportId=GICLR253"
 							+"&payeeCd="+($F("txtPayeeCdHid"))
 							+"&searchBy="+($F("rdoAsOf") ? 1 : 2)
 							+"&asOfDate="+$F("txtAsOfDate")
 							+"&fromDate="+$F("txtFromDate")
 							+"&toDate="+$F("txtToDate");
			
 			if("screen" == $F("selDestination")){
 				showPdfReport(content, "Claim Listing per Motorshop");
 				overlayGenericPrintDialog.close();
 			}else if($F("selDestination") == "printer"){
 				new Ajax.Request(content, {
 					parameters : {noOfCopies : $F("txtNoOfCopies"),
 						  	      printerName : $F("selPrinter")},
 					onCreate: showNotice("Processing, please wait..."),				
 					onComplete: function(response){
 						hideNotice();
 						if (checkErrorOnResponse(response)){
 							showWaitingMessageBox("Printing Completed.", imgMessage.SUCCESS, function(){
 								overlayGenericPrintDialog.close();
 							});
 						}
 					}
 				});
 			}else if("file" == $F("selDestination")){
				var fileType = "PDF"; //Dren 03.08.2016 SR-5372
				
				if($("rdoPdf").checked)
					fileType = "PDF";
				else if ($("rdoCsv").checked)
					fileType = "CSV";
				
				new Ajax.Request(content, {
					parameters : {destination : "file",
					fileType : fileType},
					onCreate: showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response))
						{if (fileType == "CSV"){
							copyFileToLocal(response, "csv");
							deleteCSVFileFromServer(response.responseText);
							} else 
							copyFileToLocal(response);
						}
					}				  
				}); //Dren 03.08.2016 SR-5372
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
	
	$("txtPayeeName").focus();
	setClaimListingPerMotorshop();
	initializeAccordion();
	var executeQuery = false;
	
}catch(e){
	showErrorMessage("Claim Listing Per Motorshop page has errors.", e);	
}	
</script>