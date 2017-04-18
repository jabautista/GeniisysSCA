<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="giacs207TempDiv" name="giacs207TempDiv"></div>
<div id="billsForAnAssdMainDiv" name="billsForAnAssdMainDiv">
	<div id="toolbarDiv" name="toolbarDiv">
		<div class="toolButton" style="float: right;">
			<span style="background: url(${pageContext.request.contextPath}/images/toolbar/exit.png) left center no-repeat;" id="btnToolbarExit">Exit</span>
			<span style="display: none; background: url(${pageContext.request.contextPath}/images/toolbar/exitDisabled.png) left center no-repeat;" id="btnToolbarExitDisabled">Exit</span>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>List of Bills (For an Assured)</label>
	   		<span class="refreshers" style="margin-top: 0;"> 
	   		</span>
	   	</div>
	</div>
	<div class="sectionDiv">
		<table style="margin: 10px auto;">
			<tr>
				<td class="rightAligned">Assured</td>
				<td class="leftAligned" colspan="3">
					<input type="text" id="txtAssdNo" name="txtAssdNo" tabindex="101" style="width: 100px; float: left; height: 14px; margin: 0; margin-right: 5px;" class="" readonly="readonly"/>
					<input type="text" id="txtAssdName" name="txtAssdName" tabindex="102" style="width: 599px; float: left; height: 14px; margin: 0;" class="" readonly="readonly"/>
				</td>
				<td>
					<input id="btnListAll" class="button" type="button" value="List All" name="btnListAll" style="width: 60px;">
				</td>
			</tr>
		</table>
	</div>
	<div class="sectionDiv" style="height: 390px;">
		<div id="billsForAnAssdTGDiv" style="padding-top: 15px; padding-top: 15px; padding-left: 60px; padding-bottom: 0px; float: left;">
			<div id="billsForAnAssdTable" style="height: 285px;">
				Table Grid
			</div>
			<table style="padding-top: 0px; margin-left: 325px;">
				<tr>
					<td class="rightAligned">Totals</td>
					<td class="leftAligned">
						<input class="rightAligned" type="text" id="txtSumTotBalDue" name="txtSumTotBalDue" tabindex="103" style="width: 130px; float: left; height: 14px; margin: 0;" class="" readonly="readonly"/>
					</td>
					<td class="leftAligned">
						<input class="rightAligned" type="text" id="txtSumTotPayments" name="txtSumTotPayments" tabindex="104" style="width: 130px; float: left; height: 14px; margin: 0;" class="" readonly="readonly"/>
					</td>
					<td class="leftAligned">
						<input class="rightAligned" type="text" id="txtSumTotAmtDue" name="txtSumTotAmtDue" tabindex="105" style="width: 130px; float: left; height: 14px; margin: 0;" class="" readonly="readonly"/>
					</td>
				</tr>
			</table>
			<div id="buttonsDiv" class="buttonsDiv" style="width: 100%; padding-top: 20px; margin-left: 0px;">
				<input id="btnSort" class="button" type="button" value="Sort" name="btnSort" style="width: 100px;">
				<input id="btnDetails" class="button" type="button" value="Details" name="btnDetails" style="width: 100px;">
				<input id="btnReturn" class="button" type="button" value="Return" name="btnReturn" style="width: 100px;">
			</div>
		</div>
	</div>
	<div>
		<input id="fundDesc"   type="hidden"  value="${fundDesc}"/>
		<input id="fundCd"     type="hidden"  value="${fundCd}"/>
		<input id="branchName" type="hidden"  value="${branchName}"/>
		<input id="branchCd"   type="hidden"  value="${branchCd}"/>
		<input id="agingId"    type="hidden"  value="${agingId}"/>
		<input id="assdNo"     type="hidden"  value="${assdNo}"/>
		<input id="selectedAgingId"            type="hidden"/>
		<input id="selectedBranchCd"           type="hidden"/>
	</div>
</div>
<script type="text/javascript">
	initializeAll();
	setModuleId("GIACS207");
	setDocumentTitle("List of Bills (For an Assured)");
	objGIACS207.currentForm = "GIACS207";
	var jsonBillsForAnAssdDtls = JSON.parse('${jsonBillsForAnAssdDtls}');
	
	billsForAnAssdDtlsTableModel = {
			id : 207,
			url : contextPath + "/GIACInquiryController?action=showGIACS207&refresh=1"
			+ "&assdNo=" + $F("assdNo")
			+ "&agingId=" + $F("agingId")
			+ "&branchCd=" + $F("branchCd"),
			options : {
				toolbar : {
					elements : [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter : function() {
						rowIndex = -1;
						setDetailsForm(null);
						tbgBillsForAnAssdDtls.keys.removeFocus(tbgBillsForAnAssdDtls.keys._nCurrentFocus, true);
						tbgBillsForAnAssdDtls.keys.releaseKeys();
					}
				},
				width : '800px',
				height : '250px',
				onCellFocus : function(element, value, x, y, id) {
					tbgBillsForAnAssdDtls.keys.removeFocus(tbgBillsForAnAssdDtls.keys._nCurrentFocus, true);
					tbgBillsForAnAssdDtls.keys.releaseKeys();
					setDetailsForm(tbgBillsForAnAssdDtls.geniisysRows[y]);
				},
				prePager : function() {
					setDetailsForm(null);
					tbgBillsForAnAssdDtls.keys.removeFocus(tbgBillsForAnAssdDtls.keys._nCurrentFocus, true);
					tbgBillsForAnAssdDtls.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					//setDetailsForm(null);
					tbgBillsForAnAssdDtls.keys.removeFocus(tbgBillsForAnAssdDtls.keys._nCurrentFocus, true);
					tbgBillsForAnAssdDtls.keys.releaseKeys();
					$("selectedAgingId").value = "";
				},
				afterRender : function() {
					tbgBillsForAnAssdDtls.keys.removeFocus(tbgBillsForAnAssdDtls.keys._nCurrentFocus, true);
					tbgBillsForAnAssdDtls.keys.releaseKeys();
				},
				onSort : function() {
					//setDetailsForm(null);
					tbgBillsForAnAssdDtls.keys.removeFocus(tbgBillsForAnAssdDtls.keys._nCurrentFocus, true);
					tbgBillsForAnAssdDtls.keys.releaseKeys();
					$("selectedAgingId").value = "";
				}, 
				onRefresh: function(){
					if(objGIACS207.currentForm == "GIACS207"){
						if(objGIACS207.multiSort != null){
							objGIACS207.multiSort = null;
							objGIACS207.msortOrder = [];
							objGIACS207.agingSortURL = null;
							tbgBillsForAnAssdDtls.url = contextPath + "/GIACInquiryController?action=showGIACS207&refresh=1&assdNo=" + $F("assdNo")
							+ "&multiSort=" + ""
							+ "&agingId=" + $F("agingId")
							+ "&branchCd=" + $F("branchCd");
							tbgBillsForAnAssdDtls._refreshList();
						}
					}
				},
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
				id : "columnHeading",
				title : "Age Level",
				titleAlign : 'left',
				width : '140px',
				align : 'left'
				//filterOption : true
			},{
				id : "issCd",
				title : "Iss Cd",
				titleAlign : 'left',
				width : '82px',
				align : 'left'
				//filterOption : true
			},{
				id : "billNo",
				title : "Bill Number",
				titleAlign : 'left',
				width : '140px',
				filterOption : true,
				align : 'left',
				filterOption : true
			},{
				id : "balanceAmtDue",
				title : "Balance Due",
				titleAlign : 'right',
				width : '140px',
				geniisysClass: 'money',
				align : 'right',
				filterOption : true,
				filterOptionType : 'number'
			},{
				id : "totalPayments",
				title : "Total Payments",
				titleAlign : 'right',
				width : '140px',
				geniisysClass: 'money',
				align : 'right',
				filterOption : true,
				filterOptionType : 'number'
			},{
				id : "totalAmountDue",
				title : "Total Amount Due",
				titleAlign : 'right',
				width : '140px',
				geniisysClass: 'money',
				align : 'right',
				filterOption : true,
				filterOptionType : 'number'
			}],
			rows : jsonBillsForAnAssdDtls.rows
	};
	tbgBillsForAnAssdDtls = new MyTableGrid(billsForAnAssdDtlsTableModel);
	tbgBillsForAnAssdDtls.pager = jsonBillsForAnAssdDtls;
	tbgBillsForAnAssdDtls.render('billsForAnAssdTable');
	tbgBillsForAnAssdDtls.afterRender = function(){
		tbgBillsForAnAssdDtls.keys.removeFocus(tbgBillsForAnAssdDtls.keys._nCurrentFocus, true);
		tbgBillsForAnAssdDtls.keys.releaseKeys();
		
		if(tbgBillsForAnAssdDtls.geniisysRows.length > 0){
			var rec = tbgBillsForAnAssdDtls.geniisysRows[0];
			tbgBillsForAnAssdDtls.selectRow('0');
			setDetailsForm(rec);
		}
	};
	
	function setDetailsForm(rec){
		try {
			$("txtAssdNo").value = $("txtAssdNo").value == "" ? rec == null ? "" : rec.assdNo : $("txtAssdNo").value;
			$("txtAssdName").value = $("txtAssdName").value == "" ? rec == null ? "" : unescapeHTML2(rec.assdName) : $("txtAssdName").value;
			$("txtSumTotBalDue").value = rec == null ? "" : formatCurrency(rec.sumBalanceAmtDue);
			$("txtSumTotPayments").value = rec == null ? "" : formatCurrency(rec.sumTotalPayments);
			$("txtSumTotAmtDue").value = rec == null ? "" : formatCurrency(rec.sumTotalAmountDue);
			$("selectedAgingId").value = rec == null ? "" : rec.agingId;
			$("selectedBranchCd").value = rec == null ? "" : rec.issCd;
		} catch (e) {
			showErrorMessage("setDetailsForm", e);
		}
	}
	
	function showSortPopUp(){
		try {
			overlayBillsUnderAgeSortPopUp = 
				Overlay.show(contextPath+"/GIACInquiryController", {
					urlContent: true,
					urlParameters: {action    : "showGIACS207SortPopUp",																
									ajax      : "1",
									assdNo    : $F("assdNo"),
					},
				    title: "Sort",
				    height: 280,
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
	
	function showAssuredListAllPopUp(){
		try {
			overlayAssuredListAllPopUp = 
				Overlay.show(contextPath+"/GIACInquiryController", {
					urlContent: true,
					urlParameters: {action    : "showAssuredListAllPopUp",																
									ajax      : "1",
									fundCd    : $F("assdNo"),
					},
				    title: "List of Assured Names",
				    height: 390,
				    width: 550,
				    draggable: true
				});
			} catch (e) {
				showErrorMessage("Overlay Error: " , e);
			}
	}
	
	$("btnListAll").observe("click", function(){
		showAssuredListAllPopUp();
	});
	
	$("btnDetails").observe("click", function(){
		if ($F("selectedAgingId") == null || $F("selectedAgingId") == ""){
			showMessageBox("No record selected.", "I");
		} else {
			try{
				new Ajax.Request(contextPath+"/GIACAccTransController?action=checkUserAccess2", {
					method: "POST",
					parameters: {
						moduleName: 'GIACS204'
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
							showGIACS204("GIACS207", $F("fundCd"), $F("branchCd"), $F("selectedBranchCd"), $F("agingId"), $F("selectedAgingId"), $F("assdNo"), $F("fundDesc"), $F("branchName"));
						}
					}
				});
			}catch(e){
				showErrorMessage('checkUserAccess', e);
			}
		}
	});
	
	$("btnReturn").observe("click", function(){
		objGIACS207.multiSort = null;
		objGIACS207.msortOrder = [];
		objGIACS207.agingSortURL = null;
		objGIACS207.currentForm = null;
		//showGIACS202("GIACS207", $F("fundCd"), $F("branchCd"), objGIACS202.columnNo, objGIACS202.multiSort, $F("fundDesc"), $F("branchName"));
		$("billsByAssdAndAgeMainDiv").style.display = null;
		$("giac202TempDiv").style.display = "none";
		setModuleId("GIACS202");
		setDocumentTitle("Aging by Assured (For a Give Age Level)");
	});
	
	$("btnToolbarExit").observe("click", function() {
		objGIACS207.multiSort = null;
		objGIACS207.msortOrder = [];
		objGIACS207.agingSortURL = null;
		objGIACS207.currentForm = null;
		//showGIACS202("GIACS207", $F("fundCd"), $F("branchCd"), objGIACS202.columnNo, objGIACS202.multiSort, $F("fundDesc"), $F("branchName"));
		$("billsByAssdAndAgeMainDiv").style.display = null;
		$("giac202TempDiv").style.display = "none";
		setModuleId("GIACS202");
		setDocumentTitle("Aging by Assured (For a Give Age Level)");
	});
	$("txtAssdNo").focus();
</script>