<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="reprintCollnLetterMainDiv" class="sectionDiv">
	<div id="reprintCollnLetterTGDiv" name="reprintCollnLetterTGDiv" style="height:330px; margin:20px 20px 20px 30px;">
	</div>
	
	<div id="reprintCollnLetterButtonsDiv" name="reprintCollnLetterButtonsDiv" class="buttonsDiv" style="margin-top: 20px;">
		<input type="button" class="button" id="btnReprintCLSelectAll" name="btnReprintCLSelectAll" value="Select All" style="width:90px;" />
		<input type="button" class="button" id="btnReprintCLPrint" name="btnReprintCLPrint" value="Print" style="width:90px;" />
		<input type="button" class="button" id="btnReprintCLReturn" name="btnReprintCLReturn" value="Back" style="width:90px;" />
	</div>
</div>


<script>
	var selectedIndex = -1;
	var selectedRow = new Object();
	var isSelectedAll = false;  						// set to true if button btnSelectAll is clicked. same as VARIABLES.select_all
	
	var totalAmtForRowsToPrint = parseFloat(0); 		// for holding the current total of balance amount in rowsToPrint
	var initialTotalAmtDue = parseFloat(0);				// for holding the initial sum of total amt due upon loading of tg.
	
	allRowsToPrint = [];
	rowsToPrint = [];

	try {
		var tbgCollnLetter = new Object();
		tbgCollnLetter.objCollnLetterTableGrid = JSON.parse('${collnLetterList}');
		tbgCollnLetter.objCollnLetter = tbgCollnLetter.objCollnLetterTableGrid.rows || [];
		
		tbgCollnLetterTableModel = {
				url 		: contextPath + "/GIACCreditAndCollectionReportsController?action=getCollnLetterList&refresh=1",
				options		: {
					width	: '850',
					height	: '315',
					validateChangesOnPrePager : false,
					onCellFocus : function(element, value, x, y, id){
						var mtgId = tbgCollnLetterTableGrid._mtgId;						
						if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
							selectedIndex = y;
							row = y;
							selectedRow = tbgCollnLetterTableGrid.geniisysRows[y];
						}		
					},
					onRemoveRowFocus: function(){
						tbgCollnLetterTableGrid.keys.releaseKeys();
						selectedIndex = -1;
						selectedRow = null;		     	
		          	},
					toolbar : {
						elements : [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]			
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
								    id: 'collSeqNo',
								    title: 'Sequence No.',
								    align: 'right',
								    width: '100px',
									filterOption: true,
									filterOptionType: 'integerNoNegative',
									renderer: function(value){
										return formatNumberDigits(value, 7);
									}
								},
								{
								    id: 'collLetNo',
								    title: 'Letter No.',
								    align: 'right',
								    width: '100px',
									filterOption: true,
									filterOptionType: 'integerNoNegative'
								},
								{
								    id: 'collYear',
								    title: 'Year',
								    align: 'right',
								    width: '100px',
									filterOption: true,
									filterOptionType: 'integerNoNegative'
								},
								{
								    id: 'billNo',
								    title: 'Bill No.',
								    width: '120px',
									filterOption: true
								}, 
								{
								    id: 'balanceAmtDue',
								    title: 'Balance Amt Due',
								    align: 'right',
								    width: '160px',
									geniisysClass: 'money',
									filterOption: true,
									filterOptionType: 'number'
								},
								{
								    id: 'userId',
								    title: 'User ID',
								    width: '100px',
									filterOption: true
								}, 
								{
								    id: 'lastUpdate2',
								    title: 'Last Update',
								    width: '100px',
									filterOption: true,
									filterOptionType: 'formattedDate',
								    geniisysClass: 'date',
								    renderer : function(value){
										return dateFormat(value, 'mm-dd-yyyy');
									}
								}, 
								{
								    id: 'incTag',
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
						            		if(value == "Y" && !isSelectedAll) {
						            			if(selectedRow.balanceAmtDue == 0){ 
						            				showMessageBox("Printing of SOA with Balance Amount Due equal to zero is not allowed.", "I");
						            				newValue = false; 
						            			} else {//if(selectedRow.agingBalAmtDue > 0){
						            				selectedRow.incTag = "Y";
						            				insertRowToPrint(selectedRow);
						            			}
						            		} else if(value == "N" && !isSelectedAll) {
						            			removeRowToPrint(selectedRow);
						            		}
						            		// this part handles the changes in checkbox after the btnSelectAll is clicked.
						            		if(isSelectedAll){
						            			value == "N" ? removeRowToPrint(selectedRow) : insertRowToPrint(selectedRow);					            			
						            		}
						            		tagSelectedRow(newValue, tbgCollnLetterTableGrid._mtgId, tbgCollnLetterTableGrid.getColumnIndex("incTag"), selectedRow.divCtrId);						            		
					 			    	}
						            })
								}
				           	],
				resetchange : true,
				rows		: tbgCollnLetter.objCollnLetter
		};
		tbgCollnLetterTableGrid = new MyTableGrid(tbgCollnLetterTableModel);
		tbgCollnLetterTableGrid.pager = tbgCollnLetter.objCollnLetterTableGrid;
		tbgCollnLetterTableGrid.render('reprintCollnLetterTGDiv');
		tbgCollnLetterTableGrid.afterRender = function(){
			tbgCollnLetter.objCollnLetter = tbgCollnLetterTableGrid.geniisysRows;
			//initialTotalAmtDue3 = formatCurrency(tbgCollnLetterTableGrid.geniisysRows[0].totalAmtDue);
			//$("txtAgingListAllTGSum").value = initialTotalAmtDue3;
		};
	} catch(e){
		showErrorMessage("collnLetterList", e);
	}
		
	function insertRowToPrint(row) {
		var myRows = isSelectedAll ? allRowsToPrint : rowsToPrint;
		var exists = false;
		
		for(var i=0; i<myRows.length; i++) {
			if(row.billNo != null && row.billNo == myRows[i].billNo){
				exists = true;
				break;
			}
		}
		if(!exists) {
			isSelectedAll ? allRowsToPrint.push(row) : rowsToPrint.push(row);
			//computeTotalForRowsToPrint();
		}
	}
	
	function removeRowToPrint(row) {
		var myRows = isSelectedAll ? allRowsToPrint : rowsToPrint;
		for(var i=0; i<myRows.length; i++) {
			if(row.billNo != null && row.billNo == myRows[i].billNo){
				isSelectedAll ? allRowsToPrint.splice(i,1) : rowsToPrint.splice(i,1);
			}
		}
		//computeTotalForRowsToPrint();
	}
	
	//checks/unchecks checkbox 'P' in the tablegrid
	function tagSelectedRow(isTagged, mtgId, x, y){
		$('mtgInput' + mtgId + '_' + x + ',' + y).checked = isTagged;
		isTagged ? $('mtgIC'+ mtgId + '_' + x + ',' + y).addClassName('modifiedCell') : $('mtgIC'+ mtgId + '_' + x + ',' + y).removeClassName('modifiedCell');
		tbgCollnLetterTableGrid.modifiedRows = [];
	}
	
	function computeTotalForRowsToPrint(){		
		var tempTotal = parseFloat(0);
		var myRows = isSelectedAll ? allRowsToPrint : rowsToPrint;
		
		for(var i=0; i<myRows.length; i++) {
			tempTotal += parseFloat(myRows[i].balanceAmtDue);			
		}
		totalAmtForRowsToPrint = tempTotal;
		//$("txtAgingListAllTGSum").value = formatCurrency(totalAmtForRowsToPrint3);
	}
	
	function printParamReports(isReportAvailable, obj){
		var proceedToPrint = true;
		if (checkAllRequiredFieldsInDiv("printDiv")) {
			var noOfCopies = parseInt($F("txtNoOfCopies"));
			
			if(noOfCopies < 1){
				noOfCopies = 1;
				$("txtNoOfCopies").value = "1";
			}
			var fileType = "";

			if ($("rdoPdf").disabled == false
					&& $("rdoExcel").disabled == false) {
				fileType = $("rdoPdf").checked ? "PDF" : "XLS";
			}
			if(!isReportAvailable){
				proceedToPrint = false;
				showMessageBox(objCommonMessage.UNAVAILABLE_REPORT, "I"); 
			}
			
			if(proceedToPrint){
				var reports = [];
				for(var i=0; i<obj.length; i++){
					var content = contextPath
								+ "/CreditAndCollectionReportPrintController?action=printReport"
								+ "&noOfCopies=" 	+ noOfCopies
								+ "&printerName=" 	+ $F("selPrinter") 
								+ "&destination="   + $F("selDestination") 
								+ "&reportId=" 		+ obj[i].reportId
								+ "&reportTitle=" 	+ obj[i].reportTitle 
								+ "&fileType="		+ fileType
								+ "&issCd="			+ obj[i].issCd
								+ "&premSeqNo="		+ obj[i].premSeqNo
								+ "&instNo="		+ obj[i].instNo
								+ "&collLetNo="		+ obj[i].collLetNo;
					
					reports.push({reportUrl : content, reportTitle : obj[i].reportTitle});
					printGenericReport2(content);
					
					if (i == obj.length-1){
						if ("screen" == $F("selDestination")){
							showMultiPdfReport(reports); 
						}
					}
				}
			} //end if report is already existing			
		}
	}
	
	function populateParametersA(repList){
		var reps = [];
		for(var i=0; i<repList.length; i++){
			//msg = msg + "billNo: " + repList[i].issCd + "-" + repList[i].premSeqNo + "-" +repList[i].instNo + " \tcollLetNo: " + repList[i].collLetNo +"\n";
			reps.push({reportId : "GIACR410", reportTitle : "Collection Reports :  Statement Of Accounts", 
					   issCd : repList[i].issCd, premSeqNo : repList[i].premSeqNo, instNo : repList[i].instNo, collLetNo : repList[i].collLetNo});
		}
		
		showGenericPrintDialog("Print", function(){printParamReports(false, reps);}, "", true);
	}
	
	function populateParametersC(repList){
		var reps = [];
		showGenericPrintDialog("Print", function(){printParamReports(false, reps);}, "", true);
		// if report is already available, change the first parameter of printParamReports to true
	}
	
	function populateParametersE(repList){
		var reps = [];
		showGenericPrintDialog("Print", function(){printParamReports(false, reps);}, "", true);
	}
	
	function populateParametersNIA(repList){
		var reps = [];
		for(var i=0; i<repList.length; i++){
			reps.push({reportId : "GIACR410", reportTitle : "Collection Reports :  Statement Of Accounts", 
					   issCd : repList[i].issCd, premSeqNo : repList[i].premSeqNo, instNo : repList[i].instNo, collLetNo : repList[i].collLetNo});
			
			if(repList[i].collLetNo == 1){
				reps.push({reportId : "GIACR410A", reportTitle : "Collection Reports :  Statement Of Accounts", 
					   issCd : repList[i].issCd, premSeqNo : repList[i].premSeqNo, instNo : repList[i].instNo, collLetNo : repList[i].collLetNo});
			} else if(repList[i].collLetNo == 2){
				reps.push({reportId : "GIACR410B", reportTitle : "Collection Reports :  Statement Of Accounts", 
					   issCd : repList[i].issCd, premSeqNo : repList[i].premSeqNo, instNo : repList[i].instNo, collLetNo : repList[i].collLetNo});
			} else if(repList[i].collLetNo == 3){
				reps.push({reportId : "GIACR410C", reportTitle : "Collection Reports :  Statement Of Accounts", 
					   issCd : repList[i].issCd, premSeqNo : repList[i].premSeqNo, instNo : repList[i].instNo, collLetNo : repList[i].collLetNo});
			}
		}
		showGenericPrintDialog("Print", function(){printParamReportsNIA(true, reps);}, "", true);
	}
	/* PCI ADDED BY MarkS SR5873 11.25.2016 */
	function populateParametersPCI(repList){
		var reps = [];
		for(var i=0; i<repList.length; i++){
			//msg = msg + "billNo: " + repList[i].issCd + "-" + repList[i].premSeqNo + "-" +repList[i].instNo + " \tcollLetNo: " + repList[i].collLetNo +"\n";
			reps.push({reportId : "GIACR410", reportTitle : "Collection Reports :  Statement Of Accounts", 
					   issCd : repList[i].issCd, premSeqNo : repList[i].premSeqNo, instNo : repList[i].instNo, collLetNo : repList[i].collLetNo});
		}
		
		showGenericPrintDialog("Print", function(){printParamReports(true, reps);}, "", true);
	}
	
	$("btnReprintCLSelectAll").observe("click", function(){
		$("btnReprintCLSelectAll").value = isSelectedAll ? "Select All" : "Unselect All";
		isSelectedAll = isSelectedAll ? false : true;	
		
		if(isSelectedAll){
			allRowsToPrint = [];
			rowsToPrint = [];
			try {
				new Ajax.Request(contextPath+"/GIACCreditAndCollectionReportsController?action=getCollnLetterListAll", {
					method: "POST",	
					parameters: {
						intmOrAssdNo : objSOA.prevParams.intmOrAssdNo, //nvl(objSOA.prevParams.intmOrAssdNo,0), Kris 04.23.2014 
						viewType	 : objSOA.prevParams.viewType
					},
					asynchronous: false,
					evalScripts: true,
					onComplete: function(response){
						changeTag = 0;
						if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response, null)){
							allRowsToPrint = JSON.parse(response.responseText);
						} else {
							showMessageBox(response.responseText, imgMessage.ERROR);
						} 
					}
				});	
			}catch(e){
				showErrorMessage("btnFilterBySelectAll", e);
			}
		} else {
			allRowsToPrint = [];
			rowsToPrint = [];
		}
		//$("txtAgingListAllTGSum").value = initialTotalAmtDue3;
		
		// update the checkboxes in the table grid
		var rows = tbgCollnLetter.objCollnLetter;
		for(var y=0; y<rows.length; y++){
			tagSelectedRow(isSelectedAll, tbgCollnLetterTableGrid._mtgId, tbgCollnLetterTableGrid.getColumnIndex("incTag"), y);
		}
		for(var x=0; x<allRowsToPrint.length; x++){
			allRowsToPrint[x].incTag = isSelectedAll ? "Y" : "N";
		}
	});
		
	$("btnReprintCLPrint").observe("click", function(){
		objSOA.currentPage = "reprintCollectionLetter";
		if(allRowsToPrint.length == 0 && rowsToPrint.length == 0){ //!isSelectedAll2 && && selectedIndex2 == -1
			showMessageBox("Please select an item to print.", "I");			
		} else {
			if(objSOA.paramCollLetClient == "FGI" || objSOA.paramCollLetClient == "COV" || objSOA.paramCollLetClient == "CPI"){
				validateBeforePrint(populateParametersA, isSelectedAll, allRowsToPrint, rowsToPrint);				
			} else if(objSOA.paramCollLetClient == "AUI"){
				validateBeforePrint(populateParametersC, isSelectedAll, allRowsToPrint, rowsToPrint);
			} else if(objSOA.paramCollLetClient == "MET"){
				validateBeforePrint(populateParametersE, isSelectedAll, allRowsToPrint, rowsToPrint);
			} else if(objSOA.paramCollLetClient == "NIA"){
				validateBeforePrint(populateParametersNIA, isSelectedAll, allRowsToPrint, rowsToPrint);
			} else if(objSOA.paramCollLetClient == "PCI"){ // PCI ADDED BY MarkS SR5873 11.25.2016
				validateBeforePrint(populateParametersNIA, isSelectedAll, allRowsToPrint, rowsToPrint);
			} 
		}
	});
	
	$("btnReprintCLReturn").observe("click", function(){
		objSOA.prevParams.prevPage = "reprintCollectionLetter";
		showSOAMainPage();
	});
	
	function printParamReportsNIA(isReportAvailable, obj){
		var proceedToPrint = true;
		if (checkAllRequiredFieldsInDiv("printDiv")) {
			var noOfCopies = parseInt($F("txtNoOfCopies"));
			
			if(noOfCopies < 1){
				noOfCopies = 1;
				$("txtNoOfCopies").value = "1";
			}
			var fileType = "";

			if ($("rdoPdf").disabled == false
					/* && $("rdoExcel").disabled == false */) {
				//fileType = $("rdoPdf").checked ? "PDF" : "XLS";
				fileType = "PDF"; // please revise when csv is available - andrew
			}
			if(!isReportAvailable){
				proceedToPrint = false;
				showMessageBox(objCommonMessage.UNAVAILABLE_REPORT, "I"); 
			}
			if(proceedToPrint){
				var reports = [];
				for(var i=0; i<obj.length; i++){
					var content = contextPath
								+ "/CreditAndCollectionReportPrintController?action=printReport"
								+ "&noOfCopies=" 	+ noOfCopies
								+ "&printerName=" 	+ $F("selPrinter") 
								+ "&destination="   + $F("selDestination") 
								+ "&reportId=" 		+ obj[i].reportId
								+ "&reportTitle=" 	+ obj[i].reportTitle 
								+ "&fileType="		+ fileType
								+ "&issCd="			+ obj[i].issCd
								+ "&premSeqNo="		+ obj[i].premSeqNo
								+ "&instNo="		+ obj[i].instNo
								+ "&collLetNo="		+ obj[i].collLetNo
								+ "&viewType="      + objSOA.prevParams.viewType;
					
					reports.push({reportUrl : content, reportTitle : obj[i].reportTitle});
					printGenericReport2(content);
					
					if (i == obj.length-1){
						if ("screen" == $F("selDestination")){
							showMultiPdfReport(reports); 
						}
					}
				}
			} //end if report is already existing			
		}
		
	}
</script>