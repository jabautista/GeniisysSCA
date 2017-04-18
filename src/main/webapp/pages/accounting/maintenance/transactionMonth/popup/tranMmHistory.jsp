<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
	
	
<div id="giacs038HistMainDiv">
	<input id="hidFundCd" type="hidden" value="${fundCd }">
	<input id="hidBranchCd" type="hidden" value="${branchCd }">
	<input id="hidTranYr" type="hidden" value="${tranYr }">
	<input id="hidTranMm" type="hidden" value="${tranMm }">
	
	<div id="tranMmStatHistTableDiv" style="padding-top: 10px;">
		<label style=""><b>Transaction Month History</b></label>
		<div id="tranMmStatHistTable" style="height: 193px;  margin: 20px 0 0 10px;"></div>
	</div>
	
	<div id="tranClmStatHistTableDiv" style="padding-top: 20px;">
		<label style=""><b>Claim Booking Month History</b></label>
		<div id="tranClmStatHistTable" style="height: 193px;  margin: 20px 0 0 10px;"></div>
	</div>
	
	<div style="margin: 10px;" align="center">
		<input id="btnReturn" type="button" class="button" value="Return" style="width: 80px;">
	</div>
</div>

<script type="text/javascript">
try{
	var objGIACS038 = {};
	objGIACS038.tranMmStatHistList = JSON.parse('${jsonStatHist}');
	
	var tranMmStatHistTable = {
			url : contextPath + "/GIACTranMmController?action=getTranMmStatHist&refresh=1&gfunFundCd="+$F("hidFundCd")+
					"&branchCd="+$F("hidBranchCd")+"&tranYr="+$F("hidTranYr")+"&tranMm="+$F("hidTranMm"),
			options : {
				width : '452px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					tbgTranMmStatHist.keys.removeFocus(tbgTranMmStatHist.keys._nCurrentFocus, true);
					tbgTranMmStatHist.keys.releaseKeys();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					tbgTranMmStatHist.keys.removeFocus(tbgTranMmStatHist.keys._nCurrentFocus, true);
					tbgTranMmStatHist.keys.releaseKeys();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						tbgTranMmStatHist.keys.removeFocus(tbgTranMmStatHist.keys._nCurrentFocus, true);
						tbgTranMmStatHist.keys.releaseKeys();
					}
				},
				onSort: function(){
					rowIndex = -1;
					tbgTranMmStatHist.keys.removeFocus(tbgTranMmStatHist.keys._nCurrentFocus, true);
					tbgTranMmStatHist.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					tbgTranMmStatHist.keys.removeFocus(tbgTranMmStatHist.keys._nCurrentFocus, true);
					tbgTranMmStatHist.keys.releaseKeys();
				},		
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
					id : "closedTag rvMeaning",
					title: "Status",
					titleAlign:' center',
					filterOption: true,
					sortable: true,
					children: [
						{
							id: "closedTag",
							title: "Closed Tag",
							width: 70,
							filterOption: true,
							sortable: true
						},
						{
							id: "rvMeaning",
							title: "Meaning",
							width: 100,
							filterOption: true,
							sortable: true
						}
		            ]
				},	
				{
					id : 'userId',
					title: 'User ID',
					width : '90px',
					filterOption: true
				},
				{
					id : 'lastUpdate',
					title: 'Last Update',
					width : '160px',
					filterOption: false			
				}
			],
			rows : objGIACS038.tranMmStatHistList.rows
	};

	tbgTranMmStatHist = new MyTableGrid(tranMmStatHistTable);
	tbgTranMmStatHist.pager = objGIACS038.tranMmStatHistList;
	tbgTranMmStatHist.render("tranMmStatHistTable");
	
	
	objGIACS038.tranMmClmStatHistList = JSON.parse('${jsonClmStatHist}');
	objGIACS038.afterSave = null;
	
	var tranMmClmStatHistTable = {
			url : contextPath + "/GIACTranMmController?action=getClmTranMmStatHist&refresh=1&gfunFundCd="+$F("hidFundCd")+
					"&branchCd="+$F("hidBranchCd")+"&tranYr="+$F("hidTranYr")+"&tranMm="+$F("hidTranMm"),
			options : {
				width : '452px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					tbgTranMmClmStatHist.keys.removeFocus(tbgTranMmClmStatHist.keys._nCurrentFocus, true);
					tbgTranMmClmStatHist.keys.releaseKeys();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					tbgTranMmClmStatHist.keys.removeFocus(tbgTranMmClmStatHist.keys._nCurrentFocus, true);
					tbgTranMmClmStatHist.keys.releaseKeys();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						tbgTranMmClmStatHist.keys.removeFocus(tbgTranMmClmStatHist.keys._nCurrentFocus, true);
						tbgTranMmClmStatHist.keys.releaseKeys();
					}
				},
				onSort: function(){
					rowIndex = -1;
					tbgTranMmClmStatHist.keys.removeFocus(tbgTranMmClmStatHist.keys._nCurrentFocus, true);
					tbgTranMmClmStatHist.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					tbgTranMmClmStatHist.keys.removeFocus(tbgTranMmClmStatHist.keys._nCurrentFocus, true);
					tbgTranMmClmStatHist.keys.releaseKeys();
				},		
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
					id : "clmClosedTag rvMeaning",
					title: "Status",
					titleAlign:' center',
					filterOption: true,
					sortable: true,
					children: [
						{
							id: "clmClosedTag",
							title: "Clm Closed Tag",
							width: 70,
							filterOption: true,
							sortable: true
						},
						{
							id: "rvMeaning",
							title: "Meaning",
							width: 100,
							filterOption: true,
							sortable: true
						}
		            ]
				},	
				{
					id : 'userId',
					title: 'User ID',
					width : '90px',
					filterOption: true
				},
				{
					id : 'lastUpdate',
					title: 'Last Update',
					width : '160px',
					filterOption: false			
				}
			],
			rows : objGIACS038.tranMmClmStatHistList.rows
	};

	tbgTranMmClmStatHist = new MyTableGrid(tranMmClmStatHistTable);
	tbgTranMmClmStatHist.pager = objGIACS038.tranMmClmStatHistList;
	tbgTranMmClmStatHist.render("tranClmStatHistTable");

	$("btnReturn").observe("click", function(){
		historyOverlay.close();
	});
	
	$("btnReturn").focus();
}catch(e){
	showErrorMessage("Popup page error", e);
}
	
</script>