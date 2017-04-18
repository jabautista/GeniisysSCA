<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="inwardRiPaymentStatusMainDiv" name="inwardRiPaymentStatusMainDiv" style="height: 550px;">
	<div id="toolbarDiv" name="toolbarDiv">
		<div class="toolButton">
			<span style="background: url(${pageContext.request.contextPath}/images/toolbar/enterQuery.png) left center no-repeat;" id="btnToolbarEnterQuery">Enter Query</span>
			<span style="display: none; background: url(${pageContext.request.contextPath}/images/toolbar/enterQueryDisabled.png) left center no-repeat;" id="btnToolbarEnterQueryDisabled">Enter Query</span>
		</div>
		<div class="toolButton">
			<span style="background: url(${pageContext.request.contextPath}/images/toolbar/executeQuery.png) left center no-repeat;" id="btnToolbarExecuteQuery">Execute Query</span>
			<span style="display: none; background: url(${pageContext.request.contextPath}/images/toolbar/executeQueryDisabled.png) left center no-repeat;" id="btnToolbarExecuteQueryDisabled">Execute Query</span>
		</div>
		<div class="toolButton" style="float: right;">
			<span style="background: url(${pageContext.request.contextPath}/images/toolbar/exit.png) left center no-repeat;" id="btnToolbarExit">Exit</span>
			<span style="display: none; background: url(${pageContext.request.contextPath}/images/toolbar/exitDisabled.png) left center no-repeat;" id="btnToolbarExitDisabled">Exit</span>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
	   		<label>Inward RI Payment Status</label>
	   		<span class="refreshers" style="margin-top: 0;">
	   		</span>
	   	</div>
	</div>
	<div class="sectionDiv" id="inwardRiPaymentStatusFormDiv">
		<table cellspacing="0" align="center" style="padding: 20px; width: 900px;">
			<tr>
				<td class="rightAligned" style="width:90px;">Policy No.</td>
				<td class="leftAligned" style="border: none; width:410px;">
					<input class="polNoReq allCaps required" type="text" id="txtLineCd" name="txtLineCd" style="width: 40px; float: left; margin: 2px 4px 0 0" maxlength="2" tabindex="101" />
					<input class="" type="text" id="txtSublineCd" name="txtSublineCd" readonly="readonly" style="width: 80px; float: left; margin: 2px 4px 0 0" maxlength="7" tabindex="102" />
					<input class="" type="text" id="txtIssCd" name="txtIssCd" readonly="readonly" style="width: 40px; float: left; margin: 2px 4px 0 0" maxlength="2" tabindex="103" />
					<input class="rightAligned" type="text" id="txtIssueYy" name="txtIssueYy" readonly="readonly" style="width: 40px; float: left; margin: 2px 4px 0 0" maxlength="3" tabindex="104" />
					<input class="rightAligned" type="text" id="txtPolSeqNo" name="txtPolSeqNo" readonly="readonly" style="width: 75px; float: left; margin: 2px 4px 0 0" maxlength="8" tabindex="105" />
					<input class="rightAligned" type="text" id="txtRenewNo" name="txtRenewNo" readonly="readonly" style="width: 30px; float: left;" maxlength="3" tabindex="106" />
					<span class="lovSpan" style="border: none; height: 21px; margin: 2px 4px 0 0; margin-left: 5px;">
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchPolicyNo" name="searchPolicyNo" alt="Go" style="margin: 2px 0 4px 0; float: left;" />
					</span>
				</td>
				<td class="rightAligned" style="width:100px;">Endt. No.</td>
				<td class="leftAligned" style="border: none; width:180px;">
					<input class="" type="text" id="txtEndtIssCd" name="txtEndtIssCd" readonly="readonly" style="width: 40px; float: left; margin: 2px 4px 0 0" maxlength="2" tabindex="107" />
					<input class="rightAligned" lpad="2" type="text" id="txtEndtYy" name="txtEndtYy" readonly="readonly" style="width: 40px; float: left; margin: 2px 4px 0 0" maxlength="3" tabindex="108" />
					<input class="rightAligned" lpad="7" type="text" id="txtEndtSeqNo" name="txtEndtSeqNo" readonly="readonly" style="width: 75px; float: left; margin: 2px 4px 0 0" maxlength="8" tabindex="109" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width:90px;">RI Policy No.</td>
				<td class="leftAligned" style="border: none; width:410px;">
					<input class="" type="text" id="txtRiPolicyNo" name="txtRiPolicyNo" readonly="readonly" style="width: 365px; float: left; margin: 2px 4px 0 0" tabindex="110" />
				</td>
				<td class="rightAligned" style="width:100px;">RI Endt. No.</td>
				<td class="leftAligned" style="border: none; width:180px;">
					<input class="" type="text" id="txtRiEndtNo" name="txtRiEndtNo" readonly="readonly" style="width: 179px; float: left; margin: 2px 4px 0 0" tabindex="111" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width:95px;">Ceding Company</td>
				<td class="leftAligned" style="border: none; width:410px;">
					<input class="" type="text" id="txtCedingCompany" name="txtCedingCompany" readonly="readonly" style="width: 365px; float: left; margin: 2px 4px 0 0" tabindex="112" />
				</td>
				<td class="rightAligned" style="width:100px;">RI Binder No.</td>
				<td class="leftAligned" style="border: none; width:180px;">
					<input class="" type="text" id="txtRiBinderNo" name="txtRiBinderNo" readonly="readonly" style="width: 179px; float: left; margin: 2px 4px 0 0" tabindex="113" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width:95px;">Coverage</td>
				<td class="leftAligned" style="border: none; width:410px;">
					<div id="txtEffDateCoverageDiv" style="float: left; border: solid 1px gray; width: 145px; height: 20px; margin-left: 0px; margin-top: 0px;">
						<input type="text" id="txtEffDate" name="txtEffDate" tabindex="114" style="float: left; margin-top: 0px; margin-right: 0.5px; width: 120px; height: 14px; border: none;"/>
						<img id="imgEffDate" alt="imgEffDate" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"/>
					</div>
					<div id="separatorDiv" style="float: left; border: none; width: 79px; height: 20px; margin-left: 0px; margin-top: 0px;">
					</div>
					<div id="txtExpiryCoverageDiv" style="float: left; border: solid 1px gray; width: 145px; height: 20px; margin-left: 0px; margin-top: 0px;">
						<input type="text" id="txtExpiryDate" name="txtExpiryDate" tabindex="115" style="float: left; margin-top: 0px; margin-right: 0.5px; width: 120px; height: 14px; border: none;"/>
						<img id="imgExpiryDate" alt="imgExpiryDate" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"/>
					</div>
				</td>
			</tr>
		</table>
	</div>
	<div class="sectionDiv">
		<div id="tableInwardRiPaymentStatusDiv" style="padding: 5px; height: 280px;">
			<div id="inwardRiPaymentStatusTable" style="padding: 10px; padding-left: 55px;"></div>
		</div>
	</div>
	<div class="buttonDiv" style="float: left; width: 100%; margin-bottom: 20px; margin-top: 10px;">
		<table align="center" style="margin-bottom: 20px;">
			<tbody>
				<tr>
					<td>
						<input id="btnInspection" class="button noChangeTagAttr" type="button" style="display: none; value="Select Inspection" name="btnInspection">
					</td>
					<td>
						<input id="btnDetails"  name="btnDetails" class="button" type="button" style="width: 100px;" value="Details">
					</td>
				</tr>
			</tbody>
		</table> 
	</div>
</div>
<script type="text/javascript">
	initializeAll();
	setModuleId("GIRIS013");
	checkUserAccess();
	setDocumentTitle("Inward RI Payment Status");
	$("txtLineCd").focus();
	disableToolbarButton("btnToolbarEnterQuery");
	disableToolbarButton("btnToolbarExecuteQuery");
	disableButton("btnDetails");
	var row = 0;
	var policyId;
	var issCd;
	var premSeqNo;
	var prevLineCd = "";
	
	function checkUserAccess(){
		try{
			new Ajax.Request(contextPath+"/GIACAccTransController?action=checkUserAccess2", {
				method: "POST",
				parameters: {
					moduleName: "GIRIS013"
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(response.responseText == 0){
						showWaitingMessageBox('You are not allowed to access this module.', imgMessage.ERROR, 
								function(){
							goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", "");
						});  
						
					}
				}
			});
		}catch(e){
			showErrorMessage('checkUserAccess', e);
		}
	}
	
	try {
		var objInwardRiPaymentStatus = new Object();
		objInwardRiPaymentStatus.objInwardRiPaymentStatusTableGrid = JSON.parse('${jsonInwardRiPaymentStatus}');
		objInwardRiPaymentStatus.objInwardRiPaymentStatusList = objInwardRiPaymentStatus.objInwardRiPaymentStatusTableGrid.rows || [];
		
		var inwardRiPaymentStatusTableModel = {
				url : contextPath + "/GIRIInpolbasController?action=viewInwardRiPaymentStatus&refresh=1"
				+ "&policyId=" + policyId,
				options : {
					toolbar : {
						elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
						onFilter : function() {
							inwardRiPaymentStatusTG.keys.removeFocus(inwardRiPaymentStatusTG.keys._nCurrentFocus, true);
							inwardRiPaymentStatusTG.keys.releaseKeys();
						}
					},
					title :'',
					width : '800px',
					height : '240px',
					onCellFocus: function(elemet, value, x, y, id){
						row = inwardRiPaymentStatusTG.geniisysRows[y];
						issCd = row == null ? "" : row.issCd;
						premSeqNo = row == null ? "" : row.premSeqNo;
					},
					onRemoveRowFocus: function(){
						issCd = "";
						premSeqNo = 0;
						inwardRiPaymentStatusTG.keys.removeFocus(inwardRiPaymentStatusTG.keys._nCurrentFocus, true);
						inwardRiPaymentStatusTG.keys.releaseKeys();
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
						}, {
							id : "invoiceNo",
							title : "Invoice No.",
							width : '150',
							filterOption : true
						}, {
							id : "currencyDesc",
							title : "Currency",
							width : '190'
						}, {
							id : "netDue",
							title : "Net Due",
							titleAlign : 'right',
							width : '150',
							geniisysClass: 'money',
							align : 'right',
						}, {
							id : "collectionAmt",
							title : "Payment",
							titleAlign : 'right',
							width : '150',
							geniisysClass: 'money',
							align : 'right',
						}, {
							id : "balance",
							title : "Balance",
							titleAlign : 'right',
							width : '150',
							geniisysClass: 'money',
							align : 'right',
						}
				],
				rows : objInwardRiPaymentStatus.objInwardRiPaymentStatusTableGrid.rows
		};
		inwardRiPaymentStatusTG = new MyTableGrid(inwardRiPaymentStatusTableModel);
		inwardRiPaymentStatusTG.pager = objInwardRiPaymentStatus.objInwardRiPaymentStatusTableGrid;
		inwardRiPaymentStatusTG.render('inwardRiPaymentStatusTable');
		inwardRiPaymentStatusTG.afterRender = function(){
			inwardRiPaymentStatusTG.keys.removeFocus(inwardRiPaymentStatusTG.keys._nCurrentFocus, true);
			inwardRiPaymentStatusTG.keys.releaseKeys();
			
			if(inwardRiPaymentStatusTG.geniisysRows.length > 0){
				var rec = inwardRiPaymentStatusTG.geniisysRows[0];
				inwardRiPaymentStatusTG.selectRow('0');
				issCd = rec.issCd;
				premSeqNo = rec.premSeqNo;
			}
		};
	} catch(e){
		showErrorMessage("GIRIS013 Table Grid", e);
	}
	
	$("searchPolicyNo").observe("click", function() {
		if($F("txtLineCd") == ""){
			customShowMessageBox("Required fields should be entered.", "I", "txtLineCd");
		} else {
			showGIRIS013PolNoLOV();	
		}
	});
	
	function showGIRIS013PolNoLOV() {
		try {
			LOV.show({ controller : "UnderwritingLOVController",
				urlParameters : {
					action  : "showGIRIS013PolNoLOV",
					lineCd  : $F("txtLineCd"),
					effDate : $F("txtEffDate"),
					expiryDate : $F("txtExpiryDate"),
					page : 1
				},
				title : "List of Policy Nos.",
				width : 655,
				height : 385,
				hideColumnChildTitle : true,
				filterVersion : "2",
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
					id : "policyNo",
					title : "Policy No. / Endt No.",
					width : '210'
				}, {
					id : "riPolicyNo",
					title : "RI Policy No.",
					width : '140',
					filterOption : true
				}, {
					id : "riEndtNo",
					title : "RI Endt. No.",
					width : '130',
					filterOption : true
				}, {
					id : "riBinderNo",
					title : "RI Binder No.",
					width : '130',
					filterOption : true
				}, {
					id : 'sublineCd',
					title : 'Policy Subline Code',
					width : '0',
					filterOption : true,
					editable : false,
					visible : false
				}, {
					id : 'issueYy',
					title : 'Policy Issue Year',
					type : 'number',
					width : '0',
					filterOption : true,
					filterOptionType: 'integerNoNegative',
					editable : false,
					visible : false
				}, {
					id : 'polSeqNo',
					title : 'Policy Sequence No.',
					type : 'number',
					width : '0',
					filterOption : true,
					filterOptionType: 'integerNoNegative',
					editable : false,
					visible : false
				}, {
					id : 'renewNo',
					title : 'Policy Renew No.',
					type : 'number',
					width : '0',
					filterOption : true,
					filterOptionType: 'integerNoNegative',
					editable : false,
					visible : false
				} ],
					draggable : true,
					onSelect : function(row) {
						$("txtSublineCd").value = unescapeHTML2(row.sublineCd);
						$("txtIssCd").value = unescapeHTML2(row.issCd);
						$("txtIssueYy").value = row.issueYy;
						$("txtPolSeqNo").value = formatNumberDigits(row.polSeqNo, 7);
						$("txtRenewNo").value = formatNumberDigits(row.renewNo, 2);
						$("txtEndtIssCd").value = row.endtSeqNo == "0" ? "" : unescapeHTML2(row.endtIssCd);
						$("txtEndtYy").value = row.endtYy == "0" ? "" : row.endtYy;
						$("txtEndtSeqNo").value = row.endtSeqNo == "0" ? "" : formatNumberDigits(row.endtSeqNo, 6);
						$("txtRiPolicyNo").value = unescapeHTML2(row.riPolicyNo);
						$("txtRiEndtNo").value = unescapeHTML2(row.riEndtNo);
						$("txtRiBinderNo").value = unescapeHTML2(row.riBinderNo);
						$("txtCedingCompany").value = unescapeHTML2(row.riSname);
						$("txtEffDate").value = row.effDate == null ? null : dateFormat(row.effDate, 'mm-dd-yyyy');
						$("txtExpiryDate").value = row.expiryDate == null ? null : dateFormat(row.expiryDate, 'mm-dd-yyyy');
						enableToolbarButton("btnToolbarEnterQuery");
						enableToolbarButton("btnToolbarExecuteQuery");
						disableSearch("searchPolicyNo");
						disableDate("imgEffDate");
						disableDate("imgExpiryDate");
						policyId = row.policyId;
						prevLineCd = $F("txtLineCd");
					},
					onUndefinedRow : function(){
						customShowMessageBox("No record selected.", imgMessage.INFO, "txtLineCd");
						$("txtEffDate").value = "";
						$("txtExpiryDate").value = "";
						$("txtLineCd").value = "";
					},
				});
		} catch (e) {
			showErrorMessage("showGIRIS013PolNoLOV", e);
		}
	}
	
	$("btnDetails").observe("click", function(){
		showInwRiDetailsOverlay();
	});
	
	function showInwRiDetailsOverlay(){
		try {
			overlayInwRiDetails = 
				Overlay.show(contextPath+"/GIRIInpolbasController", {
					urlContent: true,
					urlParameters: {action    : "showInwRiDetailsOverlay",																
									ajax      : "1",
									issCd     : issCd,
									premSeqNo : premSeqNo
					},
				    title: "Details",
				    height: 300,
				    width: 400,
				    draggable: true
				});
			} catch (e) {
				showErrorMessage("Overlay Error: " , e);
			}
	}
	
	$("imgEffDate").observe("click", function(){
		scwShow($('txtEffDate'),this, null);
	});
	
	$("imgExpiryDate").observe("click", function(){
		scwShow($('txtExpiryDate'),this, null);
	});
	
	$("txtEffDate").observe("blur", function(){
		if($F("txtEffDate") != ""){
			validateDateFormat($F("txtEffDate"), "txtEffDate");	
			
			if ($("txtExpiryDate").value != "" && this.value != "") {
				if (compareDatesIgnoreTime(Date.parse($F("txtEffDate")),Date.parse($("txtExpiryDate").value)) == -1) {
					customShowMessageBox("From Date should not be later than To Date.","E","txtEffDate");
					this.clear();
				}
			}
		}
	});
	
	$("txtExpiryDate").observe("blur", function(){
		if($F("txtExpiryDate") != ""){
			validateDateFormat($F("txtExpiryDate"), "txtExpiryDate");
			
			if ($("txtEffDate").value != ""&& this.value != "") {
				if (compareDatesIgnoreTime(Date.parse($F("txtEffDate")),Date.parse($("txtExpiryDate").value)) == -1) {
					customShowMessageBox("From Date should not be later than To Date.","E","txtExpiryDate");
					this.clear();
				}
			}
		}
	});
	
	function validateDateFormat(strValue, elemName){
		var text = strValue; 
		var comp = text.split('-');
		var m = parseInt(comp[0], 10);
		var d = parseInt(comp[1], 10);
		var y = parseInt(comp[2], 10);
		var status = true;
		var isMatch = text.match(/^(\d{1,2})-(\d{1,2})-(\d{4})$/);
		var date = new Date(y,m-1,d);
		
		if(isNaN(y) || isNaN(m) || isNaN(d) || y.toString().length < 4 || !isMatch ){
			customShowMessageBox("Date must be entered in a format like MM-DD-RRRR.", imgMessage.INFO, elemName);
			status = false;
		}
		if(0 >= m || 13 <= m){
			customShowMessageBox("Month must be between 1 and 12.", imgMessage.INFO, elemName);	
			status = false; 
		}
		if(date.getDate() != d){				
			customShowMessageBox("Day must be between 1 and the last of the month.", imgMessage.INFO, elemName);	
			status = false;
		}
		if(!status){
			$(elemName).value = "";
		}
		return status;
	}
	
	$("txtLineCd").observe("blur", function(){
		if(prevLineCd != ""){
			if(prevLineCd != $F("txtLineCd")){
				customShowMessageBox("Previously selected line code is " + prevLineCd + ".", "I", "txtLineCd");
				$("txtLineCd").value = prevLineCd;
			}
		}
	});
	
	$("btnToolbarEnterQuery").observe("click", function(){
		showInwardRiPaymentStatus();
	});
	
	$("btnToolbarExecuteQuery").observe("click", function(){
		if($F("txtLineCd") == ""){
			customShowMessageBox("Required fields should be entered.", "I", "txtLineCd");
		} else {
			inwardRiPaymentStatusTG.url = contextPath + "/GIRIInpolbasController?action=viewInwardRiPaymentStatus&refresh=1"
			+ "&policyId=" + policyId;
			inwardRiPaymentStatusTG._refreshList();
			disableToolbarButton("btnToolbarExecuteQuery");
			enableButton("btnDetails");	
		}
	});
	
	$("btnToolbarExit").observe("click",function(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});
</script>