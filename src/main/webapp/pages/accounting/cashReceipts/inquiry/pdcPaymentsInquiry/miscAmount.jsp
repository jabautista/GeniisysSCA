<div id="miscAmountDiv" style="width: 472px; margin: 0 auto;">
	<div class="sectionDiv" style="margin: 7px auto 0; padding: 5px 0;">
		<div style="padding-top: 5px; padding-left: 5px;">
			<div id="miscAmountTable" style="height:53px;"></div>
		</div>
		<center><input type="button" class="button" id="btnReturn" value="Return" style="margin-top: 10px; width: 100px; clear: both;" tabindex="1001"/></center>
	</div>
</div>
<script type="text/javascript">
	try {
		$("btnReturn").focus();
		
		miscAmountTableModel = {
				url: contextPath+"/GIPIPolbasicController?action=showMiscAmount&refresh=1",	
				options: {
					width: '462px',
					height: '56px',
					onCellFocus : function(element, value, x, y, id) {
						tbgMiscAmount.keys.removeFocus(tbgMiscAmount.keys._nCurrentFocus, true);
						tbgMiscAmount.keys.releaseKeys();
					},
					onRemoveRowFocus : function(element, value, x, y, id){
						tbgMiscAmount.keys.removeFocus(tbgMiscAmount.keys._nCurrentFocus, true);
						tbgMiscAmount.keys.releaseKeys();
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
					{
						id: 'grossAmt',
						title : 'Gross Amount',
						width: "150",
						align: 'right',
						titleAlign: 'right',
						renderer : function(value) {
					    	return formatCurrency(value);
					    }
					},
					{
						id: 'commissionAmt',
						title : 'Commission Amount',
						width: "150px",
						align: 'right',
						titleAlign: 'right',
						renderer : function(value) {
					    	return formatCurrency(value);
					    }
					},
					{
						id: 'vatAmt',
						title : 'VAT Amount',
						width: "150px",
						align: 'right',
						titleAlign: 'right',
						renderer : function(value) {
					    	return formatCurrency(value);
					    }
					}
				],
				rows : objGIACS092.jsonViewPDCPayments
			};
		
		tbgMiscAmount = new MyTableGrid(miscAmountTableModel);
		tbgMiscAmount.pager = [];
		tbgMiscAmount.render('miscAmountTable');
		tbgMiscAmount.afterRender = function (){
			tbgMiscAmount.keys.removeFocus(tbgMiscAmount.keys._nCurrentFocus, true);
			tbgMiscAmount.keys.releaseKeys();
			$("pagerDiv2").hide();
		};
		
		$("btnReturn").observe("click", function(){
			overlayMiscAmount.close();
			delete overlayMiscAmount;
		});
		
	} catch (e) {
		showErrorMessage("Error : " , e);
	}
</script>