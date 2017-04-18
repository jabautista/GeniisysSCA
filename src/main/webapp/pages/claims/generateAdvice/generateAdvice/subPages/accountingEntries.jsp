<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="accountingEntriesMainDiv">
	<div id="giclAcctEntriesHeaderDiv" name="giclAcctEntriesHeaderDiv" style="margin-top: 10px; width: 99.5%;" class="sectionDiv">
		<table style="margin: 10px;">
			<tr>
				<td class="rightAligned" width="28px">Item </td>
				<td class="leftAligned">
					<input type="text" id="txtItemNo" name="txtItemNo" readonly="readonly" style="width: 50px; text-align: right;"/>
					<input type="text" id="txtItemTitle" name="txtItemTitle" readonly="readonly" style="width: 230px;" value=""/>
				</td>
				<td class="rightAligned" width="50px">Payee </td>
				<td class="leftAligned">
					<input type="text" id="txtPayeeName" name="txtPayeeName" readonly="readonly" style="width: 328px;" value=""/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Peril </td>
				<td class="leftAligned">
					<input type="text" id="txtPerilName" name="txtPerilName" readonly="readonly" style="width: 292px;" value="${adviceNo}"/>
				</td>
			</tr>
		</table>		
	</div>
	<div id="giclAcctEntriesDiv" name="giclAcctEntriesDiv" class="sectionDiv" style="width: 99.5%;">
		<div id="giclAcctEntriesListTableGridDiv" name="giclAcctEntriesListTableGridDiv" style="margin: 10px; margin-bottom: 27px;">
			<div id="giclAcctEntriesListTableGrid" style="height: 180px;"></div>
		</div>
		<div>
			<table style="margin-bottom: 20px; margin-left: 164px;">
				<tr>
					<td class="rightAligned">Total Debit Amount</td>
					<td class="leftAligned">
						<input type="text" id="txtTotalDebitAmount" name="txtTotalDebitAmount" readonly="readonly" style="width: 155px;" class="money" value="${totalDebitAmt}"/>
					</td>
					<td class="rightAligned" width="125px">Total Credit Amount</td>
					<td class="leftAligned">
						<input type="text" id="txtTotalCreditAmount" name="txtTotalCreditAmount" readonly="readonly" style="width: 155px;" class="money" value="${totalCreditAmt}"/>
					</td>
				</tr>
			</table>
			<table style="margin: 10px;">
				<tr>
					<td class="rightAligned">Account Name</td>
					<td class="leftAligned">
						<span id="acctNameSpan" style="border: 1px solid gray; width: 635px; height: 21px; float: left;"> 
							<input type="text" id="txtAcctName" name="txtAcctName" style="border: none; float: left; width: 96%; background: transparent;" readonly="readonly" /> 
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" id="btnAcctName" name="btnAcctName" alt="Go" style="background: transparent;"/>
						</span>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<div align="center">
		<input type="button" class="button" id="btnReturn" value="Return" style="width: 80px;margin-top: 10px; margin-bottom: 10px;">
	</div>
</div>
<script type="text/javascript">
	$("btnReturn").observe("click", function(){
		delete objGICLAcctEntries;
		delete tbgGICLAcctEntries;
		overlayGICLAcctEntries.close();
		delete overlayGICLAcctEntries;
	});	
	
	function computeTotals(){
		var totalCreditAmount = 0;
		var totalDebitAmount = 0;
		for(var i=0; i<tbgGICLAcctEntries.geniisysRows.length; i++){
			totalCreditAmount += parseFloat(tbgGICLAcctEntries.geniisysRows[i].creditAmount);
			totalDebitAmount += parseFloat(tbgGICLAcctEntries.geniisysRows[i].debitAmount);
		}
		$("txtTotalCreditAmount").value = formatCurrency(totalCreditAmount);
		$("txtTotalDebitAmount").value = formatCurrency(totalDebitAmount);
	}	
	
	var objGICLAcctEntries = JSON.parse('${jsonAcctEntries}');
	var acctEntriesModel = {	
		url: contextPath+"/GICLAcctEntriesController?action=getGICLAcctEntriesList&refresh=1&claimId="+objCLMGlobal.claimId+"&adviceId="+objGICLS032.objCurrGICLClmLossExp.adviceId+"&payeeCd="+objGICLS032.objCurrGICLClmLossExp.payeeCd+"&payeeClassCd="+objGICLS032.objCurrGICLClmLossExp.payeeClassCd,
		options:{
			title: '',
			width: '725px',
			toolbar: {
				elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
			},
			onCellFocus: function(element, value, x, y, id){
				var mtgId = tbgGICLAcctEntries._mtgId;							
				if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
					$("txtAcctName").value = tbgGICLAcctEntries.geniisysRows[y].nbtGlAcctName;					
				}
				tbgGICLAcctEntries.keys.removeFocus(tbgGICLAcctEntries.keys._nCurrentFocus, true);
				tbgGICLAcctEntries.keys.releaseKeys();
			},
			onRemoveRowFocus: function(element, value, x, y, id){
				$("txtAcctName").value = "";
			},
			onSort : function(){
				$("txtAcctName").value = "";
			},
			onRefresh:function(){
				$("txtAcctName").value = "";
			}
		},
		columnModel: [
			{   id: 'recordStatus',
			    title: '',
			    width: '0',
			    visible: false,
			    editor: 'checkbox' 			
			},
			{	id: 'divCtrId',
				width: '0',
				visible: false
			},
			{	id: 'glAcctCode',
				title: 'GL Account Code',
				width: '250px'				
			},
			{	id: 'slCode',
				title: 'SL Code',
				width: '120px',
				align: 'right',
				titleAlign: 'right',
				filterOption: true,
				filterOptionType: 'integerNoNegative'
			},
			{	id: 'debitAmount',
				title: 'Debit Amount',
				width: '160px',
				geniisysClass: 'money',
				align: 'right',
				titleAlign: 'right',
				filterOption: true,
				filterOptionType: 'number'
			},
			{	id: 'creditAmount',
				title: 'Credit Amount',
				width: '160px',
				geniisysClass: 'money',
				align: 'right',
				titleAlign: 'right',
				filterOption: true,
				filterOptionType: 'number'
			},
		],
		rows: objGICLAcctEntries.rows
	};
	
	tbgGICLAcctEntries = new MyTableGrid(acctEntriesModel);
	tbgGICLAcctEntries.pager = objGICLAcctEntries;
	tbgGICLAcctEntries.render('giclAcctEntriesListTableGrid');
	
	$("txtItemNo").value = objGICLS032.objCurrGICLClmLossExp.itemNo;
	$("txtItemTitle").value = unescapeHTML2(objGICLS032.objCurrGICLClmLossExp.dspItemTitle);
	$("txtPerilName").value = unescapeHTML2(objGICLS032.objCurrGICLClmLossExp.dspPerilName);
	$("txtPayeeName").value = unescapeHTML2(objGICLS032.objCurrGICLClmLossExp.dspPayeeName);
	
	$("btnAcctName").observe("click", function(){
		showOverlayEditor("txtAcctName", 500, $("txtAcctName").hasAttribute("readonly"));
	});
	
	computeTotals();
</script>