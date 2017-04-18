<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma","no-cache");
%>
<div id="dcbListingMainDiv" name="dcbListingMainDiv">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>DCB Listing</label>
		</div>
	</div>
	
	<div id="dcbListTableGridSectionDiv" class="sectionDiv" style="height: 370px;">
		<div id="dcbListTableGridDiv" style="padding: 10px;" align="center">
			<div id="dcbListTableGrid" style="height: 325px; width: 694px;" align="left"></div>
		</div>
	</div>
</div>

<script type="text/javaScript">
	setModuleId("GIACS035");
	setDocumentTitle("DCB Listing");
	clearObjectValues(objACGlobal);

	var selectedObjRow = null; // variable that points to the currently selected row of table grid
	
	/**
	** The table grid part goes here. emman (03.16.2011)
	**/

	try {
		var objDCB = new Object();
		objDCB.objDCBListTableGrid = JSON.parse('${dcbListTableGrid}'.replace(/\\/g, '\\\\'));
		objDCB.objDCBList = objDCB.objDCBListTableGrid.rows || [];

		var dcbTableModel = {
				url: contextPath+"/GIACAccTransController?action=refreshDCBListing",
				options:{
					title: '',
					width: '694px',
					onCellFocus: function(element, value, x, y, id){
						var mtgId = dcbListTableGrid._mtgId;
						selectedObjRow = -1;
						if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
							// set global gacc tran id and selected DCB row
							selectedObjRow = y;
							objACGlobal.gaccTranId = dcbListTableGrid.geniisysRows[y].gaccTranId;
						}observeChangeTagInTableGrid(dcbListTableGrid);
					},
					onCellBlur: function(){
						observeChangeTagInTableGrid(dcbListTableGrid);
					},
					onRowDoubleClick: function(y){
						var row = dcbListTableGrid.geniisysRows[y];
						// set global gacc tran id and selected OR row
						objACGlobal.gaccTranId = row.gaccTranId;
						selectedObjRow = y;

						if (objACGlobal.gaccTranId == null) {
							showMessageBox("Please select an OR first.", imgMessage.ERROR);
							return false;
						} else {
							setGlobalORDetails2(row);
							editDCBInformation();
						}
					},
					toolbar: {
						elements: [MyTableGrid.ADD_BTN, MyTableGrid.EDIT_BTN, MyTableGrid.FILTER_BTN],
						onAdd: function(){
							objACGlobal.gaccTranId = null;
							selectedObjRow = null;
							resetUsedGlobalValues();
							editDCBInformation();
							dcbListTableGrid.keys.releaseKeys();
						},
						onEdit: function(){
							dcbListTableGrid.keys.releaseKeys();
							if (objACGlobal.gaccTranId == null || selectedObjRow == null) {
								showMessageBox("Please select an OR first.", imgMessage.ERROR);
								return false;
							} else {
								var row = dcbListTableGrid.geniisysRows[selectedObjRow];
								setGlobalORDetails2(row);
								editDCBInformation();
							}
						}
					}
				},
				columnModel: [
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
						id: 'dcbNo',
						title: 'DCB No.',
						width: '75px',
						filterOption: true,
						sortable: true,
						align: 'center',
						titleAlign: 'center'
					},
					{
						id: 'dspBranchName',
						title: 'Branch',
						width: '500px',
						filterOption: true,
						sortable: true,
						align: 'left',
						titleAlign: 'center'
					},
					{
						id: 'tranDate',
						title: 'DCB Date',
						width: '105px',
						filterOption: true,
						sortable: true,
						align: 'center',
						type: 'date',
						titleAlign: 'center'
					}
				],
				resetChangeTag: true,
				rows: objDCB.objDCBList
		};

		dcbListTableGrid = new MyTableGrid(dcbTableModel);
		dcbListTableGrid.pager = objDCB.objDCBListTableGrid;
		dcbListTableGrid.render('dcbListTableGrid');
	} catch(e){
		showErrorMessage("dcbListing.jsp", e);
	}

	function setGlobalORDetails2(orRow) {
		objACGlobal.gaccTranId 		= orRow.gaccTranId;
		objACGlobal.branchCd		= orRow.gibrBranchCd;
		objACGlobal.fundCd			= orRow.gfunFundCd;
		objACGlobal.callingForm		= "dcbListing";
	}

	function resetUsedGlobalValues(){
		objACGlobal.gaccTranId 		= null;
		objACGlobal.branchCd		= null;
		objACGlobal.fundCd			= null;
		objACGlobal.callingForm		= "dcbListing";
	}
	
	$("acExit").stopObserving();
	$("acExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	});

	// calling functions (transfer to accounting.js when finished)
/*	function editDCBInformation() {
		new Ajax.Updater("mainContents", contextPath + "/GIACAccTransController?action=editDCBInformation", {
			method: "GET",
			asynchronous: true,
			evalScripts: true,
			parameters: {
				gaccTranId	: objACGlobal.gaccTranId
			},
			onCreate : function() {
				showNotice("Loading, please wait...");
			},
			onComplete : function(response) {
				if (checkErrorOnResponse(response)) {
					hideNotice("");
				}
			}
		});
	}*/
	
	$("acExit").observe("click", function(){  //added by Halley 11.22.13
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	}); 
</script>