<div class="sectionDiv" style="border: none; margin-bottom: 40px;">
	<div id="polDiscSurcTGDiv" style="margin: 10px 0px 0px 10px; float: left; width: 900px; height: 303px; ">
		
	</div>
	<div style="float: left; margin-top: 10px;">
		<label style="margin: 3px 0px 0px 105px;">Remarks</label>
		<div style="border: 1px solid gray; height: 20px; width: 640px; float: left; margin-left: 5px;">
			<textarea id="txtPolicyRemarks" name="txtPolicyRemarks" style="width: 616px; border: none; height: 13px; resize: none;" readonly="readonly"></textarea>
			<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 2px; float: right;" alt="Edit" id="editPolicyRemarks" />
		</div>
	</div>
</div>
<script type="text/JavaScript">
try{
	try{
		var objPolDisSur = new Object();
		objPolDisSur.objPolDiscSurcTableGrid = JSON.parse('${jsonDiscSurcDtl}');
		objPolDisSur.objPolDiscSurc = objPolDisSur.objPolDiscSurcTableGrid.rows || []; 
		
		var polDiscSurcModel = {
			url:contextPath+"/GIPIPolbasicController?action=showDiscSurcDetail&refresh=1&type=pol",
			options:{
				id: 4,
				width: '900px',
				height: '279px',
				onCellFocus: function(element, value, x, y, id){
					$("txtPolicyRemarks").value = polDiscSurcTableGrid.geniisysRows[y].remarks;
					
					polDiscSurcTableGrid.keys.removeFocus(polDiscSurcTableGrid.keys._nCurrentFocus, true);
					polDiscSurcTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus:function(element, value, x, y, id){
					$("txtPolicyRemarks").clear();
					
					polDiscSurcTableGrid.keys.removeFocus(polDiscSurcTableGrid.keys._nCurrentFocus, true);
					polDiscSurcTableGrid.keys.releaseKeys();
				},
				toolbar:{
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onRefresh: function() {
						$("txtPolicyRemarks").clear();
						
						polDiscSurcTableGrid.keys.removeFocus(polDiscSurcTableGrid.keys._nCurrentFocus, true);
						polDiscSurcTableGrid.keys.releaseKeys();
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
			rows: objPolDisSur.objPolDiscSurc
		};
		
		polDiscSurcTableGrid = new MyTableGrid(polDiscSurcModel);
		polDiscSurcTableGrid.pager = objPolDisSur.objPolDiscSurcTableGrid;
		polDiscSurcTableGrid._mtgId = 4;
		polDiscSurcTableGrid.render('polDiscSurcTGDiv');
		polDiscSurcTableGrid.afterRender = function(){
			
		};
	}catch(e){
		showErrorMessage("polDiscSurcTableGrid",e);
	}
	
	$("editPolicyRemarks").observe("click", function (){
		showEditor("txtPolicyRemarks", 4000, "true");
	});
}catch(e){
	showErrorMessage("polDiscSurc.jsp", e);
}
</script>