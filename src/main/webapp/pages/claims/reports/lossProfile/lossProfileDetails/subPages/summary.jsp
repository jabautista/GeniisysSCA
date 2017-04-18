<div id="summaryMainDiv" style="float: left; height: 400px;">
	<div id="summaryTGDiv" style="height: 270px; float: left; margin: 10px 10px 10px 10px;">
		
	</div>
	<div id="totalsDiv" style="float: left;">
		<fieldset style="width: 883px; margin-left: 10px; float: left;">
			<legend><b>Totals</b></legend>
			<table>
				<tr>
					<td class="rightAligned" width="100px">Claim Count</td>
					<td>
						<input type="text" id="txtSumClaimCount" style="width: 160px; text-align: right;"/>
					</td>
					<td class="rightAligned" width="100px">Gross Loss</td>
					<td>
						<input type="text" id="txtSumNbtGrossLoss" style="width: 160px; text-align: right;"/>
					</td>
					<td class="rightAligned" width="100px">Facultative</td>
					<td>
						<input type="text" id="txtSumFacultative" style="width: 160px; text-align: right;"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" width="100px">Sum Insured</td>
					<td>
						<input type="text" id="txtSumTotalTsiAmt" style="width: 160px; text-align: right;"/>
					</td>
					<td class="rightAligned" width="100px">Net Retention</td>
					<td>
						<input type="text" id="txtSumNetRetention" style="width: 160px; text-align: right;"/>
					</td>
					<td class="rightAligned" width="100px">Treaty</td>
					<td>
						<input type="text" id="txtSumTreaty" style="width: 160px; text-align: right;"/>
					</td>
				</tr>
			</table>
		</fieldset>
	</div>
</div>
<script type="text/JavaScript">
try{
	var objLPSumm = new Object();
	objLPSumm.objLossProfileSummaryTableGrid = JSON.parse('${jsonLossProfileSummary}');
	objLPSumm.objLossProfileSummary = objLPSumm.objLossProfileSummaryTableGrid.rows || []; 

	function initializeLossProfileSummary(){
		var lossProfileSummaryModel = {
			url:contextPath+"/GICLLossProfileController?action=showLossProfileSummary&refresh=1&globalChoice="+"L"+"&globalTreaty="+"Y"
						   +"&globalLineCd="+nvl($F("txtLineCd"), $F("txtDtlLineCd"))+"&globalSublineCd="+nvl($F("txtSublineCd"), $F("txtDtlSublineCd")),
			options:{
				hideColumnChildTitle: true,
				id: 3,
				width: '900px',
				height: '248px',
				onCellFocus: function(element, value, x, y, id){
					lossProfileSummaryTableGrid.keys.removeFocus(lossProfileSummaryTableGrid.keys._nCurrentFocus, true);
					lossProfileSummaryTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus:function(element, value, x, y, id){
					lossProfileSummaryTableGrid.keys.removeFocus(lossProfileSummaryTableGrid.keys._nCurrentFocus, true);
					lossProfileSummaryTableGrid.keys.releaseKeys();
				},
				toolbar:{
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onRefresh: function() {
						lossProfileSummaryTableGrid.keys.removeFocus(lossProfileSummaryTableGrid.keys._nCurrentFocus, true);
						lossProfileSummaryTableGrid.keys.releaseKeys();
					}
				},
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
					id 			 : "rangeFrom rangeTo",
					title		 : "Range",
					children	 : [
						{
							id : "rangeFrom",
							title: 'Range From',
							width: 155,
							align: 'right',
							geniisysClass: 'money',
							sortable: false,
							filterOption: true,
							filterOptionType: 'numberNoNegative'
						}, {
							id : "rangeTo",
							title: 'Range To',
							width: 155,
							align: 'right',
							geniisysClass: 'money',
							sortable: false,
							filterOption: true,
							filterOptionType: 'numberNoNegative'
						},
					]
				},
				{
					id: 'policyCount',
					title: 'Claim Count',
					width: '155px',
					align: 'right',
					titleAlign: 'right',
					visible: true,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{
					id: 'totalTsiAmt',
					title: 'Sum Insured',
					width: '155px',
					align: 'right',
					titleAlign: 'right',
					geniisysClass: 'money',
					visible: true,
					filterOption: true,
					filterOptionType: 'number'
				},
				{
					id: 'nbtGrossLoss',
					title: 'Gross Loss',
					width: '155px',
					align: 'right',
					titleAlign: 'right',
					geniisysClass: 'money',
					visible: true,
					filterOption: true,
					filterOptionType: 'number'
				},
				{
					id: 'netRetention',
					title: 'Net Retention',
					width: '155px',
					align: 'right',
					titleAlign: 'right',
					geniisysClass: 'money',
					visible: true,
					filterOption: true,
					filterOptionType: 'number'
				},
				{
					id: 'facultative',
					title: 'Facultative',
					width: '155px',
					align: 'right',
					titleAlign: 'right',
					geniisysClass: 'money',
					visible: true,
					filterOption: true,
					filterOptionType: 'number'
				},
				{
					id: 'treaty',
					title: 'Treaty',
					width: '155px',
					align: 'right',
					titleAlign: 'right',
					geniisysClass: 'money',
					visible: true,
					filterOption: true,
					filterOptionType: 'number'
				},
			],
			rows: objLPSumm.objLossProfileSummary
		};
		lossProfileSummaryTableGrid = new MyTableGrid(lossProfileSummaryModel);
		lossProfileSummaryTableGrid.pager = objLPSumm.objLossProfileSummaryTableGrid;
		lossProfileSummaryTableGrid.render('summaryTGDiv');
		lossProfileSummaryTableGrid.afterRender = function(){
			if(objLPSumm.objLossProfileSummary.length > 0){
				var i = objLPSumm.objLossProfileSummary.length - 1;
				$("txtSumClaimCount").value = objLPSumm.objLossProfileSummary[i].sumPolicyCount;
				$("txtSumNbtGrossLoss").value = formatCurrency(objLPSumm.objLossProfileSummary[i].sumNbtGrossLoss);
				$("txtSumFacultative").value = formatCurrency(objLPSumm.objLossProfileSummary[i].sumFacultative);
				$("txtSumTotalTsiAmt").value = formatCurrency(objLPSumm.objLossProfileSummary[i].sumTotalTsiAmt);
				$("txtSumNetRetention").value = formatCurrency(objLPSumm.objLossProfileSummary[i].sumNetRetention);
				$("txtSumTreaty").value = formatCurrency(objLPSumm.objLossProfileSummary[i].sumTreaty);
			}
		};
	}
	
	function initializeLossProfileSummaryTreaty(){
		var lossProfileSummaryModel = {
			url:contextPath+"/GICLLossProfileController?action=showLossProfileSummary&refresh=1&globalChoice="+"L"+"&globalTreaty="+"Y"
						   +"&globalLineCd="+nvl($F("txtLineCd"), $F("txtDtlLineCd"))+"&globalSublineCd="+nvl($F("txtSublineCd"), $F("txtDtlSublineCd")),
			options:{
				hideColumnChildTitle: true,
				id: 3,
				width: '900px',
				height: '248px',
				onCellFocus: function(element, value, x, y, id){
					lossProfileSummaryTableGrid.keys.removeFocus(lossProfileSummaryTableGrid.keys._nCurrentFocus, true);
					lossProfileSummaryTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus:function(element, value, x, y, id){
					lossProfileSummaryTableGrid.keys.removeFocus(lossProfileSummaryTableGrid.keys._nCurrentFocus, true);
					lossProfileSummaryTableGrid.keys.releaseKeys();
				},
				toolbar:{
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onRefresh: function() {
						lossProfileSummaryTableGrid.keys.removeFocus(lossProfileSummaryTableGrid.keys._nCurrentFocus, true);
						lossProfileSummaryTableGrid.keys.releaseKeys();
					}
				},
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
					id 			 : "rangeFrom rangeTo",
					title		 : "Range",
					sortable	 : true,
					children	 : [
						{
							id : "rangeFrom",
							width: 155,
							align: 'right',
							geniisysClass: 'money',
						}, {
							id : "rangeTo",
							width: 155,
							align: 'right',
							geniisysClass: 'money',
						},
					]
				},
				{
					id: 'policyCount',
					title: 'Claim Count',
					width: '155px',
					align: 'right',
					titleAlign: 'right',
					visible: true,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{
					id: 'totalTsiAmt',
					title: 'Sum Insured',
					width: '155px',
					align: 'right',
					titleAlign: 'right',
					geniisysClass: 'money',
					visible: true,
					filterOption: true,
					filterOptionType: 'number'
				},
				{
					id: 'nbtGrossLoss',
					title: 'Gross Loss',
					width: '155px',
					align: 'right',
					titleAlign: 'right',
					geniisysClass: 'money',
					visible: true,
					filterOption: true,
					filterOptionType: 'number'
				},
				{
					id: 'netRetention',
					title: 'Net Retention',
					width: '155px',
					align: 'right',
					titleAlign: 'right',
					geniisysClass: 'money',
					visible: true,
					filterOption: true,
					filterOptionType: 'number'
				},
				{
					id: 'facultative',
					title: 'Facultative',
					width: '155px',
					align: 'right',
					titleAlign: 'right',
					geniisysClass: 'money',
					visible: true,
					filterOption: true,
					filterOptionType: 'number'
				},
				{
					id: 'treaty1Loss',
					title: nvl(objLPSumm.objLossProfileSummary[0].lbl1, 'Treaty1'),
					width: '155px',
					align: 'right',
					titleAlign: 'right',
					geniisysClass: 'money',
					visible: true,
					filterOption: true,
					filterOptionType: 'number'
				},
				{
					id: 'treaty2Loss',
					title: nvl(objLPSumm.objLossProfileSummary[0].lbl2, 'Treaty2'),
					width: '155px',
					align: 'right',
					titleAlign: 'right',
					geniisysClass: 'money',
					visible: true,
					filterOption: true,
					filterOptionType: 'number'
				},
				{
					id: 'treaty3Loss',
					title: nvl(objLPSumm.objLossProfileSummary[0].lbl3, 'Treaty3'),
					width: '155px',
					align: 'right',
					titleAlign: 'right',
					geniisysClass: 'money',
					visible: true,
					filterOption: true,
					filterOptionType: 'number'
				},
				{
					id: 'treaty4Loss',
					title: nvl(objLPSumm.objLossProfileSummary[0].lbl4, 'Treaty4'),
					width: '155px',
					align: 'right',
					titleAlign: 'right',
					geniisysClass: 'money',
					visible: true,
					filterOption: true,
					filterOptionType: 'number'
				},
				{
					id: 'treaty5Loss',
					title: nvl(objLPSumm.objLossProfileSummary[0].lbl5, 'Treaty5'),
					width: '155px',
					align: 'right',
					titleAlign: 'right',
					geniisysClass: 'money',
					visible: true,
					filterOption: true,
					filterOptionType: 'number'
				},
				{
					id: 'treaty6Loss',
					title: nvl(objLPSumm.objLossProfileSummary[0].lbl6, 'Treaty6'),
					width: '155px',
					align: 'right',
					titleAlign: 'right',
					geniisysClass: 'money',
					visible: true,
					filterOption: true,
					filterOptionType: 'number'
				},
				{
					id: 'treaty7Loss',
					title: nvl(objLPSumm.objLossProfileSummary[0].lbl7, 'Treaty7'),
					width: '155px',
					align: 'right',
					titleAlign: 'right',
					geniisysClass: 'money',
					visible: true,
					filterOption: true,
					filterOptionType: 'number'
				},
				{
					id: 'treaty8Loss',
					title: nvl(objLPSumm.objLossProfileSummary[0].lbl8, 'Treaty8'),
					width: '155px',
					align: 'right',
					titleAlign: 'right',
					geniisysClass: 'money',
					visible: true,
					filterOption: true,
					filterOptionType: 'number'
				},
				{
					id: 'treaty9Loss',
					title: nvl(objLPSumm.objLossProfileSummary[0].lbl9, 'Treaty9'),
					width: '155px',
					align: 'right',
					titleAlign: 'right',
					geniisysClass: 'money',
					visible: true,
					filterOption: true,
					filterOptionType: 'number'
				},
				{
					id: 'treaty10Loss',
					title: nvl(objLPSumm.objLossProfileSummary[0].lbl10, 'Treaty10'),
					width: '155px',
					align: 'right',
					titleAlign: 'right',
					geniisysClass: 'money',
					visible: true,
					filterOption: true,
					filterOptionType: 'number'
				},
			],
			rows: objLPSumm.objLossProfileSummary
		};
		lossProfileSummaryTableGrid = new MyTableGrid(lossProfileSummaryModel);
		lossProfileSummaryTableGrid.pager = objLPSumm.objLossProfileSummaryTableGrid;
		lossProfileSummaryTableGrid.render('summaryTGDiv');
		lossProfileSummaryTableGrid.afterRender = function(){
			if(objLPSumm.objLossProfileSummary.length > 0){
				var i = objLPSumm.objLossProfileSummary.length - 1;
				$("txtSumClaimCount").value = objLPSumm.objLossProfileSummary[i].sumPolicyCount;
				$("txtSumNbtGrossLoss").value = formatCurrency(objLPSumm.objLossProfileSummary[i].sumNbtGrossLoss);
				$("txtSumFacultative").value = formatCurrency(objLPSumm.objLossProfileSummary[i].sumFacultative);
				$("txtSumTotalTsiAmt").value = formatCurrency(objLPSumm.objLossProfileSummary[i].sumTotalTsiAmt);
				$("txtSumNetRetention").value = formatCurrency(objLPSumm.objLossProfileSummary[i].sumNetRetention);
				$("txtSumTreaty").value = formatCurrency(objLPSumm.objLossProfileSummary[i].sumTreaty);			
			}
		};
	}

	if($("chkAllTreaties").checked){
		initializeLossProfileSummaryTreaty();
	}else{
		initializeLossProfileSummary();	
	}
	
}catch(e){
	showErrorMessage("summary page", e);
}
</script>