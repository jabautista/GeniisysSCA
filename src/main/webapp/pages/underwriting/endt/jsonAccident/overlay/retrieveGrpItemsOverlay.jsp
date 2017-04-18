<div id="retrieveGrpItemsMainDiv">
	<div id="retGrpItemsTGDiv" style="height: 265px; width: 430px; float: left; margin: 10px 0 0 5px;">
		
	</div>
	<div id="radioButtonsDiv" style="height: 245px; width: 200px; float: left; margin: 10px 0 0 0;" class="sectionDiv">
		<table>
			<tr>
				<td>
					<div style="padding: 15px 0 15px 0">
						<input type="radio" id="selectedGrp" name="grpItemsGroup" value="selected" style="margin: 0 5px 0 5px; float: left;">
						<label for="selectedGrp">Selected Grouped Items</label>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div style="padding: 10px 0 20px 0">
						<input type="radio" id="allGrp" name="grpItemsGroup" value="all" style="margin: 0 5px 0 5px; float: left;">
						<label for="allGrp">All Grouped Items</label>
					</div>
				</td>
			</tr>
		</table>
	</div>
	<div id="buttonsDiv" align="center" style="float: left; height: inherit; width: 100%;">
		<input id="btnOkRetrieve" type="button" class="button" value="Ok">
		<input id="btnCancelRetrieve" type="button" class="button" value="Cancel">
	</div>
</div>

<script type="text/javascript">
	var noOfPersons = 0;
	var objRetGrpItems = new Object();
	objRetGrpItems.objRetGrpItemsTableGrid = JSON.parse('${retrievedGrpTGJson}');
	objRetGrpItems.objRetGrpItemsRows = objRetGrpItems.objRetGrpItemsTableGrid.rows || [];
	objRetGrpItems.retGrpItems = [];
	
	try{
		var retrievedGrpItemsTableModel = {
			url: contextPath+"/GIPIWGroupedItemsController?action=showRetrieveGrpItemsOverlay&refresh=1&parId="+objGroupedItems.vars.parId+
					"&lineCd="+objGroupedItems.vars.lineCd+"&sublineCd="+objGroupedItems.vars.sublineCd+"&issCd="+objGroupedItems.vars.issCd+
					"&issueYy="+objGroupedItems.vars.issueYy+"&polSeqNo="+objGroupedItems.vars.polSeqNo+"&renewNo="+objGroupedItems.vars.renewNo+
					"&itemNo="+objGroupedItems.vars.itemNo+"&effDate="+objGroupedItems.vars.effDate,
			options: {
				id: 6,
	          	height: '225px',
	          	width: '415px',
	            toolbar: {
	            	elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
	            	onRefresh: function(){
	            		$("selectedGrp").checked = false;
	            		$("allGrp").checked = false;
	            	},
	            	onFilter: function(){
	            		$("selectedGrp").checked = false;
	            		$("allGrp").checked = false;
	            	}
	            }
			},
			columnModel:[
				{   id: 'recordStatus',
				    width: '0px',
				    visible: false,
				    editor: 'checkbox'
				},
				{	id: 'divCtrId',
					width: '0px',
					visible: false
				},
				{	id:			'',
					sortable:	false,
					align:		'center',
					title:		'',
					width:		'25px',
					editable:  true,
					hideSelectAllBox: true,
					editor: new MyTableGrid.CellCheckbox({
			            getValueOf: function(value){
		            		if (value){
								return "Y";
		            		}else{
								return "N";	
		            		}
		            	},
		            	onClick: function(value, checked) {
		            		validateCheckedRows(checked);
	 			    	}
		            })
				},
				{	id: 'groupedItemNo',
					width: '98px',
					title: 'Enrollee Code',
					filterOption: true,
					sortable: false,
					filterOptionType: 'integerNoNegative'
				},
				{	id: 'groupedItemTitle',
					width: '280px',
					title: 'Enrollee Name',
					filterOption: true,
					sortable: false
				}
			],
			rows: objRetGrpItems.objRetGrpItemsRows
		};
		retGrpItemsTableGrid = new MyTableGrid(retrievedGrpItemsTableModel);
		retGrpItemsTableGrid.pager = objRetGrpItems.objRetGrpItemsTableGrid;
		retGrpItemsTableGrid.render("retGrpItemsTGDiv");
	}catch(e){
		showErrorMessage("Error in Retrieved Grouped Items TableGrid", e);
	}
	
	$("selectedGrp").observe("click", function(){
		for(var i = 0; i < retGrpItemsTableGrid.geniisysRows.length; i++){
			$("mtgInput"+retGrpItemsTableGrid._mtgId+"_2,"+i).checked = false;	
		}
	});
	
	$("allGrp").observe("click", function(){
		for(var i = 0; i < retGrpItemsTableGrid.geniisysRows.length; i++){
			$("mtgInput"+retGrpItemsTableGrid._mtgId+"_2,"+i).checked = true;	
		}
	});
	
	$("btnCancelRetrieve").observe("click", function(){
		retrieveGrpItemsOverlay.close();
	});
	
	$("btnOkRetrieve").observe("click", function(){
		if(checkSelectedRow()){
			$("allGrp").checked ? checkNoOfPersonsRet("Y") : prepareGrpItems();
		}else{
			showMessageBox("Please select Enrollee(s) to retrieve.", "I");
		}
	});
	
	function checkSelectedRow(){
		for(var i = 0; i < retGrpItemsTableGrid.geniisysRows.length; i++){
			if($("mtgInput"+retGrpItemsTableGrid._mtgId+"_2,"+i).checked){
				return true;
			}
		}
		return false;
	}
	
	function validateCheckedRows(checked){
		var checkedExists = false;
		for(var i = 0; i < retGrpItemsTableGrid.geniisysRows.length; i++){
			if($("mtgInput"+retGrpItemsTableGrid._mtgId+"_2,"+i).checked){
				checkedExists = true;
			}
		}
		if((!checked && checkedExists) || checked){
			$("selectedGrp").checked = true;
		}
	}
	
	function prepareGrpItems(){
		noOfPersons = parseInt(groupedItemsTableGrid.pager.total);
		var objRow = "";
		for(var i = 0; i < retGrpItemsTableGrid.geniisysRows.length; i++){
			if($("mtgInput"+retGrpItemsTableGrid._mtgId+"_2,"+i).checked){
				objRow = setRetrievedGrpItems(i);
				objRetGrpItems.retGrpItems.push(objRow);
				noOfPersons = parseInt(noOfPersons) + 1;
			}
		}
		checkNoOfPersonsRet("N");
	}
	
	function setRetrievedGrpItems(y){
		var obj = new Object();
		obj.parId = objGroupedItems.vars.parId;
		obj.lineCd = objGroupedItems.vars.lineCd;
		obj.sublineCd = objGroupedItems.vars.sublineCd;
		obj.issCd = objGroupedItems.vars.issCd;
		obj.issueYy = objGroupedItems.vars.issueYy;
		obj.polSeqNo = objGroupedItems.vars.polSeqNo;
		obj.renewNo = objGroupedItems.vars.renewNo;
		obj.itemNo = objGroupedItems.vars.itemNo;
		obj.effDate = objGroupedItems.vars.effDate;
		obj.groupedItemNo = retGrpItemsTableGrid.geniisysRows[y].groupedItemNo;
		obj.groupedItemTitle = retGrpItemsTableGrid.geniisysRows[y].groupedItemTitle;
		obj.controlCd = retGrpItemsTableGrid.geniisysRows[y].controlCd;
		obj.controlTypeCd = retGrpItemsTableGrid.geniisysRows[y].controlTypeCd;
		return obj;
	}
	
	function checkNoOfPersonsRet(insertAll){
		if(insertAll == "Y"){
			noOfPersons = parseInt(groupedItemsTableGrid.pager.total) + parseInt(retGrpItemsTableGrid.pager.total);
		}
		
		if((parseInt(objGroupedItems.vars.noOfPersons) != parseInt(noOfPersons)) && (parseInt(noOfPersons) > 1)){
			showConfirmBox("Confirmation", "Saving changes will update the No. of Persons, " +
					"do you want to continue?", "Yes", "No",
					function(){
						insertRetrievedGrpItems(insertAll, true); 
					}, "", "");
		}else{
			insertRetrievedGrpItems(insertAll, false);
		}
	}
	
	function insertRetrievedGrpItems(insertAll, changeNo){
		var objParams = new Object();
		objParams.setRows = insertAll == "Y" ? [] : objRetGrpItems.retGrpItems;
		
		new Ajax.Request(contextPath + "/GIPIWGroupedItemsController?action=insertRetrievedGrpItems",{
			parameters : {
				parameters     : JSON.stringify(objParams),
				insertAll	   : insertAll,
				parId		   : objGroupedItems.vars.parId,
				lineCd		   : objGroupedItems.vars.lineCd,
				sublineCd	   : objGroupedItems.vars.sublineCd,
				issCd		   : objGroupedItems.vars.issCd,
				issueYy		   : objGroupedItems.vars.issueYy,
				polSeqNo	   : objGroupedItems.vars.polSeqNo,
				renewNo		   : objGroupedItems.vars.renewNo,
				itemNo		   : objGroupedItems.vars.itemNo,
				effDate		   : objGroupedItems.vars.effDate,
				noOfPersons    : changeNo ? noOfPersons : null,
				prorateFlag	   : objGroupedItems.vars.prorateFlag,
				compSw		   : objGroupedItems.vars.compSw,
				endtExpiryDate : objGroupedItems.vars.endtExpiryDate,
				shortRtPercent : objGroupedItems.vars.shortRtPct,
				endtTaxSw	   : objGroupedItems.vars.endtTaxSw,
				packLineCd	   : objGroupedItems.vars.packLineCd,
				packSublineCd  : objGroupedItems.vars.packSublineCd,
				parStatus	   : objGroupedItems.vars.parStatus,
				packPolFlag    : objGroupedItems.vars.packPolFlag
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : function(){
				showNotice("Retrieving Grouped Items, please wait...");
			},
			onComplete : function(response){
				hideNotice("");
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					showWaitingMessageBox("Grouped Items Retrieval Finished Successfully.", "I", function(){
						retrieveGrpItemsOverlay.close();
						groupedItemsOverlay.close();
						objUW.showEndtAccidentGroupedItemsOverlay();
					});
				}
			}
		});
	}
</script>