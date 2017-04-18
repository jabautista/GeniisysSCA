<div id="commRateHistory" style="width: 99.5%; margin-top: 5px;">
    <div class="sectionDiv">
   		<div align="center" id="lovDiv">
			<table style="margin: 10px auto;">
				<tr>
					<td class="rightAligned">Intermediary</td>
					<td class="leftAligned">
						<input readonly="readonly" type="text" id="txtIntmNo" name="txtIntmNo" style="width: 50px; float: left; height: 13px; margin: 0; text-align: right;"tabindex="301"/>
					</td>
					<td class="leftAligned">
						<input id="txtIntmName" name="txtIntmName" type="text" style="width: 220px; height: 13px;" readonly="readonly" tabindex="302"/>
					</td>
					<td class="rightAligned" style="width: 100px;" id="">Issuing Source</td>
					<td class="leftAligned">
						<input readonly="readonly" type="text" id="txtIssCd" name="txtIntmName" style="width: 50px; float: left; height: 13px; margin: 0;" tabindex="303"/>
					</td>
					<td class="leftAligned">
						<input id="txtIssName" name="txtIssName" type="text" style="width: 220px; height: 13px;" readonly="readonly" tabindex="304"/>
					</td>
				</tr>	
				<tr>
					<td class="rightAligned" id="">Line</td>
					<td class="leftAligned">
						<input readonly="readonly" type="text" id="txtLineCd" name="txtLineCd" style="width: 50px; float: left; height: 13px; margin: 0;" tabindex="305"/>
					</td>
					<td class="leftAligned">
						<input id="txtLineName" name="txtLineName" type="text" style="width: 220px; height: 13px;" readonly="readonly" tabindex="306"/>
					</td>
					<td class="rightAligned" id="">Subline</td>
					<td class="leftAligned">
						<input readonly="readonly" type="text" id="txtSublineCd" name="txtSublineCd" style="width: 50px; float: left; height: 13px; margin: 0;" tabindex="307"/>
					</td>
					<td class="leftAligned">
						<input id="txtSublineName" name="txtSublineName" type="text" style="width: 220px; height: 13px;" readonly="readonly" tabindex="308"/>
					</td>
				</tr>
			</table>
		</div>
    </div>
	<div class="sectionDiv" style="padding: 10px 0 10px 10px; height: 255px; width: 98.78%">
		<div id="commRateHistoryTable"></div>
	</div>
	<center><input type="button" class="button" value="Return" id="btnReturn" style="margin-top: 8px; width: 100px;" tabindex="309"/></center>
</div>

<script type="text/javascript">
	newFormInstance();
	var objHistory = {};
	objHistory.commRateHist = JSON.parse('${historyJSON}');
	
	var historyModel = {
		url: contextPath + "/GIISIntmSpecialRateController?action=showHistory&refresh=1"+
							"&intmNo="+$F("txtIntmNo")+"&issCd="+$F("txtIssCd")+
							"&lineCd="+$F("txtLineCd")+"&sublineCd="+$F("txtSublineCd"),
		options : {
			width : '775px',
			height: '255px',
			pager : {},
			onCellFocus : function(element, value, x, y, id){
				historyTG.keys.removeFocus(historyTG.keys._nCurrentFocus, true);
				historyTG.keys.releaseKeys();
			},
			onRemoveRowFocus : function(){
				historyTG.keys.removeFocus(historyTG.keys._nCurrentFocus, true);
				historyTG.keys.releaseKeys();
			},					
			toolbar : {
				elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
				onFilter: function(){
					historyTG.keys.removeFocus(historyTG.keys._nCurrentFocus, true);
					historyTG.keys.releaseKeys();
				}
			}
		},
		columnModel : [
			{
			    id: 'recordStatus',
			    width: '0',				    
			    visible : false			
			},
			{
				id : 'divCtrId',
				width : '0',
				visible : false
			},
			{	id: 'overrideTag',
				title: '&#160;O',
            	width: '23px',
            	altTitle: 'Override Tag',
            	titleAlign: 'center',
            	editable: false,
            	filterOption: true,
            	filterOptionType: "checkbox",
            	editor: new MyTableGrid.CellCheckbox({
		            getValueOf: function(value){
		            	return value ? "Y" : "N";
	            	}
            	})
			},
			{
				id : 'effDate',
				title : "Effectivity Date",
				align : 'center',
				width : '105px',
				filterOption: true,
				filterOptionType: "formattedDate"
			},
			{
				id : 'expiryDate',
				title : "Expiry Date",
				align : 'center',
				width : '105px',
				filterOption: true,
				filterOptionType: "formattedDate"
			},	
			{
				id : "perilName",
				title : "Peril",
				filterOption : true,
				width : '265px'
			},
			{
				id : "oldCommRate",
				title : "Old Comm Rt.",
				width : '120px',
				align : 'right',
				titleAlign : 'right',
				filterOption : true,
				filterOptionType : 'numberNoNegative',
				renderer : function(value){
					return formatToNthDecimal(value, 7);
				}
			},
			{
				id : "newCommRate",
				title : "New Comm Rt.",
				width : '120px',
				align : 'right',
				titleAlign : 'right',
				filterOption : true,
				filterOptionType : 'numberNoNegative',
				renderer : function(value){
					return formatToNthDecimal(value, 7);
				}
			}
		],
		rows : objHistory.commRateHist.rows
	};
	historyTG = new MyTableGrid(historyModel);
	historyTG.pager = objHistory.commRateHist;
	historyTG.render("commRateHistoryTable");
	
	function newFormInstance(){
		$("txtIntmNo").focus();
		
		$("txtIntmNo").value = $F("intmNo");
		$("txtIntmName").value = $F("intmName");
		$("txtIssCd").value = $F("issCd");
		$("txtIssName").value = $F("issName");
		$("txtLineCd").value = $F("lineCd");
		$("txtLineName").value = $F("lineName");
		$("txtSublineCd").value = $F("sublineCd");
		$("txtSublineName").value = $F("sublineName");
	}
	
	$("btnReturn").observe("click", function(){
		historyOverlay.close();
		delete historyOverlay;
	});
</script>