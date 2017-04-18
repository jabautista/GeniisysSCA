<div id="lossRatioSummaryMainDiv" class="sectionDiv" style="border: none;">
	<div id="lossRatioSummaryTGDiv" class="sectionDiv" style="height: 313px; margin-left: 10px; margin-top: 10px; border: none;">

	</div>
	<div id="totalsDiv" class="sectionDiv" style="border: none; margin-top: 10px; margin-bottom: 27px;">
		<fieldset style="width: 883px; margin-left: 10px;">
		<legend><b>Totals</b></legend>
			<table>
				<tr>
					<td class="rightAligned" width="153px">Loss Paid</td>
					<td><input type="text" id="txtLossPaidTotal" style="width: 135px; text-align: right; " readonly="readonly"/></td>
					<td class="rightAligned" width="164px">Premiums Written</td>
					<td><input type="text" id="txtPremWrittenTotal" style="width: 135px; text-align: right; " readonly="readonly"/></td>
					<td class="rightAligned" width="108px">Losses Incurred</td>
					<td><input type="text" id="txtLossIncurredTotal" style="width: 135px; text-align: right; " readonly="readonly"/></td>
				</tr>
				<tr>
					<td class="rightAligned">Outstanding Loss (Curr Yr)</td>
					<td><input type="text" id="txtCurrOsTotal" style="width: 135px; text-align: right; " readonly="readonly"/></td>
					<td class="rightAligned">Premiums Reserve (Curr Yr)</td>
					<td><input type="text" id="txtCurrPremResTotal" style="width: 135px; text-align: right; " readonly="readonly"/></td>
					<td class="rightAligned">Premiums Earned</td>
					<td><input type="text" id="txtPremEarnedTotal" style="width: 135px; text-align: right; " readonly="readonly"/></td>
				</tr>
				<tr>
					<td class="rightAligned">Outstanding Loss (Prev Yr)</td>
					<td><input type="text" id="txtPrevOsTotal" style="width: 135px; text-align: right; " readonly="readonly"/></td>
					<td class="rightAligned">Premiums Reserve (Prev Yr)</td>
					<td><input type="text" id="txtPrevPremResTotal" style="width: 135px; text-align: right; " readonly="readonly"/></td>
					<td class="rightAligned">Loss Ratio</td>
					<td><input type="text" id="txtLossRatioTotal" style="width: 135px; text-align: right; " readonly="readonly"/></td>
				</tr>
			</table>
		</fieldset>
	</div>
</div>
<script type="text/JavaScript">
try{
	var objLRSumm = new Object();
	objLRSumm.objLossRatioSummaryTableGrid = JSON.parse('${jsonLossRatioSummary}');
	objLRSumm.objLossRatioSummary = objLRSumm.objLossRatioSummaryTableGrid.rows || []; 

	var lossRatioSummaryModel = {
		url:contextPath+"/GICLLossRatioController?action=showLossRatioSummary&refresh=1&sessionId="+$F("hidSessionId")+"&prntOption="+$F("hidPrntOption"),
		options:{
			id: 'LRS',
			width: '900px',
			height: '298px',
			onCellFocus: function(element, value, x, y, id){
				lossRatioSummaryTableGrid.keys.removeFocus(lossRatioSummaryTableGrid.keys._nCurrentFocus, true);
				lossRatioSummaryTableGrid.keys.releaseKeys();
			},
			onRemoveRowFocus:function(element, value, x, y, id){
				lossRatioSummaryTableGrid.keys.removeFocus(lossRatioSummaryTableGrid.keys._nCurrentFocus, true);
				lossRatioSummaryTableGrid.keys.releaseKeys();
			}					
		},
		columnModel:[
	 		{   id: 'recordStatus',
			    title: '',
			    width: '0px',
			    visible: false,
			    editor: 'checkbox' 			
			},
			{	id: 'divCtrId',
				width: '0px',
				visible: false
			},
			{
				id: 'display',
				title: objLRSumm.objLossRatioSummary[0].displayLabel,
				width: '250px',
				visible: true,
				sortable: true
			},
			{
				id: 'lossPaidAmt',
				title: 'Loss Paid',
				width: '155px',
				align: 'right',
				titleAlign: 'right',
				geniisysClass: 'money',
				visible: true,
				sortable: true
			},
			{
				id: 'currLossRes',
				title: 'Outstanding Loss(Curr Yr)',
				width: '155px',
				align: 'right',
				titleAlign: 'right',
				geniisysClass: 'money',
				visible: true,
				sortable: true
			},
			{
				id: 'prevLossRes',
				title: 'Outstanding Loss(Prev Yr)',
				width: '155px',
				align: 'right',
				titleAlign: 'right',
				geniisysClass: 'money',
				visible: true,
				sortable: true
			},
			{
				id: 'currPremAmt',
				title: 'Premiums Written',
				width: '155px',
				align: 'right',
				titleAlign: 'right',
				geniisysClass: 'money',
				visible: true,
				sortable: true
			},
			{
				id: 'currPremRes',
				title: 'Premiums Reserve(Curr Yr)',
				width: '165px',
				align: 'right',
				titleAlign: 'right',
				geniisysClass: 'money',
				visible: true,
				sortable: true
			},
			{
				id: 'prevPremRes',
				title: 'Premiums Reserve(Prev Yr)',
				width: '165px',
				align: 'right',
				titleAlign: 'right',
				geniisysClass: 'money',
				visible: true,
				sortable: true
			},
			{
				id: 'lossesIncurred',
				title: 'Losses Incurred',
				width: '155px',
				align: 'right',
				titleAlign: 'right',
				geniisysClass: 'money',
				visible: true,
				sortable: true
			},
			{
				id: 'premiumEarned',
				title: 'Premiums Earned',
				width: '155px',
				align: 'right',
				titleAlign: 'right',
				geniisysClass: 'money',
				visible: true,
				sortable: true
			},
			{
				id: 'lossRatio',
				title: 'Loss Ratio',
				width: '155px',
				align: 'right',
				titleAlign: 'right',
				visible: true,
				sortable: true,
				renderer : function(value){
                	return formatToNthDecimal(value, 4); //Dren Niebres 06.03.2016 SR-21428
	   			}
			},
		],
		rows: objLRSumm.objLossRatioSummary
	};
	lossRatioSummaryTableGrid = new MyTableGrid(lossRatioSummaryModel);
	lossRatioSummaryTableGrid.pager = objLRSumm.objLossRatioSummaryTableGrid;
	lossRatioSummaryTableGrid.render('lossRatioSummaryTGDiv');
	lossRatioSummaryTableGrid.afterRender = function(){
		try{
			if(objLRSumm.objLossRatioSummary.length > 0){
				$("txtLossPaidTotal").value = formatCurrency(objLRSumm.objLossRatioSummary[0].sumLossPaidAmt);
				$("txtCurrOsTotal").value = formatCurrency(objLRSumm.objLossRatioSummary[0].sumCurrLossRes);
				$("txtPrevOsTotal").value = formatCurrency(objLRSumm.objLossRatioSummary[0].sumPrevLossRes);
				$("txtPremWrittenTotal").value = formatCurrency(objLRSumm.objLossRatioSummary[0].sumCurrPremAmt);
				$("txtCurrPremResTotal").value = formatCurrency(objLRSumm.objLossRatioSummary[0].sumCurrPremRes);
				$("txtPrevPremResTotal").value = formatCurrency(objLRSumm.objLossRatioSummary[0].sumPrevPremRes);
				$("txtLossIncurredTotal").value = formatCurrency(objLRSumm.objLossRatioSummary[0].sumLossesIncurred);
				$("txtPremEarnedTotal").value = formatCurrency(objLRSumm.objLossRatioSummary[0].sumPremiumEarned);
				$("txtLossRatioTotal").value = formatToNthDecimal(objLRSumm.objLossRatioSummary[0].sumLossRatio, 4); //Dren Niebres 06.03.2016 SR-21428
			}
		}catch(e){
			showErrorMessage("lossRatioSummaryTableGrid.afterRender ", e);
		}
		
	};
}catch(e){
	showErrorMessage("lossRatioSummary page", e);
}
</script>