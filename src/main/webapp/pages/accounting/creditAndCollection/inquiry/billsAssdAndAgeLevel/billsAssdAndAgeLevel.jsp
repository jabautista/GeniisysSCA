<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="giacs204TempDiv" name="giacs204TempDiv"></div>
<div id="billsAssdAndAgeLevelMainDiv" name="billsAssdAndAgeLevelMainDiv">
	<div id="toolbarDiv" name="toolbarDiv">
		<div class="toolButton" style="float: right;">
			<span style="background: url(${pageContext.request.contextPath}/images/toolbar/exit.png) left center no-repeat;" id="btnToolbarExit">Exit</span>
			<span style="display: none; background: url(${pageContext.request.contextPath}/images/toolbar/exitDisabled.png) left center no-repeat;" id="btnToolbarExitDisabled">Exit</span>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>List of Bills (Assured and Age Level)</label>
	   		<span class="refreshers" style="margin-top: 0;"> 
	   		</span>
	   	</div>
	</div>
	<div class="sectionDiv">
		<table style="margin: 10px auto;">
			<tr>
				<td class="rightAligned">Fund</td>
				<td class="leftAligned">
					<input type="text" id="txtFundDesc" name="txtFundDesc" value="${fundCd}" style="width: 294px; float: left; height: 14px; margin: 0;" class="" readonly="readonly"/>
				</td>
				<td class="rightAligned">Branch</td>
				<td class="leftAligned">
					<input type="text" id="txtBranchName" name="txtBranchName" value="${selectedBranchCd}" style="width: 294px; float: left; height: 14px; margin: 0;" class="" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Age Level</td>
				<td class="leftAligned">
					<input type="text" id="txtAgeLevel" name="txtAgeLevel" style="width: 294px; float: left; height: 14px; margin: 0;" class="" readonly="readonly"/>
				</td>
				<td class="rightAligned">Total Balance Due</td>
				<td class="leftAligned">
					<input class="rightAligned" type="text" id="txtTotBalDue" name="txtTotBalDue" style="width: 294px; float: left; height: 14px; margin: 0;" class="" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Assured</td>
				<td class="leftAligned" colspan="3">
					<input type="text" id="txtAssdNo" name="txtAssdNo" style="width: 100px; float: left; height: 14px; margin: 0; margin-right: 5px;" class="" readonly="readonly"/>
					<input type="text" id="txtAssdName" name="txtAssdName" style="width: 599px; float: left; height: 14px; margin: 0;" class="" readonly="readonly"/>
				</td>
			</tr>
		</table>
	</div>
	<div class="sectionDiv" style="height: 370px;">
		<div id="billsAssdAndAgeLevelTGDiv" style="padding-top: 15px; padding-top: 15px; padding-left: 210px; padding-bottom: 0px; float: left;">
			<div id="billsAssdAndAgeLevelTable" style="height: 285px;">
				Table Grid
			</div>
			<div id="buttonsDiv" class="buttonsDiv" style="width: 100%; padding-top: 20px; margin-left: 65px;">
				<input id="btnSort" class="button" type="button" value="Sort" name="btnSort" style="width: 100px;">
				<input id="btnDetails" class="button" type="button" value="Details" name="btnDetails" style="width: 100px;">
				<input id="btnReturn" class="button" type="button" value="Return" name="btnReturn" style="width: 100px;">
			</div>
		</div>
	</div>
	<div>
		<input id="fundDesc"            type="hidden"  value="${fundDesc}"/>
		<input id="fundCd"              type="hidden"  value="${fundCd}"/>
		<input id="branchName"          type="hidden"  value="${branchName}"/>
		<input id="branchCd"            type="hidden"  value="${branchCd}"/>
		<input id="agingId"             type="hidden"  value="${agingId}"/>
		<input id="assdNo"              type="hidden"  value="${assdNo}"/>
		<input id="callFrom"            type="hidden"  value="${callFrom}"/>
		<input id="selectedAgingId"     type="hidden"  value="${selectedAgingId}"/>
		<input id="selectedBranchCd"    type="hidden"  value="${selectedBranchCd}"/>
	</div>
</div>
<script type="text/javascript">
	initializeAll();
	setModuleId("GIACS204");
	setDocumentTitle("List of Bills (Assured and Age Level)");
	objGIACS203.currentForm = "GIACS204";
	var jsonBillsAssdAndAgeLevel = JSON.parse('${jsonBillsAssdAndAgeLevel}');
	
	billsAssdAndAgeLevelTableModel = {
			id : 204,
			url : contextPath + "/GIACInquiryController?action=showGIACS204&refresh=1"
			+ "&selectedAgingId=" + $F("selectedAgingId")
			+ "&selectedBranchCd=" + $F("selectedBranchCd")
			+ "&assdNo=" + $F("assdNo"),
			options : {
				toolbar : {
					elements : [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter : function() {
						setDetailsForm(null);
						tbgBillsAssdAndAgeLevel.keys.removeFocus(tbgBillsAssdAndAgeLevel.keys._nCurrentFocus, true);
						tbgBillsAssdAndAgeLevel.keys.releaseKeys();
					}
				},
				width : '505px',
				height : '250px',
				onCellFocus : function(element, value, x, y, id) {
					tbgBillsAssdAndAgeLevel.keys.removeFocus(tbgBillsAssdAndAgeLevel.keys._nCurrentFocus, true);
					tbgBillsAssdAndAgeLevel.keys.releaseKeys();
					setDetailsForm(tbgBillsAssdAndAgeLevel.geniisysRows[y]);
				},
				prePager : function() {
					//setDetailsForm(null);
					tbgBillsAssdAndAgeLevel.keys.removeFocus(tbgBillsAssdAndAgeLevel.keys._nCurrentFocus, true);
					tbgBillsAssdAndAgeLevel.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					//setDetailsForm(null);
					tbgBillsAssdAndAgeLevel.keys.removeFocus(tbgBillsAssdAndAgeLevel.keys._nCurrentFocus, true);
					tbgBillsAssdAndAgeLevel.keys.releaseKeys();
				},
				afterRender : function() {
					tbgBillsAssdAndAgeLevel.keys.removeFocus(tbgBillsAssdAndAgeLevel.keys._nCurrentFocus, true);
					tbgBillsAssdAndAgeLevel.keys.releaseKeys();
				},
				onSort : function() {
					//setDetailsForm(null);
					tbgBillsAssdAndAgeLevel.keys.removeFocus(tbgBillsAssdAndAgeLevel.keys._nCurrentFocus, true);
					tbgBillsAssdAndAgeLevel.keys.releaseKeys();
				},
				onRefresh : function(){
					if(objGIACS204.currentForm == "GIACS204"){
						if(objGIACS204.multiSort != null){
							objGIACS204.multiSort = null;
							objGIACS204.msortOrder = [];
							objGIACS204.agingSortURL = null;
							tbgBillsAssdAndAgeLevel.url = contextPath + "/GIACInquiryController?action=showGIACS204&refresh=1&selectedAgingId=" + $F("selectedAgingId")
							+ "&selectedBranchCd=" + $F("selectedBranchCd") + "&assdNo=" + $F("assdNo") + "&multiSort=" + "";
							tbgBillsAssdAndAgeLevel._refreshList();
						}
					}
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
			},{
				id : "billNo",
				title : "Bill Number",
				titleAlign : 'left',
				width : '100px',
				filterOption : true,
				align : 'left',
			}, {
				id : "totalAmountDue",
				title : "Total Amount Due",
				titleAlign : 'right',
				width : '130px',
				geniisysClass: 'money',
				align : 'right',
				filterOption : true,
				filterOptionType : 'numberNoNegative'
			}, {
				id : "totalPayments",
				title : "Total Payments",
				titleAlign : 'right',
				width : '130px',
				geniisysClass: 'money',
				align : 'right',
				filterOption : true,
				filterOptionType : 'numberNoNegative'
			}, {
				id : "balanceAmtDue",
				title : "Balance Due",
				titleAlign : 'right',
				width : '130px',
				geniisysClass: 'money',
				align : 'right',
				filterOption : true,
				filterOptionType : 'numberNoNegative'
			}],
			rows : jsonBillsAssdAndAgeLevel.rows
	};
	tbgBillsAssdAndAgeLevel = new MyTableGrid(billsAssdAndAgeLevelTableModel);
	tbgBillsAssdAndAgeLevel.pager = jsonBillsAssdAndAgeLevel;
	tbgBillsAssdAndAgeLevel.render('billsAssdAndAgeLevelTable');
	tbgBillsAssdAndAgeLevel.afterRender = function(){
		tbgBillsAssdAndAgeLevel.keys.removeFocus(tbgBillsAssdAndAgeLevel.keys._nCurrentFocus, true);
		tbgBillsAssdAndAgeLevel.keys.releaseKeys();
		
		if(tbgBillsAssdAndAgeLevel.geniisysRows.length > 0){
			var rec = tbgBillsAssdAndAgeLevel.geniisysRows[0];
			tbgBillsAssdAndAgeLevel.selectRow('0');
			setDetailsForm(rec);
		}
	};
	
	function setDetailsForm(rec){
		try {
			$("txtAgeLevel").value = rec == null ? "" : rec.columnHeading;
			$("txtTotBalDue").value = rec == null ? "" : formatCurrency(rec.sumBalanceAmtDue);
			$("txtAssdNo").value = rec == null ? "" : $F("assdNo");
			$("txtAssdName").value = rec == null ? "" : unescapeHTML2(rec.assdName);
		} catch (e) {
			showErrorMessage("setDetailsForm", e);
		}
	}
	
	function showSortPopUp(){
		try {
			overlayBillsUnderAgeSortPopUp = 
				Overlay.show(contextPath+"/GIACInquiryController", {
					urlContent: true,
					urlParameters: {action    : "showGIACS204SortPopUp",																
									ajax      : "1",
									fundCd           : $F("fundCd"),
									branchCd         : $F("branchCd"),
									selectedBranchCd : $F("selectedBranchCd"),
									agingId          : $F("agingId"),
									selectedAgingId  : $F("selectedAgingId"),
									assdNo           : $F("assdNo"),
									fundDesc         : $F("fundDesc"),
									branchName       : $F("branchName")
					},
				    title: "Sort",
				    height: 250,
				    width: 360,
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
		try{
			new Ajax.Request(contextPath+"/GIACAccTransController?action=checkUserAccess2", {
				method: "POST",
				parameters: {
					moduleName: 'GIACS203'
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(response.responseText == 0){
						showWaitingMessageBox('You are not allowed to access this module.', imgMessage.ERROR, 
								function(){
							return false;
						});  
					} else {
						showGIACS203("GIACS204", $F("callFrom"), $F("fundCd"), $F("branchCd"), $F("selectedBranchCd"), $F("agingId"), $F("selectedAgingId"), $F("assdNo"), $F("fundDesc"), $F("branchName"));
					}
				}
			});
		}catch(e){
			showErrorMessage('checkUserAccess', e);
		}
	});
	
	$("btnReturn").observe("click", function(){
		objGIACS204.multiSort = null;
		objGIACS204.msortOrder = [];
		objGIACS204.agingSortURL = null;
		objGIACS204.currentForm = null;
		if($F("callFrom") == "GIACS206"){
			//showGIACS206($F("fundCd"), $F("branchCd"), $F("agingId"), $F("assdNo"), $F("fundDesc"), $F("branchName"));
			$("billsForGivenAssdMainDiv").style.display = null;
			$("giacs206TempDiv").style.display = "none";
			setModuleId("GIACS206");
			setDocumentTitle("Aging by Age Level (For a Given Assured)");
		} else if($F("callFrom") == "GIACS203"){
			if($("billsForGivenAssdMainDiv") != null){
				$("billsForGivenAssdMainDiv").style.display = null;
				$("giacs206TempDiv").style.display = "none";
				setModuleId("GIACS206");
				setDocumentTitle("Aging by Age Level (For a Given Assured)");	
			} else {
				$("billsForAnAssdMainDiv").style.display = null;
				$("giacs207TempDiv").style.display = "none";
				setModuleId("GIACS207");
				setDocumentTitle("List of Bills (For an Assured)");
			}
		} else {
			//showGIACS207($F("fundCd"),$F("branchCd"),$F("agingId"),$F("assdNo"), $F("fundDesc"), $F("branchName"));
			$("billsForAnAssdMainDiv").style.display = null;
			$("giacs207TempDiv").style.display = "none";
			setModuleId("GIACS207");
			setDocumentTitle("List of Bills (For an Assured)");
		}
	});
	
	$("btnToolbarExit").observe("click", function() {
		objGIACS204.multiSort = null;
		objGIACS204.msortOrder = [];
		objGIACS204.agingSortURL = null;
		objGIACS204.currentForm = null;
		if($F("callFrom") == "GIACS206"){
			//showGIACS206($F("fundCd"), $F("branchCd"), $F("agingId"), $F("assdNo"), $F("fundDesc"), $F("branchName"));
			$("billsForGivenAssdMainDiv").style.display = null;
			$("giacs206TempDiv").style.display = "none";
			setModuleId("GIACS206");
			setDocumentTitle("Aging by Age Level (For a Given Assured)");
		} else if($F("callFrom") == "GIACS203"){
			$("billsForGivenAssdMainDiv").style.display = null;
			$("giacs206TempDiv").style.display = "none";
			setModuleId("GIACS206");
			setDocumentTitle("Aging by Age Level (For a Given Assured)");
		} else {
			//showGIACS207($F("fundCd"),$F("branchCd"),$F("agingId"),$F("assdNo"), $F("fundDesc"), $F("branchName"));
			$("billsForAnAssdMainDiv").style.display = null;
			$("giacs207TempDiv").style.display = "none";
			setModuleId("GIACS207");
			setDocumentTitle("List of Bills (For an Assured)");
		}
	});
</script>