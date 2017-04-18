<div id="glAcctWoDtl" style="width: 99.5%; margin-top: 5px;">
	<div class="sectionDiv" style="padding: 10px 0 10px 10px; height: 320px; width: 97.6%">
		<div id="glAcctNoWoDtlTable">
		</div>
	</div>
	<center>
		<input type="button" class="button" value="Continue" id="btnContinue" style="margin-top: 10px; margin-left: 0px; width: 100px;" />
		<input type="button" class="button" value="Cancel" id="btnCancelNoDtl" style="margin-top: 10px; width: 100px;" />
	</center>
</div>
<div>
	<input id="year"     	type="hidden"  value="${year}"/>
	<input id="dateBasis"   type="hidden"  value="${dateBasis}"/>
	<input id="tranFlag"    type="hidden"  value="${tranFlag}"/>
</div>
<script type="text/javascript">

	var objGlAcctNoDtl = {};
	var objCurrGLAcctNoDtl = null;
	objGlAcctNoDtl.GlAcctNoDtlList = JSON.parse('${jsonGlAcctNoDtl}');
	
	var glAcctNoDtlTable = {
			url : contextPath + "/GIACBudgetController?action=viewNoDtl&refresh=1&year=" + $F("year"),
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
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						tbgGLAcctNoDtl.keys.removeFocus(tbgGLAcctNoDtl.keys._nCurrentFocus, true);
						tbgGLAcctNoDtl.keys.releaseKeys();
					}
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
				}
			],
			rows : objGlAcctNoDtl.GlAcctNoDtlList.rows
	};
	tbgGLAcctNoDtl = new MyTableGrid(glAcctNoDtlTable);
	tbgGLAcctNoDtl.pager = objGlAcctNoDtl.GlAcctNoDtlList;
	tbgGLAcctNoDtl.render("glAcctNoWoDtlTable");
	
	$("btnContinue").observe("click", function(){
		extractGiacs510();
		giacBudgetNoDtlOverlay.close();
		delete giacBudgetNoDtlOverlay;
	});
	
	function extractGiacs510(){
		try {
			new Ajax.Request(contextPath+"/GIACBudgetController",{
				method: "POST",
				parameters : {action : "extractGiacs510",
							  year   : $F("txtYear"),
							  dateBasis : $F("dateBasis"),
							  tranFlag : $F("tranFlag")
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function (){
					showNotice("Extracting, please wait...");
				},
				onComplete: function(response){
					hideNotice();
					var result = JSON.parse(response.responseText);
					if (checkErrorOnResponse(response)){
						if (result.exist == "0") {
							showMessageBox("No records extracted.","I");
						}else{
							showMessageBox("Extraction complete. ", imgMessage.SUCCESS);
						}
					}
				}
			});
		} catch (e) {
			showErrorMessage("extractGiacs510",e);
		}
	}
	
	$("btnCancelNoDtl").observe("click", function(){
		giacBudgetNoDtlOverlay.close();
		delete giacBudgetNoDtlOverlay;
	});
</script>