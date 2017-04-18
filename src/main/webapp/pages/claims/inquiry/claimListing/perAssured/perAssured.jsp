<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="perAssuredMainDiv" name="perAssuredMainDiv">
	<div id="perAssuredSubMenu">
	 	<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="perAssuredExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Claim Listing per Assured</label>
	   	</div>
	</div>	
	<div class="sectionDiv" style="padding: 0 0 10px 0;">
		<div style="float: left;">
			<div id="assuredDiv">
				<table style="margin: 10px 10px 5px 16px;">
					<tr>
						<td class="rightAligned" width="50px"><span id="spanNameSearchOpt">Name</span></td>
						<td class="leftAligned">
							<span class="lovSpan required" style="width: 491px; margin-right: 0px;">
								<input type="text" id="txtFreeText" ignoreDelKey="true" style="width: 450px; float: left; border: none; height: 14px; margin: 0;" class="required" tabindex="101"/> 
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchAssured" alt="Go" style="float: right;" tabindex="102"/>
							</span>
						</td>
					</tr>
				</table>
			</div>
			<div style="float: left; margin-left: 72px; margin-bottom: 10px;">
				<table>
					<tr>
						<td>
							<fieldset style="width: 200px; height: 48px;">
								<legend>Name Search Option</legend>
								<table align="center">
									<tr>
										<td class="rightAligned">
											<input type="radio" name="nameSearchBy" id="rdoFreeText" style="float: left; margin: 3px 10px 0px 10px" tabindex="103" />
											<label for="rdoFreeText" style="float: left; height: 20px; padding-top: 3px;">Free Text</label>
										</td>
										<td class="rightAligned">
											<input type="radio" name="nameSearchBy" id="rdoAssured" style="float: left; margin: 3px 10px 0px 30px" tabindex="104" />
											<label for="rdoAssured" style="float: left; height: 20px; padding-top: 3px;">Assured</label>
										</td>
									</tr>
								</table>
							</fieldset>
						</td>
						<td>
							<fieldset style="width: 250px; height:48px;">
								<legend>Search By</legend>
								<table align="center">
									<tr>
										<td class="rightAligned">
											<input type="radio" name="searchBy" id="rdoClaimFileDate" style="float: left; margin: 3px 10px 0px 10px" tabindex="105" />
											<label for="rdoClaimFileDate" style="float: left; height: 20px; padding-top: 3px;" title="Claim File Date">Claim File Date</label>
										</td>
										<td class="rightAligned">
											<input type="radio" name="searchBy" id="rdoLossDate" style="float: left; margin: 3px 10px 0px 30px" tabindex="106" />
											<label for="rdoLossDate" style="float: left; height: 20px; padding-top: 3px;" title="Loss Date">Loss Date</label>
										</td>
									</tr>
								</table>
							</fieldset>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div class="sectionDiv" style="float: right; width: 255px; margin: 12px 60px 0 0;">
			<table style="margin: 8px;">	
				<tr>
					<td class="rightAligned"><input type="radio" name="byDate" id="rdoAsOf" title="As of" style="float: left;" tabindex="107"/><label for="rdoAsOf" title="As of" style="float: left; height: 20px; padding-top: 3px;">As of</label></td>
					<td class="leftAligned">
						<div style="float: left; width: 165px;" class="withIconDiv" id="divAsOf">
							<input type="text" removeStyle="true" id="txtAsOf" class="withIcon" readonly="readonly" style="width: 140px;" tabindex="108"/>
							<img id="imgAsOf" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="As of Date" tabindex="109"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned"><input type="radio" name="byDate" id="rdoFrom" title="From" style="float: left;" tabindex="110"/><label for="rdoFrom" style="float: left; height: 20px; padding-top: 3px;">From</label></td>
					<td class="leftAligned">
						<div style="float: left; width: 165px;" class="withIconDiv" id="divFrom">
							<input type="text" removeStyle="true" id="txtFrom" class="withIcon" readonly="readonly" style="width: 140px;" tabindex="111"/>
							<img id="imgFrom" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="From Date" tabindex="112"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">To</td>
					<td class="leftAligned">
						<div style="float: left; width: 165px;" class="withIconDiv" id="divTo">
							<input type="text" removeStyle="true" id="txtTo" class="withIcon" readonly="readonly" style="width: 140px;" tabindex="113"/>
							<img id="imgTo" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="To Date" tabindex="114"/>
						</div>
					</td>
				</tr>
			</table>
		</div>
	</div>		
	<div class="sectionDiv" style="margin-bottom: 50px;">
		<div id="perAssuredTableDiv" style="padding: 10px 0 0 10px;">
			<div id="perAssuredTable" style="height: 300px; margin-left: auto;"></div>
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
					<td class="rightAligned">File Date</td>
					<td class="leftAligned"><input type="text" id="txtFileDate" style="width: 230px;" readonly="readonly" tabindex="303"/></td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 110px;">Claim Status</td>
					<td class="leftAligned"><input type="text" id="txtClaimStatus" style="width: 370px;" readonly="readonly" tabindex="302"/></td>
					<td></td>
					<td class="rightAligned">Loss Date</td>
					<td class="leftAligned"><input type="text" id="txtLossDate" style="width: 230px;" readonly="readonly" tabindex="304"/></td>
				</tr>
				<tr id="tblRowAssuredName">
					<td class="rightAligned">
						Assured
					</td>
					<td colspan="4" class="leftAligned">
						<input type="text" id="txtAssuredName" style="width: 99%" readonly="readonly" tabindex="305"/>
					</td>
				</tr>			
			</table>
		</div>
		<div style="float: left; width: 100%; margin-bottom: 10px;" align="center">
			<input type="button" class="button" id="btnPrintReport" value="Print Report" tabindex="401"/>
		</div>	
	</div>
</div>
<script type="text/javascript">
	try{
		
		$("mainNav").hide();
		
		setModuleId("GICLS251");
		setDocumentTitle("Claim Listing Per Assured");
		var assdNo = "";
		var freeText = "";
		var recoveryDetailsCount = 0;
		var onLOV = false;
		
		$("mainNav").hide();
		
		function initGICLS251(){
			assdNo = "";
			freeText = "";
			recoveryDetailsCount = 0;
			onLOV = false;
			$("txtFreeText").focus();
			$("rdoAsOf").checked = true;
			$("rdoClaimFileDate").checked = true;
			$("txtAsOf").value = getCurrentDate();
			$("rdoFreeText").checked = true;
			toggleNameSearchOption();
			disableFromToFields();
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
			setPrintButtons(false);
			objRecovery = new Object();
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
		
		function showGICLS251AssuredLOV() {
			onLOV = true;
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action : "getGICLS251Lov",
					searchString : $("txtFreeText").value,
					page : 1,
					controlModule : "GICLS251"
				},
				title : "List of Assured",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "assdNo",
					title : "Assured No.",
					width : '120px',
				}, {
					id : "assdName",
					title : "Assured Name",
					width : '345px',
					renderer: function(value) {
						return unescapeHTML2(value).replace(/ /g, "&nbsp;");
					}
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText:  $("txtFreeText").value,
				onSelect : function(row) {
					recoveryDetailsCount = row.recoveryDetailsCount;
					onLOV = false;
					assdNo = row.assdNo;
					freeText = unescapeHTML2(row.assdName);
					$("txtFreeText").value = freeText;
					enableToolbarButton("btnToolbarEnterQuery");
					enableToolbarButton("btnToolbarExecuteQuery");
				},
				onCancel : function () {
					onLOV = false;
					$("txtFreeText").focus();
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtFreeText");
					onLOV = false;
				}
			});
		}
		
		function toggleNameSearchOption(){
			if($("rdoFreeText").checked){
				$("spanNameSearchOpt").innerHTML = "Name";
				$("imgSearchAssured").hide();
				$("tblRowAssuredName").show();
				if($("txtFreeText").value != "")
					enableToolbarButton("btnToolbarExecuteQuery");
				else{
					disableToolbarButton("btnToolbarExecuteQuery");
				}
			}
			
			if($("rdoAssured").checked){
				$("spanNameSearchOpt").innerHTML = "Assured";
				$("imgSearchAssured").show();
				$("tblRowAssuredName").hide();
				if(assdNo != "")
					enableToolbarButton("btnToolbarExecuteQuery");
				else{
					disableToolbarButton("btnToolbarExecuteQuery");	
				}
			}
		}
		
		function executeQuery(){
			if($("rdoFreeText").checked){
				tbgClaimsPerAssured.url = contextPath+"/GICLClaimListingInquiryController?action=showPerAssuredFreeText&refresh=1&txtFreeText=" + encodeURIComponent($F("txtFreeText")) + getParams();
			}
			
			if($("rdoAssured").checked){
				tbgClaimsPerAssured.url = contextPath+"/GICLClaimListingInquiryController?action=showClaimListingPerAssured&refresh=1&assdNo=" +assdNo + getParams();
			}
			
			tbgClaimsPerAssured._refreshList();
			if (tbgClaimsPerAssured.geniisysRows.length == 0){
				customShowMessageBox("Query caused no records to be retrieved. Re-enter.", imgMessage.INFO, "txtFreeText");
				//$("rdoClaimFileDate").disable();
				//$("rdoLossDate").disable();
				setPrintButtons(false);
			} else {
				setPrintButtons(true);
			}
			disableFields();
			enableToolbarButton("btnToolbarEnterQuery");
		}
		
		function setDetails(rec) {
			if(rec!=null){
				$("txtPolicyNo").value = rec.policyNumber;
				$("txtClaimStatus").value = rec.clmStatDesc;
				$("txtLossDate").value = dateFormat(rec.lossDate, "mm-dd-yyyy");
				$("txtFileDate").value = dateFormat(rec.claimFileDate, "mm-dd-yyyy");
				if($("tblRowAssuredName").getStyle('display') != 'none');
					$("txtAssuredName").value = rec.assdNo + " - " + unescapeHTML2(rec.assuredName);
				/* if(rec.recoverySw == 'Y'){
					objRecovery.claimId = rec.claimId;
					enableButton("btnRecoveryDetails");
				} else {
					objRecovery.claimId = '';
					disableButton("btnRecoveryDetails");
				} */
					
				if(rec.recoveryDetCount > 0){
					objRecovery.claimId = rec.claimId;
					enableButton("btnRecoveryDetails");
				} else {
					disableButton("btnRecoveryDetails");
				}
			} else {
				$("txtPolicyNo").clear();
				$("txtClaimStatus").clear();
				$("txtLossDate").clear();
				$("txtFileDate").clear();
				$("txtAssuredName").clear();
				disableButton("btnRecoveryDetails");
			}
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
			$("txtAsOf").setStyle({backgroundColor: 'white'});
			$("divAsOf").setStyle({backgroundColor: 'white'});
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
			disableSearch("imgSearchAssured");
			disableDate("imgAsOf");
			disableDate("imgFrom");
			disableDate("imgTo");
			$("txtFreeText").readOnly = true;
			$("txtFrom").setStyle({backgroundColor: '#F0F0F0'});
			$("divFrom").setStyle({backgroundColor: '#F0F0F0'});
			$("txtTo").setStyle({backgroundColor: '#F0F0F0'});
			$("divTo").setStyle({backgroundColor: '#F0F0F0'});
			$("txtAsOf").setStyle({backgroundColor: '#F0F0F0'});
			$("divAsOf").setStyle({backgroundColor: '#F0F0F0'});
			disableToolbarButton("btnToolbarExecuteQuery");
			$("rdoFreeText").disable();
			$("rdoAssured").disable();
		}
		
		observeBackSpaceOnDate("txtAsOf");
		observeBackSpaceOnDate("txtFrom");
		observeBackSpaceOnDate("txtTo");
		
		$("rdoFreeText").observe("click", toggleNameSearchOption);
		$("rdoAssured").observe("click", toggleNameSearchOption);
		
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
				customShowMessageBox("TO Date should not be less than the FROM date.", "I", "txtTo");
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
				customShowMessageBox("TO Date should not be less than the FROM date.", "I", "txtTo");
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
		
		function changeSearchByOpt() {
			if($("txtFreeText").readOnly){
				if($("rdoFreeText").checked){
					tbgClaimsPerAssured.url = contextPath+"/GICLClaimListingInquiryController?action=showPerAssuredFreeText&refresh=1&txtFreeText=" + encodeURIComponent($F("txtFreeText")) + getParams();
				}
				
				if($("rdoAssured").checked){
					tbgClaimsPerAssured.url = contextPath+"/GICLClaimListingInquiryController?action=showClaimListingPerAssured&refresh=1&assdNo=" +assdNo + getParams();
				}
				tbgClaimsPerAssured._refreshList();
				
				if (tbgClaimsPerAssured.geniisysRows.length == 0){
					setPrintButtons(false);
				} else {
					setPrintButtons(true);
				}
			}
		}
		
		function resetForm(){
			$("rdoAsOf").enable();
			$("rdoFrom").enable();
			$("txtFreeText").clear();
			$("txtFreeText").readOnly = false;
			enableSearch("imgSearchAssured");
			setDetails(null);
			$("txtTotLossReserve").clear();
			$("txtTotExpenseReserve").clear();
			$("txtTotLossesPaid").clear();
			$("txtTotExpensesPaid").clear();
			tbgClaimsPerAssured.url = contextPath+"/GICLClaimListingInquiryController?action=showClaimListingPerAssured&refresh=1";
			tbgClaimsPerAssured._refreshList();
			disableButton("btnRecoveryDetails");
			$("rdoFreeText").enable();
			$("rdoAssured").enable();
			$("rdoFreeText").check = true;
			$("rdoClaimFileDate").enable();
			$("rdoLossDate").enable();
			initGICLS251();
		}
		
		function showRecoveryDetails() {
			try {
			overlayRecoveryDetails = 
				Overlay.show(contextPath+"/GICLClaimListingInquiryController", {
					urlContent: true,
					urlParameters: {action : "showRecoveryDetails",																
									ajax : "1",
									claimId : objRecovery.claimId
					},
				    title: "Recovery Details",
				    height: 500,
				    width: 820,
				    draggable: true
				});
			} catch (e) {
				showErrorMessage("overlay error: " , e);
			}
		}
		
		var jsonClmListPerAssured = JSON.parse('${jsonClmListPerAssured}');
		perAssuredTableModel = {
				options: {
					toolbar: {
						elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
					},
					width: '900px',
					height: '275px',
					onCellFocus : function(element, value, x, y, id) {
						setDetails(tbgClaimsPerAssured.geniisysRows[y]);					
						tbgClaimsPerAssured.keys.removeFocus(tbgClaimsPerAssured.keys._nCurrentFocus, true);
						tbgClaimsPerAssured.keys.releaseKeys();
					},
					onRemoveRowFocus : function(element, value, x, y, id){					
						setDetails(null);
						tbgClaimsPerAssured.keys.removeFocus(tbgClaimsPerAssured.keys._nCurrentFocus, true);
						tbgClaimsPerAssured.keys.releaseKeys();
					},
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
						id : "claimNumber",
						title: "Claim Number",
						width: '155px',
						filterOption : true
					},
					{
						id : "freeText",
						title: "Assured/Item/Group Item",
						width: '273px',
						filterOption : true,
						renderer : function(val) {
							return unescapeHTML2(val).replace(/ /g, "&nbsp;");
						}
					},
					{
						id : "lossReserve",
						title: "Loss Reserve",
						width: '100px',
						align : "right",
						titleAlign : "right",
						filterOption : true,
						geniisysClass : 'money',
						filterOptionType : 'number'

					},
					{
						id : "expenseReserve",
						title: "Expense Reserve",
						width: '115px',
						align : "right",
						titleAlign : "right",
						filterOption : true,
						geniisysClass : 'money',
						filterOptionType : 'number'
					},
					{
						id : "lossesPaid",
						title: "Losses Paid",
						width: '90px',
						align : "right",
						titleAlign : "right",
						filterOption : true,
						geniisysClass : 'money',
						filterOptionType : 'number'
					},
					{
						id : "expensesPaid",
						title: "Expenses Paid",
						width: '100px',
						align : "right",
						titleAlign : "right",
						filterOption : true,
						geniisysClass : 'money',
						filterOptionType : 'number'
					}
				],
				rows: jsonClmListPerAssured.rows
			};
		
		tbgClaimsPerAssured = new MyTableGrid(perAssuredTableModel);
		tbgClaimsPerAssured.pager = jsonClmListPerAssured;
		tbgClaimsPerAssured.render('perAssuredTable');
		tbgClaimsPerAssured.afterRender = function() {
			try{
				setDetails(null);
				if(tbgClaimsPerAssured.geniisysRows.length > 0){
					var rec = tbgClaimsPerAssured.geniisysRows[0];
					$("txtTotLossReserve").value = formatCurrency(rec.totLossResAmt);
					$("txtTotExpenseReserve").value = formatCurrency(rec.totExpResAmt);
					$("txtTotLossesPaid").value = formatCurrency(rec.totLossPaidAmt);
					$("txtTotExpensesPaid").value = formatCurrency(rec.totExpPaidAmt);
					
					if($("rdoFreeText").checked){
						recoveryDetailsCount = tbgClaimsPerAssured.geniisysRows[tbgClaimsPerAssured.geniisysRows.length - 1].totRecoveryDetCount;	
					}
					
					/* 
					//
					
					if(recoveryDetailsCount > 0) 
						var rec = tbgClaimsPerAssured.geniisysRows[0];
						$("txtTotLossReserve").value = formatCurrency(rec.totLossResAmt);
						$("txtTotExpenseReserve").value = formatCurrency(rec.totExpResAmt);
						$("txtTotLossesPaid").value = formatCurrency(rec.totLossPaidAmt);
						$("txtTotExpensesPaid").value = formatCurrency(rec.totExpPaidAmt);	 */
					
				} else {
					$("txtTotLossReserve").clear();
					$("txtTotExpenseReserve").clear();
					$("txtTotLossesPaid").clear();
					$("txtTotExpensesPaid").clear();
				}	
			} catch (e) {
				showMessageBox("Error : " + e.message, "E");
			}
		};
		
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
		
		var reports = [];
		function checkReport(){
			if(!$("chkClaimListing").checked && !$("chkRecoveryListing").checked){
				customShowMessageBox("Please choose which report you want to print.", imgMessage.ERROR, 'btnPrint');
				return false;
			}
			
			var reportId = [];
			
			if($("rdoFreeText").checked){
				if($("chkClaimListing").checked)
					reportId.push("GICLR251B");
				if($("chkRecoveryListing").checked)
					reportId.push("GICLR251C");
			} else if($("rdoAssured").checked){
				if($("chkClaimListing").checked)
					reportId.push("GICLR251");
				if($("chkRecoveryListing").checked)
					reportId.push("GICLR251A");
			}
			
			for(var i=0; i < reportId.length; i++){
				printReport(reportId[i]);	
			}
			
			if ("screen" == $F("selDestination")) {
				showMultiPdfReport(reports);
				reports = [];
			}
		}
		
		function printReport(reportId){
			try {
				var content = contextPath + "/PrintClaimListingInquiryController?action=printReport"
						                  + "&reportId=" + reportId
						                  + "&moduleId=GICLS251"
						                  + "&freeText=" + encodeURIComponent($F("txtFreeText"))
						                  + "&assdNo=" + assdNo
						                  + getParams()
						                  + "&noOfCopies=" + $F("txtNoOfCopies")
						                  + "&printerName=" + $F("selPrinter")
						                  + "&destination=" + $F("selDestination");
				
				if(reportId == "GICLR251B" || reportId == "GICLR251")
					reptTitle = "Claim Listing per Assured";
				else if (reportId == "GICLR251C" || reportId == "GICLR251A")
					reptTitle = "Recovery Listing per Assured";
				
				if("screen" == $F("selDestination")){
					reports.push({reportUrl : content, reportTitle : reptTitle});
				}else if($F("selDestination") == "printer"){
					new Ajax.Request(content, {
						parameters : {noOfCopies : $F("txtNoOfCopies")},
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
		
		function addCheckbox(){
			var htmlCode = "<table cellspacing='10px' style='margin: 10px;'><tr><td><input type='checkbox' id='chkClaimListing' checked='checked' /></td><td><label for='chkClaimListing'>Claim Listing Per Assured</label></td></tr><tr><td><input type='checkbox' checked='checked' id='chkRecoveryListing' /></td><td><label for='chkRecoveryListing'>Recovery Listing Per Assured</label></td></tr></table>"; 
			
			$("printDialogFormDiv2").update(htmlCode); 
			$("printDialogFormDiv2").show();
			$("printDialogMainDiv").up("div",1).style.height = "248px";
			$($("printDialogMainDiv").up("div",1).id).up("div",0).style.height = "280px";
			
			if(recoveryDetailsCount == 0){
				$("chkRecoveryListing").checked = false;
				$("chkRecoveryListing").disable();
			}
				
		}
		
		$("rdoClaimFileDate").observe("click", changeSearchByOpt);
		$("rdoLossDate").observe("click", changeSearchByOpt);
		$("btnRecoveryDetails").observe("click", showRecoveryDetails);
		$("btnToolbarEnterQuery").observe("click", resetForm);
		$("rdoAsOf").observe("click", disableFromToFields);
		$("rdoFrom").observe("click", disableAsOfFields);
		$("btnToolbarExecuteQuery").observe("click", function(){
			if(validateRequiredDates())
				executeQuery();
		});
		
		$("txtFreeText").observe('keypress', function(event){
			enableToolbarButton("btnToolbarEnterQuery");
			if($("rdoAssured").checked){
			    if(event.keyCode == Event.KEY_RETURN) {
			    	if(onLOV || $("txtFreeText").readOnly || assdNo != "")
			    		return;
			    	showGICLS251AssuredLOV();
			    } else if(event.keyCode == 0 || event.keyCode == 8) {
			    	disableToolbarButton("btnToolbarExecuteQuery");
			    	assdNo = "";
			    	recoveryDetailsCount = 0;
			    }
			} else {
				if(event.keyCode == 0 || event.keyCode == 8){
					enableToolbarButton("btnToolbarExecuteQuery");
					assdNo = "";
				}
			}
		});
		
		$("imgSearchAssured").observe("click", function(){
			if(onLOV || $("txtFreeText").readOnly  || assdNo != "")
	    		return;
	    	showGICLS251AssuredLOV();
		});
		
		$("perAssuredExit").observe("click", function(){
			goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
		});
		
		$("btnToolbarExit").observe("click", function(){
			goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
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
		
		$("txtAsOf").observe("blur", function(){
			if($("txtAsOf").value == "")
				$("txtAsOf").value = getCurrentDate();
		});
		
		$("btnToolbarPrint").observe("click", function(){
			showGenericPrintDialog("Print Claim Listing / Recovery Listing per Assured", checkReport, addCheckbox, true);
		});
		
		$("btnPrintReport").observe("click", function(){
			 showGenericPrintDialog("Print Claim Listing / Recovery Listing  per Assured", checkReport, addCheckbox, true);
		});
		
		initializeAll();
		initGICLS251();
		
	} catch(e) {
		showErrorMessage("Error : " , e);
	}

</script>