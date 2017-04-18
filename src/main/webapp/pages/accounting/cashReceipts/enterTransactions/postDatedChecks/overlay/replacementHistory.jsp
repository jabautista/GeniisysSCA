<div class="sectionDiv" style="width: 600px;">
	<div id="taxRateHistoryTableDiv" style="padding-top: 10px; padding-bottom: 10px">
		<div id="repHistoryTable" style="height: 311px; padding-left: 10px;"></div>
	</div>
</div>
<div align="center">
	<input type="button" class="button" value="Return" id="btnReturn" style="margin-top: 10px; width: 100px;" />
</div>
<script type="text/javascript">	
	$("btnReturn").observe("click", function(){
		overlayReplacementHistory.close();
		delete overlayReplacementHistory;
	});
	
	var repHistory = JSON.parse('${jsonRecList}');
	var params = JSON.parse('${object}');	
	
	repHistoryTable = {
			url : contextPath+"/GIACPdcChecksController?action=showReplacementHistory&refresh=1&fundCd="+params.fundCd+"&branchCd="+params.branchCd+"&gaccTranId="+params.gaccTranId+"&itemNo="+params.itemNo,
			options: {
				width: '580px',
				pager: {
				},
				onCellFocus : function(element, value, x, y, id) {
					tbgRepHistory.keys.removeFocus(tbgRepHistory.keys._nCurrentFocus, true);
					tbgRepHistory.keys.releaseKeys();
				},
				prePager: function(){
					tbgRepHistory.keys.removeFocus(tbgRepHistory.keys._nCurrentFocus, true);
					tbgRepHistory.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id){					
					tbgRepHistory.keys.removeFocus(tbgRepHistory.keys._nCurrentFocus, true);
					tbgRepHistory.keys.releaseKeys();
				},
				onSort : function(){
					tbgRepHistory.keys.removeFocus(tbgRepHistory.keys._nCurrentFocus, true);
					tbgRepHistory.keys.releaseKeys();	
				},
				onRefresh : function(){
					tbgRepHistory.keys.removeFocus(tbgRepHistory.keys._nCurrentFocus, true);
					tbgRepHistory.keys.releaseKeys();
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
						title: "History ID",
						width: '80px'
						
					},
					{
						id : "newPayMode", 
						title: "New Pay Mode",
						width: '100px'
					},
					{
						id : "oldAmount", 
						title: "Old Amount",
						width: '90px',
						geniisysClass : 'money',
						align : "right",
						titleAlign : "right",
					},
					{
						id : "newAmount", 
						title: "New Amount",
						width: '90px',
						geniisysClass : 'money',
						align : "right",
						titleAlign : "right",
					},
					{
						id : "overrideUser", 
						title: "Override User",
						width: '100px'
					},
					{
						id : "lastUpdate",
						title: "Last Update",
						width: '80px',
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
					}
			],
			rows: repHistory.rows || []
		};
	
	tbgRepHistory = new MyTableGrid(repHistoryTable);
	tbgRepHistory.pager = repHistory;
	tbgRepHistory.render('repHistoryTable');
</script>