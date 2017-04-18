<div id="viewBankFilesMainDiv" name="viewBankFilesMainDiv" style="margin-top: 10px; margin-bottom: 5px; margin-left: 5px; margin-right: 5px;">
	<div id="tableDiv" class="sectionDiv" style="height: 320px;">
		<div id="viewBankFilesTableGridDiv" name="viewBankFilesTableGridDiv" style="margin-top: 10px; margin-left: 10px; height: 320px;"></div>
	</div>
	<div id="viewButtonsDiv" style="float: left; width: 100px; padding-left: 160px; margin-top: 10px;">
		<table align="center">
			<tr>
				<td><input type="button" class="button" id="btnViewRecordsViaBankFiles" name="btnViewRecordsViaBankFiles" value="View Records" style="width: 120px;" tabindex="201"/></td>
				<td><input type="button" class="button" id="btnReturnViewBankFiles" name="btnReturnViewBankFiles" value="Return" style="width: 120px;" tabindex="201"/></td>
			</tr>
		</table>
	</div>
</div>
<script type="text/javascript">
	var jsonBankFiles = JSON.parse('${jsonBankFilesList}');	
	bankFilesTableModel = {
			url : contextPath+"/GIACGeneralDisbursementReportsController?action=showViewBankFiles&refresh=1",
			options: {
				width: '530px',
				height: '300px',
				pager: {
				},
				onCellFocus : function(element, value, x, y, id) {
					objCurrBankFileNo = tbgBankFiles.geniisysRows[y].bankFileNo;
					tbgBankFiles.keys.removeFocus(tbgBankFiles.keys._nCurrentFocus, true);
					tbgBankFiles.keys.releaseKeys();
				},
				prePager: function(){
					objCurrBankFileNo = "";
					tbgBankFiles.keys.removeFocus(tbgBankFiles.keys._nCurrentFocus, true);
					tbgBankFiles.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id){	
					objCurrBankFileNo = "";
					tbgBankFiles.keys.removeFocus(tbgBankFiles.keys._nCurrentFocus, true);
					tbgBankFiles.keys.releaseKeys();
				},
				onSort : function(){
					objCurrBankFileNo = "";
					tbgBankFiles.keys.removeFocus(tbgBankFiles.keys._nCurrentFocus, true);
					tbgBankFiles.keys.releaseKeys();
				},
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onFilter: function(){
						objCurrBankFileNo = "";
						tbgBankFiles.keys.removeFocus(tbgBankFiles.keys._nCurrentFocus, true);
						tbgBankFiles.keys.releaseKeys();
					},
					onRefresh: function(){
						objCurrBankFileNo = "";
						tbgBankFiles.keys.removeFocus(tbgBankFiles.keys._nCurrentFocus, true);
						tbgBankFiles.keys.releaseKeys();
					}
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
				{	id: 'paidSw',
					altTitle: 'Paid Sw',
					titleAlign: 'center',
					width: '25px',
					visible: true,
					sortable: false,
					defaultValue: false,
					otherValue: false,
			    	editor: new MyTableGrid.CellCheckbox({
				        getValueOf: function(value){
				        	if (value){
								return "I";
			            	}else{
								return "N";	
			            	}
				        }
			    	})
				},				
				{
					id : "bankFileNo",
					title: "Bank File No",
					width: '110px',
					sortable: true,
					filterOption: true,
					filterOptionType: 'integerNoNegative',
					align : 'right',
					titleAlign : 'right',
					renderer : function(value) {
						return value == '' ? '' : formatNumberDigits(value,10); 
					}
				},
				{
					id : "bankFileName",
					title: "Bank File Name",
					width: '210px',
					titleAlign: 'left',
					align: 'left',
					sortable: true,
					filterOption: true
				},
				{
					id : "extractDate",
					title: "Extract Date",
					width: '150px',
					titleAlign: 'left',
					align: 'left',
					sortable: true,
					filterOption: true
				}
			],
			rows: jsonBankFiles.rows
		};
	
	tbgBankFiles = new MyTableGrid(bankFilesTableModel);
	tbgBankFiles.pager = jsonBankFiles;
	tbgBankFiles.render('viewBankFilesTableGridDiv');

	function showViewRecordsViaBankFiles(){
		overlayViewRecords = Overlay.show(contextPath + "/GIACGeneralDisbursementReportsController", {
			urlContent : true,
			urlParameters : {action : "viewRecordsViaBankFile",
				bankFileNo: objCurrBankFileNo
			},
			title : 'View Records',
			height : '450px',
			width : '760px',
			draggable : true
		});		
	}
	
	$("btnViewRecordsViaBankFiles").observe("click", function() {
		if (objCurrBankFileNo != "") {
			showViewRecordsViaBankFiles();
		}else {
			showMessageBox("Please select a record first.", imgMessage.INFO);
		}
	});
	
	$("btnReturnViewBankFiles").observe("click", function() {
		overlayViewBankFiles.close();
	});
	
</script>