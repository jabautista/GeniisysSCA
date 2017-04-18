<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="mainNavPerIntermediary">
 	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="btnExit">Exit</a></li>
			</ul>
		</div>
	</div>
</div>
<div id="claimListingPerIntermediaryMainDiv" name="claimListingPerIntermediaryMainDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Claim Listing per Intermediary</label>
	   		<!-- <span class="refreshers" style="margin-top: 0;">
	 			<label id="btnReloadForm" name="gro" style="margin-left: 5px;">Reload Form</label>
			</span> -->
	   	</div>
	</div>	
	<div id="claimListingPerIntermediaryDiv" align="center">
		<div class="sectionDiv" style="padding: 0 0 10px 0;">
			<div style="float: left;">
				<table style="margin: 10px 10px 5px 31px;">
					<tr>
						<td class="rightAligned">Intermediary</td>
						<td class="leftAligned">
							<span class="lovSpan" style="width: 400px; margin-right: 30px;">
								<input type="text" id="txtIntermediary" ignoreDelKey="true" style="width: 370px; float: left; border: none; height: 14px; margin: 0;" class="" tabindex="101"/>  
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchIntermediary" alt="Go" style="float: right;" tabindex="102"/>
							</span>
						</td>
					</tr>
				</table>
				<div style="float: left; margin-left: 115px; margin-bottom: 10px;">
					<fieldset style="width: 385px;">
						<legend>Search By</legend>
						<table>
							<tr>
								<td class="rightAligned">
									<input type="radio" name="searchBy" id="rdoClaimFileDate" style="float: left; margin: 3px 2px 3px 40px;" tabindex="103" />
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
	
	
	<div class ="sectionDiv" align="center" style="margin-bottom: 50px;">
		<div id="perIntermediaryTableDiv" style="padding: 10px 0 0 10px;">
			<div id="perIntermediaryTable" style="height: 300px; margin-left: auto;"></div>
		</div>
		<div>			
			<table align="center" border="0" style="margin-bottom: 10px; margin-top: 10px;">
				<tr>
					<td><input type="button" class="disabledButton" id="btnClaimDetails" value="Claim Details" tabindex="201" /></td>
					<td><input type="button" class="disabledButton" id="btnRecoveryDetails" value="Recovery Details"  tabindex="202"/></td>
					<td><input type="button" class="disabledButton" id="btnPrintReport" name="btnPrintReportPerIntermediary" value="Print Report" tabindex="203" /></td>
				</tr>
			</table>
		</div>
	</div>	
</div>
<script type="text/javascript">
	try {
		setModuleId("GICLS266");
		setDocumentTitle("Claim Listing Per Intermediary");
		$("mainNav").hide();
		var onLOV = false;
		var recoveryDetailsCount = 0;
		
		$("mainNav").hide();
		
		function initializeGICLS266(){		
			$("txtIntermediary").focus();
			$("rdoAsOf").checked = true;
			$("rdoClaimFileDate").checked = true;
			$("txtAsOf").value = getCurrentDate();
			disableFromToFields();
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
			setPrintButtons(false);
			objPerIntm = new Object();
			objRecovery = new Object();
			objPerIntm.intmNo = "";
			recoveryDetailsCount = 0;
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
			disableSearch("imgSearchIntermediary");
			$("txtIntermediary").readOnly = true;
			disableDate("imgAsOf");
			disableDate("imgFrom");
			disableDate("imgTo");
			$("txtFrom").setStyle({backgroundColor: '#F0F0F0'});
			$("divFrom").setStyle({backgroundColor: '#F0F0F0'});
			$("txtTo").setStyle({backgroundColor: '#F0F0F0'});
			$("divTo").setStyle({backgroundColor: '#F0F0F0'});
			$("txtAsOf").setStyle({backgroundColor: '#F0F0F0'});
			$("divAsOf").setStyle({backgroundColor: '#F0F0F0'});
			disableToolbarButton("btnToolbarExecuteQuery");
		}
		
		observeBackSpaceOnDate("txtAsOf");
		observeBackSpaceOnDate("txtFrom");
		observeBackSpaceOnDate("txtTo");
		
		function getParams() {
			var params = "";
			if($("rdoClaimFileDate").checked)
				params = "&searchByOpt=fileDate";
			else
				params = "&searchByOpt=lossDate";
			
			params = params + "&dateAsOf=" + $("txtAsOf").value + "&dateFrom=" + $("txtFrom").value + "&dateTo=" + $("txtTo").value;
			return params;
		}
		
		function changeSearchByOpt(){
			if($("txtIntermediary").readOnly){
				tbgClaimsPerIntermediary.url = contextPath+"/GICLClaimListingInquiryController?action=showClaimListingPerIntermediary&refresh=1&intmNo="+objPerIntm.intmNo + getParams();
				tbgClaimsPerIntermediary._refreshList();
				if (tbgClaimsPerIntermediary.geniisysRows.length == 0){
					setPrintButtons(false);
				} else {
					setPrintButtons(true);
				}
			}
		}
		
		function resetForm(){
			setPrintButtons(false);
			$("txtIntermediary").clear();
			$("txtIntermediary").enable();
			$("txtIntermediary").removeAttribute("readonly");
			enableSearch("imgSearchIntermediary");
			$("rdoAsOf").enable();
			$("rdoClaimFileDate").checked = false;
			$("rdoLossDate").checked = false;
			$("rdoFrom").disabled = false;
			setDetails(null);
			tbgClaimsPerIntermediary.url = contextPath+"/GICLClaimListingInquiryController?action=showClaimListingPerIntermediary&refresh=1";
			tbgClaimsPerIntermediary._refreshList();
			disableButton("btnRecoveryDetails");
			disableButton("btnClaimDetails");
			initializeGICLS266();
		}
		
		function executeQuery(){
			tbgClaimsPerIntermediary.url = contextPath+"/GICLClaimListingInquiryController?action=showClaimListingPerIntermediary&refresh=1&intmNo=" + objPerIntm.intmNo + getParams();
			tbgClaimsPerIntermediary._refreshList();			
			if (tbgClaimsPerIntermediary.geniisysRows.length == 0){
				customShowMessageBox("Query caused no records to be retrieved. Re-enter.", imgMessage.INFO, "txtIntermediary");
				setPrintButtons(false);
			} else {
				setPrintButtons(true);
			}
			disableFields();
		}
		
		function showGICLS266IntermediaryLOV(){
			onLOV = true;
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action : "getGICLS266IntermediaryLov",
					page : 1,
					searchString : objPerIntm.intmNo == "" ? $F("txtIntermediary") : "",
				},
				title : "Intermediary",
				width : 436,
				height : 386,
				columnModel : [ {
					id : "intmNo",
					title : "Intermediary No",
					width : '120px',
				}, {
					id : "intmName",
					title : "Intermediary Name",
					width : '300px',
					renderer: function(value){
						return unescapeHTML2(value);	
					}
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText:  objPerIntm.intmNo == "" ? $F("txtIntermediary") : "",
				onSelect : function(row) {
					onLOV = false;
					recoveryDetailsCount = row.recoveryDetailsCount;
					$("txtIntermediary").value = unescapeHTML2(row.intmName);
					objPerIntm.intmNo = row.intmNo;
					enableToolbarButton("btnToolbarEnterQuery");
					enableToolbarButton("btnToolbarExecuteQuery");
				},
				onCancel : function () {
					onLOV = false;
					$("txtIntermediary").focus();
				},
				onUndefinedRow : function(){
					objPerIntm.intmNo = "";
					$("txtIntermediary").clear();
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtIntermediary");
					onLOV = false;
				}
			});		
		}
		
		var jsonClmListPerIntermediary = JSON.parse('${jsonClmListPerIntermediary}');
		perIntermediaryTableModel = {
				options: {
					toolbar: {
						elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
					},
					width: '900px',
					pager: {
					},
					onCellFocus : function(element, value, x, y, id) {
						setDetails(tbgClaimsPerIntermediary.geniisysRows[y]);
						tbgClaimsPerIntermediary.keys.removeFocus(tbgClaimsPerIntermediary.keys._nCurrentFocus, true);
						tbgClaimsPerIntermediary.keys.releaseKeys();
					},
					onRemoveRowFocus : function(element, value, x, y, id){					
						setDetails(null);
						tbgClaimsPerIntermediary.keys.removeFocus(tbgClaimsPerIntermediary.keys._nCurrentFocus, true);
						tbgClaimsPerIntermediary.keys.releaseKeys();
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
						id: 'recoverySw',
	              		title : 'R',
	              		altTitle: 'With Recovery',
		              	width: '32px',
		              	editable: false,
		              	visible: true,
		              	defaultValue: false,
						otherValue:	false,
						filterOption: true,
						filterOptionType: 'checkbox',
						editor: new MyTableGrid.CellCheckbox({
				            getValueOf: function(value){
			            		if (value){
									return "Y";
			            		}else{
									return "N";	
			            		}	
			            	} 
			            })
					},
					{
						id : "claimNo",
						title: "Claim Number",
						width: '180px',
						visible: true,
						filterOption: true
					},				
					{
						id : "policyNo",
						title: "Policy Number",
						width: '180px',
						visible: true,
						filterOption: true
					},
					{
						id : "assuredName",
						title: "Assured Name",
						width: '270px',
						visible: true,
						renderer: function(value){
							return unescapeHTML2(value);
						},
						filterOption: true
					},
					{
						id : "clmFileDate",
						title: "File Date",
						width: '101px',
						visible: true,
						renderer: function(value){
							return dateFormat(value, "mm-dd-yyyy");
						},
						filterOption: true,
						filterOptionType : 'formattedDate',
						align: "center",
						titleAlign: "center"
					},
					{
						id : "lossDate",
						title: "Loss Date",
						width: '102px',
						visible: true,
						renderer: function(value){
							return dateFormat(value, "mm-dd-yyyy");
						},
						filterOption: true,
						filterOptionType : 'formattedDate',
						align: "center",
						titleAlign: "center"
					}				
				],
				rows: jsonClmListPerIntermediary.rows
			};
			
		tbgClaimsPerIntermediary = new MyTableGrid(perIntermediaryTableModel);
		tbgClaimsPerIntermediary.pager = jsonClmListPerIntermediary;
		tbgClaimsPerIntermediary.render('perIntermediaryTable');
		tbgClaimsPerIntermediary.afterRender = function(){
			setDetails(null);
		};
		
		function setDetails(obj) {
			if(obj!=null){
				if(obj.recoveryDetCount > 0){
					objRecovery.claimId = obj.claimId;
					enableButton("btnRecoveryDetails");
				} else {
					disableButton("btnRecoveryDetails");
				}
				
			    if(obj.claimDetCount > 0){

					objPerIntm.claimId = obj.claimId;
					objPerIntm.perilCd = obj.perilCd;
					objPerIntm.itemNo = obj.itemNo;
					objPerIntm.lineCd = obj.lineCd;
					objPerIntm.claimNo = obj.claimNo;
					objPerIntm.policyNo = obj.policyNo;
					objPerIntm.lossCatDesc = unescapeHTML2(obj.lossCatDesc);
					objPerIntm.lossDate = dateFormat(obj.lossDate, "mm-dd-yyyy");
					objPerIntm.assuredName = obj.assuredName;
					objPerIntm.clmStatDesc = obj.clmStatDesc;
					enableButton("btnClaimDetails");
				} else {
					disableButton("btnClaimDetails");
				}
			} else {
				disableButton("btnRecoveryDetails");
				disableButton("btnClaimDetails");
			}
		}
		
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
					 height: 500,
					 width: 820,
					draggable : true
				});
			} catch (e) {
				showErrorMessage("overlay error: ", e);
			}
		}
		
		function showClaimDetails() {
			try {
				overlayClaimDetails = Overlay.show(contextPath
						+ "/GICLClaimListingInquiryController", {
					urlContent : true,
					urlParameters : {
						action : "showClaimDetails",
						ajax : "1",
						claimId : objPerIntm.claimId,
						perilCd : objPerIntm.perilCd,
						itemNo  : objPerIntm.itemNo,
						lineCd  : objPerIntm.lineCd,
						claimNo : objPerIntm.claimNo,
						policyNo : objPerIntm.policyNo,
						lossCatDesc : objPerIntm.lossCatDesc,
						lossDate : objPerIntm.lossDate,
						assuredName : objPerIntm.assuredName,
						clmStatDesc : objPerIntm.clmStatDesc
					},
					title : "Claim Details",
					height : 365,
					width : 797,
					draggable : true
				});
			} catch (e) {
				showErrorMessage("overlay error: ", e);
			}
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
		
		function addCheckbox(){
			var htmlCode = "<table cellspacing='10px' style='margin: 10px;'><tr><td><input type='checkbox' id='chkClaimListing' checked='checked' /></td><td><label for='chkClaimListing'>Claim Listing Per Intermediary</label></td></tr><tr><td><input type='checkbox' checked='checked' id='chkRecoveryListing' /></td><td><label for='chkRecoveryListing'>Recovery Listing Per Intermediary</label></td></tr></table>"; 
			
			$("printDialogFormDiv2").update(htmlCode); 
			$("printDialogFormDiv2").show();
			$("printDialogMainDiv").up("div",1).style.height = "248px";
			$($("printDialogMainDiv").up("div",1).id).up("div",0).style.height = "280px";
			
			if(recoveryDetailsCount == 0){
				$("chkRecoveryListing").checked = false;
				$("chkRecoveryListing").disable();
			}
				
		}
		
		var reports = [];
		function checkReport(){
			if(!$("chkClaimListing").checked && !$("chkRecoveryListing").checked){
				customShowMessageBox("Please choose which report you want to print.", imgMessage.ERROR, 'btnPrint');
				return false;
			}
			
			var reportId = [];
			
			if($("chkClaimListing").checked)  //Dren Niebres SR-5370 05.10.2016 - Start
				if($F("selDestination") == "file") { 
					if ($("rdoPdf").checked) 
						reportId.push("GICLR266");
					else 
						reportId.push("GICLR266_CSV");		
				} else {
					reportId.push("GICLR266");
				}	 							
			if($("chkRecoveryListing").checked)
				if($F("selDestination") == "file") { 
					if ($("rdoPdf").checked) 
						reportId.push("GICLR266A");
					else 
						reportId.push("GICLR266A_CSV");		
				} else {
					reportId.push("GICLR266A");
				}  //Dren Niebres SR-5370 05.10.2016 - End		
				
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
						                  + "&moduleId=GICLS266"
						                  + "&intmNo=" + objPerIntm.intmNo
						                  + getParams();
				
				if(reportId == "GICLR266")
					reptTitle = "Claim Listing per Intermediary";
				else if (reportId == "GICLR266A")
					reptTitle = "Recovery Listing per Intermediary";
				
				if("screen" == $F("selDestination")){
					reports.push({reportUrl : content, reportTitle : reptTitle});
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
					
					var fileType = "PDF"; //Dren Niebres SR-5370 05.10.2016 - Start
					
					if ($("rdoPdf").checked)
						fileType = "PDF";
					else
						fileType = "CSV2";

					new Ajax.Request(content, {
						parameters : {destination : "file",
									  fileType : fileType},
						onCreate: showNotice("Generating report, please wait..."),
						onComplete: function(response){
							hideNotice();
							if (checkErrorOnResponse(response)){
								if (fileType == "CSV2"){ 
									copyFileToLocal(response, "csv");
								} else 
									copyFileToLocal(response);
							} //Dren Niebres SR-5370 05.10.2016 - End
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

		$("rdoAsOf").observe("click", disableFromToFields);
		$("rdoFrom").observe("click", disableAsOfFields);
		$("btnClaimDetails").observe("click", showClaimDetails);
		$("btnRecoveryDetails").observe("click", showRecoveryDetails);
		$("btnToolbarEnterQuery").observe("click", resetForm);
		/* $("btnReloadForm").observe("click", function(){
			objCLMGlobal.callingForm = ""; 
			new Ajax.Request(contextPath + "/GICLClaimListingInquiryController", {
				evalScript : true,
			    parameters : {action : "showClaimListingPerIntermediary"},
			    onCreate : showNotice("Loading, please wait..."),
				onComplete : function(response){
					hideNotice();
					try {
						if(checkErrorOnResponse(response)){
							$("dynamicDiv").update(response.responseText);
						}
					} catch(e){
						showErrorMessage("showClaimListingPerIntermediary - onComplete : ", e);
					}								
				} 
			});
		}); */
		$("rdoClaimFileDate").observe("click", changeSearchByOpt);
		$("rdoLossDate").observe("click", changeSearchByOpt);
		$("btnToolbarExecuteQuery").observe("click", function(){
			if(validateRequiredDates())
				executeQuery();
		});
		
		$("txtAsOf").observe("blur", function(){
			if($("txtAsOf").value == "")
				$("txtAsOf").value = getCurrentDate();
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
		
	 	$("btnToolbarPrint").observe("click", function(){
			showGenericPrintDialog("Print Claim Listing Per Intermediary", checkReport, addCheckbox, true);
			$("csvOptionDiv").show(); //Dren Niebres SR-5370 05.10.2016
		});
		
		 $("btnPrintReport").observe("click", function(){
			showGenericPrintDialog("Print Claim Listing Per Intermediary", checkReport, addCheckbox, true);
			$("csvOptionDiv").show(); //Dren Niebres SR-5370 05.10.2016
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
		
		$("txtIntermediary").observe('keypress', function(event){
		    if(event.keyCode == 0 || event.keyCode == 8 || event.keyCode == 46) {
				disableToolbarButton("btnToolbarExecuteQuery");
				objPerIntm.intmNo = "";
		    }
		});
		
		$("txtIntermediary").observe('change', function(event){
		    if(this.value.trim() == ""){
		    	this.clear();
		    }
		    showGICLS266IntermediaryLOV();
		});
		
		$("imgSearchIntermediary").observe("click", function(){
			if($F("txtIntermediary").trim() == ""){
		    	$("txtIntermediary").clear();
		    }
		    showGICLS266IntermediaryLOV();
		});
		
		$("btnExit").observe("click", function(){
			goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
		});
		
		$("btnToolbarExit").observe("click", function(){
			goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
		});
		
		initializeAll();
		initializeGICLS266();
		
	} catch (e){
		showErrorMessage("Error : " , e.message);
	}
</script>