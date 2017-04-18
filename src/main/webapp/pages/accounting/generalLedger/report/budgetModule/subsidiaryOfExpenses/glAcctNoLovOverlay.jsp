<div id="glAcctNo" style="width: 99.5%; margin-top: 5px;">
	<div class="sectionDiv" style="padding: 10px 0 10px 10px; height: 320px; width: 97.6%">
		<div id="glAcctNoListTable">
		</div>
	</div>
	<input type="checkbox" id="chkAll" style="margin-top: 5px; float: left;"/>
	<label for="chkAll" style="margin-top: 5px;">Check All</label>
	<center>
		<input type="button" class="button" value="Ok" id="btnOk" style="margin-top: 10px; margin-left: -85px; width: 100px;" />
		<input type="button" class="button" value="Cancel" id="btnCancel" style="margin-top: 10px; width: 100px;" />
	</center>
</div>
<div>
	<input id="year"     type="hidden"  value="${year}"/>
	<input id="table"      type="hidden"  value="${table}"/>
</div>
<script type="text/javascript">
	var objGLAcctNoLovList = {};
	var objCurrGLAcctNo = null;
	objGLAcctNoLovList.GLAcctNoList = JSON.parse('${jsonGLAcctLOV}');
	
	var glAcctNoTable = {
			url : contextPath + "/GIACBudgetController?action=showGLAcctLOV&refresh=1&table=" + $F("table") + "&year=" + $F("year"),
			options : {
				width : '575px',
				height : '320px',
				pager : {},
				onCellFocus : function(element, value, x, y, id) {
					
				},
				prePager : function() {
					
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					
				},
				onSort : function() {
					
				}, 
				beforeSort: function(){
								
        		},
        		onRefresh: function(){
        			
				},
			},
			columnModel : [
				{
					id : 'recordStatus',
					title : '',
					width : '0',
					visible : false
				}, 
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},
				{
					id: 'chkBox',
					title: '',
					width: '30px',
					tooltip: '',
					align: 'center',
					titleAlign: 'center',
					editor:	 'checkbox',
					editable : true,
					sortable: false,
					editor: new MyTableGrid.CellCheckbox({
						onClick: function(value, checked) {
							
						}
					})
				},
				{
					id : 'glAccountNo',
					filterOption : true,
					title : 'GL Account No',
					width : '150px',
					renderer: function(value){
						return unescapeHTML2(value);	
					}
				},
				{
					id : 'glAcctName',
					filterOption : true,
					title : 'GL Account Name',
					width : '530px',
					renderer: function(value){
						return unescapeHTML2(value);	
					}
				},
				{   id: 'glAcctCategory',
				    width: '0px',
				    visible: false
				},
				{   id: 'glControlAcct',
				    width: '0px',
				    visible: false
				},
				{   id: 'glSubAcct1',
				    width: '0px',
				    visible: false
				},
				{   id: 'glSubAcct2',
				    width: '0px',
				    visible: false
				},
				{   id: 'glSubAcct3',
				    width: '0px',
				    visible: false
				},
				{   id: 'glSubAcct4',
				    width: '0px',
				    visible: false
				},
				{   id: 'glSubAcct5',
				    width: '0px',
				    visible: false
				},
				{   id: 'glSubAcct6',
				    width: '0px',
				    visible: false
				},
				{   id: 'glSubAcct7',
				    width: '0px',
				    visible: false
				},
				{   id: 'glAcctId',
				    width: '0px',
				    visible: false
				}
			],
			rows : objGLAcctNoLovList.GLAcctNoList.rows
	};
	tbgGLAcctNoLov = new MyTableGrid(glAcctNoTable);
	tbgGLAcctNoLov.pager = objGLAcctNoLovList.GLAcctNoList;
	tbgGLAcctNoLov.render("glAcctNoListTable");
	
	function setGlAcctNo(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.year = $F("year");
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			if($F("table") == "GIAC_BUDGET"){
				obj.budget = "";
				obj.remarks = "";
			} else {				
				obj.dtlAcctId = rec.glAcctId;
				obj.glAcctId = $F("glAcctId");
			}
			
			return obj;
		} catch(e){
			showErrorMessage("setGlAcctNo", e);
		}
	}
	
	function addGlAcctNo(){
		if($F("table") == "GIAC_BUDGET"){
			for(var i = 0; i < objGLAcctNoLovList.GLAcctNoList.rows.length; i++){
				if($("mtgInput" + tbgGLAcctNoLov._mtgId + "_2," + i).checked){
					var glAcctNo = setGlAcctNo(tbgGLAcctNoLov.getRow(i));
					tbgBudgetPerYear.addBottomRow(glAcctNo);
					changeTag = 1;
				}
			}
		} else {
			for(var i = 0; i < objGLAcctNoLovList.GLAcctNoList.rows.length; i++){
				if($("mtgInput" + tbgGLAcctNoLov._mtgId + "_2," + i).checked){
					var glAcctNo = setGlAcctNo(tbgGLAcctNoLov.getRow(i));
					tbgGiacBudgetDtl.addBottomRow(glAcctNo);
					changeTag = 1;
				}
			}
		}
		
		giacBudgetLOVOVerlay.close();
		delete giacBudgetLOVOVerlay;
	}
	
	$("chkAll").observe("click", function(){
		if($("chkAll").checked){
			for(var i = 0; i < objGLAcctNoLovList.GLAcctNoList.rows.length; i++){
				$("mtgInput" + tbgGLAcctNoLov._mtgId + "_2," + i).checked = true;
			}
		} else {
			for(var i = 0; i < objGLAcctNoLovList.GLAcctNoList.rows.length; i++){
				$("mtgInput" + tbgGLAcctNoLov._mtgId + "_2," + i).checked = false;
			}
		}
	});
	
	$("btnOk").observe("click", function(){
		addGlAcctNo();
	});
	
	$("btnCancel").observe("click", function(){
		giacBudgetLOVOVerlay.close();
		delete giacBudgetLOVOVerlay;
	});
</script>