<div align="center" class="sectionDiv" style="width: 700px; margin-top: 5px;">
	<table cellspacing="2" style="width: 200px; margin-top: 10px; margin-bottom: 10px;">
		<tr>
			<td><label style="width: 50px; text-align: center;" >Tax</label></td>
			<td class="leftAligned" style="width:120px;">
				<input id="txtTaxCd2" type="text" ignoreDelKey="1" class="rightAligned disableDelKey allCaps" style="width: 50px;" tabindex="101" readonly="readonly">
			</td>
			<td class="leftAligned">
				<input id="txtTaxDesc2" type="text" ignoreDelKey="1" class="disableDelKey allCaps" style="width: 400px;" tabindex="102" readonly="readonly">
			</td>
		</tr>
	</table>
</div>
<div class="sectionDiv" style="width: 700px;">
	<div id="taxRateHistoryTableDiv" style="padding-top: 10px; padding-bottom: 10px">
		<div id="taxRateHistoryTable" style="height: 311px; padding-left: 10px;"></div>
	</div>
</div>
<div align="center">
	<input type="button" class="button" value="Return" id="btnReturn" style="margin-top: 10px; width: 100px;" />
</div>
<script type="text/javascript">	
	$("btnReturn").observe("click", function(){
		overlayTaxRateHistory.close();
		delete overlayTaxRateHistory;
	});
	
	$("txtTaxCd2").value = '${taxCd}';
	$("txtTaxDesc2").value = '${taxDesc}';
	var jsonTaxRateHistory = JSON.parse('${jsonTaxRateHistory}');	
		taxRateHistoryTable = {
				url : contextPath+"/GIISLossTaxesController?action=showTaxRateHistory&refresh=1&lossTaxId="+'${lossTaxId}',
				options: {
					width: '680px',
					pager: {
					},
					onCellFocus : function(element, value, x, y, id) {
						tbgTaxRateHistory.keys.removeFocus(tbgTaxRateHistory.keys._nCurrentFocus, true);
						tbgTaxRateHistory.keys.releaseKeys();
					},
					prePager: function(){
						tbgTaxRateHistory.keys.removeFocus(tbgTaxRateHistory.keys._nCurrentFocus, true);
						tbgTaxRateHistory.keys.releaseKeys();
					},
					onRemoveRowFocus : function(element, value, x, y, id){					
						tbgTaxRateHistory.keys.removeFocus(tbgTaxRateHistory.keys._nCurrentFocus, true);
						tbgTaxRateHistory.keys.releaseKeys();
					},
					onSort : function(){
						tbgTaxRateHistory.keys.removeFocus(tbgTaxRateHistory.keys._nCurrentFocus, true);
						tbgTaxRateHistory.keys.releaseKeys();	
					},
					onRefresh : function(){
						tbgTaxRateHistory.keys.removeFocus(tbgTaxRateHistory.keys._nCurrentFocus, true);
						tbgTaxRateHistory.keys.releaseKeys();
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
							id : "startDate",
							title: "Start Date",
							width: '115px',
							align : "center",
							titleAlign : "center",
							renderer: function (value){
								var dateTemp;
								if(value=="" || value==null){
									dateTemp = "";
								}else{
									dateTemp = dateFormat(value,"mm-dd-yyyy");
								}
								value = dateTemp;
								return value;
							}
						},				
						{
							id : "endDate",
							title: "End Date",
							width: '115px',
							align : "center",
							titleAlign : "center",
							renderer: function (value){
								var dateTemp;
								if(value=="" || value==null){
									dateTemp = "";
								}else{
									dateTemp = dateFormat(value,"mm-dd-yyyy");
								}
								value = dateTemp;
								return value;
							}
						},
						{
							id : "taxRate",
							title: "Tax Rate",
							width: '90px',
							align : "right",
							titleAlign : "right",
							filterOptionType: 'number',
							renderer : function(value) {
								return formatCurrency(value);
							}
						},
						{
							id : "userId", 
							title: "User ID",
							width: '200px'
						},
						{
							id : "lastUpdate",
							title: "Last Update",
							width: '140px',
							align : "center",
							titleAlign : "center",
						}
				],
				rows: jsonTaxRateHistory.rows
			};
		
		tbgTaxRateHistory = new MyTableGrid(taxRateHistoryTable);
		tbgTaxRateHistory.pager = jsonTaxRateHistory;
		tbgTaxRateHistory.render('taxRateHistoryTable');
</script>