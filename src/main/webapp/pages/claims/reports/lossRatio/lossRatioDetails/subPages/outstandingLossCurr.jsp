<div id="outLossCurrMainDiv" class="sectionDiv" style="border: none; margin-bottom: 40px;">
	<div id="outLossCurrTGDiv" class="sectionDiv" style="height: 313px; margin-left: 10px; margin-top: 10px; border: none;">
	
	</div>
</div>
<script type="text/javascript">
try{
	var objOLCurr = new Object();

	function initializeOutLossCurrPrl(){
		try{
			objOLCurr.objOutLossCurrPrlTableGrid = JSON.parse('${jsonOutLoss}');
			objOLCurr.objOutLossCurrPrl = objOLCurr.objOutLossCurrPrlTableGrid.rows || [];
			
			var outLossCurrPrlModel = {
				url:contextPath+"/GICLLossRatioController?action=showOutLoss&refresh=1&queryAction=getOutLossCurrPrl&year=curr&sessionId="+$F("hidSessionId"),
				options:{
					id: 'OCP',
					width: '900px',
					height: '298px',
					onCellFocus: function(element, value, x, y, id){
						outLossCurrPrlTableGrid.keys.removeFocus(outLossCurrPrlTableGrid.keys._nCurrentFocus, true);
						outLossCurrPrlTableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus:function(element, value, x, y, id){
						outLossCurrPrlTableGrid.keys.removeFocus(outLossCurrPrlTableGrid.keys._nCurrentFocus, true);
						outLossCurrPrlTableGrid.keys.releaseKeys();
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
						width: '250px',
						visible: true
					},
					{
						id: 'nbtPerilName',
						title: 'Peril',
						width: '125px',
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
				rows: objOLCurr.objOutLossCurrPrl
			};
			outLossCurrPrlTableGrid = new MyTableGrid(outLossCurrPrlModel);
			outLossCurrPrlTableGrid.pager = objOLCurr.objOutLossCurrPrlTableGrid;
			outLossCurrPrlTableGrid.render('outLossCurrTGDiv');
		}catch(e){
			showErrorMessage("initializeOutLossCurrPrl",e);
		}
	}
	
	function initializeOutLossCurrIntm(){
		try{
			objOLCurr.objOutLossCurrIntmTableGrid = JSON.parse('${jsonOutLoss}');
			objOLCurr.objOutLossCurrIntm = objOLCurr.objOutLossCurrIntmTableGrid.rows || [];
			
			var outLossCurrIntmModel = {
				url:contextPath+"/GICLLossRatioController?action=showOutLoss&refresh=1&queryAction=getOutLossCurrIntm&year=curr&sessionId="+$F("hidSessionId"),
				options:{
					id: 'OCI',
					width: '900px',
					height: '298px',
					onCellFocus: function(element, value, x, y, id){
						outLossCurrIntmTableGrid.keys.removeFocus(outLossCurrIntmTableGrid.keys._nCurrentFocus, true);
						outLossCurrIntmTableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus:function(element, value, x, y, id){
						outLossCurrIntmTableGrid.keys.removeFocus(outLossCurrIntmTableGrid.keys._nCurrentFocus, true);
						outLossCurrIntmTableGrid.keys.releaseKeys();
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
				rows: objOLCurr.objOutLossCurrIntm
			};
			outLossCurrIntmTableGrid = new MyTableGrid(outLossCurrIntmModel);
			outLossCurrIntmTableGrid.pager = objOLCurr.objOutLossCurrIntmTableGrid;
			outLossCurrIntmTableGrid.render('outLossCurrTGDiv');
		}catch(e){
			showErrorMessage("initializeOutLossCurrIntm",e);
		}
	}
	
	function initializeOutLossCurr(){
		try{
			objOLCurr.objOutLossCurrTableGrid = JSON.parse('${jsonOutLoss}');
			objOLCurr.objOutLossCurr = objOLCurr.objOutLossCurrTableGrid.rows || [];
			
			var outLossCurrModel = {
				url:contextPath+"/GICLLossRatioController?action=showOutLoss&refresh=1&queryAction=getOutLossCurr&year=curr&sessionId="+$F("hidSessionId"),
				options:{
					id: 'OSC',
					width: '900px',
					height: '298px',
					onCellFocus: function(element, value, x, y, id){
						outLossCurrTableGrid.keys.removeFocus(outLossCurrTableGrid.keys._nCurrentFocus, true);
						outLossCurrTableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus:function(element, value, x, y, id){
						outLossCurrTableGrid.keys.removeFocus(outLossCurrTableGrid.keys._nCurrentFocus, true);
						outLossCurrTableGrid.keys.releaseKeys();
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
				rows: objOLCurr.objOutLossCurr
			};
			outLossCurrTableGrid = new MyTableGrid(outLossCurrModel);
			outLossCurrTableGrid.pager = objOLCurr.objOutLossCurrTableGrid;
			outLossCurrTableGrid.render('outLossCurrTGDiv');
		}catch(e){
			showErrorMessage("initializeOutLossCurr",e);
		}
	}
	
	if($("rdoByPeril").checked){
		initializeOutLossCurrPrl();	
	}else if($("rdoByIntm").checked){
		initializeOutLossCurrIntm();
	}else{
		initializeOutLossCurr();
	}
	
}catch(e){
	showErrorMessage("outstandingLossCurr page", e);
}
</script>
