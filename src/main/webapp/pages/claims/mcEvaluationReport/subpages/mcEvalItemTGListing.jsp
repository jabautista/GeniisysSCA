<div id="mcEvalItemTGDiv" style="padding: 10px;">
	<div id="mcEvalItemTG" style="height: 200px; width: 900px;"></div>
</div>

<script type="text/javascript">

    var objMcEvalItemTG = JSON.parse('${mcEvalItemTg}'.replace(/\\/g, '\\\\'));
	
	var mcEvalItemTable = {
			id : 2,
			url: contextPath+"/GICLMcEvaluationController?action=getMcEvalItemTGList&refresh=1"+
			"&sublineCd="+nvl(mcMainObj.sublineCd,"")+ "&issCd="+nvl(mcMainObj.issCd,"")+
			"&clmYy="+nvl(mcMainObj.clmYy,"")+ "&clmSeqNo="+nvl(mcMainObj.clmSeqNo,""),
			options : {
				title : '',
				width : '890px',
				pager: {}, 
				hideColumnChildTitle: true,
				toolbar : {
					elements : [ MyTableGrid.REFRESH_BTN],
					onRefresh : function() {
						mcEvalItemGrid.keys.releaseKeys();
					}
				},
				onCellFocus : function(element, value, x, y, id) {
					mcEvalItemGrid.keys.removeFocus(mcEvalItemGrid.keys._nCurrentFocus, true);
					mcEvalItemGrid.keys.releaseKeys();
					mcMainObj = mcEvalItemGrid.geniisysRows[y];
					selectedItemInfo = y;
					populateItemFields(mcMainObj);
					getMcEvaluationTG(mcMainObj);
					reloadEvalTG();
					disableButton("btnAddItem");	
					//marco - 05.26.2015 - GENQA SR 4484
					disableSearch("textItemNoIcon");
					disableSearch("txtPerilCdIcon");
					disableSearch("txtPlateNoIcon");
				},
				onRemoveRowFocus : function() {
					mcEvalItemGrid.keys.removeFocus(mcEvalItemGrid.keys._nCurrentFocus, true);
					mcEvalItemGrid.keys.releaseKeys();
					populateItemFields(null);
					getMcEvaluationTG(null);
					reloadEvalTG();
					enableButton("btnAddItem");
					//marco - 05.26.2015 - GENQA SR 4484
					enableSearch("textItemNoIcon");
					enableSearch("txtPerilCdIcon");
					enableSearch("txtPlateNoIcon");
				},
				beforeSort : function(){
					if(changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}
				}
			},columnModel:[{
				id : 'recordStatus',
				title : '',
				width : '0',
				visible : false,
				editor : 'checkbox'
			},{
				id : 'divCtrId',
				width : '0',
				visible : false
			}, {
				id : 'itemNo dspItemDesc',
				title : 'Item',
				width : '300px',
				sortable : false,					
				children : [
					{
						id : 'itemNo',							
						width : 80,							
						sortable : false,
						editable : false,	
						align: 'right'
					},
					{
						id : 'dspItemDesc',							
						width : 255,
						sortable : false,
						editable : false
					}
				            ]					
			},	{
				id : 'perilCd dspPerilDesc',
				title : 'Peril',
				width : '300px',
				sortable : false,					
				children : [
					{
						id : 'perilCd',							
						width : 80,							
						sortable : false,
						editable : false,	
						align: 'right'
					},
					{
						id : 'dspPerilDesc',							
						width : 255,
						sortable : false,
						editable : false
					}
				            ]					
			}, {
				id : 'plateNo',
				title : 'Plate No.',
				width : '204',
				editable : false,
				filterOption : true
			}],
			resetChangeTag: true,
			rows : objMcEvalItemTG.rows
		};
	
	mcEvalItemGrid = new MyTableGrid(mcEvalItemTable);
	mcEvalItemGrid.pager = objMcEvalItemTG;
	mcEvalItemGrid.render('mcEvalItemTG'); 
	mcEvalItemGrid.afterRender = function(){
		objMcEvalItem = mcEvalItemGrid.geniisysRows;
		populateItemFields(null);
		getMcEvaluationTG(null);
		reloadEvalTG();
		enableButton("btnAddItem");
		//marco - 05.26.2015 - GENQA SR 4484
		enableSearch("textItemNoIcon");
		enableSearch("txtPerilCdIcon");
		enableSearch("txtPlateNoIcon");
	};
	
	
	function reloadEvalTG(){
		populateEvalSumFields(null);
		populateOtherDetailsFields(null);
		toggleButtons(null);
		toggleEditableOtherDetails(false);
		enableButton("btnAddReport");
		selectedMcEvalObj = null;
		$("editMode").value = "";
	}
</script>

