<div id="giacAcctTransHeaderDiv" name="giclAcctTransHeaderDiv" style="margin-top: 10px;">
	<div id="giacAcctTransListTableGridDiv" name="giacAcctTransListTableGridDiv" style="margin: 10px;">
		<div id="giacAcctTransListTableGrid" style="height: 180px;"></div>
	</div>
</div>
<div id="acctEntriesDiv"></div>
<input id="selectedTranId" type="hidden" value="0"/>
<input id="selectedBranchCd" type="hidden"/>
<script>
	initializeAll();
	initializeAllMoneyFields();
	try{
		var objAcctTransTG = JSON.parse('${acctTransTG}'.replace(/\\n/g, "&#10").replace(/\\/g, ""));//replace enter  by MAC 11/12/2013
		var acctTransIndex = null;
		var acctTransTable = {
			url: contextPath+"/GIACBatchDVController?action=getGIACS086AcctTransTableGrid&refresh=1&ajax=1&batchDvId="+objGICLBatchDv.batchDvId,
			options: {
				title: '',
				onCellFocus: function(element, value, x, y, id) {
					acctTransIndex = y;
					var rec = acctTransGrid.getRow(y);
					$("selectedTranId").value = rec.tranId;
					$("selectedBranchCd").value = rec.branchCd;
					/*acctEntriesTableGrid.url = contextPath+"/GIACBatchDVController?action=getGIACS086AcctEntriesTableGrid&refresh=1&tranId="+nvl($F("selectedTranId"), 0);
					acctEntriesTableGrid._refreshList();*/
					retrieveAcctEntries();
				},onRemoveRowFocus : function(element, value, x, y, id){
					acctTransIndex = null;
					$("selectedTranId").value = 0;
					acctEntriesTableGrid.url = contextPath+"/GIACBatchDVController?action=getGIACS086AcctEntriesTableGrid&refresh=1&tranId="+nvl($F("selectedTranId"), 0);
					acctEntriesTableGrid._refreshList();
			  	}, 
			  	toolbar: {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
				}
			}, columnModel : [ 
				{   
					id: 'recordStatus',
				    width: '0',
				    visible: false,
				    editor: 'checkbox' 			
				},
				{	
					id: 'divCtrId',
					width: '0',
					visible: false
				},{
					id: 'branchCd',
					title: 'Branch',
				  	width: '50',
				  	filterOption: true
			 	},{
					id: 'refNo',
					title: 'Reference No.',
				  	width: '200',
				  	filterOption: true
			 	},{
					id: 'particulars',
					title: 'Particulars',
				  	width: '380',
				  	filterOption: true,
				  	renderer: function(value){//added to unescape HTML characters by MAC 11/12/2013.
				  		return unescapeHTML2(value);
				  	}
			 	},{
					id: 'tranId',
					title: '',
				  	width: '0',
				  	visible: false
			 	},{
					id: 'batchDvId',
					title: '',
				  	width: '0',
				  	visible: false
			 	}                    
			],
			rows: objAcctTransTG.rows	
		};
		acctTransGrid = new MyTableGrid(acctTransTable);
		acctTransGrid.pager = objAcctTransTG;
		acctTransGrid.render('giacAcctTransListTableGrid');
	}catch(e){
		showErrorMessage("acctrans table grid.",e);
	}
	
	function retrieveAcctEntries(){
		try{
			new Ajax.Updater("acctEntriesDiv",contextPath+"/GIACBatchDVController",{
				method: "GET",
				parameters: {
					action: "getGIACS086AcctEntriesTableGrid",
					tranId: $F("selectedTranId"),
					branchCd : $F("selectedBranchCd")
				},
				evalScripts: true,
				asynchronous: false
			});
		}catch(e){
			showErrorMessage("retrieveAcctEntries",e);
		}
	}
	
	retrieveAcctEntries();
</script>