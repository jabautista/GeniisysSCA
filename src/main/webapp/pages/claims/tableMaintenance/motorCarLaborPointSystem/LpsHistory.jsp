<div class="sectionDiv" style="width: 797px; margin-top: 3px;">
	<table align="center" style="margin: 15px auto;">
		<tr>
			<td><label for="txtLossExpCd2" style="float: right; margin-right: 5px;">Vehicle Part</label></td>
			<td>
				<input type="text" id="txtLossExpCd2" style="width: 70px;" readonly="readonly"/>
				<input type="text" id="txtLossExpDesc2" style="width: 447px;" readonly="readonly"/>
			</td>
		</tr>
	</table>
</div>
<div class="sectionDiv" style="width: 797px; margin-top: 2px;">
	<div style="padding: 10px 0 10px 10px; width: 777px; height: 170px;">
		<div id="lpsHistoryTable" style="height: 156px; margin-left: auto;"></div>
	</div>
	<table align="center" style="margin-top: 10px;">
		<tr>
			<td><label for="txtRemarks2" style="float: right; margin-right: 5px;">Remarks</label></td>
			<td>
				<div id="remarks2Div" name="remarks2Div" style="float: left; width: 535px; border: 1px solid gray; height: 22px;">
					<textarea ignoreDelKey="true" style="float: left; height: 16px; width: 509px; margin-top: 0; border: none;" id="txtRemarks2" name="txtRemarks2" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="204" readonly="readonly"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks2"  tabindex="205"/>
				</div>
			</td>
		</tr>
	</table>
	<div style="text-align: center">
		<input type="button" class="button" id="btnReturn" value="Return" style="width: 100px; margin: 10px auto;"/>
	</div>
</div>
<script type="text/javascript">
	try {
		
		$("txtLossExpCd2").value = unescapeHTML2($F("txtLossExpCd"));
		$("txtLossExpDesc2").value = unescapeHTML2($F("txtLossExpDesc"));
		
		$("editRemarks2").observe("click", function(){
			showOverlayEditor("txtRemarks2", 4000, $("txtRemarks2").hasAttribute("readonly"));
		});
		
		var jsonLpsHistory = JSON.parse('${jsonLpsHistory}');	
		lpsHistoryTableModel = {
			id  : "lpsHistory",	
			url : contextPath+"/GICLMcLpsController?action=showGicls171LpsHistory&refresh=1&lossExpCd=" + encodeURIComponent($F("txtLossExpCd2")),
			options: {
				width: 777,
				onCellFocus : function(element, value, x, y, id) {
					//setHistoryDetails(tbgLpsHistory.geniisysRows[y]);
					$("txtRemarks2").value = unescapeHTML2(tbgLpsHistory.geniisysRows[y].remarks);
					tbgLpsHistory.keys.removeFocus(tbgLpsHistory.keys._nCurrentFocus, true);
					tbgLpsHistory.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id){
					tbgLpsHistory.keys.removeFocus(tbgLpsHistory.keys._nCurrentFocus, true);
					tbgLpsHistory.keys.releaseKeys();
					$("txtRemarks2").clear();
					//setHistoryDetails(null);
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
					id : "historyId",
					title: "History No.",
					width: 90,
					align: "right",
					titleAlign: "right",
					filterOption : true/* ,
					renderer: function(val){
						return formatNumberDigits(val, 4);
					} */
				},
				{
					id : "tinsmithLight",
					title: "Light",
					width: 110,
					align : "right",
					titleAlign : "right",
					geniisysClass : "money"
				},
				{
					id : "tinsmithMedium",
					title: "Medium",
					width: 110,
					align : "right",
					titleAlign : "right",
					geniisysClass : "money"
				},
				{
					id : "tinsmithHeavy",
					title: "Heavy",
					width: 110,
					align : "right",
					titleAlign : "right",
					geniisysClass : "money"
				},
				{
					id : "painting",
					title: "Painting",
					width: 110,
					align : "right",
					titleAlign : "right",
					geniisysClass : "money"
				},
				{
					id: "userId",
					title: "User ID",
					width: 90
				},
				{
					id: "lastUpdate",
					title: "Last Update",
					width: 137,
					align: "center",
					titleAlign: "center"
				}
			],
			rows: jsonLpsHistory.rows
		};
	
		tbgLpsHistory = new MyTableGrid(lpsHistoryTableModel);
		tbgLpsHistory.pager = jsonLpsHistory;
		tbgLpsHistory.render('lpsHistoryTable');
		tbgLpsHistory.afterRender = function(){
			$("txtRemarks2").clear();
		};
		
		$("btnReturn").observe("click", function(){
			overlayLpsHistory.close();
			delete overlayLpsHistory;
		});
		
		initializeAll();
	} catch (e) {
		showErrorMessage("LPS History", e);
	}
</script>