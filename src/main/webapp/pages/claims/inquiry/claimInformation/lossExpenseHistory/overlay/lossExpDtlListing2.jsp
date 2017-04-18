<div id="lossExpDtlMainDiv" name="lossExpDtlMainDiv">
	<div id="lossExpDtlTableGridDiv" style="margin: 10px 12px">
		<div id="lossExpDtlGridDiv" style="height: 250px; margin-top: 5px;">
			<div id="lossExpDtlTableGrid" style="height: 250px; width: 490px;"></div>
		</div>
		<div style="float: right; margin-top: 5px;">
			<table>
				<tr>
					<td class="leftAligned" style="width: 115px;"><b>Total Loss Amount</b></td>
					<td><input type="text" id="totalLossAmt" name="totalLossAmt" class="money" value="0.00" style="width: 155px;" readonly="readonly"/></td>
				</tr>
			</table>
		</div>
		<div class="buttonsDiv" align="center" style="margin-bottom: 5px;">
			<input type="hidden" id="hidClmLossId"  name="hidClmLossId"  value="${clmLossId}">
			<input type="hidden" id="hidPayeeType"  name="hidPayeeType" value="${payeeType}">
			<input type="button" id="btnOk" name="btnOk" style="width: 120px;" class="button hover"  value="Return" />
		</div>
	</div>
</div>

<script type="text/javascript">
	try{
		var objLossExpDtl2 = JSON.parse('${jsonGiclLossExpDtl}');
		objLossExpDtl2.lossExpDtlListing = objLossExpDtl2.rows || []; 
		
		var lossExpDtlTableModel2 = {
			url : contextPath + "/GICLLossExpDtlController?action=showGICLS260LossExpDtls&action1=getAllGiclLossExpDtlList"+
				  "&claimId="+ nvl(objCLMGlobal.claimId, 0)+"&clmLossId="+$("hidClmLossId").value+"&payeeType="+$("hidPayeeType").value+"&lineCd="+objCLMGlobal.lineCode,
			options:{
				title: '',
				pager: { },
				width: '490px',
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN],
					onRefresh: function(){
						lossExpDtlTableGrid2.keys.removeFocus(lossExpDtlTableGrid2.keys._nCurrentFocus, true);
						lossExpDtlTableGrid2.keys.releaseKeys();
					}
				},
				onCellFocus: function(element, value, x, y, id){
					lossExpDtlTableGrid2.keys.removeFocus(lossExpDtlTableGrid2.keys._nCurrentFocus, true);
					lossExpDtlTableGrid2.keys.releaseKeys();
				},
				onRemoveRowFocus: function() {
					lossExpDtlTableGrid2.keys.removeFocus(lossExpDtlTableGrid2.keys._nCurrentFocus, true);
					lossExpDtlTableGrid2.keys.releaseKeys();
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
				{	id: 'lossExpCd',
					width: '50px',
					title: 'Exp Cd',
				  	titleAlign: 'center',
				  	width: '80px'
				},
				{	id: 'dspExpDesc',
					align: 'left',
				  	title: 'Description',
				  	titleAlign: 'center',
				  	width: '237px',
				  	editable: false
				},
				{
				   	id: 'dtlAmt',
				   	title: 'Loss Amount',
				   	titleAlign: 'center',
				   	type : 'number',
				  	width: '160px',
				  	geniisysClass : 'money'
				}
				
			],
			rows : objLossExpDtl2.lossExpDtlListing,
			requiredColumns: ''
		};
		
		lossExpDtlTableGrid2 = new MyTableGrid(lossExpDtlTableModel2);
		lossExpDtlTableGrid2.pager = objLossExpDtl2;
		lossExpDtlTableGrid2.render('lossExpDtlTableGrid');
		lossExpDtlTableGrid2.afterRender = function(){
			lossExpDtlTableGrid2.keys.removeFocus(lossExpDtlTableGrid2.keys._nCurrentFocus, true);
			lossExpDtlTableGrid2.keys.releaseKeys();
			
			var totalLossAmt = 0;
			var list = objLossExpDtl2.lossExpDtlListing;
			for(var i=0; i<list.length; i++){
				if(list[i].recordStatus != -1){
					totalLossAmt = parseFloat(nvl(totalLossAmt,0)) + parseFloat(nvl(list[i].dtlAmt, 0));
				}
			}
			
			$("totalLossAmt").value    = formatCurrency(totalLossAmt);
		};
		
		$("btnOk").observe("click", function(){
			Windows.close("modal_dialog_lov");
		});
		
	}catch(e){
		showErrorMessage("Claim Information - Loss Expense Hist - giclLossExpDtl 2", e);
	}
</script>