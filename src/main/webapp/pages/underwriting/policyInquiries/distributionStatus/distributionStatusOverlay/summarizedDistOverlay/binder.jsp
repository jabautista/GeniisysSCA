<div id="binderMainDiv">
	<div class="sectionDiv" style="margin-top: 8px; width: 546px; height: 265px;">
		<div class="sectionDiv" style="border: none; margin-top: 5px;">
			<label style="margin-top: 6px; margin-left: 5px;">Reinsurer</label>
			<input type="text" id="riName" style="margin-left: 5px; width: 467px;" readonly="readonly"/>
		</div>
		<div id="binderTGDiv" class="sectionDiv" style="height: 160px; width: 534px; margin-top: 5px; margin-left: 5px;">
			
		</div>
		<div id="totalsDiv" class="sectionDiv" style="border: none;">
			<label style="margin-left: 108px; margin-top: 6px;">Total</label>
			<input type="text" id="totShrPct" style="width: 100px; text-align: right; margin-left: 5px;" readonly="readonly"/>
			<input type="text" id="totRiTsi" style="width: 120px; text-align: right;" readonly="readonly"/>
			<input type="text" id="totRiPrem" style="width: 124px; text-align: right;" readonly="readonly"/>
		</div>
		<div class="sectionDiv" id="buttonsDiv" style="border: none; margin-top: 8px; text-align: center;">
			<input id="btnOk" type="button" class="button" value="Ok" style="width: 100px;"/>
		</div>
	</div>
</div>
<script type="text/javascript">
try{
	var jsonBinder = JSON.parse('${binder}');

	binderTableModel = {
		url : contextPath + "/GIPIPolbasicController?action=viewBinder&riCd=" + $F("hidRiCd") + "&lineCd=" + $F("hidLineCd") + "&sublineCd=" + $F("hidSublineCd")
						  + "&issCd=" + $F("hidIssCd") + "&issueYy=" + $F("hidIssueYy") + "&polSeqNo=" + $F("hidPolSeqNo") + "&renewNo=" + $F("hidRenewNo") + "&refresh=1",
		options : {
			toolbar : {
				elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
				onFilter : function() {
					tbgBinder.keys.removeFocus(tbgBinder.keys._nCurrentFocus, true);
					tbgBinder.keys.releaseKeys();
				}
			},
			width : '534px',
			height : '137px',
			onCellFocus : function(element, value, x, y, id) {
				tbgBinder.keys.removeFocus(tbgBinder.keys._nCurrentFocus, true);
				tbgBinder.keys.releaseKeys();
			}, 
			onRemoveRowFocus : function(element, value, x, y, id) {
				tbgBinder.keys.removeFocus(tbgBinder.keys._nCurrentFocus, true);
				tbgBinder.keys.releaseKeys();
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
				id : 'binderNo',
				title : 'Binder',
				titleAlign: 'center',
				sortable : true,
				width : '130px',
				filterOption : true
			},
			{
				id : 'riShrPct',
				title : 'Percent Share',
				titleAlign: 'center',
				align: 'right',
				sortable : true,
				width : '110px',
				geniisysClass : 'money',     
	            geniisysMinValue: '-999999999999.99',     
	            geniisysMaxValue: '999,999,999,999.99',
	            renderer: function(value){
					return formatToNineDecimal(value);
				}
			},
			{
				id : 'riTsiAmt',
				title : 'TSI Amount',
				titleAlign: 'center',
				align: 'right',
				geniisysClass: 'money',
				sortable : true,
				width : '130px'
			},
			{
				id : 'riPremAmt',
				title : 'Premium Amount',
				titleAlign: 'center',
				align: 'right',
				geniisysClass: 'money',
				sortable : true,
				width : '130px'
			}
		],
		rows : jsonBinder.rows
	};
	
	tbgBinder = new MyTableGrid(binderTableModel);
	tbgBinder.pager = jsonBinder;
	tbgBinder.render('binderTGDiv');
	tbgBinder.afterRender = function(){
		$("riName").value = unescapeHTML2(tbgBinder.geniisysRows[0].riName);  //unescapeHTML2 - Halley 11.5.13
		$("totShrPct").value = formatToNineDecimal(tbgBinder.geniisysRows[0].totRiShrPct);
		$("totRiTsi").value = formatCurrency(tbgBinder.geniisysRows[0].totRiTsiAmt);
		$("totRiPrem").value = formatCurrency(tbgBinder.geniisysRows[0].totRiPremAmt);
	};

	$("btnOk").observe("click", function(){
		viewBinderOverlay.close();
	});
	
	} catch (e) {
		showErrorMessage("riPlacement page: ", e);
	}
</script>