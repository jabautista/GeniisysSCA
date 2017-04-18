<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="ajax" uri="http://ajaxtags.org/tags/ajax" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include>
<div id="contentsDiv">
	<div id="glBalanceTable" name="glBalanceTable" style="width: 100%; display: block; margin-top: 5px; margin-bottom: 10px; height:285px;"></div>
	
	<div id="acctTotalsMainDiv" style="width: 100%; display: block; margin:0 auto; padding-top: 10px; padding-bottom: 10px;">
		<div id="acctTotalsDiv" style="height: 100px;">
			<table align="right">
				<tr>
					<td style="text-align:right; padding-right:10px;">Total Debit Amount</td>
					<td>
						<input type="text" id="txtDebitTotal" class="money" style="width: 150px; text-align: right;" readonly="readonly" tabindex=301/>
					</td>
				</tr>
				<tr>
					<td style="text-align:right; padding-right:10px;">Total Credit Amount</td>
					<td>
						<input type="text" id="txtCreditTotal" class="money" style="width: 150px; text-align: right;" readonly="readonly" tabindex=302/>					
					</td>
				</tr>
				<tr>
					<td style="text-align:right; padding-right:10px;">Difference</td>
					<td>
						<input type="text" id="txtDifference" class="money" style="width: 150px; text-align: right;" readonly="readonly" tabindex=303/>
					</td>
				</tr>
			</table>
		</div>
		<div align="center">
			Account Name: <input type="text" id="glAccountName" name="glAccountName" style="width:600px;" readonly="readonly" tabindex=304/>
		</div>
		<div align="center" style="width:90px; margin:0 auto; padding-top:15px;">
			<input type="button" id="btnReturn" class="button" value="Return" style="width: 90px; float: left;" tabindex=305/>
		</div>
	</div>
</div>

<script type="text/javascript">
	//var glBalArray = JSON.parse('${glBalance}'.replace(/\\/g, '\\\\'));
	//createGlBalRow(glBalArray);
	initializeAllMoneyFields();
	
	try{
		var objAcctEntriesArray = [];
		var objAccountingEntries = new Object();
		objAccountingEntries.objAccountingEntriesTableGrid = JSON.parse('${acctEntriesJSON}'.replace(/\\/g, '\\\\'));
		objAccountingEntries.acctEntriesList = objAccountingEntries.objAccountingEntriesTableGrid.rows || [];
	
		var tableModel = {
				url: contextPath+"/GIACAcctEntriesController?action=showAcctEntriesTableGrid&refresh=1&gaccTranId="+objACGlobal.gaccTranId,
				options:{
					hideColumnChildTitle: true,
					title: '',
					height: '270px',
					width: '700px',
					onCellFocus: function(element, value, x, y, id) {
						accountingEntriesTableGrid.keys.releaseKeys();
						$("glAccountName").value = accountingEntriesTableGrid.geniisysRows[y].glAcctName;
					},
					onRemoveRowFocus: function(){
						accountingEntriesTableGrid.keys.releaseKeys();
						$("glAccountName").value = "";
					},
					onSort: function () {
						accountingEntriesTableGrid.keys.releaseKeys();
						$("glAccountName").value = "";
					},
					postPager: function () {
						accountingEntriesTableGrid.keys.releaseKeys();
						$("glAccountName").value = "";
					},
					toolbar : {
						elements : [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN ],
						onRefresh: function(){
							accountingEntriesTableGrid.keys.releaseKeys();
							$("glAccountName").value = "";
						},
						onFilter: function(){
							accountingEntriesTableGrid.keys.releaseKeys();
							$("glAccountName").value = "";
						}
				}
		},
		columnModel: [
						{	
							id: 'recordStatus', 	
						    width: '0',
						   	visible: false,
						    editor: 'checkbox' 					
						},
						{	id: 'divCtrId',
							width: '0',
							visible: false
						},
						/* {id: 'glAcctCategory glControlAcct glSubAcct1 glSubAcct2 glSubAcct3 glSubAcct4 glSubAcct5 glSubAcct6 glSubAcct7',
							title: 'GL Account Code',
							sortable: true,
							width: 270,
							children: [
		            	               {
										   id : 'glAcctCategory',
										   width: 40,
										   align: 'right',
										   renderer: function(value){
						            		   return lpad(value, 2, 0);
						            	   }
									   },
									   {
										   id : 'glControlAcct',
										   width: 40,
										   align: 'right',
										   renderer: function(value){
						            		   return lpad(value, 2, 0);
						            	   }
									   },
									   {
										   id : 'glSubAcct1',
										   width: 40,
										   align: 'right',
										   renderer: function(value){
						            		   return lpad(value, 2, 0);
						            	   }
									   },
									   {
										   id : 'glSubAcct2',
										   width: 40,
										   align: 'right',
										   renderer: function(value){
						            		   return lpad(value, 2, 0);
						            	   }
									   },
									   {
										   id : 'glSubAcct3',
										   width: 40,
										   align: 'right',
										   renderer: function(value){
						            		   return lpad(value, 2, 0);
						            	   }
									   },
									   {
										   id : 'glSubAcct4',
										   width: 40,
										   align: 'right',
										   renderer: function(value){
						            		   return lpad(value, 2, 0);
						            	   }
									   },
									   {
										   id : 'glSubAcct5',
										   width: 40,
										   align: 'right',
										   renderer: function(value){
						            		   return lpad(value, 2, 0);
						            	   }
									   },
									   {
										   id : 'glSubAcct6',
										   width: 40,
										   align: 'right',
										   renderer: function(value){
						            		   return lpad(value, 2, 0);
						            	   }
									   },
									   {
										   id : 'glSubAcct7',
										   width: 40,
										   align: 'right',
										   renderer: function(value){
						            		   return lpad(value, 2, 0);
						            	   }
									   }
					       ]
						}, */
						{	id: 'acctCode',
							title: 'GL Account Code',
							width: '320px',
							sortable: true,
			 			    filterOption : true
						},
						{	id: 'glAcctName',
							width: '0',
							visible: false
						},
						{	id: 'slName',
							width: '0',
							visible: false
						},
						{	id: 'debitAmt',
							title: 'Debit Amount',
							width: '150px',
							align: 'right',
							sortable: true,
			 			    filterOption : true,
						    renderer: function(value){
		            			return formatCurrency(value);
		            	    }
						},
						{	id: 'creditAmt',
							title: 'Credit Amount',
							width: '150px',
							align: 'right',
							sortable: true,
			 			    filterOption : true,
						    renderer: function(value){
		            			return formatCurrency(value);
		            	    }
						},
						{	id: 'glAcctId',
							width: '0',
							visible: false
						},
						{	id: 'slCd',
							width: '0',
							visible: false
						},
						{	id: 'slTypeCd',
							width: '0',
							visible: false
						},
						{	id: 'generationType',
							width: '0',
							visible: false
						}
						
			],
			rows: objAccountingEntries.acctEntriesList
		};
		
		accountingEntriesTableGrid = new MyTableGrid(tableModel);
		accountingEntriesTableGrid.pager = objAccountingEntries.objAccountingEntriesTableGrid;
		accountingEntriesTableGrid.render('glBalanceTable');
		accountingEntriesTableGrid.afterRender = function(){
			objAcctEntriesArray = accountingEntriesTableGrid.geniisysRows;
			
			$("txtDebitTotal").value = formatCurrency('${totalDebitAmt}');
			$("txtCreditTotal").value = formatCurrency('${totalCreditAmt}');
			computeGlTotals();
		};
	}catch (e) {
		showErrorMessage("accountingEntries.jsp",e);
	}

	
	function computeGlTotals() {
		var totalDebit = unformatCurrency("txtDebitTotal");
		var totalCredit= unformatCurrency("txtCreditTotal");

		var difference = totalDebit - totalCredit;
		
		$("txtDifference").value = formatCurrency(difference);
	}
	
	$("btnReturn").observe("click", function() {
		glBalance.close();
	});
</script>