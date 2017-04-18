<div id="commRateHistory" style="width: 99.5%; margin-top: 5px;">
    <div class="sectionDiv" id="historyHeaderDiv">
   		<div style="" align="center" id="lovDiv">
			<table cellspacing="2" border="0" style="margin: 10px auto;">
				<tr>
					<td class="rightAligned" style="" id="">Issuing Source</td>
					<td class="leftAligned">
						<input readonly="readonly" type="text" id="txtHistDspIssCd" name="txtHistDspIssCd" style="width: 40px; float: left; height: 13px; margin: 0;"tabindex="401"/>
					</td>
					<td class="leftAligned">
						<input id="txtHistDspIssName" name="txtHistDspIssName" type="text" style="width: 200px; height: 13px;" value="" readonly="readonly" tabindex="402"/>
					</td>
					<td class="rightAligned" style="width: 140px;" id="">Intermediary Type</td>
					<td class="leftAligned">
						<input readonly="readonly" type="text" id="txtHistDspCoIntmType" name="txtHistDspCoIntmType" style="width: 40px; float: left; height: 13px; margin: 0;" tabindex="403"/>
					</td>
					<td class="leftAligned">
						<input id="txtHistDspCoIntmName" name="txtHistDspCoIntmName" type="text" style="width: 200px; height: 13px;" value="" readonly="readonly" tabindex="404"/>
					</td>
				</tr>	
				<tr>
					<td class="rightAligned" id="">Line</td>
					<td class="leftAligned">
						<input readonly="readonly" type="text" id="txtHistDspLineCd" name="txtHistDspLineCd" style="width: 40px; float: left; height: 13px; margin: 0;" tabindex="405"/>
					</td>
					<td class="leftAligned">
						<input id="txtHistDspLineName" name="txtHistDspLineName" type="text" style="width: 200px; height: 13px;" value="" readonly="readonly" tabindex="406"/>
					</td>
					<td class="rightAligned" id="">Subline</td>
					<td class="leftAligned">
						<input readonly="readonly" type="text" id="txtHistDspSublineCd" name="txtHistDspSublineCd" style="width: 40px; float: left; height: 13px; margin: 0;" tabindex="407"/>
					</td>
					<td class="leftAligned">
						<input id="txtHistDspSublineName" name="txtHistDspSublineName" type="text" style="width: 200px; height: 13px;" value="" readonly="readonly" tabindex="408"/>
					</td>
				</tr>
			</table>
		</div>
    </div>
	<div class="sectionDiv" style="padding: 10px 0 10px 10px; height: 255px; width: 98.78%">
		<div id="commRateHistoryTable"></div>
	</div>
	<center><input type="button" class="button" value="Return" id="btnReturn" style="margin-top: 8px; width: 100px;" /></center>
</div>


<script type="text/javascript">
	var objHistory = {};
	objHistory.commRateHist = JSON.parse('${jsonCommRate}');

	function newFormInstance(){
		$("txtHistDspIssCd").focus();
		
		$("txtHistDspIssCd").value = $F("issCd");
		$("txtHistDspIssName").value = $F("issName");
		$("txtHistDspCoIntmType").value = $F("intmType");
		$("txtHistDspCoIntmName").value = $F("intmName");
		$("txtHistDspLineCd").value = $F("lineCd");
		$("txtHistDspLineName").value = $F("lineName");
		$("txtHistDspSublineCd").value = $F("sublineCd");
		$("txtHistDspSublineName").value = $F("sublineName");
	}
	newFormInstance();
	
	var commRateHistTable = {
		url: contextPath + "/GIISIntmdryTypeRtController?action=showHistoryOverlay&refresh=1&"+
							"&issCd="+$F("txtHistDspIssCd")+"&intmType="+$F("txtHistDspCoIntmType")+
							"&lineCd="+$F("txtHistDspLineCd")+"&sublineCd="+$F("txtHistDspSublineCd"),
		options : {
			width : '775px',
			height: '255px',
			pager : {},
			onCellFocus : function(element, value, x, y, id){
				tbgCommRateHist.keys.removeFocus(tbgCommRateHist.keys._nCurrentFocus, true);
				tbgCommRateHist.keys.releaseKeys();
			},
			onRemoveRowFocus : function(){
				tbgCommRateHist.keys.removeFocus(tbgCommRateHist.keys._nCurrentFocus, true);
				tbgCommRateHist.keys.releaseKeys();
			},					
			toolbar : {
				elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
				onFilter: function(){
					tbgCommRateHist.keys.removeFocus(tbgCommRateHist.keys._nCurrentFocus, true);
					tbgCommRateHist.keys.releaseKeys();
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
			{
				id : 'dspEffDate',
				title : "Effectivity Date",
				align : 'center',
				width : '105px',
				filterOption: true,
				filterOptionType: 'formattedDate'
			},
			{
				id : 'dspExpiryDate',
				title : "Expiry Date",
				align : 'center',
				width : '105px',
				filterOption: true,
				filterOptionType: 'formattedDate'
			},	
			{
				id : "perilName",
				title : "Peril",
				filterOption : true,
				width : '265px'
			},
			{
				id : "oldCommRate",
				title : "Old Comm Rate",
				width : '133px',
				align : 'right',
				titleAlign : 'right',
				filterOption : true,
				filterOptionType : 'numberNoNegative',
				renderer : function(value){
					return formatToNthDecimal(value, 7);
				}
			}
			,
			{
				id : "newCommRate",
				title : "New Comm Rate",
				width : '133px',
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
	tbgCommRateHist = new MyTableGrid(commRateHistTable);
	tbgCommRateHist.pager = objHistory.commRateHist;
	tbgCommRateHist.render("commRateHistoryTable");
	
	$("btnReturn").observe("click", function(){
		giiss201HistoryOverlay.close();
		delete giiss201HistoryOverlay;
	});
</script>