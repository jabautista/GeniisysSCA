<div id="cslTableGrid" style="height: 156px; margin:10px; width: 745px;"></div>

<script type="text/javascript">
	try{
		var objCslTG = JSON.parse('${jsonCsl}');
		var objCsl = objCslTG.rows || [];
		
		var cslTableModel = {
			id : 15,
			url : contextPath + "/GICLClaimLossExpenseController?action=getCSLTableGridList"
					          + "&claimId="+ nvl(objCLMGlobal.claimId, 0),
			options:{
				title: '',
				pager: { },
				width: '745px',
				hideColumnChildTitle: true,
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN],
					onRefresh: function(){
						clearCslRelatedTableGrids();
					}
				},
				onCellFocus: function(element, value, x, y, id){
					cslTableGrid.releaseKeys();
					var mtgId = cslTableGrid._mtgId;
					var csl = cslTableGrid.geniisysRows[y];
					var clmLossId = csl.clmLossId;
					objCurrCsl = csl;
					currCslClmLossId = clmLossId; 
					retrieveDtlCSL(clmLossId);
					$("txtCslRemarks").value = unescapeHTML2(csl.remarks);
					
					if(x == cslTableGrid.getColumnIndex("generateTag")){
						var checkboxId = 'mtgInput'+mtgId+'_'+x+','+y; 
						if($(checkboxId).checked && nvl(csl.cslNo, "") != ""){
							$(checkboxId).checked = false;
							enableDisableGenerateCslBtn();
							showMessageBox("CSL No. has already been generated for this record.", "I");
							return false;
						}else if(nvl($("hidOverrideCsl").value, "N") == "Y"){
							if($(checkboxId).checked){
								checkUnpaidPremiums(csl, "CSL", checkboxId);
							}
						}else{
							enableDisableGenerateCslBtn();
						}
					}else if(x == cslTableGrid.getColumnIndex("printTag")){
						var checkboxId = 'mtgInput'+mtgId+'_'+x+','+y;
						if($(checkboxId).checked && nvl(csl.cslNo, "") == ""){
							$(checkboxId).checked = false;
							enableDisablePrintCslBtn();
							showMessageBox("No CSL No. has been generated for this record.", "I");
						}else{
							enableDisablePrintCslBtn();
						}
					}
				},
				onRemoveRowFocus: function() {
					clearCslRelatedTableGrids();
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
				{	id: 'payeeClassCd',
					width: '0',
					visible: false
				},
				{	id: 'payeeCd',
					width: '0',
					visible: false
				},
				{	id: 'clmLossId',
					width: '0',
					visible: false
				},
				{	id: 'remarks',
					width: '0',
					visible: false
				},
				{	id: 'evalId',
					width: '0',
					visible: false
				},
				{ 	id: 'generateTag',
				  	sortable: false,
				  	align: 'center',
				  	altTitle: 'Generate CSL',
				  	title: '&#160;G',
				  	titleAlign: 'center',
				  	width: '23px',
				  	editable: true,
				  	defaultValue: false,
				  	otherValue: false,
				  	hideSelectAllBox: true,
				  	editor: 'checkbox'	
				},
				{ 	id: 'printTag',
				  	sortable: false,
				  	align: 'center',
				  	altTitle: 'Print CSL',
				  	title: '&#160;P',
				  	titleAlign: 'center',
				  	width: '23px',
				  	editable: true,
				  	defaultValue: false,
				  	otherValue: false,
				  	hideSelectAllBox: true,
				  	editor: 'checkbox'	
				},
				{	id: 'histSeqNo',
					align: 'right',
				  	title: '&#160;&#160;H',
				  	titleAlign: 'center',
				  	altTitle: 'History Sequence Number',
				  	width: '28px',
				  	editable: false,
				  	sortable: true,
				  	filterOption: true,
				  	filterOptionType: 'integerNoNegative'
				},
				{
					id : 'classDesc payeeName',
					title : 'Company',
					width : '380px',
					sortable : false,					
					children : [
						{
							id : 'classDesc',							
							width : 100,
							title : 'Payee Class',
							filterOption: true,
							sortable : false,
							editable : false,
							renderer : function(value){
								return unescapeHTML2(value);
							}
						},
						{
							id : 'payeeName',							
							width : 280,
							title : 'Payee',
							filterOption: true,
							sortable : false,
							editable : false,							
							renderer : function(value){
								return unescapeHTML2(value);
							}
						}
					]					
				},
				{
				   	id: 'paidAmt',
				   	title: 'Amount',
				   	titleAlign: 'center',
				   	type : 'number',
				  	width: '125px',
				  	geniisysClass : 'money',
				  	filterOption: true,
					filterOptionType: 'number'
				},
				{	id: 'cslNo',
					align: 'left',
				  	title: 'CSL No.',
				  	titleAlign: 'center',
				  	width: '100px',
				  	editable: false,
				  	sortable: true,
				  	filterOption: true
				},
				{ 	id: 'thirdPartyTag',
				  	sortable: false,
				  	align: 'center',
				  	altTitle: 'Third Party Tag',
				  	title: '&#160;T',
				  	titleAlign: 'center',
				  	width: '23px',
				  	editable: true,
				  	defaultValue: false,
				  	otherValue: false,
				  	hideSelectAllBox: true,
				  	editor: 'checkbox'	
				},
			],
			rows : objCsl,
			requiredColumns: ''
		};
		
		cslTableGrid = new MyTableGrid(cslTableModel);
		cslTableGrid.pager = objCslTG;
		cslTableGrid.render('cslTableGrid');
		cslTableGrid.afterRender = function(){
			currCslClmLossId = null;
			objCurrCsl = null;
			enableDisableGenerateCslBtn();
			enableDisablePrintCslBtn();
		};
		
	}catch(e){
		showErrorMessage("Loss Expense Hist - CSL", e);
	}
		
</script>