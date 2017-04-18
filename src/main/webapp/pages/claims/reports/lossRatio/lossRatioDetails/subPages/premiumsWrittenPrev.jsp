<div id="premWrittenPrevMainDiv" class="sectionDiv" style="border: none; margin-bottom: 40px;">
	<div id="premWrittenPrevTGDiv" class="sectionDiv" style="height: 313px; margin-left: 10px; margin-top: 10px; border: none;">
	
	</div>
</div>
<script type="text/javascript">
try{
	var objPWPrev = new Object();
	
	function initializePremiumsWrittenPrevPrl(){
		try{
			objPWPrev.objPremiumsWrittenPrevPrlTableGrid = JSON.parse('${jsonPremiumsWrittenPrev}');
			objPWPrev.objPremiumsWrittenPrevPrl = objPWPrev.objPremiumsWrittenPrevPrlTableGrid.rows || [];

			var premiumsWrittenPrevPrlModel = {
				url:contextPath+"/GICLLossRatioController?action=showPremiumsWrittenPrev&refresh=1&queryAction=getPremiumsWrittenPrevPrl&sessionId="+$F("hidSessionId")+"&prntDate="+$F("hidPrntDate"),
				options:{
					id: 'PWPP',
					width: '900px',
					height: '298px',
					onCellFocus: function(element, value, x, y, id){
						premiumsWrittenPrevPrlTableGrid.keys.removeFocus(premiumsWrittenPrevPrlTableGrid.keys._nPreventFocus, true);
						premiumsWrittenPrevPrlTableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus:function(element, value, x, y, id){
						premiumsWrittenPrevPrlTableGrid.keys.removeFocus(premiumsWrittenPrevPrlTableGrid.keys._nPreventFocus, true);
						premiumsWrittenPrevPrlTableGrid.keys.releaseKeys();
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
						id: 'policyNo',
						title: 'Policy',
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
						id: 'inceptDate',
						title: 'Incept Date',
						width: '90px',
						align: 'center',
						titleAlign: 'center',
						visible: true
					},
					{
						id: 'expiryDate',
						title: 'Expiry Date',
						width: '90px',
						align: 'center',
						titleAlign: 'center',
						visible: true
					},
					{
						id: 'nbtDate',
						title: getDateLabelGicls205(),
						width: '90px',
						align: 'center',
						titleAlign: 'center',
						visible: !$("rdoEffDate").checked
					},
					{
						id: 'tsiAmt',
						title: 'TSI Amount',
						width: '155px',
						align: 'right',
						titleAlign: 'right',
						geniisysClass: 'money',
						visible: true
					},
					{
						id: 'premAmt',
						title: 'Premium Amt',
						width: '155px',
						align: 'right',
						titleAlign: 'right',
						geniisysClass: 'money',
						visible: true
					},
				],
				rows: objPWPrev.objPremiumsWrittenPrevPrl
			};
			premiumsWrittenPrevPrlTableGrid = new MyTableGrid(premiumsWrittenPrevPrlModel);
			premiumsWrittenPrevPrlTableGrid.pager = objPWPrev.objPremiumsWrittenPrevPrlTableGrid;
			premiumsWrittenPrevPrlTableGrid.render('premWrittenPrevTGDiv');
		}catch(e){
			showErrorMessage("initializePremiumsWrittenPrevPrl",e);
		}
	}
	
	function initializePremiumsWrittenPrevIntm(){
		try{
			objPWPrev.objPremiumsWrittenPrevIntmTableGrid = JSON.parse('${jsonPremiumsWrittenPrev}');
			objPWPrev.objPremiumsWrittenPrevIntm = objPWPrev.objPremiumsWrittenPrevIntmTableGrid.rows || [];
			
			var premiumsWrittenPrevIntmModel = {
				url:contextPath+"/GICLLossRatioController?action=showPremiumsWrittenPrev&refresh=1&queryAction=getPremiumsWrittenPrevIntm&sessionId="+$F("hidSessionId")+"&prntDate="+$F("hidPrntDate"),
				options:{
					id: 'PWPI',
					width: '900px',
					height: '298px',
					onCellFocus: function(element, value, x, y, id){
						premiumsWrittenPrevIntmTableGrid.keys.removeFocus(premiumsWrittenPrevIntmTableGrid.keys._nPreventFocus, true);
						premiumsWrittenPrevIntmTableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus:function(element, value, x, y, id){
						premiumsWrittenPrevIntmTableGrid.keys.removeFocus(premiumsWrittenPrevIntmTableGrid.keys._nPreventFocus, true);
						premiumsWrittenPrevIntmTableGrid.keys.releaseKeys();
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
						id: 'policyNo',
						title: 'Policy',
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
						id: 'inceptDate',
						title: 'Incept Date',
						width: '90px',
						align: 'center',
						titleAlign: 'center',
						visible: true
					},
					{
						id: 'expiryDate',
						title: 'Expiry Date',
						width: '90px',
						align: 'center',
						titleAlign: 'center',
						visible: true
					},
					{
						id: 'nbtDate',
						title: getDateLabelGicls205(),
						width: '90px',
						align: 'center',
						titleAlign: 'center',
						visible: !$("rdoEffDate").checked
					},
					{
						id: 'tsiAmt',
						title: 'TSI Amount',
						width: '155px',
						align: 'right',
						titleAlign: 'right',
						geniisysClass: 'money',
						visible: true
					},
					{
						id: 'premAmt',
						title: 'Premium Amt',
						width: '155px',
						align: 'right',
						titleAlign: 'right',
						geniisysClass: 'money',
						visible: true
					},
				],
				rows: objPWPrev.objPremiumsWrittenPrevIntm
			};
			premiumsWrittenPrevIntmTableGrid = new MyTableGrid(premiumsWrittenPrevIntmModel);
			premiumsWrittenPrevIntmTableGrid.pager = objPWPrev.objPremiumsWrittenPrevIntmTableGrid;
			premiumsWrittenPrevIntmTableGrid.render('premWrittenPrevTGDiv');
		}catch(e){
			showErrorMessage("initializePremiumsWrittenPrevIntm",e);
		}
	}
	
	function initializePremiumsWrittenPrev(){
		try{
			objPWPrev.objPremiumsWrittenPrevTableGrid = JSON.parse('${jsonPremiumsWrittenPrev}');
			objPWPrev.objPremiumsWrittenPrev = objPWPrev.objPremiumsWrittenPrevTableGrid.rows || [];
			
			var premiumsWrittenPrevModel = {
				url:contextPath+"/GICLLossRatioController?action=showPremiumsWrittenPrev&refresh=1&queryAction=getPremiumsWrittenPrev&sessionId="+$F("hidSessionId")+"&prntDate="+$F("hidPrntDate"),
				options:{
					id: 'PWP',
					width: '900px',
					height: '298px',
					onCellFocus: function(element, value, x, y, id){
						premiumsWrittenPrevTableGrid.keys.removeFocus(premiumsWrittenPrevTableGrid.keys._nPreventFocus, true);
						premiumsWrittenPrevTableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus:function(element, value, x, y, id){
						premiumsWrittenPrevTableGrid.keys.removeFocus(premiumsWrittenPrevTableGrid.keys._nPreventFocus, true);
						premiumsWrittenPrevTableGrid.keys.releaseKeys();
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
						id: 'policyNo',
						title: 'Policy',
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
						id: 'nbtInceptDate',
						title: 'Incept Date',
						width: '90px',
						align: 'center',
						titleAlign: 'center',
						visible: true
					},
					{
						id: 'nbtExpiryDate',
						title: 'Expiry Date',
						width: '90px',
						align: 'center',
						titleAlign: 'center',
						visible: true
					},
					{
						id: 'nbtDate',
						title: getDateLabelGicls205(),
						width: '90px',
						align: 'center',
						titleAlign: 'center',
						visible: !$("rdoEffDate").checked
					},
					{
						id: 'nbtTsiAmt',
						title: 'TSI Amount',
						width: '155px',
						align: 'right',
						titleAlign: 'right',
						geniisysClass: 'money',
						visible: true
					},
					{
						id: 'premAmt',
						title: 'Premium Amt',
						width: '155px',
						align: 'right',
						titleAlign: 'right',
						geniisysClass: 'money',
						visible: true
					},
				],
				rows: objPWPrev.objPremiumsWrittenPrev
			};
			premiumsWrittenPrevTableGrid = new MyTableGrid(premiumsWrittenPrevModel);
			premiumsWrittenPrevTableGrid.pager = objPWPrev.objPremiumsWrittenPrevTableGrid;
			premiumsWrittenPrevTableGrid.render('premWrittenPrevTGDiv');
		}catch(e){
			showErrorMessage("initializePremiumsWrittenPrev",e);
		}
	}
	
	if($("rdoByPeril").checked){
		initializePremiumsWrittenPrevPrl();	
	}else if($("rdoByIntm").checked){
		initializePremiumsWrittenPrevIntm();
	}else{
		initializePremiumsWrittenPrev();
	}
	
}catch(e){
	showErrorMessage("premiumsWrittenPrevPrl page", e);
}
</script>