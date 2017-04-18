<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="contentsDiv" >
		<div id="premiumTableDiv" style="padding: 5px 5px 5px 5px;">
			<div id="premiumTable" style="height: 190px"></div>
		</div>
		<div style="float: right; width: 100%;">
			<table align="right">
				<tr>
					<td class="rightAligned" style="padding-right: 5px;">Total</td>
					<td class="leftAligned" style="padding-right: 5px;"><input class="rightAligned" type="text" id="txtTotalPremAmt" name="txtTotalPremAmt" readonly="readonly" style="width: 140px" value="0.00"/></td>
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
		var jsonPremium = JSON.parse('${jsonPremium}');
		premiumTableModel = {
			url : contextPath+ "/GIACInquiryController?action=showPremiumOverlay&refresh=1&issCd=" + $F("txtBillIssCd") + "&premSeqNo=" + $F("txtPremSeqNo")
								+"&toForeign="+$F("hidToForeign"),
			options : {
				width : '587px',
				height : '190px',
				pager : {},
				onCellFocus : function(element, value, x, y, id) {
					tbgPremium.keys.releaseKeys();
				},
				prePager : function() {
					tbgPremium.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					tbgPremium.keys.releaseKeys();
				},
				onSort : function(){
					tbgPremium.keys.releaseKeys();
				},
				toolbar : {
					elements : [MyTableGrid.REFRESH_BTN ],
					onRefresh : function(){
						tbgPremium.keys.releaseKeys();
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
			    	id:'perilCd',
			    	title: 'Peril',
			    	width: '70px',
			    	align: 'right',
			    	renderer: function(value){
			    		return nvl(value,'') == '' ? '' :formatNumberDigits(nvl(value, 0),2);
			    	}
			    },
			    {
			    	id:'perilName',
			    	title: 'Description',
			    	width: '360px',
			    	align: 'left'
			    },
			    {
			    	id:'premAmt',
			    	title: 'Premium Amount',
			    	width: '125px',
			    	align: 'right',
			    	titleAlign: 'right',
			    	renderer: function(value){
			    		return nvl(value,'') == '' ? '0.00' : formatCurrency(nvl(value, 0));
			    	}
			    },
			    {
			    	id:'totalPremAmt',
			    	width: '0px',
			    	visible: false
			    }
			],
			rows : jsonPremium.rows
		};
		tbgPremium = new MyTableGrid(premiumTableModel);
		tbgPremium.pager = jsonPremium;
		tbgPremium.render('premiumTable');
		tbgPremium.afterRender = function(){
											if (tbgPremium.geniisysRows.length > 0) {
												$("txtTotalPremAmt").value = formatCurrency(nvl(tbgPremium.geniisysRows[0].totalPremAmt, 0));
											} 
		};
		
	} catch (e) {
		showErrorMessage("premiumTableModel", e);
	}
	
	$("btnReturn").observe("click",function(){
		overlayPremiumInfo.close();
	});
</script>