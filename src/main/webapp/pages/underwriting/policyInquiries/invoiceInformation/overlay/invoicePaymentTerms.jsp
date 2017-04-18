<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div class="sectionDiv" style="margin: 10px 5px 5px 5px; width:780px;">
	<table border="0" cellpadding="2" cellspacing="2" style="margin: 10px 10px 10px 40px;">
		<tr>
			<td class="rightAligned">Invoice Number</td>
			<td>
				<input type="text" id="txtPaytIssCd" name="txtPaytIssCd" style="width:50px; margin-left:5px;" readonly="readonly" tabindex="101" />
				<input type="text" id="txtPaytPremSeqNo" name="txtPaytPremSeqNo" style="width:138px; text-align:right;" readonly="readonly" tabindex="102"  />
				<input type="text" id="txtPaytItemGrp" name="txtPaytItemGrp" style="width:50px; text-align:right;"  readonly="readonly" tabindex="103" />
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Payment Term</td>
			<td><input type="text" id="txtPaytTerm" name="txtPaytTerm" style="width:261px; margin-left:5px;" readonly="readonly" tabindex="104" /></td>
		</tr>
		<tr>
			<td class="rightAligned">Remarks</td>
			<td>
				<textarea id="txtPaytRemarks" name="txtPaytRemarks" style="margin-left:5px; resize:none; height: 14px; width:590px;" readonly="readonly" maxlength="4000" tabindex="104"></textarea>
				<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" id="textRemarks" class="hover" />
				<!-- <input type="text" id="txtSoaIssCd" name="txtSoaIssCd" style="width:50px; margin-left:5px;" readonly="readonly" tabindex="104" /> -->
			</td>
		</tr>
	</table>
</div>

<div id="paytermsTGMainDiv" name="paytermsTGMainDiv" class="sectionDiv" style="margin: 0 5px 5px 5px; width:780px; height:250px;">
	<div id="paytermsTG" name="paytermsTG" style="margin: 10px 10px 10px 10px; height:220px; width:750px;"></div>
</div>

<div class="buttonsDiv" style="margin: 10px 10px 10px 10px; width: 780px;">
	<input type="button" class="button" id="btnClosePayterms" name="btnClosePayterms" value="Ok" style="width:90px;" />
</div>

<script type="text/javascript">
	var paytermList =  JSON.parse('${invoicePaytermDetails}');
	var paytermRows = paytermList.rows || [];
	
	try {
		
		paytermTableModel = {
				url: contextPath +"/GIPIInvoiceController?action=getInvoicePaytermsInfo&refresh=1"
						+ "&issCd=" 	+ objInvoiceInfo.selectedRow.issCd
						+ "&premSeqNo="	+ objInvoiceInfo.selectedRow.premSeqNo
						+ "&itemGrp="	+ objInvoiceInfo.selectedRow.itemGrp,
				id: 1,
				options: {
					height: '208px',
					width: '760px',
					onCellFocus: function(element, value, x, y, id){
						paytermTableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus: function(){
						paytermTableGrid.keys.removeFocus(paytermTableGrid.keys._nCurrentFocus, true);
						paytermTableGrid.keys.releaseKeys();
					},
					toolbar: {
		            	elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN]
		            }
				},
				columnModel: [
								{   id: 'recordStatus',
								    width: '0',
								    visible: false,
								    editor: 'checkbox'
								},
								{	id: 'divCtrId',
									width: '0',
									visible: false
								},
								{	id: 'instNo',
									title: 'Inst. No',
									width: '80px',
									align: 'right',
									titleAlign: 'right',
									filterOption: true,
									filterOptionType: 'integerNoNegative',
									renderer: function(value){
										return formatNumberDigits(value, 2);
									}
								},  
								{	id: 'dueDateStr',
									width: '100px',
									title: 'Due Date',
									type: 'date',
									format: 'mm-dd-yyyy',
									filterOption: true,
									filterOptionType: 'formattedDate'
								},
								{	id: 'sharePercentage',
									title: 'Share Percentage',
									width: '150px',
									align: 'right',
									titleAlign: 'right',
									filterOption: true,
									filterOptionType: 'numberNoNegative',
									renderer: function(value){
										return formatToNineDecimal(nvl(value, "0"));
									}
								},
								{	id: 'taxAmount',
									title: 'Tax Amount',
									width: '200px',
									align: 'right',
									titleAlign: 'right',
									filterOption: true,
									filterOptionType: 'number',
									renderer: function(value){
										return formatCurrency(nvl(value, "0"));
									}
								},
								{	id: 'premAmount',
									title: 'Premium Amount',
									width: '200px',
									align: 'right',
									titleAlign: 'right',
									filterOption: true,
									filterOptionType: 'number',
									renderer: function(value){
										return formatCurrency(nvl(value, "0"));
									}
								},
				],
				rows: paytermRows
		};
		paytermTableGrid = new MyTableGrid(paytermTableModel);
		paytermTableGrid.pager = paytermList;
		paytermTableGrid.render('paytermsTG');
	} catch(e){
		showErrorMessage("Invoice Payment Term Tablegrid: ", e);
	}
	
	function populatePaytermInfo(){
		$("txtPaytIssCd").value = objInvoiceInfo.selectedRow.issCd;
		$("txtPaytPremSeqNo").value = formatNumberDigits(objInvoiceInfo.selectedRow.premSeqNo, 12);
		$("txtPaytItemGrp").value = formatNumberDigits(objInvoiceInfo.selectedRow.itemGrp, 2);
		$("txtPaytTerm").value = objInvoiceInfo.selectedRow.paytTermsDesc;
		$("txtPaytRemarks").value = objInvoiceInfo.selectedRow.remarks;
	}
	
	$("textRemarks").observe("click", function () {
		showEditor("txtPaytRemarks", 4000, 'true');
	});
	
	$("btnClosePayterms").observe("click", function(){
		invoicePaytermsOverlay.close();
	});
	
	populatePaytermInfo();
</script>