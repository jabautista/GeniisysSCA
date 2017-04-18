<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="giacs206TempDiv" name="giacs206TempDiv"></div>
<div id="billsForGivenAssdMainDiv" name="billsForGivenAssdMainDiv">
	<div id="toolbarDiv" name="toolbarDiv">
		<div class="toolButton" style="float: right;">
			<span style="background: url(${pageContext.request.contextPath}/images/toolbar/exit.png) left center no-repeat;" id="btnToolbarExit">Exit</span>
			<span style="display: none; background: url(${pageContext.request.contextPath}/images/toolbar/exitDisabled.png) left center no-repeat;" id="btnToolbarExitDisabled">Exit</span>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Aging by Age Level (For a Given Assured)</label>
	   		<span class="refreshers" style="margin-top: 0;"> 
	   		</span>
	   	</div>
	</div>
	<div class="sectionDiv">
		<table style="margin: 10px auto;">
			<tr>
				<td class="rightAligned">Assured</td>
				<td class="leftAligned" colspan="3">
					<input type="text" id="txtAssdNo" name="txtAssdNo" style="width: 100px; float: left; height: 14px; margin: 0; margin-right: 5px;" class="" readonly="readonly"/>
					<input type="text" id="txtAssdName" name="txtAssdName" style="width: 599px; float: left; height: 14px; margin: 0;" class="" readonly="readonly"/>
				</td>
			</tr>
		</table>
	</div>
	<div class="sectionDiv" style="height: 380px;">
		<div id="billsForGivenAssdTGDiv" style="padding-top: 15px; padding-top: 15px; padding-left: 60px; padding-bottom: 0px; float: left;">
			<div id="billsForGivenAssdTable" style="height: 285px; margin-left: 150px;">
				Table Grid
			</div>
			<table style="padding-top: 0px; margin-left: 463px;">
				<tr>
					<td class="rightAligned">Total</td>
					<td class="leftAligned">
						<input class="rightAligned" type="text" id="txtSumTotBalDue" name="txtSumTotBalDue" style="width: 140px; float: left; height: 14px; margin: 0;" class="" readonly="readonly"/>
					</td>
				</tr>
			</table>
			<div id="buttonsDiv" class="buttonsDiv" style="width: 100%; padding-top: 0px; margin-left: 70px;">
				<input id="btnReturn" class="button" type="button" value="Return" name="btnReturn" style="width: 100px;">
				<input id="btnBill" class="button" type="button" value="Bills" name="btnBill" style="width: 100px;">
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
	setModuleId("GIACS206");
	setDocumentTitle("Aging by Age Level (For a Given Assured)");
	var jsonBillsForGivenAssdDtls = JSON.parse('${jsonBillsForGivenAssdDtls}');
	
	billsForGivenAssdTableModel = {
		id : 206,
		url : contextPath + "/GIACInquiryController?action=showGIACS206&refresh=1"
		+ "&fundCd=" + $F("fundCd")
		+ "&branchCd=" + $F("branchCd")
		+ "&agingId=" + $F("agingId")
		+ "&assdNo=" + $F("assdNo"),
		options : {
			toolbar : {
				elements : [MyTableGrid.REFRESH_BTN ],
				onFilter : function() {
					setDetailsForm(null);
					tbgBillsForGivenAssd.keys.removeFocus(tbgBillsForGivenAssd.keys._nCurrentFocus, true);
					tbgBillsForGivenAssd.keys.releaseKeys();
				}
			},
			width : '500px',
			height : '250px',
			onCellFocus : function(element, value, x, y, id) {
				tbgBillsForGivenAssd.keys.removeFocus(tbgBillsForGivenAssd.keys._nCurrentFocus, true);
				tbgBillsForGivenAssd.keys.releaseKeys();
				setDetailsForm(tbgBillsForGivenAssd.geniisysRows[y]);
			},
			prePager : function() {
				//setDetailsForm(null);
				tbgBillsForGivenAssd.keys.removeFocus(tbgBillsForGivenAssd.keys._nCurrentFocus, true);
				tbgBillsForGivenAssd.keys.releaseKeys();
			},
			onRemoveRowFocus : function(element, value, x, y, id) {
				//setDetailsForm(null);
				tbgBillsForGivenAssd.keys.removeFocus(tbgBillsForGivenAssd.keys._nCurrentFocus, true);
				tbgBillsForGivenAssd.keys.releaseKeys();
			},
			afterRender : function() {
				//setDetailsForm(null);
				tbgBillsForGivenAssd.keys.removeFocus(tbgBillsForGivenAssd.keys._nCurrentFocus, true);
				tbgBillsForGivenAssd.keys.releaseKeys();
			},
			onSort : function() {
				//setDetailsForm(null);
				tbgBillsForGivenAssd.keys.removeFocus(tbgBillsForGivenAssd.keys._nCurrentFocus, true);
				tbgBillsForGivenAssd.keys.releaseKeys();
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
			id : "dspGibrGfunFundCd",
			title : "Fund Code",
			titleAlign : 'left',
			width : '100px',
			align : 'left',
		},{
			id : "dspGibrBranchCd",
			title : "Branch Code",
			titleAlign : 'left',
			width : '100px',
			align : 'left',
		},{
			id : "dspColumnHeading",
			title : "Column Heading",
			titleAlign : 'left',
			width : '140px',
			align : 'left',
		}, {
			id : "balanceAmtDue",
			title : "Amount Due",
			titleAlign : 'right',
			width : '145px',
			geniisysClass: 'money',
			align : 'right',
		}],
		rows : jsonBillsForGivenAssdDtls.rows
	};
	tbgBillsForGivenAssd = new MyTableGrid(billsForGivenAssdTableModel);
	tbgBillsForGivenAssd.pager = jsonBillsForGivenAssdDtls;
	tbgBillsForGivenAssd.render('billsForGivenAssdTable');
	tbgBillsForGivenAssd.afterRender = function(){
		tbgBillsForGivenAssd.keys.removeFocus(tbgBillsForGivenAssd.keys._nCurrentFocus, true);
		tbgBillsForGivenAssd.keys.releaseKeys();
		
		if(tbgBillsForGivenAssd.geniisysRows.length > 0){
			var rec = tbgBillsForGivenAssd.geniisysRows[0];
			tbgBillsForGivenAssd.selectRow('0');
			setDetailsForm(rec);
		}
	};
	
	function setDetailsForm(rec){
		try {
			$("txtAssdNo").value = rec == null ? "" : rec.assdNo;
			$("txtAssdName").value = rec == null ? "" : unescapeHTML2(rec.assdName);
			$("txtSumTotBalDue").value = rec == null ? "" : formatCurrency(rec.sumBalanceAmtDue);
			$("selectedAgingId").value = rec == null ? "" : rec.agingId;
			$("selectedBranchCd").value = rec == null ? "" : rec.dspGibrBranchCd;
		} catch (e) {
			showErrorMessage("setDetailsForm", e);
		}
	}
	
	$("btnReturn").observe("click", function(){
		//showGIACS202("GIACS206", $F("fundCd"), $F("branchCd"), objGIACS202.columnNo, objGIACS202.multiSort, $F("fundDesc"), $F("branchName"));
		$("billsByAssdAndAgeMainDiv").style.display = null;
		$("giac202TempDiv").style.display = "none";
		setModuleId("GIACS202");
		setDocumentTitle("Aging by Assured (For a Give Age Level)");
	});
	
	$("btnBill").observe("click", function(){
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
							showGIACS204("GIACS206", $F("fundCd"), $F("branchCd"), $F("selectedBranchCd"), $F("agingId"), $F("selectedAgingId"), $F("assdNo"), $F("fundDesc"), $F("branchName"));
						}
					}
				});
			}catch(e){
				showErrorMessage('checkUserAccess', e);
			}
		}
	});
	
	$("btnToolbarExit").observe("click", function() {
		//showGIACS202("GIACS206", $F("fundCd"), $F("branchCd"), objGIACS202.columnNo, objGIACS202.multiSort, $F("fundDesc"), $F("branchName"));
		$("billsByAssdAndAgeMainDiv").style.display = null;
		$("giac202TempDiv").style.display = "none";
		setModuleId("GIACS202");
		setDocumentTitle("Aging by Assured (For a Give Age Level)");
	});
</script>