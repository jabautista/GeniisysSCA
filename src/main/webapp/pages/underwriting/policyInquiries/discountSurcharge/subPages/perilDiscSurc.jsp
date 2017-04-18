<div class="sectionDiv" style="border: none; margin-bottom: 40px;">
	<div id="perilDiscSurcTGDiv" style="margin: 10px 0px 0px 10px; float: left; width: 900px; height: 303px; ">
		
	</div>
	<div style="float: left; margin-top: 10px;">
		<label style="margin: 3px 0px 0px 105px;">Remarks</label>
		<div style="border: 1px solid gray; height: 20px; width: 640px; float: left; margin-left: 5px;">
			<textarea id="txtPerilRemarks" name="txtPerilRemarks" style="width: 616px; border: none; height: 13px; resize: none;" readonly="readonly"></textarea>
			<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 2px; float: right;" alt="Edit" id="editPerilRemarks" />
		</div>
	</div>
</div>
<script type="text/JavaScript">
try{
	try{
		var objPrlDisSur = new Object();
		objPrlDisSur.objPerilDiscSurcTableGrid = JSON.parse('${jsonDiscSurcDtl}');
		objPrlDisSur.objPerilDiscSurc = objPrlDisSur.objPerilDiscSurcTableGrid.rows || []; 
		
		var perilDiscSurcModel = {
			url:contextPath+"/GIPIPolbasicController?action=showDiscSurcDetail&refresh=1&type=prl",
			options:{
				id: 2,
				width: '900px',
				height: '279px',
				onCellFocus: function(element, value, x, y, id){
					$("txtPerilRemarks").value = perilDiscSurcTableGrid.geniisysRows[y].remarks;
					
					perilDiscSurcTableGrid.keys.removeFocus(perilDiscSurcTableGrid.keys._nCurrentFocus, true);
					perilDiscSurcTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus:function(element, value, x, y, id){
					$("txtPerilRemarks").clear();
					
					perilDiscSurcTableGrid.keys.removeFocus(perilDiscSurcTableGrid.keys._nCurrentFocus, true);
					perilDiscSurcTableGrid.keys.releaseKeys();
				},
				toolbar:{
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onRefresh: function() {
						$("txtPerilRemarks").clear();
						
						perilDiscSurcTableGrid.keys.removeFocus(perilDiscSurcTableGrid.keys._nCurrentFocus, true);
						perilDiscSurcTableGrid.keys.releaseKeys();
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
				{	id: 'perilName',
					title: 'Peril Name',
					width: '160px',
					visible: true,
					filterOption: true,
					sortable: true,
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
			rows: objPrlDisSur.objPerilDiscSurc
		};
		
		perilDiscSurcTableGrid = new MyTableGrid(perilDiscSurcModel);
		perilDiscSurcTableGrid.pager = objPrlDisSur.objPerilDiscSurcTableGrid;
		perilDiscSurcTableGrid._mtgId = 2;
		perilDiscSurcTableGrid.render('perilDiscSurcTGDiv');
	}catch(e){
		showErrorMessage("perilDiscSurcTableGrid",e);
	}
	
	$("editPerilRemarks").observe("click", function (){
		showEditor("txtPerilRemarks", 4000, "true");
	});
}catch(e){
	showErrorMessage("perilDiscSurc.jsp", e);
}
</script>