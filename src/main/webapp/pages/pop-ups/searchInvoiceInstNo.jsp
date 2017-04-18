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
		<div id="billInvoiceListingDiv" style="height: 330.5px; width: 800px; margin: 10px; margin-top: 10px; margin-bottom: 5px;"></div>
		
		<div style="padding: 10px 4px;">
			<div>
				<div style="float:left; height: 80px;">
					<div style="padding-top: 5px;"><label class="leftAligned" width="30%" style="font-size: 11px;">Policy No. / Endt. No.:</label></div>
					<div style="padding-top: 25px;"><label class="leftAligned" width="30%" style="font-size: 11px;">Assured: </label></div>
					<div style="padding-top: 27px;"><label class="leftAligned" width="30%" style="font-size: 11px;">Intermediary:</label></div>
				</div>
				<div>
					<div>
						<div style="float:left;">
							<input type="text"  style="font-size: 11px; width: 320px; margin-right: 30px; margin-left: 4px;" readOnly="readOnly" id="searchPolicyNo"/>
						</div>
						<div style="float:left;">
							<label class="leftAligned" width="40px" style="font-size: 11px; margin-top: 2px;">Ref. Policy No.: </label>
							<input type="text" id="searchRefPolNo" style="margin-left: 4px; width: 206px;" readOnly="readOnly"/>
						</div>
					</div>
					<div>
						<input type="text" id="searchAssured"  style="margin-left: 4px; width: 660px;" readOnly="readOnly"/>
					</div>
					<div style="margin-left: 10px;">
						<input type="text" id="searchIntermediary" style="margin-left: 4px; width: 660px;" readOnly="readOnly"/>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div id="divB"  class="buttonsDiv" style="margin-top: 10px; margin-bottom: 0px;">
		<input type="button" id="btnInvoiceOk" class="button" value="Ok" style="width: 80px;" />
		<input type="button" id="btnInvoiceCancel" class="button" value="Cancel" style="width: 80px;" />
	</div>
</div>
<script type="text/JavaScript">
	objAC.objInvoiceListingTableGrid = JSON.parse('${reserveDsTG}');
	objAC.objInvoiceListing = objAC.objInvoiceListingTableGrid.rows || [];
	objAC.selectedObjsInInvoiceLOV = [];
	var selectedIndex = null;
	var selectedRec = null;
	invoiceSelectedInvoiceRows = new Array();
	selectedPartial = new Array();
	
	var searchTableModel = {
			id : 2,
			url: contextPath
			+ "/GIACDirectPremCollnsController?action=refreshInvoiceListingTg"
			+ "&premSeqNo=" + $F("billCmNo")
			+ "&issCd=" + $F("tranSource")
			+ "&tranType=" + $F("tranType")
			+ "&instNo=" + $F("instNo"),
		options : {
			title : '',
			pager: {}, 
			addSettingBehavior : false,
			addDraggingBehavior: false,
			validateChangesOnPrePager : false,
			checkChanges: false,
			hideColumnChildTitle: true,
			width : '800px',
			toolbar : {
				elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN]
			},
			onCellFocus: function (element, value, x, y, id) {
				var mtgId = searchTableGrid._mtgId;		
				selectedIndex = y;
				if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
					selectedRec = searchTableGrid.geniisysRows[y];
					$("searchAssured").value 		= unescapeHTML2(selectedRec.assdName);
					$("searchPolicyNo").value		= unescapeHTML2(selectedRec.policyNo); //robert
					$("searchIntermediary").value = unescapeHTML2(selectedRec.intmName);
					$("searchRefPolNo").value 		= selectedRec.refPolNo;
				}
				objAC.currentRecord = selectedRec;
				if(id != "isIncluded") {
					searchTableGrid.keys.removeFocus(searchTableGrid.keys._nCurrentFocus, true);
					searchTableGrid.keys.releaseKeys();
				}
			},
			onRemoveRowFocus: function (element, value, x, y, id) {
				searchTableGrid.keys.removeFocus(searchTableGrid.keys._nCurrentFocus, true);
				searchTableGrid.keys.releaseKeys();
				selectedIndex = null;
				selectedRec = null;
				$("searchAssured").value 		= "";
				$("searchPolicyNo").value		= "";
				$("searchIntermediary").value 	= ""; //alfie
				$("searchRefPolNo").value 		= "";
				objAC.currentRecord = null;
			},
			rowPostQuery: function (y) {
				checkPreviouslySelected(searchTableGrid.getRow(y),y);
				disableAddedBill(searchTableGrid.getRow(y),y);
				//checkSelected(searchTableGrid.getRow(y),y);
			},
			prePager : function (){
				invoiceSelectedInvoiceRows = invoiceSelectedInvoiceRows.concat(searchTableGrid.getModifiedRows().filter(function fun(row) {
																			if (row.isIncluded==true) {
																				return row;
																			}
																		}));
			}
		},
		columnModel: [
		              	{	id: 'recordStatus',
			            	width: '0',
			            	visible: false
		              	},              	
		              	{
		    				id: 'divCtrId',
		    				width: '0',
		    				visible: false 
		    			},
        				{	id: 'isIncluded',
		              		title : '',
			              	width: '22',
			              	sortable: false,
			              	hideSelectAllBox: true,
							editable: true,
							visible: true,
							editor: new MyTableGrid.CellCheckbox({
								onClick: function(value, checked) {
									try{
	  			        				var recordValidated = selectedRec;
	  			        				var orPrintTag = null;
	  			        				var invoiceIndex = searchTableGrid.getCurrentPosition()[1];
	  			        				if($("mtgInput2_2,"+selectedIndex).hasAttribute("disabled")){
	  			        					return;
	  			        				}
	              						if (checked) {
		              						var invoiceRowId = recordValidated.issCd + recordValidated.premSeqNo + recordValidated.instNo; 
		              						if (getObjectFromArrayOfObjects(selectedPartial, "issCd premSeqNo instNo",
		              								invoiceRowId)) {
		              							showWaitingMessageBox("You can only reverse one transaction per bill.", "I", inValidateOverridePayt);
		              						}
		              						selectedPartial = selectedPartial.concat(searchTableGrid.getModifiedRows().filter(function fun(row) {
												if (row.isIncluded==true && ($F("tranType") == 2 || $F("tranType") == 4)) {
													return row;
												}
											}));
											//searchTableGrid.setValueAt(true,searchTableGrid.getColumnIndex('isIncluded'), searchTableGrid.getCurrentPosition()[1]);	
											orPrintTag = searchTableGrid.getValueAt(searchTableGrid.getColumnIndex("orPrintTag"),selectedIndex);
											objAC.usedAddButton = "L"; //for LOV
											validatePremSeqNoGIACS007($F("tranType"), $F("tranSource"), searchTableGrid.getRow(invoiceIndex).premSeqNo,
												function() {	
												recordValidated = validateGIACS007Record2(searchTableGrid.getRow(invoiceIndex).premSeqNo,
	      													searchTableGrid.getRow(invoiceIndex).instNo, 
	      													searchTableGrid.getRow(invoiceIndex).revGaccTranId,
	      													searchTableGrid.getRow(invoiceIndex).issCd, $F("tranType"), recordValidated, selectedIndex);
												}, function() {
													searchTableGrid.setValueAt(false,searchTableGrid.getColumnIndex('isIncluded'), invoiceIndex);		
												});
	              							searchTableGrid.setValueAt($("tranType").value, searchTableGrid.getColumnIndex('tranType'), invoiceIndex);
	              							searchTableGrid.setValueAt(recordValidated, searchTableGrid.getColumnIndex('otherInfo'), invoiceIndex);
	              							searchTableGrid.setValueAt((orPrintTag==undefined) ? "N" : orPrintTag, searchTableGrid.getColumnIndex("orPrintTag"), invoiceIndex);
	              							searchTableGrid.setValueAt("", searchTableGrid.getColumnIndex("particulars"),invoiceIndex);
	              							searchTableGrid.setValueAt(searchTableGrid.getValueAt(searchTableGrid.getColumnIndex("collAmt"),invoiceIndex) *
	              													   //searchTableGrid.getValueAt(searchTableGrid.getColumnIndex("otherInfo"),invoiceIndex).currRt,
	              													   searchTableGrid.getValueAt(searchTableGrid.getColumnIndex("currRt"),invoiceIndex),	// changed by shan 07.08.2014
	              													   searchTableGrid.getColumnIndex("forCurrAmt"), invoiceIndex);
	              							searchTableGrid.setValueAt(objACGlobal.fundCd, searchTableGrid.getColumnIndex("fundCd"), invoiceIndex);
	              							searchTableGrid.setValueAt(searchTableGrid.getValueAt(searchTableGrid.getColumnIndex("taxAmt"),invoiceIndex),
	              													   searchTableGrid.getColumnIndex("sumTaxTotal"), invoiceIndex);
	              							searchTableGrid.setValueAt(recordValidated.paramPremAmt, searchTableGrid.getColumnIndex("paramPremAmt"), invoiceIndex);
	              							searchTableGrid.setValueAt(recordValidated.prevPremAmt, searchTableGrid.getColumnIndex("prevPremAmt"), invoiceIndex);
	              							searchTableGrid.setValueAt(recordValidated.prevTaxAmt, searchTableGrid.getColumnIndex("prevTaxAmt"), invoiceIndex);
	              							searchTableGrid.setValueAt(recordValidated.origCollAmt, searchTableGrid.getColumnIndex('origCollAmt'), invoiceIndex);
	              							searchTableGrid.setValueAt(recordValidated.origPremAmt, searchTableGrid.getColumnIndex('origPremAmt'), invoiceIndex);
	              							searchTableGrid.setValueAt(recordValidated.origTaxAmt, searchTableGrid.getColumnIndex('origTaxAmt'), invoiceIndex);
	              							searchTableGrid.setValueAt(recordValidated.premVatable, searchTableGrid.getColumnIndex('premVatable'), invoiceIndex); //robert 01.21.2013
	              							searchTableGrid.setValueAt(recordValidated.currCd, searchTableGrid.getColumnIndex('currCd'), invoiceIndex); //robert 04.17.2013
	              							searchTableGrid.setValueAt(recordValidated.currRt, searchTableGrid.getColumnIndex('currRt'), invoiceIndex); //robert 04.17.2013
	              							searchTableGrid.setValueAt(recordValidated.premZeroRated, searchTableGrid.getColumnIndex('premZeroRated'), invoiceIndex); //robert 11.27.2013
	              							searchTableGrid.setValueAt(recordValidated.premVatExempt, searchTableGrid.getColumnIndex('premVatExempt'), invoiceIndex); //robert 11.27.2013
	              							searchTableGrid.keys.releaseKeys();
		              					}else{
		              						var invoiceRowId = recordValidated.issCd + recordValidated.premSeqNo + recordValidated.instNo; 
		              						if (getObjectFromArrayOfObjects(selectedPartial, "issCd premSeqNo instNo",
		              								invoiceRowId)) {
			              						selectedPartial = searchTableGrid.getModifiedRows().filter(function fun(row) {
													if (row.isIncluded==false && ($F("tranType") == 2 || $F("tranType") == 4)) {
														new Array();
													}
												});
		              						}
		              					}
									}catch(e){
										showErrorMessage("select bill",e);
									}
              			        }
              			    })
		              	},
		              	{	id : 'issCd premSeqNo',
		        			title : 'Bill No.',
		        			width : '144px',			
		        			children : [
		        				{
		        					id : 'issCd',							
		        					width : 30,							
		        					sortable : false,
		        					editable : false
		        				},
		        				{
		        					id : 'premSeqNo',							
		        					width : 80,
		        					align: 'right',
		        					renderer : function(value){
		        						return lpad(value.toString(), 12, "0");					
		        					}
		        				}
		        		     ]			
		              	}, 
		              	{	id:	'instNo',
			              	width: '50px',
			              	title: 'Inst. No.',
			           		filterOption: true,
			              	align: 'right',
			           		titleAlign: 'right',
			           		filterOptionType: 'integerNoNegative',
        					renderer : function(value){
        						return lpad(value.toString(), 2, "0");					
        					}
		              	},
		              	{	id: 'refInvNo',
			              	width: objAC.paytRefNoVis == "Y" ? '101px' : '138px' ,
			              	title: 'Ref. Inv. No.',
			              	filterOption: true,
				            align: 'left',
				            titleAlign: 'left'
		              	},
		              	{	id: 'paytRefNo',
			              	width: objAC.paytRefNoVis == "Y" ? '120px' : '0' ,
			              	title: "Payment Ref. No.",
				            align: 'left',
				            titleAlign: 'left',
				            visible: objAC.paytRefNoVis == "Y" ? true : false
		              	},
		              	{	id: 'collAmt',
			              	width: objAC.paytRefNoVis == "Y" ? '109px' : '140px' ,
			              	title: 'Collection',
			              	align: 'right',
			              	type: 'number',
			              	filterOption: true,
							geniisysClass : 'money',
			              	titleAlign: 'right',
			              	filterOptionType: 'number'
		              	},
		              	{	id: 'premAmt',
			              	width: objAC.paytRefNoVis == "Y" ? '109px' : '140px' ,
			              	title: "Premium",
			              	align: 'right',
			              	type: "number",
			              	filterOption: true,
							geniisysClass : 'money',
							titleAlign: 'right',
			              	filterOptionType: 'number'
		              	},
		              	{	id: 'taxAmt',
			              	width: objAC.paytRefNoVis == "Y" ? '109px' : '130px' ,
			              	title: "Tax",
			              	align: 'right',
			              	type: "number",
			              	filterOption: true,
							geniisysClass : 'money',
							titleAlign: 'right',
			              	filterOptionType: 'number'
		              	},
		              	{	id: 'orPrintTag',
			              	width: '0',
			              	visible: false
		              	},
		              	{	id: 'tranType',
			              	width: '0',
			              	visible: false
		              	},
		            	{	id: 'otherInfo',
			              	width: '0',
			              	visible: false
		              	},
		              	{	id: 'particulars',
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
		    			{
        					id : 'issCd',							
        					width : '0',							
        					visible: false,
			           		filterOption: true,
			           		title: "Issue Code"
        				},
        				{
        					id : 'premSeqNo',							
        					width : '0',
        					visible: false,
			           		filterOption: true,
			           		title: "Bill/CM No.",
			              	filterOptionType: 'integerNoNegative'
        				},
        				{
        					id : 'assdName',							
        					width : '0',							
        					visible: false,
			           		filterOption: true,
			           		title: "Assured"
        				},
        				{
        					id : 'intmName',							
        					width : '0',							
        					visible: false,
			           		filterOption: true,
			           		title: "Intermediary"
        				},
        				{
        					id : 'refPolNo',							
        					width : '0',							
        					visible: false,
			           		filterOption: true,
			           		title: "Ref. Policy No."
        				},
		              	{	id: 'refPolNo',
			              	width: '0',
			              	visible: false
		              	},
		              	{	id: 'premVatable',
			              	width: '0',
			              	visible: false
		              	},
		              	{	id: 'premVatExempt',
			              	width: '0',
			              	visible: false
		              	},
		              	{	id: 'premZeroRated',
			              	width: '0',
			              	visible: false
		              	},
		              	{	id: 'revGaccTranId',
			              	width: '0',
			              	visible: false
		              	},
		              	{	id: 'policyNo',
			              	width: '0',
			              	visible: false
		              	},
		              	{   id: 'prevPremAmt',
		              		width: '0',
		              		visible: false
		              	},
		              	{   id: 'prevTaxAmt',
		              		width: '0',
		              		visible: false
		              	},
		              	{   id: 'paramPremAmt',
		              		width: '0',
		              		visible: false
		              	},
		              	{   id: 'origPremAmt',
		              		width: '0',
		              		visible: false
		              	},
		              	{   id: 'origTaxAmt',
		              		width: '0',
		              		visible: false
		              	},
		              	{   id: 'origCollAmt',
		              		width: '0',
		              		visible: false
		              	},
		              	//added 11.15.12
		              	{
        					id : 'endtYy',							
        					width : '0',							
        					visible: false,
			           		filterOption: true,
			           		title: "Endt Year",
			           		filterOptionType: "integerNoNegative"
        				},
        				{
        					id : 'endtSeqNo',							
        					width : '0',							
        					visible: false,
			           		filterOption: true,
			           		title: "Endt Sequence Number",
			           		filterOptionType: "integerNoNegative"
			           		
        				},
        				{
        					id : 'endtIssCd',							
        					width : '0',							
        					visible: false,
			           		filterOption: true,
			           		title: "Endt Issue Code"
        				},
        				{
        					id : 'issueYy',							
        					width : '0',							
        					visible: false,
			           		filterOption: true,
			           		title: "Issue Year",
			           		filterOptionType: "integerNoNegative"
        				},
        				{
        					id : 'lineCd',							
        					width : '0',							
        					visible: false,
			           		filterOption: true,
			           		title: "Line Code"
        				},
        				{
        					id : 'polSeqNo',							
        					width : '0',							
        					visible: false,
			           		filterOption: true,
			           		title: "Policy Sequence Number",
			           		filterOptionType: "integerNoNegative"
        				},
        				{
        					id : 'sublineCd',							
        					width : '0',							
        					visible: false,
			           		filterOption: true,
			           		title: "Subline Code"
        				},
        				//robert 04.17.2013
		              	{   id: 'currCd',
		              		width: '0',
		              		visible: false
		              	},
		              	{   id: 'currRt',
		              		width: '0',
		              		visible: false
		              	}
			         ],
				rows: objAC.objInvoiceListing
	};
	
	searchTableGrid = new MyTableGrid(searchTableModel);
	searchTableGrid.pager = objAC.objInvoiceListingTableGrid;
	searchTableGrid.render('billInvoiceListingDiv');
	searchTableGrid.afterRender = function(){
		selectedIndex = null;
		selectedRec = null;
		$("searchAssured").value 		= "";
		$("searchPolicyNo").value		= "";
		$("searchIntermediary").value 	= "";
		$("searchRefPolNo").value 		= "";
	};

	function disableAddedBill(bill,y) {
		var invoiceRowId = objACGlobal.gaccTranId + 
		bill.issCd + bill.premSeqNo +
		bill.instNo; // marco - removed - + $("tranType").value;
		//if (getObjectFromArrayOfObjects(objAC.objGdpc, 
		//	    "gaccTranId issCd premSeqNo instNo tranType",
		//	    invoiceRowId)) {
		if(nvl(getObjectFromArrayOfObjects(objAC.objGdpc, "gaccTranId issCd premSeqNo instNo", invoiceRowId), "") != ""){ //marco - 09.22.2014 - modified
			$("mtgInput2_2," + y).checked = true;
			$("mtgInput2_2," + y).disabled=true;
		} 
	}                               

 	function checkPreviouslySelected(bill, y) {
		var invoiceRowId = bill.issCd + bill.premSeqNo + bill.instNo; 
		if (getObjectFromArrayOfObjects(invoiceSelectedInvoiceRows, "issCd premSeqNo instNo",
				invoiceRowId)) {
			$("mtgInput2_2," + y).checked = true;
		}
	}
	
	function checkSelected(bill, y) {
		var invoiceRowId = bill.issCd + bill.premSeqNo +
		bill.instNo + $("tranType").value;
		if (getObjectFromArrayOfObjects(invoiceSelectedInvoiceRows, 
			    "issCd premSeqNo instNo tranType",
			    invoiceRowId)) {
			$("mtgInput4_2," + y).checked = true;
		}
	}
	
	//invoiceSelectedInvoiceRows2 = new Array();
	function mergeSameInvoiceRows(invoiceRows) {
		var temp = {};
		var newRow = {};
		var newArray = [];
		for(var i=0; i<invoiceRows.length; i++) {
			newRow = invoiceRows[i];
			for(var j=0; j<newArray.length; j++) {
				if(newRow.issCd == newArray[j].issCd && newRow.instNo == newArray[j].instNo &&
						newRow.premSeqNo == newArray[j].premSeqNo && newRow.tranType == newArray[j].tranType) {
					newRow.collAmt = parseFloat(newRow.collAmt) + parseFloat(newArray[j].collAmt);
					newRow.premAmt = parseFloat(newRow.premAmt) + parseFloat(newArray[j].premAmt);
					newRow.taxAmt = parseFloat(newRow.taxAmt) + parseFloat(newArray[j].taxAmt);
					
					newRow.collectionAmt1 = parseFloat(newRow.collectionAmt1) + parseFloat(newArray[j].collectionAmt1);
					newRow.premAmt1 = parseFloat(newRow.premAmt1) + parseFloat(newArray[j].premAmt1);
					newRow.taxAmt1 = parseFloat(newRow.taxAmt1) + parseFloat(newArray[j].taxAmt1);
					
					newRow.sumTaxTotal = parseFloat(newRow.sumTaxTotal) + parseFloat(newArray[j].sumTaxTotal);
					newRow.forCurrAmt = parseFloat(newRow.forCurrAmt) + parseFloat(newArray[j].forCurrAmt);
					
					newRow.premVatable = (newRow.premVatable == null ? 0 : parseFloat(newRow.premVatable)) + 
										(newArray[j].premVatable == null ? 0 : parseFloat(newArray[j].premVatable));
					newRow.premVatExempt = (newRow.premVatExempt == null ? 0 : parseFloat(newRow.premVatExempt)) + 
										(newArray[j].premVatExempt == null ? 0 : parseFloat(newArray[j].premVatExempt));
					newRow.premZeroRated = (newRow.premZeroRated == null ? 0 : parseFloat(newRow.premZeroRated)) + 
										(newArray[j].premZeroRated == null ? 0 : parseFloat(newArray[j].premZeroRated));
					
					if(newRow.tranType == 2 || newRow.tranType == 4) {
						newRow.forCurrAmt = -1*newRow.forCurrAmt;
						newRow.premVatable = -1*newRow.premVatable;
						newRow.premVatExempt = -1*newRow.premVatExempt;
						newRow.premZeroRated = -1*newRow.premZeroRated;
					}
					
					newRow.revGaccTranId = null;
					newArray.splice(j, 1);
					//invoiceRows.splice(j, 1);
				}
			}
			newArray.push(newRow);
		}	
		return newArray;
	}
	
	/* function setTranTypeValues(obj){
		for (var i=0; i<obj.length; i++){
			if (obj[i].tranType == 1 || obj[i].tranType == 3){
				null;
			}else {
				obj[i].collAmt = obj[i].collectionAmt1;
				obj[i].premAmt = obj[i].premAmt1;
				obj[i].taxAmt = obj[i].taxAmt1;
				obj[i].premCollectionAmt = obj[i].premCollectionAmt * -1;
				obj[i].origCollAmt = obj[i].origCollAmt * -1;
				obj[i].origPremAmt = obj[i].origPremAmt * -1;
				obj[i].origTaxAmt = obj[i].origTaxAmt * -1;
				obj[i].forrCurrAmt = obj[i].forrCurrAmt * -1;
				obj[i].sumTaxTotal = obj[i].sumTaxTotal * -1;
			}
		}
	} */
	
	function setObjGdpc(row){
		var rowObjGdpc = new Object();
		rowObjGdpc = row;
		rowObjGdpc.gaccTranId = objACGlobal.gaccTranId;
		rowObjGdpc.recordStatus = 0;
		return rowObjGdpc;
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
	
	function addRecordsInPaidList2(newRecordsList) {
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
			rowObj.maxCollAmt = newRecordsList[index1].collAmt;
			rowObj.incTag = nvl(objAC.currentRecord.incTag, "N"); // added by: Nica 04.22.2013 - to assign the new incTag derived from getIncTagForAdvPremPayts
			
			var hasDuplicate = false;
			for(var i = 0; i < objAC.objGdpc.length; i++){
				if(rowObj.issCd == objAC.objGdpc[i].issCd && rowObj.premSeqNo == objAC.objGdpc[i].premSeqNo &&
					rowObj.instNo == objAC.objGdpc[i].instNo && objAC.objGdpc[i].recordStatus != -1){
					hasDuplicate = true;
				}
			}
			
			if(!hasDuplicate){
				if (getObjectFromArrayOfObjects(objAC.objGdpc, 
					    "gaccTranId issCd premSeqNo instNo tranType",
	    				newPremCollnRowId)==null) {
					rowObj.recordStatus = 0;
					rowObj.balanceAmtDue = 0;
					
					objAC.objGdpc.push(rowObj);
					gdpcTableGrid.addBottomRow(rowObj);
				} else {
					var jsonReplacementRecord = getObjectFromArrayOfObjects(objAC.objGdpc, "gaccTranId issCd premSeqNo instNo tranType",
									newPremCollnRowId);
					rowObj.recordStatus = 2;
					gdpcTableGrid.updateRowAt(rowObj, jsonReplacementRecord.index-1);
				}
				/* computeTotalAmountsGIACS7(unformatCurrencyValue(rowObj.collAmt), unformatCurrencyValue(rowObj.premAmt), 
						unformatCurrencyValue(rowObj.taxAmt), "add"); */
				computeTotalAmountsGIACS7(new Number(rowObj.collAmt), new Number(rowObj.premAmt),  new Number(rowObj.taxAmt), "add"); //modified by robert 01.18.2013
			}
		}
		//computeTotalAmountsGIACS7();
		gdpcTableGrid.onRemoveRowFocus();
	}
	
	$("btnInvoiceOk").observe("click", function () {
		try {
			//$("invoicePageNo").value = 1;
			searchTableGrid.releaseKeys();
			var invoiceModifiedRows = invoiceSelectedInvoiceRows.concat(searchTableGrid.getModifiedRows().filter(function fun(row) { // andrew - 05.09.2011 - added array concat of selected invoice in different pages
																			if (row.isIncluded==true) {
																				/*row.collAmt = row.newCollAmt;
																					row.premAmt = row.newPremAmt;
																					row.taxAmt = row.newTaxAmt ;
																					row.premVatExempt = row.newPremVatExempt;*/
																				return row;
																			}
																		}));
			
			if(invoiceModifiedRows.length == 0){
				return false;
			}else if(invoiceModifiedRows.length > 1) {
				invoiceModifiedRows = mergeSameInvoiceRows(invoiceModifiedRows);
			}
			//setTranTypeValues(invoiceModifiedRows);			
			function isBigEnough(element, index, array) {
				  return (element >= 10);
				}

			for (var x=0; x<invoiceModifiedRows; x++) {
				if (invoiceModifiedRows.isIncluded==false) {
					invoiceModifiedRows.splice(x,1);
				}
			}
			
			addRecordsInPaidList2(invoiceModifiedRows);
			objAC.formChanged = "Y";
			changeTag = 1;
			modalPageNo2 = 1;
			objAC.selectedFromInvoiceLOV = false;
		} catch (e) {
			showErrorMessage("searchInvoice.jsp - btnInvoiceOk", e);
		} finally {
			searchTableGrid.keys.removeFocus(searchTableGrid.keys._nCurrentFocus, true);
			searchTableGrid.keys.releaseKeys();
			distDtlsOverlay.close();
			delete distDtlsOverlay;
			rowPremCollnDeselectedFnTG();
		} 
	});
	
	$("btnInvoiceCancel").observe("click", function(){
		clearInvalidPrem();
		searchTableGrid.keys.removeFocus(searchTableGrid.keys._nCurrentFocus, true);
		searchTableGrid.keys.releaseKeys();
		distDtlsOverlay.close();
		delete distDtlsOverlay;
	});
	
</script>