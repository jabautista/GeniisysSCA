<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="perLawyerMainDiv" name="perLawyerMainDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Claim Listing per Lawyer</label>
	   	</div>
	</div>
	<div id="sectionDivTop" class="sectionDiv">
		<div style="float: left;">
			<table style="margin: 10px 0px 5px 20px;">
				<tr>
					<td class="rightAligned">Lawyer</td>
					<td class="leftAligned">
						<span class="lovSpan" style="width: 530px; margin-right: 5px; margin-left:10px;">
							<input type="hidden" id="hidLawyer" name="hidLawyer"/>
							<input type="hidden" id="hidLawyerCd" name="hidLawyerCd"/>
							<input type="hidden" id="hidLawyerClassCd" name="hidLawyerClassCd"/>
							<input type="text" ignoreDelKey="1" id="txtLawyer" name="txtLawyer" style="width:505px; float: left; border: none; height: 14px; margin: 0;" class="required disableDelKey allCaps" tabindex="101"/>  
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchLawyer" name="imgSearchLawyer" alt="Go" style="float: right;" tabindex="102"/>
						</span>
					</td>
				</tr>
			</table>
			<div style="float: left; margin-left: 78px; margin-bottom: 10px; margin-right: 5px;">
				<fieldset style="width: 519px; height: 52px;">
					<legend>Search By</legend>
					<table style="margin-top: 8px;">
						<tr>
							<td width="90px"></td>
							<td class="rightAligned">
								<input type="radio" name="searchBy" id="rdoClaimFileDate" style="float: left; margin: 3px 2px 3px 30px;" tabindex="103"/>
								<label for="rdoClaimFileDate" style="float: left; height: 20px; padding-top: 3px;" title="Claim File Date">Claim File Date</label>
							</td>
							<td width="70px"></td>
							<td class="rightAligned">
								<input type="radio" name="searchBy" id="rdoLossDate" style="float: left; margin: 3px 2px 3px 30px;" tabindex="104"/>
								<label for="rdoLossDate" style="float: left; height: 20px; padding-top: 3px;" title="Loss Date">Loss Date</label>
							</td>
							<td width="90px"></td>
						</tr>
					</table>
				</fieldset>
			</div>	
		</div>
		<div class="sectionDiv" style="float: left; width: 255px; margin: 12px;">
			<table style="margin: 8px;">	
				<tr>
					<td class="rightAligned"><input type="radio" name="byDate" id="rdoAsOf" title="As of" style="float: left;" tabindex="105"/><label for="rdoAsOf" title="As of" style="float: left; height: 20px; padding-top: 3px;">As of</label></td>
					<td class="leftAligned">
						<div style="float: left; width: 165px;" class="withIconDiv">
							<input type="text" id="txtAsOfDate" name="txtAsOfDate" class="withIcon" readonly="readonly" style="width: 140px;" tabindex="106"/>
							<img id="hrefAsOfDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="As of Date" tabindex="107"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned"><input type="radio" name="byDate" id="rdoFrom" title="From" style="float: left;" tabindex="108"/><label for="rdoFrom" style="float: left; height: 20px; padding-top: 3px;">From</label></td>
					<td class="leftAligned">
						<div style="float: left; width: 165px;" class="withIconDiv">
							<input type="text" id="txtFromDate" name="txtFromDate" class="withIcon" readonly="readonly" style="width: 140px;" tabindex="109"/>
							<img id="hrefFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="From Date" tabindex="110"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">To</td>
					<td class="leftAligned">
						<div style="float: left; width: 165px;" class="withIconDiv">
							<input type="text" id="txtToDate" name="txtToDate" class="withIcon" readonly="readonly" style="width: 140px;" tabindex="111"/>
							<img id="hrefToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="To Date" tabindex="112"/>
						</div>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<div id="sectionDivBottom" class="sectionDiv" style="margin-bottom: 50px;">
		<div>
			<div id="perLawyerTableDiv" style="padding: 10px 0 0 10px;">
				<div id="perLawyerTable" style="height: 340px;"></div>
			</div>	
		</div>
			<div class="sectionDiv" style="margin: 10px; width: 97.5%;">
				<table style="margin: 5px 5px 5px 5px; float: left;">
					<tr>
						<td class="rightAligned">Claim No</td>
						<td class="leftAligned"><input type="text" id="txtClaimNo" style="width: 350px;" readonly="readonly" tabindex="301"/></td>
						<td class="rightAligned" style="width: 110px">Assured Name</td>
						<td class="leftAligned"><input type="text" id="txtAssured" style="width: 300px;" readonly="readonly" tabindex="304"/></td>
					</tr>
					<tr>
						<td class="rightAligned">Policy No</td>
						<td class="leftAligned"><input type="text" id="txtPolicyNo" style="width: 350px;" readonly="readonly" tabindex="302"/></td>
						<td class="rightAligned" style="width: 130px">Claim Status</td>
						<td class="leftAligned"><input type="text" id="txtClaimStatus" style="width: 300px;" readonly="readonly" tabindex="305"/></td>
					</tr>
					<tr>
						<td class="rightAligned">Court</td>
						<td class="leftAligned"><input type="text" id="txtCourt" style="width: 350px;" readonly="readonly" tabindex="303"/></td>
						<td colspan=2>
							<table style="margin-left: 40px;">
								<tr>
									<td class="rightAligned" style="width:200px;">File Date<input type="text" id="txtClaimFileDate" style="width: 97px; margin-left: 8px;" readonly="readonly" tabindex="306"/></td>
									<td class="rightAligned" style="width: 200px;">Loss Date<input class="leftAligned" type="text" id="txtLossDate" style="width: 95px; margin-left: 8px;" readonly="readonly" tabindex="307"/></td>
								</tr>
							</table>
						</td>
						<input type="hidden" id="hidClaimId" name="hidClaimId" />
						<input type="hidden" id="hidRecoveryId" name="hidRecoveryId" />
					</tr>
					<tr>
						<input type="hidden" id="hidSearchBy" name="hidSearchBy" value=""/>				
					</tr>			
				</table>
			</div>
			<div style="float: left; width: 100%; margin-bottom: 10px;" align="center">
				<input type="button" class="button" id="btnRecoveryDetails" value="Recovery Details" tabindex="401"/>
				<input type="button" class="button" id="btnPrintReport" value="Print Report" tabindex="402"/>
			</div>
		</div>
	</div>
<script type="text/javascript">
	initializeAll();
	setModuleId("GICLS276");
	setDocumentTitle("Claim Listing Per Lawyer");
	filterOn = false;
	objRecovery = new Object();
	
	//perLawyer Table
	var jsonClmListPerLawyer = JSON.parse('${jsonClmListPerLawyer}');	
	perLawyerTableModel = {
			url : contextPath+"/GICLClaimListingInquiryController?action=showClaimListingPerLawyer&refresh=1",
			options: {
				toolbar: {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter : function(){
						setDetailsForm(null);
						tbgClaimsPerLawyer.keys.removeFocus(tbgClaimsPerLawyer.keys._nCurrentFocus, true);
						tbgClaimsPerLawyer.keys.releaseKeys();
						filterOn = true;
						togglePrintButton(false);
						toggleRecoveryDetailsButton(false);
					}
				},
				width: '900px',
				pager: {
				},
				onCellFocus : function(element, value, x, y, id) {
					setDetailsForm(tbgClaimsPerLawyer.geniisysRows[y]);					
					tbgClaimsPerLawyer.keys.removeFocus(tbgClaimsPerLawyer.keys._nCurrentFocus, true);
					tbgClaimsPerLawyer.keys.releaseKeys();
					togglePrintButton(true);
					toggleRecoveryDetailsButton(true);
				},
				prePager: function(){
					setDetailsForm(null);
					tbgClaimsPerLawyer.keys.removeFocus(tbgClaimsPerLawyer.keys._nCurrentFocus, true);
					tbgClaimsPerLawyer.keys.releaseKeys();
					togglePrintButton(false);
					toggleRecoveryDetailsButton(false);
				},
				onRemoveRowFocus : function(element, value, x, y, id){					
					setDetailsForm(null);
					toggleRecoveryDetailsButton(false);
				},
				onSort : function(){
					setDetailsForm(null);
					tbgClaimsPerLawyer.keys.removeFocus(tbgClaimsPerLawyer.keys._nCurrentFocus, true);
					tbgClaimsPerLawyer.keys.releaseKeys();	
					toggleRecoveryDetailsButton(false);
				},
				onRefresh : function(){
					setDetailsForm(null);
					tbgClaimsPerLawyer.keys.removeFocus(tbgClaimsPerLawyer.keys._nCurrentFocus, true);
					tbgClaimsPerLawyer.keys.releaseKeys();
					toggleRecoveryDetailsButton(false);
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
					id : "recoveryNo",
					title: "Recovery Number",
					width: '120px',
					filterOption : true,
					align : "left",
					titleAlign : "left"
				},				
				{
					id : "caseNo",
					title: "Case No.",
					width: '120px',
					filterOption : true,
					align : "left",
					titleAlign : "left"
				},
				{
					id : "classDesc",
					title: "Payor Class",
					width: '90px',
					filterOption : true
				},
				{
					id : "payeeName", 
					title: "Payor",
					width: '210px',
					filterOption : true,
				},
				{
					id : "recStatDesc",
					title: "Status",
					width: '120px',
					filterOption : true,
				},
				{
					id : "recoverableAmt",
					title: "Recoverable Amt",
					width: '110px',
					filterOption : true,
					align : 'right',
					titleAlign : 'right',
					filterOptionType: 'number',
					geniisysClass: 'money'
				},
				{
					id : "recoveredAmt",
					title: "Recovered Amt",
					width: '110px',
					filterOption : true,
					align : 'right',
					titleAlign : 'right',
					filterOptionType: 'number',
					geniisysClass: 'money'
				}
			],
			rows: [] //jsonClmListPerLawyer.rows
		};
	
	tbgClaimsPerLawyer = new MyTableGrid(perLawyerTableModel);
	//tbgClaimsPerLawyer.pager = jsonClmListPerLawyer;
	tbgClaimsPerLawyer.render('perLawyerTable');
	
	function setDetailsForm(rec){
		try{
			$("txtClaimNo").value 		= rec == null ? "" : unescapeHTML2(rec.claimNo);
			$("txtPolicyNo").value		= rec == null ? "" : unescapeHTML2(rec.policyNo);
			$("txtAssured").value		= rec == null ? "" : unescapeHTML2(rec.assdName);
			$("txtClaimStatus").value	= rec == null ? "" : unescapeHTML2(rec.clmStatDesc);
			$("txtCourt").value			= rec == null ? "" : unescapeHTML2(rec.court);
			$("txtClaimFileDate").value = rec == null ? "" : dateFormat(rec.clmFileDate, "mm-dd-yyyy");
			$("txtLossDate").value 		= rec == null ? "" : dateFormat(rec.lossDate, "mm-dd-yyyy");
			$("hidClaimId").value 		= rec == null ? "" : unescapeHTML2(rec.claimId);
			objRecovery.claimId 		= rec == null ? "" : unescapeHTML2(rec.claimId);
			$("hidRecoveryId").value	= rec == null ? "" : unescapeHTML2(rec.recoveryId);
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
			togglePrintButton(true);
			disableInputField("txtLawyer");
	 		if (tbgClaimsPerLawyer.geniisysRows.length == 0) {
				customShowMessageBox("Query caused no records to be retrieved. Re-enter.", imgMessage.INFO, "txtLawyer");
				disableButton("btnPrintReport");
				togglePrintButton(false);
			}
		}
	}
	
	function resetHeaderForm(){
		try{
				$("hidLawyer").value = "";
				$("hidLawyerCd").value = "";
				$("txtLawyer").value = "";
				enableInputField("txtLawyer");
				setClaimListingPerLawyer();
				tbgClaimsPerLawyer.url = contextPath+"/GICLClaimListingInquiryController?action=showClaimListingPerLawyer&refresh=1&lawyerCd="+$F("hidLawyerCd");
				tbgClaimsPerLawyer._refreshList();
				$("txtLawyer").focus();
				executeQuery = false;
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
			tbgClaimsPerLawyer.url = contextPath +"/GICLClaimListingInquiryController?action=showClaimListingPerLawyer&refresh=1&lawyerCd="+$F("hidLawyerCd")+"&searchBy="+ $F("hidSearchBy") +"&asOfDate="+$F("txtAsOfDate");
			tbgClaimsPerLawyer._refreshList();
		}
		
		if ($("rdoFrom").checked == true) {
			tbgClaimsPerLawyer.url = contextPath +"/GICLClaimListingInquiryController?action=showClaimListingPerLawyer&refresh=1&lawyerCd="+$F("hidLawyerCd")+"&searchBy="+ $F("hidSearchBy") +"&fromDate="+$F("txtFromDate")+"&toDate="+$F("txtToDate");
			tbgClaimsPerLawyer._refreshList();
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
			$("txtFromDate").addClassName("required");
			$("txtToDate").addClassName("required");
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
			$("txtFromDate").removeClassName("required");
			$("txtToDate").removeClassName("required");
		}
	}
	function togglePrintButton(enable) {
		if (nvl(enable,false) == true){
			enableButton("btnPrintReport");
			enableToolbarButton("btnToolbarPrint");
		}else {
			disableButton("btnPrintReport");
			disableToolbarButton("btnToolbarPrint");
		}
	}
	
	function toggleRecoveryDetailsButton(enable) {
		if (nvl(enable,false) == true){
			enableButton("btnRecoveryDetails");
		}else {
			disableButton("btnRecoveryDetails");
		}
	}
	
	//default setting
	function setClaimListingPerLawyer() {
		$("rdoClaimFileDate").checked 	= true;
		$("rdoAsOf").checked 			= true;
		$("rdoFrom").disabled 			= false;
		$("rdoAsOf").disabled 			= false;
		enableDate("hrefAsOfDate");
		enableDate("hrefFromDate");
		enableDate("hrefToDate");
		enableSearch("imgSearchLawyer");
		disableButton("btnPrintReport");
		disableButton("btnRecoveryDetails");
		disableToolbarButton("btnToolbarPrint");
		disableToolbarButton("btnToolbarExecuteQuery");
		disableToolbarButton("btnToolbarEnterQuery");
		toggleCalendar(false);
	}
	
	//Date Validation
	function validateDate() {
		if ($("rdoFrom").checked == true) {
			if ($("txtFromDate").value == "") {
				customShowMessageBox("Pls. enter FROM date.", imgMessage.INFO, "txtFromDate");
				enableToolbarButton("btnToolbarExecuteQuery");
				return false;
			}
			if ($("txtToDate").value == "") {
				customShowMessageBox("Pls. enter TO date.", imgMessage.INFO, "txtToDate");
				enableToolbarButton("btnToolbarExecuteQuery");
				return false;
			}
		}
		return true; 
	}
	
	//lawyer LOV
	function showGICLS276LawyerLOV(lawyer){
		LOV.show({
			controller : "ClaimsLOVController",
			urlParameters : {
				action : "getLawyerLOV",
				lawyerName: lawyer,
				page : 1
			},
			title : "List of Lawyers",
			width : 450,
			height : 390,
			columnModel : [ {
				id : "lawyerCd",
				title : "Lawyer Code",
				width : '120px',
			}, {
				id : "lawyerName",
				title : "Lawyer Name",
				width : '310px'
			} ],
			draggable : true,	
			autoSelectOneRecord: true,
			onSelect : function(row) {
				$("txtLawyer").value = unescapeHTML2(row.lawyerName);
				$("hidLawyerCd").value = row.lawyerCd;
				$("hidLawyerClassCd").value = row.lawyerClassCd;
				enableToolbarButton("btnToolbarExecuteQuery");
				enableToolbarButton("btnToolbarEnterQuery");
			},
			onCancel: function(){
				$("txtLawyer").focus();
				$("hidLawyerCd").value = "";
				$("hidLawyerClassCd").value = "";
			},
			onShow: function(){$(this.id + "_txtLOVFindText").focus();}
		});
	}
	
	//Print Report
	function printReport(){
		try {
			var reportId; //SR-5410
			if($F("selDestination") == "file") { //Start Kevin SR-5410 6-16-2016
				if ($("rdoPdf").checked) 
					reportId = "GICLR276";
				else 
					reportId = "GICLR276_CSV";		
			} else {
				reportId = "GICLR276";
			} //End Kevin SR-5410
			var content = contextPath + "/PrintClaimListingInquiryController?action=printReport"
							+"&reportId="+reportId+"&lawyerCd="+$("hidLawyerCd").value //reportId SR-5410
							+"&lawyerClassCd="+$("hidLawyerClassCd").value
							+"&searchBy="+($F("rdoAsOf") ? 1 : 2)
							+"&asOfDate="+$F("txtAsOfDate")
							+"&fromDate="+$F("txtFromDate")
							+"&toDate="+$F("txtToDate");
			
			if("screen" == $F("selDestination")){
				showPdfReport(content, "Claim Listing per Lawyer");
			}else if($F("selDestination") == "printer"){
				new Ajax.Request(content, {
					parameters : {noOfCopies : $F("txtNoOfCopies"),
						  	      printerName : $F("selPrinter")},
					onCreate: showNotice("Processing, please wait..."),				
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							showWaitingMessageBox("Printing complete.", "S", function(){
								overlayGenericPrintDialog.close();
							});
						}
					}
				});
			}else if("file" == $F("selDestination")){
				var fileType = "PDF"; //Start Kevin SR-5410 6-16-2016
				
				if ($("rdoPdf").checked){
					fileType = "PDF";
				}
				else{
					fileType = "CSV2"; //End SR-5410
				}
					
				new Ajax.Request(content, {
					parameters : {destination : "file",
								  /* fileType : $("rdoPdf").checked ? "PDF" : "XLS"}, */
								  fileType : fileType},
					onCreate: showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							if (fileType == "CSV2"){ //Start Kevin SR-5410 6-16-2016
								copyFileToLocal(response, "csv");
							} else {
								copyFileToLocal(response);
							}
						} //End SR-5410
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
							} else {
								showWaitingMessageBox("Printing complete.", "S", function(){
									overlayGenericPrintDialog.close();
								});
							}
						}
					}
				});
			}
		} catch (e){
			showErrorMessage("printReport", e);
		}
	}
	
	//Recovery Details
	function showRecoveryDetails() {
		try {
			overlayRecoveryDetails = Overlay.show(contextPath
					+ "/GICLClaimListingInquiryController", {
				urlContent : true,
				urlParameters : {
					action : "showGicls276RecoveryDetails",
					ajax : "1",
					claimId : objRecovery.claimId,
					recoveryId : $("hidRecoveryId").value
					},
				title : "Recovery Details",
				 height: 500,
				 width: 820,
				draggable : true
			});
		} catch (e) {
			showErrorMessage("overlay error: ", e);
		}
	}
	
	//lawyer validation on search
	function validateLawyer() {
		new Ajax.Request(contextPath + "/GICLClaimListingInquiryController", {
			method: "POST",
			parameters: {
				action : "validateLawyer",
				lawyerName : $("txtLawyer").value
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				if (response.responseText == 0) {
					/* $("txtLawyer").value = "";
					customShowMessageBox("There is no record of this lawyer in GIIS_PAYEES.", imgMessage.INFO, "txtLawyer"); */
					showGICLS276LawyerLOV($("txtLawyer").value);
				} else if(response.responseText == 1) {
					showGICLS276LawyerLOV($("txtLawyer").value);
					enableToolbarButton("btnToolbarEnterQuery");
					if ($("txtLawyer").value != "") {
						enableToolbarButton("btnToolbarExecuteQuery");
					}else {
						disableToolbarButton("btnToolbarExecuteQuery");
					}
				} else if (response.responseText.include("Sql Exception")) {
					showGICLS276LawyerLOV($("txtLawyer").value);
					enableToolbarButton("btnToolbarEnterQuery");
				}
			}
		});			
	}
		
	$$("input[name='searchBy']").each(function(btn) {
		btn.observe("click", function() {
			toggleSearchBy(); 
			if ($("txtLawyer").value != "" && executeQuery==true) {
				execute();
			}
		});
	}); 
	
	function execute() {
		tbgClaimsPerLawyer.url = contextPath +"/GICLClaimListingInquiryController?action=showClaimListingPerLawyer&refresh=1&lawyerCd="+$F("hidLawyerCd")+"&searchBy="+ $F("hidSearchBy") +"&fromDate="+$F("txtFromDate")+"&toDate="+$F("txtToDate");
		setFieldOnSearch();	
		disableToolbarButton("btnToolbarExecuteQuery");
	}; 
	
	$("btnRecoveryDetails").observe("click", function(){
		showRecoveryDetails();
	});
	observeBackSpaceOnDate("txtAsOfDate");
	observeBackSpaceOnDate("txtFromDate");
	observeBackSpaceOnDate("txtToDate");	
	
	//date field validations
	$("txtFromDate").observe("focus", function(){
		if ($("hrefFromDate").disabled == true) return;
		var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g,"/")) : "";
		var toDate = $F("txtToDate") != "" ? new Date($F("txtToDate").replace(/-/g,"/")) :"";
		var sysdate = new Date();
		if (fromDate > sysdate && fromDate != ""){
			customShowMessageBox("Date should not be greater than the current date.", "I", "txtFromDate");
			$("txtFromDate").clear();
			return false;
		}
		if (toDate < fromDate && toDate != ""){
			customShowMessageBox("From Date should not be later than To Date.", "I", "txtFromDate");
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
			customShowMessageBox("From Date should not be later than To Date.", "I", "txtToDate");
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
 	$("txtLawyer").observe("change", function() {
		if ($("txtLawyer").value != "") {
			validateLawyer();
			enableToolbarButton("btnToolbarExecuteQuery");
			enableToolbarButton("btnToolbarEnterQuery");
			$("hidLawyerCd").value = "";
			$("hidLawyerClassCd").value = "";
		}
		else if ($("txtLawyer").value == ""){
			disableToolbarButton("btnToolbarExecuteQuery");
			enableToolbarButton("btnToolbarEnterQuery");
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
		
	//toolbar buttons
	$("btnToolbarEnterQuery").observe("click", resetHeaderForm);
	$("btnToolbarExecuteQuery").observe("click", function() {
		if ($("txtLawyer").value != "") {
			setFieldOnSearch();	
			executeQuery = true;
			disableToolbarButton("btnToolbarExecuteQuery");
			disableSearch("imgSearchLawyer");
		}
	});
	$("btnToolbarPrint").observe("click", function(){
		showGenericPrintDialog("Print Claim Listing per Lawyer", printReport, "", true);
		$("csvOptionDiv").show(); //added by Kevin for SR-5410
	});
	$("btnToolbarExit").observe("click", function(){
		document.stopObserving("keyup");
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
	});
	
	$("imgSearchLawyer").observe("click", function(){
		temp = $("txtLawyer").value;
		$("txtLawyer").value = "";
		showGICLS276LawyerLOV($("txtLawyer").value);
		$("txtLawyer").value = temp;
	});
	
	$("btnPrintReport").observe("click", function(){
		showGenericPrintDialog("Print Claim Listing per Lawyer", printReport, "", true);
		$("csvOptionDiv").show(); //added by Kevin for SR-5410
	});
	
	$("txtLawyer").focus();
	setClaimListingPerLawyer();
	initializeAccordion();
	//var executeQuery = false;
</script>