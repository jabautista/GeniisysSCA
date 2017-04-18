<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<!-- <div id="mainNav" name="mainNav" claimsBasicMenu="Y">
	<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
		<ul>
			<span id="qIMenus" name="qIMenus" style="display: block;">
				<li><a id="quotationInfoExit">Exit</a></li>
			</span>
		</ul>
	</div>
</div> -->
<div id="giimm014MainDiv">
<jsp:include page="/pages/toolbar.jsp"></jsp:include>
<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
		<label>View Package Quotation</label>
			<span class="refreshers" style="margin-top: 0;">
				<label id="gro" name="gro" style="margin-left: 5px;"></label>
				<label id="reloadQuoteInfoForm" name="reloadQuoteInfoForm"></label>
			</span>
	</div>
</div>
<div class="sectionDiv" style="margin-bottom: 1px;">
	<div style="height: 160px;">
		<div style="margin-top: 20px; margin-right: 120px; margin-left: 120px;">
			<table align="left">
				<tr>
					<td><label>Pack Quotation</label></td>
					<td colspan="5"><input class="required" type="text" style="width: 23px;"	id="txtLineCd" name="txtLineCd" maxlength="2"/></td>
					<td><input class="" type="text" style="width: 52px;"	id="txtSublineCd" name="txtSublineCd" maxlength="7"/></td>
					<td><input class="" type="text" style="width: 23px;" id="txtIssCd" name="txtIssCd" maxlength="2"/></td>
					<td><input class="" type="text" style="width: 28px; text-align: right;" id="txtQuotationYy" name="txtQuotationYy" maxlength="4"/>
						<input type="hidden" id="hidPackQuoteId"/>
					</td>
					<td><input class="" type="text" style="width: 58px; text-align: right;" id="txtQuotationNo" name="txtQuotationNo" maxlength="8"/>
					</td>
					<td><input class="" type="text" style="width: 25px; text-align: right;" id="txtProposalNo" name="txtProposalNo" maxlength="3"/></td>
					<td><img style="padding-top: 2px" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchQuote" name="imgSearchQuote" alt="Go" /></td>
					<td style="padding-left: 21px"><label>Status</label></td>
					<td><input type="text" style="width: 201px;" id="txtStatQuote" name="txtStatQuote" readonly="readonly" /></td>
				</tr>
			    <tr>
					<td><label>Client/Assured</label></td>
					<td colspan="13"><input type="text" style="width: 565px;" id="txtAssuredClient" name="txtAssuredClient" readonly="readonly" />
					</td>
				</tr>
			</table>
		    <table align="left">
				<tr>
					<td style="padding-left:3px"><label>Inception Date</label></td>
					<td colspan="13"><input type="text" style="width: 162px;" id="txtInceptDate" name="txtInceptDate" readonly="readonly" />
					</td>
					<td style="padding-left: 105px"><label>Date Accepted</label></td>
					<td><input type="text" style="width: 200px;" id="txtDateAccepted" name="txtDateAccepted" readonly="readonly" />
					</td>
				</tr>
			</table>
			<table align="left">
				<tr>
					<td colspan="5" style="padding-left: 20px">Expiry Date</td>
					<td><input type="text" style="width: 162px;"
						id="txtExpiryDate" name="txtExpiryDate" readonly="readonly" /></td>
					<td style="padding-left: 159px">Days</td>
					<td><input type="text" style="width: 81px;"
						id="txtDaysQuote" name="txtDaysQuote" readonly="readonly" /></td>
				</tr>
			</table>
		</div>
	</div>
</div>
<div class="sectionDiv" id="quoteInfoDiv" style="margin-bottom: 50px;">
	<div style="height: 320px; width: 600px">
		<div id="quoteTable" style="height: 310px; width: 600px; margin-top: 15px; padding-left:135px;"></div>
	</div>
	<div>
		<table border="0" style="margin-bottom: 20px;" align="center">
			<tr>
				<td><input type="button" class="button" id="btnViewQuoteInfo"
					value="View Package Quotation" tabindex="201"
					style="width: 180px;" /></td>
			</tr>
		</table>
	</div>
</div>
</div>
<div id="packQuoteInfoMainDiv" style="display: none;">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<span style="display: block;">
					<li><a id="packQuoteInfoExit">Exit</a></li>
				</span>
			</ul>
		</div>
	</div>
	<div id="packQuoteInfoDiv""></div>
</div>

<script type="text/javascript">
	var selectedRow = null;
	setModuleId("GIIMM014");
	setDocumentTitle("View Package Quotation");
	
	function initializeGIIMM014(){		
		$("txtLineCd").focus();
		disableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
		disableButton("btnViewQuoteInfo");
	}

	var jsonQuotationNo = JSON.parse('${jsonQuotationNo}');
	quotationNoTableModel = {
		url : contextPath
				+ "/GIPIQuoteController?action=viewQuotationNo",
		options : {
			width : '655px',
			pager : {},
			onCellFocus : function(element, value, x, y, id) {
				tbgQuotationNo.keys.removeFocus(
						tbgQuotationNo.keys._nCurrentFocus, true);
				tbgQuotationNo.keys.releaseKeys();
				toggleButtons(true);
				selectedRow = tbgQuotationNo.geniisysRows[y];
			},
			onRemoveRowFocus : function(element, value, x, y, id) {
				tbgQuotationNo.keys.removeFocus(
						tbgQuotationNo.keys._nCurrentFocus, true);
				tbgQuotationNo.keys.releaseKeys();
				toggleButtons(false);
				selectedRow = null;
			},onSort : function(){
				tbgQuotationNo.keys.removeFocus(
						tbgQuotationNo.keys._nCurrentFocus, true);
				tbgQuotationNo.keys.releaseKeys();	
				toggleButtons(false);
				selectedRow = null;
			}
		},
		columnModel : [ {
			id : 'recordStatus',
			title : '',
			width : '0',
			visible : false
		}, {
			id : 'divCtrId',
			width : '0',
			visible : false
		}, {
			id : "dvQuote",
			title : "Quotation No.",
			width : '645px',
			filterOption : true
		} ],
		rows : jsonQuotationNo.rows
	};

	tbgQuotationNo = new MyTableGrid(quotationNoTableModel);
	tbgQuotationNo.pager = jsonQuotationNo;
	tbgQuotationNo.render('quoteTable');
	
	function toggleButtons(enable) {
		if (nvl(enable,false) == true){
			enableButton("btnViewQuoteInfo");
		}else {
			disableButton("btnViewQuoteInfo");
		}
	}
	
	//marco - 07.07.2014
	function showQuotationStatus(){
		new Ajax.Updater("packQuoteInfoDiv", contextPath + "/GIPIQuoteController?action=showViewQuotationStatusPage", {
			method : "GET",
			parameters : {
				quoteId : selectedRow.quoteId,
				lineCd  : selectedRow.lineCd
			},
			evalScripts : true,
			asynchronous : true,
			onCreate : function(){ 
				showNotice("Getting quotation information, please wait...");
			},
			onComplete : function(){
				hideNotice();
				setModuleId("GIIMM005");
				setDocumentTitle("View Quotation Information");
				$("giimm014MainDiv").hide();
				$("packQuoteInfoMainDiv").show();
				$("quotationInformationMainDiv").show();
				objQuoteGlobal.showQuotationStatus = showQuotationStatus;
			}
		});
	}
	
	//view quotation info
	$("btnViewQuoteInfo").observe("click", function() {
		showQuotationStatus();
	});
	
	//marco - 07.07.2014
	$("packQuoteInfoExit").observe("click", function(){
		$("giimm014MainDiv").show();
		$("packQuoteInfoMainDiv").hide();
		$("quotationInformationMainDiv").update();
		setModuleId("GIIMM014");
		setDocumentTitle("View Package Quotation");
	});

	function resetForm(){
		$("txtLineCd").clear();
		$("txtLineCd").removeAttribute("readonly");
		$("txtSublineCd").clear();
		$("txtSublineCd").removeAttribute("readonly");
		$("txtIssCd").clear();
		$("txtIssCd").removeAttribute("readonly");
		$("txtQuotationYy").clear();
		$("txtQuotationYy").removeAttribute("readonly");
		$("txtQuotationNo").clear();
		$("txtQuotationNo").removeAttribute("readonly");
		$("txtProposalNo").clear();
		$("txtProposalNo").removeAttribute("readonly");
		$("txtStatQuote").clear();
		$("txtAssuredClient").clear();
		$("txtInceptDate").clear();
		$("txtExpiryDate").clear();
		$("txtDateAccepted").clear();
		$("txtDaysQuote").clear();
		$("txtLineCd").focus();	
		tbgQuotationNo.url = contextPath+"/GIPIQuoteController?action=viewQuotationNo";
		tbgQuotationNo._refreshList();
		enableSearch("imgSearchQuote");
		disableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
		toggleButtons(false);//added by reymon 11122013
	}
	
	//toolbar query
	$("btnToolbarEnterQuery").observe("click", resetForm);
	
	//toolbar execute query
	$("btnToolbarExecuteQuery").observe("click", function() {
		if ($("txtLineCd"). value != "" && $("txtSublineCd"). value != "") {
			executeQuery($("hidPackQuoteId").value);
		}
		disableFields();
	});

	//Exit Module
	/* $("quotationInfoExit").observe(
			"click",
			function() {
				goToModule("/GIISUserController?action=goToMarketing",
						"Marketing Main", "");
			}); */
	
	//toolbar exit
	$("btnToolbarExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToMarketing",
				"Marketing Main", "");
	});
	
	function disableFields() {
		disableToolbarButton("btnToolbarExecuteQuery");
		disableSearch("imgSearchQuote");
	}

	//LOV
	$("imgSearchQuote").observe("click", function() {
		showGIIMMPackQuotationLOV();
	});

	//get Pack Quote LOV
	function showGIIMMPackQuotationLOV() {
		if($F("txtLineCd").trim() == ""){
			showWaitingMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, function(){
				$("txtLineCd").focus();
			});
			return;
		}
		try {
			LOV.show({
				controller: "MarketingLOVController",
				urlParameters: {action : "getPackQuoteLOV",
								lineCd : $("txtLineCd").value,
								sublineCd : $("txtSublineCd").value,
								issCd : $("txtIssCd").value,
								quotationYy : $("txtQuotationYy").value,
								quotationNo : $("txtQuotationNo").value,
								proposalNo : $("txtProposalNo").value,
								page : 1},
							title: "Pack Quotation",
							width: 830,
							height: 400,
							filterVersion: "2",
							draggable : true,
							columnModel: [
						{
							id : 'lineCd',
							title : "Line Code",
							width : '0',
							visible : false
						}, {
							id: 'sublineCd',
							title: 'Subline Code',
							width: '0',
							visible: false
						},{
							id: 'issCd',
							title: 'Issue Code',
							width: '0',
							visible: false
						},{
							id: 'quotationYy',
							width: '0',
							title: 'Quotation Yy',
							visible: false
						},{
							id: 'quotationNo',
							width: '0',
							title: 'Quotation No',
							visible: false
						},{
							id: 'proposalNo',
							width: '0',
							title: 'Proposal No.',
							visible: false
						},{
							id : "packQuotation",
							title : "Pack Quotation",
							width : "160px"
						},{
							id : "assdName",
							title : "Client/Assured",
							width : "255px",
							filterOption : true,
							renderer: function(value){
					    		return nvl(value,'') == '' ? '' : escapeHTML2(nvl(value, ''));
					    	}
						}, {
							id : "inceptDate",
							title : "Inception Date",
							width : "90px",
							type: 'date',
							//format: 'mm/dd/yyyy',	replaced kenneth L. 10.08.2013 
							geniisysClass: 'date',
							filterOption : true,
							filterOptionType : 'formattedDate'
						}, {
							id : "expiryDate",
							title : "Expiry Date",
							width : "80px",
							type: 'date',
							//format: 'mm/dd/yyyy',	replaced kenneth L. 10.08.2013
							geniisysClass: 'date',
							filterOption : true,
							filterOptionType : 'formattedDate'
						}, {
							id : "acceptDate",
							title : "Date Accepted",
							width : "87px",
							type: 'date',
							geniisysClass: 'date',
							//format: 'mm/dd/yyyy',	replaced kenneth L. 10.08.2013
							filterOptionType : 'formattedDate'
						}, {
							id : "days",
							title : "Days",
							width : "40px",
							visible : false
						}, {
							id : "dspMeanStatus",
							title : "Status",
							width : "80px",
							visible : true,
							filterOption : true
						} ],
						autoSelectOneRecord : true,
						onSelect : function(row) {
							$("txtLineCd").value = unescapeHTML2(row.lineCd);
							$("txtSublineCd").value = unescapeHTML2(row.sublineCd);
							$("txtIssCd").value = unescapeHTML2(row.issCd);
							$("txtQuotationYy").value = unescapeHTML2(row.quotationYy);
							$("txtQuotationNo").value = unescapeHTML2(row.quotationNo);
							$("txtProposalNo").value = unescapeHTML2(row.proposalNo);
							$("txtStatQuote").value = unescapeHTML2(row.dspMeanStatus);
							$("txtAssuredClient").value = unescapeHTML2(row.client);
							$("txtInceptDate").value = unescapeHTML2(row.inceptDate);
							$("txtExpiryDate").value = unescapeHTML2(row.expiryDate);
							$("txtDateAccepted").value = unescapeHTML2(row.acceptDate);
							$("txtDaysQuote").value = unescapeHTML2(row.days);
							$("hidPackQuoteId").value = unescapeHTML2(row.packQuoteId);
							enableToolbarButton("btnToolbarEnterQuery");
							enableToolbarButton("btnToolbarExecuteQuery");
							$("txtLineCd").readOnly = true;
							$("txtSublineCd").readOnly = true;
							$("txtIssCd").readOnly = true;
							$("txtQuotationYy").readOnly = true;
							$("txtQuotationNo").readOnly = true;
							$("txtProposalNo").readOnly = true;
							$("txtQuotationNo").value = formatNumberDigits(row.quotationNo, 7);
							$("txtProposalNo").value = formatNumberDigits(row.proposalNo, 3);
							//$("txtAssdName").value = row.assdName; remove by steven 05.17.2013; this id is not existing in any element.
						},
						onCancel : function() {
							if (moduleId == "GIIMM014") {
								$("txtLineCd").enable();
								$("txtLineCd").focus();
							}
						},
						onUndefinedRow : function() {
							customShowMessageBox("No record selected.",
									imgMessage.INFO, "txtLineCd");
							$("txtLineCd").enable();
						}
					});
		} catch (e) {
			showErrorMessage("showGIIMMPackQuotationLOV", e);
		}
	}
	
	function executeQuery(packQuoteId){
		tbgQuotationNo.url = contextPath+"/GIPIQuoteController?action=viewQuotationNo&packQuoteId="+packQuoteId;
		tbgQuotationNo._refreshList();
	}
	
	$("txtLineCd").observe("keyup", function(){
		$("txtLineCd").value = $F("txtLineCd").toUpperCase();
		enableToolbarButton("btnToolbarEnterQuery");
	});

	$("txtSublineCd").observe("keyup", function(){
		$("txtSublineCd").value = $F("txtSublineCd").toUpperCase();
		enableToolbarButton("btnToolbarEnterQuery");
	});

	$("txtIssCd").observe("keyup", function(){
		$("txtIssCd").value = $F("txtIssCd").toUpperCase();
		enableToolbarButton("btnToolbarEnterQuery");
	});

	$("txtQuotationYy").observe("keyup", function(){
		enableToolbarButton("btnToolbarEnterQuery");
		if(isNaN($F("txtQuotationYy"))){
			$("txtQuotationYy").value = "";
		}
	});

	$("txtQuotationNo").observe("keyup", function(){
		enableToolbarButton("btnToolbarEnterQuery");
		if(isNaN($F("txtQuotationNo"))){
			$("txtQuotationNo").value = "";
		}
	});

	$("txtProposalNo").observe("keyup", function(){
		enableToolbarButton("btnToolbarEnterQuery");
		if(isNaN($F("txtProposalNo"))){
			$("txtProposalNo").value = "";
		}
	});
	
	$("txtQuotationYy").observe("change", function(){
		if($F("txtQuotationYy") != ""){
			$("txtQuotationYy").value = formatNumberDigits($F("txtQuotationYy"), 4);			
		}
	});

	$("txtQuotationNo").observe("change", function(){
		if($F("txtQuotationNo") != ""){
			$("txtQuotationNo").value = formatNumberDigits($F("txtQuotationNo"), 8);	
		}
	});

	$("txtProposalNo").observe("change", function(){
		if($F("txtProposalNo") != ""){
			$("txtProposalNo").value = formatNumberDigits($F("txtProposalNo"), 3);
		}
		
	});
	
	//reload form
	observeReloadForm("reloadQuoteInfoForm", function(){
		new Ajax.Request(contextPath + "/GIPIQuoteController", {
		    parameters : {action : "viewQuotationInformation"},
		    onCreate : showNotice("Loading, please wait..."),
			onComplete : function(response){
				hideNotice();
				try {
					if(checkErrorOnResponse(response)){
						enableInputField("txtLineCd");
						enableInputField("txtSublineCd");
						enableInputField("txtIssCd");
						enableInputField("txtQuotationYy");
						enableInputField("txtQuotationNo");
						enableInputField("txtProposalNo");
						executeFlag = false;
						$("dynamicDiv").update(response.responseText);
					}
				} catch(e){
					showErrorMessage("viewQuotationInformation - onComplete : ", e);
				}
			} 
		});
	});

	hideToolbarButton("btnToolbarPrint"); 
	$("txtLineCd").focus();
	toggleButtons(false);
	initializeGIIMM014();
	
</script>
