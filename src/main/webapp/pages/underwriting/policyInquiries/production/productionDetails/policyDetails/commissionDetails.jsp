<div id="commissionDetailsMainDiv" name="commissionDetailsMainDiv">
	<div class="sectionDiv" style="width:99.5%;margin: 10px 0px 0 0px">
		<div style="margin: 10px 0 0 10px">
			<div id="commissionDetailsTableGrid" style="height: 250px;width:702px;"></div>
		</div>		
		<div style="margin:5px 0 5px 146px">
			<table>
				<tr>
					<td>Totals</td>
					<td><input id="txtParentCommRtTotal" class="rightAligned" type="text" style="width:118px"/></td>
					<td><input id="txtParentCommAmtTotal" class="rightAligned" type="text" style="width:118px"/></td>
					<td><input id="txtChildCommRtTotal" class="rightAligned" type="text" style="width:118px"/></td>
					<td><input id="txtChildCommAmtTotal" class="rightAligned" type="text" style="width:118px"/></td>
				</tr>
			</table>
		</div>
	</div>
	<center>	
		<input type="button" class="button" value="Return" id="btnReturn" style="width: 100px; margin-top: 20px" /> 
	</center>
</div>
<script>
try {
	var jsonCommDetails = JSON.parse('${jsonCommDetails}');
	commissionDetailsTableModel = {
		url : contextPath
				+ "/GIPIPolbasicController?action=getGIPIS201CommDtls&refresh=1&lineCd=${lineCd}&issCd=${issCd}&policyId=${policyId}&intmNo=${intmNo}",
		options : {
			hideColumnChildTitle: true,
			width : '702px',
			pager : {},
			toolbar : {
				elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
				onFilter : function() {
					tbgCommissionDetails.keys.removeFocus(tbgCommissionDetails.keys._nCurrentFocus, true);
					tbgCommissionDetails.keys.releaseKeys();					
				}
			},			
			onCellFocus : function(element, value, x, y, id) {						
				tbgCommissionDetails.keys.removeFocus(
						tbgCommissionDetails.keys._nCurrentFocus, true);
				tbgCommissionDetails.keys.releaseKeys();				
			},
			prePager : function() {
				tbgCommissionDetails.keys.removeFocus(tbgCommissionDetails.keys._nCurrentFocus, true);
				tbgCommissionDetails.keys.releaseKeys();				
			},
			onRemoveRowFocus : function(element, value, x, y, id) {				
				tbgCommissionDetails.keys.removeFocus(
						tbgCommissionDetails.keys._nCurrentFocus, true);
				tbgCommissionDetails.keys.releaseKeys();				
			},
			onSort : function() {
				tbgCommissionDetails.keys.removeFocus(tbgCommissionDetails.keys._nCurrentFocus, true);
				tbgCommissionDetails.keys.releaseKeys();				
			},onRefresh : function() {				
				tbgCommissionDetails.keys.removeFocus(tbgCommissionDetails.keys._nCurrentFocus, true);
				tbgCommissionDetails.keys.releaseKeys();				
			}
		},
		columnModel : [ {
			id : 'recordStatus',
			title : '',
			width : '0',
			visible : false
		}, {
			id : 'divCtrId',
			width : '0',
			visible : false
		}, {
			id : "perilName",
			title : "Peril",
			width : '170px',
			titleAlign : 'left',
			align : 'left',
			filterOption : true,
		}, {
			id : "parentCommRt",
			title : 'Parent Comm %',
			width : '125px',
			titleAlign : 'right',
			align : 'right',
			filterOption : true,
			filterOptionType : 'number',
			renderer : function(value){
				return formatToNthDecimal(value,2);
			}			
		
		}, {
			id : "parentCommAmt",
			title: "Parent Comm Amt",
			width : '125px',
			titleAlign : 'right',
			align : 'right',
			filterOption : true,
			filterOptionType : 'number',
			renderer : function(value){
				return formatCurrency(value);
			}
		}, {
			id : "childCommRt",
			title : 'Agent Comm %',
			width : '125px',
			titleAlign : 'right',
			align : 'right',
			filterOption : true,
			filterOptionType : 'number',
			renderer : function(value){
				return formatToNthDecimal(value,2);
			}	
		}, {
			id : "childCommAmt",
			title: "Agent Comm Amt",
			width : '125px',
			titleAlign : 'right',
			align : 'right',
			filterOption : true,
			filterOptionType : 'number',
			renderer : function(value){
				return formatCurrency(value);
			}
		}],
		rows : jsonCommDetails.rows
	};
	
	tbgCommissionDetails = new MyTableGrid(commissionDetailsTableModel);
	tbgCommissionDetails.pager = jsonCommDetails;
	tbgCommissionDetails.render('commissionDetailsTableGrid');	
	tbgCommissionDetails.afterRender = function(){
		$("txtParentCommRtTotal").value = formatToNthDecimal(tbgCommissionDetails.geniisysRows[0].parentCommRtTotal,2);
		$("txtParentCommAmtTotal").value = formatCurrency(tbgCommissionDetails.geniisysRows[0].parentCommAmtTotal);
		$("txtChildCommRtTotal").value = formatToNthDecimal(tbgCommissionDetails.geniisysRows[0].childCommRtTotal,2);
		$("txtChildCommAmtTotal").value = formatCurrency(tbgCommissionDetails.geniisysRows[0].childCommAmtTotal);
	};

	$("btnReturn").observe("click", function(){
		overlayCommissionDetails.close();
		delete overlayCommissionDetails;
	});	
} catch (e) {
	showErrorMessage("Error : ", e.message);
}
</script>