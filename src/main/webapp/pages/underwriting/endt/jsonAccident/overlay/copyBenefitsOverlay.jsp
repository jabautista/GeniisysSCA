<div id="copyBenefitsMainDiv">
	<div id="copyBenTGDiv" style="height: 265px; width: 430px; float: left; margin: 10px 0 0 5px;">
		
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
		<input id="btnOkCopy" type="button" class="button" value="Ok">
		<input id="btnCancelCopy" type="button" class="button" value="Cancel">
	</div>
</div>

<script type="text/javascript">
	var objCopyBen = new Object();
	objCopyBen.copyBenTableGrid = JSON.parse('${copyBenTGJson}');
	objCopyBen.copyBenRows = objCopyBen.copyBenTableGrid.rows || [];
	objCopyBen.copyBen = [];

	try{
		var copyBenTableModel = {
			url: contextPath+"/GIPIWGroupedItemsController?action=showCopyBenefitsOverlay&refresh=1&parId="+objGroupedItems.vars.parId+
								"&itemNo="+objGroupedItems.vars.itemNo+"&groupedItemNo="+objGroupedItems.selectedRow.groupedItemNo,
			options: {
				id: 7,
	          	height: '225px',
	          	width: '415px',
	          	onCellFocus: function(element, value, x, y, id){
	
	            },
	            onRemoveRowFocus: function(){
					
	            },
	            beforeSort: function(){
	            	
	            },
	            onSort: function(){
	            	
	            },
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
					sortable: false,
					filterOption: true
				}
			],
			rows: objCopyBen.copyBenRows
		};
		copyBenTableGrid = new MyTableGrid(copyBenTableModel);
		copyBenTableGrid.pager = objCopyBen.copyBenTableGrid;
		copyBenTableGrid.render("copyBenTGDiv");
	}catch(e){
		showErrorMessage("Error in Copy Benefits TableGrid", e);
	}
	
	$("selectedGrp").observe("click", function(){
		for(var i = 0; i < copyBenTableGrid.geniisysRows.length; i++){
			$("mtgInput"+copyBenTableGrid._mtgId+"_2,"+i).checked = false;	
		}
	});
	
	$("allGrp").observe("click", function(){
		for(var i = 0; i < copyBenTableGrid.geniisysRows.length; i++){
			$("mtgInput"+copyBenTableGrid._mtgId+"_2,"+i).checked = true;
		}
	});
	
	$("btnOkCopy").observe("click", function(){
		$("allGrp").checked ? copyBenefits("Y") : prepareCopyBen();
	});
	
	$("btnCancelCopy").observe("click", function(){
		copyBenefitsOverlay.close();
	});
	
	function validateCheckedRows(checked){
		var checkedExists = false;
		for(var i = 0; i < copyBenTableGrid.geniisysRows.length; i++){
			if($("mtgInput"+copyBenTableGrid._mtgId+"_2,"+i).checked){
				checkedExists = true;
			}
		}
		if((!checked && checkedExists) || checked){
			$("selectedGrp").checked = true;
		}
	}
	
	function prepareCopyBen(){
		var objRow = "";
		for(var i = 0; i < copyBenTableGrid.geniisysRows.length; i++){
			if($("mtgInput"+copyBenTableGrid._mtgId+"_2,"+i).checked){
				objRow = setCopyBen(i);
				objCopyBen.copyBen.push(objRow);				
			}
		}
		copyBenefits("N");
	}
	
	function setCopyBen(y){
		var obj = new Object();
		obj.parId = objGroupedItems.vars.parId;
		obj.itemNo = objGroupedItems.vars.itemNo;
		obj.groupedItemNo = objGroupedItems.selectedRow.groupedItemNo;
		obj.packBenCd = objGroupedItems.selectedRow.packBenCd;
		obj.col1 = copyBenTableGrid.geniisysRows[y].groupedItemNo;
		obj.lineCd = objGroupedItems.vars.lineCd;
		return obj;
	}
	
	function copyBenefits(copyAll){
		var objParams = new Object();
		objParams.setRows = copyAll == "Y" ? [] : objCopyBen.copyBen;
		new Ajax.Request(contextPath + "/GIPIWGroupedItemsController?action=copyBenefits",{
			parameters : {
				parameters 	   : JSON.stringify(objParams),
				parId	   	   : objGroupedItems.vars.parId,
				itemNo		   : objGroupedItems.vars.itemNo,
				lineCd	       : objGroupedItems.vars.lineCd,
				sublineCd      : objGroupedItems.vars.sublineCd,
				issCd          : objGroupedItems.vars.issCd,
				issueYy        : objGroupedItems.vars.issueYy,
				polSeqNo       : objGroupedItems.vars.polSeqNo,
				renewNo        : objGroupedItems.vars.renewNo,
				effDate        : objGroupedItems.vars.effDate,
				itemNo     	   : objGroupedItems.vars.itemNo,
				groupedItemNo  : objGroupedItems.selectedRow.groupedItemNo,
				packBenCd	   : objGroupedItems.selectedRow.packBenCd,
				copyAll	   	   : copyAll,
				effDate 	   : objGroupedItems.vars.effDate,
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
				showNotice("Copying benefits, please wait...");
			},
			onComplete : function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					showWaitingMessageBox("Benefits successfully copied.", "I", function(){
						copyBenefitsOverlay.close();
						enrolleeOverlay.close();
						objGroupedItems.showEnrolleeCoverageOverlay();
					});
				}
			}
		});
	}
</script>