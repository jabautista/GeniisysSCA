<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div>
	<div style="padding-top: 10px;">
		<div id="historyTable" style="height: 206px; margin-left: 11px;"></div>
	</div>
	<div style="float: none; text-align: center;">
		<input type="button" class="button" value="Return" id="btnExitHistory" style="width: 90px; margin-top: 7px;" />
	</div>
</div>
<script type="text/javascript">
	try {
		
		var objGiiss215History = {};
		objGiiss215History.claimList = JSON.parse('${jsonBancAreaHist}');
		
		var historyTable = {};
		
		historyTable = {
			id : "tbgHistory",
			url : contextPath + "/GIISBancAreaController?action=showGiiss215History&refresh=1&areaCd=" + objGiiss215.areaCd,
			options : {
				width : 614,
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
					id : "oldEffDate",
					title: "Old Effectivity Date",
					align: "center",
					titleAlign: "center",
					width: 150,
					renderer: function(val){
						return val == "" ? "" : dateFormat(val, "mm-dd-yyyy");
					},
					filterOption: true,
					filterOptionType : "formattedDate"
				},
				{
					id : "newEffDate",
					title: "New Effectivity Date",
					align: "center",
					titleAlign: "center",
					width: 150,
					renderer: function(val){
						return val == "" ? "" : dateFormat(val, "mm-dd-yyyy");
					},
					filterOption: true,
					filterOptionType : "formattedDate"
				},
				{
					id: "userId",
					title: "User ID",
					width: 150,
					filterOption: true
				},
				{
					id: "lastUpdate",
					title: "Last Update",
					align: "center",
					titleAlign: "center",
					width: 150,
					renderer: function(val){
						return val == "" ? "" : dateFormat(val, "mm-dd-yyyy");
					},
					filterOption: true,
					filterOptionType : "formattedDate"
				}							
			],
			rows : objGiiss215History.claimList.rows
		};

		tbgHistory = new MyTableGrid(historyTable);
		tbgHistory.pager = objGiiss215History.claimList;
		tbgHistory.render("historyTable");
		
		$("btnExitHistory").observe("click", function(){
			overlayHistory.close();
			delete overlayHistory;
		});
		
	} catch (e) {
		showErrorMessage("History", e);
	}
</script>