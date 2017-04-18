<div id="riPlacementMainDiv">
	<div class="sectionDiv" style="margin-top: 8px; width: 546px; height: 280px;">
		<div id="riPlacementTGDiv" class="sectionDiv" style="height: 200px; width: 534px; margin-top: 5px; margin-left: 5px;">
			
		</div>
		<div id="totalsDiv" class="sectionDiv" style="border: none;">
			<label style="margin-left: 108px; margin-top: 6px;">Total</label>
			<input type="text" id="totShr" style="width: 100px; text-align: right; margin-left: 5px;" readonly="readonly"/>
			<input type="text" id="totRiTsi" style="width: 120px; text-align: right;" readonly="readonly"/>
			<input type="text" id="totRiPrem" style="width: 124px; text-align: right;" readonly="readonly"/>
		</div>
		<div class="sectionDiv" id="buttonsDiv" style="border: none; margin-top: 8px; text-align: center;">
			<input id="btnOk" type="button" class="button" value="Ok" style="width: 100px;" />
			<input id="btnBinders" type="button" class="button" value="Binders" style="width: 100px;"/>
		</div>
	</div>
	<div id="hiddenDiv">
		<input type="hidden" id="hidRiCd" />
	</div>
</div>
<script type="text/javascript">
try{
	var objRiPlacement = new Object();
	var jsonSummDistRiPlacement = JSON.parse('${summDistRiPlacement}');

	summDistRiPlacementTableModel = {
		url : contextPath + "/GIPIPolbasicController?action=viewSummDistRiPlacement&lineCd=" + $F("hidLineCd") + "&sublineCd=" + $F("hidSublineCd")
						  + "&issCd=" + $F("hidIssCd") + "&issueYy=" + $F("hidIssueYy") + "&polSeqNo=" + $F("hidPolSeqNo") + "&renewNo=" + $F("hidRenewNo") + "&refresh=1",
		options : {
			toolbar : {
				elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
				onFilter : function() {
					tbgSummDistRiPlacement.keys.removeFocus(tbgSummDistRiPlacement.keys._nCurrentFocus, true);
					tbgSummDistRiPlacement.keys.releaseKeys();
				}
			},
			width : '534px',
			height : '177px',
			onCellFocus : function(element, value, x, y, id) {
				tbgSummDistRiPlacement.keys.removeFocus(tbgSummDistRiPlacement.keys._nCurrentFocus, true);
				tbgSummDistRiPlacement.keys.releaseKeys();
				$("hidRiCd").value = tbgSummDistRiPlacement.geniisysRows[y].riCd;
			}, 
			onRemoveRowFocus : function(element, value, x, y, id) {
				tbgSummDistRiPlacement.keys.removeFocus(tbgSummDistRiPlacement.keys._nCurrentFocus, true);
				tbgSummDistRiPlacement.keys.releaseKeys();
				$("hidRiCd").value = "";
			},
			onSort : function() {
				tbgSummDistRiPlacement.keys.removeFocus(tbgSummDistRiPlacement.keys._nCurrentFocus, true);
				tbgSummDistRiPlacement.keys.releaseKeys();
				$("hidRiCd").value = "";
			},
			onRefresh : function() {
				tbgSummDistRiPlacement.keys.removeFocus(tbgSummDistRiPlacement.keys._nCurrentFocus, true);
				tbgSummDistRiPlacement.keys.releaseKeys();
				$("hidRiCd").value = "";
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
				id : 'riSname',
				title : 'Reinsurer',
				titleAlign: 'center',
				filterOption : true,
				width : '130px'
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
		rows : jsonSummDistRiPlacement.rows
	};
	
	tbgSummDistRiPlacement = new MyTableGrid(summDistRiPlacementTableModel);
	tbgSummDistRiPlacement.pager = jsonSummDistRiPlacement;
	tbgSummDistRiPlacement.render('riPlacementTGDiv');
	tbgSummDistRiPlacement.afterRender = function(){
		//$("hidRiCd").value = tbgSummDistRiPlacement.geniisysRows[0].riCd;
		$("totShr").value = formatToNineDecimal(tbgSummDistRiPlacement.geniisysRows[0].totRiShrPct);
		$("totRiTsi").value = formatCurrency(tbgSummDistRiPlacement.geniisysRows[0].totRiTsiAmt);
		$("totRiPrem").value = formatCurrency(tbgSummDistRiPlacement.geniisysRows[0].totRiPremAmt);
	};
	
	function viewBinder(){
		try{
			viewBinderOverlay = Overlay.show(contextPath + "/GIPIPolbasicController", {
				urlContent: true,
	            draggable: true,
	            urlParameters: {
	                    action : "viewBinder",
	                    riCd : $F("hidRiCd"),
	                    lineCd : $F("hidLineCd"),
	                    sublineCd : $F("hidSublineCd"),
	                    issCd : $F("hidIssCd"),
	                    issueYy : $F("hidIssueYy"),
	                    polSeqNo : $F("hidPolSeqNo"),
	                    renewNo : $F("hidRenewNo")
	            },
	            title: "Binders",
	        	height: 276,
	        	width: 548
			});
		}catch(e){
			showMessageBox("viewBinder",e);
		}
	}

	$("btnOk").observe("click", function(){
		viewRiPlacementOverlay.close();
	});
	$("btnBinders").observe("click", function(){
		if($F("hidRiCd") == ""){
			showMessageBox("Please select a Reinsurer.", "I");
		}else{
			viewBinder();	
		}
	});
	} catch (e) {
		showErrorMessage("riPlacement page: ", e);
	}
</script>