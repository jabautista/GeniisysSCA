<div id="claimDetailsMainDiv" name="claimDetailsMainDiv">
	<div id="outerDiv" name="outerDiv" style="width: 99%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Claims</label>
			<span class="refreshers" style="margin-top: 0;">
				<label name="gro" style="margin-left: 5px;">Hide</label>
			</span>
		</div>
	</div>
	<div id="claimsTGDiv" name="claimsTGDiv" class="sectionDiv" style="height: 160px; padding: 10px 0 0 10px; width: 97%;">
		
	</div>
</div>

<script type="text/javascript">
	objSMSRenewal.claimDtlsTableGrid = JSON.parse('${claimDtlsTableGrid}');
	objSMSRenewal.claimDtlsRows = objSMSRenewal.claimDtlsTableGrid.rows || [];
	
	try {
		var claimDtlsTableGridModel = {
			url: contextPath+"/GIEXSmsDtlController?action=showClaimDtls&refresh=1"+
					"&lineCd="+objSMSRenewal.selectedRow.lineCd+"&sublineCd="+objSMSRenewal.selectedRow.sublineCd+
					"&issCd="+objSMSRenewal.selectedRow.issCd+"&issueYy="+objSMSRenewal.selectedRow.issueYy+
					"&polSeqNo="+objSMSRenewal.selectedRow.polSeqNo+"&renewNo="+objSMSRenewal.selectedRow.renewNo,
			options: {
				width: '570px',
				height: '125px',
				hideColumnChildTitle: true,
				onCellFocus: function(element, value, x, y, id) {
					claimDtlsTableGrid.keys.removeFocus(claimDtlsTableGrid.keys._nCurrentFocus, true);
					claimDtlsTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus : function(){
					claimDtlsTableGrid.keys.removeFocus(claimDtlsTableGrid.keys._nCurrentFocus, true);
					claimDtlsTableGrid.keys.releaseKeys();
			  	},
			},
			columnModel: [
				{
					id: 'recordStatus',
				    width: '0',
				    visible: false,
				    editor: 'checkbox' 	
				},
				{	
					id: 'divCtrId',
					width: '0',
					visible: false
				},
				{
					id: 'issCd claimYy claimSeqNo',
					title: 'Claim No.',
					children:
					[
						{
							id: 'issCd',
							width: 40
						} ,
						{
							id: 'claimYy',
							width: 35
						},
						{
							id: 'claimSeqNo',
							width: 70
						}
					]
				},
				{
					id: 'lossResAmt',
					title: 'Claim Amount',
					width: '100px',
					align: 'right',
					geniisysClass: 'money'
				},
				{
					id: 'lossPdAmt',
					title: 'Paid Amount',
					width: '100px',
					align: 'right',
					geniisysClass: 'money'
				},
				{
					id: 'clmFileDate',
					title: 'Filed Date',
					width: '90px',
					align: 'center'
				},
				{
					id: 'clmStatDesc',
					title: 'Status',
					width: '95px'
				}
			],
			rows: objSMSRenewal.claimDtlsRows
		};
		claimDtlsTableGrid = new MyTableGrid(claimDtlsTableGridModel);
		claimDtlsTableGrid.pager = objSMSRenewal.claimDtlsTableGrid;
		claimDtlsTableGrid.render('claimsTGDiv');
	}catch(e) {
		showErrorMessage("claimDtlsTableGrid", e);
	}
</script>