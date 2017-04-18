<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="contentsDiv" >
		<div id="pdcPaymentsTableDiv" style="padding: 5px 5px 10px 5px;">
			<div id="pdcPaymentsTable" style="height: 200px"></div>
		</div>
		<div style="float: right; width: 100%;">
			<table align="right">
				<tr>
					<td class="rightAligned" style="padding-right: 5px;">Payor</td>
					<td class="leftAligned" style="padding-right: 5px;"><input type="text" id="txtPayor" name="txtPayor" readonly="readonly" style="width: 650px"/></td>
				</tr>			
			</table>
		</div>
		<div class="buttonDiv"align="center" style="padding: 40px 0 0 0;">
			<input type="button" id="btnReturn" class="button" value="Return" style="width: 90px;"/>
		</div>
</div>
<script>
	initializeAll();
	try {
		var jsonPDCPayments = JSON.parse('${jsonPDCPayments}');
		pdcPaymentsTableModel = {
			url : contextPath+ "/GIACInquiryController?action=showPDCPaymentsOverlay&refresh=1&issCd=" + $F("txtBillIssCd") + "&premSeqNo=" + $F("txtPremSeqNo")
						+"&toForeign="+$F("hidToForeign"),
			options : {
				hideColumnChildTitle: true,
				width : '738px',
				height : '200px',
				pager : {},
				onCellFocus : function(element, value, x, y, id) {
					var obj = tbgPDCPayments.geniisysRows[y];
					$("txtPayor").value = unescapeHTML2(nvl(obj.payor,''));
					tbgPDCPayments.keys.releaseKeys();
				},
				postPager : function() {
					$("txtPayor").value = null; 
					tbgPDCPayments.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					$("txtPayor").value = null; 
					tbgPDCPayments.keys.releaseKeys();
				},
				onSort : function(){
					$("txtPayor").value = null; 
					tbgPDCPayments.keys.releaseKeys();
				},
				toolbar : {
					elements : [MyTableGrid.REFRESH_BTN ],
					onRefresh : function(){
						$("txtPayor").value = null; 
						tbgPDCPayments.keys.releaseKeys();
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
			    	id:'apdcNo',
			    	title: 'APDC No.',
			    	width: '75px'
			    },
			    {
			    	id:'sdfApdcDate',
			    	title: 'APDC Date ',
			    	width: '80px',
			    	align: 'center',
			    	titleAlign: 'center'
			    },
			    {
			    	id:'bankSname bankBranch',
			    	title: 'Bank',
			    	width: 200,
			    	titleAlign: 'left',
			    	children: [
				    	   	    {	id: 'bankSname',
							    	width: 80
							    },
							    {	id: 'bankBranch',
							    	width: 125,
							    	align: 'left',
							    	renderer: function(value){
							    		return value.toUpperCase();
							    	}
							    }
			    	          ]
			    },
			    {
			    	id:'checkClass',
			    	title: 'Check Class',
			    	width: '75px'
			    },
			    {
			    	id:'checkNo',
			    	title: 'Check No.',
			    	width: '75px'
			    },
			    {
			    	id:'sdfCheckDate',
			    	title: 'Check Date',
			    	width: '80px',
			    	align: 'center',
			    	titleAlign: 'center'
			    },
			    {
			    	id:'collectionAmt',
			    	title: 'Amount',
			    	width: '100px',
			    	align: 'right',
			    	titleAlign: 'right',
			    	renderer: function(value){
			    		return nvl(value,'') == '' ? '0.00' : formatCurrency(nvl(value, 0));
			    	}
			    }
			],
			rows : jsonPDCPayments.rows
		};
		tbgPDCPayments = new MyTableGrid(pdcPaymentsTableModel);
		tbgPDCPayments.pager = jsonPDCPayments;
		tbgPDCPayments.render('pdcPaymentsTable');
	} catch (e) {
		showErrorMessage("pdcPaymentsTableModel", e);
	}
	
	$("btnReturn").observe("click",function(){
		overlayPDCPaymentsInfo.close();
	});
</script>