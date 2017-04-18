<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma","no-cache");
%>

<div id="memoListMainDiv" name="memoListMainDiv">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Credit/Debit Memo Listing</label>
			<input type="hidden" id="hidFundCd" name="hidFundCd"  />
			<input type="hidden" id="hidBranchCd" name="hidBranchCd"  />
		</div>
	</div>
	
	<div id="memoListTableGridSectionDiv" class="sectionDiv" style="height: 400px;"> <!-- Added by Jerome Bautista 12.14.2015 SR 3467 -->
		<div style="height: 30px; padding: 10px 5px 0px 5px;">
			<table align = "center">
				<tr>
					<td><input type="radio" name="tranStatusFlagRG" id="newRB" value="O" style="margin: 0 0 0 5px; float: left;" checked="checked"/><label style="margin: 0 25px 0 5px;" for="newRB"/>Open</td>
					<td><input type="radio" name="tranStatusFlagRG" id="closedRB" value="C" style="margin: 0 0 0 5px; float: left;"/><label style="margin: 0 25px 0 5px;" for="closedRB"/>Closed</td>
					<td><input type="radio" name="tranStatusFlagRG" id="printedRB" value="P" style="margin: 0 0 0 5px; float: left;"/><label style="margin: 0 25px 0 5px;" for="printedRB"/>Posted</td>
					<td><input type="radio" name="tranStatusFlagRG" id="deletedRB" value="D" style="margin: 0 0 0 5px; float: left;"/><label style="margin: 0 25px 0 5px;" for="deletedRB"/>Cancelled</td>
				</tr>
			</table>
		</div>
		<div id="memoListTableGridDiv" style="padding: 10px;">
			<div id="memoListTableGrid" style="height: 310px; width: 900px;"></div>
		</div>
	</div>
</div>

<script type="text/javascript">
	setModuleId(null);
	setDocumentTitle("Credit/Debit Memo Listing");
	clearObjectValues(objACGlobal);
	
	var selectedIndex = null;
	var selectedRow = null;
	var tranStatus; //Added by Jerome Bautista SR 3467 01.04.2016
	
	try {
		var cancelFlag = '${cancelFlag}';
		
		var objMemoArray = [];
		var objMemo = new Object();
		objMemo.objMemoListTableGrid = JSON.parse('${memoList}'.replace(/\\/g, '\\\\'));
		objMemo.objMemoList = objMemo.objMemoListTableGrid.rows || [];
		
		var buttons1 = [MyTableGrid.ADD_BTN, MyTableGrid.EDIT_BTN, MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN];
		var buttons2 = [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN];
		var buttons = cancelFlag == "Y" ? buttons2 : buttons1;
		
		var memoTableModel = {
				url : contextPath + "/GIACMemoController?action=getMemoList&refresh=1" + "&fundCd=" + $F("hidFundCd") + "&branchCd=" + $F("hidBranchCd") + "&tranStatus=O", //Added by Jerome Bautista 01.06.2016
				options : {
					title :'',
					width : '900px',
					onCellFocus: function(elemet, value, x, y, id){
						var mtgId = memoListTableGrid._mtgId;
						//selectedIndex = -1;
						
						if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
							selectedIndex = y;
							var row = memoListTableGrid.geniisysRows[y];
							objACGlobal.gaccTranId = row.gaccTranId;
							objACGlobal.fundCd = row.fundCd;
							objACGlobal.branchCd = row.branchCd;
						}						
					},
					onRemoveRowFocus: function(){
						selectedIndex = null;
					},
					onCellBlur : function(){
						
					},
					onRowDoubleClick : function(y){
						selectedIndex = y;
						var row = memoListTableGrid.geniisysRows[y];
						objACGlobal.gaccTranId = row.gaccTranId;
						
						if (objACGlobal.gaccTranId == null) {
							showMessageBox("Please select a memo first.", imgMessage.ERROR);
							return false;
						} else {
							setGlobalMemoDetails(row);
							updateMemoInformation(cancelFlag, row.branchCd, row.fundCd);
						}
					},
					toolbar : {
						elements : buttons,
						onAdd : function(){
							objAC.fromMenu = "tblAddCreditDebitMemo";
							showMemoPage();
						},
						onEdit : function(){
							if(selectedIndex != null){
								updateMemoInformation(cancelFlag, objACGlobal.branchCd, objACGlobal.fundCd);
							} else {
								showMessageBox("Please select a record first.", "I");
							}
						}
					}
				},
				columnModel : [
								{
								    id: 'recordStatus',
								    title: '',
								    width: '0',
								    visible: false
								},
								{
									id: 'divCtrId',
									width: '0',
									visible: false
								},
								{
								    id: 'gaccTranId',
								    title: 'gaccTranId',
								    width: '0',
									visible: false
								},
								{
								    id: 'fundCd',
								    title: 'Fund Cd',
								    width: '100px',
								    visible: false
								},
								{
									id: 'branchCd',
									title: 'Branch Cd',
									width: '50px',
									visible: false
								},
								{
									id: 'memoType',
									title: 'Memo Type',
									width: '100px',
									filterOption: true,
									sortable: true
								},
								{
								    id: 'memoNumber',
								    title: 'Memo Number',
								    width: '130px',
									filterOption: true,
									sortable: true
								},
								{
									id: 'dvNo', //Added by Jerome Bautista 12.11.2015 SR 3467
									title: 'DV No.',
									width: '100px',
									filterOption: true,
									sortable: true,
								},
								{
									id: 'memoDate',
									title: 'Memo Date',
									width: '140px',
									type: 'date',
									sortable: true,
									format: 'mm-dd-yyyy',
									filterOption: true,
									filterOptionType: 'formattedDate'
								},
								{
								    id: 'meanMemoStatus',
								    title: 'Status',
								    width: '130px',
									filterOption: true,
									sortable: true
								},
								{
								    id: 'recipient',
								    title: 'Recipient',
								    width: '220px',
									filterOption: true,
									sortable: true
								}
					],
				resetChangeTag : true,
				rows : objMemo.objMemoList
		};
		memoListTableGrid = new MyTableGrid(memoTableModel);
		memoListTableGrid.pager = objMemo.objMemoListTableGrid;
		memoListTableGrid.render('memoListTableGrid');
		
	}catch(e){
		showErrorMessage("creditDebitMemoTable.jsp", e);
	}
	
	function setGlobalMemoDetails(memoRow) {
		objACGlobal.gaccTranId 		= memoRow.gaccTranId;
		objACGlobal.branchCd		= memoRow.branchCd;
		objACGlobal.fundCd			= memoRow.fundCd;
		objACGlobal.callingForm		= "memoListing";
	}

	function resetUsedGlobalValues(){
		objACGlobal.gaccTranId 		= null;
		objACGlobal.branchCd		= null;
		objACGlobal.fundCd			= null;
		objACGlobal.callingForm		= "memoListing";
	}
	
	function executeQuery(){ //Added by Jerome Bautista 12.14.2015 SR 3467
		memoListTableGrid.url = contextPath+"/GIACMemoController?action=getMemoList&refresh=1" + "&fundCd=" + $F("hidFundCd") + "&branchCd=" + $F("hidBranchCd") 
		+ "&tranStatus=" + tranStatus,
		memoListTableGrid._refreshList();
	}
	
	$$("input[name='tranStatusFlagRG']").each(function(rb){
		rb.observe("click", function(){
			tranStatus = rb.value;
			executeQuery();
		});
	});
	
	$("acExit").stopObserving();
	$("acExit").observe("click", function() {
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	});	
</script>