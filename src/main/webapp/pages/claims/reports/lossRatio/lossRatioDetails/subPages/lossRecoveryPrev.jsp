<div id="lossRecPrevMainDiv" class="sectionDiv" style="border: none; margin-bottom: 40px;">
	<div id="lossRecPrevTGDiv" class="sectionDiv" style="height: 313px; margin-left: 10px; margin-top: 10px; border: none;">
	
	</div>
</div>
<script type="text/javascript">
try{
	var objLRPrev = new Object();

	function initializeLossRecPrevPrl(){
		try{
			objLRPrev.objLossRecPrevPrlTableGrid = JSON.parse('${jsonLossRec}');
			objLRPrev.objLossRecPrevPrl = objLRPrev.objLossRecPrevPrlTableGrid.rows || [];
			
			var lossRecPrevPrlModel = {
				url:contextPath+"/GICLLossRatioController?action=showLossRec&refresh=1&queryAction=getLossRecPrevPrl&year=prev&sessionId="+$F("hidSessionId"),
				options:{
					id: 'LRPP',
					width: '900px',
					height: '298px',
					onCellFocus: function(element, value, x, y, id){
						lossRecPrevPrlTableGrid.keys.removeFocus(lossRecPrevPrlTableGrid.keys._nPreventFocus, true);
						lossRecPrevPrlTableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus:function(element, value, x, y, id){
						lossRecPrevPrlTableGrid.keys.removeFocus(lossRecPrevPrlTableGrid.keys._nPreventFocus, true);
						lossRecPrevPrlTableGrid.keys.releaseKeys();
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
						id: 'nbtPerilName',
						title: 'Peril',
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
				rows: objLRPrev.objLossRecPrevPrl
			};
			lossRecPrevPrlTableGrid = new MyTableGrid(lossRecPrevPrlModel);
			lossRecPrevPrlTableGrid.pager = objLRPrev.objLossRecPrevPrlTableGrid;
			lossRecPrevPrlTableGrid.render('lossRecPrevTGDiv');
		}catch(e){
			showErrorMessage("initializeLossRecPrevPrl",e);
		}
	}
	
	function initializeLossRecPrevIntm(){
		try{
			objLRPrev.objLossRecPrevIntmTableGrid = JSON.parse('${jsonLossRec}');
			objLRPrev.objLossRecPrevIntm = objLRPrev.objLossRecPrevIntmTableGrid.rows || [];
			
			var lossRecPrevIntmModel = {
				url:contextPath+"/GICLLossRatioController?action=showLossRecPrev&refresh=1&queryAction=getLossRecPrevIntm&year=prev&sessionId="+$F("hidSessionId"),
				options:{
					id: 'LRPI',
					width: '900px',
					height: '298px',
					onCellFocus: function(element, value, x, y, id){
						lossRecPrevIntmTableGrid.keys.removeFocus(lossRecPrevIntmTableGrid.keys._nPreventFocus, true);
						lossRecPrevIntmTableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus:function(element, value, x, y, id){
						lossRecPrevIntmTableGrid.keys.removeFocus(lossRecPrevIntmTableGrid.keys._nPreventFocus, true);
						lossRecPrevIntmTableGrid.keys.releaseKeys();
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
				rows: objLRPrev.objLossRecPrevIntm
			};
			lossRecPrevIntmTableGrid = new MyTableGrid(lossRecPrevIntmModel);
			lossRecPrevIntmTableGrid.pager = objLRPrev.objLossRecPrevIntmTableGrid;
			lossRecPrevIntmTableGrid.render('lossRecPrevTGDiv');
		}catch(e){
			showErrorMessage("initializeLossRecPrevIntm",e);
		}
	}
	
	function initializeLossRecPrev(){
		try{
			objLRPrev.objLossRecPrevTableGrid = JSON.parse('${jsonLossRec}');
			objLRPrev.objLossRecPrev = objLRPrev.objLossRecPrevTableGrid.rows || [];
			
			var lossRecPrevModel = {
				url:contextPath+"/GICLLossRatioController?action=showLossRecPrev&refresh=1&queryAction=getLossRecPrev&year=prev&sessionId="+$F("hidSessionId"),
				options:{
					id: 'LRP',
					width: '900px',
					height: '298px',
					onCellFocus: function(element, value, x, y, id){
						lossRecPrevTableGrid.keys.removeFocus(lossRecPrevTableGrid.keys._nPreventFocus, true);
						lossRecPrevTableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus:function(element, value, x, y, id){
						lossRecPrevTableGrid.keys.removeFocus(lossRecPrevTableGrid.keys._nPreventFocus, true);
						lossRecPrevTableGrid.keys.releaseKeys();
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
				rows: objLRPrev.objLossRecPrev
			};
			lossRecPrevTableGrid = new MyTableGrid(lossRecPrevModel);
			lossRecPrevTableGrid.pager = objLRPrev.objLossRecPrevTableGrid;
			lossRecPrevTableGrid.render('lossRecPrevTGDiv');
		}catch(e){
			showErrorMessage("initializeLossRecPrev",e);
		}
	}
	
	if($("rdoByPeril").checked){
		initializeLossRecPrevPrl();	
	}else if($("rdoByIntm").checked){
		initializeLossRecPrevIntm();
	}else{
		initializeLossRecPrev();
	}
	
}catch(e){
	showErrorMessage("lossRecPrev page", e);
}
</script>