<div id="distPerItemMainDiv">
	<div class="sectionDiv" style="width: 745px; height: 529px; margin-top: 8px;">
		<div id="policyDiv" class="sectionDiv" style="border: none; margin-top: 15px;">
			<label style="margin-left: 117px; margin-top: 6px;">Policy</label>
			<input type="text" id="policyNo" style="margin-left: 5px; width: 240px; float: left;" readonly="readonly"/>
			<label style="margin-left: 19px; margin-top: 6px; float: left;">Item No</label>
			<input type="text" id="itemNo" style="margin-left: 5px; width: 200px; text-align: right;" readonly="readonly"/>
		</div>
		<div class="sectionDiv" style="border: none;">
			<label style="margin-left: 44px; margin-top: 6px;">Total Sum Insured</label>
			<input id="txtTsi" type="text" style="margin-left: 5px; width: 240px; float: left; text-align: right;" readonly="readonly"/>
			<label style="margin-left: 14px; margin-top: 6px; float: left;">Premium</label>
			<input id="txtPremium" type="text" style="margin-left: 5px; width: 200px; float: left; text-align: right;" readonly="readonly"/>
		</div>
		<div id="distItemTGDiv" class="sectionDiv" style="height: 200px; width: 400px; margin-left: 165px; margin-top: 15px;">
			
		</div>
		<div id="distPerItemTGDiv" class="sectionDiv" style="height: 200px; width: 732px; margin-left: 5px; margin-top: 15px;">
			
		</div>
		<div id="sectionDiv">
			<label style="margin-left: 147px; margin-top: 6px;">Total</label>
			<input type="text" id="txtTotTsiSpct" style="width: 114px; margin-left: 5px; text-align: right; float: left;" readonly="readonly"/>
			<input type="text" id="txtTotDistTsi" style="width: 128px; margin-left: 1px; text-align: right; float: left;" readonly="readonly"/>
			<input type="text" id="txtTotPremSpct" style="width: 114px; margin-left: 1px; text-align: right; float: left;" readonly="readonly"/>
			<input type="text" id="txtTotDistPrem" style="width: 128px; margin-left: 1px; text-align: right; float: left;" readonly="readonly"/>
		</div>
	</div>	
	<div id="buttonsDiv" class="sectionDiv" style="border: none; margin-top: 8px; margin-left: 5px; width: 732px; text-align: center;">
		<input type="button" id="btnOk" class="button" value="Ok" style="width: 140px;"/>
	</div>
</div>
<script type="text/javascript">
try{
	var objDistItemDtl = new Object();	
	var jsonDistItem = JSON.parse('${distItem}');
	var jsonDistPerItemDtl = new Object();
	
	distItemTableModel = {
		url : contextPath + "/GIPIPolbasicController?action=viewDistItem&lineCd=" + $F("hidLineCd") + "&sublineCd=" + $F("hidSublineCd")
						  + "&issCd=" + $F("hidIssCd") + "&issueYy=" + $F("hidIssueYy") + "&polSeqNo=" + $F("hidPolSeqNo") + "&renewNo=" + $F("hidRenewNo") + "&refresh=1",
		options : {
			toolbar : {
				elements : [ MyTableGrid.REFRESH_BTN ],
			},
			width : '400px',
			height : '177px',
			onCellFocus : function(element, value, x, y, id) {
				tbgDistItem.keys.removeFocus(tbgDistItem.keys._nCurrentFocus, true);
				tbgDistItem.keys.releaseKeys();
				objDistItemDtl = tbgDistItem.geniisysRows[y];
				showDistItemDtlTG(true);
			}, 
			onRemoveRowFocus : function(element, value, x, y, id) {
				tbgDistItem.keys.removeFocus(tbgDistItem.keys._nCurrentFocus, true);
				tbgDistItem.keys.releaseKeys();
				showDistItemDtlTG(false);
				clearFields();
			},
			onSort : function() {
				tbgDistItem.keys.removeFocus(tbgDistItem.keys._nCurrentFocus, true);
				tbgDistItem.keys.releaseKeys();
				showDistItemDtlTG(false);
				clearFields();
			},
			onRefresh : function() {
				tbgDistItem.keys.removeFocus(tbgDistItem.keys._nCurrentFocus, true);
				tbgDistItem.keys.releaseKeys();
				showDistItemDtlTG(false);
				clearFields();
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
				id : 'policyNo',
				title : 'Policy No',
				titleAlign: 'center',
				width : '240px'
			},
			{
				id : 'itemNo',
				title : 'Item No',
				titleAlign: 'center',
				sortable : true,
				width : '130px'
			}
		],
		rows : jsonDistItem.rows
	};
	
	tbgDistItem = new MyTableGrid(distItemTableModel);
	tbgDistItem.pager = jsonDistItem;
	tbgDistItem.render('distItemTGDiv');
	tbgDistItem.afterRender = function(){
		$("policyNo").value = tbgDistItem.geniisysRows[0].policyNo;
	};
	
	function showDistItemDtlTG(show){
		try{	
			if(show){
				var itemNo = objDistItemDtl.itemNo;
				
				tbgDistPerItem.url = contextPath + "/GIPIPolbasicController?action=viewDistPerItem&itemNo=" + itemNo + "&lineCd=" + $F("hidLineCd") + "&sublineCd=" + $F("hidSublineCd")
				  									 + "&issCd=" + $F("hidIssCd") + "&issueYy=" + $F("hidIssueYy") + "&polSeqNo=" + $F("hidPolSeqNo") + "&renewNo=" + $F("hidRenewNo") + "&refresh=1",
				tbgDistPerItem._refreshList();
			} else{
				clearTableGridDetails(tbgDistPerItem); 
			}
		}catch(e){
			showErrorMessage("showDistItemDtlTG ",e);
		}
	}
	
	function clearFields(){
		$("itemNo").clear();
		$("txtTsi").clear();
		$("txtPremium").clear();
		$("txtTotTsiSpct").clear();
		$("txtTotDistTsi").clear();
		$("txtTotPremSpct").clear();
		$("txtTotDistPrem").clear();
	}
	
	distPerItemTableModel = {
		id : 33,
		options : {
			width : '732px',
			height : '177px',
			onCellFocus : function(element, value, x, y, id) {
				tbgDistPerItem.keys.removeFocus(tbgDistPerItem.keys._nCurrentFocus, true);
				tbgDistPerItem.keys.releaseKeys();
			}, 
			onRemoveRowFocus : function(element, value, x, y, id) {
				tbgDistPerItem.keys.removeFocus(tbgDistPerItem.keys._nCurrentFocus, true);
				tbgDistPerItem.keys.releaseKeys();
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
				id : 'trtyName',
				title : 'Share',
				titleAlign: 'center',
				sortable : true,
				width : '171px'
			},
			{
				id : 'tsiSpct',
				title : 'Percent Share',
				titleAlign: 'center',
				align: 'right',
				sortable : true,
				width : '120px',
				geniisysClass : 'money',     
	            geniisysMinValue: '-999999999999.99',     
	            geniisysMaxValue: '999,999,999,999.99',
	            renderer: function(value){
					return formatToNineDecimal(value);
				}
			},
			{
				id : 'distTsi',
				title : 'Sum Insured',
				titleAlign: 'center',
				align: 'right',
				geniisysClass: 'money',
				sortable : true,
				width : '134px'
			},
			{
				id : 'premSpct',
				title : 'Percent Share',
				titleAlign: 'center',
				align: 'right',
				sortable : true,
				width : '120px',
				geniisysClass : 'money',     
	            geniisysMinValue: '-999999999999.99',     
	            geniisysMaxValue: '999,999,999,999.99',
	            renderer: function(value){
					return formatToNineDecimal(value);
				}
			},
			{
				id : 'distPrem',
				title : 'Premium Amount',
				titleAlign: 'center',
				align: 'right',
				geniisysClass: 'money',
				sortable : true,
				width : '134px'
			}
		],
		rows : []
	};
	
	tbgDistPerItem = new MyTableGrid(distPerItemTableModel);
	tbgDistPerItem.pager = jsonDistPerItemDtl;
	tbgDistPerItem.render('distPerItemTGDiv');
	tbgDistPerItem.afterRender = function(){
		$("txtTotTsiSpct").value = formatToNineDecimal(tbgDistPerItem.geniisysRows[0].totTsiSpct);
		$("txtTotDistTsi").value = formatCurrency(tbgDistPerItem.geniisysRows[0].totDistTsi);
		$("txtTotPremSpct").value = formatToNineDecimal(tbgDistPerItem.geniisysRows[0].totPremSpct);
		$("txtTotDistPrem").value = formatCurrency(tbgDistPerItem.geniisysRows[0].totDistPrem);
		$("txtTsi").value = formatCurrency(tbgDistPerItem.geniisysRows[0].totDistTsi);
		$("txtPremium").value = formatCurrency(tbgDistPerItem.geniisysRows[0].totDistPrem);
		$("policyNo").value = tbgDistPerItem.geniisysRows[0].policyNo;
		$("itemNo").value = tbgDistPerItem.geniisysRows[0].itemNo;
	};
	
	$("btnOk").observe("click", function(){
		viewDistPerItemOverlay.close();
	});
}catch(e){
	showErrorMessage("distributionPerItem page: ",e);
}
</script>