<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="bankAcctHistoryMainDiv" name="bankAcctHistoryMainDiv">
	<div class="sectionDiv" style="width: 99.5%; padding-bottom: 10px; padding-top: 10px; margin-top: 5px;">
		<div id="bankAcctHstryFieldDiv" align="center">
			<div id="bankAcctHstryFieldTableGrid"
				style="height:200px; width:683px;"></div>
		</div>		
	</div>
	<div class="sectionDiv" style="width: 99.5%; padding-bottom: 10px; padding-top: 10px;">
		<div id="bankAcctHistoryDiv" align="center">
			<div id="bankAcctHstryValueTableGrid"
				style="height:200px; width:683px;"></div>
		</div>		
	</div>
	<center>	
		<input type="button" class="button" value="Return" id="btnReturn" style="width: 100px; margin-top: 20px" /> 
	</center>
</div>
<script>
try{
	var jsonBankAcctHstryField = JSON.parse('${jsonBankAcctHstryField}');
	bankAcctHstryFieldTableModel = {
		url : contextPath
				+ "/GICLClaimTableMaintenanceController?action=getBankAcctHstryField&refresh=1&payeeClassCd=${payeeClassCd}&payeeNo=${payeeNo}",
		options : {
			toolbar : {
				elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ]
			},
			width : '683px',
			height : '200px',
			pager : {},
			onCellFocus : function(element, value, x, y, id) {	
				setBankAcctHstryValueTbg(tbgBankAcctHstryField.geniisysRows[y]);
				tbgBankAcctHstryField.keys.removeFocus(
						tbgBankAcctHstryField.keys._nCurrentFocus, true);
				tbgBankAcctHstryField.keys.releaseKeys();				
			},
			onRemoveRowFocus : function(element, value, x, y, id) {			
				setBankAcctHstryValueTbg(null);
				tbgBankAcctHstryField.keys.removeFocus(
						tbgBankAcctHstryField.keys._nCurrentFocus, true);
				tbgBankAcctHstryField.keys.releaseKeys(); 		
			},
			onSort : function() {	
				setBankAcctHstryValueTbg(null);
				tbgBankAcctHstryField.keys.removeFocus(
						tbgBankAcctHstryField.keys._nCurrentFocus, true);
				tbgBankAcctHstryField.keys.releaseKeys();
			},
			onRefresh : function() {		
				setBankAcctHstryValueTbg(null);
				tbgBankAcctHstryField.keys.removeFocus(
						tbgBankAcctHstryField.keys._nCurrentFocus, true);
				tbgBankAcctHstryField.keys.releaseKeys();		
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
			id : "field",
			title : "Field Name",
			width : '655px',
			align : "left",
			titleAlign : "left",
			filterOption : true
		}],
		rows : jsonBankAcctHstryField.rows
	};

	tbgBankAcctHstryField = new MyTableGrid(bankAcctHstryFieldTableModel);
	tbgBankAcctHstryField.pager = jsonBankAcctHstryField;
	tbgBankAcctHstryField.render('bankAcctHstryFieldTableGrid');		
	
	 var jsonBankAcctHstryValue = JSON.parse('${jsonBankAcctHstryValue}');
	 bankAcctHstryValueTableModel = {
		url : contextPath
				+ "/GICLClaimTableMaintenanceController?action=getBankAcctHstryValue&payeeClassCd=${payeeClassCd}&payeeNo=${payeeNo}",
		options : {
			toolbar : {
				elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ]
			},
			width : '683px',
			height : '200px',
			pager : {},
			onCellFocus : function(element, value, x, y, id) {				
				tbgBankAcctHstryValue.keys.removeFocus(
						tbgBankAcctHstryValue.keys._nCurrentFocus, true);
				tbgBankAcctHstryValue.keys.releaseKeys();				
			},
			onRemoveRowFocus : function(element, value, x, y, id) {				
				tbgBankAcctHstryValue.keys.removeFocus(
						tbgBankAcctHstryValue.keys._nCurrentFocus, true);
				tbgBankAcctHstryValue.keys.releaseKeys(); 		
			},
			onSort : function() {				
				tbgBankAcctHstryValue.keys.removeFocus(
						tbgBankAcctHstryValue.keys._nCurrentFocus, true);
				tbgBankAcctHstryValue.keys.releaseKeys();
			},
			onRefresh : function() {				
				tbgBankAcctHstryValue.keys.removeFocus(
						tbgBankAcctHstryValue.keys._nCurrentFocus, true);
				tbgBankAcctHstryValue.keys.releaseKeys();		
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
			id : "oldValue",
			title : "Previous Value",
			width : '200px',
			align : "left",
			titleAlign : "left",
			filterOption : true
		}, {
			id : "newValue",
			title : "Current Value",
			width : '200px',
			align : "left",
			titleAlign : "left",
			filterOption : true
		}, {
			id : "userId",
			title : "User ID",
			width : '100px',
			align : "left",
			titleAlign : "left",
			filterOption : true
		}, {
			id : "lastUpdate",
			title : "Last Update",
			width : '150px',
			align : "left",
			titleAlign : "left",
			filterOption : true
		}],
		rows : jsonBankAcctHstryValue.rows
	};

	 tbgBankAcctHstryValue = new MyTableGrid(bankAcctHstryValueTableModel);
	 tbgBankAcctHstryValue.pager = jsonBankAcctHstryValue;
	 tbgBankAcctHstryValue.render('bankAcctHstryValueTableGrid');	 
	
	 function setBankAcctHstryValueTbg(obj) {
		if (obj == null) {		
			tbgBankAcctHstryValue.url = contextPath
					+ "/GICLClaimTableMaintenanceController?action=getBankAcctHstryValue&payeeClassCd=${payeeClassCd}&payeeNo=${payeeNo}";
			tbgBankAcctHstryValue._refreshList();			
		} else {	
			tbgBankAcctHstryValue.url = contextPath
					+ "/GICLClaimTableMaintenanceController?action=getBankAcctHstryValue&payeeClassCd=${payeeClassCd}&payeeNo=${payeeNo}&field="
					+ obj.field;
					tbgBankAcctHstryValue._refreshList();			
		}
	}
	 
	$("btnReturn").observe("click", function(){
		overlayBankAcctHistory.close();
		delete overlayBankAcctHistory;
	});	
} catch (e) {
	showErrorMessage("Error : " , e.message);
} 
</script>