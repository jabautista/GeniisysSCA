<div id="lossExpTaxMainDiv" name="lossExpTaxMainDiv">
	<div id="lossExpTaxTableGridDiv" style="margin: 10px 13px">
		<div id="lossExpTaxGridDiv" style="height: 225px; margin-top: 5px;">
			<div id="lossExpTaxTableGrid" style="height: 225px; width: 950px;"></div>
		</div>
		<div style="float: right;">
			<table>
				<tr>
					<td align="left" style="width: 100px;"><b>Total Tax Amount</b></td>
					<td><input type="text" id="totalTaxAmt" name="totalTaxAmt" class="money" value="0.00" style="width: 120px; margin-right: 60px;" readonly="readonly"/></td>
				</tr>
			</table>
		</div>
		<div class="buttonsDiv" align="center" style="margin-bottom: 5px;">
			<input type="hidden" id="hidClmLossId"  name="hidClmLossId"  value="${clmLossId}">
			<input type="button" id="btnOk" name="btnOk" style="width: 120px;" class="button hover"  value="Return" />
		</div>
	</div>
</div>

<script type="text/javascript">
	try{
		var objLossExpTax = JSON.parse('${jsonGiclLossExpTax}');
		objLossExpTax.lossExpTaxList = objLossExpTax.rows || [];
		
		var lossExpTaxTableModel = {
			url : contextPath + "/GICLLossExpTaxController?action=showGICLS260LossExpTax"
					          + "&claimId="+ nvl(objCLMGlobal.claimId, 0)
					          + "&clmLossId="+$("hidClmLossId").value
					          + "&issCd="+objCLMGlobal.issueCode,
			options:{
				title: '',
				pager: { },
				width: '950px',
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onRefresh: function(){
						lossExpTaxTableGrid.keys.removeFocus(lossExpTaxTableGrid.keys._nCurrentFocus, true);
						lossExpTaxTableGrid.keys.releaseKeys();
					}
				},
				onCellFocus: function(element, value, x, y, id){
					lossExpTaxTableGrid.keys.removeFocus(lossExpTaxTableGrid.keys._nCurrentFocus, true);
					lossExpTaxTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus: function() {
					lossExpTaxTableGrid.keys.removeFocus(lossExpTaxTableGrid.keys._nCurrentFocus, true);
					lossExpTaxTableGrid.keys.releaseKeys();
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
				{
					id: 'withTax',
					title: 'WT',
					altTitle: 'With Tax',
					width: '27px',
					align: 'center',
					titleAlign: 'center',
					editable: false,
					sortable: false,
					defaultValue: false,
					otherValue: false,
					editor: new MyTableGrid.CellCheckbox({
				        getValueOf: function(value){
			            	if (value){
								return "Y";
			            	}else{
								return "N";	
			            	}
		            	}
		            })
				},
				{	id: 'taxType',
					align: 'left',
				  	title: 'Type',
				  	titleAlign: 'center',
				  	width: '50px',
				  	editable: false,
				  	sortable: true,
				  	filterOption: true
				},
				{ 	id: 'taxCd',
				  	align: 'right',
				  	title: 'Code',
				  	titleAlign: 'center',
				  	width: '50px',
				  	editable: false,
				  	sortable: true,
				  	renderer: function(value){
						return lpad(value.toString(), 5, "0");					
					},
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{	id: 'taxName',
					align: 'left',
				  	title: 'Tax Name',
				  	titleAlign: 'center',
				  	width: '265px',
				  	editable: false,
				  	sortable: true,
				  	filterOption: true,
				},
				{ 	id: 'slCd',
				  	align: 'right',
				  	title: 'SL Code',
				  	titleAlign: 'center',
				  	width: '85px',
				  	editable: false,
				  	sortable: true,
				  	renderer : function(value){
						return lpad(value.toString(), 12, "0");					
					},
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{ 	id: 'lossExpCd',
				  	title: 'LE',
				  	titleAlign: 'center',
				  	width: '50px',
				  	editable: false,
				  	sortable: true,
				  	filterOption: true
				},
				{
				   	id: 'baseAmt',
				   	title: 'Base Amount',
				   	titleAlign: 'center',
				   	type : 'number',
				  	width: '120px',
				  	geniisysClass : 'money',
				  	filterOption: true,
				  	filterOptionType: 'number'
				},
				{
				   	id: 'taxPct',
				   	title: 'Tax Pct.',
				   	titleAlign: 'center',
				   	type : 'number',
				  	width: '100px',
				  	geniisysClass : 'rate',
				  	filterOption: true,
				  	filterOptionType: 'number'
				},
				{
				   	id: 'taxAmt',
				   	title: 'Tax Amount',
				   	titleAlign: 'center',
				   	type : 'number',
				  	width: '120px',
				  	geniisysClass : 'money',
				  	filterOption: true,
				  	filterOptionType: 'number'
				},
				{
					id: 'netTag',
					title: 'DV',
					altTitle: 'Net Tag',
					width: '27px',
					align: 'center',
					titleAlign: 'center',
					editable: false,
					sortable: false,
					defaultValue: false,
					otherValue: false,
					editor: new MyTableGrid.CellCheckbox({
				        getValueOf: function(value){
			            	if (value){
								return "Y";
			            	}else{
								return "N";	
			            	}
		            	}
		            })
				},
				{
					id: 'advTag',
					title: 'Adv',
					altTitle: 'Adv. Tag',
					width: '27px',
					align: 'center',
					titleAlign: 'center',
					editable: false,
					sortable: false,
					defaultValue: false,
					otherValue: false,
					editor: new MyTableGrid.CellCheckbox({
				        getValueOf: function(value){
			            	if (value){
								return "Y";
			            	}else{
								return "N";	
			            	}
		            	}
		            })
				},
			],
			rows : objLossExpTax.lossExpTaxList,
			requiredColumns: ''
		};
		
		lossExpTaxTableGrid = new MyTableGrid(lossExpTaxTableModel);
		lossExpTaxTableGrid.pager = objLossExpTax;
		lossExpTaxTableGrid.render('lossExpTaxTableGrid');
		lossExpTaxTableGrid.afterRender = function(){
			lossExpTaxTableGrid.keys.removeFocus(lossExpTaxTableGrid.keys._nCurrentFocus, true);
			lossExpTaxTableGrid.keys.releaseKeys();
			
			var totalTaxAmt = 0;
			var rows = objLossExpTax.lossExpTaxList;
			
			for(var i=0; i<rows.length; i++){
				if(rows[i].recordStatus != -1){
					totalTaxAmt = parseFloat(nvl(totalTaxAmt,0)) + parseFloat(nvl(rows[i].taxAmt, 0));
				}
			}
			$("totalTaxAmt").value = formatCurrency(totalTaxAmt);
		};
		
		$("btnOk").observe("click", function(){
			Windows.close("modal_dialog_lov");
		});
		
	}catch(e){
		showErrorMessage("Claim Information - Loss Expense Hist - Loss Tax", e);
	}

</script>