<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="contentsDiv" >
		<div id="taxesTableDiv" style="padding: 5px 5px 5px 5px;">
			<div id="taxesTable" style="height: 190px"></div>
		</div>
		<div style="float: right; width: 100%;">
			<table align="right">
				<tr>
					<td class="rightAligned" style="padding-right: 5px;">Total</td>
					<td class="leftAligned" style="padding-right: 5px;"><input class="rightAligned" type="text" id="txtTotalTaxes" name="txtTotalTaxes" readonly="readonly" style="width: 140px" value="0.00"/></td>
				</tr>			
			</table>
		</div>
		<div class="buttonDiv"align="center" style="padding: 30px 0 0 0;">
			<input type="button" id="btnReturn" class="button" value="Return" style="width: 90px;"/>
		</div>
</div>
<script>
	initializeAll();
	try {
		var jsonTaxes = JSON.parse('${jsonTaxes}');
		taxesTableModel = {
			url : contextPath+ "/GIACInquiryController?action=showTaxesOverlay&refresh=1&issCd=" + $F("txtBillIssCd") + "&premSeqNo=" + $F("txtPremSeqNo") +"&currencyRt="+$F("txtCurrencyRt")
					+"&toForeign="+$F("hidToForeign"),
			options : {
				width : '587px',
				height : '190px',
				pager : {},
				onCellFocus : function(element, value, x, y, id) {
					tbgTaxes.keys.releaseKeys();
				},
				prePager : function() {
					tbgTaxes.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					tbgTaxes.keys.releaseKeys();
				},
				onSort : function(){
					tbgTaxes.keys.releaseKeys();
				},
				toolbar : {
					elements : [MyTableGrid.REFRESH_BTN ],
					onRefresh : function(){
						tbgTaxes.keys.releaseKeys();
					},
				}
			},
			columnModel : [ 
				{
				    id: 'recordStatus',
				    title: '',
				    width: '0',
				    visible: false
				},
				{
					id: 'divCtrId',
					width: '0',
					visible: false 
				},               
			    {
			    	id:'taxCd',
			    	title: 'Code',
			    	width: '70px',
			    	align: 'right',
			    	renderer: function(value){
			    		return nvl(value,'') == '' ? '' :formatNumberDigits(nvl(value, 0),2);
			    	}
			    },
			    {
			    	id:'taxDesc',
			    	title: 'Description',
			    	width: '360px',
			    	align: 'left'
			    },
			    {
			    	id:'dspTaxAmt',
			    	title: 'Taxes Amount',
			    	width: '125px',
			    	align: 'right',
			    	titleAlign: 'right',
			    	renderer: function(value){
			    		return nvl(value,'') == '' ? '0.00' : formatCurrency(nvl(value, 0));
			    	}
			    },
			    {
			    	id:'totalTaxAmt',
			    	width: '0px',
			    	visible: false
			    }
			],
			rows : jsonTaxes.rows
		};
		tbgTaxes = new MyTableGrid(taxesTableModel);
		tbgTaxes.pager = jsonTaxes;
		tbgTaxes.render('taxesTable');
		tbgTaxes.afterRender = function(){
											if (tbgTaxes.geniisysRows.length > 0) {
												$("txtTotalTaxes").value = formatCurrency(nvl(tbgTaxes.geniisysRows[0].totalTaxAmt, 0));
											} 
		};
		
	} catch (e) {
		showErrorMessage("taxesTableModel", e);
	}
	
	$("btnReturn").observe("click",function(){
		overlayTaxesInfo.close();
	});
</script>