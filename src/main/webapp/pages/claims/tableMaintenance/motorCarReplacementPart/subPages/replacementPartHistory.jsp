<div id="replacementPartHistoryMainDiv" name="replacementPartHistoryMainDiv" style="height:400px;">
	<div id="replacementPartDetailDiv" name="replacementPartDetailDiv" class="sectionDiv" style="margin-top: 10px; width: 800px;">
		<table align="center" style="margin-top: 5px; margin-bottom: 5px;">
			<tr>
				<td class="rightAligned" style="padding-right: 3px;">Part</td>
				<td class="leftAligned">
					<input id="txtLossExpCd" name="txtLossExpCd" type="text" style="width: 60px; text-align: right;" value="" readonly="readonly" tabindex="500"/>
						<input id="txtLossExpDesc" name="txtLossExpDesc" type="text" style="width: 300px;" value="" readonly="readonly" tabindex="501"/>
				</td>
			</tr>
		</table>
	</div>
	<div id="histTableDiv" class="sectionDiv" style="height: 315px; width: 800px;">
		<div id="tableGridDiv" name="tableGridDiv" style="margin-top: 10px; margin-left: 10px; height: 290px;">
			<div id="historyTable" style="height: 190px;"></div>
		</div>
	</div>	
	<div class="buttonsDiv" style="width: 800px; margin-bottom: 10px;">
		<input type="button" class="button" id="btnReturn" name="btnReturn" value="Return" style="width:150px;" tabindex="1001"/>
	</div>
	
</div>

<script type="text/javascript">	
	try{
		var objHist = new Object();
		objHist.objHistListing = JSON.parse('${jsonMcPartCostListHistory}');
		var tbgHistory = {
				url: contextPath+"/GICLMcPartCostController?action=showMotorCarPartCostHistory&refresh=1&partCostId="+objCurrPartCostId,
			options: {
				width: '780px',
				height: '270px',
				hideColumnChildTitle: true,
				onCellFocus: function(element, value, x, y, id){
					historyTableGrid.keys.removeFocus(historyTableGrid.keys._nCurrentFocus, true);
					historyTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus: function(){
					historyTableGrid.keys.removeFocus(historyTableGrid.keys._nCurrentFocus, true);
					historyTableGrid.keys.releaseKeys();
	            },
                onSort: function(){
                	historyTableGrid.keys.removeFocus(historyTableGrid.keys._nCurrentFocus, true);
            		historyTableGrid.keys.releaseKeys();
                },
                prePager: function(){
                	historyTableGrid.keys.removeFocus(historyTableGrid.keys._nCurrentFocus, true);
            		historyTableGrid.keys.releaseKeys();
                },
				onRefresh: function(){
					historyTableGrid.keys.removeFocus(historyTableGrid.keys._nCurrentFocus, true);
					historyTableGrid.keys.releaseKeys();
				},
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onFilter: function(){
						historyTableGrid.keys.removeFocus(historyTableGrid.keys._nCurrentFocus, true);
						historyTableGrid.keys.releaseKeys();
					}
				}
			},
			columnModel: [
				{
					id : 'recordStatus',
					width : '0',
					visible : false
				},
				{	id: 'divCtrId',
					width: '0',
					visible: false
				},
				{	
					id: 'histNo',
					title: 'Hist No.',
					align : 'right',
					titleAlign : 'right',
					width: '100px',
					filterOptionType : 'integerNoNegative',
					filterOption: true,
					renderer: function(value){
						return (value != "" ? lpad(value, 3, 0) : "");
					}
				},
				{	
					id: 'origAmt',
					title: 'Original Amount',
					align : 'right',
					titleAlign : 'right',
					width: '160px',
					filterOption: true,
					filterOptionType : 'numberNoNegative',
					geniisysClass: 'money'
				},
				{
					id: 'surpAmt',
					title: 'Surplus Amount',
					align : 'right',
					titleAlign : 'right',
					width: '160px',
					filterOption: true,
					filterOptionType : 'numberNoNegative',
					geniisysClass: 'money'
				},
				{
					id: 'entryDate',
					title: 'Entry Date',
					width: '160px',
					align : 'center',
					titleAlign : 'center',
					filterOption: true,
					filterOptionType : 'formattedDate',
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
					id: 'userId',
					title: 'User',
					width: '160px',
					filterOption: true
				}
				],
			rows:objHist.objHistListing.rows
		};
		
		historyTableGrid = new MyTableGrid(tbgHistory);
		historyTableGrid.pager = objHist.objHistListing;
		historyTableGrid.render('historyTable');
		historyTableGrid.afterRender = function(y) {
			$("txtLossExpCd").value = unescapeHTML2(historyTableGrid.geniisysRows[0].lossExpCd);
			$("txtLossExpDesc").value = unescapeHTML2(historyTableGrid.geniisysRows[0].lossExpDesc); 
		};
		
	}catch (e) {
		showErrorMessage("historyTableGrid", e);
	}
	
	$("btnReturn").observe("click", function() {
		overlayHistory.close();
	});
	
</script>