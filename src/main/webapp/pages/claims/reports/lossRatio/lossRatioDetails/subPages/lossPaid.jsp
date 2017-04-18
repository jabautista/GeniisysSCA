<div id="lossPaidMainDiv" class="sectionDiv" style="border: none; margin-bottom: 40px;">
	<div id="lossPaidTGDiv" class="sectionDiv" style="height: 313px; margin-left: 10px; margin-top: 10px; border: none;">
	
	</div>
</div>
<script type="text/javascript">
try{
	var objLossPaid = new Object();

	function initializeLossPaidPrl(){
		try{
			objLossPaid.objLossPaidPrlTableGrid = JSON.parse('${jsonLossPaid}');
			objLossPaid.objLossPaidPrl = objLossPaid.objLossPaidPrlTableGrid.rows || [];
			
			var lossPaidPrlModel = {
				url:contextPath+"/GICLLossRatioController?action=showLossPaid&refresh=1&queryAction=getLossPaidPrl&sessionId="+$F("hidSessionId"),
				options:{
					id: 'LPP',
					width: '900px',
					height: '298px',
					onCellFocus: function(element, value, x, y, id){
						lossPaidPrlTableGrid.keys.removeFocus(lossPaidPrlTableGrid.keys._nCurrentFocus, true);
						lossPaidPrlTableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus:function(element, value, x, y, id){
						lossPaidPrlTableGrid.keys.removeFocus(lossPaidPrlTableGrid.keys._nCurrentFocus, true);
						lossPaidPrlTableGrid.keys.releaseKeys();
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
						id: 'nbtClaimNo',
						title: 'Claim No.',
						width: '150px',
						visible: true
					},
					{
						id: 'nbtAssured',
						title: 'Assured',
						width: '315px',
						visible: true
					},
					{
						id: 'nbtPerilName',
						title: 'Peril',
						width: '150px',
						visible: true
					},
					{
						id: 'nbtLossDate',
						title: 'Loss Date',
						width: '90px',
						align: 'center',
						titleAlign: 'center',
						visible: true
					},
					{
						id: 'lossPaid',
						title: 'Loss Amt.',
						width: '155px',
						align: 'right',
						titleAlign: 'right',
						geniisysClass: 'money',
						visible: true
					},
				],
				rows: objLossPaid.objLossPaidPrl
			};
			lossPaidPrlTableGrid = new MyTableGrid(lossPaidPrlModel);
			lossPaidPrlTableGrid.pager = objLossPaid.objLossPaidPrlTableGrid;
			lossPaidPrlTableGrid.render('lossPaidTGDiv');
		}catch(e){
			showErrorMessage("initializeLossPaid",e);
		}
	}
	
	function initializeLossPaidIntm(){
		try{
			objLossPaid.objLossPaidIntmTableGrid = JSON.parse('${jsonLossPaid}');
			objLossPaid.objLossPaidIntm = objLossPaid.objLossPaidIntmTableGrid.rows || [];
			
			var lossPaidIntmModel = {
				url:contextPath+"/GICLLossRatioController?action=showOutLoss&refresh=1&queryAction=getLossPaidIntm&sessionId="+$F("hidSessionId"),
				options:{
					id: 'LPI',
					width: '900px',
					height: '298px',
					onCellFocus: function(element, value, x, y, id){
						lossPaidIntmTableGrid.keys.removeFocus(lossPaidIntmTableGrid.keys._nCurrentFocus, true);
						lossPaidIntmTableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus:function(element, value, x, y, id){
						lossPaidIntmTableGrid.keys.removeFocus(lossPaidIntmTableGrid.keys._nCurrentFocus, true);
						lossPaidIntmTableGrid.keys.releaseKeys();
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
						id: 'nbtClaimNo',
						title: 'Claim No.',
						width: '220px',
						visible: true
					},
					{
						id: 'nbtAssured',
						title: 'Assured',
						width: '250px',
						visible: true
					},
					{
						id: 'nbtIntm',
						title: 'Intermediary',
						width: '180px',
						visible: true
					},
					{
						id: 'nbtLossDate',
						title: 'Loss Date',
						width: '90px',
						align: 'center',
						titleAlign: 'center',
						visible: true
					},
					{
						id: 'lossPaid',
						title: 'Loss Amt.',
						width: '155px',
						align: 'right',
						titleAlign: 'right',
						geniisysClass: 'money',
						visible: true
					},
				],
				rows: objLossPaid.objLossPaidIntm
			};
			lossPaidIntmTableGrid = new MyTableGrid(lossPaidIntmModel);
			lossPaidIntmTableGrid.pager = objLossPaid.objLossPaidIntmTableGrid;
			lossPaidIntmTableGrid.render('lossPaidTGDiv');
		}catch(e){
			showErrorMessage("initializeLossPaidIntm",e);
		}
	}
	
	function initializeLossPaid(){
		try{
			objLossPaid.objLossPaidTableGrid = JSON.parse('${jsonLossPaid}');
			objLossPaid.objLossPaid = objLossPaid.objLossPaidTableGrid.rows || [];
			
			var lossPaidModel = {
				url:contextPath+"/GICLLossRatioController?action=showLossPaid&refresh=1&queryAction=getLossPaid&sessionId="+$F("hidSessionId"),
				options:{
					id: 'LP',
					width: '900px',
					height: '298px',
					onCellFocus: function(element, value, x, y, id){
						lossPaidTableGrid.keys.removeFocus(lossPaidTableGrid.keys._nCurrentFocus, true);
						lossPaidTableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus:function(element, value, x, y, id){
						lossPaidTableGrid.keys.removeFocus(lossPaidTableGrid.keys._nCurrentFocus, true);
						lossPaidTableGrid.keys.releaseKeys();
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
						id: 'nbtClaimNo',
						title: 'Claim No.',
						width: '160px',
						visible: true
					},
					{
						id: 'nbtAssured',
						title: 'Assured',
						width: '481px',
						visible: true
					},
					{
						id: 'nbtLossDate',
						title: 'Loss Date',
						width: '90px',
						align: 'center',
						titleAlign: 'center',
						visible: true
					},
					{
						id: 'lossPaid',
						title: 'Loss Amt.',
						width: '155px',
						align: 'right',
						titleAlign: 'right',
						geniisysClass: 'money',
						visible: true
					},
				],
				rows: objLossPaid.objLossPaid
			};
			lossPaidTableGrid = new MyTableGrid(lossPaidModel);
			lossPaidTableGrid.pager = objLossPaid.objLossPaidTableGrid;
			lossPaidTableGrid.render('lossPaidTGDiv');
		}catch(e){
			showErrorMessage("initializeLossPaid",e);
		}
	}
	
	if($("rdoByPeril").checked){
		initializeLossPaidPrl();	
	}else if($("rdoByIntm").checked){
		initializeLossPaidIntm();
	}else{
		initializeLossPaid();
	}
	
}catch(e){
	showErrorMessage("lossPaid page", e);
}
</script>