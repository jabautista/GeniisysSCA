<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="giac202TempDiv" name="giac202TempDiv"></div>
<div id="billsByAssdAndAgeMainDiv" name="billsByAssdAndAgeMainDiv">
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
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Aging by Assured (For a Give Age Level)</label>
	   		<span class="refreshers" style="margin-top: 0;">
	   		</span>
	   	</div>
	</div>
	<div class="sectionDiv">
		<table style="margin: 10px auto;">
			<tr>		
				<td class="rightAligned">Fund</td>
				<td class="leftAligned">
					<span class="lovSpan" class="required" style="width: 300px; margin-right: 60px;">
						<input type="text" id="txtFundDesc" name="txtFundDesc" class="required"  value="${fundDesc}" style="width: 275px; float: left; border: none; height: 14px; margin: 0;" class="" readonly="readonly"/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchFund" class="required" name="imgSearchFund" alt="Go" style="float: right;"/>
					</span>
				</td>
				<td class="rightAligned">Branch</td>
				<td class="leftAligned">
					<span class="lovSpan" class="required" style="width: 240px;">
						<input type="text" id="txtBranchName" name="txtBranchName" class="required" value="${branchName}" style="width: 215px; float: left; border: none; height: 14px; margin: 0;" class="" readonly="readonly"/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchBranch" name="imgSearchBranch" alt="Go" class="required" style="float: right;"/>
					</span>
				</td>
				<td></td>
			</tr>
			<tr>
				<td class="rightAligned">Age Level</td>
				<td class="leftAligned">
					<span class="lovSpan" style="width: 300px;">
						<input type="text" id="txtAgeLevel" name="txtAgeLevel" style="width: 270px; float: left; border: none; height: 14px; margin: 0;" class="" readonly="readonly"/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchAgingLevel" name="imgSearchAgingLevel" alt="Go" style="float: right;"/>
					</span>
				</td>
				<td class="rightAligned">Total Balance Due</td>
				<td class="leftAligned">
					<input class="rightAligned" type="text" id="txtTotBalDue" name="txtTotBalDue" style="width: 234px; float: left; height: 14px; margin: 0;" class="" readonly="readonly"/>
				</td>
				<td>
					<input id="btnListAll" class="button" type="button" tabindex="" value="List All" name="btnListAll" style="width: 60px;">
				</td>
			</tr>
		</table>		
	</div>
	<div class="sectionDiv" style="height: 370px;">
		<div id="billsByAssdAndAgeTGDiv" style="padding-top: 15px; padding-top: 15px; padding-left: 90px; padding-bottom: 0px; float: left;">
			<div id="billsByAssdAndAgeTable" style="height: 285px;">
				Table Grid
			</div>
			<div id="buttonsDiv" class="buttonsDiv" style="width: 100%; padding-top: 20px; margin-left: 165px;">
				<input id="btnSort" class="button" type="button" value="Sort" name="btnSort" style="width: 100px;">
				<input id="btnDetails" class="button" type="button" value="Details" name="btnDetails" style="width: 100px;">
			</div>
		</div>
	</div>
	<input type="hidden" id="hidFundCd" name="hidFundCd" value="${fundCd}"/>
	<input type="hidden" id="hidBranchCd" name="hidBranchCd" value="${branchCd}"/>
	<input type="hidden" id="hidColumnNo" name="hidColumnNo"/>
	<input id="callFrom" type="hidden"  value="${callFrom}"/>
</div>
<script type="text/javascript">
	setModuleId("GIACS202");
	setDocumentTitle("Aging by Assured (For a Give Age Level)");
	initializeAll();
	initializeAllMoneyFields();
	addStyleToInputs();
	checkUserAccess();
	checkCallFrom();
	var objCurrList = null;
	
	var jsonBillsByAssdAndAge = JSON.parse('${jsonBillsByAssdAndAge}');
	var listAllSw = 'N';
	var agingId;
	var assdNo;
	
	function checkUserAccess(){
		try{
			new Ajax.Request(contextPath+"/GIACAccTransController?action=checkUserAccess2", {
				method: "POST",
				parameters: {
					moduleName: "GIACS202"
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(response.responseText == 0){
						showWaitingMessageBox('You are not allowed to access this module.', imgMessage.ERROR, 
								function(){
							goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");
						});  
						
					}
				}
			});
		}catch(e){
			showErrorMessage('checkUserAccess', e);
		}
	}
	
	function checkCallFrom(){
		if($F("callFrom") == "GIACS203" || $F("callFrom") == "GIACS206" || $F("callFrom") == "GIACS207"){
			disableInputField("txtFundDesc");
			disableInputField("txtBranchName");
			disableSearch("imgSearchFund");
			disableSearch("imgSearchBranch");
			disableSearch("imgSearchAgingLevel");
		} else {
			disableToolbarButton("btnToolbarEnterQuery");
			disableButton("btnSort");
		}
	}
	
	billByAssdAndAgeTableModel = {
			id : 202,
			url : contextPath + "/GIACInquiryController?action=showGIACS202&refresh=1"
			+ "&fundCd=" + $F("hidFundCd")
			+ "&branchCd=" + $F("hidBranchCd")
			+ "&columnNo=" + objGIACS202.columnNo,
			options : {
				toolbar : {
					elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
					onFilter : function() {
						setDetailsForm(null);
						tbgBillsByAssdAndAge.keys.removeFocus(tbgBillsByAssdAndAge.keys._nCurrentFocus, true);
						tbgBillsByAssdAndAge.keys.releaseKeys();
						disableFormButton();
					}
				},
				width : '750px',
				height : '250px',
				onCellFocus : function(element, value, x, y, id) {
					objCurrList = tbgBillsByAssdAndAge.geniisysRows[y];
					setDetailsForm(tbgBillsByAssdAndAge.geniisysRows[y]);
					listAllSw = 'Y';
				},
				prePager : function() {
					setDetailsForm(null);
					tbgBillsByAssdAndAge.keys.removeFocus(tbgBillsByAssdAndAge.keys._nCurrentFocus, true);
					tbgBillsByAssdAndAge.keys.releaseKeys();
					disableFormButton();
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					//setDetailsForm(null);
					tbgBillsByAssdAndAge.keys.removeFocus(tbgBillsByAssdAndAge.keys._nCurrentFocus, true);
					tbgBillsByAssdAndAge.keys.releaseKeys();
					disableFormButton();
					listAllSw = 'N';
				},
				afterRender : function() {
					tbgBillsByAssdAndAge.keys.removeFocus(tbgBillsByAssdAndAge.keys._nCurrentFocus, true);
					tbgBillsByAssdAndAge.keys.releaseKeys();
					disableFormButton();
				},
				onSort : function() {
					//setDetailsForm(null);
					tbgBillsByAssdAndAge.keys.removeFocus(tbgBillsByAssdAndAge.keys._nCurrentFocus, true);
					tbgBillsByAssdAndAge.keys.releaseKeys();
					disableFormButton();
				},
				onRowDoubleClick: function(y){
					setDetailsForm(tbgBillsByAssdAndAge.geniisysRows[y]);
					showDetailsDirOverlay();
				}
			},
			columnModel : [{
				id : 'recordStatus',
				title : '',
				width : '0',
				visible : false
			},{
				id : 'divCtrId',
				width : '0',
				visible : false
			}, {
				id : "a020AssdNo",
				title : "Assured No.",
				width : '150px',
				titleAlign : 'left',
				filterOption : true,
				align : 'left'
			}, {
				id : "assdName",
				title : "Assured Name",
				titleAlign : 'left',
				width : '428px',
				filterOption : true,
				align : 'left',
			}, {
				id : "balanceAmtDue",
				title : "Balance Amount Due",
				titleAlign : 'right',
				width : '143px',
				geniisysClass: 'money',
				align : 'right',
			}],
			rows : jsonBillsByAssdAndAge.rows
	};
	tbgBillsByAssdAndAge = new MyTableGrid(billByAssdAndAgeTableModel);
	tbgBillsByAssdAndAge.pager = jsonBillsByAssdAndAge;
	tbgBillsByAssdAndAge.render('billsByAssdAndAgeTable');
	tbgBillsByAssdAndAge.afterRender = function(){
		tbgBillsByAssdAndAge.keys.removeFocus(tbgBillsByAssdAndAge.keys._nCurrentFocus, true);
		tbgBillsByAssdAndAge.keys.releaseKeys();
		
		if(tbgBillsByAssdAndAge.geniisysRows.length > 0){
			var rec = tbgBillsByAssdAndAge.geniisysRows[0];
			tbgBillsByAssdAndAge.selectRow('0');
			setDetailsForm(rec);
		}
	};
	
	function setDetailsForm(rec){
		try {
			$("txtAgeLevel").value = rec == null ? "" : rec.columnHeading;
			$("txtTotBalDue").value = rec == null ? "" : formatCurrency(rec.sumBalanceAmtDue);
			agingId = rec == null ? "" : rec.gagpAgingId;
			assdNo = rec == null ? "" : rec.a020AssdNo;
		} catch (e) {
			showErrorMessage("setDetailsForm", e);
		}
	}
	
	function showAgingListAllPopUp(){
		try {
			overlayAgingListAllPopUp = 
				Overlay.show(contextPath+"/GIACInquiryController", {
					urlContent: true,
					urlParameters: {action    : "showAgingListAllPopUp",																
									ajax      : "1",
									fundCd    : $F("hidFundCd"),
									branchCd  : $F("hidBranchCd"),
					},
				    title: "Aging Totals List",
				    height: 300,
				    width: 470,
				    draggable: true
				});
			} catch (e) {
				showErrorMessage("Overlay Error: " , e);
			}
	}
	
	$("btnListAll").observe("click", function(){
		showAgingListAllPopUp();
	});
	
	function showSortPopUp(){
		try {
			overlayAgingSortPopUp = 
				Overlay.show(contextPath+"/GIACInquiryController", {
					urlContent: true,
					urlParameters: {action    : "showSortPopUp",																
									ajax      : "1",
									fundCd    : $F("hidFundCd"),
									branchCd  : $F("hidBranchCd"),
									columnNo  : $F("hidColumnNo")
					},
				    title: "Sort",
				    height: 250,
				    width: 350,
				    draggable: true
				});
			} catch (e) {
				showErrorMessage("Overlay Error: " , e);
			}
	}
	
	$("btnSort").observe("click", function(){
		showSortPopUp();
	});
	
	$("btnDetails").observe("click", function(){
		if ($F("txtAgeLevel") == null || $F("txtAgeLevel") == ""){
			showMessageBox("No record selected.", "I");
		} else {
			tbgBillsByAssdAndAge.keys.removeFocus(tbgBillsByAssdAndAge.keys._nCurrentFocus, true);
			tbgBillsByAssdAndAge.keys.releaseKeys();
			showDetailsDirOverlay();
		}
	});
	
	function showDetailsDirOverlay(){
		try {
			overlayShowDetailsDirOverlay = 
				Overlay.show(contextPath+"/GIACInquiryController", {
					urlContent: true,
					urlParameters: {action     : "showDetailsDirOverlay",																
									ajax       : "1",
									fundCd     : $F("hidFundCd"),
									branchCd   : $F("hidBranchCd"),
									agingId    : agingId,
									assdNo     : assdNo,
									fundDesc   : $F("txtFundDesc"),
									branchName : $F("txtBranchName")
					},
				    title: "Details",
				    height: 250,
				    width: 350,
				    draggable: true
				});
			} catch (e) {
				showErrorMessage("Overlay Error: " , e);
			}
	}
	
	$("btnToolbarExit").observe("click", function() {
		objGIACS202.columnNo = "";
		objGIACS202.multiSort = null;
		objGIACS202.msortOrder = [];
		objGIACS202.agingSortURL = null;
		objGIACS203.multiSort = null;
		objGIACS203.msortOrder = [];
		objGIACS203.agingSortURL = null;
		objGIACS204.multiSort = null;
		objGIACS204.msortOrder = [];
		objGIACS204.agingSortURL = null;
		objGIACS207.multiSort = null;
		objGIACS207.msortOrder = [];
		objGIACS207.agingSortURL = null;
		objGIACS207AssdList.multiSort = null;
		objGIACS207AssdList.msortOrder = [];
		objGIACS207AssdList.agingSortURL = null;
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");
	});
	
	function disableFormButton(){
		disableToolbarButton("btnToolbarExecuteQuery");
	}
	
	function getAgingLevelListLOV(){
		LOV.show({
			controller: 'AccountingLOVController',
			urlParameters: {
				action:		"getAgingLevelListLOV"
			},
			title: "Valid Values for Aging Level",
			width: 405,
			height: 386,
			draggable: true,
			columnModel: [
				{
					id: "columnNo",
					title: "Column Number",
					width: "100px"
				},
				{
					id: "columnHeading",
					title: "Column Heading",
					width: "290px"
				}
			],
			onSelect: function(row){
				if(row != undefined){
					$("txtAgeLevel").value = row.columnHeading;
					$("hidColumnNo").value = row.columnNo;
					objGIACS202.columnNo = row.columnNo;
				}
			}
		});
	}
	
	$("imgSearchAgingLevel").observe("click", function(){
		getAgingLevelListLOV();
	});
	
	$("imgSearchFund").observe("click", function() {
		enableToolbarButton("btnToolbarEnterQuery");
		//showGIACSInquiryFundLOV("getGIACSInquiryFundLOV", $("txtFundDesc"), "Code", "Description", $("hidFundCd"), $("txtBranchName"), "txtFundDesc");
		showFundLOV();
	});
	
	function showFundLOV(){
		LOV.show({
			controller : "AccountingLOVController",
			urlParameters : {
				action : "getGIACS237FundLOV",
				searchString : $("txtFundDesc").value,
				page : 1,
				controlModule : "GIACS202"
			},
			title : "Valid Values for Company",
			width : 480,
			height : 386,
			columnModel : [ {
				id : "fundCd",
				title : "Code",
				width : '120px',
			}, {
				id : "fundDesc",
				title : "Description",
				width : '345px',
				renderer: function(value) {
					return unescapeHTML2(value);
				}
			} ],
			draggable : true,
			autoSelectOneRecord: true,
			filterText:  $("txtFundDesc").value,
			onSelect : function(row) {
				$("txtFundDesc").value = unescapeHTML2(row.fundDesc);
				$("hidFundCd").value = unescapeHTML2(row.fundCd);
				if($F("txtBranchName") == ""){
					
				} else {
					enableToolbarButton("btnToolbarExecuteQuery");
				}
			},
			onCancel : function () {
				$("txtFundDesc").focus();
			},
			onUndefinedRow : function(){
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtFundDesc");
			}
		});
	}
	
	$("imgSearchBranch").observe("click", function() {
		enableToolbarButton("btnToolbarEnterQuery");
		//showGIACSInquiryBranchLOV("GIACS202", "getGIACSInquiryBranchLOV", $("hidFundCd"), $("txtBranchName"), "Code", "Description", $("hidBranchCd"), $F("txtFundDesc"), "txtBranchName");
		showBranchLOV();
	});
	
	function showBranchLOV(){
		LOV.show({
			controller : "AccountingLOVController",
			urlParameters : {
				action : "getGIACS202BranchLOV",
				searchString : $("txtBranchName").value,
				fundCd : $F("hidFundCd"),
				page : 1,
				controlModule : "GIACS202"
			},
			title : "Valid Values for Branch",
			width : 480,
			height : 386,
			columnModel : [ {
				id : "branchCd",
				title : "Code",
				width : '120px',
			}, {
				id : "branchName",
				title : "Description",
				width : '345px',
				renderer: function(value) {
					return unescapeHTML2(value);
				}
			} ],
			draggable : true,
			autoSelectOneRecord: true,
			filterText:  $("txtBranchName").value,
			onSelect : function(row) {
				$("txtBranchName").value = unescapeHTML2(row.branchName);
				$("hidBranchCd").value = unescapeHTML2(row.branchCd);
				if($F("txtFundDesc") == ""){
					
				} else {
					enableToolbarButton("btnToolbarExecuteQuery");
				}
			},
			onCancel : function () {
				$("txtBranchName").focus();
			},
			onUndefinedRow : function(){
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtBranchName");
			}
		});
	}	
	
	$("txtBranchName").observe("change", function() {
		enableToolbarButton("btnToolbarEnterQuery");
		$("hidBranchCd").value = null;
		disableToolbarButton("btnToolbarExecuteQuery");
		showGIACSInquiryBranchLOV("GIACS202", "getGIACSInquiryBranchLOV", $("hidFundCd"), $("txtBranchName"), "Code", "Description", $("hidBranchCd"), $F("txtFundDesc"), "txtBranchName");
	});
	
	$("txtFundDesc").observe("change", function() {
		enableToolbarButton("btnToolbarEnterQuery");
		$("hidFundCd").value = null;
		disableToolbarButton("btnToolbarExecuteQuery");
		showGIACSInquiryFundLOV("getGIACSInquiryFundLOV", $("txtFundDesc"), "Code", "Description", $("hidFundCd"), $("txtBranchName"), "txtFundDesc");
	});
	
	$("btnToolbarEnterQuery").observe("click", function() {
		showGIACS202("menu", null, null, null, null, null);
	});
	
	function execute() {
		tbgBillsByAssdAndAge.url = contextPath + "/GIACInquiryController?action=showGIACS202&refresh=1&fundCd=" + $F("hidFundCd")
												+ "&branchCd=" + $F("hidBranchCd") + "&columnNo=" + $F("hidColumnNo");
		tbgBillsByAssdAndAge._refreshList();
		disableInputField("txtFundDesc");
		disableInputField("txtBranchName");
		disableInputField("txtAgeLevel");
		disableSearch("imgSearchFund");
		disableSearch("imgSearchBranch");
		disableSearch("imgSearchAgingLevel");
		enableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
		enableButton("btnSort");
	};
	
	$("btnToolbarExecuteQuery").observe("click", function() {
		if ($("txtFundDesc").value != "" && $("txtBranchName").value != "") {
			exec = true;
			execute();
		}
	});
	
	disableFormButton();
</script>