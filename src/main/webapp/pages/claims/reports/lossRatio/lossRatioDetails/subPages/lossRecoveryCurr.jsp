<div id="lossRecCurrMainDiv" class="sectionDiv" style="border: none; margin-bottom: 40px;">
	<div id="lossRecCurrTGDiv" class="sectionDiv" style="height: 313px; margin-left: 10px; margin-top: 10px; border: none;">
	
	</div>
</div>
<script type="text/javascript">
try{
	var objLRCurr = new Object();

	function initializeLossRecCurrPrl(){
		try{
			objLRCurr.objLossRecCurrPrlTableGrid = JSON.parse('${jsonLossRec}');
			objLRCurr.objLossRecCurrPrl = objLRCurr.objLossRecCurrPrlTableGrid.rows || [];
			
			var lossRecCurrPrlModel = {
				url:contextPath+"/GICLLossRatioController?action=showLossRec&refresh=1&queryAction=getLossRecCurrPrl&year=curr&sessionId="+$F("hidSessionId"),
				options:{
					id: 'LRCP',
					width: '900px',
					height: '298px',
					onCellFocus: function(element, value, x, y, id){
						lossRecCurrPrlTableGrid.keys.removeFocus(lossRecCurrPrlTableGrid.keys._nCurrentFocus, true);
						lossRecCurrPrlTableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus:function(element, value, x, y, id){
						lossRecCurrPrlTableGrid.keys.removeFocus(lossRecCurrPrlTableGrid.keys._nCurrentFocus, true);
						lossRecCurrPrlTableGrid.keys.releaseKeys();
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
						id: 'nbtRecNo',
						title: 'Recovery No',
						width: '110px',
						visible: true
					},
					{
						id: 'nbtAssured',
						title: 'Assured',
						width: '245px',
						visible: true
					},
					{
						id: 'nbtPerilName',
						title: 'Peril',
						width: '130px',
						visible: true
					},
					{
						id: 'nbtRecType',
						title: 'Recovery Type',
						width: '130px',
						visible: true
					},
					{
						id: 'nbtDateRecovered',
						title: 'Date Covered',
						width: '90px',
						align: 'center',
						titleAlign: 'center',
						visible: true
					},
					{
						id: 'recoveredAmt',
						title: 'Recovered Amount',
						width: '155px',
						align: 'right',
						titleAlign: 'right',
						geniisysClass: 'money',
						visible: true
					},
				],
				rows: objLRCurr.objLossRecCurrPrl
			};
			lossRecCurrPrlTableGrid = new MyTableGrid(lossRecCurrPrlModel);
			lossRecCurrPrlTableGrid.pager = objLRCurr.objLossRecCurrPrlTableGrid;
			lossRecCurrPrlTableGrid.render('lossRecCurrTGDiv');
		}catch(e){
			showErrorMessage("initializeLossRecCurrPrl",e);
		}
	}
	
	function initializeLossRecCurrIntm(){
		try{
			objLRCurr.objLossRecCurrIntmTableGrid = JSON.parse('${jsonLossRec}');
			objLRCurr.objLossRecCurrIntm = objLRCurr.objLossRecCurrIntmTableGrid.rows || [];
			
			var lossRecCurrIntmModel = {
				url:contextPath+"/GICLLossRatioController?action=showLossRec&refresh=1&queryAction=getLossRecCurrIntm&year=curr&sessionId="+$F("hidSessionId"),
				options:{
					id: 'LRCI',
					width: '900px',
					height: '298px',
					onCellFocus: function(element, value, x, y, id){
						lossRecCurrIntmTableGrid.keys.removeFocus(lossRecCurrIntmTableGrid.keys._nCurrentFocus, true);
						lossRecCurrIntmTableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus:function(element, value, x, y, id){
						lossRecCurrIntmTableGrid.keys.removeFocus(lossRecCurrIntmTableGrid.keys._nCurrentFocus, true);
						lossRecCurrIntmTableGrid.keys.releaseKeys();
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
						id: 'nbtRecNo',
						title: 'Recovery No',
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
						id: 'nbtRecType',
						title: 'Recovery Type',
						width: '180px',
						visible: true
					},
					{
						id: 'nbtDateRecovered',
						title: 'Date Covered',
						width: '90px',
						align: 'center',
						titleAlign: 'center',
						visible: true
					},
					{
						id: 'recoveredAmt',
						title: 'Recovered Amount',
						width: '155px',
						align: 'right',
						titleAlign: 'right',
						geniisysClass: 'money',
						visible: true
					},
				],
				rows: objLRCurr.objLossRecCurrIntm
			};
			lossRecCurrIntmTableGrid = new MyTableGrid(lossRecCurrIntmModel);
			lossRecCurrIntmTableGrid.pager = objLRCurr.objLossRecCurrIntmTableGrid;
			lossRecCurrIntmTableGrid.render('lossRecCurrTGDiv');
		}catch(e){
			showErrorMessage("initializeLossRecCurrIntm",e);
		}
	}
	
	function initializeLossRecCurr(){
		try{
			objLRCurr.objLossRecCurrTableGrid = JSON.parse('${jsonLossRec}');
			objLRCurr.objLossRecCurr = objLRCurr.objLossRecCurrTableGrid.rows || [];
			
			var lossRecCurrModel = {
				url:contextPath+"/GICLLossRatioController?action=showLossRec&refresh=1&queryAction=getLossRecCurr&year=curr&sessionId="+$F("hidSessionId"),
				options:{
					id: 'LRC',
					width: '900px',
					height: '298px',
					onCellFocus: function(element, value, x, y, id){
						lossRecCurrTableGrid.keys.removeFocus(lossRecCurrTableGrid.keys._nCurrentFocus, true);
						lossRecCurrTableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus:function(element, value, x, y, id){
						lossRecCurrTableGrid.keys.removeFocus(lossRecCurrTableGrid.keys._nCurrentFocus, true);
						lossRecCurrTableGrid.keys.releaseKeys();
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
						id: 'nbtRecNo',
						title: 'Recovery No',
						width: '110px',
						visible: true
					},
					{
						id: 'nbtAssured',
						title: 'Assured',
						width: '350px',
						visible: true
					},
					{
						id: 'nbtRecType',
						title: 'Recovery Type',
						width: '140px',
						visible: true
					},
					{
						id: 'nbtDateRecovered',
						title: 'Date Covered',
						width: '90px',
						align: 'center',
						titleAlign: 'center',
						visible: true
					},
					{
						id: 'recoveredAmt',
						title: 'Recovered Amount',
						width: '155px',
						align: 'right',
						titleAlign: 'right',
						geniisysClass: 'money',
						visible: true
					},
				],
				rows: objLRCurr.objLossRecCurr
			};
			lossRecCurrTableGrid = new MyTableGrid(lossRecCurrModel);
			lossRecCurrTableGrid.pager = objLRCurr.objLossRecCurrTableGrid;
			lossRecCurrTableGrid.render('lossRecCurrTGDiv');
		}catch(e){
			showErrorMessage("initializeLossRecCurr",e);
		}
	}
	
	if($("rdoByPeril").checked){
		initializeLossRecCurrPrl();	
	}else if($("rdoByIntm").checked){
		initializeLossRecCurrIntm();
	}else{
		initializeLossRecCurr();
	}
	
}catch(e){
	showErrorMessage("LossRecCurr page", e);
}
</script>