<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
    <%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<!-- Hidden Fields 
<div id="hiddenDiv">
	<input type="hidden" id="selectedClientId" value="0" readonly="readonly" />
	<input type="hidden" id="invoicePageNo" value="${pageNo}" /> 
</div>-->
<!-- End Hidden Fields -->
<div>
	<div>
		<div id="billInvoiceListingDiv" style="width: 762px; height: 250px;">
		</div>
	</div>
	<div style="padding: 10px 4px;">
		<div>
			<div style="float:left; height: 80px;">
				<div style="padding-top: 5px;"><label class="leftAligned" width="40%" style="font-size: 11px;">Policy No. / Endt. No.:</label></div>
				<div style="padding-top: 25px;"><label class="leftAligned" width="40%" style="font-size: 11px;">Assured: </label></div>
				<div style="padding-top: 27px;"><label class="leftAligned" width="40%" style="font-size: 11px;">Intermediary:</label></div>
			</div>
			<div>
				<div>
					<div style="float:left;">
						<input type="text"  style="font-size: 11px; width: 300px; margin-right: 70px; margin-left: 4px;" readOnly="readOnly" id="searchPolicyNo"/>
					</div>
					<div style="float:left;">
						<label class="leftAligned" width="40px" style="font-size: 11px; margin-top: 2px;">Ref. Policy No.: </label>
						<input type="text" id="searchRefPolNo" style="margin-left: 4px;" readOnly="readOnly"/>
					</div>
				</div>
				<div>
					<input type="text" id="searchAssured"  style="margin-left: 4px; width: 605px;" readOnly="readOnly"/>
				</div>
				<div style="margin-left: 10px;">
					<input type="text" id="searchIntermediary" style="margin-left: 4px; width: 605px;" readOnly="readOnly"/>
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/JavaScript">
	//position page div correctly
	/*var jsonInvoiceSearchResult = JSON.parse('${jsonSearchResult}');
	var product = 288 - (parseInt($$("div[name='row']").size())*28);
	$("pager").setStyle("margin-top: "+product+"px;");
	$("pageOption").value = $F("invoicePageNo");
	$$("div[name='row']").each(
	/*	function (row)	{
			row.observe("mouseover", function ()	{
				row.addClassName("lightblue");
			});
			
			row.observe("mouseout", function ()	{
				row.removeClassName("lightblue");
			});
		
			row.observe("click", function ()	{
				var renewNo ="";
				row.toggleClassName("selectedRow");
				if (row.hasClassName("selectedRow"))	{
					$("selectedClientId").value = row.getAttribute("id").substring(3);
					$$("div[name='row']").each(function (r)	{
						if (row.getAttribute("id") != r.getAttribute("id"))	{
							r.removeClassName("selectedRow");
						}else{
							var selected = getObjectFromArrayOfObjects(jsonInvoiceSearchResult, "issCd premSeqNo instNo", r.down("label",1).innerHTML +  r.down("label",2).innerHTML + r.down("label",3).innerHTML);
							//renewNo = r.down("input", 7).value == "" ? '00' : r.down("input", 7).value;
							renewNo = selected.renewNo == "" ? '00' : selected.renewNo;
							$("assdName").value  	= selected.assdName; //r.down("input", 1).value;
							$("polEndtNo").value 	= selected.policyNo; //r.down("input", 2).value+"-"+r.down("input", 3).value+"-"+r.down("input", 4).value+"-"+r.down("input", 5).value+"-"+(parseInt(r.down("input", 6).value)).toPaddedString(7)+"-"+renewNo;
							$("instNo").value 		= selected.instNo; //r.down("input", 9).value;
							$("billCmNo").value 	= selected.premSeqNo; //r.down("input", 10).value;
							if ($F("tranType") == 1 || $F("tranType") == 4) {
								$("premCollectionAmt").value 	= formatCurrency(selected.collectionAmt); //formatCurrency(r.down("input", 8).value);
								$("directPremAmt").value 		= formatCurrency(selected.premAmt); //formatCurrency(r.down("input", 11).value);
								$("taxAmt").value 				= formatCurrency(selected.taxAmt); //formatCurrency(r.down("input", 12).value);
							}else{
								$("premCollectionAmt").value = formatCurrency(selected.collectionAmt1); //formatCurrency(r.down("input", 13).value);
								$("directPremAmt").value 	 = formatCurrency(selected.premAmt1); //formatCurrency(r.down("input", 14).value);
								$("taxAmt").value 			 = formatCurrency(selected.taxAmt1); //formatCurrency(r.down("input", 15).value);								
							}
						}
					});
				}	
			});
		}
	);*/

	$$("label[name='address']").each(function (lbl) {
		lbl.update((lbl.innerHTML).truncate(70, "..."));
	});

	$$("label[name='payorName']").each(function (lbl) {
		lbl.update((lbl.innerHTML).truncate(25, "..."));
	});

	$$("label[name='collectionAmt']").each(function (lbl) {
		lbl.innerHTML = formatCurrency(lbl.innerHTML);
	});

	$$("label[name='premAmt']").each(function (lbl) {
		lbl.innerHTML = formatCurrency(lbl.innerHTML);
	});

	$$("label[name='taxAmt']").each(function (lbl) {
		lbl.innerHTML = formatCurrency(lbl.innerHTML);
	});

	objAC.objInvoiceListingTableGrid = JSON.parse('${searchResult}');
	objAC.objInvoiceListing = objAC.objInvoiceListingTableGrid.rows || [];
	objAC.selectedObjsInInvoiceLOV = [];
	var selectedIndex = null;
	var selectedRec = null;
	
	var searchTableModel = {
			url: contextPath+"/GIACDirectPremCollnsController?action=getSearchResult&premSeqNo="+$F("billCmNo")+"&issCd="+$F("tranSource")+"&tranType="+$F("tranType"),
			options: {
						querySort: false,
						pager: {},
						addSettingBehavior : false,
						addDraggingBehavior: false,
						validateChangesOnPrePager : false,
						checkChanges: false,
						toolbar : {
							elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN]
								
						},
						onCellFocus: function (element, value, x, y, id) {
							selectedIndex = y;
							if(element.readAttribute("type") != "checkbox"){							
								selectedRec = searchTableGrid.getRow(y);
								$("searchAssured").value 		= unescapeHTML2(selectedRec.assdName);
								$("searchPolicyNo").value		= unescapeHTML2(selectedRec.policyNo);
								$("searchIntermediary").value 	= unescapeHTML2(selectedRec.intmName);
								$("searchRefPolNo").value 		= unescapeHTML2(selectedRec.refPolNo);
								objAC.currentRecord = selectedRec;
							}
						},
						onRemoveRowFocus: function (element, value, x, y, id) {
							selectedIndex = null;
							selectedRec = null;
							$("searchAssured").value 		= "";
							$("searchPolicyNo").value		= "";
							$("searchIntermediary").value 	= ""; //alfie
							$("searchRefPolNo").value 		= "";
							searchTableGrid.releaseKeys();
							objAC.currentRecord = selectedRec;
						},
						rowPostQuery: function (y) {
							checkPreviouslySelected(searchTableGrid.getRow(y),y);
							disableAddedBill(searchTableGrid.getRow(y),y);	
							//checkSelected(searchTableGrid.getRow(y),y);
						},
						prePager : function (){
							// andrew - 05.09.2011 - collect selected rows in an array
							invoiceSelectedInvoiceRows = invoiceSelectedInvoiceRows.concat(searchTableGrid.getModifiedRows().filter(function fun(row) {
																						if (row.isIncluded==true) {
																							return row;
																						}
																					}));
						}
						
					},
			columnModel: [
			              	{	id: 'recordStatus',
				            	title: '',
				            	width: '30',
				            	sortable: false,
				            	editable: false,
				            	visible: false
			              	},
			              			              	
			              	{
			    				id: 'divCtrId',
			    				width: '0',
			    				visible: false 
			    			},

			              	{	id: 'invoiceListingId',
				              	width: '0',
				              	visible: false
			              	},

			              	{	id: 'isIncluded',
			              		title : '',
				              	width: '20',
				              	editable: true,
				              	sortable: false,
				              	visible: true,
				              	editor: new MyTableGrid.CellCheckbox({
				              			        onClick: function(value, checked) {
	              			        				var recordValidated = selectedRec;
	              			        				var orPrintTag = null;
				              						if (checked) {
														orPrintTag = searchTableGrid.getValueAt(searchTableGrid.getColumnIndex("orPrintTag"),selectedIndex);
														
														validatePremSeqNoGIACS007($F("tranType"), $F("tranSource"), searchTableGrid.getRow(searchTableGrid.getCurrentPosition()[1]).premSeqNo,
															function() {
																validateGIACS007Record2(searchTableGrid.getRow(searchTableGrid.getCurrentPosition()[1]).premSeqNo,
		              													searchTableGrid.getRow(searchTableGrid.getCurrentPosition()[1]).instNo, 
		              													$F("tranSource"), $F("tranType"), recordValidated, selectedIndex);
															}, function() {
																searchTableGrid.setValueAt(false,searchTableGrid.getColumnIndex('isIncluded'), searchTableGrid.getCurrentPosition()[1]);		
															});
				              							/* validateGIACS007Record2(searchTableGrid.getRow(searchTableGrid.getCurrentPosition()[1]).premSeqNo,
				              													searchTableGrid.getRow(searchTableGrid.getCurrentPosition()[1]).instNo, 
				              													$F("tranSource"), $F("tranType"), recordValidated); */
				              							objAC.usedAddButton = null;
														
				              							searchTableGrid.setValueAt($("tranType").value, searchTableGrid.getColumnIndex('tranType'), searchTableGrid.getCurrentPosition()[1]);
				              							
				              							searchTableGrid.setValueAt(recordValidated, searchTableGrid.getColumnIndex('otherInfo'), searchTableGrid.getCurrentPosition()[1]);
				              							
				              							searchTableGrid.setValueAt((orPrintTag==undefined) ? "N" : orPrintTag, searchTableGrid.getColumnIndex("orPrintTag"), searchTableGrid.getCurrentPosition()[1]);
				              								
				              							searchTableGrid.setValueAt("", searchTableGrid.getColumnIndex("particulars"),searchTableGrid.getCurrentPosition()[1]);
				              								
				              							searchTableGrid.setValueAt(searchTableGrid.getValueAt(searchTableGrid.getColumnIndex("collAmt"),searchTableGrid.getCurrentPosition()[1]) *
				              													   searchTableGrid.getValueAt(searchTableGrid.getColumnIndex("otherInfo"),searchTableGrid.getCurrentPosition()[1]).currRt,
				              													   searchTableGrid.getColumnIndex("forCurrAmt"),searchTableGrid.getCurrentPosition()[1]);
				              							   
				              							searchTableGrid.setValueAt(objACGlobal.fundCd, searchTableGrid.getColumnIndex("fundCd"),searchTableGrid.getCurrentPosition()[1]);
				              							
				              							searchTableGrid.setValueAt(searchTableGrid.getValueAt(searchTableGrid.getColumnIndex("taxAmt"),searchTableGrid.getCurrentPosition()[1]),
				              													   searchTableGrid.getColumnIndex("sumTaxTotal"),searchTableGrid.getCurrentPosition()[1]);
					              					}
				              						
				              			        }
				              			    })
			              	},
			              	{	id:	'billNo',
		              	  		width: '100', //140
		              	  		visible: true,
		              	  		title: "Bill No.",
		              	  		align: "left",
		              	  		titleAlign: "left"
			              	}, 
			              	{	id:	'instNo',
				              	width: '45', //50
				              	visible: true,
				              	align: "right",
				              	title: "Inst. No",
				           		filterOption: true,
				           		titleAlign: "right",
				           		filterOptionType: 'integerNoNegative'
			              	},
			              	{	id: 'refInvoiceNo',
				              	width: '75', //100
				              	visible: true,
				              	align: "center",
				              	title: "Ref. Inv. No.",
					            align: "left",
					            titleAlign: "left"
			              	},
			              	{	id: 'collAmt',
				              	width: '130', //140
				              	visible: true,
				              	title: "Collection",
				              	align: "right",
				              	type: "number",
								geniisysClass : 'money',
				              	titleAlign: "right"
			              	},
			              	{	id: 'premAmt',
				              	width: '130', //140
				              	visible: true,
				              	title: "Premium",
				              	align: "right",
				              	type: "number",
								geniisysClass : 'money',
				              	titleAlign: "right"
			              	},
			              	{	id: 'taxAmt',
				              	width: '130', //140
				              	visible: true,
				              	title: "Tax",
				              	align: "right",
				              	type: "number",
								geniisysClass : 'money',
				              	titleAlign: "right"
			              	},
			              	{	id: 'issCd',
				              	width: '0',
				              	visible: false,
				              	title: "Issue Code"
			              	},
			              	{	id:	'premSeqNo',
				              	width: '0',
				              	visible: false,
				              	filterOption: true,
				              	title: "Bill CM No.",
				              	filterOptionType: 'integerNoNegative'
			              	},
			              	{	id: 'policyNo',
				              	width: '0',
				              	visible: false
			              	},
			              	{	id: 'policyId',
				              	width: '0',
				              	visible: false
			              	},
			              	{	id: 'assdName',
				              	width: '0',
				              	visible: false,
				              	filterOption: true,
				              	title: 'Assured Name'
			              	},
			              	{	id: 'intmName',
				              	width: '0',
				              	visible: false,
				              	filterOption: true,
				              	title: 'Intermediary Name'
			              	},
			              	{	id: 'lineCd', // bonok start :: 09.17.2012
				              	width: '0',
				              	visible: false,
				              	filterOption: true,
				              	title: 'Line Code'
			              	},
			              	{	id: 'sublineCd',
				              	width: '0',
				              	visible: false,
				              	filterOption: true,
				              	title: 'Subline Code'
			              	},
			              	{	id: 'polIssCd',
				              	width: '0',
				              	visible: false,
				              	filterOption: true,
				              	title: 'Issue Code'
			              	},
			              	{	id: 'issueYy',
				              	width: '0',
				              	visible: false,
				              	filterOption: true,
				              	title: 'Issue Year'
			              	},
			              	{	id: 'polSeqNo',
				              	width: '0',
				              	visible: false,
				              	filterOption: true,
				              	title: 'Policy Sequence Number'
			              	},
			              	{	id: 'endtIssCd',
				              	width: '0',
				              	visible: false,
				              	filterOption: true,
				              	title: 'Endt Issue Code'
			              	},	
			              	{	id: 'endtYy',
				              	width: '0',
				              	visible: false,
				              	filterOption: true,
				              	title: 'Endt Year'
			              	},
			              	{	id: 'endtSeqNo',
				              	width: '0',
				              	visible: false,
				              	filterOption: true,
				              	title: 'Endt Sequence Number' // bonok end :: 09.17.2012
			              	},
			              	{	id: 'otherInfo',
				              	width: '0',
				              	visible: false
			              	},
			              	{	id: 'tranType',
				              	width: '0',
				              	visible: false
			              	},
			              	{	id: 'orPrintTag',
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
			              	{   id: 'currCd',
				              	width: '0',
				              	visible: false
			              	},
			              	{   id: 'currRt',
				              	width: '0',
				              	visible: false
			              	},
			              	{	id: 'collectionAmt1',
				              	width: '0',
				              	visible: false,
				              	title: "Collection Amt",
				              	align: "right",
				              	type: "number",
				              	titleAlign: "right"
			              	},
			              	{	id: 'premAmt1',
				              	width: '0',
				              	visible: false,
				              	title: "Premium",
				              	align: "right",
				              	type: "number",
				              	titleAlign: "right"
			              	},
			              	{	id: 'taxAmt1',
				              	width: '0',
				              	visible: false,
				              	title: "Tax",
				              	align: "right",
				              	type: "number",
				              	titleAlign: "right"
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
			              	}
				         ],
				        //requiredColumns: '',
				 	    rows : objAC.objInvoiceListing
			};		              	
	searchTableGrid = new MyTableGrid(searchTableModel);
	searchTableGrid.pager = objAC.objInvoiceListingTableGrid;
	searchTableGrid.render('billInvoiceListingDiv');

	function disableAddedBill(bill,y) {
		var invoiceRowId = objACGlobal.gaccTranId + 
		bill.issCd + bill.premSeqNo +
		bill.instNo + $("tranType").value;
		if (getObjectFromArrayOfObjects(objAC.jsonDirectPremCollnsDtls, 
			    "gaccTranId issCd premSeqNo instNo tranType",
			    invoiceRowId)) {
			$("mtgInput1_3," + y).checked = true;
			$("mtgInput1_3," + y).disabled=true;
		}
	}                               

 	function checkPreviouslySelected(bill, y) {
		var invoiceRowId = bill.issCd + bill.premSeqNo + bill.instNo; 
		if (getObjectFromArrayOfObjects(objAC.rowsToAdd, "issCd premSeqNo instNo",
				invoiceRowId)) {
			$("mtgInput1_3," + y).checked = true;
		}
	}
	
	function checkSelected(bill, y) {
		var invoiceRowId = bill.issCd + bill.premSeqNo +
		bill.instNo + $("tranType").value;
		if (getObjectFromArrayOfObjects(invoiceSelectedInvoiceRows, 
			    "issCd premSeqNo instNo tranType",
			    invoiceRowId)) {
			$("mtgInput1_3," + y).checked = true;
		}
	}
	
</script>