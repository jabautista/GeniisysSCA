<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
    <%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div >
	<div style="margin-top: 5px; width: 99.5%;" class="sectionDiv">
		<div id="billInvoiceListingDiv" style="height: 250px; width: 96%; margin: 10px; margin-top: 10px; margin-bottom: 5px;"></div>
	</div>
	<div id="divB"  class="buttonsDiv" style="margin-top: 10px; margin-bottom: 0px;">
		<input type="button" id="btnDcOk" class="button" value="Ok" style="width: 80px;" />
		<input type="button" id="btnDcCancel" class="button" value="Cancel" style="width: 80px;" />
	</div>
</div>
<script type="text/JavaScript">
	objAC.objInvoiceListingTableGrid = JSON.parse('${packInvoicesTG}');
	objAC.objInvoiceListing = objAC.objInvoiceListingTableGrid.rows || [];
	objAC.selectedObjsInInvoiceLOV = [];
	var selectedIndex = null;
	var selectedRec = null;
	var dueTag = objGIACS007.checkDue; //$("checkDue").checked == true ? 'Y' : 'N'; // SR-20000 : shan 08.10.2015
	var balAmtDue;
	var recordValidated;
	
	invoiceSelectedInvoiceRows = new Array();
	var searchTableModel = {
			url: contextPath
			+ "/GIACDirectPremCollnsController?action=getPackInvoices"
			+ "&lineCd=" + objGIACS007.lineCd //$F("polLineCd")		// SR-20000 : shan 08.10.2015
			+ "&sublineCd=" + objGIACS007.sublineCd //$F("polSublineCd")	// SR-20000 : shan 08.10.2015
			+ "&issCd=" + objGIACS007.issCd //$F("polIssCd")	// SR-20000 : shan 08.10.2015
			+ "&issYear=" + objGIACS007.issYear //$F("polIssYy")	// SR-20000 : shan 08.10.2015
			+ "&polSeqNo=" + objGIACS007.polSeqNo //$F("policySeqNo")	// SR-20000 : shan 08.10.2015
			+ "&renewNo=" + objGIACS007.renewNo //$F("polRenewNo")	// SR-20000 : shan 08.10.2015
			+ "&dueTag="  + dueTag
			+ "&ajax=1&refresh=1",
		options : {
			title: '',
			pager : {}, 
			hideColumnChildTitle: true,
			toolbar : {
				elements : [ MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
				onRefresh : function() {
				},
				onFilter : function() {
				}
			},
			onCellFocus: function (element, value, x, y, id) {
				selectedIndex = y;
				if(element.readAttribute("type") != "checkbox"){		
					selectedRec = searchTableGrid.geniisysRows[y];
				}
			},
			onRemoveRowFocus: function (element, value, x, y, id) {
				selectedIndex = null;
				selectedRec = null;
			},
			rowPostQuery: function (y) {	// SR-20000 : shan 08.25.2015
				checkPreviouslySelected(searchTableGrid.getRow(y),y);
				disableAddedBill(searchTableGrid.getRow(y),y);
			}
		},
		columnModel: [
		              	{	id: 'recordStatus',
			            	title: '',
			            	width: '0',
			            	sortable: false,
			            	editable: false,
			            	visible: false
		              	},              	
		              	{
		    				id: 'divCtrId',
		    				width: '0',
		    				visible: false 
		    			},
		              	{	id: 'insTag',
		              		title : '',
			              	width: '22',
			              	hideSelectAllBox: true,
			              	editable: true,
			              	sortable: false,
			              	visible: true,
			              	editor: new MyTableGrid.CellCheckbox({
			              			        onClick: function(value, checked) {
			              			        	if (checked){
				              			        	recordValidated = selectedRec;
				              			        	premSeqNo = searchTableGrid.getValueAt(searchTableGrid.getColumnIndex("premSeqNo"),selectedIndex);	
				              			        	issCd = searchTableGrid.getValueAt(searchTableGrid.getColumnIndex("issCd"),selectedIndex);	
				              			        	balAmtDue = searchTableGrid.getValueAt(searchTableGrid.getColumnIndex("balAmtDue"),selectedIndex);	
				              			        	searchTableGrid.setValueAt(balAmtDue, searchTableGrid.getColumnIndex('collAmt'), searchTableGrid.getCurrentPosition()[1]);
				              			        	validateBillNo(premSeqNo, issCd, null);
			              			        	}
			              			        	
			              			        }
			              			    })
		              	},
		              	{
        					id : 'lineCd',							
        					width : '58px',	
			           		filterOption: true,
			           		title: "Line"
        				},
        				{
        					id : 'sublineCd',							
        					width : '58px',	
			           		filterOption: true,
			           		title: "Subline"
        				},
        				{
        					id : 'issCd',							
        					width : '58px',		
			           		filterOption: true,
			           		title: "IssCd"
        				},
        				{
        					id : 'premSeqNo',							
        					width : '83px',	
			              	align: 'right',	
			           		filterOption: true,
			           		title: "PremSeq"
        				},
        				{
        					id : 'instNo',							
        					width : '58px',	
			              	align: 'right',
			           		filterOption: true,
			           		title: "Inst"
        				},
		              	{	id: 'balAmtDue',
			              	width: '110px' ,
			              	title: 'Amount',
			              	align: 'right',
			              	type: 'number',
			              	filterOption: true,
							geniisysClass : 'money',
			              	titleAlign: 'right',
			              	filterOptionType: 'number'
		              	},   
		              	{
		    				id: 'tranType',
		    				width: '0',
		    				visible: false 
		    			},  
		              	{
		    				id: 'policyNo',
		    				width: '0',
		    				visible: false 
		    			},              	
		              	{
		    				id: 'policyId',
		    				width: '0',
		    				visible: false 
		    			},              	
		              	{
		    				id: 'lineCd',
		    				width: '0',
		    				visible: false 
		    			},              	
		              	{
		    				id: 'sublineCd',
		    				width: '0',
		    				visible: false 
		    			},              	
		              	{
		    				id: 'issCd',
		    				width: '0',
		    				visible: false 
		    			},              	
		              	{
		    				id: 'issueYear',
		    				width: '0',
		    				visible: false 
		    			},              	
		              	{
		    				id: 'polSeqNo',
		    				width: '0',
		    				visible: false 
		    			},              	
		              	{
		    				id: 'endtSeqNo',
		    				width: '0',
		    				visible: false 
		    			},              	
		              	{
		    				id: 'endtType',
		    				width: '0',
		    				visible: false 
		    			},              	
		              	{
		    				id: 'polFlag',
		    				width: '0',
		    				visible: false 
		    			},              	
		              	{
		    				id: 'assdNo',
		    				width: '0',
		    				visible: false 
		    			},              	
		              	{
		    				id: 'assdName',
		    				width: '0',
		    				visible: false 
		    			},
		    			{
		    				id: 'collAmt',
		    				width: '0',
		    				visible: false 
		    			},
		    			{
		    				id: 'premAmt',
		    				width: '0',
		    				visible: false 
		    			},
		    			{
		    				id: 'taxAmt',
		    				width: '0',
		    				visible: false 
		    			},
		              	{	id: 'otherInfo',
			              	width: '0',
			              	visible: false
		              	},
		              	{	id: 'forCurrAmt',
			              	width: '0',
			              	visible: false
		              	},
		              	{	id: 'fundCd',
			              	width: '0',
			              	visible: false
		              	},
		              	{	id: 'sumTaxTotal',
			              	width: '0',
			              	visible: false
		              	},
		              	{	id: 'paramPremAmt',
			              	width: '0',
			              	visible: false
		              	},
		              	{	id: 'prevPremAmt',
			              	width: '0',
			              	visible: false
		              	},
		              	{	id: 'prevTaxAmt',
			              	width: '0',
			              	visible: false
		              	},
		              	{	id: 'origCollAmt',
			              	width: '0',
			              	visible: false
		              	},
		              	{	id: 'origPremAmt',
			              	width: '0',
			              	visible: false
		              	},
		              	{	id: 'origTaxAmt',
			              	width: '0',
			              	visible: false
		              	},
		              	{	id: 'premVatable',
			              	width: '0',
			              	visible: false
		              	},
		              	{	id: 'premZeroRated',
			              	width: '0',
			              	visible: false
		              	},
		              	{	id: 'premVatExempt',
			              	width: '0',
			              	visible: false
		              	},
		              	{	id: 'currCd',	// SR-20000 : shan 08.11.2015
			              	width: '0',
			              	visible: false
		              	},
		              	{	id: 'currRt',	// SR-20000 : shan 08.11.2015
			              	width: '0',
			              	visible: false
		              	}
			         ],
		resetChangeTag: true,
		rows: objAC.objInvoiceListingTableGrid.rows,
		requiredColumns: ''
	};
	
	searchTableGrid = new MyTableGrid(searchTableModel);
	searchTableGrid.pager = objAC.objInvoiceListingTableGrid;
	searchTableGrid.render('billInvoiceListingDiv');
	
	// copied from searchInvoiceInstNo.jsp ::: SR-20000 : shan 08.25.2015
	function disableAddedBill(bill,y) {	
		var invoiceRowId = objACGlobal.gaccTranId + 
		bill.issCd + bill.premSeqNo +
		bill.instNo;
		if(nvl(getObjectFromArrayOfObjects(objAC.objGdpc, "gaccTranId issCd premSeqNo instNo", invoiceRowId), "") != ""){
			$("mtgInput4_2," + y).checked = true;
			$("mtgInput4_2," + y).disabled = true;
		} 
	}    
	
	function checkPreviouslySelected(bill, y) {
		var invoiceRowId = bill.issCd + bill.premSeqNo + bill.instNo; 
		if (getObjectFromArrayOfObjects(invoiceSelectedInvoiceRows, "issCd premSeqNo instNo",
				invoiceRowId)) {
			$("mtgInput2_2," + y).checked = true;
		}
	}
	
	// end, copied from searchInvoiceInstNo.jsp ::: SR-20000
	
	function validateBillNo(premSeqNo, issCd, func) {
		try{
			new Ajax.Request(contextPath+"/GIACDirectPremCollnsController?action=validateBillNo2", {
					evalScripts: true,
					asynchronous: false,
					method: "GET",
					parameters: {
						premSeqNo: premSeqNo,
						issCd :         issCd
					},
					onComplete: function(response) {
						if (checkErrorOnResponse(response)) {
							var result = response.responseText.toQueryParams();
							if(result.msgAlert != 'Ok' && func == "btnOk"){
								showMessageBox(result.msgAlert, "E");
							}else{
								searchTableGrid.setValueAt(result.policyNo, searchTableGrid.getColumnIndex('policyNo'), searchTableGrid.getCurrentPosition()[1]);
								searchTableGrid.setValueAt(result.policyId, searchTableGrid.getColumnIndex('policyId'), searchTableGrid.getCurrentPosition()[1]);
								if(result.lineCd){
									searchTableGrid.setValueAt(result.lineCd, searchTableGrid.getColumnIndex('lineCd'), searchTableGrid.getCurrentPosition()[1]);
								}
								searchTableGrid.setValueAt(result.sublineCd, searchTableGrid.getColumnIndex('sublineCd'), searchTableGrid.getCurrentPosition()[1]);
								searchTableGrid.setValueAt(result.issCd, searchTableGrid.getColumnIndex('issCd'), searchTableGrid.getCurrentPosition()[1]);
								searchTableGrid.setValueAt(result.issueYear, searchTableGrid.getColumnIndex('issueYear'), searchTableGrid.getCurrentPosition()[1]);
								searchTableGrid.setValueAt(result.polSeqNo, searchTableGrid.getColumnIndex('polSeqNo'), searchTableGrid.getCurrentPosition()[1]);
								searchTableGrid.setValueAt(result.endtSeqNo, searchTableGrid.getColumnIndex('endtSeqNo'), searchTableGrid.getCurrentPosition()[1]);
								searchTableGrid.setValueAt(result.endtType, searchTableGrid.getColumnIndex('endtType'), searchTableGrid.getCurrentPosition()[1]);
								searchTableGrid.setValueAt(result.polFlag, searchTableGrid.getColumnIndex('polFlag'), searchTableGrid.getCurrentPosition()[1]);
								searchTableGrid.setValueAt(result.assdNo, searchTableGrid.getColumnIndex('assdNo'), searchTableGrid.getCurrentPosition()[1]);
								searchTableGrid.setValueAt(result.assdName, searchTableGrid.getColumnIndex('assdName'), searchTableGrid.getCurrentPosition()[1]);
								if(balAmtDue > 0){
									searchTableGrid.setValueAt('1', searchTableGrid.getColumnIndex('tranType'), searchTableGrid.getCurrentPosition()[1]);
								}else{
									searchTableGrid.setValueAt('3', searchTableGrid.getColumnIndex('tranType'), searchTableGrid.getCurrentPosition()[1]);
								}
								premSeqNo = searchTableGrid.getValueAt(searchTableGrid.getColumnIndex("premSeqNo"),searchTableGrid.getCurrentPosition()[1]);	
          			        	instNo = searchTableGrid.getValueAt(searchTableGrid.getColumnIndex("instNo"),searchTableGrid.getCurrentPosition()[1]);	
          			        	issCd = searchTableGrid.getValueAt(searchTableGrid.getColumnIndex("issCd"),searchTableGrid.getCurrentPosition()[1]);	
          			        	tranType = searchTableGrid.getValueAt(searchTableGrid.getColumnIndex("tranType"),searchTableGrid.getCurrentPosition()[1]);	

          			        	validatePremSeqNoGIACS007(tranType, issCd, premSeqNo,
										function() {	
										recordValidated = validateGIACS007Record2(premSeqNo,
  													instNo, 
  													null,
  													issCd, tranType, recordValidated, selectedIndex);
											// SR-20000 : shan 08.11.2015
											searchTableGrid.setValueAt(recordValidated.currCd, searchTableGrid.getColumnIndex("currCd"),selectedIndex);
											searchTableGrid.setValueAt(recordValidated.currRt, searchTableGrid.getColumnIndex("currRt"),selectedIndex);
											searchTableGrid.setValueAt(recordValidated.forCurrAmt, searchTableGrid.getColumnIndex("forCurrAmt"),selectedIndex);
	              							searchTableGrid.setValueAt(recordValidated, searchTableGrid.getColumnIndex('otherInfo'), selectedIndex);
											// SR-20000 : shan 08.11.2015
										}, function() {
											searchTableGrid.setValueAt(false,searchTableGrid.getColumnIndex('insTag'), selectedIndex);	// SR-20000 : shan 08.11.2015
										});
      							searchTableGrid.keys.releaseKeys();
							}
						} else {
							showMessageBox(response.responseText, imgMessage.ERROR);
						}
					}
				});
		}catch(e) {
			showErrorMessage("validateBillNo", e);
		}
	}
	
	function computeTotalAmounts(){
		try{
			var totalCollAmt = 0;
			var totalPremAmt = 0;
			var totalTaxAmt = 0;
			for(var i = 0; i < objAC.objGdpc.length; i++){
				if(objAC.objGdpc[i].recordStatus != -1){
					totalCollAmt += parseFloat(objAC.objGdpc[i].collAmt);
					totalPremAmt += parseFloat(unformatCurrencyValue(objAC.objGdpc[i].premAmt)); // added unformatCurrencyValue ::: SR-20000 : shan 08.25.2015
					totalTaxAmt += parseFloat(objAC.objGdpc[i].taxAmt);
				}
			}
			$("txtTotalCollAmt").value = formatCurrency(totalCollAmt);
			$("txtTotalPremAmt").value = formatCurrency(totalPremAmt);
			$("txtTotalTaxAmt").value = formatCurrency(totalTaxAmt);
		}catch(e){
			showErrorMessage("computeTotalAmounts",e);
		}
	}
	
	function getIncTagForAdvPremPayts(issCd, premSeqNo){
		try {
			new Ajax.Request(contextPath+"/GIACDirectPremCollnsController", {
				method: "GET",
				parameters: {
					action: "getIncTagForAdvPremPayts",
					tranId: objACGlobal.gaccTranId,
					premSeqNo: premSeqNo,
					issCd: issCd
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response) {
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
						objAC.currentRecord.incTag = nvl(response.responseText, "N") == "Y" ? "Y" : "N";
					}
				}
			});
		} catch(e) {
			showErrorMessage("getIncTagForAdvPremPayts", e);
		}
	}
	
	function addRecordsInPaidList(newRecordsList) {
		try{
			changeTag = 0;
			var objArray = eval('[]');
			for (var index1=0; index1<newRecordsList.length; index1++) {
				
				var newPremCollnRowId = objACGlobal.gaccTranId + 
							newRecordsList[index1].issCd + newRecordsList[index1].premSeqNo +
							newRecordsList[index1].instNo + newRecordsList[index1].tranType;
				
				objAC.currentRecord.incTag = "N";
				getIncTagForAdvPremPayts(newRecordsList[index1].issCd, newRecordsList[index1].premSeqNo);
	
				var rowObj = new Object();
				rowObj = newRecordsList[index1];
				rowObj.gaccTranId = objACGlobal.gaccTranId;
				
				if (getObjectFromArrayOfObjects(objAC.objGdpc, 
								    "gaccTranId issCd premSeqNo instNo tranType",
				    				newPremCollnRowId)==null) {
					rowObj.recordStatus = 0;
					rowObj.maxCollAmt = newRecordsList[index1].collAmt;
					rowObj.balanceAmtDue = 0;
					/* rowObj.taxAmt = 309;
					rowObj.premAmt = 1250; */
					objAC.objGdpc.push(rowObj);
					gdpcTableGrid.addBottomRow(rowObj);
				} else {
					var jsonReplacementRecord = getObjectFromArrayOfObjects(objAC.objGdpc, "gaccTranId issCd premSeqNo instNo tranType",
									newPremCollnRowId);
					rowObj.recordStatus = 2;
					gdpcTableGrid.updateRowAt(rowObj, jsonReplacementRecord.index-1);
				}
			}
			
			computeTotalAmounts();
			gdpcTableGrid.onRemoveRowFocus();
		}catch(e){
			showErrorMessage("addRecordsInPaidList",e);
		}
	}
	
	$("btnDcCancel").observe("click", function(){
		searchTableGrid.keys.removeFocus(searchTableGrid.keys._nCurrentFocus, true);
		searchTableGrid.keys.releaseKeys();
		objGIACS007 = null; // SR-20000 : shan 08.10.2015
		distDtlsOverlay.close();
		delete distDtlsOverlay;
	});
	
	invoiceSelectedInvoiceRows = new Array();
	$("btnDcOk").observe("click", function(){
		try{
			var invoiceModifiedRows = invoiceSelectedInvoiceRows.concat(searchTableGrid.getModifiedRows().filter(function fun(row) { 
				if (row.insTag==true) {
					//validateBillNo(row.premSeqNo, row.issCd, 'btnOk'); // commented ::: SR-20000 : shan 08.25.2015
					if (row.taxAmt == null) row.taxAmt = 0; // SR-20000 : shan 08.25.2015
					return row;
				}
			}));
			if(invoiceModifiedRows != ""){
				addRecordsInPaidList(invoiceModifiedRows);
				objAC.formChanged = 'Y';
				changeTag = 1; // SR-20000 : shan 08.25.2015
			};
			searchTableGrid.keys.removeFocus(searchTableGrid.keys._nCurrentFocus, true);
			searchTableGrid.keys.releaseKeys();
			objGIACS007 = null; // SR-20000 : shan 08.10.2015
			distDtlsOverlay.close();
			delete distDtlsOverlay;
		}catch(e){
			showErrorMessage("btnDcOk",e);
		}
	});
	
</script>