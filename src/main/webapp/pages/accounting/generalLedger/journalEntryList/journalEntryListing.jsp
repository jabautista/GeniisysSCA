<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="journalEntryListingMainDiv">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
		<c:if test="${'Y' eq isCancelJVList}">	
			<label title="Cancel JV Listing">Cancel JV Listing</label>	
		</c:if>
		<c:if test="${'Y' ne isCancelJVList}">	
			<label title="Enter Journal Entries Listing">Journal Entry Listing</label>	
		</c:if>
		</div>
	</div>		
	<div id="tableGridSectionDiv" class="sectionDiv" style="height: 405px; margin-bottom: 50px;">
		<!-- andrew - 08282015 - SR 17425 -->
		<div id="tranFlagOptionsDiv" style="float: left; width: 100%; margin-top: 15px; margin-left: 210px;">
			<input type="radio" id="tranFlagOpen" name="tranFlag" value="O" checked="checked" style="margin: 0 5px 0 50px; float: left;"/><label for="tranFlagOpen">Open</label>
			<input type="radio" id="tranFlagClosed" name="tranFlag" value="C" style="margin: 0 5px 0 50px; float: left;"/><label for="tranFlagClosed">Closed</label>
			<input type="radio" id="tranFlagPosted" name="tranFlag" value="P" style="margin: 0 5px 0 50px; float: left;"/><label for="tranFlagPosted">Posted</label>
			<input type="radio" id="tranFlagCancelled" name="tranFlag" value="D" style="margin: 0 5px 0 50px; float: left;"/><label for="tranFlagCancelled">Cancelled</label>
		</div>
		<div id="journalEntryTableGridDiv" style="padding: 10px; margin-top: 35px;">
			<div id="journalEntryTableGrid" style="height: 325px; width: 900px;"></div>
		</div>
	</div>
</div>

<script>
	setModuleId(null);
	var isCancelJVList = '${isCancelJVList}';
	var docTitle = isCancelJVList == 'Y'? 'Cancel JV Listing':'Enter Journal Entries Listing';
	setDocumentTitle(docTitle);
	var fundCd = null;
	var branchCd = null;
	var tranId = null;

	if(objGIACS003 == null){
		objGIACS003 = {};
		objGIACS003.tranFlag = "O";
	} else {
		$$("input[name='tranFlag']").each(function(r){
			if(r.value == objGIACS003.tranFlag){
				r.checked = true;
			}
		});		
	}
	
	try {
		var action2 = isCancelJVList == "Y" ? "getCancelJVList" : "getJournalEntryList";
		var buttons = (isCancelJVList == "Y" ? [MyTableGrid.VIEW_BTN, MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN] : [MyTableGrid.ADD_BTN, MyTableGrid.EDIT_BTN, MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]);
		//var objJournalListing = JSON.parse('${objJournalListing}'); 
		
		var tableModel = {
				url : contextPath+"/GIACJournalEntryController?action=showJournalListing&tranFlag="+objGIACS003.tranFlag+"&refresh=1&moduleId=GIACS003&action2="+action2,
				options: {
					hideColumnChildTitle: true,
					width: '900px',
					onCellFocus: function(element, value, x, y, id){
						var obj = journalListingTableGrid.geniisysRows[y];
						fundCd = obj.fundCd;
						branchCd = obj.branchCd;
						tranId = obj.tranId;
						journalListingTableGrid.keys.releaseKeys();
					},
					onRowDoubleClick: function(y){
						objGIACS003.objFilter = journalListingTableGrid.objFilter;
						objGIACS003.filterText = $F("mtgFilterText"+journalListingTableGrid._mtgId);
						objGIACS003.isLoaded = false;
						var obj = journalListingTableGrid.geniisysRows[y];
						fundCd = obj.fundCd;
						branchCd = obj.branchCd;
						tranId = obj.tranId;
						journalListingTableGrid.keys.releaseKeys();
						observeGIACS003Toolbar(fundCd, branchCd,tranId);
					},
// 					onCellBlur: function(element, value, x, y, id) {
// 						observeChangeTagInTableGrid(reassignParEndtTableGrid);
// 					},
					onRemoveRowFocus: function(element, value, x, y, id){
						fundCd = null;
						branchCd = null;
						tranId = null;
						journalListingTableGrid.keys.releaseKeys();
					},
					onSort: function() {
						fundCd = null;
						branchCd = null;
						tranId = null;
						journalListingTableGrid.keys.releaseKeys();
					},
					postPager: function () {
						fundCd = null;
						branchCd = null;
						tranId = null;
						journalListingTableGrid.keys.releaseKeys();
					},
					toolbar : {
						elements : buttons,
						onRefresh: function(){
							fundCd = null;
							branchCd = null;
							tranId = null;
							journalListingTableGrid.keys.releaseKeys();
						},
						onFilter: function(){
							fundCd = null;
							branchCd = null;
							tranId = null;
							journalListingTableGrid.keys.releaseKeys();
						},
						onAdd: function(){
							objGIACS003.objFilter = journalListingTableGrid.objFilter;
							objGIACS003.filterText = $F("mtgFilterText"+journalListingTableGrid._mtgId);
							objGIACS003.isLoaded = false;
							journalListingTableGrid.keys.releaseKeys();
							observeGIACS003Toolbar(null, null,null);
						},
						onEdit: function(){
							journalListingTableGrid.keys.releaseKeys();
							if (fundCd != null && branchCd != null && tranId != null) {
								objGIACS003.objFilter = journalListingTableGrid.objFilter;
								objGIACS003.filterText = $F("mtgFilterText"+journalListingTableGrid._mtgId);
								objGIACS003.isLoaded = false;
								observeGIACS003Toolbar(fundCd, branchCd,tranId);
							} else {
								showMessageBox("Please select a record first.",imgMessage.ERROR);
							}
						
						},
						onView: function(){
							journalListingTableGrid.keys.releaseKeys();
							if (fundCd != null && branchCd != null && tranId != null) {
								objGIACS003.objFilter = journalListingTableGrid.objFilter;
								objGIACS003.filterText = $F("mtgFilterText"+journalListingTableGrid._mtgId);
								objGIACS003.isLoaded = false;
								observeGIACS003Toolbar(fundCd, branchCd,tranId);
							} else {
								showMessageBox("Please select a record first.",imgMessage.ERROR);
							}
						}
					}
				},
				columnModel: [
		      		{
						id: 'recordStatus',
						width: '0',
						visible: false
					},
					{
						id: 'divCtrId',
						width: '0',
						visible: false
					},
					{
						id: 'jvPrefSuff jvNo',
						title: 'JV No.',
						width: 70,
						children: [
									{	id: 'jvPrefSuff',
								    	width: 30,
								    	align: 'left',
								    	title: 'JV Prefix',
								    	filterOption: true
								    },
								    {	id: 'jvNo',
								    	width: 50,
								    	title: 'JV No.',
								    	align: 'right',
								    	filterOption: true,
								    	filterOptionType: 'integerNoNegative',
							    		renderer: function(value){
								    		return nvl(value,'') == '' ? '' :formatNumberDigits(nvl(value, 0),6);
								    	}
								    }
					    	      ]
					},
					{
						id: 'fundCd',
						title: 'Fund Cd',
						width: '60px',
						align: 'left',
						filterOption: true
					},
					{
						id: 'branchCd branchName',
						title: 'Branch',
						width: '160px',
						children: [
									{	id: 'branchCd',
								    	width: 30,
								    	title: 'Branch Cd',
								    	filterOption: true
								    },
								    {	id: 'branchName',
								    	width: 140,
								    	title: 'Branch Name',
								    	filterOption: true
								    }
					    	      ]
					},
					{
				    	id:'tranYy tranMm tranSeqNo',
				    	title: 'Tran No.',
				    	width: 100,
				    	titleAlign: 'left',
				    	children: [
				    	   	    {	id: 'tranYy',
							    	width: 35,
							    	align: 'right',
							    	title: 'Tran No. - Tran Yr',
							    	filterOption: true,
							    	filterOptionType: 'integerNoNegative'
							    },
							    {	id: 'tranMm',
							    	width:25,
							    	align: 'right',
							    	title: 'Tran No. - Tran Mo',
							    	filterOption: true,
							    	filterOptionType: 'integerNoNegative',
						    		renderer: function(value){
							    		return nvl(value,'') == '' ? '' :formatNumberDigits(nvl(value, 0),2);
							    	}
							    },
							    {	id: 'tranSeqNo',
							    	width: 45,
							    	align: 'right',
							    	title: 'Tran No. - Tran Seq. No.',
							    	filterOption: true,
							    	filterOptionType: 'integerNoNegative',
							    	renderer: function(value){
							    		return nvl(value,'') == '' ? '' :formatNumberDigits(nvl(value, 0),5);
							    	}
							    }
				    	          ]
				    },
					{
						id: 'tranDate',
						title: 'Tran Date',
						width: '80px',
						align : 'center',
						titleAlign : 'center',
						filterOption: true,
						type: 'date',
						filterOptionType: 'formattedDate',
						renderer: function(value){
							return dateFormat(value,"mm-dd-yyyy");
						}
					},
// 					{
// 				    	id:'tranClass meanTranClass',
// 				    	title: 'Tran Class',
// 				    	width: 130,
// 				    	titleAlign: 'left',
// 				    	children: [
// 				    	   	    {	id: 'tranClass',
// 							    	width: 35,
// 							    	align: 'left'
// 							    },
// 							    {	id: 'meanTranClass',
// 							    	width: 100,
// 							    	align: 'left'
// 							    }
// 				    	          ]
// 				    },
					{
						id: 'jvTranType jvTranMm jvTranYy',
						title: 'JV Tran Type/Mo/Yr',
						width: 115,
				    	titleAlign: 'left',
						children: [
									{	id: 'jvTranType',
								    	width: 50,
								    	align: 'left',
								    	title: 'JV Tran Type',
								    	filterOption: true
								    },
								    {	id: 'jvTranMm',
								    	width: 30,
								    	align: 'right',
								    	title: 'JV Tran Mo',
								    	filterOption: true,
								    	filterOptionType: 'integerNoNegative',
							    		renderer: function(value){
								    		return nvl(value,'') == '' ? '' :formatNumberDigits(nvl(value, 0),2);
								    	}
								    },
								    {	id: 'jvTranYy',
								    	width: 40,
								    	align: 'right',
								    	title: 'JV Tran Yr',
								    	filterOptionType: 'integerNoNegative',
								    	filterOption: true
								    }
					    	          ]
					},
					{
						id: 'refJvNo',
						title: 'Reference JV No.',
						width: '100px',
						align : 'left',
						filterOption: true,
						renderer: function(value){
				    		return nvl(value,'') == '' ? '' :unescapeHTML2(nvl(value, ''));
				    	}
					},
					{
						id: 'particulars',
						title: 'Particulars',
						width: '175px',
						align : 'left',
						filterOption: true,
						renderer: function(value){
				    		return nvl(value,'') == '' ? '' :escapeHTML2(nvl(value, ''));//changed unescapeHTML2 to escapeHTML2 reymon 05062013
				    	}
					},
					{
						id: 'createBy', //Added by Jerome Bautista 06.26.2015 SR 4730
						title: 'Created by',
						width: 80,
						align: 'left',
						filterOption: true
					},
					{
						id: 'filterUserId', //Added by Jerome Bautista 06.26.2015 SR 4730
						title: 'User ID',
						width: 80,
						align: 'left',
						filterOption: true
					}
					
				],
				rows: [] //objJournalListing.rows
			};
			journalListingTableGrid = new MyTableGrid(tableModel);
			journalListingTableGrid.pager = {}; //objJournalListing;
			journalListingTableGrid.render('journalEntryTableGrid');
			journalListingTableGrid.afterRender = function(){
				if(objGIACS003 != null && !objGIACS003.isLoaded){
					objGIACS003.isLoaded = true;
					if(objGIACS003 != null && (objGIACS003.hasOwnProperty("filterText") && objGIACS003.filterText != "")){
						journalListingTableGrid.objFilter = objGIACS003.objFilter;
						var mtgId = journalListingTableGrid._mtgId;
						$("mtgFilterText"+mtgId).value = objGIACS003.filterText;
						$("mtgFilterBtn"+mtgId).addClassName("filterbutton_red");
						objGIACS003.objFilter = null;
						objGIACS003.filterText = "";
						journalListingTableGrid.refresh();					
					} else {
						journalListingTableGrid._refreshList();
					}
				}
			}
	} catch (e) {
		showErrorMessage("journalEntryListing.jsp Tablegrid",e);
	}
	
	function observeGIACS003Toolbar(fundCd2,branchCd2,tranId2) {
		try {
			if (isCancelJVList == 'Y') {
				showJournalListing("showJournalEntries","getCancelJV","GIACS003",fundCd2,branchCd2,tranId2,null,objGIACS003.tranFlag);
			}else{
				showJournalListing("showJournalEntries","getJournalEntries","GIACS003",fundCd2,branchCd2,tranId2,null,objGIACS003.tranFlag);
			}
		} catch (e) {
			showErrorMessage("observeGIACS003Toolbar",e);
		}
	}
	$("acExit").stopObserving();
	$("acExit").observe("click", function(){
		objGIACS003 = null;
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	});
	
	$$("input[name='tranFlag']").each(function(r){
		r.observe("click", function(){
			if(r.checked == true){
				objGIACS003.tranFlag = r.value;
				journalListingTableGrid.url = contextPath+"/GIACJournalEntryController?action=showJournalListing&tranFlag="+objGIACS003.tranFlag+"&refresh=1&moduleId=GIACS003&action2="+action2;
				journalListingTableGrid.refresh();
			}
		});
	});
</script>