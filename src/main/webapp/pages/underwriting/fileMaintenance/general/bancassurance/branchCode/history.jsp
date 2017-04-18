<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div>
	<div style="padding-top: 10px;">
		<div id="historyTable" style="height: 347px; margin-left: 11px;"></div>
	</div>
	<div style="float: none; text-align: center;">
		<input type="button" class="button" value="Return" id="btnExitHistory" style="width: 90px; margin-top: 7px;" />
	</div>
</div>
<script type="text/javascript">
	try {
		
		var objGiiss216History = {};
		objGiiss216History.claimList = JSON.parse('${jsonBancBranchHist}');
		
		var historyTable = {};
		
		historyTable = {
			id : "tbgHistory",
			url : contextPath + "/GIISBancBranchController?action=showGiiss216History&refresh=1&branchCd=" + objGiiss216.branchCd,
			options : {
				width : 780,
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					tbgHistory.keys.removeFocus(tbgHistory.keys._nCurrentFocus, true);
					tbgHistory.keys.releaseKeys();
				},
				onRemoveRowFocus : function(){
					tbgHistory.keys.removeFocus(tbgHistory.keys._nCurrentFocus, true);
					tbgHistory.keys.releaseKeys();
				},
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						tbgHistory.keys.removeFocus(tbgHistory.keys._nCurrentFocus, true);
						tbgHistory.keys.releaseKeys();
					}
				},
				onSort: function(){
					tbgHistory.keys.removeFocus(tbgHistory.keys._nCurrentFocus, true);
					tbgHistory.keys.releaseKeys();
				},
				onRefresh: function(){
					tbgHistory.keys.removeFocus(tbgHistory.keys._nCurrentFocus, true);
					tbgHistory.keys.releaseKeys();
				},				
				prePager: function(){
					tbgHistory.keys.removeFocus(tbgHistory.keys._nCurrentFocus, true);
					tbgHistory.keys.releaseKeys();
				}
			},
			columnModel : [
				{ 								// this column will only use for deletion
				    id: 'recordStatus', 		// 'id' should be 'recordStatus' to disregard the some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
				    width: '0',				    
				    visible : false			
				},
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},
				{
					id: "oldAreaCd",
					title : "Old Area",
					width: 80,
					align: "right",
					titleAlign : "right",
					renderer : function(val){
						return val == "" ? "" : formatNumberDigits(val, 4);
					},
					filterOption : true,
					filterOptionType : "integerNoNegative"
				},
				{
					id: "newAreaCd",
					title : "New Area",
					width: 80,
					align: "right",
					titleAlign : "right",
					renderer : function(val){
						return val == "" ? "" : formatNumberDigits(val, 4);
					},
					filterOption : true,
					filterOptionType : "integerNoNegative"
				},
				{
					id : "oldEffDate",
					title: "Old Eff Date",
					align: "center",
					titleAlign: "center",
					width: 100,
					renderer: function(val){
						return val == "" ? "" : dateFormat(val, "mm-dd-yyyy");
					},
					filterOption : true,
					filterOptionType : "formattedDate"
				},
				{
					id : "newEffDate",
					title: "New Eff Date",
					align: "center",
					titleAlign: "center",
					width: 100,
					renderer: function(val){
						return val == "" ? "" : dateFormat(val, "mm-dd-yyyy");
					},
					filterOption : true,
					filterOptionType : "formattedDate"
				},
				{
					id: "oldManagerCd",
					title : "Old Mgr Code",
					width: 100,
					align: "right",
					titleAlign : "right",
					renderer : function(val){
						return val == "" ? "" : formatNumberDigits(val, 4);
					},
					filterOption : true,
					filterOptionType : "integerNoNegative"
				},
				{
					id: "newManagerCd",
					title : "New Mgr Code",
					width: 100,
					align: "right",
					titleAlign : "right",
					renderer : function(val){
						return val == "" ? "" : formatNumberDigits(val, 4);
					},
					filterOption : true,
					filterOptionType : "integerNoNegative"
				},
				{
					id: "oldBankAcctCd",
					title: "Old Bank Acct",
					width: 120,
					filterOption : true
				},
				{
					id: "newBankAcctCd",
					title: "New Bank Acct",
					width: 120,
					filterOption : true
				},
				{
					id : "oldMgrEffDate",
					title: "Old Mgr Eff Date",
					align: "center",
					titleAlign: "center",
					width: 100,
					renderer: function(val){
						return val == "" ? "" : dateFormat(val, "mm-dd-yyyy");
					},
					filterOption : true,
					filterOptionType : "formattedDate"
				},
				{
					id : "newMgrEffDate",
					title: "New Mgr Eff Date",
					align: "center",
					titleAlign: "center",
					width: 100,
					renderer: function(val){
						return val == "" ? "" : dateFormat(val, "mm-dd-yyyy");
					},
					filterOption : true,
					filterOptionType : "formattedDate"
				},
				{
					id: "userId",
					title: "User ID",
					width: 150,
					filterOption : true
				},
				{
					id: "lastUpdate",
					title: "Last Update",
					width: 150,
					filterOption : true
				}							
			],
			rows : objGiiss216History.claimList.rows
		};

		tbgHistory = new MyTableGrid(historyTable);
		tbgHistory.pager = objGiiss216History.claimList;
		tbgHistory.render("historyTable");
		
		$("btnExitHistory").observe("click", function(){
			overlayHistory.close();
			delete overlayHistory;
		});
		
	} catch (e) {
		showErrorMessage("History", e);
	}
</script>