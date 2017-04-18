<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="replacePDCHdrDiv" name="replacePDCHdrDiv" style="float: left; margin-top: 5px; width: 99.5%; padding-bottom: 5px;" class="sectionDiv">
	<table align="center" border="0" style="width: 98%;">
		<tr>
			<td class="leftAligned" style="width: 20%;">Bank</td>
			<td class="rightAligned" style="width: 20%;">Check Number</td>
			<td class="rightAligned" style="width: 20%;">Amount</td>
			<td style="width: 15%;"></td>
			<td class="leftAligned" style="width: 20%;">Replace Date</td>
		</tr>
		<tr>
			<td class="leftAligned" style="width: 20%;"><input id="repPdcBank" name="repPdcBank" type="text" style="width: 95%;" disabled="disabled" value="${bank}"/></td>
			<td class="rightAligned" style="width: 20%;"><input id="repPdcCheckNo" name="repPdcCheckNo" type="text" style="width: 95%; text-align: right;" disabled="disabled" value="${checkNo}"/></td>
			<td class="rightAligned" style="width: 20%;"><input id="repPdcAmount" name="repPdcAmount" type="text" style="width: 95%; text-align: right;" disabled="disabled" value="<fmt:formatNumber pattern="#,###,##0.00" value="${amount}" />"/></td>
			<td style="width: 15%;"></td>
			<td class="leftAligned" style="width: 20%;"><input id="repPdcRepDate" name="repPdcRepDate" type="text" style="width: 95%;" disabled="disabled" value="${replaceDate}"/></td>
		</tr>
	</table>
</div>
<div id="pdcReplaceMainDiv" name="pdcReplaceMainDiv" class="sectionDiv" style="width: 99.5%; float: left;">	
	<div id="pdcReplaceTableDiv" name="pdcReplaceTableDiv" style="height: 175px; width: 100%; float: left;">
		<div id="pdcReplaceTable" name="pdcReplaceTable" style="float: left; width: 90%; margin: 5px; height: 140px;">	
		</div>
	</div>
	<div style="width: 100%; float: left; margin-bottom: 15px;">
		<label style="float: left; margin-left: 487px; height: 18px; padding-top: 3px;">Net Total</label>
		<input style="text-align: right; float: left; margin-left: 8px; width: 220px;" readonly="readonly" type="text" id="txtNetTotal" name="txtNetTotal"  tabindex="500"/>
	</div>
	<div id="repPdcDiv" name="repPdcDiv" style="float: left; width: 100%; margin-bottom: 5px;" align="center">
		<table style="float: left; margin-left: 60px;">
			<tr>
				<td class="rightAligned">Item</td>
				<td class="leftAligned">
					<input class="required" type="text" id="txtItemNoRep" name="txtItemNoRep" style="text-align: right; float: left; width: 100px;" tabindex="501">
				</td>
				<td class="rightAligned">Check Class</td>
				<td class="leftAligned">
					<select id="selCheckClassRep" name="selCheckClassRep" style="float: left; width: 228px;" class="" disabled="disabled" tabindex="508">
						<option></option>
						<c:forEach var="c" items="${checkClass}">					
							<option value="${c.rvLowValue}">${c.rvMeaning}</option>
						</c:forEach>
					</select>
				</td>						
			</tr>
			<tr>
				<td class="rightAligned">Pay Mode</td>
				<td class="leftAligned">
					<select id="selPayMode" name="selPayMode" style="float: left; width: 228px;" class="required" tabindex="502">
						<option></option>
						<c:forEach var="mode" items="${payMode}">
							<option value="${mode.rvLowValue}" >${mode.rvMeaning}</option>
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned">Check No.</td>
				<td class="leftAligned">  <!-- John Dolon; 5.25.2015; SR#17784; Error in replacing Checks with Cash payment -->
					<span id="checkRepNoSpan" class="required lovSpan" style="width: 226px; margin-right: 30px;">
						<input type="text" id="txtCheckNoRep" name="txtCheckNoRep" style="width: 201px; float: left; border: none; height: 14px; margin: 0;" class="required" tabindex="503" maxlength="25"></input> <!-- Dren 10.01.2015 SR 0020251 : Removed readonly="readonly" so user can edit the Check Number--> <!-- Dren 10.13.2015 SR 0005024 : Limit Check No to 25 characters. -->   
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchCheckRepNo" name="searchCheckRepNo" alt="Go" style="float: right;"/>
					</span>
				</td>
				<!-- <td class="leftAligned"><input class="" type="text" id="txtCheckNoRep" name="txtCheckNoRep" style="float: left; width: 220px; text-align: right;" tabindex="509" disabled="disabled"></td> -->
			</tr>
			<tr>
				<td class="rightAligned">Bank</td>
				<td class="leftAligned">
					<span id="bankSpan" class="required lovSpan" style="width: 226px; margin-right: 30px;"> <!-- John Dolon; 5.25.2015; SR#17784; Error in replacing Checks with Cash payment -->
						<input type="hidden" id="hidBankCdRep" name="hidBankCdRep">
						<input type="text" id="txtBankNameRep" name="txtBankNameRep" style="width: 201px; float: left; border: none; height: 14px; margin: 0;" class="required" readonly="readonly" tabindex="503"></input>  
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBankRep" name="btnSearchBankRep" alt="Go" style="float: right;"/>
					</span>
				</td>			
				<td class="rightAligned">Check Date</td>
				<td class="leftAligned">
					<div id="repCheckDateDiv" name="repCheckDateDiv" class="" style="float:left; border: solid 1px gray; width: 225px; height: 20px; margin-right:3px;">
				    	<input class="" style="width: 201px; border: none; height: 12px; margin: 0; float: left;" id="txtCheckDateRep" name="txtCheckDateRep" type="text" value="" readonly="readonly"  tabindex="510" disabled="disabled"/>
				    	<img id="hrefCheckDateRep" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"	alt="Check Date" onClick="scwShow($('txtCheckDateRep'),this, null)" class="hover"/>
					</div>						
			</tr>
			<tr>
				<td class="rightAligned">Currency</td>
				<td class="leftAligned">
					<select id="selCurrencyRep" name="selCurrencyRep" style="float: left; width: 228px;" class="required" tabindex="504">
						<option></option>
						<c:forEach var="curr" items="${currency}">
							<option value="${curr.code}" currencyRt="${curr.valueFloat}">${curr.desc}</option>
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned">Amount</td>
				<td class="leftAligned"><input type="text" class="money required" id="txtAmount" name="txtAmount" style="float: left; width: 220px; text-align: right;" tabindex="511"></td>						
			</tr>
			<tr>
				<td class="rightAligned">Currency Rate</td>
				<td class="leftAligned"><input type="text" id="txtCurrencyRtRep" name="txtCurrencyRtRep" style="float: left; width: 220px; text-align: right;" readonly="readonly" tabindex="505"></td>
				<td class="rightAligned">Gross Amount</td>
				<td class="leftAligned"><input type="text" class="money" id="txtGrossAmtRep" name="txtGrossAmtRep" style="float: left; width: 220px; text-align: right;" tabindex="512"></td>				
			</tr>
			<tr>
				<td class="rightAligned">Foreign Currency Amt.</td>
				<td class="leftAligned"><input type="text" id="txtFCurrencyAmtRep" name="txtFCurrencyAmtRep" style="float: left; width: 220px; text-align: right;" readonly="readonly" tabindex="506"></td>
				<td class="rightAligned">Comm. Amount</td>
				<td class="leftAligned"><input type="text" class="money" id="txtCommissionAmtRep" name="txtCommissionAmtRep" style="float: left; width: 220px; text-align: right;" tabindex="513"></td>				
			</tr>			
			<tr>
				<td class="rightAligned">OR No./APDC No.</td>
				<td class="leftAligned">
					<input type="text" id="txtRefNo" name="txtRefNo" style="float: left; width: 220px;" tabindex="507">
				</td>
				<td class="rightAligned">VAT Amount</td>
				<td class="leftAligned"><input type="text" class="money" id="txtVatAmtRep" name="txtVatAmtRep" style="float: left; width: 220px; text-align: right;" tabindex="514"></td>								
			</tr>
		</table>				
	</div>
	<div style="margin-top: 5px; margin-bottom: 10px; float: left; width: 100%;" align="center">
		<input type="button" class="button" id="btnPdcAddRep" name="btnPdcAddRep" value="Add" enValue="Add" tabindex="508"/>
		<input type="button" class="button" id="btnPdcDeleteRep" name="btnPdcDeleteRep" value="Delete" enValue="Delete" tabindex="509"/>
	</div>
</div>
<div style="margin-top: 10px; margin-bottom: 10px; float: left; width: 100%;" align="center">
	<input type="button" class="button" id="btnPdcOkRep" name="btnPdcOkRep" value="Ok" enValue="Ok" tabindex="510"/>
	<input type="button" class="button" id="btnPdcCancelRep" name="btnPdcCancelRep" value="Cancel" enValue="Cancel" tabindex="511"/>
</div>
<script type="text/javascript">
try{
	$("btnPdcCancelRep").observe("click", function(){
		overlayPdcReplace.close();
	});
	
	$("searchCheckRepNo").hide(); //John Dolon; 5.25.2015; SR#17784; Error in replacing Checks with Cash payment
	
	objCurrGIACPdcReplace = new Object();
	var selectedRowRepIndex;
	
	tgGIACPdcReplace = JSON.parse('${pdcReplaceTableGrid}'.replace(/\\/g, '\\\\'));

	var postDatedChecksTableModel = {
		url: contextPath+"/GIACPdcReplaceController?action=getGIACPdcReplaceListing&refresh=1&pdcId="+objCurrGIACApdcPaytDtl.pdcId,
		options: { 
			validateChangesOnPrePager : false,
			width: '885px',				
			beforeSort: function(){
				if(changeTag == 1){
					showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", objGIACApdcPayt.initializeAcknowledgmentReceiptSaving, showAcknowledgementReceiptListing, "");
					return false;
				} else {
					return true;
				}
			},
			prePager: function(){
				if(changeTag == 1){
					showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", objGIACApdcPayt.initializeAcknowledgmentReceiptSaving, showAcknowledgementReceiptListing, "");
					//showMessageBox("Please save your changes first.", imgMessage.INFO);
					return false;
				} else {
					return true;
				}
			},				
			onCellFocus: function (element, value, x, y, id){
				var mtgId = tgPdcReplace._mtgId;		
				if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){						
					selectedRowIndex = y;
					if(y < 0){
						var length = tgPdcReplace.geniisysRows.length;
						y = ((length - 1) + Math.abs(y)) - tgPdcReplace.newRowsAdded.length;
					}
					objCurrGIACPdcReplace = tgPdcReplace.geniisysRows[y];
					objCurrGIACPdcReplace.rowIndex = selectedRowIndex;
					setPdcRepForm(objCurrGIACPdcReplace);
					onPayModeChange(); //kenneth 12.02.2015 for additional findings of SR 20251
				}
				tgPdcReplace.keys.removeFocus(tgPdcReplace.keys._nCurrentFocus, true);
				tgPdcReplace.keys.releaseKeys();
			},
			onRemoveRowFocus: function (element, value, x, y, id){			
				setPdcRepForm(null);
				giacPdcPremCollns.setPdcDtlForm(null);
				selectedRowIndex = null;
				objCurrGIACPdcReplace = null;
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
							width: '40px',
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
							id: 'payMode',
							width: '120px',
							title: 'Pay Mode'
						},
						{
							id: 'bankName',
							width: '115px',
							title: 'Bank',
							filterOption: true
						},
						{
							id: 'checkClass',
							width: '0',
							visible: false
						},
						{
							id: 'checkClassDesc',
							width: '120px',
							title: 'Check Class'
						},
						{
							id: 'checkNo',
							width: '90px',
							align: 'right',
							title: 'Check No.'
						},
						{
							id: 'checkDate',
							width: '70px',
							title: 'Check Date',
							renderer : function(value){
			            		return dateFormat(value, "mm-dd-yyyy");
			            	}
						},
						{
							id: 'amount',
							width: '90px',
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
							width: '90px',
							title: 'Currency',
							filterOption: true
						} ,
						{
							id: 'refNo',
							width: '100px',
							title: 'OR No./APDC No.',
							filterOption: true
						}, //start of hidden fields */				
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
							id: 'pdcId',
							width: '0',
							visible: false
						}
		],
		rows: tgGIACPdcReplace.rows || []
	};

	tgPdcReplace = new MyTableGrid(postDatedChecksTableModel);
	tgPdcReplace.pager = tgGIACPdcReplace;
	tgPdcReplace.render('pdcReplaceTable');
	
	function replacePdc(){
		new Ajax.Request(contextPath + "/GIACPdcReplaceController", {
			method: "POST",
			parameters : {action : "saveGIACPdcReplace",
						  setRows : prepareJsonAsParameter(getAddedAndModifiedJSONObjects(tgPdcReplace.geniisysRows))},
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					postDatedChecksTableGrid._refreshList();
					postDatedCheckDetailsTableGrid.clear();
					postDatedCheckDetailsTableGrid.empty();
				}
			}
		});
	}
	
	function confirmReplacePdc(){
		if(objCurrGIACApdcPaytDtl.checkFlag == "R"){
			overlayPdcReplace.close();
		} else {
			if($F("txtNetTotal") != $F("repPdcAmount")){
				showMessageBox("Total amount should be equal to the check amount of the PDC.", imgMessage.INFO);
				return false;
			} else {
				showConfirmBox4("Confirmation", "Please confirm replacement of check. Continue?", "Yes", "No", "Cancel", 
					function(){
						replacePdc();
						overlayPdcReplace.close();
					}, 
					function(){
						overlayPdcReplace.close();
					}, "");
			}
		}
	}
	
	function computeNetTotal(){	
		var total = 0;
		
		for (var i=0; i<tgPdcReplace.geniisysRows.length; i++){
			if(tgPdcReplace.geniisysRows[i].recordStatus != -1){
				var val = tgPdcReplace.geniisysRows[i].amount;
				total += parseFloat(val.replace(/,/g, ''));
			}			
		}
		$("txtNetTotal").value = formatCurrency(total);
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
	
	function setPdcRepForm(row){
		try {			
			//$("txtItemNoRep").value = row == null ? formatNumberDigits((tgPdcReplace.pager.total == undefined ? 1 : tgPdcReplace.pager.total+1),3) : formatNumberDigits(row.itemNo, 3); //removed by jdiago 08.11.2014
			$("txtItemNoRep").value = row == null ? formatNumberDigits(generateNextItemNoRep(),3) : formatNumberDigits(row.itemNo, 3); //added by jdiago 08.11.2014
			$("txtItemNoRep").writeAttribute("origItemNo", $F("txtItemNoRep"));
			$("hidBankCdRep").value = row == null ? "" : row.bankCd;
			$("txtBankNameRep").value = row == null ? "" : row.bankName;
			$("selPayMode").value = row == null ? "" : row.payMode;
			$("selCheckClassRep").value = row == null ? "" : row.checkClass;
			$("selCurrencyRep").value = row == null ? objGIACApdcPayt.defaultCurrency : row.currencyCd;
			$("txtCurrencyRtRep").value = row == null ? formatToNineDecimal($("selCurrencyRep").options[$("selCurrencyRep").selectedIndex].getAttribute("currencyRt")) : formatToNineDecimal(row.currencyRt);
			$("txtCheckNoRep").value = row == null ? "" : row.checkNo;
			$("txtCheckDateRep").value = row == null ? "" : dateFormat(row.checkDate, "mm-dd-yyyy");
			$("txtCheckDateRep").writeAttribute("origCheckDate", (row == null ? "" : dateFormat(row.checkDate, "mm-dd-yyyy")));
			$("txtAmount").value = row == null ? "" : formatCurrency(row.amount);
			$("txtAmount").writeAttribute("origAmount", (row == null ? "" : row.amount));
			$("txtFCurrencyAmtRep").value = row == null ? "" : formatCurrency(row.fcurrencyAmt);
			$("txtGrossAmtRep").value = row == null ? "" : formatCurrency(row.grossAmt);
			$("txtGrossAmtRep").writeAttribute("origGrossAmt", (row == null ? "" : row.grossAmt));
			$("txtCommissionAmtRep").value = row == null ? "" : formatCurrency(row.commissionAmt);
			$("txtCommissionAmtRep").writeAttribute("origCommissionAmt", (row == null ? "" : row.commissionAmt));
			$("txtVatAmtRep").value = row == null ? "" : formatCurrency(row.vatAmt);
			$("txtVatAmtRep").writeAttribute("origVatAmt", (row == null ? "" : row.vatAmt));
			$("txtRefNo").value = row == null ? "" : row.refNo;
			$("txtRefNo").writeAttribute("refNo", (row == null ? "" : row.refNo));
						
			$("btnPdcAddRep").setAttribute("enValue", row == null ? "Add" : "Update");
			$("btnPdcAddRep").value = row == null ? "Add" : "Update";			
		} catch (e){
			showErrorMessage("setPdcRepForm", e);
		}
	}
	
	function createPdcReplace(obj){
		try {
			var pdc = (obj == null ? new Object() : obj);
			pdc.apdcId = objGIACApdcPayt == null ? null : objGIACApdcPayt.apdcId;
			pdc.pdcId = objCurrGIACApdcPaytDtl == null ? null : objCurrGIACApdcPaytDtl.pdcId;
			pdc.itemNo = $F("txtItemNoRep");
			pdc.bankCd = $F("hidBankCdRep");
			pdc.bankName = $F("txtBankNameRep");
			pdc.payMode = $F("selPayMode");
			pdc.checkClass = $("selCheckClassRep").value;
			pdc.checkClassDesc = $("selCheckClassRep").options[$("selCheckClassRep").selectedIndex].text;
			pdc.currencyCd = $F("selCurrencyRep");
			pdc.currencyDesc = $("selCurrencyRep").options[$("selCurrencyRep").selectedIndex].text;
			pdc.currencyRt = $F("txtCurrencyRtRep");
			pdc.checkNo = $F("txtCheckNoRep");
			pdc.checkDate = $F("txtCheckDateRep");
			pdc.amount = $F("txtAmount"); 
			pdc.fcurrencyAmt = $F("txtFCurrencyAmtRep");
			pdc.grossAmt = $F("txtGrossAmtRep");
			pdc.commissionAmt = $F("txtCommissionAmtRep");
			pdc.vatAmt = $F("txtVatAmtRep");
			pdc.refNo = $F("txtRefNo");
			
			return pdc;
		} catch (e){
			showErrorMessage("createPdcReplace", e);
		}			
	}
	
	function addPdcReplace(){ //modified by jdiago 08.11.2014 : checking of item no.
		try {
			if(checkAllRequiredFieldsInDiv("repPdcDiv")){
				var existTag = "N";
				for(var i=0; i<tgPdcReplace.geniisysRows.length; i++){
					if(tgPdcReplace.geniisysRows[i].itemNo == $F("txtItemNoRep") && tgPdcReplace.geniisysRows[i].recordStatus != -1){
						existTag = "Y";
					}
				}
				
				if(existTag == "N"){
					var pdc = createPdcReplace();
					if($("btnPdcAddRep").getAttribute("enValue") == "Add"){			
						tgPdcReplace.addBottomRow(pdc); //modified by jdiago 08.11.2014 : from .add to .addBottomRow			
					} else {
						tgPdcReplace.updateRowAt(pdc, selectedRowIndex);
					}
					
					setPdcRepForm(null);
					computeNetTotal();	
				} else {
					showMessageBox("Record already exists with the same item_no.", "E");
				}
			}						
		} catch (e){
			showErrorMessage("addPdcReplace", e);
		}
	}
	
	function deletePdcReplace(){
		if(selectedRowIndex != null) {
			objCurrGIACPdcReplace.recordStatus = -1; //added by jdiago 08.11.2014 
			tgPdcReplace.deleteRow(selectedRowIndex);
			setPdcRepForm(null);
			objCurrGIACPdcReplace = null;
			computeNetTotal();
		}
	}
	
	function updateForeignCurrency(){
		if($F("txtAmount") != "" && $F("txtCurrencyRtRep") != ""){
			$("txtFCurrencyAmtRep").value = formatCurrency(parseFloat(nvl($F("txtAmount"), "0").replace(/,/g, "")) / parseFloat($F("txtCurrencyRtRep")));
		}
	}	
	
	function updateCheckAmt(amount){
		$("txtAmount").value = formatCurrency(amount);
	}
	
	function initializePdcRepForm(){
		if(objCurrGIACApdcPaytDtl.checkFlag == "R") {
			disableButton("btnPdcDeleteRep");
			disableButton("btnPdcAddRep");
			
			$$("div#repPdcDiv input[type='text'], div#repPdcDiv textarea,div#repPdcDiv select,div#repPdcDiv img").each(function (input){					
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
		}
		$("repPdcBank").value = objCurrGIACApdcPaytDtl.bankName;
		$("repPdcCheckNo").value = objCurrGIACApdcPaytDtl.checkNo;
		$("repPdcAmount").value = formatCurrency(objCurrGIACApdcPaytDtl.checkAmt);
		$("repPdcRepDate").value = objCurrGIACApdcPaytDtl.replaceDate != null ? dateFormat(objCurrGIACApdcPaytDtl.replaceDate, "mm-dd-yyyy") : "";
		
		$("selCurrencyRep").innerHTML = $("selCurrency").innerHTML;
		$("selCheckClassRep").innerHTML = $("selCheckClass").innerHTML;
	}
	
	function onCurrencyChange(){
		$("txtCurrencyRtRep").value = formatToNineDecimal($("selCurrencyRep").options[$("selCurrencyRep").selectedIndex].getAttribute("currencyRt"));
		updateForeignCurrency();
	}
	
	function onPayModeChange(){
		var payMode = $F("selPayMode");
		/*if(payMode == "CHK" || payMode == "PDC"){ //John Dolon; 5.25.2015; SR#17784; Error in replacing Checks with Cash payment
			$("selCheckClassRep").disabled = false;
			$("txtCheckNoRep").disabled = false;			
			$("txtCheckDateRep").disabled = false;
			$("repCheckDateDiv").disabled = false;			
			$("selCheckClassRep").addClassName("required");
			$("txtCheckNoRep").addClassName("required");
			$("txtCheckDateRep").addClassName("required");
			$("repCheckDateDiv").addClassName("required");
		} else{
			$("selCheckClassRep").value = "";
			$("txtCheckNoRep").value = "";
			$("txtCheckDateRep").value = "";
			$("selCheckClassRep").removeClassName("required");
			$("txtCheckNoRep").removeClassName("required");
			$("txtCheckDateRep").removeClassName("required");
			$("repCheckDateDiv").removeClassName("required");
			$("selCheckClassRep").disabled = true;
			$("txtCheckNoRep").disabled = true;
			$("txtCheckDateRep").disabled = true;
			$("repCheckDateDiv").disabled = true;			
		}*/
		//John Dolon; 5.25.2015; SR#17784; Error in replacing Checks with Cash payment
		if(payMode == "CA" || payMode == "CW"){
			//bank
			$("txtBankNameRep").value = "";
			$("bankSpan").removeClassName("required");
			$("txtBankNameRep").removeClassName("required");
			$("txtBankNameRep").disabled = true;	
			disableSearch("searchBankRep");
			//check class
			$("selCheckClassRep").value = "";
			$("selCheckClassRep").removeClassName("required");
			$("selCheckClassRep").disabled = true;
			//check no
			$("txtCheckNoRep").value = "";
			$("txtCheckNoRep").removeClassName("required");
			$("checkRepNoSpan").removeClassName("required");
			$("txtCheckNoRep").disabled = true;	
			$("checkRepNoSpan").disabled = true;
			$("searchCheckRepNo").hide();
			//check date
			$("txtCheckDateRep").value = "";
			$("repCheckDateDiv").removeClassName("required");
			$("txtCheckDateRep").removeClassName("required");
			$("txtCheckDateRep").disabled = true;	
			disableDate("hrefCheckDateRep");
		} else if (payMode == "CC"){
			//bank
			$("txtBankNameRep").value = "";
			$("bankSpan").addClassName("required");
			$("txtBankNameRep").addClassName("required");
			$("txtBankNameRep").disabled = false;	
			enableSearch("searchBankRep");
			//check class
			$("selCheckClassRep").value = "";
			$("selCheckClassRep").removeClassName("required");
			$("checkRepNoSpan").removeClassName("required");
			$("selCheckClassRep").disabled = true;
			//check no
			$("txtCheckNoRep").value = "";
			$("txtCheckNoRep").disabled = false;
			$("txtCheckNoRep").addClassName("required");
			$("checkRepNoSpan").addClassName("required");
			$("searchCheckRepNo").hide();
			//check date
			$("txtCheckDateRep").value = "";
			$("repCheckDateDiv").removeClassName("required");
			$("txtCheckDateRep").removeClassName("required");
			$("txtCheckDateRep").disabled = true;	
			disableDate("hrefCheckDateRep");
		} else if (payMode == "CM" || payMode == "WT"){
			//bank
			$("txtBankNameRep").value = "";
			$("bankSpan").addClassName("required");
			$("txtBankNameRep").addClassName("required");
			$("txtBankNameRep").disabled = false;	
			enableSearch("searchBankRep");
			//check class
			$("selCheckClassRep").value = "";
			$("selCheckClassRep").removeClassName("required");
			$("selCheckClassRep").disabled = true;
			//check no
			$("txtCheckNoRep").value = "";
			$("txtCheckNoRep").disabled = false;
			$("txtCheckNoRep").removeClassName("required");
			$("checkRepNoSpan").removeClassName("required");
			$("searchCheckRepNo").hide();
			//check date
			$("txtCheckDateRep").value = "";
			$("repCheckDateDiv").removeClassName("required");
			$("txtCheckDateRep").removeClassName("required");
			$("txtCheckDateRep").disabled = false;	
			enableDate("hrefCheckDateRep");
		} else if (payMode == "CMI"){ //john --to add lov for check no when CMI
			//bank
			$("txtBankNameRep").value = "";
			$("bankSpan").removeClassName("required");
			$("txtBankNameRep").removeClassName("required");
			$("txtBankNameRep").disabled = true;	
			disableSearch("searchBankRep");
			//check class
			$("selCheckClassRep").value = "";
			$("selCheckClassRep").removeClassName("required");
			$("selCheckClassRep").disabled = true;
			//check no
			$("txtCheckNoRep").value = "";
			$("txtCheckNoRep").disabled = false;
			$("txtCheckNoRep").addClassName("required");
			$("checkRepNoSpan").addClassName("required");
			$("searchCheckRepNo").show();
			//check date
			$("txtCheckDateRep").value = "";
			$("repCheckDateDiv").addClassName("required");
			$("txtCheckDateRep").addClassName("required");
			$("txtCheckDateRep").disabled = false;	
			enableDate("hrefCheckDateRep");
		} else if(payMode == "RCM"){ //john --to add lov for check no when RCM
			//bank
			$("txtBankNameRep").value = "";
			$("bankSpan").removeClassName("required");
			$("txtBankNameRep").removeClassName("required");
			$("txtBankNameRep").disabled = true;	
			disableSearch("searchBankRep");
			//check class
			$("selCheckClassRep").value = "";
			$("selCheckClassRep").removeClassName("required");
			$("selCheckClassRep").disabled = true;
			//check no
			$("txtCheckNoRep").value = "";
			$("txtCheckNoRep").disabled = false;
			$("txtCheckNoRep").addClassName("required");
			$("checkRepNoSpan").addClassName("required");
			$("searchCheckRepNo").show();
			//check date
			$("txtCheckDateRep").value = "";
			$("repCheckDateDiv").addClassName("required");
			$("txtCheckDateRep").addClassName("required");
			$("txtCheckDateRep").disabled = false;	
			enableDate("hrefCheckDateRep");
		} else {
			//bank
			$("txtBankNameRep").value = "";
			$("bankSpan").addClassName("required");
			$("txtBankNameRep").addClassName("required");
			$("txtBankNameRep").disabled = false;	
			enableSearch("searchBankRep");
			//check class
			$("selCheckClassRep").value = "";
			$("selCheckClassRep").addClassName("required");
			$("selCheckClassRep").disabled = false;
			//check no
			$("txtCheckNoRep").value = "";
			$("txtCheckNoRep").addClassName("required");
			$("checkRepNoSpan").addClassName("required");
			$("txtCheckNoRep").disabled = false;	
			//check date
			$("txtCheckDateRep").value = "";
			$("repCheckDateDiv").addClassName("required");
			$("txtCheckDateRep").addClassName("required");
			$("txtCheckDateRep").disabled = false;	
			enableDate("hrefCheckDateRep");
		}
	}
	
	$("searchBankRep").observe("click", function(){
		showGIACBankLOV("Rep");
	});
	$("selCurrencyRep").observe("change", onCurrencyChange);
	$("txtAmount").observe("change", function() {
		if(parseFloat($F("txtAmount").replace(/,/g, "")) < 0){
			showWaitingMessageBox("Check amount should be positive.", imgMessage.ERROR, 
					function(){
						$("txtAmount").value = formatCurrency($("txtAmount").readAttribute("origAmount"));
						$("txtAmount").focus();
					});
		} else if(parseFloat($F("txtAmount").replace(/,/g, "")) == 0){
			showWaitingMessageBox("Check amount should be greater than zero.", imgMessage.ERROR, 
					function(){
						$("txtAmount").value = formatCurrency($("txtAmount").readAttribute("origAmount"));
						$("txtAmount").focus();
					});
		} else {
			$("txtAmount").writeAttribute("origAmount", $F("txtAmount"));
			updateForeignCurrency();
			var amount = parseFloat($F("txtAmount").replace(/,/g, ""));
			var comm = parseFloat(nvl($F("txtCommissionAmtRep"), "0").replace(/,/g, ""));
			var vat = parseFloat(nvl($F("txtVatAmtRep"), "0").replace(/,/g, ""));
			
			$("txtGrossAmtRep").value = formatCurrency(amount + comm + vat);
		}
	});
	
	$("txtGrossAmtRep").observe("change", function(){
		var amount = parseFloat(nvl($F("txtGrossAmtRep"), "0").replace(/,/g, "")) - parseFloat(nvl($F("txtVatAmtRep"), "0").replace(/,/g, "")) - parseFloat(nvl($F("txtCommissionAmtRep"), "0").replace(/,/g, ""));
		var message = "";
		if(parseFloat($F("txtGrossAmtRep").replace(/,/g, "")) < 0){
			message = "Gross amount should be positive.";			
		} else if(amount == 0){
			message = "Net amount should not be zero.";			
		} else if(amount < 0){
			message = "Net amount should not be negative.";			
		} 			
		
		if(message != ""){
			showWaitingMessageBox(message, imgMessage.ERROR, 
				function(){
					$("txtGrossAmtRep").value = formatCurrency($("txtGrossAmtRep").readAttribute("origGrossAmt"));
					$("txtGrossAmtRep").focus();
				});
		} else {
			$("txtGrossAmtRep").writeAttribute("origGrossAmt", $F("txtGrossAmtRep"));
			updateCheckAmt(amount);
		}
	});
	
	$("txtCommissionAmtRep").observe("change", function(){
		var amount = parseFloat(nvl($F("txtGrossAmtRep"), "0").replace(/,/g, "")) - parseFloat(nvl($F("txtVatAmtRep"), "0").replace(/,/g, "")) - parseFloat(nvl($F("txtCommissionAmtRep"), "0").replace(/,/g, ""));
		var message = "";
		if(parseFloat($F("txtVatAmtRep").replace(/,/g, "")) >= parseFloat($F("txtCommissionAmtRep").replace(/,/g, ""))){
			message = "Commission amount should be larger than VAT amount.";			
		} else if(amount == 0){
			message = "Net amount should not be zero.";			
		} else if(amount < 0){
			message = "Net amount should not be negative.";			
		} 
		
		if(message != ""){
			showWaitingMessageBox(message, imgMessage.ERROR, 
				function(){
					$("txtCommissionAmtRep").value = formatCurrency($("txtCommissionAmtRep").readAttribute("origCommissionAmt"));
					$("txtCommissionAmtRep").focus();
				});
		} else {
			$("txtCommissionAmtRep").writeAttribute("origCommissionAmt", $F("txtCommissionAmtRep"));
			updateCheckAmt(amount);
		}
	});
	
	$("txtVatAmtRep").observe("change", function(){
		var amount = parseFloat(nvl($F("txtGrossAmtRep"), "0").replace(/,/g, "")) - parseFloat(nvl($F("txtVatAmtRep"), "0").replace(/,/g, "")) - parseFloat(nvl($F("txtCommissionAmtRep"), "0").replace(/,/g, ""));
		var message = "";
		if(parseFloat($F("txtVatAmtRep").replace(/,/g, "")) >= parseFloat($F("txtCommissionAmtRep").replace(/,/g, ""))){
			message = "VAT amount should be smaller than commission amount.";			
		} else if(amount == 0){
			message = "Net amount should not be zero.";			
		} else if(amount < 0){
			message = "Net amount should not be negative.";			
		} 
		
		if(message != ""){
			showWaitingMessageBox(message, imgMessage.ERROR, 
				function(){
					$("txtVatAmtRep").value = formatCurrency($("txtVatAmtRep").readAttribute("origVatAmt"));
					$("txtVatAmtRep").focus();
				});
		} else {
			$("txtVatAmtRep").writeAttribute("origVatAmt", $F("txtVatAmtRep"));
			updateCheckAmt(amount);
		}
	});
	
	$("txtCheckDateRep").observe("blur", function(){
		if(!validateCheckDate($F("txtCheckDateRep"))){
			$("txtCheckDateRep").focus();
			$("txtCheckDateRep").value = $("txtCheckDateRep").readAttribute("origCheckDate");
		} else {
			$("txtCheckDateRep").writeAttribute("origCheckDate", $F("txtCheckDateRep"));			
		}
	});
	
	$("txtItemNoRep").observe("change", function(){
		if(isNaN($F("txtItemNoRep").replace(/,/g, ""))){
			showWaitingMessageBox("Field must be of form 099.", imgMessage.INFO, 
				function(){
					$("txtItemNoRep").value = formatNumberDigits($("txtItemNoRep").readAttribute("origItemNo"), 3);
					$("txtItemNoRep").focus();
				});
		} else {
			$("txtItemNoRep").writeAttribute("origItemNo", $F("txtItemNoRep"));
			$("txtItemNoRep").value = formatNumberDigits($F("txtItemNoRep"), 3);			
		}
	});
	
	function generateNextItemNoRep(){ //created by jdiago 08.11.2014
		var itemNo = 0;
	    var lastIndex = parseInt(tgPdcReplace.pager.total) - 1;
	    
	    if(parseInt(tgPdcReplace.pager.total) == 0){
	    	itemNo = 1; 
	    } else {
	    	var maxItemNo = 1;
	    	for(var i=0; i<tgPdcReplace.geniisysRows.length; i++){
	    		if(parseInt(tgPdcReplace.geniisysRows[i].itemNo) > maxItemNo & tgPdcReplace.geniisysRows[i].recordStatus != -1){
	    			maxItemNo = parseInt(tgPdcReplace.geniisysRows[i].itemNo);
	    		}
	    	}
	    	
	    	itemNo = maxItemNo + 1;
	    }
	    
	    return itemNo;
	}
	
	$("selPayMode").observe("change", onPayModeChange);	
	$("btnPdcAddRep").observe("click", addPdcReplace);
	$("btnPdcDeleteRep").observe("click", deletePdcReplace);	
	$("btnPdcOkRep").observe("click", confirmReplacePdc);
	
	function checkRepNoLOV(){ //John Dolon; 5.25.2015; SR#17784; Error in replacing Checks with Cash payment
		try{
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					  action : "getCreditMemoDtlsList",
					  fundCd : $("globalFundCd").value,
					memoType : $F("selPayMode") == "CMI" ? "CM" : "RCM",
					 payMode : $F("selPayMode") == "CMI" ? "CMI" : "RCM",
						page : 1
				},
				title: $F("selPayMode") == "CMI" ? "List of Credit Memo Details" : "List of RI Commission Memo",
				width: 500,
				height: 400,
				columnModel: [
		 			{
		            	   id : 'cmNo',
		            	   title: $F("selPayMode") == "RCM" ? "RCM No." : "CM No.",
		            	   width: '100px'
		               },
		               {
		            	   id: 'memoDate',
		            	   type: 'date',
		            	   title: "Tran Date",
		            	   width: '75px'
		               },
		               {
		            	   id: 'amount',
		            	   title: "Local Amount",
		            	   geniisysClass: "money",
		            	   align: 'right',
		            	   width: '100px'
		               },
		               {
		            	   id: 'shortName',
		            	   title: "Currency",
		            	   width: '80px'
		               },
		               {
		            	   id: "currencyRt",
		            	   title: "Rate",
		            	   width: '90px'
		               }
				],
				autoSelectOneRecord : true,
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtCheckNoRep").value = unescapeHTML2(row.cmNo);
						$("txtCheckDateRep").value = dateFormat(row.memoDate, "mm-dd-yyyy");
						$("txtAmount").value = formatCurrency(row.localAmt);
						$("selCurrencyRep").value = row.currencyCd;
						$("txtCurrencyRtRep").value = formatToNineDecimal(row.currencyRt);
					}
				},
				onCancel: function(){
					$("txtCheckNoRep").focus();
		  		},
		  		onUndefinedRow: function(){
		  			customShowMessageBox("No record selected.", imgMessage.INFO, "txtCheckNoRep");
		  		}
			});
		}catch(e){
			showErrorMessage("showTaxTypeLOV",e);
		}
	}
	
	$("searchCheckRepNo").observe("click", checkRepNoLOV);
	
	initializeAll();	
	initializeAllMoneyFields();
	initializePdcRepForm();
	setPdcRepForm(null);
	computeNetTotal();
} catch (e){
	showErrorMessage("postDatedChecks.jsp", e);
}
</script>