<div id="loaTableGrid" style="height: 130px; margin:10px; width: 745px;"></div>

<script type="text/javascript">
	try{
		var objLoaTG = JSON.parse('${jsonLoa}');
		var objLoa = objLoaTG.rows || [];
		
		var loaTableModel = {
			id : 12,
			url : contextPath + "/GICLClaimLossExpenseController?action=getLOATableGridList"
					          + "&claimId="+ nvl(objCLMGlobal.claimId, 0),
			options:{
				title: '',
				pager: { },
				width: '745px',
				hideColumnChildTitle: true,
				/* toolbar: {
					elements: [MyTableGrid.REFRESH_BTN], // andrew - 09.18.2012 - comment out
					onRefresh: function(){
						clearLoaRelatedTableGrids();
					}
				}, */
				onCellFocus: function(element, value, x, y, id){
					loaTableGrid.releaseKeys();
					var mtgId = loaTableGrid._mtgId; 
					var loa = loaTableGrid.geniisysRows[y];
					var clmLossId = loa.clmLossId;
					objCurrLoa = loa;
					currLoaClmLossId = clmLossId;
					retrieveDtlLOA(clmLossId);
					$("txtLoaRemarks").value = unescapeHTML2(loa.remarks);
					
					if(x == loaTableGrid.getColumnIndex("generateTag")){
						var checkboxId = 'mtgInput'+mtgId+'_'+x+','+y; 
						if($(checkboxId).checked && nvl(loa.loaNo, "") != ""){
							$(checkboxId).checked = false;
							enableDisableGenerateLoaBtn();
							showMessageBox("LOA No. has already been generated for this record.", "I");
							return false;
						}else if($(checkboxId).checked && !checkLossExpTaxExists(loa)){ //benjo 03.08.2017 SR-5945
							$(checkboxId).checked = false;
							enableDisableGenerateLoaBtn();
							showMessageBox("Cannot Generate LOA for this record. Please check loss/expense history [Loss Tax].", "I");
							return false;
						}else if(nvl($("hidOverrideLoa").value, "N") == "Y"){
							if($(checkboxId).checked){
								checkUnpaidPremiums(loa, "LOA", checkboxId);
							}else{ //added by kenneth 12022014
								enableDisableGenerateLoaBtn();
							}
						}else{
							enableDisableGenerateLoaBtn();
						}
					}else if(x == loaTableGrid.getColumnIndex("printTag")){
						var checkboxId = 'mtgInput'+mtgId+'_'+x+','+y;
						if($(checkboxId).checked && nvl(loa.loaNo, "") == ""){
							$(checkboxId).checked = false;
							enableDisablePrintLoaBtn();
							showMessageBox("No LOA No. has been generated for this record.", "I");
						}else{
							enableDisablePrintLoaBtn();
						}
					}
				},
				onRemoveRowFocus: function() {
					clearLoaRelatedTableGrids();
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
				},{	id: 'tpPayeeClassCd',
					width: '0',
					visible: false
				},
				{	id: 'tpPayeeNo',
					width: '0',
					visible: false
				},
				{ 	id: 'generateTag',
				  	sortable: false,
				  	align: 'center',
				  	altTitle: 'Generate LOA',
				  	title: '&#160;G',
				  	titleAlign: 'center',
				  	width: '23px',
				  	editable: true,
				  	defaultValue: false,
				  	otherValue: false,
				  	hideSelectAllBox: true,
				  	editor: new MyTableGrid.CellCheckbox({ //benjo 03.08.2017 SR-5945
				  		getValueOf: function(value){
		            		if (value){
								return true;
		            		}else{
								return false;	
		            		}	
		            	}
				  	})
				},
				{ 	id: 'printTag',
				  	sortable: false,
				  	align: 'center',
				  	altTitle: 'Print LOA',
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
				{	id: 'loaNo',
					align: 'left',
				  	title: 'LOA No.',
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
			rows : objLoa,
			requiredColumns: ''
		};
		
		loaTableGrid = new MyTableGrid(loaTableModel);
		loaTableGrid.pager = objLoaTG;
		loaTableGrid.render('loaTableGrid');
		loaTableGrid.afterRender = function(){
			currLoaClmLossId = null;
			objCurrLoa = null;
			enableDisableGenerateLoaBtn();
			enableDisablePrintLoaBtn();
		};
		
	}catch(e){
		showErrorMessage("Loss Expense Hist - LOA", e);
	}
		
</script>