<div id="giclLossExpRidsTableGrid" style="height: 181px; margin:15px; width: 890px;"></div>

<script type="text/javascript">
try{
	var objGICLLossExpRids = JSON.parse('${jsonGiclLossExpRids}');
	var url = objCurrGICLLossExpDs == null ? "" : contextPath + "/GICLLossExpRidsController?action=getGiclLossExpRidsList&claimId="+ nvl(objCurrGICLLossExpDs.claimId, 0)
	          + "&clmLossId="+objCurrGICLLossExpDs.clmLossId+"&clmDistNo="+objCurrGICLLossExpDs.clmDistNo+"&grpSeqNo="+objCurrGICLLossExpDs.grpSeqNo;
	
	var giclLossExpRidsTableModel = {
		id : 7,
		url : url,
		options:{
			title: '',
			pager: { },
			width: '890px',
			toolbar: {
				elements: [MyTableGrid.REFRESH_BTN/*, MyTableGrid.FILTER_BTN*/]
			},
			onCellFocus: function(element, value, x, y, id){
				giclLossExpRidsTableGrid.releaseKeys();
			},
			onRemoveRowFocus: function() {
				giclLossExpRidsTableGrid.releaseKeys();
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
			{	id: 'dspRiName',
				align: 'left',
			  	title: 'Reinsurer Name',
			  	titleAlign: 'center',
			  	width: '213px',
			  	editable: false,
			  	sortable: true,
			  	filterOption: true
			},
			{
			   	id: 'shrLossExpRiPct',
			   	title: 'Share Percentage',
			   	titleAlign: 'center',
			   	type : 'number',
			  	width: '120px',
			  	geniisysClass: 'rate',
			  	deciRate: 2,
			  	filterOption: true,
				filterOptionType: 'number'
			},
			{
			   	id: 'shrLeRiPdAmt',
			   	title: 'Share Paid Amount',
			   	titleAlign: 'center',
			   	type : 'number',
			  	width: '180px',
			  	geniisysClass : 'money',
			  	filterOption: true,
				filterOptionType: 'number'
			},
			{
			   	id: 'shrLeRiAdvAmt',
			   	title: 'Share Advice Amount',
			   	titleAlign: 'center',
			   	type : 'number',
			  	width: '180px',
			  	geniisysClass : 'money',
			  	filterOption: true,
				filterOptionType: 'number'
			},
			{
			   	id: 'shrLeRiNetAmt',
			   	title: 'Share Net Amount',
			   	titleAlign: 'center',
			   	type : 'number',
			  	width: '180px',
			  	geniisysClass : 'money',
			  	filterOption: true,
				filterOptionType: 'number'
			}
			
		],
		rows : objGICLLossExpRids.rows,
		requiredColumns: ''
	};
	
	giclLossExpRidsTableGrid = new MyTableGrid(giclLossExpRidsTableModel);
	giclLossExpRidsTableGrid.pager = objGICLLossExpRids;
	giclLossExpRidsTableGrid.render('giclLossExpRidsTableGrid');
	
}catch(e){
	showErrorMessage("Loss Expense Hist - giclLossExpRids", e);
}
</script>