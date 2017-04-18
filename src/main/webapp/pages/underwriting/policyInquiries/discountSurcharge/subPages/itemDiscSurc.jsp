<div class="sectionDiv" style="border: none; margin-bottom: 40px;">
	<div id="itemDiscSurcTGDiv" style="margin: 10px 0px 0px 10px; float: left; width: 900px; height: 303px; ">
		
	</div>
	<div style="float: left; margin-top: 10px;">
		<label style="margin: 3px 0px 0px 105px;">Remarks</label>
		<div style="border: 1px solid gray; height: 20px; width: 640px; float: left; margin-left: 5px;">
			<textarea id="txtItemRemarks" name="txtItemRemarks" style="width: 616px; border: none; height: 13px; resize: none;" readonly="readonly"></textarea>
			<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 2px; float: right;" alt="Edit" id="editItemRemarks" />
		</div>
	</div>
</div>
<script type="text/JavaScript">
try{
	try{
		var objItmDisSur = new Object();
		objItmDisSur.objItemDiscSurcTableGrid = JSON.parse('${jsonDiscSurcDtl}');
		objItmDisSur.objItemDiscSurc = objItmDisSur.objItemDiscSurcTableGrid.rows || []; 
		
		var itemDiscSurcModel = {
			url:contextPath+"/GIPIPolbasicController?action=showDiscSurcDetail&refresh=1&type=itm",
			options:{
				id: 3,
				width: '900px',
				height: '279px',
				onCellFocus: function(element, value, x, y, id){
					$("txtItemRemarks").value = itemDiscSurcTableGrid.geniisysRows[y].remarks;
					
					itemDiscSurcTableGrid.keys.removeFocus(itemDiscSurcTableGrid.keys._nCurrentFocus, true);
					itemDiscSurcTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus:function(element, value, x, y, id){
					$("txtItemRemarks").clear();
					
					itemDiscSurcTableGrid.keys.removeFocus(itemDiscSurcTableGrid.keys._nCurrentFocus, true);
					itemDiscSurcTableGrid.keys.releaseKeys();
				},
				toolbar:{
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onRefresh: function() {
						$("txtItemRemarks").clear();
						
						itemDiscSurcTableGrid.keys.removeFocus(itemDiscSurcTableGrid.keys._nCurrentFocus, true);
						itemDiscSurcTableGrid.keys.releaseKeys();
					}
				},
			},
			columnModel:[
				{   id: 'recordStatus',
				    title: '',
				    width: '0px',
				    visible: false,
				    editor: 'checkbox' 			
				},
				{	id: 'divCtrId',
					width: '0px',
					visible: false
				},
				{	id: 'netGrossTag',
					title: 'G',
					altTitle: 'Gross',
					width: '30px',
					editor : new MyTableGrid.CellCheckbox({
						getValueOf : function(value) {
							return value ? "G" : "N";
						}
					})
				},
				{	id: 'sequence',
					title: 'Sequence',
					width: '80px',
					visible: true,
					filterOption: true,
					align: 'right',
					titleAlign: 'right'
				},
				{	id: 'itemNo',
					title: 'Item No.',
					width: '90px',
					visible: true,
					filterOption: true,
					align: 'right',
					titleAlign: 'right'
				},
				{	id: 'discAmt',
					title: 'Discount Amount',
					width: '140px',
					visible: true,
					filterOption: true,
					geniisysClass: 'money',
					align: 'right',
					titleAlign: 'right'
				},
				{	id: 'discRt',
					title: 'Discount Rt',
					width: '140px',
					visible: true,
					filterOption: true,
					geniisysClass: 'rate',
					align: 'right',
					titleAlign: 'right'
				},
				{	id: 'surcAmt',
					title: 'Surcharge Amount',
					width: '140px',
					visible: true,
					filterOption: true,
					geniisysClass: 'money',
					align: 'right',
					titleAlign: 'right'
				},
				{	id: 'surcRt',
					title: 'Surcharge Rt',
					width: '140px',
					visible: true,
					filterOption: true,
					geniisysClass: 'rate',
					align: 'right',
					titleAlign: 'right'
				},
				{	id: 'netPremAmt',
					title: 'Premium Amount',
					width: '140px',
					visible: true,
					filterOption: true,
					geniisysClass: 'money',
					align: 'right',
					titleAlign: 'right'
				},
			],
			rows: objItmDisSur.objItemDiscSurc
		};
		
		itemDiscSurcTableGrid = new MyTableGrid(itemDiscSurcModel);
		itemDiscSurcTableGrid.pager = objItmDisSur.objItemDiscSurcTableGrid;
		itemDiscSurcTableGrid._mtgId = 3;
		itemDiscSurcTableGrid.render('itemDiscSurcTGDiv');
		itemDiscSurcTableGrid.afterRender = function(){
			
		};
	}catch(e){
		showErrorMessage("itemDiscSurcTableGrid",e);
	}
	
	$("editItemRemarks").observe("click", function (){
		showEditor("txtItemRemarks", 4000, "true");
	});
}catch(e){
	showErrorMessage("itemDiscSurc.jsp", e);
}
</script>