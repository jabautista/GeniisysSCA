<div id="policyRIPlacementMainDiv">
	<div id="riPlacementTGDiv" name="riPlacementTGDiv" class="sectionDiv" style="height: 200px; width: 99%; padding-top: 10px;"> <!-- padding-top: 10px; Added by Jerome Bautista 07.24.2015 SR 19737 -->
		<div id="divRIPlacementTG">
			Table Grid1
		</div>
	</div>
	<div id="grandTotalsDiv" name="totalsDiv" class="sectionDiv" style="height: 25px; width: 99%; padding-bottom: 15px;">
		<div id="totalsDiv">
			<table align="right" border="0">
				<tbody>
					<td class="rightAligned" style="width: 10%;">Total : </td>
					<td class="rightAligned">
						<input id="txtSumRISpct" type="text" class="rightAligned" name="txtSumRISpct" style="width: 120px;" readonly="readonly"/>
						<input id="txtSumRITsi" type="text" class="rightAligned" name="txtSumRITsi" style="width: 120px;" readonly="readonly"/>
						<input id="txtSumRIPrem" type="text" class="rightAligned" name="txtSumRIPrem" style="width: 120px;" readonly="readonly"/>
					</td>
				</tbody>
			</table>
		</div>
	</div>
	<div id="buttonsMainDiv" name="buttonsMainDiv" class="sectionDiv" style="height: 25px; width: 99%; padding-bottom: 15px;">
		<div class="buttonsDiv" style="margin-bottom: 10px; margin-top: 5px;">
			<input type="button" class="button" id="btnOk" value="Ok" style="width: 140px;">
			<input type="hidden" id="hidDistNo" name="hidDistNo" value="${distNo}"/>
			<input type="hidden" id="hidDistSeqNo" name="hidDistSeqNo" value="${distSeqNo}"/>
			<input type="hidden" id="hidPlacementSource" name="hidPlacementSource" value="${placementSource}"/>
			<input type="hidden" id="hidPostFlag" name="hidPostFlag" value="${postFlag}"/>
		</div>
	</div>
</div>

<script type="text/javascript">
try{
	
	var jsonViewRIPlacement = JSON.parse('${viewRIPlacement}');
	
	viewRIPlacementTableModel = {
			url : contextPath + "/GIPIPolbasicController?action=viewRIPlacement&distNo=" + $F("hidDistNo") + "&distSeqNo=" + $F("hidDistSeqNo") + "&placementSource=" + $F("hidPlacementSource")+ "&refresh=1", //refresh=1 Added by Jerome Bautista 07.24.2015 SR 19737
			options : {
				hideColumnChildTitle: true,
				width : '710px',
				height : '200px',
				pager : {},
				onCellFocus : function(element, value, x, y, id) {
					tbgViewRIPlacement.keys.removeFocus(tbgViewRIPlacement.keys._nCurrentFocus, true);
					tbgViewRIPlacement.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					tbgViewRIPlacement.keys.removeFocus(tbgViewPolicyDistribution.keys._nCurrentFocus, true);
					tbgViewRIPlacement.keys.releaseKeys();
				},
				afterRender : function(element, value, x, y, id) {;
					tbgViewRIPlacement.keys.removeFocus(tbgViewPolicyDistribution.keys._nCurrentFocus, true);
					tbgViewRIPlacement.keys.releaseKeys();
				}, //Added by Jerome Bautista 07.24.2015 SR 19737
				onRefresh : function() { 
					tbgViewRIPlacement.keys.removeFocus(tbgViewPolicyDistribution.keys._nCurrentFocus, true);
					tbgViewRIPlacement.keys.releaseKeys();
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
				id : "binderNo",
				title : "Binder No",
				width : '145px',
				titleAlign : 'leftAligned',
				align : 'left'
			}, {
				id : "riSname",
				title : "Reinsurer",
				width : '145px',
				titleAlign : 'leftAligned',
				align : 'left'
			}, {
				id : "riShrPct",
				title : "Share Percent",
				width : '140px',
				titleAlign : 'leftAligned',
				align : 'right',
				geniisysClass : 'rate', //'money', changed by robert SR 4887 09.18.15
	            geniisysMinValue: '0.00', //'-999999999999.99', changed by robert SR 4887 09.18.15
	            geniisysMaxValue: '100.00', //'999,999,999,999.99', changed by robert SR 4887 09.18.15
	            renderer: function(value){
					return formatToNineDecimal(value);
				}
			}, {
				id : "riTsiAmt",
				title : "TSI Amount",
				width : '135px',
				titleAlign : 'leftAligned',
				geniisysClass: 'money',
				align : 'right'
			}, {
				id : "riPremAmt",
				title : "Premium Amount",
				width : '128px',
				titleAlign : 'leftAligned',
				geniisysClass: 'money',
				align : 'right'
			}],
			rows : jsonViewRIPlacement.rows
	};
	
	tbgViewRIPlacement = new MyTableGrid(viewRIPlacementTableModel);
	tbgViewRIPlacement.pager = jsonViewRIPlacement;
	tbgViewRIPlacement.render('divRIPlacementTG');
	tbgViewRIPlacement.afterRender = function() {
		tbgViewRIPlacement.keys.removeFocus(tbgViewRIPlacement.keys._nCurrentFocus, true);
		tbgViewRIPlacement.keys.releaseKeys();
		
		if(tbgViewRIPlacement.geniisysRows.length > 0){
			var rec = tbgViewRIPlacement.geniisysRows[0];
			tbgViewRIPlacement.selectRow('0');
			$("txtSumRISpct").value = formatToNineDecimal(rec.SumRIShrPct);
			$("txtSumRITsi").value = formatCurrency(rec.SumRITsiAmt);
			$("txtSumRIPrem").value = formatCurrency(rec.SumRIPremAmt);
		}
	};
	
	$("btnOk").observe("click", function() {
		viewRIPlacementOverlay.close();
		delete viewRIPlacementOverlay;
	});
} catch(e) {
	showErrorMessage("Policy RI Placement Overlay.", e);
}
</script>