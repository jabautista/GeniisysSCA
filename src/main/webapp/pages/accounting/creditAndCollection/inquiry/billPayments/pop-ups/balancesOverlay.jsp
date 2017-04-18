<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="contentsDiv" >
		<div id="balancesTableDiv" style="padding: 5px 5px 5px 5px;">
			<div id="balancesTable" style="height: 190px"></div>
		</div>
		<div style="float: right; width: 100%;">
			<table align="right">
				<tr>
					<td class="rightAligned" style="padding-right: 5px;">Totals</td>
					<td class="leftAligned" style="padding-right: 5px;">
						<input class="rightAligned" type="text" id="txtTotalPremBalanceDue" readonly="readonly" style="width: 140px"/>
						<input class="rightAligned" type="text" id="txtTotalTaxBalanceDue" readonly="readonly" style="width: 140px"/>
						<input class="rightAligned" type="text" id="txtTotalBalanceAmtDue" readonly="readonly" style="width: 140px"/>
					</td>
				</tr>			
			</table>
		</div>
		<div class="buttonDiv"align="center" style="padding: 35px 0 0 0;">
			<input type="button" id="btnReturn" class="button" value="Return" style="width: 90px;"/>
		</div>
</div>
<script>
	initializeAll();
	try {
		var jsonBalances = JSON.parse('${jsonBalances}');
		balancesTableModel = {
			url : contextPath+ "/GIACInquiryController?action=showBalancesOverlay&refresh=1&issCd=" + $F("txtBillIssCd") + "&premSeqNo=" + $F("txtPremSeqNo")
						+"&toForeign="+$F("hidToForeign"),
			options : {
				hideColumnChildTitle: true,
				width : '587px',
				height : '190px',
				pager : {},
				onCellFocus : function(element, value, x, y, id) {
					tbgBalances.keys.releaseKeys();
				},
				postPager : function() {
					tbgBalances.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					tbgBalances.keys.releaseKeys();
				},
				onSort : function(){
					tbgBalances.keys.releaseKeys();
				},
				toolbar : {
					elements : [MyTableGrid.REFRESH_BTN ],
					onRefresh : function(){
						tbgBalances.keys.releaseKeys();
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
			    	id:'instNo',
			    	title: 'Inst No.',
			    	align: 'right',
			    	titleAlign: 'right',
			    	width: '75px'
			    },
			    {
			    	id:'premBalanceDue',
			    	title: 'Premium Balance Due',
			    	width: '160px',
			    	align: 'right',
			    	titleAlign: 'right',
			    	renderer: function(value){
			    		return nvl(value,'') == '' ? '0.00' : formatCurrency(nvl(value, 0));
			    	}
			    },
			    {
			    	id:'taxBalanceDue',
			    	title: 'Tax Balance Due',
			    	width: '160px',
			    	align: 'right',
			    	titleAlign: 'right',
			    	renderer: function(value){
			    		return nvl(value,'') == '' ? '0.00' : formatCurrency(nvl(value, 0));
			    	}
			    },
			    {
			    	id:'balanceAmtDue',
			    	title: 'Balance Amount Due',
			    	width: '160px',
			    	align: 'right',
			    	titleAlign: 'right',
			    	renderer: function(value){
			    		return nvl(value,'') == '' ? '0.00' : formatCurrency(nvl(value, 0));
			    	}
			    }
			],
			rows : jsonBalances.rows
		};
		tbgBalances = new MyTableGrid(balancesTableModel);
		tbgBalances.pager = jsonBalances;
		tbgBalances.render('balancesTable');
		tbgBalances.afterRender = function(){
											if (tbgBalances.geniisysRows.length > 0) {
												$("txtTotalPremBalanceDue").value = formatCurrency(nvl(tbgBalances.geniisysRows[0].totalPremBalanceDue, 0));
												$("txtTotalTaxBalanceDue").value = formatCurrency(nvl(tbgBalances.geniisysRows[0].totalTaxBalanceDue, 0));
												$("txtTotalBalanceAmtDue").value = formatCurrency(nvl(tbgBalances.geniisysRows[0].totalBalanceAmtDue, 0));
											} 
		};
	} catch (e) {
		showErrorMessage("balancesTableModel", e);
	}
	
	$("btnReturn").observe("click",function(){
		overlayBalancesInfo.close();
	});
</script>