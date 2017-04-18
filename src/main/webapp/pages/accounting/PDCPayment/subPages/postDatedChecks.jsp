<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="postDatedChecksTableDiv" name="postDatedChecksTableDiv" style="height: 225px; width: 100%; float: left;">
	<div id="postDatedChecksTable" name="postDatedChecksTable" style="float: left; width: 98.5%; position: relative; margin: 5px; height: 190px;">	
	</div>
</div>
<div id="pdcDiv" name="pdcDiv" style="float: left; width: 100%; margin-bottom: 5px;" align="center" changeTagAttr="true">
	<table style="float: left; margin-left: 60px;">
		<tr>
			<td class="rightAligned">Item</td>
			<td class="leftAligned">
				<input class="required" type="hidden" id="hidPdcId" name="hidPdcId">
				<input class="required integerNoNegativeUnformattedNoComma" type="text" id="txtItemNo" name="txtItemNo" style="text-align: right; float: left; width: 100px;" tabindex="201">
			</td>
			<td class="rightAligned">Check Class</td>
			<td class="leftAligned">
				<select id="selCheckClass" name="selCheckClass" style="float: left; width: 228px;" class="required" tabindex="208">
					<option></option>
					<c:forEach var="c" items="${checkClass}">					
						<option value="${c.rvLowValue}">${c.rvMeaning}</option>
					</c:forEach>
				</select>
			</td>						
		</tr>
		<tr>
			<td class="rightAligned">Bank</td>
			<td class="leftAligned">
				<span class="required lovSpan" style="width: 226px; margin-right: 30px;">
					<input type="hidden" id="hidBankCd" name="hidBankCd">
					<input type="text" id="txtBankName" name="txtBankName" style="width: 201px; float: left; border: none; height: 14px; margin: 0;" class="required" readonly="readonly" tabindex="202"></input>  
					<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBank" name="btnSearchBank" alt="Go" style="float: right;"/>
				</span>
			</td>
			<td class="rightAligned">Check No.</td>
			<td class="leftAligned"><input class="required" type="text" id="txtCheckNo" name="txtCheckNo" style="float: left; width: 220px; text-align: right;" maxlength="25" tabindex="209"></td>
		</tr>
		<tr>
			<td class="rightAligned">Branch</td>
			<td class="leftAligned"><input class="required" type="text" maxlength="200" id="txtBankBranch" name="txtBankBranch" style="float: left; width: 220px;" tabindex="203"></td>
			<td class="rightAligned">Check Date</td>
			<td class="leftAligned">
				<div id="checkDateDiv" name="checkDateDiv" class="required" style="float:left; border: solid 1px gray; width: 225px; height: 20px; margin-right:3px;">
			    	<input class="required" style="width: 201px; border: none; height: 12px; margin: 0; float: left;" id="txtCheckDate" name="txtCheckDate" type="text" value="" readonly="readonly"  tabindex="210"/>
			    	<img id="hrefCheckDate" name="hrefCheckDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"	alt="Check Date" onClick="scwShow($('txtCheckDate'),this, null)" class="hover"/>				    			    
				</div>						
		</tr>
		<tr>
			<td class="rightAligned">Currency</td>
			<td class="leftAligned">
				<select id="selCurrency" name="selCurrency" style="float: left; width: 228px;" class="required" tabindex="204">
					<option></option>
					<c:forEach var="curr" items="${currency}">
						<option value="${curr.code}" currencyRt="${curr.valueFloat}">${curr.desc}</option>
					</c:forEach>
				</select>
			</td>
			<td class="rightAligned">Amount</td>
			<td class="leftAligned"><input type="text" class="money required" id="txtCheckAmt" name="txtCheckAmt" style="float: left; width: 220px; text-align: right;" tabindex="211" maxlength="14"></td>						
		</tr>
		<tr>
			<td class="rightAligned">Currency Rate</td>
			<td class="leftAligned"><input type="text" id="txtCurrencyRt" name="txtCurrencyRt" style="float: left; width: 220px; text-align: right;" readonly="readonly" tabindex="205"></td>
			<td class="rightAligned">Gross Amount</td>
			<td class="leftAligned"><input type="text" class="money" id="txtGrossAmt" name="txtGrossAmt" style="float: left; width: 220px; text-align: right;" tabindex="212"></td>				
		</tr>
		<tr>
			<td class="rightAligned">Foreign Currency Amt.</td>
			<td class="leftAligned"><input type="text" id="txtFCurrencyAmt" name="txtFCurrencyAmt" style="float: left; width: 220px; text-align: right;" readonly="readonly" tabindex="206" class="money"></td>
			<td class="rightAligned">Comm. Amount</td>
			<td class="leftAligned"><input type="text" class="money" id="txtCommissionAmt" name="txtCommissionAmt" style="float: left; width: 220px; text-align: right;" tabindex="213"></td>				
		</tr>			
		<tr>
			<td class="rightAligned">Status</td>
			<td class="leftAligned">
				<input type="text" id="txtCheckFlag" name="txtCheckFlag" style="float: left; width: 220px;" readonly="readonly" tabindex="207">
				<input type="hidden" id="hidPdcPaytDtlOrFlag" name="hidPdcPaytDtlOrFlag">
			</td>
			<td class="rightAligned">VAT Amount</td>
			<td class="leftAligned"><input type="text" class="money" id="txtVatAmt" name="txtVatAmt" style="float: left; width: 220px; text-align: right;" tabindex="214"></td>								
		</tr>
	</table>				
</div>
<script type="text/javascript">
try{
	//if (('${postDatedChecksTableGrid}') != ""){
		objCurrGIACApdcPaytDtl = new Object(); 
		var defaultCurrency = "${defaultCurrency}";
		var selectedRowIndex;
		var grossAmtOrigValue;
		var test = "";
		var addFlag = 1;
		var ackReceiptsJsonObject = new Object();
		var currentRow = "";
		var pdcId = 0;
		
		ackReceiptsJsonObject.apdcPaytDtlTableGrid = JSON.parse('${postDatedChecksTableGrid}'); //remove by steven 9/27/2012 replace(/\\/g, '\\\\')
		ackReceiptsJsonObject.apdcPaytDtl = ackReceiptsJsonObject.apdcPaytDtlTableGrid.rows || [];

		var itemNo = {}; //added by jdiago 08.08.2014
		itemNo.listOfItemNos = JSON.parse('${itemNosList}'); //added by jdiago 08.08.2014 : purpose is to validate existing item numbers in next pages of tablegrid.
		
		var postDatedChecksTableModel = {
			url: contextPath+"/GIACAcknowledgmentReceiptsController?action=refreshPostDatedChecksTable&apdcId="+objGIACApdcPayt.apdcId,
			options: { 
				validateChangesOnPrePager : false,
				width: '910px',				
				beforeSort: function(){
					if(changeTag == 1 || objGIACApdcPayt.pdcPremChangeTag == 1){
						//showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", objGIACApdcPayt.initializeAcknowledgmentReceiptSaving, showAcknowledgementReceiptListing, "");
						showMessageBox("Please save your changes first.", imgMessage.INFO);
						return false;
					} else {
						return true;
					}
				},
				onSort: function(){
					setPDCForm(null);
					giacPdcPremCollns.setPdcDtlForm(null);
					selectedRowIndex = null;
					objCurrGIACApdcPaytDtl = null;
					objCurrGIACPdcPremColln = null;
					postDatedCheckDetailsTableGrid.clear();
					postDatedCheckDetailsTableGrid.empty();
					objGIACApdcPayt.clearAllTableGridFocus();
					objGIACApdcPayt.enableDisablePostDatedCheckForm();
				},				
				prePager: function(){
					if(changeTag == 1){
						showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", objGIACApdcPayt.initializeAcknowledgmentReceiptSaving, showAcknowledgementReceiptListing, "");
						return false;
					} else {
						setPDCForm(null);
						return true;
					}
				},
				beforeClick: function(){
					if(objGIACApdcPayt.pdcPremChangeTag == 1){
						showMessageBox("Please save your changes first.", imgMessage.INFO);
						return false;
					}
				},
				onCellFocus: function (element, value, x, y, id){
					/* if(changeTag == 1 || objGIACApdcPayt.pdcPremChangeTag == 1){
						showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", objGIACApdcPayt.initializeAcknowledgmentReceiptSaving, showAcknowledgementReceiptListing, "");
					} else { */
						var mtgId = postDatedChecksTableGrid._mtgId;		
						if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){						
							selectedRowIndex = y;
							if(y < 0){
								var length = postDatedChecksTableGrid.geniisysRows.length;
								y = ((length - 1) + Math.abs(y)) - postDatedChecksTableGrid.newRowsAdded.length;
							}
							objCurrGIACApdcPaytDtl = postDatedChecksTableGrid.geniisysRows[y];
							objCurrGIACApdcPaytDtl.rowIndex = selectedRowIndex;
							setPDCForm(objCurrGIACApdcPaytDtl);						
							postDatedCheckDetailsTableGrid.url = contextPath+"/GIACPdcPremCollnController?action=getGIACPdcPremCollnListing&pdcId="+objCurrGIACApdcPaytDtl.pdcId,
							postDatedCheckDetailsTableGrid._refreshList();
							/* if(giacPdcPremCollns.rows != undefined){
								for(var i=0; i<giacPdcPremCollns.rows.length; i++){
									if(giacPdcPremCollns.rows[i].pdcId == objCurrGIACApdcPaytDtl.pdcId && giacPdcPremCollns.rows[i].recordStatus != -1){
										postDatedCheckDetailsTableGrid.addRow(giacPdcPremCollns.rows[i]);
									}
								}
							} */
							giacPdcPremCollns.computeTotalCollnAmt();
							objGIACApdcPayt.enableDisablePostDatedCheckForm();
							checkLocalCurrency();
						}
						postDatedChecksTableGrid.keys.removeFocus(postDatedChecksTableGrid.keys._nCurrentFocus, true);
						postDatedChecksTableGrid.keys.releaseKeys();
					//}
				},
				onRemoveRowFocus: function (element, value, x, y, id){			
					setPDCForm(null);
					giacPdcPremCollns.setPdcDtlForm(null);
					selectedRowIndex = null;
					objCurrGIACApdcPaytDtl = null;
					objCurrGIACPdcPremColln = null;
					postDatedCheckDetailsTableGrid.clear();
					postDatedCheckDetailsTableGrid.empty();
					objGIACApdcPayt.clearAllTableGridFocus();
				},
				onRowDoubleClick: function (){

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
					id: 'itemNo',
					width: '45px',
					title: 'Item',
					align: 'right',
					renderer: function(value){
						return formatNumberDigits(value, 3);
					}
				},
				{
					id: 'bankCd',
					width: '0',
					visible: false
				},
				{
					id: 'bankName',
					width: '125px',
					title: 'Bank',
					filterOption: true
				},
				{
					id: 'bankBranch',
					width: '100px',
					title: 'Branch',
					filterOption: true
				},
				{
					id: 'checkClass',
					width: '0',
					visible: false
				},
				{
					id: 'checkClassDesc',
					width: '130px',
					title: 'Check Class'
				},
				{
					id: 'checkNo',
					width: '100px',
					align: 'right',
					title: 'Check No.'
				},
				{
					id: 'checkDate',
					width: '80px',
					title: 'Check Date',
					renderer : function(value){
	            		return dateFormat(value, "mm-dd-yyyy");
	            	}
				},
				{
					id: 'checkAmt',
					width: '100px',
					maxlength: 20,
					title: 'Amount',
					align: 'right',			
			        filterOption: true,
			        renderer: function(value){
			        	return formatCurrency(value);
			        }
				},
				{
					id: 'currencyCd',
					width: '0',
					visible: false
				} ,
				{
					id: 'currencyDesc',
					width: '100px',
					title: 'Currency',
					filterOption: true
				} ,
				{
					id: 'checkStatus',
					width: '100px',
					title: 'Status',
					filterOption: true
				}, //start of hidden fields */				
				{
					id: 'replaceDate',
					width: '0',
					visible: false
				},
				{
					id: 'grossAmt',
					width: '0',
					visible: false
				},
				{
					id: 'commissionAmt',
					width: '0',
					visible: false
				},
				{
					id: 'vatAmt',
					width: '0',
					visible: false
				},
				{
					id: 'currencyDesc',
					width: '0',
					visible: false
				},
				{
					id: 'currencyRt',
					width: '0',
					visible: false
				},
				{
					id: 'fcurrencyAmt',
					width: '0',
					visible: false
				},
				{
					id: 'payor',
					width: '0',
					visible: false
				},
				{
					id: 'address1',
					width: '0',
					visible: false
				},
				{
					id: 'address2',
					width: '0',
					visible: false
				},
				{
					id: 'address3',
					width: '0',
					visible: false
				},
				{
					id: 'tin',
					width: '0',
					visible: false
				},
				{
					id: 'intmNo',
					width: '0',
					visible: false
				},
				{
					id: 'intermediary',
					width: '0',
					visible: false
				},
				{
					id: 'particulars',
					width: '0',
					visible: false
				},
				{
					id: 'checkFlag',
					width: '0',
					visible: false
				},
				{
					id: 'pdcId',
					width: '0',
					visible: false
				},
				{
					id: 'gaccTranId',
					width: '0',
					visible: false
				},
				{
					id: 'changed',
					width: '0',
					visible: false
				}
			],
			rows: ackReceiptsJsonObject.apdcPaytDtl
		};
	
		postDatedChecksTableGrid = new MyTableGrid(postDatedChecksTableModel);
		postDatedChecksTableGrid.pager = ackReceiptsJsonObject.apdcPaytDtlTableGrid;
		postDatedChecksTableGrid.render('postDatedChecksTable');
		postDatedChecksTableGrid.afterRender = function(){ //Apollo 5.15.2014
			if(postDatedChecksTableGrid.geniisysRows.length > 0)
				enableButton("btnPrintApdc");
			else
				disableButton("btnPrintApdc");
		};

	function valPdcPremCollnChanges(){
		var withPremChanges = false;
		var setRows = getAddedAndModifiedJSONObjects(postDatedCheckDetailsTableGrid.geniisysRows);
		var delRows = getDeletedJSONObjects(postDatedCheckDetailsTableGrid.geniisysRows);
		if(setRows.length > 0 || delRows.length > 0) {
			withPremChanges = true;
		}
		return withPremChanges;
	}
		
	function validateCheckDate(date){
		var isValid = false;
		var apdcDate = "";
		var staleDate = "";
		var checkDate = "";

		if (date == ""){
			isValid = true;
		} else {
			if ($F("apdcDate") != "" && date != ""){
				//apdcDate = new Date($F("apdcDate"));
				apdcDate = Date.parse($F("apdcDate"), "mm-dd-yyyy");
				staleDate = Date.parse($F("apdcDate"), "mm-dd-yyyy");
				checkDate = Date.parse(date, "mm-dd-yyyy");
				staleDate = new Date(staleDate.setMonth(staleDate.getMonth() + (-1 * parseInt(giacs090variables.staleCheckVar))));

				if (checkDate <= staleDate){
					showMessageBox('This is a stale check.', imgMessage.ERROR);
					return false;
				} else if (checkDate > apdcDate){
					isValid = true;
				} else {
					showMessageBox('This is a dated check.', imgMessage.ERROR);				
					return false;
				}
					
			}

			var checkStaleDate = new Date(checkDate.setMonth(checkDate.getMonth() + (parseInt(giacs090variables.staleCheckVar))));
			var staleDaysNo = (checkStaleDate - apdcDate) / (1000 * 60 * 60 * 24);
	
			if (staleDaysNo <= giacs090variables.staleDaysVar){
				if (staleDaysNo == 1){
					showMessageBox('This check will be stale tomorrow.', imgMessage.INFO);
				} else {
					showMessageBox('This check will be stale within ' + staleDaysNo + ' days.', imgMessage.INFO);
				}
			}
			
		}
		
		return isValid;
	}

	function setForeignCurrency(currCd){
		for (var i = 0; i < $("foreignCurrency").length; i++){
			if ($("foreignCurrency").options[i].value == currCd){
				$("foreignCurrency").options.selectedIndex = i;
			}
		}

		var fcRt = postDatedChecksTableGrid.getValueAt(postDatedChecksTableGrid.getColumnIndex('currencyRt'), selectedPDCDtlsIndex);
		if (fcRt == ""){
			for (var i = 0; i < tempChkClassObj.currencyListingLOV.length; i++){
				if (tempChkClassObj.currencyListingLOV[i].code == currCd){
					var value = tempChkClassObj.currencyListingLOV[i].valueFloat;
					postDatedChecksTableGrid.setValueAt(value,postDatedChecksTableGrid.getColumnIndex('currencyRt'), selectedPDCDtlsIndex,true);
					$("foreignCurrencyRt").value = formatToNineDecimal(value);
				}
			}
		} else {
			$("foreignCurrencyRt").value = formatToNineDecimal(fcRt);
		}
	}
	
	function enableDisablePostDatedCheckForm(){
		try {
			var count = postDatedCheckDetailsTableGrid.rows.length;
			if(count > 0){
				$$("div#pdcDiv input[type='text'], div#pdcDiv textarea,div#pdcDiv select,div#pdcDiv img").each(function (input){					
					if(input instanceof HTMLSelectElement){
						input.disabled = true;
					} else if (input instanceof HTMLImageElement){
						if(input.src.include("search")){
							disableSearch(input.id);
						} else if(input.src.include("calendar")){
							disableDate(input.id);
						}
					} else {
						input.writeAttribute("readonly", "readonly");
					}
				});
				
				$$("div#pdcDtlsParticularsDiv input[type='text'], div#pdcDtlsParticularsDiv textarea").each(function (input){
					input.setAttribute("readonly", "readonly");
				});
			} else {
				$$("div#pdcDiv input[type='text'],div#pdcDiv textarea,div#pdcDiv select,div#pdcDiv img").each(function (input){					
					if(input instanceof HTMLSelectElement){
						input.disabled = false;
					} else if (input instanceof HTMLImageElement){
						if(input.src.include("search")){
							enableSearch(input.id);
						} else if(input.src.include("calendar")){
							enableDate(input.id);
						}
					} else {
						input.removeAttribute("readonly");
					}
				});
				
				$$("div#pdcDtlsParticularsDiv input[type='text'], div#pdcDtlsParticularsDiv textarea").each(function (input){
					input.removeAttribute("readonly");
				});
			}
		} catch(e) {
			showErrorMessage("enableDisablePostDatedCheckForm", e);
		}		
	}
	
	function enableDisablePDCForm(){
		if($("txtCheckFlag").readAttribute("checkFlag") == "C" || ($F("statusCd") == "P" && $("txtCheckFlag").readAttribute("checkFlag") == "A")) {
			disableButton("btnPdcDelete");
			disableButton("btnPdcAdd");
			//disableButton("btnPdcReplace");
			disableButton("btnPdcDtlDelete");
			disableButton("btnPdcDtlAdd");
			disableButton("btnUpdate");
			disableButton("btnSpecUpdate");
			
			$$("div#pdcDiv input[type='text'], div#pdcDiv textarea,div#pdcDiv select,div#pdcDiv img").each(function (input){					
				if(input instanceof HTMLSelectElement){
					input.disabled = true;
				} else if (input instanceof HTMLImageElement){
					if(input.src.include("search")){
						disableSearch(input.id);
					} else if(input.src.include("calendar")){
						disableDate(input.id);
					}
				} else {
					input.writeAttribute("readonly", "readonly");
				}
			});
			
			$$("div#pdcDtlsParticularsDiv input[type='text'], div#pdcDtlsParticularsDiv textarea").each(function (input){
				input.setAttribute("readonly", "readonly");
			});
			
			$$("div#premCollnFormDiv input[type='text'],div#premCollnFormDiv textarea,div#premCollnFormDiv select,div#premCollnFormDiv img").each(function (input){					
				if(input instanceof HTMLSelectElement){
					input.disabled = true;
				} else if (input instanceof HTMLImageElement){
					if(input.src.include("search")){
						disableSearch(input.id);
					} else if(input.src.include("calendar")){
						disableDate(input.id);
					}
				} else {
					input.writeAttribute("readonly", "readonly");
				}
			});
		} else {
			enableButton("btnPdcDelete");
			enableButton("btnPdcAdd");
			enableButton("btnPdcReplace");
			enableButton("btnPdcDtlDelete");
			enableButton("btnPdcDtlAdd");
			enableButton("btnUpdate");
			enableButton("btnSpecUpdate");
			
			$$("div#pdcDiv input[type='text'],div#pdcDiv textarea,div#pdcDiv select,div#pdcDiv img").each(function (input){					
				if(input instanceof HTMLSelectElement){
					input.disabled = false;
				} else if (input instanceof HTMLImageElement){
					if(input.src.include("search")){
						enableSearch(input.id);
					} else if(input.src.include("calendar")){
						enableDate(input.id);
					}
				} else {
					input.removeAttribute("readonly");
				}
			});
			
			$$("div#pdcDtlsParticularsDiv input[type='text'], div#pdcDtlsParticularsDiv textarea").each(function (input){
				input.removeAttribute("readonly");
			});
			
			if($F("txtParticularsDtl").trim() != ""){
				$("txtParticularsDtl").writeAttribute("readonly", "readonly");
			}
			
			$$("div#premCollnFormDiv input[type='text'], div#premCollnFormDiv textarea, div#premCollnFormDiv select, div#premCollnFormDiv img").each(function (input){			
				if(input instanceof HTMLSelectElement){
					input.disabled = false;
				} else if (input instanceof HTMLImageElement){
					if(input.src.include("search")){
						enableSearch(input.id);
					} else if(input.src.include("calendar")){
						enableDate(input.id);
					}
				} else {
					//input.removeAttribute("readonly"); // bonok :: 01.10.2013 UCPBGEN-QA SR: 11836
					//$("txtDtlCurrencyRt").removeAttribute("readonly");
					//$("txtDtlFCurrencyAmt").removeAttribute("readonly");
				}
			});
		}
		$("txtCheckDate").readOnly = true; //added by steven 9/27/2012
		$("txtBankName").readOnly = true; //added by steven 9/27/2012
		$("txtCheckFlag").readOnly = true; //added by steven 9/27/2012
		$("txtIntermediary").readOnly = true; //added by steven 9/27/2012
	}
	
	function setPDCForm(row){
		try {			
			$("hidPdcId").value = row == null ? "" : row.pdcId;
			//$("txtItemNo").value = row == null ? formatNumberDigits((postDatedChecksTableGrid.pager.total == undefined ? 1 : postDatedChecksTableGrid.pager.total+1),3) : formatNumberDigits(row.itemNo, 3); removed by jdiago 08.08.2014 : will be replaced with generateNextItemNo()
			$("txtItemNo").value = row == null ? formatNumberDigits(generateNextItemNo(itemNo.listOfItemNos),3) : formatNumberDigits(row.itemNo, 3); //added by jdiago 08.08.2014 : generateNextItemNo
			$("txtItemNo").writeAttribute("origItemNo", $F("txtItemNo"));
			$("hidBankCd").value = row == null ? "" : row.bankCd;
			$("txtBankName").value = row == null ? "" : unescapeHTML2(nvl(row.bankName,"")); //added by steven 9/27/2012
			$("txtBankBranch").value = row == null ? "" : unescapeHTML2(nvl(row.bankBranch,"")); //added by steven 9/27/2012
			$("selCheckClass").value = row == null ? "" : row.checkClass;						
			$("selCurrency").value = row == null ? defaultCurrency : row.currencyCd;
			$("txtCurrencyRt").value = row == null ? formatToNineDecimal($("selCurrency").options[$("selCurrency").selectedIndex].getAttribute("currencyRt")) : formatToNineDecimal(row.currencyRt);
			$("txtCheckNo").value = row == null ? "" : unescapeHTML2(nvl(row.checkNo,"")); //added by steven 9/27/2012
			$("txtCheckDate").value = row == null ? "" : dateFormat(row.checkDate, "mm-dd-yyyy");
			$("txtCheckDate").writeAttribute("origCheckDate", (row == null ? "" : dateFormat(row.checkDate, "mm-dd-yyyy")));
			$("txtCheckAmt").value = row == null ? "" : formatCurrency(row.checkAmt);
			$("txtCheckAmt").writeAttribute("origCheckAmt", (row == null ? "" : row.checkAmt));
			$("txtFCurrencyAmt").value = row == null ? "" : formatCurrency(row.fcurrencyAmt);
			$("txtFCurrencyAmt").writeAttribute("origFCurrencyAmt", (row == null ? "" : row.fcurrencyAmt)); //marco - 04.17.2013 
			$("txtGrossAmt").value = row == null ? "" : formatCurrency(row.grossAmt);
			$("txtGrossAmt").writeAttribute("origGrossAmt", (row == null ? "" : row.grossAmt));
			$("txtCommissionAmt").value = row == null ? "" : formatCurrency(row.commissionAmt);
			$("txtCommissionAmt").writeAttribute("origCommissionAmt", (row == null ? "" : row.commissionAmt));
			$("txtVatAmt").value = row == null ? "" : formatCurrency(row.vatAmt);
			$("txtVatAmt").writeAttribute("origVatAmt", (row == null ? "" : row.vatAmt));
			$("txtCheckFlag").value = row == null ? "New" : row.checkStatus;
			$("txtCheckFlag").writeAttribute("checkFlag", (row == null ? "N" : row.checkFlag));
			$("hidPdcPaytDtlOrFlag").value = row == null ? "" : row.orFlag;
			
			$("txtParticularsPayor").value = row == null ? "" : unescapeHTML2(nvl(row.payor,"")); //added by steven 9/27/2012
			$("txtAddress1").value = row == null ? "" : unescapeHTML2(nvl(row.address1,"")); //added by steven 9/27/2012
			$("txtAddress2").value = row == null ? "" : unescapeHTML2(nvl(row.address2,"")); //added by steven 9/27/2012
			$("txtAddress3").value = row == null ? "" : unescapeHTML2(nvl(row.address3,"")); //added by steven 9/27/2012
			$("txtTinNo").value = row == null ? "" : unescapeHTML2(nvl(row.tin,"")); //added by steven 9/27/2012
			$("hidIntmNo").value = row == null ? "" : row.intmNo;
			$("txtIntermediary").value = row == null ? "" : unescapeHTML2(nvl(row.intermediary,"")); //added by steven 9/27/2012
			$("txtParticularsDtl").value = row == null ? "" : unescapeHTML2(nvl(row.particulars,"")); //added by steven 9/27/2012
			
			$("btnPdcAdd").setAttribute("enValue", row == null ? "Add" : "Update");
			$("btnPdcAdd").value = row == null ? "Add" : "Update";
			//row != null && $F("statusCd") != "P"? enableButton("btnPdcCancel") : disableButton("btnPdcCancel");
			row != null ? enableButton("btnPdcCancel") : disableButton("btnPdcCancel"); //marco - SR 20105 - 11.24.2015 - removed statusCd condition
			if($F("statusCd") != "P" && $F("statusCd") != "C"){
				enableDisablePDCForm();
			}
			checkLocalCurrency();
			$("selDtlCurrency").setAttribute("disabled", "disabled");
		} catch (e){
			showErrorMessage("setPDCForm", e);
		}
	}
	
	function createPDC(obj){
		try {
			var pdc = (obj == null ? new Object() : obj);
			pdc.apdcId = objGIACApdcPayt == null ? null : objGIACApdcPayt.apdcId;
			pdc.pdcId = $F("hidPdcId") == "" ? null : $F("hidPdcId");
			pdc.itemNo = $F("txtItemNo");
			pdc.bankCd = $F("hidBankCd");
			pdc.bankName = escapeHTML2($F("txtBankName")); //added by steven 9/27/2012
			pdc.bankBranch = escapeHTML2($F("txtBankBranch")); //added by steven 9/27/2012
			pdc.checkClass = $("selCheckClass").value;
			pdc.checkClassDesc = $("selCheckClass").options[$("selCheckClass").selectedIndex].text;
			pdc.currencyCd = $F("selCurrency");
			pdc.currencyDesc = $("selCurrency").options[$("selCurrency").selectedIndex].text;
			pdc.currencyRt = $F("txtCurrencyRt");
			pdc.checkNo = escapeHTML2($F("txtCheckNo"));  //added by steven 9/27/2012
			pdc.checkDate = $F("txtCheckDate");
			pdc.checkAmt = $F("txtCheckAmt"); 
			pdc.fcurrencyAmt = $F("txtFCurrencyAmt");
			pdc.grossAmt = $F("txtGrossAmt");
			pdc.commissionAmt = $F("txtCommissionAmt");
			pdc.vatAmt = $F("txtVatAmt");
			pdc.checkStatus = $F("txtCheckFlag");
			pdc.checkFlag = $("txtCheckFlag").readAttribute("checkFlag");
			pdc.orFlag = $F("hidPdcPaytDtlOrFlag");
			
			pdc.payor = escapeHTML2($F("txtParticularsPayor")); //added by steven 9/27/2012
			pdc.address1 = escapeHTML2($F("txtAddress1")); //added by steven 9/27/2012
			pdc.address2 = escapeHTML2($F("txtAddress2")); //added by steven 9/27/2012
			pdc.address3 = escapeHTML2($F("txtAddress3")); //added by steven 9/27/2012
			pdc.tin = escapeHTML2($F("txtTinNo")); //added by steven 9/27/2012
			pdc.intmNo = $F("hidIntmNo");
			pdc.intermediary = escapeHTML2($F("txtIntermediary")); //added by steven 9/27/2012
			pdc.particulars = escapeHTML2($F("txtParticularsDtl"));	 //added by steven 9/27/2012
			if(pdc.pdcId == null){
				pdc.pdcId = generatePdcId();
			}
			
			return pdc;
		} catch (e){
			showErrorMessage("createPDC", e);
		}			
	}
	
	function addPDC(fromCancel){ //marco - SR-20105 - 11.20.2015 - added parameter
		try {
			var count = postDatedCheckDetailsTableGrid.rows.length;
			if(count > 0 && nvl(fromCancel, "N") != "Y"){
				showMessageBox("Post-Dated Check with existing Details record(s) cannot be updated.", "I");
				return;
			}
			
			function continueAddPdc(){//modified by jdiago 08.08.2014 : everything created as function.
				var pdc = createPDC();
				if($("btnPdcAdd").getAttribute("enValue") == "Add"){			
					//postDatedChecksTableGrid.addRow(pdc);			
					postDatedChecksTableGrid.addBottomRow(pdc);
				} else {
					postDatedChecksTableGrid.updateRowAt(pdc, selectedRowIndex);
				}
				objCurrGIACApdcPaytDtl = null;
				changeTag = 1;
				setPDCForm(null);
				postDatedCheckDetailsTableGrid.clear();
				postDatedCheckDetailsTableGrid.empty();	
			}
			
			if(checkAllRequiredFieldsInDiv("pdcDiv")){ //added by jdiago 08.08.2014 : validate if item no exists already.
				var proceed = true;
				
				for(var i=0; i<itemNo.listOfItemNos.rows.length; i++){
					if(itemNo.listOfItemNos.rows[i].itemNo == parseInt($F("txtItemNo"))){
						if(($F("btnPdcAdd") == "Update" && objCurrGIACApdcPaytDtl.itemNo != parseInt($F("txtItemNo"))) || ($F("btnPdcAdd") == "Add")){
							proceed = false;
						}
					}
				}
				
				if(proceed){
					if($F("btnPdcAdd") == "Add"){
						var rec = {};
						rec.itemNo = parseInt($F("txtItemNo"));
						itemNo.listOfItemNos.rows.push(rec);
					} else {
						for(var i=0; i<itemNo.listOfItemNos.rows.length; i++){
							if(itemNo.listOfItemNos.rows[i].itemNo == objCurrGIACApdcPaytDtl.itemNo){
								var rec = objCurrGIACApdcPaytDtl;
								rec.itemNo = parseInt($F("txtItemNo"));
								itemNo.listOfItemNos.rows.splice(i, 1, rec);
							}
						}
					}
					
					continueAddPdc();
				} else {
					showMessageBox("Record already exists with the same item_no.", "E");
				}
			}
		} catch (e){
			showErrorMessage("addPDC", e);
		}
	}
	
	function deletePDC(){ //modified by jdiago 08012014 : added validation of apdc
		try{
			new Ajax.Request(contextPath + "/GIACAcknowledgmentReceiptsController", {
				parameters : {
					action : "valDelApdc",
					pdcId : objCurrGIACApdcPaytDtl.pdcId,
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						deletePDCFinal();
					}
				}
			});
		} catch(e){
			showErrorMessage("deletePDC", e);
		}
		
		function deletePDCFinal(){ //modified by jdiago 08.08.2014 : everything created as a function
			if(selectedRowIndex != null) {
				for(var i=0; i<itemNo.listOfItemNos.rows.length; i++){
					if(itemNo.listOfItemNos.rows[i].itemNo == parseInt(objCurrGIACApdcPaytDtl.itemNo)){
						itemNo.listOfItemNos.rows.splice(i, 1);
					}
				}
				
				changeTag = 1;
				postDatedChecksTableGrid.deleteRow(selectedRowIndex);
				setPDCForm(null);
				giacPdcPremCollns.setPdcDtlForm(null);
				objCurrGIACApdcPaytDtl = null;
				postDatedCheckDetailsTableGrid.clear();
				postDatedCheckDetailsTableGrid.empty();
				objGIACApdcPayt.clearAllTableGridFocus();
			}	
		}
	}
	
	function cancelPDC(){
		if($("txtCheckFlag").readAttribute("checkFlag") == "C"){
			showMessageBox("This check is already cancelled.", imgMessage.INFO);
		//} else if ($F("hidPdcPaytDtlOrFlag") == "P" || $F("hidPdcPaytDtlOrFlag") == "N") { //marco - SR-20105 - 11.20.2015 - replaced
		} else if (nvl(objCurrGIACApdcPaytDtl.gaccTranId, "") != "" && ($F("hidPdcPaytDtlOrFlag") == "P" || $F("hidPdcPaytDtlOrFlag") == "N")) {
			showMessageBox("Please cancel the existing O.R. first.", imgMessage.INFO);
		} else if (changeTag == 1) {
			showMessageBox("Please save your changes first.", imgMessage.INFO);
		} else {
			showConfirmBox("Confirmation", "Please confirm cancellation of check. Continue?", "Yes", "No", 
				function(){
					$("txtCheckFlag").writeAttribute("checkFlag", "C");
					$("txtCheckFlag").value = "Cancelled";
					//fireEvent($("btnPdcAdd"), "click"); //marco - SR-20105 - 11.20.2015 - replaced
					addPDC("Y");
				},
				"");			
		}
	}
	
	function openReplacePDCModal(pdcRow){
		overlayPdcReplace = Overlay.show(contextPath+"/GIACPdcReplaceController", 
			{urlContent: true,
			 urlParameters: {action: "getGIACPdcReplaceListing",
			 			     pdcId : objCurrGIACApdcPaytDtl.pdcId},
			 title: "Replace",
			 height: 570, //modified by jdiago 08012014 : from 555 to 570
			 width: 900,
			 draggable: true
			});
	}
	
	function replacePDC(){
		if(objCurrGIACApdcPaytDtl == null){
			showMessageBox('Please select a post-dated check to be replaced.', imgMessage.INFO);
		} else if ($F("statusCd") == "C"){
			showMessageBox('Acknowledgment Receipt is already cancelled.', imgMessage.INFO);
		} else if ($F("statusCd") == "P" && objCurrGIACApdcPaytDtl.checkFlag == "A") {
			showMessageBox("Check is already applied.", imgMessage.INFO);
		} else if (changeTag == 1) {
			showMessageBox("Please save your changes first.", imgMessage.INFO);
		} else {
			var pdcRow = objCurrGIACApdcPaytDtl;
			openReplacePDCModal(pdcRow);
		}
	}
	
	function updateForeignCurrency(){
		if($F("txtCheckAmt") != "" && $F("txtCurrencyRt") != ""){
			$("txtFCurrencyAmt").value = formatCurrency(parseFloat(nvl($F("txtCheckAmt"), "0").replace(/,/g, "")) / parseFloat($F("txtCurrencyRt")));
		}
	}	
	
	function updateCheckAmt(amount){
		$("txtCheckAmt").value = formatCurrency(amount);
	}
	
	function onCurrencyChange(){
		checkLocalCurrency();
		$("txtCurrencyRt").value = formatToNineDecimal($("selCurrency").options[$("selCurrency").selectedIndex].getAttribute("currencyRt"));
		updateForeignCurrency();
	}
	
	//marco - 04.22.2013
	function checkLocalCurrency(){
		if(parseInt($("selCurrency").options[$("selCurrency").selectedIndex].getAttribute("value")) == defaultCurrency){
			disableInputField("txtCurrencyRt");
		}else{
			enableInputField("txtCurrencyRt");
		}
	}
	
	function showGIISIntmLOV(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action: "getGIISIntmLOV",
							page: 1},
			title: "Valid Values for Intermediary",
			width: 600,
			height: 400,
			columnModel : [
			               {
			            	   id : "intmNo",
			            	   title: "No.",
			            	   width: '50px',
			            	   align: 'right',
			            	   titleAlign: 'right'
			               },
			               {
			            	   id: "intmName",
			            	   title: "Name",
			            	   width: '250px'
			               },
			               {
			            	   id: "refIntmCd",
			            	   title: "Ref Intm No",
			            	   width: '80px'
			               },
			               {
			            	   id: "issCd",
			            	   title: "Issuing Source",
			            	   width: '100px'
			               },
			               {
			            	   id: "licTag",
			            	   title: "License Tag",
			            	   width: '90px'
			               }
			              ],
			draggable: true,
			onSelect: function(row) {
				$("txtIntermediary").value = unescapeHTML2(row.intmName); //marco - 04.15.2013 - unescape lang po
				$("hidIntmNo").value = row.intmNo;
			}
		});	
	}
	
	$("searchBank").observe("click", function(){
		if($('txtBankName').readAttribute('readonly') != 'readonly') {
			showGIACBankLOV("");
		}
	});
	$("searchIntm").observe("click", showGIISIntmLOV);	
	$("selCurrency").observe("change", onCurrencyChange);
	$("txtCheckAmt").observe("change", function() {
		if(parseFloat($F("txtCheckAmt").replace(/,/g, "")) < 0){
			showWaitingMessageBox("Check amount should be positive.", imgMessage.ERROR, 
					function(){
						$("txtCheckAmt").value = formatCurrency($("txtCheckAmt").readAttribute("origCheckAmt"));
						$("txtCheckAmt").focus();
					});
		} else if(parseFloat($F("txtCheckAmt").replace(/,/g, "")) == 0){
			showWaitingMessageBox("Check amount should be greater than zero.", imgMessage.ERROR, 
					function(){
						$("txtCheckAmt").value = formatCurrency($("txtCheckAmt").readAttribute("origCheckAmt"));
						$("txtCheckAmt").focus();
					});
		} else {
			$("txtCheckAmt").writeAttribute("origCheckAmt", $F("txtCheckAmt"));
			updateForeignCurrency();
			var amount = parseFloat($F("txtCheckAmt").replace(/,/g, ""));
			var comm = parseFloat(nvl($F("txtCommissionAmt"), "0").replace(/,/g, ""));
			var vat = parseFloat(nvl($F("txtVatAmt"), "0").replace(/,/g, ""));

			$("txtGrossAmt").value = formatCurrency(amount + comm + vat);
		}
	});
	
	$("txtGrossAmt").observe("change", function(){
		var amount = parseFloat(nvl($F("txtGrossAmt"), "0").replace(/,/g, "")) - parseFloat(nvl($F("txtVatAmt"), "0").replace(/,/g, "")) - parseFloat(nvl($F("txtCommissionAmt"), "0").replace(/,/g, ""));
		var message = "";
		if(parseFloat($F("txtGrossAmt").replace(/,/g, "")) < 0){
			message = "Gross amount should be positive.";			
		} else if(amount == 0){
			message = "Net amount should not be zero.";			
		} else if(amount < 0){
			message = "Net amount should not be negative.";			
		} 		
			
		if(message != ""){			
			showWaitingMessageBox(message, imgMessage.ERROR, 
				function(){
					$("txtGrossAmt").value = formatCurrency($("txtGrossAmt").readAttribute("origGrossAmt"));
					$("txtGrossAmt").focus();
				});
		} else {
			$("txtGrossAmt").writeAttribute("origGrossAmt", $F("txtGrossAmt"));
			updateCheckAmt(amount);
		}
	});
	
	$("txtCommissionAmt").observe("change", function(){
		var amount = parseFloat(nvl($F("txtGrossAmt"), "0").replace(/,/g, "")) - parseFloat(nvl($F("txtVatAmt"), "0").replace(/,/g, "")) - parseFloat(nvl($F("txtCommissionAmt"), "0").replace(/,/g, ""));
		var message = "";
		if(parseFloat($F("txtVatAmt").replace(/,/g, "")) >= parseFloat($F("txtCommissionAmt").replace(/,/g, ""))){
			message = "Commission amount should be larger than VAT amount.";			
		} else if(amount == 0){
			message = "Net amount should not be zero.";			
		} else if(amount < 0){
			message = "Net amount should not be negative.";			
		} 

		if(message != ""){
			showWaitingMessageBox(message, imgMessage.ERROR, 
				function(){
					$("txtCommissionAmt").value = formatCurrency($("txtCommissionAmt").readAttribute("origCommissionAmt"));
					$("txtCommissionAmt").focus();
				});
		} else {
			$("txtCommissionAmt").writeAttribute("origCommissionAmt", $F("txtCommissionAmt"));
			updateCheckAmt(amount);
			updateForeignCurrency(); //Added by carlo SR 23885 02-22-2017
		}
	});
	
	$("txtVatAmt").observe("change", function(){
		var amount = parseFloat(nvl($F("txtGrossAmt"), "0").replace(/,/g, "")) - parseFloat(nvl($F("txtVatAmt"), "0").replace(/,/g, "")) - parseFloat(nvl($F("txtCommissionAmt"), "0").replace(/,/g, ""));
		var message = "";
		if(parseFloat($F("txtVatAmt").replace(/,/g, "")) >= parseFloat($F("txtCommissionAmt").replace(/,/g, ""))){
			message = "VAT amount should be smaller than commission amount.";			
		} else if(amount == 0){
			message = "Net amount should not be zero.";			
		} else if(amount < 0){
			message = "Net amount should not be negative.";			
		} 		
			
		if(message != ""){
			showWaitingMessageBox(message, imgMessage.ERROR, 
				function(){
					$("txtVatAmt").value = formatCurrency($("txtVatAmt").readAttribute("origVatAmt"));
					$("txtVatAmt").focus();
				});		
		} else {
			$("txtVatAmt").writeAttribute("origVatAmt", $F("txtVatAmt"));
			updateCheckAmt(amount);
		}
	});
	
	$("txtCheckDate").observe("focus", function(){ //modified by jdiago 08.08.2014 : from blur to focus to fire immediate function.
		if(!validateCheckDate($F("txtCheckDate"))){
			$("txtCheckDate").focus();
			$("txtCheckDate").value = $("txtCheckDate").readAttribute("origCheckDate");
		} else {
			$("txtCheckDate").writeAttribute("origCheckDate", $F("txtCheckDate"));			
		}
	});
	
	$("txtItemNo").observe("change", function(){
		if(isNaN($F("txtItemNo").replace(/,/g, ""))){
			showWaitingMessageBox("Field must be of form 099.", imgMessage.INFO, 
				function(){
					$("txtItemNo").value = formatNumberDigits($("txtItemNo").readAttribute("origItemNo"), 3);
					$("txtItemNo").focus();
				});
		} else {
			$("txtItemNo").writeAttribute("origItemNo", $F("txtItemNo"));
			$("txtItemNo").value = formatNumberDigits($F("txtItemNo"), 3);			
		}
	});
	
	$("txtIntermediary").observe("keyup", function(event){
		if(event.keyCode == 46){
			$("txtIntermediary").value = "";
			$("hidIntmNo").value = "";
		}
	});
	
	//marco - 04.17.2013
	$("txtFCurrencyAmt").observe("change", function(){
		if(parseFloat($F("txtFCurrencyAmt").replace(/,/g, "")) < 0){
			showWaitingMessageBox("Check amount should be positive.", imgMessage.ERROR, 
				function(){
					$("txtFCurrencyAmt").value = formatCurrency($("txtFCurrencyAmt").readAttribute("origFCurrencyAmt"));
					$("txtFCurrencyAmt").focus();
				});
		}else if(parseFloat($F("txtFCurrencyAmt").replace(/,/g, "")) == 0){
			showWaitingMessageBox("Check amount should be greater than zero.", imgMessage.ERROR, 
				function(){
					$("txtFCurrencyAmt").value = formatCurrency($("txtFCurrencyAmt").readAttribute("origFCurrencyAmt"));
					$("txtFCurrencyAmt").focus();
				});
		}else{
			$("txtCheckAmt").writeAttribute("origCheckAmt", $F("txtCheckAmt"));
			var amount = parseFloat(nvl($F("txtFCurrencyAmt"), "0").replace(/,/g, "")) * parseFloat($F("txtCurrencyRt"));
			updateCheckAmt(amount);
			
			$("txtCheckAmt").writeAttribute("origCheckAmt", $F("txtCheckAmt"));
			amount = parseFloat($F("txtCheckAmt").replace(/,/g, ""));
			var comm = parseFloat(nvl($F("txtCommissionAmt"), "0").replace(/,/g, ""));
			var vat = parseFloat(nvl($F("txtVatAmt"), "0").replace(/,/g, ""));
			$("txtGrossAmt").value = formatCurrency(amount + comm + vat);
		}
	});
	
	//marco - 05.10.2013
	$("txtCurrencyRt").observe("change", function(){
		updateForeignCurrency();
	});
	
	function generateNextItemNo(listOfItemNos){ //created by jdiago 08.08.2014 : generate the next item no by max item no. plus 1.
		var itemNo = 0;
	    var lastIndex = postDatedChecksTableGrid.pager.total - 1;
	    
	    if(postDatedChecksTableGrid.pager.total == 0){
	    	itemNo = 1; 
	    } else {
	    	itemNo = listOfItemNos.rows[lastIndex].itemNo + 1;	
	    }
	    
	    return itemNo;
	}
	
	$("btnPdcAdd").observe("click", addPDC);
	$("btnPdcDelete").observe("click", deletePDC);
	$("btnPdcCancel").observe("click", cancelPDC);
	$("btnPdcReplace").observe("click", replacePDC);
	setPDCForm(null);	
	initializeAll();
	initializeAllMoneyFields();
	checkLocalCurrency(); //marco - 05.11.2013
	objCurrGIACApdcPaytDtl = null;
	objGIACApdcPayt.enableDisablePostDatedCheckForm = enableDisablePostDatedCheckForm;
} catch (e){
	showErrorMessage("postDatedChecks.jsp", e);
}
</script>