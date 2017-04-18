<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="perUserMainDiv">
 	<div id="perAssuredSubMenu">
	 	<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="btnExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv">
		<div id="innerDiv">
			<label>Claim Listing per User</label>
		</div>
	</div>	
	<div class="sectionDiv" style="padding: 0 0 10px 0;">
		<div style="float: left;">
			<table style="margin: 10px 10px 5px 30px;">
				<tr>
					<td class="rightAligned">Claim Processor</td>
					<td class="leftAligned">
						<span class="lovSpan required" style="width: 400px; margin-right: 30px;">
							<input type="text" id="txtClaimProcessor" style="width: 370px; float: left; border: none; height: 14px; margin: 0;" class="required allCaps" tabindex="101"/>  
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchClaimProcessor" alt="Go" style="float: right;" tabindex="102"/>
						</span>
					</td>
				</tr>
			</table>
			<div style="float: left; margin-left: 132px; margin-bottom: 10px;">
				<fieldset style="width: 385px;">
					<legend>Search By</legend>
					<table>
						<tr>
							<td class="rightAligned">
								<input type="radio" name="searchBy" id="rdoClaimFileDate" style="float: left; margin: 3px 2px 3px 70px;" tabindex="103" />
								<label for="rdoClaimFileDate" style="float: left; height: 20px; padding-top: 3px;" title="Claim File Date">Claim File Date</label>
							</td>
							<td class="rightAligned">
								<input type="radio" name="searchBy" id="rdoLossDate" style="float: left; margin: 3px 2px 3px 50px;" tabindex="104" />
								<label for="rdoLossDate" style="float: left; height: 20px; padding-top: 3px;" title="Loss Date">Loss Date</label>
							</td>
						</tr>
					</table>
				</fieldset>
			</div>
		</div>
		<div class="sectionDiv" style="float: right; width: 255px; margin: 12px 60px 0 0;">
			<table style="margin: 8px;">	
				<tr>
					<td class="rightAligned"><input type="radio" name="byDate" id="rdoAsOf" title="As of" style="float: left;" tabindex="105"/><label for="rdoAsOf" title="As of" style="float: left; height: 20px; padding-top: 3px;">As of</label></td>
					<td class="leftAligned">
						<div style="float: left; width: 165px;" class="withIconDiv" id="divAsOf">
							<input type="text" removeStyle="true" id="txtAsOf" class="withIcon" readonly="readonly" style="width: 140px;" tabindex="106"/>
							<img id="imgAsOf" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="As of Date" tabindex="107"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned"><input type="radio" name="byDate" id="rdoFrom" title="From" style="float: left;" tabindex="108"/><label for="rdoFrom" style="float: left; height: 20px; padding-top: 3px;">From</label></td>
					<td class="leftAligned">
						<div style="float: left; width: 165px;" class="withIconDiv" id="divFrom">
							<input type="text" removeStyle="true" id="txtFrom" class="withIcon" readonly="readonly" style="width: 140px;" tabindex="109"/>
							<img id="imgFrom" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="From Date" tabindex="110"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">To</td>
					<td class="leftAligned">
						<div style="float: left; width: 165px;" class="withIconDiv" id="divTo">
							<input type="text" removeStyle="true" id="txtTo" class="withIcon" readonly="readonly" style="width: 140px;" tabindex="111"/>
							<img id="imgTo" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="To Date" tabindex="112"/>
						</div>
					</td>
				</tr>
			</table>
		</div>
	</div>	
	<div class="sectionDiv" style="margin-bottom: 50px;">
		<div id="perUserTableDiv" style="padding: 10px 0 0 10px;">
			<div id="perUserTable" style="height: 300px; margin-left: auto;"></div>
		</div>
		<div style="margin: 5px; float: left; margin-left: 20px;">
			<table>
				<tr>
					<td>
						<input type="button" id="btnRecoveryDetails" class="disabledButton" value="Recovery Details" tabindex="201" />
					</td>
				</tr>		
			</table>	
		</div>
		<div style="margin: 5px; float: right; margin-right: 20px;">
			<table>
				<tr>
					<td class="rightAligned">Totals</td>
					<td class=""><input type="text" id="txtTotLossReserve" style="width: 120px; text-align: right;" readonly="readonly" tabindex="202"/></td>
					<td class=""><input type="text" id="txtTotExpenseReserve" style="width: 120px; text-align: right;" readonly="readonly" tabindex="203"/></td>
					<td class=""><input type="text" id="txtTotLossesPaid" style="width: 120px; text-align: right;" readonly="readonly" tabindex="204"/></td>
					<td class=""><input type="text" id="txtTotExpensesPaid" style="width: 120px; text-align: right;" readonly="readonly" tabindex="205"/></td>
				</tr>
			</table>
		</div>
		<div class="sectionDiv" style="margin: 10px; float: left; width: 97.5%;">
			<table style="margin: 5px; float: left;">
				<tr>
					<td class="rightAligned">Policy Number</td>
					<td class="leftAligned"><input type="text" id="txtPolicyNo" style="width: 370px;" readonly="readonly" tabindex="301"/></td>
					<td width="50px"></td>
					<td class="rightAligned">Loss Date</td>
					<td class="leftAligned"><input type="text" id="txtLossDte" style="width: 230px;" readonly="readonly" tabindex="303"/></td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 110px;">Assured Name</td>
					<td class="leftAligned"><input type="text" id="txtAssuredName" style="width: 370px;" readonly="readonly" tabindex="302"/></td>
					<td></td>
					<td class="rightAligned">File Date</td>
					<td class="leftAligned"><input type="text" id="txtFileDate" style="width: 230px;" readonly="readonly" tabindex="304"/></td>
				</tr>			
			</table>
		</div>
		<div style="float: left; width: 100%; margin-bottom: 10px;" align="center">
			<input type="button" class="disabledButton" id="btnProcHistory" value="Processor History" style="width: 140px;" />
			<input type="button" class="disabledButton" id="btnClaimStatusHistory" value="Claim Status History" style="width: 140px;" />
			<input type="button" class="disabledButton" id="btnClaimDetails" value="Claim Details" style="width: 140px;" />
			<input type="button" class="disabledButton" id="btnPrintReport" value="Print Report" style="width: 140px;" tabindex="401"/>
		</div>
	</div>	
</div>
<div id="claimInfoNew"><</div>
<script type="text/javascript">
	try{
		$("mainNav").hide();
		var onLOV = false;
		var inHouAdj = "";
		setModuleId("GICLS271");
		setDocumentTitle("Claim Listing Per User");
		
		function initializeGICLS271(){
			$("txtClaimProcessor").focus();
			$("rdoAsOf").checked = true;
			$("rdoClaimFileDate").checked = true;
			$("txtAsOf").value = getCurrentDate();
			disableFromToFields();
			setPrintButtons(false);
			disableToolbarButton("btnToolbarExecuteQuery");
			disableToolbarButton("btnToolbarEnterQuery");
			objRecovery = new Object();
			onLOV = false;
			inHouAdj = "";
		}
		
		function setPrintButtons(x){
			if(x){
				enableButton("btnPrintReport");
				enableToolbarButton("btnToolbarPrint");
			} else {
				disableButton("btnPrintReport");
				disableToolbarButton("btnToolbarPrint");
				
			}
		}
		
		function disableFromToFields() {
			$("txtAsOf").disabled = false;
			$("imgAsOf").disabled = false;
			$("txtFrom").disabled = true;
			$("txtTo").disabled = true;
			$("imgFrom").disabled = true;
			$("imgTo").disabled = true;
			$("txtFrom").value = "";
			$("txtTo").value = "";
			$("rdoAsOf").checked = true;
			$("txtAsOf").value = getCurrentDate();
			disableDate("imgFrom");
			disableDate("imgTo");
			enableDate("imgAsOf");
			$("txtFrom").setStyle({backgroundColor: '#F0F0F0'});
			$("divFrom").setStyle({backgroundColor: '#F0F0F0'});
			$("txtTo").setStyle({backgroundColor: '#F0F0F0'});
			$("divTo").setStyle({backgroundColor: '#F0F0F0'});
			$("txtAsOf").setStyle({backgroundColor: '#FFFACD'});
			$("divAsOf").setStyle({backgroundColor: '#FFFACD'});
		}
		
		function disableAsOfFields() {
			$("txtFrom").disabled = false;
			$("imgFrom").disabled = false;
			$("imgTo").disabled = false;
			$("txtTo").disabled = false;
			$("txtAsOf").disabled = true;
			$("imgAsOf").disabled = true;
			$("txtAsOf").value = "";
			$("rdoFrom").checked = true;
			disableDate("imgAsOf");
			enableDate("imgFrom");
			enableDate("imgTo");
			$("txtFrom").setStyle({backgroundColor: '#FFFACD'});
			$("divFrom").setStyle({backgroundColor: '#FFFACD'});
			$("txtTo").setStyle({backgroundColor: '#FFFACD'});
			$("divTo").setStyle({backgroundColor: '#FFFACD'});
			$("txtAsOf").setStyle({backgroundColor: '#F0F0F0'});
			$("divAsOf").setStyle({backgroundColor: '#F0F0F0'});
		}
		
		function disableFields() {
			$("rdoAsOf").disable();
			$("txtAsOf").disable();
			$("rdoFrom").disable();
			$("txtFrom").disable();
			$("txtTo").disable();
			$("imgAsOf").disabled = true;
			$("imgFrom").disabled = true;
			$("imgTo").disabled = true;
			disableSearch("imgSearchClaimProcessor");
			disableDate("imgAsOf");
			disableDate("imgFrom");
			disableDate("imgTo");
			$("txtClaimProcessor").readOnly = true;
			$("txtFrom").setStyle({backgroundColor: '#F0F0F0'});
			$("divFrom").setStyle({backgroundColor: '#F0F0F0'});
			$("txtTo").setStyle({backgroundColor: '#F0F0F0'});
			$("divTo").setStyle({backgroundColor: '#F0F0F0'});
			$("txtAsOf").setStyle({backgroundColor: '#F0F0F0'});
			$("divAsOf").setStyle({backgroundColor: '#F0F0F0'});
			disableToolbarButton("btnToolbarExecuteQuery");
		}
		
		function validateRequiredDates(){
			if($("rdoFrom").checked){
				if($("txtFrom").value == ""){
					customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.INFO, "txtFrom");
					return false;	
				}
				else if($("txtTo").value == ""){
					customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.INFO, "txtTo");
					return false;
				}
			}
			return true;
		}
		
		function getParams() {
			var params = "";
			if($("rdoClaimFileDate").checked)
				params = "&searchByOpt=fileDate";
			else
				params = "&searchByOpt=lossDate";
			params = params + "&dateAsOf=" + $("txtAsOf").value + "&dateFrom=" + $("txtFrom").value + "&dateTo=" + $("txtTo").value;
			return params;
		}
		
		function changeSearchByOpt() {
			if($("txtClaimProcessor").readOnly){
				tbgClaimsPerUser.url = contextPath+"/GICLClaimListingInquiryController?action=showClaimListingPerUser&refresh=1&inHouAdj=" + $("txtClaimProcessor").value + getParams();
				tbgClaimsPerUser._refreshList();
				
				if (tbgClaimsPerUser.geniisysRows.length == 0)
					setPrintButtons(false);
				else
					setPrintButtons(true);
			}
		}
		
		function resetForm(){
			$("txtClaimProcessor").clear();
			$("txtClaimProcessor").readOnly = false;
			enableSearch("imgSearchClaimProcessor");
			$("rdoAsOf").enable();
			$("rdoClaimFileDate").checked = true;
			$("rdoLossDate").checked = false;
			$("rdoFrom").disabled = false;
			setDetails(null);
			$("txtTotLossReserve").clear();
			$("txtTotExpenseReserve").clear();
			$("txtTotLossesPaid").clear();
			$("txtTotExpensesPaid").clear();
			tbgClaimsPerUser.url = contextPath+"/GICLClaimListingInquiryController?action=showClaimListingPerUser&refresh=1";
			tbgClaimsPerUser._refreshList();
			disableButton("btnRecoveryDetails");
			disableButton("btnProcHistory");
			disableButton("btnClaimStatusHistory");
			disableButton("btnClaimDetails");
			initializeGICLS271();
		}
		
		function setDetails(rec){
			if(rec!= null) {
				
				objRecovery.claimId = rec.claimId;
				
				if(rec.recoveryDetCount > 0)
					enableButton("btnRecoveryDetails");
				else 
					disableButton("btnRecoveryDetails");
				
				enableButton("btnProcHistory");
				enableButton("btnClaimStatusHistory");
				enableButton("btnClaimDetails");
			} else {
				disableButton("btnRecoveryDetails");
				disableButton("btnProcHistory");
				disableButton("btnClaimStatusHistory");
				disableButton("btnClaimDetails");
			}
			
			$("txtPolicyNo").value = rec == null ? "" : rec.policyNo;
			$("txtAssuredName").value = rec == null ? "" : unescapeHTML2(rec.assdName);
			$("txtLossDte").value = rec == null ? "" : dateFormat(rec.lossDate, "mm-dd-yyyy");
			$("txtFileDate").value = rec == null ? "" : dateFormat(rec.clmFileDate, "mm-dd-yyyy");
		}	
		
		function showGICLS271UserLOV(){
			onLOV = true;
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action : "getClmUserLOV",
					searchString : $("txtClaimProcessor").value,
					page : 1
				},
				title : "List of Users",
				width : 350,
				height : 400,
				columnModel : [{
					id : "id",
					title : "ID",
					width : '0',
					visible: false
				},  {
					id : "inHouAdj",
					title : "User ID",
					width : '335px'
				} ],
				draggable : true,
				autoSelectOneRecord : true,
				filterText : $("txtClaimProcessor").value,
				onSelect : function(row){
					onLOV = false;
					inHouAdj = unescapeHTML2(row.inHouAdj);
					$("txtClaimProcessor").value = unescapeHTML2(row.inHouAdj);
					enableToolbarButton("btnToolbarExecuteQuery");
					enableToolbarButton("btnToolbarEnterQuery");
				},
				onCancel : function(){
					onLOV = false;
					$("txtClaimProcessor").focus();
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtClaimProcessor");
					onLOV = false;
				}
			});
		}
		
		function executeQuery(){
			tbgClaimsPerUser.url = contextPath+"/GICLClaimListingInquiryController?action=showClaimListingPerUser&refresh=1&inHouAdj=" + inHouAdj + getParams();
			tbgClaimsPerUser._refreshList();
			if (tbgClaimsPerUser.geniisysRows.length == 0) {
				customShowMessageBox("Query caused no records to be retrieved. Re-enter.", imgMessage.INFO, "txtClaimProcessor");
				setPrintButtons(false);
			} else
				setPrintButtons(true);
			disableFields();
		}
		
		var jsonClmListPerUser = JSON.parse('${jsonClmListPerUser}');	
		perUserTableModel = {
				options: {
					toolbar: {
						elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
					},
					width: '900px',
					pager: {
					},
					onCellFocus : function(element, value, x, y, id) {
						setDetails(tbgClaimsPerUser.geniisysRows[y]);					
						tbgClaimsPerUser.keys.removeFocus(tbgClaimsPerUser.keys._nCurrentFocus, true);
						tbgClaimsPerUser.keys.releaseKeys();
					},
					onRemoveRowFocus : function(element, value, x, y, id){					
						setDetails(null);
						tbgClaimsPerUser.keys.removeFocus(tbgClaimsPerUser.keys._nCurrentFocus, true);
						tbgClaimsPerUser.keys.releaseKeys();
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
									id : "recoverySw",
									title: "R",
									altTitle : 'With Recovery',
									width: '30px',					
									align : "left",
									titleAlign : "left",
									editable: false,
									defaultValue: false,
									otherValue:false,
									filterOption : true,
									filterOptionType : 'checkbox',
									editor:new MyTableGrid.CellCheckbox({getValueOf : function(value) {
										if (value){
											return"Y";
										}else{
											return"N";
										}
									}})
								},
								{
									id : "claimNo",
									title: "Claim Number",
									filterOption : true,
									width: '163px'
								},
								{
									id : "claimStatDesc",
									title: "Claim Status",
									width: '150px',
									filterOption : true,
									titleAlign : "center"
								},
								{
									id : "lossResAmt",
									title: "Loss Reserve",
									titleAlign : "right",
									width: '130px',
									align : "right",
									geniisysClass: "money",
									filterOption : true,
									filterOptionType : 'number',
									titleAlign : "center"
								},
								{
									id : "expResAmt",
									title: "Expense Reserve",
									titleAlign : "right",
									width: '130px',
									align : "right",
									geniisysClass: "money",
									filterOption : true,
									filterOptionType : 'number',
									titleAlign : "center"
								},
								{
									id : "lossPdAmt",
									title: "Losses Paid",
									titleAlign : "right",
									width: '130px',
									align : "right",
									geniisysClass: "money",
									filterOption : true,
									filterOptionType : 'number',
									titleAlign : "center"
								},
								{
									id : "expPdAmt",
									title: "Expenses Paid",
									titleAlign : "right",
									width: '130px',
									align : "right",
									geniisysClass: "money",
									filterOption : true,
									filterOptionType : 'number',
									titleAlign : "center"
								}
							],
							rows: jsonClmListPerUser.rows
						};
		tbgClaimsPerUser = new MyTableGrid(perUserTableModel);
		tbgClaimsPerUser.pager = jsonClmListPerUser;
		tbgClaimsPerUser.render('perUserTable');
		tbgClaimsPerUser.afterRender = function(){
			setDetails(null);
				if(tbgClaimsPerUser.geniisysRows.length > 0){
				var rec = tbgClaimsPerUser.geniisysRows[0];
				$("txtTotLossReserve").value = formatCurrency(rec.totLossRes);
				$("txtTotExpenseReserve").value = formatCurrency(rec.totExpRes);
				$("txtTotLossesPaid").value = formatCurrency(rec.totLossPd);
				$("txtTotExpensesPaid").value = formatCurrency(rec.totExpPd);
			} else {
				$("txtTotLossReserve").clear();
				$("txtTotExpenseReserve").clear();
				$("txtTotLossesPaid").clear();
				$("txtTotExpensesPaid").clear();
			}	
		};
		
		function showRecoveryDetails() {
			try {
				overlayRecoveryDetails = Overlay.show(contextPath
						+ "/GICLClaimListingInquiryController", {
					urlContent : true,
					urlParameters : {
						action : "showRecoveryDetails",
						ajax : "1",
						claimId : objRecovery.claimId},
					title : "Recovery Details",
					height : 500,
					width : 820,
					draggable : true
				});
			} catch (e) {
				showErrorMessage("Recovery Details Error : ", e);
			}
		}
		
		function showProcessorHistory() {
			try {
				overlayProcessorHistory = Overlay.show(contextPath
						+ "/GICLClaimListingInquiryController", {
					urlContent : true,
					urlParameters : {
						action : "showProcessorHistory",
						ajax : "1",
						claimId : objRecovery.claimId},
					title : "Process History",
					height : 220,
					width : 665,
					draggable : true
				});
			} catch (e) {
				showErrorMessage("overlay error: ", e);
			}
		}
		
		function showClaimStatusHistory() {
			try {
				overlayClaimStatusHistory = Overlay.show(contextPath
						+ "/GICLClaimListingInquiryController", {
					urlContent : true,
					urlParameters : {
						action : "showClaimStatusHistory",
						ajax : "1",
						claimId : objRecovery.claimId},
					title : "Claim Status History",
					height : 220,
					width : 665,
					draggable : true
				});
			} catch (e) {
				showErrorMessage("overlay error: ", e);
			}
		}
		
		function printReport(){
			try {
				var content = contextPath + "/PrintClaimListingInquiryController?action=printReport"
								+"&reportId="+"GICLR271"
								+"&inHouAdj="+$F("txtClaimProcessor")
								+ getParams();
				if("screen" == $F("selDestination")){
					showPdfReport(content, "Claim Listing per User");
				}else if($F("selDestination") == "printer"){
					new Ajax.Request(content, {
						method: "GET",
						parameters : {noOfCopies : $F("txtNoOfCopies"),
						 	 		 printerName : $F("selPrinter")},
						onCreate: showNotice("Processing, please wait..."),	
						asynchronous: true,
						evalScripts: true,
						onComplete: function(response){
							hideNotice();
							if (checkErrorOnResponse(response)){
								
							}
						}
					});
				}else if($F("selDestination") == "file"){
					var fileType = "PDF"; //added by carlo de guzman 3.08.2016
					
					if($("rdoPdf").checked)
						fileType = "PDF";
					else if ($("rdoCsv").checked)
						fileType = "CSV"; // end
						
					new Ajax.Request(content, {
						method: "POST",
						parameters : {destination : "file",
						fileType : fileType},
									  //$("rdoPdf").checked ? "PDF" : "XLS"}, removed carlo de guzman 3.09.2016
						onCreate: showNotice("Generating report, please wait..."),
						asynchronous: true,
						evalScripts: true,
						onComplete: function(response){
							hideNotice();
							if (checkErrorOnResponse(response))
								{if (fileType == "CSV"){  // added by carlo de guzman 3.09.2016
								copyFileToLocal(response, "csv");
								deleteCSVFileFromServer(response.responseText);
								} else // end
								copyFileToLocal(response);
							}
						}
					});
				}else if($F("selDestination") == "local"){
					new Ajax.Request(content, {
						method: "POST",
						parameters : {destination : "local"},
						asynchronous: true,
						evalScripts: true,
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
		
		$("rdoAsOf").observe("click", disableFromToFields);
		$("rdoFrom").observe("click", disableAsOfFields);
		$("btnRecoveryDetails").observe("click", showRecoveryDetails);
		$("btnProcHistory").observe("click", showProcessorHistory);
		$("btnClaimStatusHistory").observe("click", showClaimStatusHistory);
		$("rdoClaimFileDate").observe("click", changeSearchByOpt);
		$("rdoLossDate").observe("click", changeSearchByOpt);
		$("btnToolbarEnterQuery").observe("click", resetForm);
		
		$("btnToolbarExecuteQuery").observe("click", function(){
			if(validateRequiredDates())
				executeQuery();
		});
		
		$("imgAsOf").observe("click", function() {
			if ($("imgAsOf").disabled == true)
				return;
			scwShow($('txtAsOf'), this, null);
		});
		
		$("imgFrom").observe("click", function() {
			if ($("imgFrom").disabled == true)
				return;
			scwShow($('txtFrom'), this, null);
		});
		
		$("imgTo").observe("click", function() {
			if ($("imgTo").disabled == true)
				return;
			scwShow($('txtTo'), this, null);
		});
		
		$("txtClaimProcessor").observe('keypress', function(event){
		    if(event.keyCode == Event.KEY_RETURN) {
		    	if(onLOV)
		    		return;
	    		showGICLS271UserLOV();
		    } else
		    	disableToolbarButton("btnToolbarExecuteQuery");
		});
		
		$("imgSearchClaimProcessor").observe("click", function(){
			if(onLOV)
				return;
			showGICLS271UserLOV();
		});
			
		$("btnClaimDetails").observe("click", function(){
			if(checkUserModule("GICLS271")){ 
				objCLMGlobal.claimId = objRecovery.claimId;
				objCLMGlobal.callingForm = "GICLS271";
				showClaimInformationMain("claimInfoNew");
				$("perUserMainDiv").hide();
			}
			//showMessageBox(objCommonMessage.UNAVAILABLE_MODULE, 'I');
		});
		
		$("btnPrintReport").observe("click", function(){
			showGenericPrintDialog("Print Claim Listing per User",printReport, null, true);
			$("csvOptionDiv").show(); //added by carlo de guzman 3.09.2016
		});
		
		$("btnToolbarPrint").observe("click", function(){
			showGenericPrintDialog("Print Claim Listing per User", printReport, null, true);
			$("csvOptionDiv").show(); //added by carlo de guzman 3.09.2016
		});
		
		$("txtAsOf").observe("focus", function(){
			if ($("imgAsOf").disabled == true) return;
			var asOfDate = $F("txtAsOf") != "" ? new Date($F("txtAsOf").replace(/-/g,"/")) :"";
			var sysdate = new Date();
			if (asOfDate > sysdate && asOfDate != ""){
				customShowMessageBox("Date should not be greater than the current date.", "I", "txtAsOf");
				$("txtAsOf").clear();
				return false;
			}
		});
		
	 	$("txtFrom").observe("focus", function(){
			if ($("imgFrom").disabled == true) return;
			var fromDate = $F("txtFrom") != "" ? new Date($F("txtFrom").replace(/-/g,"/")) :"";
			var sysdate = new Date();
			var toDate = $F("txtTo") != "" ? new Date($F("txtTo").replace(/-/g,"/")) :"";
			if (fromDate > sysdate && fromDate != ""){
				customShowMessageBox("Date should not be greater than the current date.", "I", "txtFrom");
				$("txtFrom").clear();
				$("txtTo").clear();
				return false;
			}
			if (toDate < fromDate && toDate != ""){
				customShowMessageBox("From Date should not be later than To Date.", "I", "txtTo");
				$("txtFrom").clear();
				$("txtTo").clear();
				return false;
			}
		});
	 	
	 	$("txtTo").observe("focus", function(){
			if ($("imgTo").disabled == true) return;
			var toDate = $F("txtTo") != "" ? new Date($F("txtTo").replace(/-/g,"/")) :"";
			var fromDate = $F("txtFrom") != "" ? new Date($F("txtFrom").replace(/-/g,"/")) :"";
			var sysdate = new Date();
			if (toDate > sysdate && toDate != ""){
				customShowMessageBox("Date should not be greater than the current date.", "I", "txtTo");
				$("txtTo").clear();
				return false;
			}
			if (toDate < fromDate && toDate != ""){
				customShowMessageBox("From Date should not be later than To Date.", "I", "txtTo");
				$("txtTo").clear();
				return false;
			}
			if(fromDate=="" && toDate!=""){
				customShowMessageBox("Please enter FROM date first.", "I", "txtTo");
				$("txtTo").clear();
				$("txtFrom").clear();
				return false;
			}
		});
	 	
	 	$("btnExit").observe("click", function() {
			goToModule("/GIISUserController?action=goToClaims","Claims Main", "");
		});
	 	
	 	$("btnToolbarExit").observe("click", function() {
			goToModule("/GIISUserController?action=goToClaims","Claims Main", "");
		});
		
	 	initializeAll();
		initializeGICLS271();
		
	} catch(e){
		showErrorMessage("Error in Claim Listing per User: ", e);
	}
</script>

