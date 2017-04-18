<div id="availmentsListTableGrid" style="height: 150px;">tablegrid</div>

<script type="text/javascript">
try{
	var objAvailments = JSON.parse('${jsonAvailmentsTableGridList}');
	var availmentsTableModel = {
			url : contextPath
					+ "/GICLClaimReserveController?action=getAvailmentsTableGrid&refresh=1"
					+ "&claimId="+objCLMGlobal.claimId
					+ "&lineCd="+objCLMGlobal.lineCd
					+ "&sublineCd="+objCLMGlobal.sublineCd
					+ "&polIssCd="+objCLMGlobal.polIssCd
					+ "&issueYy="+objCLMGlobal.issueYy
					+ "&polSeqNo="+objCLMGlobal.polSeqNo
					+ "&renewNo="+objCLMGlobal.renewNo
					+ "&perilCd="+objCurrGICLItemPeril.perilCd
					+ "&noOfDays="+objCurrGICLItemPeril.noOfDays,
			options : {
				title : '',
				width : '645px',
				onCellFocus : function(element, value, x, y, id) {
					availmentsTableGrid.keys.removeFocus(availmentsTableGrid.keys._nCurrentFocus, true); // andrew - 12.12.2012
					availmentsTableGrid.keys.releaseKeys();	
				},
				onRemoveRowFocus : function() {
					availmentsTableGrid.keys.removeFocus(availmentsTableGrid.keys._nCurrentFocus, true); // andrew - 12.12.2012
					availmentsTableGrid.keys.releaseKeys();	
				},
				toolbar : {
					elements : [MyTableGrid.REFRESH_BTN]
				}
			},
			columnModel : [
			    {
					id : 'recordStatus',
					title : '',
					width : '0',
					visible : false
				},
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},
				{
					id : 'claimNo',
					title : 'Claim No.',
					width : '150px',
					titleAlign : 'center'
				},
				{
					id : 'lossDate',
					title : 'Loss Date',
					width : '75px',
					titleAlign: 'center'
				},
				{
					id : 'clmStatDesc',
					title : 'Status',
					titleAlign: 'center'
				},
				{
					id : 'lossReserve',
					title : 'Reserve Amount',
					align : 'right',
					renderer: function(value){
						return formatCurrency(value);
					},
					titleAlign: 'center'
				},
				{
					id : 'paidAmt',
					title : 'Paid Amount',
					align : 'right',
					renderer: function(value){
						return formatCurrency(value);
					},
					titleAlign: 'center'
				},
				{
					id : 'noOfUnits',
					title : 'Days Used',
					align : 'right',
					titleAlign: 'center'
				}
			],
			rows : objAvailments.rows
	};
	availmentsTableGrid = new MyTableGrid(availmentsTableModel);
	availmentsTableGrid.pager = objAvailments;
	availmentsTableGrid.render('availmentsListTableGrid');
	
	$("txtTotalReserveAmount").value = formatCurrency('${sumLossReserve}');
	$("txtTotalPaidAmount").value = formatCurrency('${sumPaidAmt}');
	$("txtTotalNoOfUnits").value = '${sumNoOfUnits}';
	
} catch (e){
	showErrorMessage("availmentsListTableGrid", e);
}
</script>