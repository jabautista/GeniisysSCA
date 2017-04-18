<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="filterByAgingmMainDiv" class="filterByAgingmMainDiv" >
	<div id="filterByAgingTGDiv" name="filterByAgingTGDiv" style="height:250px; margin:20px 20px 5px 20px;">
	</div>
	
	<div id="filterByAgingTextDiv" name="filterByAgingTextDiv" style="float:right; float:left; margin:5px 5px 20px 350px;">
		<table id="tblSum" border="0" style="width:250px; align:right;">
			<tr>
				<td style="text-align:right;">Total:</td>
				<td><input type="text" id="filterByAgingTGSum" name="filterByAgingTGSum" origValue="" readonly="readonly" style="width:150px; margin-left:5px; text-align:right;" /></td>
			</tr>
		</table>
	</div>
	
	<div id="filterByAgingButtonsDiv" name="filterByAgingButtonsDiv" class="buttonsDiv" style="margin-top:5px; margin-bottom:5px;">
		<input type="button" class="button" id="btnFilterBySelectAll" name="btnFilterBySelectAll" value="Select All" style="width:90px;" />
		<input type="button" class="button" id="btnFilterByPrint" name="btnFilterByPrint" value="Print" style="width:90px;" />
		<input type="button" class="button" id="btnFilterByReturn" name="btnFilterByReturn" value="Return" style="width:90px;" />
	</div>
</div>

<script type="text/javascript">
	objSOA.printParams = null;
	currentPrintParams = new Object();

	var rowsToPrint2 = [];								// for holding records if record is selected via checkbox
	var allRowsToPrint2 = []; 							// for holding all records if all records are selected via btnSelectall
	
	var totalAmtForRowsToPrint2 = parseFloat(0); 		// for holding the current total of balance amount in rowsToPrint
	var initialTotalAmtDue2 = parseFloat(0);			// for holding the initial sum of total amt due upon loading of tg.
	
	var selectedIndex2 = -1;
	var selectedRow2 = new Object();					
	var isSelectedAll2 = false;  						// set to true if button btnSelectAll is clicked. same as VARIABLES.select_all
	
	
	if(objSOA.prevParams.fromButton == "printCollectionLetter"){
		try {
			var tbgAging = new Object();
			tbgAging.objAgingTableGrid = JSON.parse('${filterByAgingList}');
			tbgAging.objAging = tbgAging.objAgingTableGrid.rows || [];
			
			tbgAgingTableModel = {
					url 		: contextPath + "/GIACCreditAndCollectionReportsController?"
											  + "action=getFilterByAgingList"
											  + "&refresh=1&viewType="+encodeURIComponent(objSOA.prevParams.viewType)
											  + "&intmAssdNo=" + nvl(objSOA.prevParams.intmOrAssdNo,"")
											  + "&fromButton=" + objSOA.prevParams.fromButton,
					options		: {
						width	: '580',
						height	: '230',
						validateChangesOnPrePager : function(){return false;},
						onCellFocus : function(element, value, x, y, id){
								var mtgId = tbgAgingTableGrid._mtgId;
								
								if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
									selectedIndex2 = y;
									row = y;
									selectedRow2 = tbgAgingTableGrid.geniisysRows[y];
								}
						},
						onRemoveRowFocus: function(){
							tbgAgingTableGrid.keys.releaseKeys();
							selectedIndex2 = -1;
							selectedRow2 = null;
							recheckRows2();		     	
			          	},
			          	onSort: function(){
			          		recheckRows2();
			          	},
			          	postPager: function(){
			          		recheckRows2();
			          	},
						toolbar : {
							elements : [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
							onFilter: function(){
								allRowsToPrint2 = [];
						  		rowsToPrint2 = [];
						  		isSelectedAll2 = false;
						  		$("btnFilterBySelectAll").value = "Select All";
							}
						}
					},
					columnModel	: [
									{
									    id: 'recordStatus',
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
									    width: '0px',
										visible: false									
									},
									{
									    id: 'assdNo',
									    width: '0px',
										visible: false									
									},
									{
									    id: 'agingId',
									    width: '0px',
										visible: false									
									},
									{
									    id: 'fundCd',
									    title: 'Fund',
									    width: '70px',
										filterOption: true							
									},
									{
									    id: 'branchCd',
									    title: 'Branch',
									    width: '70px',
										filterOption: true
									}, 
									{
									    id: 'ageLevel',
									    title: 'Age Level',
									    width: '190px',
										filterOption: true
									}, 
									{
									    id: 'agingBalAmtDue',
									    title: 'Total Balance Due',
									    titleAlign: 'right',
									    align: 'right',
									    width: '170px',
										geniisysClass: 'money',
										filterOption: true,
										filterOptionType: 'number'
									},
									{
									    id: 'agingTaxBalDue',
									    width: '0px',
										visible: false
									},  
									{
									    id: 'agingPremBalDue',
									    width: '0px',
										visible: false
									},  
									{
									    id: 'incTag2',
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
							            		if(value == "Y" && !isSelectedAll2) {
							            			if(selectedRow2.agingBalAmtDue == 0){ //balanceAmtDue == 0
							            				showMessageBox("Printing of SOA with Balance Amount Due equal to zero is not allowed.", "I");
							            				newValue = false; 
							            			} else {//if(selectedRow2.agingBalAmtDue > 0){
							            				selectedRow2.incTag2 = "Y";
							            				insertRowToPrint2(selectedRow2);
							            			}
							            		} else if(value == "N" && !isSelectedAll2) {
							            			removeRowToPrint2(selectedRow2);
							            		}
							            		// this part handles the changes in checkbox after the btnSelectAll is clicked.
							            		if(isSelectedAll2){
							            			value == "N" ? removeRowToPrint2(selectedRow2) : insertRowToPrint2(selectedRow2);					            			
							            		}
							            		
							            		tagSelectedRow2(newValue, tbgAgingTableGrid._mtgId, tbgAgingTableGrid.getColumnIndex("incTag2"), selectedRow2.divCtrId);
						 			    	}
							            })
									}
					           	],
					rows		: tbgAging.objAging
			};
			tbgAgingTableGrid = new MyTableGrid(tbgAgingTableModel);
			tbgAgingTableGrid.pager = tbgAging.objAgingTableGrid;
			tbgAgingTableGrid.render('filterByAgingTGDiv');
			tbgAgingTableGrid.afterRender = function(){
				tbgAging.objAging = tbgAgingTableGrid.geniisysRows;
				initialTotalAmtDue = formatCurrency(tbgAgingTableGrid.geniisysRows[0].totalAmtDue);
				$("filterByAgingTGSum").value = initialTotalAmtDue;
				$("filterByAgingTGSum").setAttribute("origValue", initialTotalAmtDue);
			};
		} catch(e){
			showMessageBox("tbgAgingTableGrid", e);
		}
	
	} else if(objSOA.prevParams.fromButton == "listAll"){
		// hide the table for sum
		$("tblSum").hide();
		
		try {
			var tbgAging = new Object();
			tbgAging.objAgingTableGrid = JSON.parse('${filterByAgingList}');
			tbgAging.objAging = tbgAging.objAgingTableGrid.rows || [];
			
			tbgAgingTableModel = {
					url 		: contextPath + "/GIACCreditAndCollectionReportsController?"
											  + "action=getFilterByAgingList"
											  + "&refresh=1&viewType="+encodeURIComponent(objSOA.prevParams.viewType)
											  + "&intmAssdNo=" + nvl(objSOA.prevParams.intmOrAssdNo, "")
											  + "&fromButton=" + objSOA.prevParams.fromButton
											  + "&intmAssdList=" + objSOA.prevParams.intmAssdList,
					options		: {
						width	: '500',
						height	: '230',
						validateChangesOnPrePager : function(){return false;},
						onCellFocus : function(element, value, x, y, id){
							//tbgAgingTableGrid.keys.releaseKeys(); removed releaseKeys so that the tablegrid checkbox will function properly, pol cruz, 3.22.2014
								var mtgId = tbgAgingTableGrid._mtgId;
								
								if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
									selectedIndex2 = y;
									row = y;
									selectedRow2 = tbgAgingTableGrid.geniisysRows[y];
								}
						},
						onRemoveRowFocus: function(){
							tbgAgingTableGrid.keys.releaseKeys();
							selectedIndex2 = -1;
							selectedRow2 = null;
			          		recheckRows2();		     	
			          	},
			          	onSort: function(){
			          		recheckRows2();
			          	},
			          	postPager: function(){
			          		recheckRows2();
			          	},
						toolbar : {
							elements : [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
							onFilter: function(){
								allRowsToPrint2 = [];
						  		rowsToPrint2 = [];
						  		isSelectedAll2 = false;
						  		$("btnFilterBySelectAll").value = "Select All";
							}
						}
					},
					columnModel	: [
									{
									    id: 'recordStatus',
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
									    width: '0px',
										visible: false									
									},
									{
									    id: 'assdNo',
									    width: '0px',
										visible: false									
									},
									{
									    id: 'agingId',
									    width: '0px',
										visible: false									
									},
									{
									    id: 'fundCd',
									    title: 'Fund',
									    width: '100px',
										filterOption: true							
									},
									{
									    id: 'branchCd',
									    title: 'Branch',
									    width: '100px',
										filterOption: true
									}, 
									{
									    id: 'ageLevel',
									    title: 'Age Level',
									    width: '215px',
										filterOption: true
									}, 
									{
									    id: 'agingBalAmtDue',
									    width: '0px',
										visible: false
									},
									{
									    id: 'agingTaxBalDue',
									    width: '0px',
										visible: false
									},  
									{
									    id: 'agingPremBalDue',
									    width: '0px',
										visible: false
									},  
									{
									    id: 'incTag2',
									    title: '&nbsp;&nbsp;P',
									    titleAlign: 'center',
									    altTitle: 'Include Tag',
									    align: 'center',
									    width: '40px',
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
							            		if(value == "Y" && !isSelectedAll2) {
							            			if(selectedRow2.agingBalAmtDue == 0){ //balanceAmtDue == 0
							            				showMessageBox("Printing of SOA with Balance Amount Due equal to zero is not allowed.", "I");
							            				newValue = false; 
							            			} else {//if(selectedRow2.agingBalAmtDue > 0){
							            				selectedRow2.incTag2 = "Y";
							            				insertRowToPrint2(selectedRow2);
							            			}
							            		} else if(value == "N" && !isSelectedAll2) {
							            			removeRowToPrint2(selectedRow2);
							            		}
							            		// this part handles the changes in checkbox after the btnSelectAll is clicked.
							            		if(isSelectedAll2){
							            			value == "N" ? removeRowToPrint2(selectedRow2) : insertRowToPrint2(selectedRow2);					            			
							            		}
							            		
							            		tagSelectedRow2(newValue, tbgAgingTableGrid._mtgId, tbgAgingTableGrid.getColumnIndex("incTag2"), selectedRow2.divCtrId);
						 			    	}
							            })
									}
					           	],
					//resetchange : true,
					rows		: tbgAging.objAging
			};
			tbgAgingTableGrid = new MyTableGrid(tbgAgingTableModel);
			tbgAgingTableGrid.pager = tbgAging.objAgingTableGrid;
			tbgAgingTableGrid.render('filterByAgingTGDiv');
			tbgAgingTableGrid.afterRender = function(){
				tbgAging.objAging = tbgAgingTableGrid.geniisysRows;
								
				if(tbgAging.objAging.length > 0) {
					initialTotalAmtDue = formatCurrency(tbgAgingTableGrid.geniisysRows[0].totalAmtDue);
				}else
					initialTotalAmtDue = 0;
				$("filterByAgingTGSum").value = initialTotalAmtDue;
				$("filterByAgingTGSum").setAttribute("origValue", initialTotalAmtDue);
			};
		} catch(e){
			showMessageBox("tbgAgingTableGrid", e);
		}
	}
	
	function recheckRows2(){
		var rows = tbgAgingTableGrid.geniisysRows;
		if (isSelectedAll2){
			for(var y=0; y<rows.length; y++){
				tagSelectedRow2(isSelectedAll2, tbgAgingTableGrid._mtgId, tbgAgingTableGrid.getColumnIndex("incTag2"), y);
			}
		}else{
			for(var y=0; y<rowsToPrint2.length; y++){
				for(var b=0; b<rows.length; b++){
					if (rowsToPrint2[y].agingId == rows[b].agingId){
						tagSelectedRow2(true, tbgAgingTableGrid._mtgId, tbgAgingTableGrid.getColumnIndex("incTag2"), b);
					}
				}
			}
		}	
		computeTotalForRowsToPrint2();	// SR-4050 : shan 06.19.2015
	}
	
	function insertRowToPrint2(row) {
		var myRows = isSelectedAll2 ? allRowsToPrint2 : rowsToPrint2;
		var exists = false;
		
		for(var i=0; i<myRows.length; i++) {
			if(row.agingId != null && row.agingId == myRows[i].agingId){
				exists = true;
				break;
			}
		}
		if(!exists) {
			isSelectedAll2 ? allRowsToPrint2.push(row) : rowsToPrint2.push(row);
			computeTotalForRowsToPrint2();
		}
	}
	
	function removeRowToPrint2(row) {
		var myRows = isSelectedAll2 ? allRowsToPrint2 : rowsToPrint2;
		
		for(var i=0; i<myRows.length; i++) {
			if(row.agingId != null && row.agingId == myRows[i].agingId){
				isSelectedAll2 ? allRowsToPrint2.splice(i,1) : rowsToPrint2.splice(i,1);
			}
		}
		computeTotalForRowsToPrint2();
		
		$("btnFilterBySelectAll").value = "Select All";	// start SR-4050 : shan 06.19.2015
		if (isSelectedAll2){
			rowsToPrint2 = allRowsToPrint2;
			allRowsToPrint2 = [];
		}
		isSelectedAll2 = false;	// end SR-4050 : shan 06.19.2015
	}
	//checks/unchecks checkbox 'P' in the tablegrid
	function tagSelectedRow2(isTagged, mtgId, x, y){
		$('mtgInput' + mtgId + '_' + x + ',' + y).checked = isTagged;
		isTagged ? $('mtgIC'+ mtgId + '_' + x + ',' + y).addClassName('modifiedCell') : $('mtgIC'+ mtgId + '_' + x + ',' + y).removeClassName('modifiedCell');
		tbgAgingTableGrid.modifiedRows = [];
	}
	
	function computeTotalForRowsToPrint2(){		
		var tempTotal = parseFloat(0);
		var myRows = isSelectedAll2 ? allRowsToPrint2 : rowsToPrint2;
		
		for(var i=0; i<myRows.length; i++) {
			tempTotal += parseFloat(myRows[i].agingBalAmtDue);			
		}
		totalAmtForRowsToPrint2 = tempTotal;
		
		if($("filterByAgingTextDiv") != null && $("filterByAgingTGSum") != null){
			if(parseFloat(totalAmtForRowsToPrint2) == parseFloat("0")){
				$("filterByAgingTGSum").value = formatCurrency($("filterByAgingTGSum").readAttribute("origValue"));
			} else {
				$("filterByAgingTGSum").value = formatCurrency(totalAmtForRowsToPrint2);
			}
		}
	}
	
	function preProcess(){
		showGenericPrintDialog("Printing Window", prepareForPrint, "", true);
	}
	
	//executes PROCESS_ASSD or PROCESS_INTM
	//function processIntmOrAssd(){
	//function processIntmOrAssd(intmNoList, assdNoList, agingIdList, intmNo, assdNo, agingId, fileType){
	function processIntmOrAssd(intmNo, assdNo, agingId, fileType){
		try {
			/* validation removed as per SA Albert : shan 01.28.2015	// SR-4050 : shan 06.19.2015
			new Ajax.Request(contextPath+"/GIACCreditAndCollectionReportsController?action=processIntmOrAssd2", {
				method: "POST",
				parameters: {
					viewType : objSOA.prevParams.viewType,
					intmNoList: objSOA.prevParams.intmNoList, //intmNoList,
					assdNoList: objSOA.prevParams.assdNoList, //assdNoList,
					agingIdList: objSOA.prevParams.agingIdList, //agingIdList,
					assdNo: assdNo, 
					intmNo: intmNo,
					agingId: agingId,
					fromButton: objSOA.prevParams.fromButton,
					reportId: currentPrintParams.reportName
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					changeTag = 0;
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response, null)){
						// sa orig na processIntmOrAssd ito
						/*currentPrintParams.queryOne = response.responseText;	
						//prepareForPrint();
						//showGenericPrintDialog("Printing Window", prepareForPrint, "", true);* /
						
						// for processIntmOrAssd2
						//var processedList = JSON.parse(response.responseText);
						var isExisting = response.responseText;
						//if(objSOA.prevParams.fromButton == "listAllAging"){
							if(isExisting == "N"/* processedList.length == 0 * /){
								//showMessageBox("No records with this age were fetched for this " + (objSOA.prevParams.viewType == "A" ? "assured" : "intermediary") + ".", "I");
							} else if(isExisting == "Y") {*/	// SR-4050 : shan 06.19.2015
								//showGenericPrintDialog("Printing Window", prepareForPrint, "", true);
								
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
											+ "&agingId=" + nvl(agingId, "")
											+ "&outstandingBal=" ; 
								printGenericReport(content, currentPrintParams.reportTitle);
				/*			}	// SR-4050 : shan 06.19.2015
						//}
						
					} else {
						overlayGenericPrintDialog.close();
					} 
				}
			});	*/	// SR-4050 : shan 06.19.2015
		} catch(e){
			showErrorMessage("processIntmOrAssd", e);
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
		
		if(objSOA.prevParams.fromButton == "listAll"){
			objSOA.prevParams.fromButton = "listAllAging";
		} else if(objSOA.prevParams.fromButton == "printCollectionLetter"){
			objSOA.prevParams.fromButton = "printCollectionLetterAging";
		}
		
		getParamsToPrint(isSelectedAll2, allRowsToPrint2, rowsToPrint2);
		var fileType = "";
		if($("rdoPdf").disabled == false/*  && $("rdoExcel").disabled == false */){
			//fileType = $("rdoPdf").checked ? "PDF" : "XLS"; 
			fileType = "PDF"; // please revise when CSV is availble - andrew
		}
		
		var assdNo = objSOA.prevParams.viewType == "A" ? objSOA.prevParams.intmOrAssdNo : "";
		var intmNo = objSOA.prevParams.viewType != "A" ? objSOA.prevParams.intmOrAssdNo : "";
		//processIntmOrAssd(intmNoList, assdNoList, agingIdList, intmNo, assdNo, agingId, fileType);
		processIntmOrAssd(intmNo, assdNo, null, fileType);		
	}
	
	$("btnFilterBySelectAll").observe("click", function(){
		$("btnFilterBySelectAll").value = isSelectedAll2 ? "Select All" : "Unselect All";
		isSelectedAll2 = isSelectedAll2 ? false : true;		
		
		if(isSelectedAll2){
			rowsToPrint2 = [];
			allRowsToPrint2 = [];
			try {
				new Ajax.Request(contextPath+"/GIACCreditAndCollectionReportsController?action=getListAllAgingSelectAll",{ // + (objSOA.prevParams.viewType == "I" ? "getFilterByAgingIntmAll" : "getFilterByAgingAssdAll"), {
					method: "POST",
					parameters: {
						intmOrAssdNo : objSOA.prevParams.intmOrAssdNo, 
						viewType	 : objSOA.prevParams.viewType,
						objFilter	 : prepareJsonAsParameter(tbgAgingTableGrid.objFilter),
						intmAssdList : objSOA.prevParams.intmAssdList,
						fromButton	 : objSOA.prevParams.fromButton,
						listFilter	: prepareJsonAsParameter(objSOA.prevParams.filterBy3)	//filter of intm/assd	// SR-4050 : shan 06.19.2015
					},
					asynchronous: false,
					evalScripts: true,
					onCreate: showNotice("Checking records, please wait..."),	// SR-4050 : shan 06.19.2015
					onComplete: function(response){
						hideNotice();	// SR-4050 : shan 06.19.2015
						changeTag = 0;
						if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response, null)){
							allRowsToPrint2 = JSON.parse(response.responseText);
						} else {
							showMessageBox(response.responseText, imgMessage.ERROR);
						} 
					}
				});	
			}catch(e){
				showErrorMessage("btnFilterBySelectAll", e);
			}
		} else {
			allRowsToPrint2 = [];
			rowsToPrint2 = [];
			//$("filterByAgingTGSum").value = initialTotalAmtDue;
		}
		$("filterByAgingTGSum").value = initialTotalAmtDue;
		// update the checkboxes in the table grid
		var rows = tbgAging.objAging;
		for(var y=0; y<rows.length; y++){
			tagSelectedRow2(isSelectedAll2, tbgAgingTableGrid._mtgId, tbgAgingTableGrid.getColumnIndex("incTag2"), y);
		}
		for(var x=0; x<allRowsToPrint2.length; x++){
			allRowsToPrint2[x].incTag2 = isSelectedAll2 ? "Y" : "N";
		}
	});
		
	$("btnFilterByPrint").observe("click", function(){
		if(allRowsToPrint2.length == 0 && rowsToPrint2.length == 0){ //!isSelectedAll2 && && selectedIndex2 == -1
			showMessageBox("Please select an item to print.", "I");			
		} else {
			if(objSOA.prevParams.fromButton == "listAll" || objSOA.prevParams.fromButton == "listAllAging"){
				if(objSOA.prevParams.viewType == "I"){
					objSOA.prevParams.printBtnNo = 4;
					//processIntmOrAssd();
					preProcess();
				} else {// if(objSOA.prevParams.viewType == "A"){
					objSOA.prevParams.printBtnNo = 6;
					//processIntmOrAssd();
					preProcess();
				}
			} else if(objSOA.prevParams.fromButton == "printCollectionLetter" || objSOA.prevParams.fromButton == "printCollectionLetterAging"){
				if(objSOA.prevParams.viewType == "I"){
					objSOA.prevParams.printBtnNo = 1;
					//processIntmOrAssd();
					preProcess();
				} else if(objSOA.prevParams.viewType == "A"){
					objSOA.prevParams.printBtnNo = 2;
					//processIntmOrAssd();
					preProcess();
				}
			}
			/*if(objSOA.prevParams.viewType == "I"){
				objSOA.prevParams.printBtnNo = 1;
				processIntmOrAssd(); //nirereturn si Query na ipapasa kay Jasper 
				// note!!! execute the select statement in GAGT.print_intm <button> before calling the Jasper				
			} else if(objSOA.prevParams.viewType == "A"){
				objSOA.prevParams.printBtnNo = 2;
				processIntmOrAssd(); //nirereturn si Query na ipapasa kay Jasper 
				// note!!! execute the select statement in CONTROL.print_assd <button> before calling the Jasper				
			}*/
		}
	});
	
	$("btnFilterByReturn").observe("click", function(){
		if(objSOA.prevParams.fromButton == "listAllAging"){
			objSOA.prevParams.fromButton = "listAll";
		} else if(objSOA.prevParams.fromButton == "printCollectionLetterAging"){
			objSOA.prevParams.fromButton = "printCollectionLetter";
		}
		overlayFilterByAgingList.close();
	});
	
	$("mtgRefreshBtn"+tbgAgingTableGrid._mtgId).observe("click", function(){
		allRowsToPrint2 = [];
  		rowsToPrint2 = [];
  		isSelectedAll2 = false;
  		$("btnFilterBySelectAll").value = "Select All";
  		recheckRows2();
	});
</script>