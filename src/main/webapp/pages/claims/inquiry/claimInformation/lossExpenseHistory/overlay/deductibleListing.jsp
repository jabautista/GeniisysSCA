<div id="lossExpDedMainDiv" name="lossExpDtlMainDiv">
	<div id="lossExpDedTableGridDiv" style="margin: 10px 12px">
		<div id="lossExpDedGridDiv" style="height: 225px; margin-top: 5px;">
			<div id="lossExpDedTableGrid" style="height: 225px; width: 770px;"></div>
		</div>
		<div style="float: right; margin-top: 5px;">
			<table>
				<tr>
					<td class="leftAligned" style="width: 40px;"><b>Total</b></td>
					<td><input type="text" id="totalDedAmt" name="totalDedAmt" class="money" value="0.00" style="width: 130px;" readonly="readonly"/></td>
				</tr>
			</table>
		</div>
		<div class="buttonsDiv" align="center" style="margin-bottom: 5px;">
			<input type="hidden" id="hidDedClmLossId"  name="hidDedClmLossId"  value="${clmLossId}">
			<input type="hidden" id="hidDedPayeeType"  name="hidDedPayeeType" value="${payeeType}">
			<input type="button" id="btnLEDedDtls" 	   name="btnLEDedDtls" style="width: 130px;" class="disabledButton hover"  value="Deductible Details" />
			<input type="button" id="btnLEDedReturn"   name="btnLEDedReturn" style="width: 120px;" class="button hover"  value="Return" />
		</div>
	</div>
</div>

<script type="text/javascript">
	try{
		var objLossExpDed = JSON.parse('${jsonLossExpDeductible}');
		objLossExpDed.deductibleListing = objLossExpDed.rows || [];
		var selectedDeductible = null;
		
		var deductibleTableModel = {
			url : contextPath + "/GICLLossExpDtlController?action=showGICLS260LossExpDeductibles"+
				  "&claimId="+ nvl(objCLMGlobal.claimId, 0)+"&clmLossId="+$("hidDedClmLossId").value+"&payeeType="+$("hidDedPayeeType").value+"&lineCd="+objCLMGlobal.lineCode,
			options:{
				title: '',
				pager: { },
				width: '770px',
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN],
					onRefresh: function(){
						selectedDeductible = null;
						disableButton("btnLEDedDtls");
						deductibleTableGrid.keys.removeFocus(deductibleTableGrid.keys._nCurrentFocus, true);
						deductibleTableGrid.keys.releaseKeys();
					}
				},
				onCellFocus: function(element, value, x, y, id){
					selectedDeductible = deductibleTableGrid.geniisysRows[y];
					enableButton("btnLEDedDtls");
					deductibleTableGrid.keys.removeFocus(deductibleTableGrid.keys._nCurrentFocus, true);
					deductibleTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus: function() {
					selectedDeductible = null;
					disableButton("btnLEDedDtls");
					deductibleTableGrid.keys.removeFocus(deductibleTableGrid.keys._nCurrentFocus, true);
					deductibleTableGrid.keys.releaseKeys();
				},
				onSort: function() {
					selectedDeductible = null;
					disableButton("btnLEDedDtls");
					deductibleTableGrid.keys.removeFocus(deductibleTableGrid.keys._nCurrentFocus, true);
					deductibleTableGrid.keys.releaseKeys();
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
				{	id: 'dspExpDesc',
					align: 'left',
				  	title: 'Loss Expense',
				  	titleAlign: 'center',
				  	width: '200px',
				  	editable: false,
				  	sortable: true
				},
				{	id: 'dspDedLeDesc',
					align: 'left',
				  	title: 'For Loss Expense',
				  	titleAlign: 'center',
				  	width: '120px',
				  	editable: false,
				  	sortable: true
				},
				{	id: 'nbtNoOfUnits',
					align: 'right',
				  	title: 'Unit(s)',
				  	titleAlign: 'center',
				  	width: '70px',
				  	editable: false,
				  	sortable: true
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
				   	id: 'dedBaseAmt',
				   	title: 'Base Amount',
				   	titleAlign: 'center',
				   	type : 'number',
				  	width: '130px',
				  	geniisysClass : 'money'
				},
				{
				   	id: 'dtlAmt',
				   	title: 'Deductible Amount',
				   	titleAlign: 'center',
				   	type : 'number',
				  	width: '130px',
				  	geniisysClass : 'money'
				}
				
			],
			rows : objLossExpDed.deductibleListing,
			requiredColumns: ''
		};
		
		deductibleTableGrid = new MyTableGrid(deductibleTableModel);
		deductibleTableGrid.pager = objLossExpDed;
		deductibleTableGrid.render('lossExpDedTableGrid');
		deductibleTableGrid.afterRender = function(){
			selectedDeductible = null;
			disableButton("btnLEDedDtls");
			deductibleTableGrid.keys.removeFocus(deductibleTableGrid.keys._nCurrentFocus, true);
			deductibleTableGrid.keys.releaseKeys();
			
			var totalDedAmt = 0;
			var list = objLossExpDed.deductibleListing;
			for(var i=0; i<list.length; i++){
				if(list[i].recordStatus != -1){
					totalDedAmt = parseFloat(nvl(totalDedAmt,0)) + parseFloat(nvl(list[i].dtlAmt,0));
				}
			}
			
			$("totalDedAmt").value    = formatCurrency(totalDedAmt);
		};
		
		
		$("btnLEDedReturn").observe("click", function(){
			Windows.close("deductible_canvas");
		});
		
		$("btnLEDedDtls").observe("click", function(){
			if(selectedDeductible == null){
				showMessageBox("Please select deductible record first.", "I");
				return false;
			}
			
			overlayDedDtls = Overlay.show(contextPath + "/GICLLossExpDedDtlController", {
				urlContent: true,
				urlParameters: {action : "showGICLS260LossExpDedDtl",
								claimId : objCLMGlobal.claimId,
								lineCd: objCLMGlobal.lineCode,
								payeeType: $("hidDedPayeeType").value,
								clmLossId: $("hidDedClmLossId").value,
								sublineCd: selectedDeductible.sublineCd,
								lossExpCd: selectedDeductible.lossExpCd,
								dspExpDesc: selectedDeductible.dspExpDesc,
								ajax: 1
				},
				title: "Deductible Details",	
				id: "ded_dtls_canvas",
				width: 530, 
				height: 325,
			    draggable: false,
			    closable: true
			});
		});
		
	}catch(e){
		showErrorMessage("Claim Information - Loss Expense Hist - Deductible", e);
	}
</script>