<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma","no-cache");
%>
<div id="orListingMainDiv" name="orListingMainDiv">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>OR Listing</label>
			<input type="hidden" id="acFundCd" name="acFundCd" value="${acFundCd}" />
			<input type="hidden" id="acBranch" name="acBranch" value="${acBranch}" />
		</div>
	</div>
	
	<div id="orListTableGridSectionDiv" class="sectionDiv" style="height: 405px;">
		<div id="orParamDiv" style="margin: 15px 10px 35px 290px;">
			<input title="New" type="radio" id="newRB" name="orParam" value="N" style="margin: 0 5px 0 5px; float: left;" checked="true"><label for="newRB">New</label>
			<input title="Printed" type="radio" id="printedRB" name="orParam" value="P" style="margin: 0 5px 0 30px; float: left;"><label for="printedRB">Printed</label>
			<input title="Cancelled" type="radio" id="cancelledRB" name="orParam" value="C" style="margin: 0 5px 0 30px; float: left;"><label for="cancelledRB">Cancelled</label>
			<input title="Replaced" type="radio" id="replacedRB" name="orParam" value="R" style="margin: 0 5px 0 30px; float: left;"><label for="replacedRB">Replaced</label>
		</div>
	
		<div id="orListTableGridDiv" style="padding: 10px; float: left;">
			<div id="orListTableGrid" style="height: 325px; width: 900px;"></div>
		</div>
	</div>
</div>

<script type="text/javaScript">
	//setModuleId("GIACS001"); // andrew - this listing has no moduleId
	setModuleId(null);
	setDocumentTitle("OR Listing");
	clearObjectValues(objACGlobal);
	var selectedObjRow = null; // variable that points to the currently selected row of table grid
	
	/**
	** The table grid part goes here. emman (02.14.2011)
	**/

	try {
		var objOR = new Object();
		objOR.objORListTableGrid = JSON.parse('${orListTableGrid}'.replace(/\\/g, '\\\\'));
		objOR.objORList = objOR.objORListTableGrid.rows || [];
		var buttons = (objAC.fromMenu == "cancelOR" || objAC.fromMenu == "cancelOtherOR" ? [MyTableGrid.VIEW_BTN, MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN] : [MyTableGrid.ADD_BTN, MyTableGrid.EDIT_BTN, MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]);

		var orTableModel = {
				url: contextPath+"/GIACOrderOfPaymentController?action=refreshORListing&acFundCd="+encodeURIComponent($F("acFundCd"))+"&acBranch="+encodeURIComponent($F("acBranch"))+"&orStatus=N",
				options:{
					title: '',
					width: '900px',
					hideColumnChildTitle: true,
					onCellFocus: function(element, value, x, y, id){
						var mtgId = orListTableGrid._mtgId;
						selectedObjRow = null;
						if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
							// set global gacc tran id and selected OR row
							selectedObjRow = y;
							objACGlobal.gaccTranId = orListTableGrid.geniisysRows[y].gaccTranId;
						}observeChangeTagInTableGrid(orListTableGrid);
						
						// cc - temp
					},
					onRemoveRowFocus : function() {					//added by kenneth L. 09.24.2013
						orListTableGrid.keys.releaseKeys();
						resetUsedGlobalValues();
					},
					onCellBlur: function(){
						observeChangeTagInTableGrid(orListTableGrid);
					},
					onRowDoubleClick: function(y){
						var row = orListTableGrid.geniisysRows[y];
						// set global gacc tran id and selected OR row
						objACGlobal.gaccTranId = row.gaccTranId;
						objACGlobal.orStatus = row.orStatus;
						selectedObjRow = y;

						if (objACGlobal.gaccTranId == null) {
							showMessageBox("Please select an OR first.", imgMessage.ERROR);
							return false;
						} else {
							setGlobalORDetails2(row);
							editORInformation();
						}
					},
					toolbar: {
						elements: buttons,
						onAdd: function(){
							orListTableGrid.keys.releaseKeys();
							objACGlobal.gaccTranId = null;
							if(objAC.createORTag == "M") {
								objACGlobal.orTag = "*";
							} 						
							createORInformation($F("acBranch"));
							selectedObjRow = null;
							resetUsedGlobalValues();
						},
						onEdit: function(){							
							orListTableGrid.keys.releaseKeys();
							if (objACGlobal.gaccTranId == null || selectedObjRow == null) {
								showMessageBox("Please select an OR first.", imgMessage.ERROR);
								return false;
							} else {
								var row = orListTableGrid.geniisysRows[selectedObjRow];
								setGlobalORDetails2(row);
								editORInformation();
							}
						},
						onView: function(){ // andrew - 08.14.2012		
							if (objACGlobal.gaccTranId == null || selectedObjRow == null) {
								showMessageBox("Please select an OR first.", imgMessage.ERROR);
								return false;
							} else {
								var row = orListTableGrid.geniisysRows[selectedObjRow];
								setGlobalORDetails2(row);
								editORInformation();
							}
							orListTableGrid.keys.releaseKeys();
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
						id: 'orTagLbl',
						title: '',
						width: '20px',
						sortable: false,
						align: 'center'
					},
					{
						id: 'dcbNo',
						title: 'DCB No.',
						width: '70px',
						filterOption: true,
						sortable: true,
						align: 'center',
						titleAlign: 'center'
					},
					{
						id: 'orNo',
						title: 'OR No.',
						width: '110px', //changed from 90 by robert 11.06.2013
						filterOption: true,
						sortable: true,
						align: 'center',
						titleAlign: 'center',
						renderer: function(value){
							return value == '-' ? '' :value;
						}
					},
					{
						id: 'orDate',
						title: 'OR Date',
						width: '85px',
						filterOption: true,
						filterOptionType: 'formattedDate',
						sortable: true,
						align: 'center',
						type: 'date',
						titleAlign: 'center'
					},
					{
						id: 'payor',
						title: 'Payor',
						width: '310px',
						filterOption: true,
						sortable: true,
						align: 'left',
						titleAlign: 'center'
					},
					{
						id: 'dcbUserId',
						title: 'Cashier',
						width: '70px',
						filterOption: true,
						sortable: true,
						align: 'center',
						titleAlign: 'center'
					},
					/*{
						id: 'dcbBankAcct',
						title: 'DCB Bank Account',
						width: '342px',
						filterOption: true,
						sortable: true,
						align: 'left',
						titleAlign: 'center'
					},*/
					{
						id: 'orStatus',
						title: 'OR Status',
						width: '85px',
						filterOption: true, //marco - 09.09.2014 - replaced with radio button options
						sortable: true,
						align: 'center',
						titleAlign: 'center'
					},
					{	id: 'userId', // column added by: Nica 06.15.2012
	    	   	    	title: 'User Id',
						align: 'center',
						sortable: true,
						//filterOption: true,
						titleAlign: 'center',
				    	width: '70px'
				    },
				    {	id: 'lastUpdate', // column added by: Nica 06.15.2012
				    	title: 'Last Update',
				    	width: '85px',
				    	align: 'center',
				    	filterOption: true, // Added by Jerome Bautista 11.03.2015 SR 20144
						filterOptionType: 'formattedDate', // Added by Jerome Bautista 11.03.2015 SR 20144
				    	sortable: true,
				    	titleAlign: 'center',
				    	type:'date'
				    }
				],
				resetChangeTag: true,
				rows: objOR.objORList
		};

		orListTableGrid = new MyTableGrid(orTableModel);
		orListTableGrid.pager = objOR.objORListTableGrid;
		orListTableGrid.render('orListTableGrid');
	} catch(e){
		showErrorMessage("orListing.jsp", e);
	}

	function setGlobalORDetails2(orRow) {
		objACGlobal.gaccTranId 		= orRow.gaccTranId;
		objACGlobal.branchCd		= orRow.branchCd;
		objACGlobal.fundCd			= orRow.fundCd;
		objACGlobal.workflowColVal 	= orRow.gaccTranId;
		objACGlobal.orTag			= orRow.orTag;
		objACGlobal.orFlag			= orRow.orFlag;
		objACGlobal.opTag			= orRow.opTag;
		objACGlobal.withPdc			= orRow.withPdc;
		objACGlobal.callingForm		= "orListing";
	}

	//Added by Tonio March 16, 2011 
	//To reset All variables needed in GIACS001 when clicking on the ADD button
	function resetUsedGlobalValues(){
		objACGlobal.gaccTranId 		= null;
		objACGlobal.branchCd		= null;
		objACGlobal.fundCd			= null;
		objACGlobal.workflowColVal 	= null;
		//objACGlobal.orTag			= null;
		objACGlobal.orFlag			= null;
		objACGlobal.opTag			= null;
		objACGlobal.withPdc			= null;
		objACGlobal.callingForm		= "orListing";
	}

	//marco - 09.09.2014
	$$("input[name='orParam']").each(function(r){
		$(r).observe("click", function(){
			orListTableGrid.url = contextPath+"/GIACOrderOfPaymentController?action=refreshORListing&acFundCd="+encodeURIComponent($F("acFundCd"))+"&acBranch="+encodeURIComponent($F("acBranch"))+"&orStatus="+r.value,
			orListTableGrid._refreshList();
		});
	});

	$("acExit").stopObserving();
	$("acExit").observe("click", function(){
		if(objAC.otherORBranchCd == null) {
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		} else {
			if(objAC.fromMenu == "cancelOtherOR"){
				showBranchOR(3);
			} else {
				showBranchOR(1);
			}
		}
	});
</script>