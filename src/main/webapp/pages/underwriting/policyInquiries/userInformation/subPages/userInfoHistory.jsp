<div id="userInfoHistoryMainDiv" name="userInfoHistoryMainDiv" style="height:400px;">
	<div id="userDetailDiv" name="userDetailDiv" class="sectionDiv" style="margin-top: 10px; width: 800px;">
		<table align="center" style="margin-top: 5px; margin-bottom: 5px;">
			<tr>
				<td class="rightAligned" style="padding-right: 3px;">User ID</td>
				<td class="leftAligned">
					<input type="text" id="txtHistUserId" name="txtHistUserId" class="text" readonly="readonly" style="width: 380px;" tabindex="901"/>
				</td>
			</tr>
		</table>
	</div>
	<div id="histTableDiv" class="sectionDiv" style="height: 320px; width: 800px;">
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
		$("txtHistUserId").value = selectedUser;
		$("txtHistUserId").focus();
		var objHist = new Object();
		objHist.objHistListing = JSON.parse('${jsonHistory}');
		objHist.histList = objHist.objHistListing.rows || [];
		var tbgHistory = {
				url: contextPath+"/GIPIPolbasicController?action=getHistoryList&refresh=1&userId="+selectedUser,
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
				{	id: 'histId',
					title: 'Hist',
					width: '60px',
					align: 'right',
					titleAlign: 'right',
					filterOption: true,
					filterOptionType: "integerNoNegative"
				},
				{
					id 			 : "oldUserGrp oldUserGrpDesc",
					title		 : "Old User Group",
					sortable	 : true,
					children	 : [
						{
							id : "oldUserGrp",
							title: 'Old User Group',
							width: 60,
							align: 'right',
							filterOption: true,
							filterOptionType: "integerNoNegative"
						}, {
							id : "oldUserGrpDesc",
							title: 'Old User Group Desc',
							width: 200,
							filterOption: true
						},
					]
				},
				{
					id 			 : "newUserGrp newUserGrpDesc",
					title		 : "New User Group",
					sortable	 : true,
					children	 : [
						{
							id : "newUserGrp",
							title: 'New User Group',
							width: 60,
							align: 'right',
							filterOption: true,
							filterOptionType: "integerNoNegative"
						}, {
							id : "newUserGrpDesc",
							title: 'New User Group Desc',
							width: 200,
							filterOption: true
						},
					]
				},
				{	id: 'histLastUpdate',
					title: 'Last Update',
					width: '160px',
					filterOption: true
				}
				],
			rows: objHist.histList
		};
		
		historyTableGrid = new MyTableGrid(tbgHistory);
		historyTableGrid.pager = objHist.objHistListing;
		historyTableGrid.render('historyTable');
		
	}catch (e) {
		showErrorMessage("historyTableGrid", e);
	}
	
	$("btnReturn").observe("click", function() {
		overlayHistory.close();
	});
	
</script>