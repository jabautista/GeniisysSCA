<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="agingIntmMainDiv" class="SectionDiv">
	<div id="agingIntmTGDiv" name="agingIntmTGDiv" style="height:250px; margin:20px 20px 20px 20px;">
	</div>
	
	<div id="agingIntmTextDiv" name="agingIntmTextDiv" style="float:right; height:30px; float:left; margin:5px 5px 20px 400px;">
		<table border="0" style="width:250px; align:right;">
			<tr>
				<td style="text-align:right;">Total:</td>
				<td><input type="text" id="txtAgingListAllTGSum" name="txtAgingListAllTGSum" origValue="" readonly="readonly" style="width:160px; margin-left:5px; text-align:right;" /></td>
			</tr>
		</table>
	</div>
	
	<div id="agingIntmButtonsDiv" name="agingIntmButtonsDiv" class="buttonsDiv" style="margin-top:5px; margin-bottom:5px;">
		<input type="button" class="button" id="btnListAllAging" name="btnListAllAging" value="Aging" style="width:90px;" />
		<input type="button" class="button" id="btnListAllSelectAll" name="btnListAllSelectAll" value="Select All" style="width:90px;" />
		<input type="button" class="button" id="btnListAllPrint" name="btnListAllPrint" value="Print" style="width:90px;" />
		<input type="button" class="button" id="btnListAllReturn" name="btnListAllReturn" value="Return" style="width:90px;" />
	</div>
</div>

<script>
	var selectedIndex3 = -1;
	var selectedRow3 = new Object();
	var isSelectedAll3 = false;  						// set to true if button btnSelectAll is clicked. same as VARIABLES.select_all
	
	var totalAmtForRowsToPrint3 = parseFloat(0); 		// for holding the current total of balance amount in rowsToPrint
	var initialTotalAmtDue3 = parseFloat(0);			// for holding the initial sum of total amt due upon loading of tg.
	
	allRowsToPrint3 = [];
	rowsToPrint3 = [];

	currentPrintParams = new Object();
	
	// For intermediary
	if(objSOA.prevParams.viewType == "I"){
		try {
			var tbgAgingIntm = new Object();
			tbgAgingIntm.objAgingIntmTableGrid = JSON.parse('${agingIntmAssdList}');
			tbgAgingIntm.objAgingIntm = tbgAgingIntm.objAgingIntmTableGrid.rows || [];
			
			tbgAgingIntmTableModel = {
					url 		: contextPath + "/GIACCreditAndCollectionReportsController?action=getAgingIntmLOV&refresh=1",
					options		: {
						width	: '650',
						height	: '250',
						validateChangesOnPrePager : function(){return false;},
						onCellFocus : function(element, value, x, y, id){
							var mtgId = tbgAgingIntmTableGrid._mtgId;						
							if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
								selectedIndex3 = y;
								row = y;
								selectedRow3 = tbgAgingIntmTableGrid.geniisysRows[y];
							}
						},
						onRemoveRowFocus: function(){
							tbgAgingIntmTableGrid.keys.releaseKeys();
							selectedIndex3 = -1;
							selectedRow3 = null;
							recheckRows3(tbgAgingIntmTableGrid);		     	
			          	},
			          	onSort: function(){
			          		recheckRows3(tbgAgingIntmTableGrid);
			          	},
			          	postPager: function(){
			          		recheckRows3(tbgAgingIntmTableGrid);
			          	},
						toolbar : {
							elements : [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
							onFilter: function(){
								allRowsToPrint3 = [];
						  		rowsToPrint3 = [];
						  		isSelectedAll3 = false;
						  		$("btnListAllSelectAll").value = "Select All";
						  		disableButton("btnListAllAging");
							}
						}
					},
					columnModel	: [
									{
									    id: 'recordStatus',
									    title: '',
									    width: '0px',
									    visible: false
									},
									{
										id: 'divCtrId',
										width: '0px',
										visible: false
									},
									{
									    id: 'intmNo',
									    title: 'Intm No.',
									    align: 'right',
									    width: '70px',
										filterOption: true,
										filterOptionType: 'integerNoNegative'
									},
									{
									    id: 'intmName',
									    title: 'Intermediary Name',
									    width: '350px',
										filterOption: true										
									}, 
									{
									    id: 'balanceAmtDue',
									    title: 'Total Amount',
									    align: 'right',
									    width: '164px',
										geniisysClass: 'money',
										filterOption: true,
										filterOptionType: 'number'
									},  
									{
									    id: 'incTag3',
									    title: '&nbsp;&nbsp;P',
									    titleAlign: 'center',
									    altTitle: 'Include Tag',
									    align: 'center',
									    width: '30px',
									    sortable: false,
									    editable: true,
										defaultValue: false,
										otherValue: false,
									    editor: new MyTableGrid.CellCheckbox({
								            getValueOf: function(value){
							            		if (value){
													return "Y";
							            		} else {
													return "N";	
							            		}	
							            	},
							            	onClick: function(value, checked) {
							            		var newValue = checked;
							            		if(value == "Y" && !isSelectedAll3) {
							            			if(selectedRow3.balanceAmtDue == 0){ 
							            				showMessageBox("Printing of SOA with Balance Amount Due equal to zero is not allowed.", "I");
							            				newValue = false; 
							            			} else {//if(selectedRow3.agingBalAmtDue > 0){
							            				selectedRow3.incTag3 = "Y";
							            				insertRowToPrint3(selectedRow3);
							            			}
							            		} else if(value == "N" && !isSelectedAll3) {
							            			removeRowToPrint3(selectedRow3);
							            		}
							            		// this part handles the changes in checkbox after the btnSelectAll is clicked.
							            		if(isSelectedAll3){
							            			value == "N" ? removeRowToPrint3(selectedRow3) : insertRowToPrint3(selectedRow3);					            			
							            		}
							            		
							            		tagSelectedRow3(newValue, tbgAgingIntmTableGrid._mtgId, tbgAgingIntmTableGrid.getColumnIndex("incTag3"), selectedRow3.divCtrId);
							            		
							            		if(rowsToPrint3.length > 0 || allRowsToPrint3.length > 0){
							            			enableButton("btnListAllAging");
							            		} else if(rowsToPrint3.length == 0 && allRowsToPrint3.length == 0){
							            			disableButton("btnListAllAging");	
							            		}
						 			    	}
							            })
									}
					           	],
					resetchange : true,
					rows		: tbgAgingIntm.objAgingIntm
			};
			tbgAgingIntmTableGrid = new MyTableGrid(tbgAgingIntmTableModel);
			tbgAgingIntmTableGrid.pager = tbgAgingIntm.objAgingIntmTableGrid;
			tbgAgingIntmTableGrid.render('agingIntmTGDiv');
			tbgAgingIntmTableGrid.afterRender = function(){
				tbgAgingIntm.objAgingIntm = tbgAgingIntmTableGrid.geniisysRows;
				initialTotalAmtDue3 = formatCurrency(tbgAgingIntmTableGrid.geniisysRows[0].totalAmtDue);
				$("txtAgingListAllTGSum").value = initialTotalAmtDue3;
				$("txtAgingListAllTGSum").setAttribute("origValue", initialTotalAmtDue3);				
			};
		} catch(e){
			showErrorMessage("agingIntmListing", e);
		}
		
		$("mtgRefreshBtn"+tbgAgingIntmTableGrid._mtgId).observe("click", function(){
			allRowsToPrint3 = [];
	  		rowsToPrint3 = [];
	  		isSelectedAll3 = false;
	  		$("btnListAllSelectAll").value = "Select All";
	  		disableButton("btnListAllAging");
	  		recheckRows3(tbgAgingIntmTableGrid);
		});
	
	} else { // For assured
		try {
			var tbgAgingAssd = new Object();
			tbgAgingAssd.objAgingAssdTableGrid = JSON.parse('${agingIntmAssdList}');
			tbgAgingAssd.objAgingAssd = tbgAgingAssd.objAgingAssdTableGrid.rows || [];
			
			tbgAgingAssdTableModel = {
					url 		: contextPath + "/GIACCreditAndCollectionReportsController?action=getAgingAssdLOV&refresh=1",
					options		: {
						//title	: 'List of Intermediaries',
						width	: '650',
						height	: '250',
						validateChangesOnPrePager : function(){return false;},
						onCellFocus : function(element, value, x, y, id){
							var mtgId = tbgAgingAssdTableGrid._mtgId;						
							if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
								selectedIndex3 = y;
								row = y;
								selectedRow3 = tbgAgingAssdTableGrid.geniisysRows[y];
							}
						},
						onRemoveRowFocus: function(){
							tbgAgingAssdTableGrid.keys.releaseKeys();
							selectedIndex3 = -1;
							selectedRow3 = null;
							recheckRows3(tbgAgingAssdTableGrid);		     	
			          	},
			          	onSort: function(){
			          		recheckRows3(tbgAgingAssdTableGrid);
			          	},
			          	postPager: function(){
			          		recheckRows3(tbgAgingAssdTableGrid);
			          	},
						toolbar : {
							elements : [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
							onFilter: function(){
								allRowsToPrint3 = [];
						  		rowsToPrint3 = [];
						  		isSelectedAll3 = false;
						  		$("btnListAllSelectAll").value = "Select All";
						  		disableButton("btnListAllAging");
							}
						}
					},
					columnModel	: [
									{
									    id: 'recordStatus',
									    title: '',
									    width: '0px',
									    visible: false
									},
									{
										id: 'divCtrId',
										width: '0px',
										visible: false
									},
									{
									    id: 'assdNo',
									    title: 'Assd No.',
									    align: 'right',
									    width: '70px',
										filterOption: true,
										filterOptionType: 'integerNoNegative'
									},
									{
									    id: 'assdName',
									    title: 'Assured Name',
									    filterOption: true,
									    width: '350px'
									}, 
									{
									    id: 'balanceAmtDue',
									    title: 'Total Amount',
									    align: 'right',
									    width: '164px',
										geniisysClass: 'money',
										filterOption: true,
										filterOptionType: 'number'
									},  
									{
									    id: 'incTag3',
									    title: '&nbsp;&nbsp;P',
									    titleAlign: 'center',
									    altTitle: 'Include Tag',
									    align: 'center',
									    width: '30px',
									    sortable: false,
									    editable: true,
										defaultValue: false,
										otherValue: false,
									    editor: new MyTableGrid.CellCheckbox({
								            getValueOf: function(value){
							            		if (value){
													return "Y";
							            		} else {
													return "N";	
							            		}	
							            	},
							            	onClick: function(value, checked) {
							            		var newValue = checked;
							            		if(value == "Y" && !isSelectedAll3) {
							            			if(selectedRow3.balanceAmtDue == 0){ 
							            				showMessageBox("Printing of SOA with Balance Amount Due equal to zero is not allowed.", "I");
							            				newValue = false; 
							            			} else {//if(selectedRow3.agingBalAmtDue > 0){
							            				selectedRow3.incTag3 = "Y";
							            				insertRowToPrint3(selectedRow3);
							            			}
							            		} else if(value == "N" && !isSelectedAll3) {
							            			removeRowToPrint3(selectedRow3);
							            		}
							            		// this part handles the changes in checkbox after the btnSelectAll is clicked.
							            		if(isSelectedAll3){
							            			value == "N" ? removeRowToPrint3(selectedRow3) : insertRowToPrint3(selectedRow3);					            			
							            		}
							            		
							            		tagSelectedRow3(newValue, tbgAgingAssdTableGrid._mtgId, tbgAgingAssdTableGrid.getColumnIndex("incTag3"), selectedRow3.divCtrId);
							            		
							            		if(rowsToPrint3.length > 0 || allRowsToPrint3.length > 0){
							            			enableButton("btnListAllAging");
							            		} else if(rowsToPrint3.length == 0 && allRowsToPrint3.length == 0){
							            			disableButton("btnListAllAging");	
							            		}
						 			    	}
							            })
									}
					           	],
					resetchange : true,
					rows		: tbgAgingAssd.objAgingAssd
			};
			tbgAgingAssdTableGrid = new MyTableGrid(tbgAgingAssdTableModel);
			tbgAgingAssdTableGrid.pager = tbgAgingAssd.objAgingAssdTableGrid;
			tbgAgingAssdTableGrid.render('agingIntmTGDiv');
			tbgAgingAssdTableGrid.afterRender = function(){
				tbgAgingAssd.objAgingAssd = tbgAgingAssdTableGrid.geniisysRows;
				initialTotalAmtDue3 = formatCurrency(tbgAgingAssdTableGrid.geniisysRows[0].totalAmtDue);
				$("txtAgingListAllTGSum").value = initialTotalAmtDue3;
				$("txtAgingListAllTGSum").setAttribute("origValue", initialTotalAmtDue3);
			};
		} catch(e){
			showErrorMessage("agingAssdListing", e);
		}	

		$("mtgRefreshBtn"+tbgAgingAssdTableGrid._mtgId).observe("click", function(){
			allRowsToPrint3 = [];
	  		rowsToPrint3 = [];
	  		isSelectedAll3 = false;
	  		$("btnListAllSelectAll").value = "Select All";
	  		disableButton("btnListAllAging");
	  		recheckRows3(tbgAgingAssdTableGrid);
		});
	}

	function initializeFields(){
		disableButton("btnListAllAging");
	}
	
	function recheckRows3(tableGrid){
		var rows = tableGrid.geniisysRows;
		if (isSelectedAll3){
			for(var y=0; y<rows.length; y++){
				tagSelectedRow3(isSelectedAll3, tableGrid._mtgId, tableGrid.getColumnIndex("incTag3"), y);
			}
		}else{
			for(var y=0; y<rowsToPrint3.length; y++){
				for(var b=0; b<rows.length; b++){
					if (/*tableGrid == tbgAgingAssdTableGrid*/ objSOA.prevParams.viewType != "I"){	// SR-4050 : shan 06.19.2015
						if (rowsToPrint3[y].assdNo == rows[b].assdNo){
							tagSelectedRow3(true, tableGrid._mtgId, tableGrid.getColumnIndex("incTag3"), b);
						}
					}else if (/*tableGrid == tbgAgingIntmTableGrid*/ objSOA.prevParams.viewType == "I"){	// SR-4050 : shan 06.19.2015
						if (rowsToPrint3[y].intmNo == rows[b].intmNo){
							tagSelectedRow3(true, tableGrid._mtgId, tableGrid.getColumnIndex("incTag3"), b);
						}
					}
				}
			}
		}	
		computeTotalForRowsToPrint3();	// SR-4050 : shan 06.19.2015
	}
	
	function insertRowToPrint3(row) {
		var myRows = isSelectedAll3 ? allRowsToPrint3 : rowsToPrint3;
		var exists = false;
		
		if(objSOA.prevParams.viewType == "I"){
			for(var i=0; i<myRows.length; i++) {
				if(row.intmNo != null && row.intmNo == myRows[i].intmNo){
					exists = true;
					break;
				}
			}
		} else {
			for(var i=0; i<myRows.length; i++) {
				if(row.assdNo != null && row.assdNo == myRows[i].assdNo){
					exists = true;
					break;
				}
			}
		}
		if(!exists) {
			isSelectedAll3 ? allRowsToPrint3.push(row) : rowsToPrint3.push(row);
			computeTotalForRowsToPrint3();
		}
	}
	
	function removeRowToPrint3(row) {
		var myRows = isSelectedAll3 ? allRowsToPrint3 : rowsToPrint3;
		
		for(var i=0; i<myRows.length; i++) {
			if(row.intmNo != null && row.intmNo == myRows[i].intmNo){
				isSelectedAll3 ? allRowsToPrint3.splice(i,1) : rowsToPrint3.splice(i,1);
			} else if(row.assdNo != null && row.assdNo == myRows[i].assdNo){
				isSelectedAll3 ? allRowsToPrint3.splice(i,1) : rowsToPrint3.splice(i,1);
			}
		}
		computeTotalForRowsToPrint3();
		
		$("btnListAllSelectAll").value = "Select All";	// start SR-4050 : shan 06.19.2015
		if (isSelectedAll3){
			rowsToPrint3 = allRowsToPrint3;
			allRowsToPrint3 = [];
		}
		isSelectedAll3 = false;	// end SR-4050 : shan 06.19.2015
	}
	
	//checks/unchecks checkbox 'P' in the tablegrid
	function tagSelectedRow3(isTagged, mtgId, x, y){
		$('mtgInput' + mtgId + '_' + x + ',' + y).checked = isTagged;
		isTagged ? $('mtgIC'+ mtgId + '_' + x + ',' + y).addClassName('modifiedCell') : $('mtgIC'+ mtgId + '_' + x + ',' + y).removeClassName('modifiedCell');
		objSOA.prevParams.viewType == "I" ? tbgAgingIntmTableGrid.modifiedRows = [] : tbgAgingAssdTableGrid.modifiedRows = [];
	}
	
	function computeTotalForRowsToPrint3(){		
		var tempTotal = parseFloat(0);
		var myRows = isSelectedAll3 ? allRowsToPrint3 : rowsToPrint3;
		
		for(var i=0; i<myRows.length; i++) {
			tempTotal += parseFloat(myRows[i].balanceAmtDue);			
		}
		totalAmtForRowsToPrint3 = tempTotal;
		if(parseFloat(totalAmtForRowsToPrint3) == parseFloat("0")){
			$("txtAgingListAllTGSum").value = formatCurrency($("txtAgingListAllTGSum").readAttribute("origValue"));
		} else {
			$("txtAgingListAllTGSum").value = formatCurrency(totalAmtForRowsToPrint3);
		}
		
	}
	
	function prepareForPrint(){ // print_records
		if(objSOA.prevParams.printBtnNo == 1){
			currentPrintParams.reportName = "GIACR190B";
			currentPrintParams.reportTitle = "SOA - Aging (Intermediary)";
		} else if(objSOA.prevParams.printBtnNo == 2){
			currentPrintParams.reportName = "GIACR190D";
			currentPrintParams.reportTitle = "SOA - Aging (Assured)";
		} else if(objSOA.prevParams.printBtnNo == 3){
			currentPrintParams.reportName = "GIACR190A";
			currentPrintParams.reportTitle = "SOA - List All (Intermediary)";
		} else if(objSOA.prevParams.printBtnNo == 4){
			if(objSOA.prevParams.viewType == "I"){
				currentPrintParams.reportName = "GIACR190A";
				currentPrintParams.reportTitle = "SOA - List All (Intermediary)";
			} else {
				currentPrintParams.reportName = "GIACR190C";
				currentPrintParams.reportTitle = "SOA - List All (Assured)";				
			}
		} else if(objSOA.prevParams.printBtnNo == 5 || objSOA.prevParams.printBtnNo == 6){
			currentPrintParams.reportName = "GIACR190C";
			currentPrintParams.reportTitle = "SOA - List All (Assured)";
		} 
		
		getParamsToPrint(isSelectedAll3, allRowsToPrint3, rowsToPrint3);
		
		var fileType = "";
		if($("rdoPdf").disabled == false/*  && $("rdoExcel").disabled == false */){
			//fileType = $("rdoPdf").checked ? "PDF" : "XLS"; 
			fileType = "PDF"; // please revise when CSV is available - andrew
		}
		var content = contextPath+"/CreditAndCollectionReportPrintController?action=printReport"
					+ "&reportId=" + currentPrintParams.reportName	
					+ "&noOfCopies=" + $F("txtNoOfCopies") + "&printerName=" + $F("selPrinter") + "&destination=" + $F("selDestination")
					+ "&fileType=" + fileType
					
					+ "&printButtonNo=" + objSOA.prevParams.printBtnNo
					+ "&intmNoList=" + encodeURIComponent(nvl(objSOA.prevParams.intmNoList,""))
					+ "&assdNoList=" + encodeURIComponent(nvl(objSOA.prevParams.assdNoList,""))
					+ "&agingIdList=" + encodeURIComponent(nvl(objSOA.prevParams.agingIdList,""))
					+ "&assdNo=" + (objSOA.prevParams.viewType == "A" ? nvl(objSOA.prevParams.intmOrAssdNo, "") : "")
					+ "&intmNo=" + (objSOA.prevParams.viewType != "A" ? nvl(objSOA.prevParams.intmOrAssdNo, "") : "")
					//+ "&agingId=" + agingId 
					+ "&outstandingBal=" ;					
		
		printGenericReport(content, currentPrintParams.reportTitle);
	}
	
	$("btnListAllAging").observe("click", function(){
		objSOA.prevParams.fromButton = "listAll";
		//objSOA.prevParams.intmOrAssdNo = objSOA.prevParams.viewType == "A" ? selectedRow3.assdNo : selectedRow3.intmNo;
		getParamsToPrint(isSelectedAll3, allRowsToPrint3, rowsToPrint3);
		var intmAssdList = (objSOA.prevParams.viewType == "I" ? objSOA.prevParams.intmNoList :objSOA.prevParams.assdNoList);
		objSOA.prevParams.intmAssdList = intmAssdList.substring(1, intmAssdList.length - 1).replace(/#/g, ",");
		objSOA.prevParams.filterBy3	= (objSOA.prevParams.viewType == "I" ? tbgAgingIntmTableGrid.objFilter : tbgAgingAssdTableGrid.objFilter);	// SR-4050 : shan 06.19.2015
				
		try{
			overlayFilterByAgingList = Overlay.show(contextPath+"/GIACCreditAndCollectionReportsController", { 
				urlContent: true,
				urlParameters: {
					action 		: "getFilterByAgingList",
					intmAssdNo	: (objSOA.prevParams.viewType == "I" ? nvl(selectedRow3.intmNo,objSOA.prevParams.intmOrAssdNo) : nvl(selectedRow3.assdNo,objSOA.prevParams.intmOrAssdNo)),
					viewType	: objSOA.prevParams.viewType,
					fromButton	: objSOA.prevParams.fromButton,
					intmAssdList : objSOA.prevParams.intmAssdList, 
					listFilter	: prepareJsonAsParameter(objSOA.prevParams.filterBy3)},	// SR-4050 : shan 06.19.2015
				title: "Filter by aging",							
			    height: 350,
			    width: 540,
			    draggable: true,
			    onCompleteFunction : function(){
			    }
			});					
		}catch(e){
			showErrorMessage("btnListAllAging: " + e);
		}
	});
	
	$("btnListAllSelectAll").observe("click", function(){
		$("btnListAllSelectAll").value = isSelectedAll3 ? "Select All" : "Unselect All";
		isSelectedAll3 = isSelectedAll3 ? false : true; 
		
		if(isSelectedAll3){
			allRowsToPrint3 = [];
			rowsToPrint3 = [];
			var filterBy = (objSOA.prevParams.viewType == "I" ? tbgAgingIntmTableGrid.objFilter: tbgAgingAssdTableGrid.objFilter);
			try {
				new Ajax.Request(contextPath+"/GIACCreditAndCollectionReportsController?action=" + (objSOA.prevParams.viewType == "I" ? "getAgingIntmLOVAll" : "getAgingAssdLOVAll"), {
					method: "POST",	
					parameters: {
						intmOrAssdNo : objSOA.prevParams.intmOrAssdNo, //nvl(objSOA.prevParams.intmOrAssdNo,0), Kris 04.23.2014 
						viewType	 : objSOA.prevParams.viewType,
						objFilter	 : prepareJsonAsParameter(filterBy)
					},
					asynchronous: false,
					evalScripts: true,
					onCreate: showNotice("Checking records, please wait..."),	// SR-4050 : shan 06.19.2015
					onComplete: function(response){
						hideNotice();	// SR-4050 : shan 06.19.2015
						changeTag = 0;
						if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response, null)){
							allRowsToPrint3 = JSON.parse(response.responseText);
						} else {
							showMessageBox(response.responseText, imgMessage.ERROR);
						} 
					}
				});	
			}catch(e){
				showErrorMessage("btnFilterBySelectAll", e);
			}
		} else {
			allRowsToPrint3 = [];
			rowsToPrint3 = [];
			//$("txtAgingListAllTGSum").value = initialTotalAmtDue3;
		}
		$("txtAgingListAllTGSum").value = initialTotalAmtDue3;
		
		// update the checkboxes in the table grid
		if(objSOA.prevParams.viewType == "I"){
			var rows = tbgAgingIntm.objAgingIntm;
			for(var y=0; y<rows.length; y++){
				tagSelectedRow3(isSelectedAll3, tbgAgingIntmTableGrid._mtgId, tbgAgingIntmTableGrid.getColumnIndex("incTag3"), y);
			}
		} else {
			var rows = tbgAgingAssd.objAgingAssd;
			for(var y=0; y<rows.length; y++){
				tagSelectedRow3(isSelectedAll3, tbgAgingAssdTableGrid._mtgId, tbgAgingAssdTableGrid.getColumnIndex("incTag3"), y);
			}
		}
		for(var x=0; x<allRowsToPrint3.length; x++){
			allRowsToPrint3[x].incTag3 = isSelectedAll3 ? "Y" : "N";
		}
		
		if(rowsToPrint3.length > 0 || allRowsToPrint3.length > 0){
			enableButton("btnListAllAging");
		} else if(rowsToPrint3.length == 0 && allRowsToPrint3.length == 0){
			disableButton("btnListAllAging");	
		}
	});
	
	$("btnListAllPrint").observe("click", function(){
		//showMessageBox("The selected report is not  yet available.", "I");
		if(allRowsToPrint3.length == 0 && rowsToPrint3.length == 0){
			showMessageBox("Please select an item to print.", "I");
		} else {
			if(objSOA.prevParams.viewType == "I"){
				objSOA.prevParams.printBtnNo = 3;
			} else if(objSOA.prevParams.viewType == "A"){
				objSOA.prevParams.printBtnNo = 5;
			}
			showGenericPrintDialog("Printing Window", prepareForPrint, "", true);
		}
	});
	
	$("btnListAllReturn").observe("click", function(){
		overlayAgingIntmList.close();
	});
	
	initializeFields();
	
</script>