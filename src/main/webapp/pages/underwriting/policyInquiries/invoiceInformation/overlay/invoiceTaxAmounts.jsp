<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div class="sectionDiv" style="margin: 10px 10px 5px 10px;width:620px;">
	<table style="margin:10px 10px 10px 100px;">
		<tr>
			<td class="rightAligned">Invoice Number</td>
			<td>
				<input type="text" id="txtInvTaxIssCd" name="txtInvTaxIssCd" style="width:50px; margin-left:5px;" readonly="readonly" tabindex="101" />
				<input type="text" id="txtInvTaxPremSeqNo" name="txtInvTaxPremSeqNo" style="width:138px; text-align:right;" readonly="readonly" tabindex="102"  />
				<input type="text" id="txtInvTaxItemGrp" name="txtInvTaxItemGrp" style="width:50px; text-align:right;"  readonly="readonly" tabindex="103" />
			</td>
		</tr>
	</table>
</div>

<div class="sectionDiv"  style="margin: 0 10px 10px 10px; height:220px;width:620px; height: 275px;">
	<div id="taxTGDiv" name="taxTGDiv" style="margin: 10px 10px 10px 10px; width:600px;"></div>
</div>

<div class="buttonsDiv"  style="margin: 10px 10px 10px 10px; width:620px;">
	<input type="button" class="button" id="btnCloseTaxAmount" name="btnCloseTaxAmount" value="Ok" style="width: 90px;" />
</div>

<script type="text/javascript">
	var taxList = JSON.parse('${invoiceList}');
	var taxRows = taxList.rows || [];
	
	try {
		taxTableModel = {
				url: contextPath + "/GIPIInvoiceController?action=getInvoiceTaxDetails&refresh=1"
									+ "&issCd=" 	+ objInvoiceInfo.selectedRow.issCd
									+ "&premSeqNo="	+ objInvoiceInfo.selectedRow.premSeqNo
									+ "&itemGrp="	+ objInvoiceInfo.selectedRow.itemGrp,
				id: 1,
				options: {
					id: 1,
					height: '230px',
					width: '600px',
					onCellFocus: function(element, value, x, y,  id){
						taxTableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus: function(){
						taxTableGrid.keys.releaseKeys();
					},
					toolbar: {
						elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN]
					},
				},
				columnModel: [{   
								id: 'recordStatus',
							    width: '0px',
							    visible: false,
							    editor: 'checkbox'
							},
							{	
								id: 'divCtrId',
								width: '0px',
								visible: false
							},
							{	
								id: 'taxDesc',
								title: 'Tax Description',
								width: '380px',
								filterOption: true
							},
							{	
								id: 'taxAmount',
								title: 'Tax Amount',
								width: '200px',
								titleAlign: 'right',
								align: 'right',
								filterOption: true,
								filterOptionType: 'number',
								renderer: function(value){
									return formatCurrency(nvl(value, "0"));
								}
							}
				],
				rows: taxRows
		},
		taxTableGrid = new MyTableGrid(taxTableModel);
		taxTableGrid.pager = taxList; 
		taxTableGrid.render('taxTGDiv');
	} catch(e){
		showErrorMessage("tax amounts table grid: ", e);
	}

	function populateFields3(){
		$("txtInvTaxIssCd").value 			= objInvoiceInfo.selectedRow.issCd;
		$("txtInvTaxPremSeqNo").value 		= formatNumberDigits(objInvoiceInfo.selectedRow.premSeqNo, 12);
		$("txtInvTaxItemGrp").value 		= formatNumberDigits(objInvoiceInfo.selectedRow.itemGrp, 2);
	}
	
	$("btnCloseTaxAmount").observe("click", function(){
		invoiceTaxOverlay.close();
	});
	
	populateFields3();
</script>