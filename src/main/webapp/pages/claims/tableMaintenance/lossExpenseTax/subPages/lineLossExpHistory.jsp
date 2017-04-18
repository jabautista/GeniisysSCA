<div align="center" class="sectionDiv" style="width: 400px;">
	<table cellspacing="2" style="width: 200px; margin-top: 10px; margin-bottom: 10px;">
		<tr>
			<td class="rightAligned" style="padding-right: 5px;">Line</td>
			<td class="leftAligned" style="width:120px;">
				<input id="txtLineCd" type="text" ignoreDelKey="1" class="disableDelKey allCaps" style="width: 50px;" tabindex="101" readonly="readonly">
			</td>
			<td class="leftAligned">
				<input id="txtLineName" type="text" ignoreDelKey="1" class="disableDelKey allCaps" style="width: 200px;" tabindex="102" readonly="readonly">
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="padding-right: 5px;">Loss/Expense</td>
			<td class="leftAligned" style="width:120px;">
				<input id="txtLossExpCd" type="text" ignoreDelKey="1" class="disableDelKey allCaps" style="width: 50px;" tabindex="103"  readonly="readonly">
			</td>
			<td class="leftAligned">
				<input id="txtLossExpDesc" type="text" ignoreDelKey="1" class="disableDelKey allCaps" style="width: 200px;" tabindex="104" readonly="readonly">
			</td>
		</tr>
	</table>
</div>
<div class="sectionDiv" style="width: 400px;">
	<div id="lineLossExpHistoryTableDiv" style="padding-top: 10px; padding-bottom: 10px">
		<div id="lineLossExpHistoryTable" style="height: 231px; padding-left: 10px;"></div>
	</div>
</div>
<div align="center">
	<input type="button" class="button" value="Return" id="btnReturn" style="margin-top: 10px; width: 100px;" />
</div>
<script type="text/javascript">	
	$("btnReturn").observe("click", function(){
		overlayLineLossExpHist.close();
		delete overlayLineLossExpHist;
	});
	
	var jsonLineLossExpHistory = JSON.parse('${jsonLineLossExpHistory}');	
	
	lineLossExpHistoryTable = {
			url : contextPath+"/GIISLossTaxesController?action=showLineLossExpHistory&refresh=1&lossTaxId="+'${lossTaxId}'+"&lineCd="+encodeURIComponent(jsonLineLossExpHistory.rows[0].lineCd)+"&lossExpCd="+encodeURIComponent(jsonLineLossExpHistory.rows[0].lossExpCd),
			options: {
				width: '380px',
				pager: {
				},
				onCellFocus : function(element, value, x, y, id) {
					tbgLineLossExpHistory.keys.removeFocus(tbgLineLossExpHistory.keys._nCurrentFocus, true);
					tbgLineLossExpHistory.keys.releaseKeys();
				},
				prePager: function(){
					tbgLineLossExpHistory.keys.removeFocus(tbgLineLossExpHistory.keys._nCurrentFocus, true);
					tbgLineLossExpHistory.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id){					
					tbgLineLossExpHistory.keys.removeFocus(tbgLineLossExpHistory.keys._nCurrentFocus, true);
					tbgLineLossExpHistory.keys.releaseKeys();
				},
				onSort : function(){
					tbgLineLossExpHistory.keys.removeFocus(tbgLineLossExpHistory.keys._nCurrentFocus, true);
					tbgLineLossExpHistory.keys.releaseKeys();	
				},
				onRefresh : function(){
					tbgLineLossExpHistory.keys.removeFocus(tbgLineLossExpHistory.keys._nCurrentFocus, true);
					tbgLineLossExpHistory.keys.releaseKeys();
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
						id : "taxRate",
						title: "Tax Rate",
						width: '90px',
						align: 'right',
						titleAlign : "right",
						renderer : function(value) {
							return formatToNthDecimal(value,9);
						}
					},
					{
						id : "userId", 
						title: "User ID",
						width: '138px'
					},
					{
						id : "lastUpdate",
						title: "Last Update",
						width: '140px',
						align: 'center',
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
					}
			],
			rows: jsonLineLossExpHistory.rows
		};
	
	tbgLineLossExpHistory = new MyTableGrid(lineLossExpHistoryTable);
	tbgLineLossExpHistory.pager = jsonLineLossExpHistory;
	tbgLineLossExpHistory.render('lineLossExpHistoryTable');
	
	$("txtLineCd").value = unescapeHTML2(tbgLineLossExpHistory.geniisysRows[0].lineCd);
	$("txtLossExpCd").value = unescapeHTML2(tbgLineLossExpHistory.geniisysRows[0].lossExpCd);
	$("txtLineName").value = unescapeHTML2(tbgLineLossExpHistory.geniisysRows[0].lineName);
	$("txtLossExpDesc").value = unescapeHTML2(tbgLineLossExpHistory.geniisysRows[0].lossExpDesc);
</script>