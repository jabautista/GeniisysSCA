<div id="suCommissionDetailsTableGridSectionDiv"
	style="margin: 0px auto 0px auto;">
	<div id="suCommissionDetailsOuterDiv" class="sectionDiv"
		style="border: none;">
		<div id="suCommissionDetailsInnerDiv" style="border: none;"
			class="sectionDiv">
			<div id="suCommissionDetailsTableGridDiv" class="sectionDiv"
				style="border: none; width: 650px; margin-top: 10px; margin-bottom: 10px; padding: 10px;">
				<div id="suCommissionDetailsListing" class="sectionDiv"
					style="border: none; height: 170px; width: 700px; margin: 0px auto 0px auto; overflow: hidden;">
				</div>
			</div>
		</div>
	</div>
	<div class="sectionDiv"
		style="margin: 10px; width: 680px; padding: 10px;">
		<input type="hidden" id="policyId" name="policyId" /> <input
			type="hidden" id="premSeqNo" name="premSeqNo" /> <input type="hidden"
			id="lineCd" name="lineCd" />
		<table style="width: 100%;">
			<tr>
				<td class="rightAligned" style="width: 120px; padding-right: 5px;">Rate
					:</td>
				<td class="leftAligned"><input type="text" id="txtRate"
					name="txtRate" style="width: 148px; text-align: right;"
					readonly="readonly" /></td>
				<td class="rightAligned" style="width: 120px; padding-right: 5px;">Withholding
					Tax :</td>
				<td class="leftAligned"><input type="text"
					id="txtWithholdingTax" name="txtWithholdingTax"
					style="width: 148px; text-align: right;" readonly="readonly" /></td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 120px; padding-right: 5px;">Total
					Commission :</td>
				<td class="leftAligned"><input type="text" id="txtTotalComm"
					name="txtTotalComm" style="width: 148px; text-align: right;"
					readonly="readonly" /></td>
				<td class="rightAligned" style="width: 120px; padding-right: 5px;">Net
					Commission :</td>
				<td class="leftAligned"><input type="text" id="txtNetComm"
					name="txtNetComm" style="width: 148px; text-align: right;"
					readonly="readonly" /></td>
			</tr>
		</table>
	</div>
	<div style="text-align: center;">

		<input type="button" class="button" id="btnReturn" value="Close"
			style="width: 100px;" />
	</div>
</div>
<script>
	try {

		var objCommDtls = new Object();
		objCommDtls.objCommDtlsTableGrid = JSON.parse('${commissionDtls}'
				.replace(/\\/g, '\\\\'));
		objCommDtls.objCommDtlsList = objCommDtls.objCommDtlsListTableGrid
				|| [];

		var commissionTableModel = {
			url : contextPath
					+ "/GIPIPolbasicController?action=getCommissionDetailsSu"
					+ "&policyId=" + '${policyId}' + "&premSeqNo="
					+ '${premSeqNo}' + "&lineCd=" + '${lineCd}' + "&refresh=1",
			options : {
				hideColumnChildTitle : true,
				title : '',
				width : 700,
				toolbar : {
					elements : [ MyTableGrid.REFRESH_BTN ]
				},
				pager: {
				},
				onCellFocus : function(element, value, x, y, id) {
					rowIndex = y;
					objCurrTGColumn = commissionTableGrid.geniisysRows[y];
					$("txtNetComm").value = formatToNthDecimal(nvl(
							objCurrTGColumn.netComAmt, 0), 2);
					$("txtRate").value = formatToNthDecimal(nvl(
							objCurrTGColumn.commissionRt, 0), 9);
					$("txtWithholdingTax").value = formatToNthDecimal(nvl(
							objCurrTGColumn.wholdingTax, 0), 2);
					$("txtTotalComm").value = formatToNthDecimal(nvl(unescapeHTML2(objCurrTGColumn.totalCommission),0), 2);
					commissionTableGrid.keys.removeFocus(
							commissionTableGrid.keys._nCurrentFocus, true);
					commissionTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus : function() {
					$("txtNetComm").value = '';
					$("txtRate").value = '';
					$("txtWithholdingTax").value = '';
					$("txtTotalComm").value = '';
					commissionTableGrid.keys.removeFocus(
							commissionTableGrid.keys._nCurrentFocus, true);
					commissionTableGrid.keys.releaseKeys();
				},
			},
			columnModel : [
					{
						id : 'recordStatus',
						width : '0px',
						visible : false,
						editor : 'checkbox'
					},
					{
						id : 'divCtrId',
						width : '0px',
						visible : false
					},
					{
						id : 'commissionRt',
						width : '0px',
						visible : false
					},
					{
						id : 'totalCommission',
						width : '0px',
						visible : false
					},
					{
						id : 'netComAmt',
						width : '0px',
						visible : false
					},
					{
						id : 'wholdingTax',
						width : '0px',
						visible : false,
						renderer : function(value) {
							return nvl(value, '') == '' ? ''
									: formatToNthDecimal(nvl(value, 0), 2);
						}
					},
					{
						id : 'intmNo intmName',
						title : 'Intermediary No./Name',
						width : 210,
						sortable : false,
						visible : true,
						children : [ {
							id : 'intmNo',
							width : 60,
							sortable : false
						},

						{
							id : 'intmName',
							width : 150,
							sortable : false
						} ]
					},
					{
						id : 'parentIntmNo parentIntmName',
						title : 'Parent Intm No./Name',
						width : 210,
						sortable : false,
						visible : true,
						children : [ {
							id : 'parentIntmNo',
							width : 60,
							sortable : false,
							visible : true
						},

						{
							id : 'parentIntmName',
							width : 150,
							sortable : false,
							visible : true
						} ]
					},
					{
						id : 'sharePercentage',
						title : 'Share Percentage',
						width : 115,
						align : 'right',
						sortable : false,
						visible : true,
						renderer : function(value) {
							return nvl(value, '') == '' ? ''
									: formatToNthDecimal(nvl(value, 0), 7);
						}
					},
					{
						id : 'sharePrem',
						title : 'Share of Premium',
						width : 120,
						align : 'right',
						sortable : false,
						visible : true,
						renderer : function(value) {
							return nvl(value, '') == '' ? ''
									: formatToNthDecimal(nvl(value, 0), 2);
						}
					} ],
			rows : objCommDtls.objCommDtlsTableGrid.rows
		};

		commissionTableGrid = new MyTableGrid(commissionTableModel);
		commissionTableGrid.pager = objCommDtls.objCommDtlsTableGrid;
		commissionTableGrid.render('suCommissionDetailsListing');

		
	} catch (e) {
		showErrorMessage("suCommissionDetails.jsp", e);
	}

	$("btnReturn").observe("click", function() {
			console.log('test');
			overlayCommissionDetailsSu.close();
	});
</script>