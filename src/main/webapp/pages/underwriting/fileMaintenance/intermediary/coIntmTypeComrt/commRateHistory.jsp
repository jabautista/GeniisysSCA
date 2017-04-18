<div id="commRateHistory" style="width: 99.5%; margin-top: 5px;">
    <div class="sectionDiv" id="historyHeaderDiv">
   		<div style="" align="center" id="lovDiv">
			<table cellspacing="2" border="0" style="margin: 10px auto;">
				<tr>
					<td class="rightAligned" style="" id="">Issuing Source</td>
					<td class="leftAligned" colspan="3">
						<span class="lovSpan" style="float: left; width: 65px; margin-right: 5px; margin-top: 2px; height: 21px;">
							<input readonly="readonly" type="text" id="txtHistDspIssCd" name="txtHistDspIssCd" value="${issCd}" style="width: 40px; float: left; border: none; height: 15px; margin: 0;" maxlength="4" tabindex="401" lastValidValue=""/>
						</span>
						<input id="txtHistDspIssName" name="txtHistDspIssName" type="text" style="width: 195px;" value="${issName}" readonly="readonly" tabindex="402"/>
					</td>
					<td class="rightAligned" style="width: 140px;" id="">Co-Intermediary Type</td>
					<td class="leftAligned" colspan="3">
						<span class="lovSpan" style="float: left; width: 65px; margin-right: 5px; margin-top: 2px; height: 21px;">
							<input readonly="readonly" type="text" id="txtHistDspCoIntmType" name="txtHistDspCoIntmType" value="${coIntmType}" style="width: 40px; float: left; border: none; height: 15px; margin: 0;" maxlength="5" tabindex="403" lastValidValue=""/>
						</span>
						<input id="txtHistDspCoIntmName" name="txtHistDspCoIntmName" type="text" style="width: 195px;" value="${coIntmName}" readonly="readonly" tabindex="404"/>
					</td>
				</tr>	
				<tr>
					<td class="rightAligned" style="" id="">Line</td>
					<td class="leftAligned" colspan="3">
						<span class="lovSpan" style="float: left; width: 65px; margin-right: 5px; margin-top: 2px; height: 21px;">
							<input readonly="readonly" type="text" id="txtHistDspLineCd" name="txtHistDspLineCd" value="${lineCd}" style="width: 40px; float: left; border: none; height: 15px; margin: 0;" maxlength="4" tabindex="405" lastValidValue=""/>
						</span>
						<input id="txtHistDspLineName" name="txtHistDspLineName" type="text" style="width: 195px;" value="${lineName}" readonly="readonly" tabindex="406"/>
					</td>
					<td class="rightAligned" style="" id="">Subline</td>
					<td class="leftAligned" colspan="3">
						<span class="lovSpan" style="float: left; width: 65px; margin-right: 5px; margin-top: 2px; height: 21px;">
							<input readonly="readonly" type="text" id="txtHistDspSublineCd" name="txtHistDspSublineCd" value="${sublineCd}" style="width: 40px; float: left; border: none; height: 15px; margin: 0;" maxlength="4" tabindex="407" lastValidValue=""/>
						</span>
						<input id="txtHistDspSublineName" name="txtHistDspSublineName" type="text" style="width: 195px;" value="${sublineName}" readonly="readonly" tabindex="408"/>
					</td>
				</tr>
			</table>
		</div>
    </div>
	<div class="sectionDiv" style="padding: 10px 0 10px 10px; height: 255px; width: 98.78%">
		<div id="commRateHistoryTable"></div>
	</div>
	<center><input type="button" class="button" value="Return" id="btnReturn" style="margin-top: 5px; width: 100px;" /></center>
</div>
<script type="text/javascript">
	var objGIISS084Hist = {};
	objGIISS084Hist.commRateHist = JSON.parse('${jsonCommRateHistList}');
	
	var commRateHistTable = {
		url : contextPath + "/GIISIntmTypeComrtController?action=showCommRateHistoryOverlay&refresh=1&issCd=" + encodeURIComponent($F("txtHistDspIssCd")) + "&coIntmType=" + encodeURIComponent($F("txtHistDspCoIntmType"))
			+ "&lineCd=" + encodeURIComponent($F("txtHistDspLineCd")) + "&sublineCd=" + encodeURIComponent($F("txtHistDspSublineCd")),
		options : {
			width : '775px',
			height: '255px',
			hideColumnChildTitle: true,
			pager : {},
			onCellFocus : function(element, value, x, y, id){
				
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
				id : 'effDate',
				title : "Effectivity Date",
				align : 'center',
				titleAlign : 'center',
				filterOption: true,
				filterOptionType: 'formattedDate',
				width : '120px'
			},
			{
				id : 'expiryDate',
				title : "Expiry Date",
				align : 'center',
				titleAlign : 'center',
				filterOption: true,
				filterOptionType: 'formattedDate',
				width : '120px'
			},	
			{
				id : "dspPerilName",
				title : "Peril",
				filterOption : true,
				width : '225px'
			},
			{
				id : "oldCommRate",
				title : "Old Comm Rate",
				align : 'right',
				titleAlign : 'right',
				filterOption : true,
				filterOptionType : 'numberNoNegative',
				renderer : function(value){
					return formatToNthDecimal(value, 7);
				},
				width : '135px'
			},
			{
				id : "newCommRate",
				title : "New Comm Rate",
				align : 'right',
				titleAlign : 'right',
				filterOption : true,
				filterOptionType : 'numberNoNegative',
				renderer : function(value){
					return formatToNthDecimal(value, 7);
				},
				width : '135px'
			}
		],
		rows : objGIISS084Hist.commRateHist.rows
	};
	tbgCommRateHist = new MyTableGrid(commRateHistTable);
	tbgCommRateHist.pager = objGIISS084Hist.commRateHist;
	tbgCommRateHist.render("commRateHistoryTable");
	
	$("btnReturn").observe("click", function(){
		overlayCommRateHistory.close();
		delete overlayCommRateHistory;
	});
</script>