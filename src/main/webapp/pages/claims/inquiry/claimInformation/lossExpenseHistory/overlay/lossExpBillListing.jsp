<div id="lossExpBillMainDiv" name="lossExpBillMainDiv">
	<div id="lossExpBillTableGridDiv" style="margin: 10px 13px">
		<div id="lossExpBillGridDiv" style="height: 225px; margin-top: 5px;">
			<div id="lossExpBillTableGrid" style="height: 225px; width: 800px;"></div>
		</div>
		<div style="margin: 10px 0px; margin-bottom: 10px; float: left; width: 650px;">
			<table align="center" border="0">
				<tr>
					<td style="text-align: right;">Remarks</td>
					<td class="leftAligned" colspan="3"  width="700px" style="padding-left: 5px;">
						<div style="border: 1px solid gray; height: 20px; width: 100%">
							<textarea onKeyDown="limitText(this,4000);" onKeyUp="limitText(this,4000);" id="txtLEBillRemarks" name="txtLEBillRemarks" style="width: 94%; border: none; height: 13px; resize:none;" readonly="readonly"></textarea>
							<img class="hover" src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editLEBillRemarks" />
						</div>
					</td>
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
		var objLossExpBill = JSON.parse('${jsonLossExpBill}');
		objLossExpBill.lossExpBillList = objLossExpBill.rows || []; 
		
		var lossExpBillTableModel = {
			url : contextPath + "/GICLLossExpBillController?action=showGICLS260LossExpBill"+
				  "&claimId="+ nvl(objCLMGlobal.claimId, 0)+"&clmLossId="+$("hidClmLossId").value,
			options:{
				title: '',
				width: '800px',
				hideColumnChildTitle: true,
				pager: { },
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onRefresh: function(){
						$("txtLEBillRemarks").value = "";
						lossExpBillTableGrid.keys.removeFocus(lossExpBillTableGrid.keys._nCurrentFocus, true);
						lossExpBillTableGrid.keys.releaseKeys();
					}
				},
				onCellFocus: function(element, value, x, y, id){
					var lossExpBill = lossExpBillTableGrid.geniisysRows[y];
					$("txtLEBillRemarks").value = unescapeHTML2(lossExpBill.remarks);
					lossExpBillTableGrid.keys.removeFocus(lossExpBillTableGrid.keys._nCurrentFocus, true);
					lossExpBillTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus: function() {
					$("txtLEBillRemarks").value = "";
					lossExpBillTableGrid.keys.removeFocus(lossExpBillTableGrid.keys._nCurrentFocus, true);
					lossExpBillTableGrid.keys.releaseKeys();
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
				{	id: 'docTypeDesc',
					align: 'left',
				  	title: 'Type',
				  	titleAlign: 'center',
				  	width: '70px',
				  	editable: false,
				  	sortable: false,
				  	filterOption: true
				},
				{
					id : 'dspPayeeClass dspPayee',
					title : 'Company',
					width : '350px',
					sortable : false,					
					children : [
						{
							id : 'dspPayeeClass',							
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
							id : 'dspPayee',							
							width : 250,
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
					id: 'billDate',
					title: 'Bill Date',
					width: '100px',
					filterOption: true,
					filterOptionType: 'formattedDate',
					sortable: false,
					align: 'center',
					type: 'date',
					titleAlign: 'center'
				},
				{	id: 'docNumber',
					align: 'left',
				  	title: 'Number',
				  	titleAlign: 'center',
				  	width: '135px',
				  	editable: false,
				  	sortable: false,
				  	filterOption: true
				},
				{
				   	id: 'amount',
				   	title: 'Amount',
				   	titleAlign: 'center',
				   	type : 'number',
				  	width: '125px',
				  	geniisysClass : 'money',
				  	editable: false,
				  	sortable: false,
				  	filterOption: true,
					filterOptionType: 'number'
				}
			],
			rows : objLossExpBill.lossExpBillList,
			requiredColumns: ''
		};
		
		lossExpBillTableGrid = new MyTableGrid(lossExpBillTableModel);
		lossExpBillTableGrid.pager = objLossExpBill;
		lossExpBillTableGrid.render('lossExpBillTableGrid');
		lossExpBillTableGrid.afterRender = function(){
			$("txtLEBillRemarks").value = "";
			lossExpBillTableGrid.keys.removeFocus(lossExpBillTableGrid.keys._nCurrentFocus, true);
			lossExpBillTableGrid.keys.releaseKeys();
		};
		
		$("editLEBillRemarks").observe("click", function(){showEditor("txtLEBillRemarks", 4000, 'true');});
		
		$("btnOk").observe("click", function(){
			Windows.close("modal_dialog_lov");
		});
		
	}catch(e){
		showErrorMessage("Claim Information - Loss Exp Hist - Bill Information", e);
	}

</script>