<div id="paymentHistoryMainDiv" name="paymentHistoryMainDiv">
	<div id="paymentHistoryTableGridDiv" style="margin: 10px 12px">
		<div id="paymentGridDiv" style="height: 180px; margin-top: 5px;">
			<div id="paymentHistoryTableGrid" style="height: 156px; width: 672px;"></div>
		</div>
	</div>
	<div style="margin: 10px; margin-bottom: 10px; float: left; width: 680px;">
		<table align="center" border="0">
			<tr>
				<td style="width: 70px; text-align: right;">Payee Class</td>
				<td class="leftAligned" style="padding-left: 5px;">
					<input id="txtPHPayeeClassCd" 	name="txtPHPayeeClassCd" 	type="text" style="width: 40px;"  value="" readonly="readonly"/>
					<input id="txtPHPayeeClassDesc" name="txtPHPayeeClassDesc" 	type="text" style="width: 200px;" value="" readonly="readonly" />
				</td>
				<td style="width:70px; text-align: right;">Remarks</td>
				<td class="leftAligned" colspan="3"  width="250px" style="padding-left: 5px;">
					<div style="border: 1px solid gray; height: 20px; width: 250px">
						<textarea onKeyDown="limitText(this,4000);" onKeyUp="limitText(this,4000);" id="txtPaytHistRemarks" name="txtPaytHistRemarks" style="width: 200px;; border: none; height: 13px; resize:none;" readonly="readonly"></textarea>
						<img class="hover" src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editPaytHistRemarks" />
					</div>
				</td>
			</tr>
			<tr>
				<td style="width: 70px; text-align: right;">Payee</td>
				<td class="leftAligned" style="padding-left: 5px;">
					<input id="txtPHPayeeCd" 	name="txtPHPayeeCd" 	type="text" style="width: 40px;"  value="" readonly="readonly"/>
					<input id="txtPHPayeeName"  name="txtPHPayeeName" 	type="text" style="width: 200px;" value="" readonly="readonly" />
				</td>
				<td style="width:70px; text-align: right;">User Id</td>
				<td class="leftAligned" style="padding-left: 5px;"><input type="text" style="width: 70px;" id="txtPaytHistUserId" name="txtPaytHistUserId" readonly="readonly" value=""/></td>
				<td style="width:70px; text-align: right;">Last Update</td>
				<td class="leftAligned" width="80px"><input type="text" style="width: 80px;" id="txtPaytHistLastUpdate" name="txtPaytHistLastUpdate" readonly="readonly" value=""/></td>					
			</tr>
		</table>
	</div>
	<div class="buttonsDiv" align="center" style="margin-bottom: 5px;">
		<input type="hidden" id="hidItemNo"  		name="hidItemNo"  value="${itemNo}">
		<input type="hidden" id="hidPerilCd" 		name="hidPerilCd" value="${perilCd}">
		<input type="hidden" id="hidGroupedItemNo" 	name="hidGroupedItemNo" value="${groupedItemNo}">
		<input type="button" id="btnOk" name="btnOk" style="width: 120px;" class="button hover"  value="Return" />
	</div>
</div>

<script type="text/javascript">
	try {
		var objPaymentHist = JSON.parse('${jsonPaymentHistory}'.replace(/\\/g, '\\\\'));
		objPaymentHist.paymentHistList = objPaymentHist.rows || [];
		
		var paymentHistTableModel = {
				url: contextPath
				+ "/GICLClaimReserveController?action=showGICLS260ClaimReserveOverlay&action1=getPaymentHistoryGrid"
				+ "&claimId=" + objCLMGlobal.claimId+"&itemNo="+ $("hidItemNo").value
				+"&perilCd=" + $("hidPerilCd").value+"&groupedItemNo="+$("hidGroupedItemNo").value,
				options:{
					title: '',
					width: '672px',
					hideColumnChildTitle: true,
					onCellFocus: function(element, value, x, y, id){
						var obj = paymentHistListTableGrid.geniisysRows[y];
						setPaymentHistInfo(obj);
						paymentHistListTableGrid.keys.removeFocus(paymentHistListTableGrid.keys._nCurrentFocus, true);
						paymentHistListTableGrid.keys.releaseKeys();	
					},
					onRemoveRowFocus: function ( x, y, element) {
						setPaymentHistInfo(null);
						paymentHistListTableGrid.keys.removeFocus(paymentHistListTableGrid.keys._nCurrentFocus, true);
						paymentHistListTableGrid.keys.releaseKeys();
					}
				},
				columnModel: [
					{
					    id: 'recordStatus',
					    title: '',
					    width: '0',
					    visible: false
					},
					
					{
						id: 'divCtrId',
						width: '0',
						visible: false
					},	
					{	id: 'histSeqNo',
						title: 'Hist No.',
						width: '70px',
						align: 'right',
						titleAlign: 'right',
						filterOption: true,
						type: 'number',
						renderer : function(value){
							return lpad(value.toString(), 3, "0");					
						}
					},
					{
						id : 'lossesPaid',
						title : 'Loss Reserve',
						titleAlign : 'right',
						type : 'number',
						width : '150px',
						geniisysClass : 'money',
						filterOption : true,
						filterOptionType : 'number'
					},
					{
						id : 'expensesPaid',
						title : 'Expense Reserve',
						titleAlign : 'right',
						type : 'number',
						width : '150px',
						geniisysClass : 'money',
						filterOption : true,
						filterOptionType : 'number'
					},
					{	id: 'convertRate',
						title: 'Convert Rate',
						width: '120px',
						geniisysClass: 'rate',
						align: 'right',
						titleAlign: 'right',
						filterOption: true,
						filterOptionType: 'integerNoNegative'
					},
					{
						id: 'datePaid',
						title: 'Date Paid',
						width: '130px',
						sortable: true,
						align: 'center',
						titleAlign: 'center',
						sortable: false
					},
					{	id: 'cancelTag',
						title: '&#160;&#160;C',
						width: '30px',
						altTitle: 'Cancel Tag',
						align: 'center',
						titleAlign: 'center',
						sortable: false,
						renderer : function(value){
							return nvl(value, "N") == "N" ? "N" : "Y";
						}
					}		
				],
				resetChangeTag: true,
				rows: objPaymentHist.paymentHistList
		};
	
		paymentHistListTableGrid = new MyTableGrid(paymentHistTableModel);
		paymentHistListTableGrid.pager = objPaymentHist;
		paymentHistListTableGrid.render('paymentHistoryTableGrid');
			
	} catch(e){
		showErrorMessage("Claim Information - paymentHistory.jsp", e);
	}
	
	function setPaymentHistInfo(obj){
		$("txtPaytHistRemarks").value 	= nvl(obj, null) != null ? unescapeHTML2(obj.remarks): null;
		$("txtPaytHistUserId").value 	= nvl(obj, null) != null ? unescapeHTML2(obj.userId): null;
		$("txtPaytHistLastUpdate").value = nvl(obj, null) != null ? (nvl(obj.lastUpdate, null) != null ? dateFormat(obj.lastUpdate, "dd-mmm-yyyy") : null): null;
		$("txtPHPayeeClassCd").value	= nvl(obj, null) != null ? unescapeHTML2(obj.payeeClassCd): null;
		$("txtPHPayeeClassDesc").value	= nvl(obj, null) != null ? unescapeHTML2(obj.classDesc): null;
		$("txtPHPayeeCd").value			= nvl(obj, null) != null ? unescapeHTML2(obj.payeeCd): null;
		$("txtPHPayeeName").value		= nvl(obj, null) != null ? unescapeHTML2(obj.payee): null;
	}
	
	$("editPaytHistRemarks").observe("click", function(){showEditor("txtPaytHistRemarks", 4000, 'true');});
	
	$("btnOk").observe("click", function(){
		Windows.close("modal_dialog_lov");
	});
		
</script>