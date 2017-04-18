<div id="premWrittenCurrMainDiv" class="sectionDiv" style="border: none; margin-bottom: 40px;">
	<div id="premWrittenCurrTGDiv" class="sectionDiv" style="height: 313px; margin-left: 10px; margin-top: 10px; border: none;">
	
	</div>
</div>
<script type="text/javascript">
try{
	var objPWCurr = new Object();

	function initializePremiumsWrittenCurrPrl(){
		try{
			objPWCurr.objPremiumsWrittenCurrPrlTableGrid = JSON.parse('${jsonPremiumsWrittenCurr}');
			objPWCurr.objPremiumsWrittenCurrPrl = objPWCurr.objPremiumsWrittenCurrPrlTableGrid.rows || [];
			
			var premiumsWrittenCurrPrlModel = {
				url:contextPath+"/GICLLossRatioController?action=showPremiumsWrittenCurr&refresh=1&queryAction=getPremiumsWrittenCurrPrl&sessionId="+$F("hidSessionId")+"&prntDate="+$F("hidPrntDate"),
				options:{
					id: 'PWCP',
					width: '900px',
					height: '298px',
					onCellFocus: function(element, value, x, y, id){
						premiumsWrittenCurrPrlTableGrid.keys.removeFocus(premiumsWrittenCurrPrlTableGrid.keys._nCurrentFocus, true);
						premiumsWrittenCurrPrlTableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus:function(element, value, x, y, id){
						premiumsWrittenCurrPrlTableGrid.keys.removeFocus(premiumsWrittenCurrPrlTableGrid.keys._nCurrentFocus, true);
						premiumsWrittenCurrPrlTableGrid.keys.releaseKeys();
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
				rows: objPWCurr.objPremiumsWrittenCurrPrl
			};
			premiumsWrittenCurrPrlTableGrid = new MyTableGrid(premiumsWrittenCurrPrlModel);
			premiumsWrittenCurrPrlTableGrid.pager = objPWCurr.objPremiumsWrittenCurrPrlTableGrid;
			premiumsWrittenCurrPrlTableGrid.render('premWrittenCurrTGDiv');
		}catch(e){
			showErrorMessage("initializePremiumsWrittenCurrPrl",e);
		}
	}
	
	function initializePremiumsWrittenCurrIntm(){
		try{
			objPWCurr.objPremiumsWrittenCurrIntmTableGrid = JSON.parse('${jsonPremiumsWrittenCurr}');
			objPWCurr.objPremiumsWrittenCurrIntm = objPWCurr.objPremiumsWrittenCurrIntmTableGrid.rows || [];
			
			var premiumsWrittenCurrIntmModel = {
				url:contextPath+"/GICLLossRatioController?action=showPremiumsWrittenCurr&refresh=1&queryAction=getPremiumsWrittenCurrIntm&sessionId="+$F("hidSessionId")+"&prntDate="+$F("hidPrntDate"),
				options:{
					id: 'PWCI',
					width: '900px',
					height: '298px',
					onCellFocus: function(element, value, x, y, id){
						premiumsWrittenCurrIntmTableGrid.keys.removeFocus(premiumsWrittenCurrIntmTableGrid.keys._nCurrentFocus, true);
						premiumsWrittenCurrIntmTableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus:function(element, value, x, y, id){
						premiumsWrittenCurrIntmTableGrid.keys.removeFocus(premiumsWrittenCurrIntmTableGrid.keys._nCurrentFocus, true);
						premiumsWrittenCurrIntmTableGrid.keys.releaseKeys();
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
				rows: objPWCurr.objPremiumsWrittenCurrIntm
			};
			premiumsWrittenCurrIntmTableGrid = new MyTableGrid(premiumsWrittenCurrIntmModel);
			premiumsWrittenCurrIntmTableGrid.pager = objPWCurr.objPremiumsWrittenCurrIntmTableGrid;
			premiumsWrittenCurrIntmTableGrid.render('premWrittenCurrTGDiv');
		}catch(e){
			showErrorMessage("initializePremiumsWrittenCurrIntm",e);
		}
	}
	
	function initializePremiumsWrittenCurr(){
		try{
			objPWCurr.objPremiumsWrittenCurrTableGrid = JSON.parse('${jsonPremiumsWrittenCurr}');
			objPWCurr.objPremiumsWrittenCurr = objPWCurr.objPremiumsWrittenCurrTableGrid.rows || [];
			
			var premiumsWrittenCurrModel = {
				url:contextPath+"/GICLLossRatioController?action=showPremiumsWrittenCurr&refresh=1&queryAction=getPremiumsWrittenCurr&sessionId="+$F("hidSessionId")+"&prntDate="+$F("hidPrntDate"),
				options:{
					id: 'PWC',
					width: '900px',
					height: '298px',
					onCellFocus: function(element, value, x, y, id){
						premiumsWrittenCurrTableGrid.keys.removeFocus(premiumsWrittenCurrTableGrid.keys._nCurrentFocus, true);
						premiumsWrittenCurrTableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus:function(element, value, x, y, id){
						premiumsWrittenCurrTableGrid.keys.removeFocus(premiumsWrittenCurrTableGrid.keys._nCurrentFocus, true);
						premiumsWrittenCurrTableGrid.keys.releaseKeys();
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
				rows: objPWCurr.objPremiumsWrittenCurr
			};
			premiumsWrittenCurrTableGrid = new MyTableGrid(premiumsWrittenCurrModel);
			premiumsWrittenCurrTableGrid.pager = objPWCurr.objPremiumsWrittenCurrTableGrid;
			premiumsWrittenCurrTableGrid.render('premWrittenCurrTGDiv');
		}catch(e){
			showErrorMessage("initializePremiumsWrittenCurr",e);
		}
	}
	
	if($("rdoByPeril").checked){
		initializePremiumsWrittenCurrPrl();	
	}else if($("rdoByIntm").checked){
		initializePremiumsWrittenCurrIntm();
	}else{
		initializePremiumsWrittenCurr();
	}
	
}catch(e){
	showErrorMessage("premiumsWrittenCurr page", e);
}
</script>