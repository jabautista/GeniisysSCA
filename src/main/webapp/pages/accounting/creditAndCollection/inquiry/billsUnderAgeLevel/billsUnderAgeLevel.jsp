<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="giacs203TempDiv" name="giacs203TempDiv"></div>
<div id="billsUnderAgeLevelMainDiv" name="billsUnderAgeLevelMainDiv">
	<div id="toolbarDiv" name="toolbarDiv">
		<div class="toolButton" style="float: right;">
			<span style="background: url(${pageContext.request.contextPath}/images/toolbar/exit.png) left center no-repeat;" id="btnToolbarExit">Exit</span>
			<span style="display: none; background: url(${pageContext.request.contextPath}/images/toolbar/exitDisabled.png) left center no-repeat;" id="btnToolbarExitDisabled">Exit</span>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>List of Bills Under an Age Level</label>
	   		<span class="refreshers" style="margin-top: 0;"> 
	   		</span>
	   	</div>
	</div>
	<div class="sectionDiv">
		<table style="margin: 10px auto;">
			<tr>
				<td class="rightAligned">Fund</td>
				<td class="leftAligned">
					<input type="text" id="txtFundDesc" name="txtFundDesc" value="${fundDesc}" style="width: 294px; float: left; height: 14px; margin: 0;" class="" readonly="readonly"/>
				</td>
				<td class="rightAligned">Branch</td>
				<td class="leftAligned">
					<input type="text" id="txtBranchName" name="txtBranchName" value="${branchName}" style="width: 294px; float: left; height: 14px; margin: 0;" class="" readonly="readonly"/>
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
		<div id="billsUnderAgeLevelTGDiv" style="padding-top: 15px; padding-top: 15px; padding-left: 60px; padding-bottom: 0px; float: left;">
			<div id="billsUnderAgeLevelTable" style="height: 285px;">
				Table Grid
			</div>
			<div id="buttonsDiv" class="buttonsDiv" style="width: 100%; padding-top: 20px; margin-left: 190px;">
				<input id="btnSort" class="button" type="button" value="Sort" name="btnSort" style="width: 100px;">
				<input id="btnReturn" class="button" type="button" value="Return" name="btnReturn" style="width: 100px;">
			</div>
		</div>
	</div>
	<div>
		<input id="callFrom"   type="hidden"  value="${callFrom}"/>
		<input id="pathFrom"   type="hidden"  value="${pathFrom}"/>
		<input id="fundCd"     type="hidden"  value="${fundCd}"/>
		<input id="branchCd"   type="hidden"  value="${branchCd}"/>
		<input id="agingId"    type="hidden"  value="${agingId}"/>
		<input id="assdNo"     type="hidden"  value="${assdNo}"/>
		<input id="selectedAgingId"     type="hidden"  value="${selectedAgingId}"/>
		<input id="selectedBranchCd"    type="hidden"  value="${selectedBranchCd}"/>
	</div>
</div>
<script type="text/javascript">
	initializeAll();
	setModuleId("GIACS203");
	setDocumentTitle("List of Bills Under an Age Level");
	initializeAllMoneyFields();
	addStyleToInputs();
	objGIACS203.currentForm = "GIACS203";
	var jsonGetBillsUnderAgeLevel = JSON.parse('${jsonGetBillsUnderAgeLevel}');
	
	billsUnderAgeLevelTableModel = {
			id : 203,
			url : contextPath + "/GIACInquiryController?action=showGIACS203&refresh=1"
			+ "&fundCd=" + $F("fundCd")
			+ "&selectedBranchCd=" + $F("selectedBranchCd")
			+ "&selectedAgingId=" + $F("selectedAgingId")
			+ "&assdNo=" + $F("assdNo"),
			options : {
				toolbar : {
					elements : [MyTableGrid.REFRESH_BTN ],
					onFilter : function() {
						setDetailsForm(null);
						tbgBillsUnderAgeLevel.keys.removeFocus(tbgBillsUnderAgeLevel.keys._nCurrentFocus, true);
						tbgBillsUnderAgeLevel.keys.releaseKeys();
						disableFormButton();
					}
				},
				width : '800px',
				height : '250px',
				onCellFocus : function(element, value, x, y, id) {
					tbgBillsUnderAgeLevel.keys.removeFocus(tbgBillsUnderAgeLevel.keys._nCurrentFocus, true);
					tbgBillsUnderAgeLevel.keys.releaseKeys();
					setDetailsForm(tbgBillsUnderAgeLevel.geniisysRows[y]);
				},
				prePager : function() {
					//setDetailsForm(null);
					tbgBillsUnderAgeLevel.keys.removeFocus(tbgBillsUnderAgeLevel.keys._nCurrentFocus, true);
					tbgBillsUnderAgeLevel.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					//setDetailsForm(null);
					tbgBillsUnderAgeLevel.keys.removeFocus(tbgBillsUnderAgeLevel.keys._nCurrentFocus, true);
					tbgBillsUnderAgeLevel.keys.releaseKeys();
				},
				afterRender : function() {
					tbgBillsUnderAgeLevel.keys.removeFocus(tbgBillsByAssdAndAge.keys._nCurrentFocus, true);
					tbgBillsUnderAgeLevel.keys.releaseKeys();
				},
				onSort : function() {
					//setDetailsForm(null);
					tbgBillsUnderAgeLevel.keys.removeFocus(tbgBillsUnderAgeLevel.keys._nCurrentFocus, true);
					tbgBillsUnderAgeLevel.keys.releaseKeys();
				},
				onRefresh : function(){
					if(objGIACS203.currentForm == "GIACS203"){
						if(objGIACS203.multiSort != null){
							objGIACS203.multiSort = null;
							objGIACS203.msortOrder = [];
							objGIACS203.agingSortURL = null;
							tbgBillsUnderAgeLevel.url = contextPath + "/GIACInquiryController?action=showGIACS203&refresh=1&fundCd=" + $F("fundCd")
							+ "&selectedBranchCd=" + $F("selectedBranchCd") + "&selectedAgingId=" + $F("selectedAgingId") + "&assdNo=" + $F("assdNo") + "&multiSort=" + "";
							tbgBillsUnderAgeLevel._refreshList();
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
				id : 'agingId',
				width : '0',
				visible : false
			},{
				id : "billNo",
				title : "Bill Number",
				titleAlign : 'left',
				width : '85px',
				filterOption : true,
				align : 'left',
			}, {
				id : "instNo",
				title : "Inst",
				width : '43px',
				titleAlign : 'right',
				align : 'right'
			}, {
				id : "totalAmountDue",
				title : "Total Amount Due",
				titleAlign : 'right',
				width : '110px',
				geniisysClass: 'money',
				align : 'right',
			}, {
				id : "totalPayments",
				title : "Total Payments",
				titleAlign : 'right',
				width : '100px',
				geniisysClass: 'money',
				align : 'right',
			}, {
				id : "tempPayments",
				title : "Temporary Payments",
				titleAlign : 'right',
				width : '130px',
				geniisysClass: 'money',
				align : 'right',
			}, {
				id : "balanceAmtDue",
				title : "Balance Due",
				titleAlign : 'right',
				width : '100px',
				geniisysClass: 'money',
				align : 'right',
			}, {
				id : "premBalanceDue",
				title : "Premium Balance",
				titleAlign : 'right',
				width : '110px',
				geniisysClass: 'money',
				align : 'right',
			}, {
				id : "taxBalanceDue",
				title : "Tax Balance",
				titleAlign : 'right',
				width : '100px',
				geniisysClass: 'money',
				align : 'right',
			}],
			rows : jsonGetBillsUnderAgeLevel.rows
	};
	tbgBillsUnderAgeLevel = new MyTableGrid(billsUnderAgeLevelTableModel);
	tbgBillsUnderAgeLevel.pager = jsonGetBillsUnderAgeLevel;
	tbgBillsUnderAgeLevel.render('billsUnderAgeLevelTable');
	tbgBillsUnderAgeLevel.afterRender = function(){
		tbgBillsUnderAgeLevel.keys.removeFocus(tbgBillsUnderAgeLevel.keys._nCurrentFocus, true);
		tbgBillsUnderAgeLevel.keys.releaseKeys();
		
		if(tbgBillsUnderAgeLevel.geniisysRows.length > 0){
			var rec = tbgBillsUnderAgeLevel.geniisysRows[0];
			tbgBillsUnderAgeLevel.selectRow('0');
			setDetailsForm(rec);
		}
	};
	
	
	function setDetailsForm(rec){
		try {
			$("txtAgeLevel").value = rec == null ? "" : rec.columnHeading;
			$("txtTotBalDue").value = rec == null ? "" : formatCurrency(rec.sumBalanceAmtDue);
			$("txtAssdNo").value = rec == null ? "" : rec.a020AssdNo;
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
					urlParameters: {action    : "showGIACS203SortPopUp",																
									ajax      : "1",
									fundCd    : $F("fundCd"),
									branchCd  : $F("branchCd"),
									agingId   : $F("agingId"),
									assdNo    : $F("assdNo"),
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
	
	$("btnReturn").observe("click", function(){
		objGIACS203.multiSort = null;
		objGIACS203.msortOrder = [];
		objGIACS203.agingSortURL = null;
		objGIACS203.currentForm = null;
		if($F("callFrom") == "GIACS202"){
			//showGIACS202("GIACS203", $F("fundCd"), $F("branchCd"), objGIACS202.columnNo, objGIACS202.multiSort, $F("txtFundDesc"), $F("txtBranchName"));
			$("billsByAssdAndAgeMainDiv").style.display = null;
			$("giac202TempDiv").style.display = "none";
			setModuleId("GIACS202");
			setDocumentTitle("Aging by Assured (For a Give Age Level)");
		} else if ($F("callFrom") == "GIACS204"){
			//showGIACS204($F("pathFrom"), $F("fundCd"), $F("branchCd"), $F("selectedBranchCd"), $F("agingId"), $F("selectedAgingId"), $F("assdNo"), $F("txtFundDesc"), $F("txtBranchName"));
			$("callFrom").value = "GIACS203";
			$("billsAssdAndAgeLevelMainDiv").style.display = null;
			$("giacs204TempDiv").style.display = "none";
			setModuleId("GIACS204");
			setDocumentTitle("List of Bills (Assured and Age Level)");
		}
	});
	
	$("btnToolbarExit").observe("click", function() {
		objGIACS203.multiSort = null;
		objGIACS203.msortOrder = [];
		objGIACS203.agingSortURL = null;
		objGIACS203.currentForm = null;
		if($F("callFrom") == "GIACS202"){
			//showGIACS202("GIACS203", $F("fundCd"), $F("branchCd"), objGIACS202.columnNo, objGIACS202.multiSort, $F("txtFundDesc"), $F("txtBranchName"));
			$("billsByAssdAndAgeMainDiv").style.display = null;
			$("giac202TempDiv").style.display = "none";
			setModuleId("GIACS202");
			setDocumentTitle("Aging by Assured (For a Give Age Level)");
		} else if ($F("callFrom") == "GIACS204"){
			//showGIACS204($F("pathFrom"), $F("fundCd"), $F("branchCd"), $F("selectedBranchCd"), $F("agingId"), $F("selectedAgingId"), $F("assdNo"), $F("txtFundDesc"), $F("txtBranchName"));
			$("callFrom").value = "GIACS203";
			$("billsAssdAndAgeLevelMainDiv").style.display = null;
			$("giacs204TempDiv").style.display = "none";
			setModuleId("GIACS204");
			setDocumentTitle("List of Bills (Assured and Age Level)");
		}
	});
</script>