<div id="distPerPerilMainDiv">
	<div class="sectionDiv" style="width: 612px; height: 512px; margin-top: 8px;">
		<div id="policyDiv" class="sectionDiv" style="border: none; margin-top: 15px;">
			<label style="margin-left: 22px; margin-top: 6px;">Policy</label>
			<input type="text" id="policyNo" style="margin-left: 5px; width: 240px; float: left;" readonly="readonly"/>
			<label style="margin-left: 45px; margin-top: 6px; float: left;">TSI</label>
			<input type="text" id="totalTsi" style="margin-left: 5px; width: 200px; text-align: right;" readonly="readonly"/>
		</div>
		<div class="sectionDiv" style="border: none;">
			<label style="margin-left: 30px; margin-top: 6px;">Peril</label>
			<input id="perilName" type="text" style="margin-left: 5px; width: 240px; float: left;" readonly="readonly"/>
			<label style="margin-left: 14px; margin-top: 6px; float: left;">Premium</label>
			<input id="totalPrem" type="text" style="margin-left: 5px; width: 200px; float: left; text-align: right;" readonly="readonly"/>
		</div>
		<div id="distPerilTGDiv" class="sectionDiv" style="height: 200px; width: 600px; margin-left: 5px; margin-top: 5px; text-align: center;">
			
		</div>
		<div id="distPerPerilDtlTGDiv" class="sectionDiv" style="height: 200px; width: 600px; margin-left: 5px; margin-top: 5px;">
			
		</div>
		<div id="sectionDiv" style="float: left;">
			<label style="margin-left: 126px; margin-top: 6px; float: left;">Total</label>
			<input type="text" id="txtTotTsiSpct" style="width: 89px; margin-left: 5px; text-align: right; float: left;" readonly="readonly"/>
			<input type="text" id="txtTotDistTsi" style="width: 106px; margin-left: 1px; text-align: right; float: left;" readonly="readonly"/>
			<input type="text" id="txtTotPremSpct" style="width: 89px; margin-left: 1px; text-align: right; float: left;" readonly="readonly"/>
			<input type="text" id="txtTotDistPrem" style="width: 106px; margin-left: 1px; text-align: right; float: left;" readonly="readonly"/>
		</div>
	</div>	
	<div id="buttonsDiv" class="sectionDiv" style="border: none; margin-top: 8px; margin-left: 5px; width: 600px; text-align: center;">
		<input type="button" id="btnOk" class="button" value="Ok" style="width: 140px;"/>
	</div>
</div>
<script type="text/javascript">
try{
	var objDistPerilDtl = new Object();	
	var jsonDistPeril = JSON.parse('${distPeril}');
	var jsonDistPerPerilDtl = new Object();
	
	distPerilTableModel = {
		url : contextPath + "/GIPIPolbasicController?action=viewDistPeril&lineCd=" + $F("hidLineCd") + "&sublineCd=" + $F("hidSublineCd")
						  + "&issCd=" + $F("hidIssCd") + "&issueYy=" + $F("hidIssueYy") + "&polSeqNo=" + $F("hidPolSeqNo") + "&renewNo=" + $F("hidRenewNo") + "&refresh=1",
		options : {
			toolbar : {
				elements : [ MyTableGrid.REFRESH_BTN ],
				onFilter : function() {
					tbgDistPeril.keys.removeFocus(tbgDistPeril.keys._nCurrentFocus, true);
					tbgDistPeril.keys.releaseKeys();
				}
			},
			width : '600px',
			height : '177px',
			onCellFocus : function(element, value, x, y, id) {
				tbgDistPeril.keys.removeFocus(tbgDistPeril.keys._nCurrentFocus, true);
				tbgDistPeril.keys.releaseKeys();
				objDistPerilDtl = tbgDistPeril.geniisysRows[y];
				showDistPerilDtlTG(true);
			}, 
			onRemoveRowFocus : function(element, value, x, y, id) {
				tbgDistPeril.keys.removeFocus(tbgDistPeril.keys._nCurrentFocus, true);
				tbgDistPeril.keys.releaseKeys();
				showDistPerilDtlTG(false);
				$("perilName").clear();
			},
			onSort : function() {
				tbgDistPeril.keys.removeFocus(tbgDistPeril.keys._nCurrentFocus, true);
				tbgDistPeril.keys.releaseKeys();
				$("perilName").clear();
				showDistPerilDtlTG(false);
			},
			onRefresh : function() {
				tbgDistPeril.keys.removeFocus(tbgDistPeril.keys._nCurrentFocus, true);
				tbgDistPeril.keys.releaseKeys();
				$("perilName").clear();
				showDistPerilDtlTG(false);
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
				sortable : true,
				width : '240px'
			},
			{
				id : 'perilName',
				title : 'Peril',
				titleAlign: 'center',
				sortable : true,
				width : '330px'
			}
		],
		rows : jsonDistPeril.rows
	};
	
	tbgDistPeril = new MyTableGrid(distPerilTableModel);
	tbgDistPeril.pager = jsonDistPeril;
	tbgDistPeril.render('distPerilTGDiv');
	tbgDistPeril.afterRender = function(){
		$("totalTsi").value = formatCurrency(tbgDistPeril.geniisysRows[0].totDistTsi);
		$("totalPrem").value = formatCurrency(tbgDistPeril.geniisysRows[0].totDistPrem);
		$("policyNo").value = tbgDistPeril.geniisysRows[0].policyNo;
		$("perilName").value = unescapeHTML2(tbgDistPeril.geniisysRows[0].perilName);
		if(tbgDistPerPerilDtl.geniisysRows == ""){
			clearTotals();
		}else{
			$("txtTotTsiSpct").value = formatToNineDecimal(tbgDistPerPerilDtl.geniisysRows[0].totTsiSpct);
			$("txtTotDistTsi").value = formatCurrency(tbgDistPerPerilDtl.geniisysRows[0].totDistTsi);
			$("txtTotPremSpct").value = formatToNineDecimal(tbgDistPerPerilDtl.geniisysRows[0].totPremSpct);
			$("txtTotDistPrem").value = formatCurrency(tbgDistPerPerilDtl.geniisysRows[0].totDistPrem);	
		}
	};
	
	function showDistPerilDtlTG(show){
		try{	
			if(show){
				var perilCd = objDistPerilDtl.perilCd;
				$("perilName").value = unescapeHTML2(objDistPerilDtl.perilName);
				tbgDistPerPerilDtl.url = contextPath + "/GIPIPolbasicController?action=viewDistPerPeril&perilCd=" + perilCd + "&lineCd=" + $F("hidLineCd") + "&sublineCd=" + $F("hidSublineCd")
				  									 + "&issCd=" + $F("hidIssCd") + "&issueYy=" + $F("hidIssueYy") + "&polSeqNo=" + $F("hidPolSeqNo") + "&renewNo=" + $F("hidRenewNo") + "&refresh=1",
				tbgDistPerPerilDtl._refreshList();
			} else{
				clearTableGridDetails(tbgDistPerPerilDtl); 
				clearTotals();
			}
		}catch(e){
			showErrorMessage("showDistPerilDtlTG ",e);
		}
	}
	
	function clearTotals(){
		$("txtTotTsiSpct").clear();
		$("txtTotDistTsi").clear();
		$("txtTotPremSpct").clear();
		$("txtTotDistPrem").clear();
	}
	
	distPerPerilDtlTableModel = {
		id: 22,
		options : {
			width : '600px',
			height : '177px',
			onCellFocus : function(element, value, x, y, id) {
				tbgDistPerPerilDtl.keys.removeFocus(tbgDistPerPerilDtl.keys._nCurrentFocus, true);
				tbgDistPerPerilDtl.keys.releaseKeys();
			}, 
			onRemoveRowFocus : function(element, value, x, y, id) {
				tbgDistPerPerilDtl.keys.removeFocus(tbgDistPerPerilDtl.keys._nCurrentFocus, true);
				tbgDistPerPerilDtl.keys.releaseKeys();
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
				width : '149px'
			},
			{
				id : 'tsiSpct',
				title : 'Percent Share',
				titleAlign: 'center',
				align: 'right',
				sortable : true,
				width : '95px',
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
				width : '112px'
			},
			{
				id : 'premSpct',
				title : 'Percent Share',
				titleAlign: 'center',
				align: 'right',
				sortable : true,
				width : '95px',
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
				width : '112px'
			}
		],
		rows : []
	};
	
	tbgDistPerPerilDtl = new MyTableGrid(distPerPerilDtlTableModel);
	tbgDistPerPerilDtl.pager = jsonDistPerPerilDtl;
	tbgDistPerPerilDtl.render('distPerPerilDtlTGDiv');
	tbgDistPerPerilDtl.afterRender = function(){
		$("txtTotTsiSpct").value = formatToNineDecimal(tbgDistPerPerilDtl.geniisysRows[0].totTsiSpct);
		$("txtTotDistTsi").value = formatCurrency(tbgDistPerPerilDtl.geniisysRows[0].totDistTsi);
		$("txtTotPremSpct").value = formatToNineDecimal(tbgDistPerPerilDtl.geniisysRows[0].totPremSpct);
		$("txtTotDistPrem").value = formatCurrency(tbgDistPerPerilDtl.geniisysRows[0].totDistPrem);
	};
	
	$("btnOk").observe("click", function(){
		viewDistPerPerilOverlay.close();
	});
}catch(e){
	showErrorMessage("distributionPerPeril page: ",e);
}
</script>