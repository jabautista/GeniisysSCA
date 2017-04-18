<div id="slidingCommHistory" style="width: 99.5%; margin-top: 5px;">
	<div class="sectionDiv">
		<table style="margin: 10px auto;">
			<tr>
				<td class="rightAligned" id="">Line</td>
				<td class="leftAligned">
					<input readonly="readonly" type="text" id="txtLineCd" name="txtLineCd" style="width: 75px; float: left; height: 13px; margin-left: 3px;" tabindex="201"/>
				</td>
				<td class="leftAligned">
					<input id="txtLineName" name="txtLineName" type="text" style="width: 350px; height: 13px;" readonly="readonly" tabindex="202"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" id="">Subline</td>
				<td class="leftAligned">
					<input readonly="readonly" type="text" id="txtSublineCd" name="txtSublineCd" style="width: 75px; float: left; height: 13px; margin-left: 3px;" tabindex="203"/>
				</td>
				<td class="leftAligned">
					<input id="txtSublineName" name="txtSublineName" type="text" style="width: 350px; height: 13px;" readonly="readonly" tabindex="204"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" id="">Peril</td>
				<td class="leftAligned">
					<input readonly="readonly" type="text" id="txtPerilCd" name="txtPerilCd" style="width: 75px; float: left; height: 13px; margin-left: 3px;" tabindex="205"/>
				</td>
				<td class="leftAligned">
					<input id="txtPerilName" name="txtPerilName" type="text" style="width: 350px; height: 13px;" readonly="readonly" tabindex="206"/>
				</td>
			</tr>
		</table>
	</div>
	
	<div class="sectionDiv" style="padding: 10px 0 10px 10px; height: 295px; width: 98.78%">
		<div id="slidingCommHistoryTable" style="height: 259px;"></div>
		
		<div align="center" style="float: left; margin-left: 90px;">
			<table style="margin-top: 5px;">
				<tr>
					<td class="rightAligned">User ID</td>
					<td class="leftAligned"><input id="txtUserId" type="text" style="width: 200px; margin-right: 20px; margin-left: 3px;" readonly="readonly" tabindex="208"></td>
					<td width="" class="rightAligned">Last Update</td>
					<td class="leftAligned"><input id="txtLastUpdate" type="text" style="width: 200px; margin-left: 3px;" readonly="readonly" tabindex="209"></td>
				</tr>
			</table>
		</div>
	</div>
	
	<center><input type="button" class="button" value="Return" id="btnReturn" style="margin-top: 10px; width: 100px;" tabindex="210"/></center>
</div>

<script type="text/javascript">
	var perilCd = '${perilCd}';
	var objHistory = {};
	objHistory.slidingCommHist = JSON.parse('${historyJSON}');

	var historyModel = {
		url: contextPath + "/GIISSlidCommController?action=showHistory&refresh=1"+
							"&lineCd="+encodeURIComponent($F("lineCd"))+"&sublineCd="+encodeURIComponent($F("sublineCd"))+"&perilCd="+perilCd,
		options : {
			width : '775px',
			height: '255px',
			pager : {},
			onCellFocus : function(element, value, x, y, id){
				setHistoryFieldValues(historyTG.geniisysRows[y]);
				historyTG.keys.removeFocus(historyTG.keys._nCurrentFocus, true);
				historyTG.keys.releaseKeys();
			},
			onRemoveRowFocus : function(){
				setHistoryFieldValues(null);
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
			{
				id : "oldLoPremLim",
				title : "Old Lo Prem",
				width : '115px',
				align : 'right',
				titleAlign : 'right',
				filterOption : true,
				filterOptionType : 'numberNoNegative',
				renderer : function(value){
					return formatToNineDecimal(value);
				}
			},
			{
				id : "loPremLim",
				title : "Lo Prem Limit",
				width : '115px',
				align : 'right',
				titleAlign : 'right',
				filterOption : true,
				filterOptionType : 'numberNoNegative',
				renderer : function(value){
					return formatToNineDecimal(value);
				}
			},
			{
				id : "oldHiPremLim",
				title : "Old Hi Prem",
				width : '115px',
				align : 'right',
				titleAlign : 'right',
				filterOption : true,
				filterOptionType : 'numberNoNegative',
				renderer : function(value){
					return formatToNineDecimal(value);
				}
			},
			{
				id : "hiPremLim",
				title : "Hi Prem Limit",
				width : '115px',
				align : 'right',
				titleAlign : 'right',
				filterOption : true,
				filterOptionType : 'numberNoNegative',
				renderer : function(value){
					return formatToNineDecimal(value);
				}
			},
			{
				id : "oldSlidCommRt",
				title : "Old Slid Comm Rate",
				width : '140px',
				align : 'right',
				titleAlign : 'right',
				filterOption : true,
				filterOptionType : 'numberNoNegative',
				renderer : function(value){
					return formatToNineDecimal(value);
				}
			},
			{
				id : "slidCommRt",
				title : "Slid Comm Rate",
				width : '138px',
				align : 'right',
				titleAlign : 'right',
				filterOption : true,
				filterOptionType : 'numberNoNegative',
				renderer : function(value){
					return formatToNineDecimal(value);
				}
			}
		],
		rows : objHistory.slidingCommHist.rows
	};
	historyTG = new MyTableGrid(historyModel);
	historyTG.pager = objHistory.slidingCommHist;
	historyTG.render("slidingCommHistoryTable");
	historyTG.afterRender = function(){
		historyTG.onRemoveRowFocus();
	};
	
	function newFormInstance(){
		$("txtLineCd").value = unescapeHTML2($F("lineCd"));
		$("txtLineName").value = unescapeHTML2($F("lineName"));
		$("txtSublineCd").value = unescapeHTML2($F("sublineCd"));
		$("txtSublineName").value = unescapeHTML2($F("sublineName"));
		$("txtPerilCd").value = unescapeHTML2('${perilCd}');
		$("txtPerilName").value = unescapeHTML2('${perilName}');
		
		$("txtLineCd").focus();
		initializeAll();
	}
	
	function setHistoryFieldValues(rec){
		$("txtUserId").value = rec == null ? "" : unescapeHTML2(rec.userId);
		$("txtLastUpdate").value = rec == null ? "" : rec.lastUpdate;
	}
	
	$("btnReturn").observe("click", function(){
		historyOverlay.close();
		delete historyOverlay;
	});
	
	newFormInstance();
</script>