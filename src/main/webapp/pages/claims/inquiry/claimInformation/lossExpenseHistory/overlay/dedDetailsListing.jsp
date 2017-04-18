<div id="lossExpDedDtlMainDiv" name="lossExpDtlMainDiv">
	<div id="lossExpDedDtlTableGridDiv" style="margin: 10px 12px">
		<div id="lossExpDedDtlGridDiv" style="height: 225px; margin-top: 5px;">
			<table style="margin-bottom: 5px;">
				<tr>
					<td class="leftAligned" style="padding-right: 5px;">Deductible</td>
					<td class="rightAligned">
						<input id="txtDeductibleCd" 		name="txtDeductibleCd" 	   	type="text" style="width: 60px;"  value="${lossExpCd}" readonly="readonly"/>
						<input id="txtDeductibleDesc" 		name="txtDeductibleDesc" 	type="text" style="width: 300px;" value="${dspExpDesc }" readonly="readonly" />
					</td>
				</tr>
			</table>
			<div id="lossExpDedDtlTableGrid" style="height: 225px; width: 505px;"></div>
		</div>
		<div class="buttonsDiv" align="center" style="margin-bottom: 5px; margin-top: 50px;">
			<input type="hidden" id="hidDedDtlClmLossId"  name="hidDedDtlClmLossId"  value="${clmLossId}">
			<input type="hidden" id="hidDedDtlLossExpCd"  name="hidDedDtlLossExpCd"  value="${lossExpCd}">
			<input type="hidden" id="hidDedDtlSublineCd"  name="hidDedDtlSublineCd"  value="${sublineCd}">
			<input type="hidden" id="hidDedDtlPayeeType"  name="hidDedDtlPayeeType" value="${payeeType}">
			<input type="button" id="btnLEDedDtlReturn"   name="btnLEDedDtlReturn" style="width: 120px;" class="button hover"  value="Return" />
		</div>
	</div>
</div>

<script type="text/javascript">
	try{
		var objLossExpDedDtls = JSON.parse('${jsonGiclLossExpDedDtl}');
		objLossExpDedDtls.dedDetailsListing = objLossExpDedDtls.rows || [];
		
		var dedDetailsTableModel = {
			url : contextPath + "/GICLLossExpDedDtlController?action=showGICLS260LossExpDedDtl"+
				  "&claimId="+ nvl(objCLMGlobal.claimId, 0)+"&clmLossId="+$("hidDedDtlClmLossId").value+
				  "&payeeType="+$("hidDedDtlPayeeType").value+"&lineCd="+objCLMGlobal.lineCode+
				  "&lossExpCd="+$("hidDedDtlLossExpCd").value+"&sublineCd="+$("hidDedDtlSublineCd").value,
			options:{
				title: '',
				pager: { },
				width: '505px',
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN],
					onRefresh: function(){
						dedDetailsTableGrid.keys.removeFocus(dedDetailsTableGrid.keys._nCurrentFocus, true);
						dedDetailsTableGrid.keys.releaseKeys();
					}
				},
				onCellFocus: function(element, value, x, y, id){
					dedDetailsTableGrid.keys.removeFocus(dedDetailsTableGrid.keys._nCurrentFocus, true);
					dedDetailsTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus: function() {
					dedDetailsTableGrid.keys.removeFocus(dedDetailsTableGrid.keys._nCurrentFocus, true);
					dedDetailsTableGrid.keys.releaseKeys();
				},
				onSort: function() {
					dedDetailsTableGrid.keys.removeFocus(dedDetailsTableGrid.keys._nCurrentFocus, true);
					dedDetailsTableGrid.keys.releaseKeys();
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
				  	editable: false
				},
				{
				   	id: 'lossAmt',
				   	title: 'Loss Amount',
				   	titleAlign: 'center',
				   	type : 'number',
				  	width: '135px',
				  	geniisysClass : 'money'
				},
				{
				   	id: 'dedAmt',
				   	title: 'Deductible Amount',
				   	titleAlign: 'center',
				   	type : 'number',
				  	width: '135px',
				  	geniisysClass : 'money'
				}
				
			],
			rows : objLossExpDedDtls.dedDetailsListing,
			requiredColumns: ''
		};
		
		dedDetailsTableGrid = new MyTableGrid(dedDetailsTableModel);
		dedDetailsTableGrid.pager = objLossExpDedDtls;
		dedDetailsTableGrid.render('lossExpDedDtlTableGrid');
		
		
		$("btnLEDedDtlReturn").observe("click", function(){
			Windows.close("ded_dtls_canvas");
		});
		
		
	}catch(e){
		showErrorMessage("Claim Information - Loss Expense Hist - Deductible Details", e);
	}
</script>