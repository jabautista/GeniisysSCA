<div id="lossExpDedDtlDiv" name="lossExpDedDtlDiv">
	<div style="margin: 10px;">
		<table>
			<tr>
				<td align="left" style="width: 70px;">Deductible  :</td>
				<td>
					<input type="text" style="float: left;width: 400px;" name="txtDedDtlLossExp" id="txtDedDtlLossExp" value="" readonly="readonly"/>
				</td>
			</tr>
		</table>
	</div>
	<div id="lossExpDedDtlTableGridDiv" name="lossExpDedDtlTableGridDiv" style="margin:10px;">
		<div id="deductiblesDetailsTableGrid" style="height: 181px; width:610px;"></div>
	</div>
	<div>
		<input type="button" id="btnDedDtlReturn" name="btnDedDtlReturn" class="button"	value="Return" 	style="width: 90px;"/>
	</div>
</div>

<script type="text/javascript">
	$("btnDedDtlReturn").observe("click", function(){
		lossExpHistWin2.close();
	});
	
	$("txtDedDtlLossExp").value = unescapeHTML2(objCurrLossExpDeductibles.lossExpCd) + " - " + unescapeHTML2(objCurrLossExpDeductibles.dspExpDesc);

	try{
		var objLossExpDedDetailsTG = JSON.parse('${jsonGiclLossExpDedDtl}');
		var objLossExpDedDetails   = objLossExpDedDetailsTG.rows || []; 
		
		var url = objCurrLossExpDeductibles == null ? "" : contextPath + "/GICLLossExpDedDtlController?action=getGiclLossExpDedDtlList&claimId="+ nvl(objCurrLossExpDeductibles.claimId, 0)+"&clmLossId="+objCurrLossExpDeductibles.clmLossId
		          +"&lossExpCd="+objCurrLossExpDeductibles.lossExpCd+"&payeeType="+objCurrLossExpDeductibles.payeeType+"&lineCd="+objCLMGlobal.lineCd+"&sublineCd="+objCurrLossExpDeductibles.sublineCd;
		
		var lossExpDedDetailsTableModel = {
			id : 9,
			url : url,
			options:{
				title: '',
				pager: { },
				width: '605px',
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN/*, MyTableGrid.FILTER_BTN*/]
				},
				onCellFocus: function(element, value, x, y, id){
					lossExpDedDetailsTableGrid.releaseKeys();
				},
				onRemoveRowFocus: function() {
					lossExpDedDetailsTableGrid.releaseKeys();
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
				{	id: 'dspDedDesc',
					align: 'left',
				  	title: 'Loss Expense',
				  	titleAlign: 'center',
				  	width: '220px',
				  	editable: false,
				  	sortable: true,
				  	filterOption: true
				},
				{
				   	id: 'dedRate',
				   	title: 'Ded. Rate',
				   	titleAlign: 'center',
				   	type : 'number',
				  	width: '100px',
				  	geniisysClass : 'rate'
				},
				{
				   	id: 'lossAmt',
				   	title: 'Loss Amount',
				   	titleAlign: 'center',
				   	type : 'number',
				  	width: '135px',
				  	geniisysClass : 'money',
				  	filterOption: true,
					filterOptionType: 'number'
				},
				{
				   	id: 'dedAmt',
				   	title: 'Deductible Amount',
				   	titleAlign: 'center',
				   	type : 'number',
				  	width: '135px',
				  	geniisysClass : 'money',
				  	filterOption: true,
					filterOptionType: 'number'
				}
				
			],
			rows : objLossExpDedDetails,
			requiredColumns: ''
		};
		
		lossExpDedDetailsTableGrid = new MyTableGrid(lossExpDedDetailsTableModel);
		lossExpDedDetailsTableGrid.pager = objLossExpDedDetailsTG;
		lossExpDedDetailsTableGrid.render('deductiblesDetailsTableGrid');
		
	}catch(e){
		showErrorMessage("Loss Expense Hist - Deductible Details", e);
	}
</script>