<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    

<div id="slSummaryTGDiv" style="padding: 20px 20px 25px 70px; height: 250px; width: 85%;"></div>

<div id="slAmtTotalsDiv" style="padding: 0 0px 60px 90px; width: 85%;">
	<table align="right">
		<tr>
			<td style="margin: 0 5px 0 0px;"> Total Debit Amount </td>
			<td><input id="txtSlTotalDebitAmt" type="text" readonly="readonly" class="money" value="0.00" style="width: 120px; "></td> 
			<td style="margin: 0 5px 0 25px;"> Total Credit Amount </td>
			<td><input id="txtSlTotalCreditAmt" type="text" readonly="readonly" class="money" value="0.00" style="width: 120px;"></td>
		</tr>
	</table>
</div>

<div align="center" class="buttonsDiv" style="margin-bottom: 30px;">
	<input id="btnReturn" type="button" class="button" value="Return" style="margin-right: 10px; width: 120px;">
</div>
 

<script type="text/javascript">
try{
	var selectedIndex = -1;	//holds the selected index
	var selectedRowInfo = null;	//holds the selected row info
	
	
	var objSlSummary = new Object();
	objSlSummary.slSummaryTG = JSON.parse('${slSummaryTableGrid}'.replace(/\\/g, '\\\\'));
	objSlSummary.slSummaryObjRows = objSlSummary.slSummaryTG.rows || [];
	objSlSummary.slSummaryList = [];	// holds all the geniisys rows
	
	try{
		var slSummaryTableModel = {
			url: objGIACS230.slSummaryURL+"&refresh=1",
			options: {
				width:	'800px',
				height: '250px',
				onCellFocus: function(element, value, x, y, id){
					selectedIndex = y;
					selectedRowInfo = slSummaryTG.geniisysRows[y];
				},
				onRemoveRowFocus: function(){
					slSummaryTG.keys.releaseKeys();
					selectedIndex = -1;
					selectedRowInfo = "";
				},
				onRefresh: function(){
					slSummaryTG.onRemoveRowFocus();
				},
				toolbar: {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						slSummaryTG.onRemoveRowFocus();
					}
				}
			},
			columnModel: [
							{
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
								id: 'fundCd',
								title: 'Company',
								titleAlign: 'center',
								width: '100px',
								filterOption: true
							},
							{
								id: 'branchCd',
								title: 'Branch',
								titleAlign: 'center',
								width: '70px',
								filterOption: true
							},
							{
								id: 'slCd',
								title: 'SL Code',
								titleAlign: 'center',
								width: '70px',
								filterOption: true
							},
							{
								id: 'slName',
								title: 'SL Name',
								titleAlign: 'center',
								width: '280px',
								filterOption: true
							},
							{
								id: 'debitAmt',
								title: 'Total Debit',
								titleAlign: 'center',
								align: 'right',
								width: '130px',
								geniisysClass: 'money',
								geniisysMaxValue: '999,999,999,999.99'
							},
							{
								id: 'creditAmt',
								title: 'Total Credit',
								titleAlign: 'center',
								align: 'right',
								width: '130px',
								geniisysClass: 'money',
								geniisysMaxValue: '999,999,999,999.99'
							}				
			],
			rows: objSlSummary.slSummaryObjRows
		};
		
		slSummaryTG = new MyTableGrid(slSummaryTableModel);
		slSummaryTG.pager = objSlSummary.slSummaryTG;
		slSummaryTG.render('slSummaryTGDiv');
		slSummaryTG.afterRender = function(){
			objSlSummary.slSummaryList = slSummaryTG.geniisysRows;
	
			var totalDebitAmt = 0;
			var totalCreditAmt = 0;
			var list = objSlSummary.slSummaryList; 
			
			for (var i=0; i<list.length; i++){
				totalDebitAmt = parseFloat(nvl(totalDebitAmt, 0)) + parseFloat(nvl(list[i].debitAmt, 0));
				totalCreditAmt = parseFloat(nvl(totalCreditAmt, 0)) + parseFloat(nvl(list[i].creditAmt, 0));
			}
			
			$("txtSlTotalDebitAmt").value = formatCurrency(totalDebitAmt);
			$("txtSlTotalCreditAmt").value = formatCurrency(totalCreditAmt);
		};
		
	}catch (e) {
		showMessageBox("Error in SL Summary TableGrid: " + e, imgMessage.ERROR);
	}


	$("btnReturn").observe("click", function(){
		try{
			slSummaryTG.keys.releaseKeys();
			showGIACS230("N");
		}catch(e){
			showErrorMessage("btnReturn", e);
		}
	});	
	
}catch(e){
	showErrorMessage("slSummaryTableGrid page: ", e);
}	
	
</script>