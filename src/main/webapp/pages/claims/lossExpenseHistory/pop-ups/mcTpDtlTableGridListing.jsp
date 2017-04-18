<div id="mcTpDtlTableGrid" style="height: 130px; margin:10px; width: 420px;"></div>

<script type="text/javascript">
	try{
		var objMcTpDtlTG = JSON.parse('${jsonMcTpDtl}');
		var objMcTpDtl = objMcTpDtlTG.rows || [];
		objMcTpDtlRow = new Object();
		
		var mcTpDtlTableModel = {
			id : 13,
			url : contextPath + "/GICLMcTpDtlController?action=getMcTpDtlForLOA"
					          + "&claimId="+ nvl(objCLMGlobal.claimId, 0),
			options:{
				title: '',
				pager: { },
				width: '420px',
				/* toolbar: {
					elements: [MyTableGrid.REFRESH_BTN] // andrew - 09.18.2012 - comment out
				}, */
				onCellFocus: function(element, value, x, y, id){
					objMcTpDtlRow = mcTpDtlTableGrid.geniisysRows[y];  //koks
					mcTpDtlTableGrid.releaseKeys();
				},
				onRemoveRowFocus: function() {
					objMcTpDtlRow = "";
					mcTpDtlTableGrid.releaseKeys();
				},
				onSort: function(){
					objMcTpDtlRow = "";
					mcTpDtlTableGrid.releaseKeys();
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
				{	id: 'payeeName',
					align: 'left',
				  	title: 'Third Party Name',
				  	titleAlign: 'center',
				  	width: '410px',
				  	editable: false,
				  	sortable: true,
				  	filterOption: true
				}
			],
			rows : objMcTpDtl,
			requiredColumns: ''
		};
		
		mcTpDtlTableGrid = new MyTableGrid(mcTpDtlTableModel);
		mcTpDtlTableGrid.pager = objMcTpDtlTG;
		mcTpDtlTableGrid.render('mcTpDtlTableGrid');
		mcTpDtlTableGrid.afterRender = function(){ // added by Kris 03.27.2014
			if(mcTpDtlTableGrid.geniisysRows.length > 0){
				mcTpDtlTableGrid.selectRow(0);
				objMcTpDtlRow = mcTpDtlTableGrid.geniisysRows[0];
			}
		};
		
	}catch(e){
		showErrorMessage("Loss Expense Hist - MC Tp Dtl", e);
	}
	
	
</script>