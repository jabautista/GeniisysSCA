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
	
	objAC.objInvoiceListingTableGrid = JSON.parse('${datedCheckTG}');
	objAC.objInvoiceListing = objAC.objInvoiceListingTableGrid.rows || [];
	objAC.selectedObjsInInvoiceLOV = [];
	var selectedIndex = null;
	var selectedRec = null;
	var recordValidated;
	objAC.fromBtnDcOk = null; //added by robert 11.25.2013
	var invoiceModifiedRows = [];
	
	invoiceSelectedInvoiceRows = new Array();
	var searchTableModel = {
			url: contextPath
			+ "/GIACPdcPremCollnController?action=showDatedChecksOverlay"
			+ "&gaccTranId=" + objACGlobal.gaccTranId
			+ "&ajax=1&refresh=1",
		options : {
			title: '',
			pager : {}, 
			hideColumnChildTitle: true,
			toolbar : {
				elements : [ MyTableGrid.REFRESH_BTN],
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
			              			        	recordValidated = selectedRec;
			              			  		    premSeqNo = searchTableGrid.getValueAt(searchTableGrid.getColumnIndex("premSeqNo"),selectedIndex);	
			              			        	issCd = searchTableGrid.getValueAt(searchTableGrid.getColumnIndex("issCd"),selectedIndex);	
			              			        	collAmt = searchTableGrid.getValueAt(searchTableGrid.getColumnIndex("collnAmt"),selectedIndex);	
			              			        	searchTableGrid.setValueAt(collAmt, searchTableGrid.getColumnIndex('collAmt'), searchTableGrid.getCurrentPosition()[1]);
			              			        	objAC.fromBtnDcOk = 'N'; //added by robert 11.25.2013
			              			        	validateBillNo(premSeqNo, issCd, null);
			              			        }
			              			    })
		              	},
		            	{
        					id : 'tranType',				
        					title: "Tran. Type",
        					width : '70',			
        					align: 'right',
        					titleAlign: 'right',
        					sortable : false,
        					editable : false
        				},
		              	{
        					id : 'issCd',				
        					title: "Issue Code",
        					width : '70',				
        					align: 'center',
        					sortable : false,
        					editable : false
        				},
        				{
        					id : 'premSeqNo',	
        					title: "Bill No.",
        					width : '125',
        					sortable : false,
        					editable : false,	
        					align: 'right',
        					renderer : function(value){
        						return lpad(value.toString(), 12, "0");					
        					}
        				},
		              	{	id:	'instNo',
			              	width: '60',
			              	align: "right",
			              	title: "Inst. No.",
			              	sortable : false,
        					renderer : function(value){
        						return lpad(value.toString(), 2, "0");					
        					}
		              	},
		              	{	id: 'collnAmt',
			              	width: '130',
			              	title: "Collection",
			              	align: "right",
			              	type: "number",
							geniisysClass : 'money',
			              	titleAlign: "right",
			              	sortable : false,
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
		              	{	id: 'currCd',
			              	width: '0',
			              	visible: false
		              	},
		              	{	id: 'currRt',
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
	
	function showSearchInvoice(issCd, premSeqNo, tranType){
		if (tranType == "2" || tranType == "4"){
			objAC.paytRefNoVis = "Y";
		}else{
			objAC.paytRefNoVis = "N";
		}
		datedChksOverlay.close();
		delete datedChksOverlay;
		distDtlsOverlay = Overlay.show(contextPath+"/GIACDirectPremCollnsController", {
			asynchronous : true,
			urlContent: true,
			draggable: true,
			urlParameters: {
				action     		: "showInvoiceListingTg",
				issCd    		: issCd,
				premSeqNo		: premSeqNo,
				tranType		: tranType,
				instNo			: null
			},
		    title: "Installments",
		    height: 490,
		    width: 820
		});
	}
	
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
								searchTableGrid.setValueAt(result.lineCd, searchTableGrid.getColumnIndex('lineCd'), searchTableGrid.getCurrentPosition()[1]);
								searchTableGrid.setValueAt(result.sublineCd, searchTableGrid.getColumnIndex('sublineCd'), searchTableGrid.getCurrentPosition()[1]);
								searchTableGrid.setValueAt(result.issCd, searchTableGrid.getColumnIndex('issCd'), searchTableGrid.getCurrentPosition()[1]);
								searchTableGrid.setValueAt(result.issueYear, searchTableGrid.getColumnIndex('issueYear'), searchTableGrid.getCurrentPosition()[1]);
								searchTableGrid.setValueAt(result.polSeqNo, searchTableGrid.getColumnIndex('polSeqNo'), searchTableGrid.getCurrentPosition()[1]);
								searchTableGrid.setValueAt(result.endtSeqNo, searchTableGrid.getColumnIndex('endtSeqNo'), searchTableGrid.getCurrentPosition()[1]);
								searchTableGrid.setValueAt(result.endtType, searchTableGrid.getColumnIndex('endtType'), searchTableGrid.getCurrentPosition()[1]);
								searchTableGrid.setValueAt(result.polFlag, searchTableGrid.getColumnIndex('polFlag'), searchTableGrid.getCurrentPosition()[1]);
								searchTableGrid.setValueAt(result.assdNo, searchTableGrid.getColumnIndex('assdNo'), searchTableGrid.getCurrentPosition()[1]);
								searchTableGrid.setValueAt(result.assdName, searchTableGrid.getColumnIndex('assdName'), searchTableGrid.getCurrentPosition()[1]);
								if(parseInt(selectedRec.collnAmt) > 0){
									searchTableGrid.setValueAt('1', searchTableGrid.getColumnIndex('tranType'), searchTableGrid.getCurrentPosition()[1]);
								}else{
									searchTableGrid.setValueAt('3', searchTableGrid.getColumnIndex('tranType'), searchTableGrid.getCurrentPosition()[1]);
								}

								inst = getNumberOfInst(selectedRec.issCd, selectedRec.premSeqNo, selectedRec.tranType);
								// bonok :: 4.8.2016 :: UCPB SR 21681
          			        	/* if(parseInt(inst) > parseInt(1)){ 
          			        		$("tranType").value = selectedRec.tranType;
          			        		$("tranSource").value = selectedRec.issCd;
          			        		showSearchInvoice(selectedRec.issCd, selectedRec.premSeqNo, selectedRec.tranType);
          			        	} */
          			        	premSeqNo = searchTableGrid.getValueAt(searchTableGrid.getColumnIndex("premSeqNo"),searchTableGrid.getCurrentPosition()[1]);	
          			        	instNo = searchTableGrid.getValueAt(searchTableGrid.getColumnIndex("instNo"),searchTableGrid.getCurrentPosition()[1]);	
          			        	issCd = searchTableGrid.getValueAt(searchTableGrid.getColumnIndex("issCd"),searchTableGrid.getCurrentPosition()[1]);	
          			        	tranType = searchTableGrid.getValueAt(searchTableGrid.getColumnIndex("tranType"),searchTableGrid.getCurrentPosition()[1]);	
          			        	objAC.currentRecord.issCd = issCd; //added by robert 11.25.2013
          						objAC.currentRecord.premSeqNo = premSeqNo; //added by robert 11.25.2013
          						objAC.currentRecord.instNo = instNo; //added by robert 11.25.2013
          			        	validatePremSeqNoGIACS007(tranType, issCd, premSeqNo,
										function() {	
										recordValidated = validateGIACS007Record2(premSeqNo,
  													instNo, 
  													null,
  													issCd, tranType, recordValidated, selectedIndex);
										searchTableGrid.setValueAt(recordValidated.forCurrAmt, searchTableGrid.getColumnIndex('forCurrAmt'), searchTableGrid.getCurrentPosition()[1]);  //added by Halley 09.16.2013
										}, function() {
											searchTableGrid.setValueAt(false,searchTableGrid.getColumnIndex('insTag'), invoiceIndex);
											
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
		var totalCollAmt = 0;
		var totalPremAmt = 0;
		var totalTaxAmt = 0;
		
		for(var i = 0; i < objAC.objGdpc.length; i++){
			if(objAC.objGdpc[i].recordStatus != -1){
				totalCollAmt += parseFloat(objAC.objGdpc[i].collAmt);
				totalPremAmt += parseFloat(objAC.objGdpc[i].premAmt);
				totalTaxAmt += parseFloat(objAC.objGdpc[i].taxAmt);
			}
		}
		$("txtTotalCollAmt").value = formatCurrency(totalCollAmt);
		$("txtTotalPremAmt").value = formatCurrency(totalPremAmt);
		$("txtTotalTaxAmt").value = formatCurrency(totalTaxAmt);
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
	
	function getNumberOfInst(issCd, premSeqNo,tranType){
		try {
			var inst;
			new Ajax.Request(contextPath+"/GIACDirectPremCollnsController", {
				method: "GET",
				parameters: {
					action: "getNumberOfInst",
					premSeqNo: premSeqNo,
					issCd: issCd,
					tranType : tranType
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response) {
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
						inst =  response.responseText;
					}
				}
			});
			return inst;
		} catch(e) {
			showErrorMessage("getIncTagForAdvPremPayts", e);
		}
	}
	
	function addRecordsInPaidList(newRecordsList) {
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
			rowObj.paramPremAmt = nvl(rowObj.paramPremAmt, null) == null ? rowObj.premAmt : rowObj.paramPremAmt; // bonok :: 3.17.2016 :: UCPB SR 21679
			
			if (getObjectFromArrayOfObjects(objAC.objGdpc, 
							    "gaccTranId issCd premSeqNo instNo tranType",
			    				newPremCollnRowId)==null) {
				rowObj.recordStatus = 0;
				rowObj.maxCollAmt = newRecordsList[index1].collAmt;
				rowObj.balanceAmtDue = 0;
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
	}
	
	$("btnDcCancel").observe("click", function(){
		searchTableGrid.keys.removeFocus(searchTableGrid.keys._nCurrentFocus, true);
		searchTableGrid.keys.releaseKeys();
		datedChksOverlay.close();
		delete datedChksOverlay;
	});
	
	function getTaxType1(taxType) {
		try {
			new Ajax.Request(contextPath+"/GIACDirectPremCollnsController?action=taxDefaultValueType", {
					method : "GET",
					parameters : {
						tranId : objACGlobal.gaccTranId,
						tranType : taxType,
						tranSource : invoiceModifiedRows.issCd,
						premSeqNo : invoiceModifiedRows.premSeqNo,
						instNo : invoiceModifiedRows.instNo,
						fundCd : objACGlobal.fundCd,
						taxAmt : invoiceModifiedRows.taxAmt,//objAC.currentRecord.taxAmt,
						paramPremAmt : invoiceModifiedRows.paramPremAmt,
						premAmt : invoiceModifiedRows.premAmt,
						collnAmt : invoiceModifiedRows.collnAmt,
						premVatExempt: invoiceModifiedRows.premVatExempt, //parameters edited 09.07.2012
						revTranId: '', //test
						taxType : taxType
					},
					evalScripts : true,
					asynchronous : false,
					onComplete : function(response) {
						if (checkErrorOnResponse(response)) {
							var result = response.responseText.toQueryParams();
							invoiceModifiedRows = result;
							
							objAC.sumGtaxAmt = result.taxAmt;
							invoiceModifiedRows.premAmt = formatCurrency(result.premAmt);
							invoiceModifiedRows.taxAmt = formatCurrency(result.taxAmt);
							invoiceModifiedRows.collnAmt = formatCurrency(result.collnAmt);
							invoiceModifiedRows.collAmt = invoiceModifiedRows.collnAmt;
							
							if (invoiceModifiedRows.otherInfo) {
								invoiceModifiedRows.forCurrAmt = result.collnAmt
										* objAC.currentRecord.otherInfo.currRt;
							} else {
								invoiceModifiedRows.forCurrAmt = unformatCurrencyValue(result.collnAmt)
										* parseFloat(selectedRec.currRt); //modified by: Halley 09.02.2013
							}
							invoiceModifiedRows.premVatExempt = result.premVatExempt; 
						}
					}
				});
		} catch (e) {
			showMessageBox(e.message);
		}
	}
	
	function withTaxAllocation() {
		try{
			if (objAC.taxPriorityFlag == null) { 
					showMessageBox(
							"There is no existing PREM_TAX_PRIORITY parameter in GIAC_PARAMETERS table.",
							imgMessage.WARNING);
					return;
				}
				invoiceModifiedRows.collAmt = invoiceModifiedRows.collnAmt;
				invoiceModifiedRows.paramPremAmt = invoiceModifiedRows.premAmt;
				if (objAC.taxPriorityFlag == 'P') {
					if (Math.abs(invoiceModifiedRows.collnAmt) <= Math.abs(invoiceModifiedRows.premAmt)) {
						invoiceModifiedRows.premAmt = invoiceModifiedRows.collnAmt;
						invoiceModifiedRows.taxAmt = formatCurrency(0);
					} else {
						invoiceModifiedRows.taxAmt = formatCurrency(invoiceModifiedRows.collnAmt
								- parseFloat(invoiceModifiedRows.premAmt));
					}
				} else {
					if (Math.abs(invoiceModifiedRows.collnAmt) <= Math.abs(invoiceModifiedRows.taxAmt)) {
						invoiceModifiedRows.premAmt = formatCurrency(0);
						invoiceModifiedRows.taxAmt = invoiceModifiedRows.collnAmt;
					} else {
						invoiceModifiedRows.premAmt = invoiceModifiedRows.collnAmt - parseFloat(invoiceModifiedRows.taxAmt);
					}
				}
				
				/*  if (invoiceModifiedRows.premVatExempt.otherInfo) {
					 invoiceModifiedRows.premVatExempt.forCurrAmt = unformatCurrencyValue($("premCollectionAmt").value)
							/ parseFloat(objAC.currentRecord.otherInfo.currRt);
				} else {
					objAC.currentRecord.forCurrAmt = unformatCurrencyValue($("premCollectionAmt").value)
							/ parseFloat(objAC.currentRecord.currRt);
				} */
				invoiceModifiedRows.prevPremAmt = invoiceModifiedRows.premAmt;
				invoiceModifiedRows.prevTaxAmt = invoiceModifiedRows.taxAmt;
				// Call procedure for the tax breakdown
				if (Math.abs(invoiceModifiedRows.taxAmt) == 0) {
					invoiceModifiedRows.premAmt = invoiceModifiedRows.collnAmt;
					invoiceModifiedRows.taxAmt = formatCurrency(0);
					
					if(invoiceModifiedRows.premZeroRated != 0) {
						invoiceModifiedRows.premZeroRated = invoiceModifiedRows.premAmt;
					} else if (invoiceModifiedRows.premVatExempt != 0){
						invoiceModifiedRows.premVatExempt = invoiceModifiedRows.premAmt;
					}
					
					if(invoiceModifiedRows.premZeroRated == 0) {
						if((invoiceModifiedRows.premAmt - invoiceModifiedRows.premVatExempt) == 0) {
							invoiceModifiedRows.premVatable = 0;
						} else if((invoiceModifiedRows.premAmt - invoiceModifiedRows.premVatExempt) > 0) {
							invoiceModifiedRows.premVatable = invoiceModifiedRows.premAmt - invoiceModifiedRows.premVatExempt;
						}
					} else {
						invoiceModifiedRows.premZeroRated = invoiceModifiedRows.premAmt;
						invoiceModifiedRows.premVatable = 0;
						invoiceModifiedRows.premVatExempt = 0;
					}
				} else {
					getTaxType1(invoiceModifiedRows.tranType);
					
					if(invoiceModifiedRows.premZeroRated == 0) {
						if((invoiceModifiedRows.premAmt - invoiceModifiedRows.premVatExempt) == 0) {
							invoiceModifiedRows.premVatable = 0;
						} else if((invoiceModifiedRows.premAmt - invoiceModifiedRows.premVatExempt) > 0) {
							invoiceModifiedRows.premVatable = invoiceModifiedRows.premAmt - invoiceModifiedRows.premVatExempt;
						}
					} else {
						invoiceModifiedRows.premZeroRated = invoiceModifiedRows.premAmt;
						invoiceModifiedRows.premVatable = 0;
						invoiceModifiedRows.premVatExempt = 0;
					}
				}
		}catch(e){
			showErrorMessage("withTaxAllocation",e);
		}
	}
	
	function noTaxAllocation() {
		if (objAC.taxPriorityFlag == null) {
			showMessageBox(
					"There is no existing PREM_TAX_PRIORITY parameter in GIAC_PARAMETERS table.",
					imgMessage.WARNING);
		}
		if (objAC.taxPriorityFlag == 'P') {
			if (Math.abs(invoiceModifiedRows.collnAmt) <= Math.abs(invoiceModifiedRows.premAmt)) {
				invoiceModifiedRows.premAmt = invoiceModifiedRows.collnAmt;
				invoiceModifiedRows.taxAmt = formatCurrency(0);
			} else {
				invoiceModifiedRows.taxAmt = formatCurrency(invoiceModifiedRows.collnAmt
						- parseFloat(invoiceModifiedRows.premAmt));
			}
		} else {
			if (Math.abs(invoiceModifiedRows.collnAmt) <= Math.abs(invoiceModifiedRows.taxAmt)) {
				invoiceModifiedRows.premAmt = formatCurrency(0);
				invoiceModifiedRows.taxAmt = invoiceModifiedRows.collnAmt;
			} else {
				invoiceModifiedRows.premAmt = invoiceModifiedRows.collnAmt - parseFloat(invoiceModifiedRows.taxAmt);
			}
		}
	}
	
	invoiceSelectedInvoiceRows = new Array();
	$("btnDcOk").observe("click", function(){
		var invoiceRows = invoiceSelectedInvoiceRows.concat(searchTableGrid.getModifiedRows().filter(function fun(row) { 
 			if (row.insTag==true) {
				invoiceModifiedRows = row;
				objAC.fromBtnDcOk = 'Y'; //added by robert 11.25.2013
				validateBillNo(row.premSeqNo, row.issCd, 'btnOk');
				if(invoiceModifiedRows.collAmt != invoiceModifiedRows.collnAmt){ //added by robert 04.10.2013
					if (objAC.taxAllocationFlag == "Y") {
						withTaxAllocation(); 
					} else {
						noTaxAllocation(); 
					}
				 	row.taxAmt = invoiceModifiedRows.taxAmt;
					row.premAmt = invoiceModifiedRows.premAmt;
					row.premZeroRated = invoiceModifiedRows.premZeroRated;
					row.premVatable = invoiceModifiedRows.premVatable;
					row.premVatExempt = invoiceModifiedRows.premVatExempt;
				}
				
				return row;
			}
		}));
		if(invoiceRows != ""){
			addRecordsInPaidList(invoiceRows);
			objAC.formChanged = 'Y';
			objAC.btnDcOk = 'Y';
			//objAC.saveDirectPrem(); //removed by robert 11.25.2013
			fireEvent($("btnSaveDirectPrem"), "click"); //added by robert 11.25.2013
		};
		objAC.fromBtnDcOk = 'N'; //added by robert 11.25.2013
		searchTableGrid.keys.removeFocus(searchTableGrid.keys._nCurrentFocus, true);
		searchTableGrid.keys.releaseKeys();
		datedChksOverlay.close();
		delete datedChksOverlay;
	});
	
</script>