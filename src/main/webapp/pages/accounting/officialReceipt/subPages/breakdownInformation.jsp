<div id="outerDiv">
	<div id="innerDiv">
		<label>Premium Information</label> <span style="margin-top: 0pt;"
			class="refreshers"> <label style="margin-left: 5px;" id="premInfoGro"
			name="gro">Show</label>
		</span>
	</div>
</div>
<div id="premInformationMotherDiv" name="premInformationMotherDiv" class="sectionDiv">
	<div id="premInformationDiv" name="premInformationDiv" >
		<div id="premInformationGrid" style="height: 206px; width:800px; padding: 10px 0 0 10px;  margin-left: 50px; margin-bottom: 2px; " align="center"></div>	
		<div>
			<table style="margin-bottom: 5px; margin-right: 60px" align="right">
				<tr>
					<td class="rightAligned">Total :  </td>
					<td class="leftAligned">
						<input type="text" id="txtTotalPremAmt2" name="txtTotalPremAmt2" readonly="readonly" style="width: 210px;" class="money" value="" tabindex="1031" />
					</td>
				</tr>
			</table>
		</div>
	</div>
</div>
<div id="outerDiv">
	<div id="innerDiv">
		<label>Taxes Information</label> <span style="margin-top: 0pt;"
			class="refreshers"> <label style="margin-left: 5px;" id="taxInfoGro"
			name="gro">Show</label>
		</span>
	</div>
</div>
<div id="taxInformationMotherDiv" name="taxInformationMotherDiv"  class="sectionDiv" >
	<div id="taxInformationDiv" name="taxInformationDiv" >
		<div id="taxInformationGrid" style="height: 206px; width:800px; padding: 10px 0 0 10px;  margin-left: 50px; margin-bottom: 2px; " align="center"></div>	
		<div>
			<table style="margin-bottom: 5px; margin-right: 60px" align="right">
				<tr>
					<td class="rightAligned">Total :  </td>
					<td class="leftAligned">
						<input type="text" id="txtTotalTaxAmt2" name="txtTotalTaxAmt2" readonly="readonly" style="width: 210px;" class="money" value="" tabindex="1032" />
					</td>
				</tr>
			</table>
		</div>
	</div>
</div>

<script type="text/javascript">
try{
	objTaxInfo = new Object();
	objPremInfo = new Object();

	initializeAccordion();
	
	var taxInfoTableModel = {
			id: 2,
		options : {
			title: '',
			pager : {}, 
			toolbar : {
				elements : [ MyTableGrid.REFRESH_BTN ],
				onRefresh : function() {
					taxInfoTableGrid.keys.releaseKeys();
				}
			},
			onCellFocus: function(element, value, x, y, id){
				objTaxInfo = taxInfoTableGrid.geniisysRows[y];
				taxInfoTableGrid.keys.releaseKeys();
			},
			onRemoveRowFocus: function(){
				objTaxInfo = null;
				taxInfoTableGrid.keys.releaseKeys();
			},
			onCellBlur: function(){
				taxInfoTableGrid.keys.removeFocus(taxInfoTableGrid.keys._nCurrentFocus, true);
				taxInfoTableGrid.keys.releaseKeys();
			}
		},
		columnModel : [
			{   id: 'recordStatus',
			    width: '0px',
			    visible: false,
			    editor: 'checkbox'
			},
			{	id: 'divCtrId',
				width: '0px',
				visible: false
			},{
				id: 'b160TaxCd',
				title: 'Tax Code',
				titleAlign: 'right',
				align : 'right',
				width : '100px',
				type: 'number',
				renderer : function(value){
					return lpad(value.toString(), 2, "0");					
				}
				
			},{
				id: 'taxName',
				title: 'Tax Description',
				titleAlign: 'left',
				align : 'left',
				width : '470px'
			},{
				id : 'taxAmt',
				title : 'Tax Amount',
				titleAlign : 'right',
				type : 'number',
				width : '200px',
				geniisysClass : 'money',
				filterOption : true,
				filterOptionType : 'number'
			}
		],
		//resetChangeTag: true,	// SR-20000 : shan 08.25.2015
		rows: []
	};
	
	taxInfoTableGrid = new MyTableGrid(taxInfoTableModel);
	taxInfoTableGrid.pager = objTaxInfo;
	taxInfoTableGrid.mtgId = 2;
	taxInfoTableGrid.render('taxInformationGrid');
	taxInfoTableGrid.afterRender = function(){
		var totalTaxAmt = 0;
		var rows = taxInfoTableGrid.geniisysRows;
		for(var i = 0; i < rows.length; i++){
			if(rows[i].recordStatus != -1){
				totalTaxAmt += parseFloat(nvl(rows[i].taxAmt,0));
			}
		}
		$("txtTotalTaxAmt2").value = formatCurrency(totalTaxAmt);
	};
	
	var premInfoTableModel = {
			id: 3,
		options : {
			title: '',
			pager : {}, 
			toolbar : {
				elements : [ MyTableGrid.REFRESH_BTN ],
				onRefresh : function() {
					taxInfoTableGrid.keys.releaseKeys();
				}
			},
			onCellFocus: function(element, value, x, y, id){
				objPremInfo = premInfoTableGrid.geniisysRows[y];
				premInfoTableGrid.keys.releaseKeys();
			},
			onRemoveRowFocus: function(){
				objPremInfo = null;
				premInfoTableGrid.keys.releaseKeys();
			},
			onCellBlur: function(){
				premInfoTableGrid.keys.removeFocus(premInfoTableGrid.keys._nCurrentFocus, true);
				premInfoTableGrid.keys.releaseKeys();
			}
		},
		columnModel : [
			{   id: 'recordStatus',
			    width: '0px',
			    visible: false,
			    editor: 'checkbox'
			},
			{	id: 'divCtrId',
				width: '0px',
				visible: false
			},{
				id: 'dspPerilCd',
				title: 'Peril Code',
				titleAlign: 'right',
				align : 'right',
				width : '100px',
				type: 'number',
				renderer : function(value){
					return lpad(value.toString(), 2, "0");					
				}
				
			},{
				id: 'dspPerilName',
				title: 'Peril Name',
				titleAlign: 'left',
				align : 'left',
				width : '470px'
			},{
				id : 'dspPremAmt',
				title : 'Premium Amount',
				titleAlign : 'right',
				type : 'number',
				width : '200px',
				geniisysClass : 'money',
				filterOption : true,
				filterOptionType : 'number'
			}
		],
		//resetChangeTag: true,		// SR-20000 : shan 08.25.2015
		rows: []
	};	
	premInfoTableGrid = new MyTableGrid(premInfoTableModel);
	premInfoTableGrid.pager = objPremInfo;
	premInfoTableGrid.mtgId = 2;
	premInfoTableGrid.render('premInformationGrid');
	premInfoTableGrid.afterRender = function(){
		var totalPremAmt = 0;
		var rows = premInfoTableGrid.geniisysRows;
		for(var i = 0; i < rows.length; i++){
			if(rows[i].recordStatus != -1){
				totalPremAmt += parseFloat(nvl(rows[i].dspPremAmt,0));
			}
		}
		$("txtTotalPremAmt2").value = formatCurrency(totalPremAmt);
	};
	
	$("taxInfoGro").observe("click", function(){
		if(objAC.currentRecord != {}){
			if(objAC.currentRecord.origTaxAmt =='0'){
				showWaitingMessageBox("Tax amount is zero. No amounts to view", "I", function(){
					$("taxInfoGro").innerHTML = "Show";
					$("taxInformationMotherDiv").hide();
				});
			}
		}
	});
	
	$("premInformationMotherDiv").hide();
	$("taxInformationMotherDiv").hide();
	
}catch(e){
	showErrorMessage("Breakdown Information page", e);
}
	
</script>