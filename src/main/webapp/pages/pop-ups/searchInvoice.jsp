<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="contentsDiv">
	<!-- <div align="left">
		<table>
			<tr>
				<td class="rightAligned">Bill No. Keyword </td>
				<td class="leftAligned"><input name="keyword" id="keyword" style="margin-bottom: 0; width: 200px;" type="text" value="" /></td>
				<td><input id="searchInvoice" class="button" type="button" style="width: 60px;" value="Search" /></td>
			</tr>
		</table>
	</div>  -->
	<div style="padding: 10px; height: 350px; background-color: #ffffff; overflow: auto;" id="searchResult">
	</div>
	
	<div id="divB" align="right" style="margin: 10px; margin-right: 0;">
		<input type="button" id="btnInvoiceOk" class="button" value="Ok" style="width: 60px;" />
		<input type="button" id="btnInvoiceCancel" class="button" value="Cancel" style="width: 60px;" />
	</div>
</div>
<script type="text/javascript" defer="defer">	
	invoiceSelectedInvoiceRows = new Array();
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
	$("btnInvoiceOk").observe("click", function () {
		try {
			//$("invoicePageNo").value = 1;
			searchTableGrid.releaseKeys();
			var invoiceModifiedRows = invoiceSelectedInvoiceRows.concat(searchTableGrid.getModifiedRows().filter(function fun(row) { // andrew - 05.09.2011 - added array concat of selected invoice in different pages
																			if (row.isIncluded==true) {
																				return row;
																			}
																		}));
			if(invoiceModifiedRows.length > 1) {
				invoiceModifiedRows = mergeSameInvoiceRows(invoiceModifiedRows);
			}
			/*var invoiceModifiedRows = objAC.rowsToAdd;/*searchTableGrid.getModifiedRows().filter(function fun(row) {
																		if (row.isIncluded==true) {
																			return row;
																		}
																	}));
																			});*/ //commented by alfie 05/10/2011		   
			setTranTypeValues(invoiceModifiedRows);																
			function isBigEnough(element, index, array) {
				  return (element >= 10);
				}

			for (var x=0; x<invoiceModifiedRows; x++) {
				if (invoiceModifiedRows.isIncluded==false) {
					invoiceModifiedRows.splice(x,1);
				}
			}
			
			addRecordsInPaidList(invoiceModifiedRows);
			modalPageNo2 = 1;
			objAC.selectedFromInvoiceLOV = false;
		} catch (e) {
			showErrorMessage("searchInvoice.jsp - btnInvoiceOk", e);
		} finally {
			Modalbox.hide();
		}
		//fireEvent($("billCmNo"), "blur"); modified by alfie 12.16.2010
	});
	
	$("btnInvoiceCancel").observe("click", function (){

		try {
			//$("invoicePageNo").value = 1;
			searchTableGrid.releaseKeys();
			modalPageNo2 = 1;
			//$("assdNo").value = ""; commented by alfie 01.27.2011
			$("polEndtNo").value = "";
			clearInvalidPrem();
			objAC.selectedFromInvoiceLOV = false;
		} catch (e) {
			showErrorMessage("searchInvoice.jsp - btnInvoiceCancel", e);
		} finally {
			Modalbox.hide();
		}
	});

	function setTranTypeValues(obj){
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
	}
	
	//$("searchInvoice").observe("click", searchInvoiceModal3);
</script>