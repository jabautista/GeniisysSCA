<div id="outLossPrevMainDiv" class="sectionDiv" style="border: none; margin-bottom: 40px;">
	<div id="outLossPrevTGDiv" class="sectionDiv" style="height: 313px; margin-left: 10px; margin-top: 10px; border: none;">
	
	</div>
</div>
<script type="text/javascript">
try{
	var objOLPrev = new Object();

	function initializeOutLossPrevPrl(){
		try{
			objOLPrev.objOutLossPrevPrlTableGrid = JSON.parse('${jsonOutLoss}');
			objOLPrev.objOutLossPrevPrl = objOLPrev.objOutLossPrevPrlTableGrid.rows || [];
			
			var outLossPrevPrlModel = {
				url:contextPath+"/GICLLossRatioController?action=showOutLoss&refresh=1&queryAction=getOutLossPrevPrl&year=prev&sessionId="+$F("hidSessionId"),
				options:{
					id: 'OPP',
					width: '900px',
					height: '298px',
					onCellFocus: function(element, value, x, y, id){
						outLossPrevPrlTableGrid.keys.removeFocus(outLossPrevPrlTableGrid.keys._nPreventFocus, true);
						outLossPrevPrlTableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus:function(element, value, x, y, id){
						outLossPrevPrlTableGrid.keys.removeFocus(outLossPrevPrlTableGrid.keys._nPreventFocus, true);
						outLossPrevPrlTableGrid.keys.releaseKeys();
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
						id: 'nbtPerilName',
						title: 'Peril',
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
						id: 'nbtFileDate',
						title: 'File Date',
						width: '90px',
						align: 'center',
						titleAlign: 'center',
						visible: true
					},
					{
						id: 'osAmt',
						title: 'Loss Amt.',
						width: '155px',
						align: 'right',
						titleAlign: 'right',
						geniisysClass: 'money',
						visible: true
					},
				],
				rows: objOLPrev.objOutLossPrevPrl
			};
			outLossPrevPrlTableGrid = new MyTableGrid(outLossPrevPrlModel);
			outLossPrevPrlTableGrid.pager = objOLPrev.objOutLossPrevPrlTableGrid;
			outLossPrevPrlTableGrid.render('outLossPrevTGDiv');
		}catch(e){
			showErrorMessage("initializeOutLossPrevPrl",e);
		}
	}
	
	function initializeOutLossPrevIntm(){
		try{
			objOLPrev.objOutLossPrevIntmTableGrid = JSON.parse('${jsonOutLoss}');
			objOLPrev.objOutLossPrevIntm = objOLPrev.objOutLossPrevIntmTableGrid.rows || [];
			
			var outLossPrevIntmModel = {
				url:contextPath+"/GICLLossRatioController?action=showOutLoss&refresh=1&queryAction=getOutLossPrevIntm&year=prev&sessionId="+$F("hidSessionId"),
				options:{
					id: 'OPI',
					width: '900px',
					height: '298px',
					onCellFocus: function(element, value, x, y, id){
						outLossPrevIntmTableGrid.keys.removeFocus(outLossPrevIntmTableGrid.keys._nPreventFocus, true);
						outLossPrevIntmTableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus:function(element, value, x, y, id){
						outLossPrevIntmTableGrid.keys.removeFocus(outLossPrevIntmTableGrid.keys._nPreventFocus, true);
						outLossPrevIntmTableGrid.keys.releaseKeys();
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
						id: 'nbtFileDate',
						title: 'File Date',
						width: '90px',
						align: 'center',
						titleAlign: 'center',
						visible: true
					},
					{
						id: 'osAmt',
						title: 'Loss Amt.',
						width: '155px',
						align: 'right',
						titleAlign: 'right',
						geniisysClass: 'money',
						visible: true
					},
				],
				rows: objOLPrev.objOutLossPrevIntm
			};
			outLossPrevIntmTableGrid = new MyTableGrid(outLossPrevIntmModel);
			outLossPrevIntmTableGrid.pager = objOLPrev.objOutLossPrevIntmTableGrid;
			outLossPrevIntmTableGrid.render('outLossPrevTGDiv');
		}catch(e){
			showErrorMessage("initializeOutLossPrevIntm",e);
		}
	}
	
	function initializeOutLossPrev(){
		try{
			objOLPrev.objOutLossPrevTableGrid = JSON.parse('${jsonOutLoss}');
			objOLPrev.objOutLossPrev = objOLPrev.objOutLossPrevTableGrid.rows || [];
			
			var outLossPrevModel = {
				url:contextPath+"/GICLLossRatioController?action=showOutLoss&refresh=1&queryAction=getOutLossPrev&year=prev&sessionId="+$F("hidSessionId"),
				options:{
					id: 'OSP',
					width: '900px',
					height: '298px',
					onCellFocus: function(element, value, x, y, id){
						outLossPrevTableGrid.keys.removeFocus(outLossPrevTableGrid.keys._nPreventFocus, true);
						outLossPrevTableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus:function(element, value, x, y, id){
						outLossPrevTableGrid.keys.removeFocus(outLossPrevTableGrid.keys._nPreventFocus, true);
						outLossPrevTableGrid.keys.releaseKeys();
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
						width: '389px',
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
						id: 'nbtFileDate',
						title: 'File Date',
						width: '90px',
						align: 'center',
						titleAlign: 'center',
						visible: true
					},
					{
						id: 'osAmt',
						title: 'Loss Amt.',
						width: '155px',
						align: 'right',
						titleAlign: 'right',
						geniisysClass: 'money',
						visible: true
					},
				],
				rows: objOLPrev.objOutLossPrev
			};
			outLossPrevTableGrid = new MyTableGrid(outLossPrevModel);
			outLossPrevTableGrid.pager = objOLPrev.objOutLossPrevTableGrid;
			outLossPrevTableGrid.render('outLossPrevTGDiv');
		}catch(e){
			showErrorMessage("initializeOutLossPrev",e);
		}
	}
	
	if($("rdoByPeril").checked){
		initializeOutLossPrevPrl();	
	}else if($("rdoByIntm").checked){
		initializeOutLossPrevIntm();
	}else{
		initializeOutLossPrev();
	}
	
}catch(e){
	showErrorMessage("outstandingLossPrev page", e);
}
</script>
