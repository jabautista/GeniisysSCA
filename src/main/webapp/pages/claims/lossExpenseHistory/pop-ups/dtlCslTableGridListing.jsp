<div id="dtlCslTableGrid" style="height: 156px; margin:10px; width: 560px;"></div>

<script type="text/javascript">
	try{
		var objDtlCslTG = JSON.parse('${jsonDtlCsl}');
		var objDtlCsl = objDtlCslTG.rows || [];
		
		var dtlCslTableModel = {
			id : 16,
			url : contextPath + "/GICLLossExpDtlController?action=getDtlCslList"
					          + "&claimId="+ nvl(objCLMGlobal.claimId, 0)
					          +"&clmLossId="+nvl(currCslClmLossId, 0)
					          +"&lineCd="+objCLMGlobal.lineCd,
			options:{
				title: '',
				pager: { },
				width: '560px',
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN]
				},
				onCellFocus: function(element, value, x, y, id){
					dtlCslTableGrid.releaseKeys();
				},
				onRemoveRowFocus: function() {
					dtlCslTableGrid.releaseKeys();
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
			rows : objDtlCsl,
			requiredColumns: ''
		};
		
		dtlCslTableGrid = new MyTableGrid(dtlCslTableModel);
		dtlCslTableGrid.pager = objDtlCslTG;
		dtlCslTableGrid.render('dtlCslTableGrid');
		computeTotalDtlCslAmount();
		
	}catch(e){
		showErrorMessage("Loss Expense Hist - Dtl CSL", e);
	}
	
	function computeTotalDtlCslAmount(){
		var totalAmt = 0;
		for(var i=0; i<objDtlCsl.length; i++){
			if(objDtlCsl[i].recordStatus != -1){
				totalAmt = parseFloat(nvl(totalAmt,0)) + parseFloat(nvl(objDtlCsl[i].dtlAmt, 0));
			}
		}
		
		$("totalDtlCslAmt").value = formatCurrency(totalAmt);
	}
	
</script>