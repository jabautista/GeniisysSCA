<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="mainNavPerRecoveryType">
 	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="btnExit">Exit</a></li>
			</ul>
		</div>
	</div>
</div>
<div id="perRecoveryTypeMainDiv" name="perRecoveryTypeMainDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Claim Listing Per Recovery Type</label>
	   	</div>
	</div>	
	<div class="sectionDiv" style="padding: 0 0 10px 0;">
		<div style="float: left;">
			<table style="margin: 10px 10px 5px 40px;">
				<tr>
					<td class="rightAligned">Recovery Type</td>
					<td class="leftAligned">
						<span class="lovSpan" style="width: 400px; margin-right: 30px;">
							<input type="text" id="txtRecoveryType" style="width: 370px; float: left; border: none; height: 14px; margin: 0;" class="" tabindex="101"/>  
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchRecoveryType" alt="Go" style="float: right;" tabindex="102"/>
						</span>
					</td>
				</tr>
			</table>
			<div style="float: left; margin-left: 135px; margin-bottom: 10px;">
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
	</div>
	<div class="sectionDiv" style="margin-bottom: 50px;">
		<div id="perRecoveryTypeTableDiv" style="padding: 10px 0 0 10px;">
			<div id="perRecoveryTypeTable" style="height: 300px; margin-left: auto;"></div>
		</div>
		<div style="margin-top: 20px;">
			<table align="center">
				<tr>
					<td class="rightAligned" style="width: 105px; padding-right: 5px;">Claim Number </td>
					<td class="rightAligned"><input style="width: 300px;" id="txtClaimNo" type="text" readOnly="readonly" tabindex="201"/></td>
					<td style="width: 20px;"></td>
					<td class="rightAligned" style="width: 105px; padding-right: 5px;">Assured Name </td>
					<td class="rightAligned"><input style="width: 300px;" id="txtAssuredName" name="txtAssuredName" type="text" readOnly="readonly" tabindex="203"/></td>
				</tr>
				<tr>										
					<td class="rightAligned" style="padding-right: 5px;">Policy Number</td>
					<td class="rightAligned"><input style="width: 300px;" id="txtPolicyNo" name="txtPolicyNo" type="text" readOnly="readonly" tabindex="202"/></td>
					<td></td>
					<td class="rightAligned" style="padding-right: 5px;">Claim Status</td>
					<td class="rightAligned"><input style="width: 300px;" id="txtClaimStat" name="txtClaimStat" type="text" readOnly="readonly" tabindex="204"/></td>
					
				</tr>
			</table>
		</div>
		<div style="margin: 15px 0 15px 0;">
			<table align="center">
				<tr>
					<td><input type="button" class="disabledButton" id="btnRecoveryDetails" value="Recovery Details" style="width: 120px;" tabindex="301" /></td>
					<td><input type="button" class="button" id="btnPrintReport" name="btnPrintReport" value="Print Report" style="width: 120px;" tabindex="302"/></td>
				</tr>
			</table>
		</div>
	</div>
</div>
<script type="text/javascript">
	try{
		var recTypeCd = "";
		var onLOV = false;
		setDocumentTitle("Claim Listing Per Recovery Type");
		setModuleId("GICLS258");
		
		function initGICLS258(){
			recTypeCd = "";
			onLOV = false;
			$("txtRecoveryType").focus();
			$("rdoAsOf").checked = true;
			$("rdoClaimFileDate").checked = true;
			$("txtAsOf").value = getCurrentDate();
			disableFromToFields();
			objRecovery = new Object();
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
			setPrintButtons(false);
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
		
		function setDetails(rec){
			if(rec != null){
				if(rec.recoveryDetCount > 0){
					enableButton("btnRecoveryDetails");
					objRecovery.claimId = rec.claimId;
					objRecovery.lineCd = rec.lineCd;
					objRecovery.recoveryId = rec.recoveryId;
				}
				else
				{
					disableButton("btnRecoveryDetails");
				}
			} else
			{
				disableButton("btnRecoveryDetails");
			}
			$("txtClaimNo").value = rec == null ? "" : unescapeHTML2(rec.claimNo);
			$("txtPolicyNo").value = rec == null ? "" : unescapeHTML2(rec.policyNo);
			$("txtAssuredName").value = rec == null ? "" : unescapeHTML2(rec.assdName);	
			$("txtClaimStat").value = rec == null ? "" : unescapeHTML2(rec.claimStat);
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
			disableSearch("imgSearchRecoveryType");
			disableDate("imgAsOf");
			disableDate("imgFrom");
			disableDate("imgTo");
			$("txtRecoveryType").readOnly = true;
			$("txtFrom").setStyle({backgroundColor: '#F0F0F0'});
			$("divFrom").setStyle({backgroundColor: '#F0F0F0'});
			$("txtTo").setStyle({backgroundColor: '#F0F0F0'});
			$("divTo").setStyle({backgroundColor: '#F0F0F0'});
			$("txtAsOf").setStyle({backgroundColor: '#F0F0F0'});
			$("divAsOf").setStyle({backgroundColor: '#F0F0F0'});
			disableToolbarButton("btnToolbarExecuteQuery");
		}
		
		function resetForm(){
			$("txtRecoveryType").clear();
			$("txtRecoveryType").enable();
			$("txtRecoveryType").removeAttribute("readonly");
			enableSearch("imgSearchRecoveryType");
			$("rdoAsOf").enable();
			$("rdoClaimFileDate").checked = false;
			$("rdoLossDate").checked = false;
			$("rdoFrom").disabled = false;
			setDetails(null);
			tbgClaimsPerRecoveryType.url = contextPath+"/GICLClaimListingInquiryController?action=showClaimListingPerRecoveryType&refresh=1";
			tbgClaimsPerRecoveryType._refreshList();
			disableButton("btnRecoveryDetails");
			disableButton("btnPrintReport");
			initGICLS258();
		}
		
		function getParams() {
			var params = "";
			params =  params + "&recTypeCd=" + recTypeCd + "&searchByOpt=";
			if($("rdoClaimFileDate").checked)
				params = params + "fileDate";
			else
				params = params + "lossDate";
			params = params + "&dateAsOf=" + $("txtAsOf").value + "&dateFrom=" + $("txtFrom").value + "&dateTo=" + $("txtTo").value;
			return params;
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
		
		function changeSearchByOption() {
			if($("txtRecoveryType").readOnly) {
				tbgClaimsPerRecoveryType.url = contextPath+"/GICLClaimListingInquiryController?action=showClaimListingPerRecoveryType&refresh=1" + getParams();
				tbgClaimsPerRecoveryType._refreshList();
				if (tbgClaimsPerRecoveryType.geniisysRows.length == 0) { //added by steven 03.17.2013
					customShowMessageBox("Query caused no records to be retrieved. Re-enter.", imgMessage.INFO, "txtRecoveryType");
					setPrintButtons(false);
				} else
					setPrintButtons(true);
			}
		}
		
		function showGICLS258RecoveryTypeLOV(){
			onLOV = true;
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action : "getGiisRecoveryTypeLOV",
					searchString : $("txtRecoveryType").value,
					page : 1
				},
				title : "List of Recovery Types",
				width : 435,
				height : 300,
				columnModel : [ {
					id : "recTypeCd",
					title : "Recovery Type Code",
					width : '120px',
				}, {
					id : "recTypeDesc",
					title : "Recovery Type",
					width : '300px'
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText:  $("txtRecoveryType").value,
				onSelect : function(row) {
					onLOV = false;
					recTypeCd = row.recTypeCd;
					$("txtRecoveryType").focus();
					$("txtRecoveryType").value = unescapeHTML2(row.recTypeDesc);
					enableToolbarButton("btnToolbarExecuteQuery");
					enableToolbarButton("btnToolbarEnterQuery");
				},
				onCancel : function() {
					onLOV = false;
					$("txtRecoveryType").focus();
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtRecoveryType");
					onLOV = false;
				}
			});
		}
		
		function executeQuery(){
			tbgClaimsPerRecoveryType.url = contextPath+"/GICLClaimListingInquiryController?action=showClaimListingPerRecoveryType&refresh=1" + getParams();
			tbgClaimsPerRecoveryType._refreshList();
			if (tbgClaimsPerRecoveryType.geniisysRows.length == 0) {
				customShowMessageBox("Query caused no records to be retrieved. Re-enter.", imgMessage.INFO, "txtRecoveryType");
				setPrintButtons(false);
			} else
				setPrintButtons(true);
			disableFields();
		}
		
		function showRecoveryDetails() {
			try {
				overlayRecoveryDetails = Overlay.show(contextPath
						+ "/GICLClaimListingInquiryController", {
					urlContent : true,
					urlParameters : {
						action : "showGICLS258Details",
						ajax : "1",
						claimId : objRecovery.claimId,
						lineCd  : objRecovery.lineCd,
						recoveryId : objRecovery.recoveryId
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
		
		var jsonClmListPerRecoveryType = JSON.parse('${jsonClmListPerRecoveryType}');		
		perRecoveryTypeTableModel = {
				url : contextPath+"/GICLClaimListingInquiryController?action=showClaimListingPerRecoveryType&refresh=1",
				options: {
					toolbar: {
						elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
					},
					width: '900px',
					height: '275px',
					onCellFocus : function(element, value, x, y, id) {
						setDetails(tbgClaimsPerRecoveryType.geniisysRows[y]);					
						tbgClaimsPerRecoveryType.keys.removeFocus(tbgClaimsPerRecoveryType.keys._nCurrentFocus, true);
						tbgClaimsPerRecoveryType.keys.releaseKeys();
					},
					onRemoveRowFocus : function(element, value, x, y, id){					
						setDetails(null);
						tbgClaimsPerRecoveryType.keys.removeFocus(tbgClaimsPerRecoveryType.keys._nCurrentFocus, true);
						tbgClaimsPerRecoveryType.keys.releaseKeys();
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
						width: '140px',
						filterOption : true
					},				
					{
						id : "payorClass",
						title: "Payor Class",
						width: '151px',
						filterOption : true
					},				
					{
						id : "payorName",
						title: "Payor",
						width: '350px',
						filterOption : true
					},				
					{
						id : "fileDate",
						title: "File Date",
						width: '113px',
						filterOption : true,
						filterOptionType : 'formattedDate',
						renderer: function (value){
							return dateFormat(value, "mm-dd-yyyy");
						}
					},				
					{
						id : "lossDate",
						title: "Loss Date",
						width: '113px',
						filterOption : true,
						filterOptionType : 'formattedDate',
						renderer: function (value){
							return dateFormat(value, "mm-dd-yyyy");
						}
					}
					
				],
				rows: jsonClmListPerRecoveryType.rows
			};
		
		tbgClaimsPerRecoveryType = new MyTableGrid(perRecoveryTypeTableModel);
		tbgClaimsPerRecoveryType.pager = jsonClmListPerRecoveryType;
		tbgClaimsPerRecoveryType.render('perRecoveryTypeTable');
		tbgClaimsPerRecoveryType.afterRender = function() {
			setDetails(null);
		};
		
		$("btnToolbarEnterQuery").observe("click", resetForm);
		$("rdoAsOf").observe("click", disableFromToFields);
		$("rdoFrom").observe("click", disableAsOfFields);
		$("rdoClaimFileDate").observe("click", changeSearchByOption);
		$("rdoLossDate").observe("click", changeSearchByOption);
		$("btnRecoveryDetails").observe("click", showRecoveryDetails);
		
		$("btnToolbarExecuteQuery").observe("click", function(){
			if(onLOV)
				return;
			if(validateRequiredDates())
				executeQuery();
		});
		
		$("btnExit").observe("click", function(){
			goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
		});
		
		$("btnToolbarExit").observe("click", function(){
			goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
		});

		$("imgSearchRecoveryType").observe("click", function(){
			if(onLOV)
				return;
			showGICLS258RecoveryTypeLOV();
		});
		
		$("txtRecoveryType").observe('keypress', function(event){
		    if(event.keyCode == Event.KEY_RETURN) {
		    	if(onLOV)
		    		return;
				showGICLS258RecoveryTypeLOV();
		    } else
		    	disableToolbarButton("btnToolbarExecuteQuery");
		});
		
		$("imgSearchRecoveryType").observe('keypress', function(event){
			if(event.keyCode == Event.KEY_RETURN) {
				if(onLOV)
					return;
				showGICLS258RecoveryTypeLOV();
		    }
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
		
		$("btnPrintReport").observe("click", function(){
			showGenericPrintDialog("Print Claim Listing per Recovery Type", doPrint, "", true);
		});
		
		$("btnToolbarPrint").observe("click", function(){
			showGenericPrintDialog("Print Claim Listing per Recovery Type", doPrint, "", true);
		});
		
		var reports = [];
		function doPrint(){
			var content;
			var searchBy;
			if($("rdoClaimFileDate").checked){
				searchBy = $("rdoAsOf").checked ? "1" : "2";
			}else{
				searchBy = $("rdoAsOf").checked ? "3" : "6";
			}
			content = contextPath+"/PrintClaimListingInquiryController?action=printReport&reportId=GICLR258&printerName="+$F("selPrinter")+"&searchBy="+searchBy+getParams();
			if($F("selDestination") == "screen"){
				reports.push({reportUrl : content, reportTitle : "Claim Listing Per Recovery Type"});		
				showMultiPdfReport(reports);
				reports = [];
			}else if($F("selDestination") == "printer"){
				new Ajax.Request(content, {
					method: "GET",
					parameters : {noOfCopies : $F("txtNoOfCopies"),
							 	 printerName : $F("selPrinter")
							 	 },
					evalScripts: true,
					asynchronous: true,
					onComplete: function(response){
						if (checkErrorOnResponse(response)){
						
						}
					}
				});
			}else if($F("selDestination") == "file"){
				new Ajax.Request(content, {
					method: "POST",
					parameters : {destination : "file",
								  fileType    : $("rdoPdf").checked ? "PDF" : "XLS"},
					evalScripts: true,
					asynchronous: true,
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
					method: "POST",
					parameters : {destination : "local"},
					evalScripts: true,
					asynchronous: true,
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
			
		}
		
		$("btnExit").observe("click", function(){
			goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
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
		
	 	initializeAll();
		initGICLS258();
		
	}catch(e){
		showErrorMessage("Error : " , e);	
	}
</script>