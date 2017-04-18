<div id="dtlLoaTableGrid" style="height: 130px; margin:10px; width: 560px;"></div>

<script type="text/javascript">
	try{
		var objDtlLoaTG = JSON.parse('${jsonDtlLoa}');
		var objDtlLoa = objDtlLoaTG.rows || [];
		
		var dtlLoaTableModel = {
			id : 14,
			url : contextPath +"/GICLLossExpDtlController?action=getDtlLoaList"
					          +"&claimId="+ nvl(objCLMGlobal.claimId, 0)
					          +"&clmLossId="+nvl(currLoaClmLossId, 0)
					          +"&lineCd="+objCLMGlobal.lineCd,
			options:{
				title: '',
				pager: { },
				width: '560px',
				/* toolbar: {
					elements: [MyTableGrid.REFRESH_BTN] // andrew - 09.19.2012 - comment out
				}, */
				onCellFocus: function(element, value, x, y, id){
					dtlLoaTableGrid.releaseKeys();
				},
				onRemoveRowFocus: function() {
					dtlLoaTableGrid.releaseKeys();
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
				{	id: 'nbtExpDesc',
					align: 'left',
				  	title: 'Parts/Labor/Materials',
				  	titleAlign: 'center',
				  	width: '400px',
				  	editable: false,
				  	sortable: true,
				  	filterOption: true
				},
				{
				   	id: 'dtlAmt',
				   	title: 'Amount',
				   	titleAlign: 'center',
				   	type : 'number',
				  	width: '150px',
				  	geniisysClass : 'money',
				  	filterOption: true,
					filterOptionType: 'number'
				}
			],
			rows : objDtlLoa,
			requiredColumns: ''
		};
		
		dtlLoaTableGrid = new MyTableGrid(dtlLoaTableModel);
		dtlLoaTableGrid.pager = objDtlLoaTG;
		dtlLoaTableGrid.render('dtlLoaTableGrid');
		computeTotalDtlLoaAmount();
		
	}catch(e){
		showErrorMessage("Loss Expense Hist - Dtl LOA", e);
	}
	
	function computeTotalDtlLoaAmount(){
		var totalAmt = 0;
		for(var i=0; i<objDtlLoa.length; i++){
			if(objDtlLoa[i].recordStatus != -1){
				totalAmt = parseFloat(nvl(totalAmt,0)) + parseFloat(nvl(objDtlLoa[i].dtlAmt, 0));
			}
		}
		
		$("totalDtlLoaAmt").value = formatCurrency(totalAmt);
	}
	
</script>