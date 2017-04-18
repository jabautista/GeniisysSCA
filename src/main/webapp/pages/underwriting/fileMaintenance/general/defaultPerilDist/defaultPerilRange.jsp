<div id="rangeOverlayDiv">
	<div class="sectionDiv" style="margin-top: 5px; width: 99%;">
		<div style="padding-top: 10px;">
			<div id="defaultDistDtlTable" style="height: 210px; margin-left: 10px;"></div>
		</div>
		
		<div align="center" id="defaultDistDtlFormDiv">
			<table style="margin-top: 5px;">
				<tr>
					<td class="rightAligned">Range From</td>
					<td class="leftAligned">
						<input type="text" id="rangeFrom" class="required" style="width: 130px; float: left; height: 13px; margin-left: 3px; text-align: right;" tabindex="401"/>
					</td>
					<td class="rightAligned" style="width: 75px;">Range To</td>
					<td class="leftAligned">
						<input type="text" id="rangeTo" class="required" style="width: 130px; float: left; height: 13px; margin-left: 3px; text-align: right;" tabindex="402"/>
					</td>
				</tr>
			</table>
		</div>
		
		<div style="margin: 8px;" align="center">
			<input type="button" class="button" id="btnAddDtl" value="Add" style="width: 80px;" tabindex="403">
			<input type="button" class="disabledButton" id="btnDeleteDtl" value="Delete" style="width: 80px;" tabindex="404">
		</div>
	</div>
	
	<div style="float: left; margin: 8px 0 0 171px;" align="center">
		<input type="button" class="button" id="btnReturn" value="Return" style="width: 80px;" tabindex="405">
		<input type="button" class="button" id="btnSaveRange" value="Save" style="width: 80px;" tabindex="406">
	</div>
</div>

<script type="text/javascript">
	var dtlIndex = -1;
	var objRange = {};
	var selectedDtl = null;
	objRange.rangeList = JSON.parse('${rangeJSON}');
	
	var defDistDtlModel = {
		id: 102,
		url: contextPath + "/GIISDefaultDistController?action=showRangeOverlay&refresh=1&defaultNo="+$F("defaultNo"),
		options: {
			width: '485px',
			height: '207px',
			pager: {},
			onCellFocus: function(element, value, x, y, id){
				dtlIndex = y;
				selectedDtl = defDistDtlTG.geniisysRows[y];
				setRangeValues(selectedDtl);
				defDistDtlTG.keys.removeFocus(defDistDtlTG.keys._nCurrentFocus, true);
				defDistDtlTG.keys.releaseKeys();
			},
			onRemoveRowFocus: function(){
				dtlIndex = -1;
				setRangeValues(null);
				defDistDtlTG.keys.removeFocus(defDistDtlTG.keys._nCurrentFocus, true);
				defDistDtlTG.keys.releaseKeys();
			},
			toolbar: {
				elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
				onFilter: function(){
					defDistDtlTG.onRemoveRowFocus();
				}
			},
			beforeSort : function(){
				if(changeTag == 1){
					showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
						$("btnSave").focus();
					});
					return false;
				}
			},
			onSort: function(){
				defDistDtlTG.onRemoveRowFocus();
			},
			onRefresh: function(){
				defDistDtlTG.onRemoveRowFocus();
			},				
			prePager: function(){
				if(changeTag == 1){
					showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
						$("btnSave").focus();
					});
					return false;
				}
				defDistDtlTG.onRemoveRowFocus();
			},
			checkChanges: function(){
				return (changeTag == 1 ? true : false);
			},
			masterDetailRequireSaving: function(){
				return (changeTag == 1 ? true : false);
			},
			masterDetailValidation: function(){
				return (changeTag == 1 ? true : false);
			},
			masterDetail: function(){
				return (changeTag == 1 ? true : false);
			},
			masterDetailSaveFunc: function() {
				return (changeTag == 1 ? true : false);
			},
			masterDetailNoFunc: function(){
				return (changeTag == 1 ? true : false);
			}
		},
		columnModel : [
			{   id: 'recordStatus',
			    width: '0',				    
			    visible: false			
			},
			{	id: 'divCtrId',
				width: '0',
				visible: false
			},
			{	id: 'rangeFrom',
				title: 'Range From',
				width: '226px',
				align: 'right',
				titleAlign: 'right',
				filterOption: true,
				filterOptionType: 'numberNoNegative',
				renderer: function(value){
					return formatCurrency(value);
				}
			},
			{	id: 'rangeTo',
				title: 'Range To',
				width: '226px',
				align: 'right',
				titleAlign: 'right',
				filterOption: true,
				filterOptionType: 'numberNoNegative',
				renderer: function(value){
					return formatCurrency(value);
				}
			}
		],
		rows: objRange.rangeList.rows
	};
	defDistDtlTG = new MyTableGrid(defDistDtlModel);
	defDistDtlTG.pager = objRange.rangeList;
	defDistDtlTG.render("defaultDistDtlTable");
	
	function setRangeValues(rec){
		$("rangeFrom").value = (rec == null ? "" : formatCurrency(rec.rangeFrom));
		$("rangeTo").value = (rec == null ? "" : formatCurrency(rec.rangeTo));
		
		rec == null ? $("btnAddDtl").value = "Add" : $("btnAddDtl").value = "Update";
		rec == null ? disableButton("btnDeleteDtl") : enableButton("btnDeleteDtl");
	}
	
	$("btnReturn").observe("click", function(){
		rangeOverlay.close();
		delete rangeOverlay;
	});
	
	$("rangeFrom").focus();
	initializeAll();
</script>