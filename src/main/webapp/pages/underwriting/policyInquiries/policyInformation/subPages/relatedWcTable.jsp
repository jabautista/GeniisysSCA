<div id="polWcTableGridSectionDiv" class="sectionDiv" style="border: none; padding:10px;">
		<div id="polWcTableGridDiv" class="sectionDiv" style="border: none;">
			<div id="polWcListing" class="sectionDiv" style="margin:auto; border: none; height:281px; width:900px;"></div>
			<div id="polWcDetails" class="sectionDiv" style="margin: auto; border: none; width:900px; margin-top: 20px; padding: 10px; ">
				<table>
					<tr>
						<td class="rightAligned">Title </td>
						<td class="leftAligned" colspan="5">
							<input id="textTitleClause" name="textTitleClause" type="text" style="width: 800px" readonly="readonly">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Text </td>
						<td class="leftAligned">
							<textarea tabindex="3" style="width: 800px; height: 30px; float: left; resize: none; " id="wcDesc" name="wcDesc" readonly="readonly"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: left;" alt="EditItemDesc" id="textDesc" class="hover" /> 
						</td>
					</tr>
				</table>
			</div>
		</div>
</div>

<script>
	var moduleId = $F("hidModuleId");
	var objWc = new Object();
	
	//objWc.objWcListTableGrid = JSON.parse('${gipiRelatedWcTableGrid}'.replace(/\\/g, '\\\\'));
	objWc.objWcListTableGrid = JSON.parse('${gipiRelatedWcTableGrid}');
	objWc.objWcList = objWc.objWcListTableGrid.rows || [];
	try{
		//added by Kris 03.01.2013
		moduleId == "GIPIS101" ? displayTG101() : displayTG100();
		
	} catch(e){

	}
		

	function viewText(obj){
		$("wcDesc").value 	       = (obj == null ? "" : unescapeHTML2(nvl(obj.wcText, "")));
		$("textTitleClause").value = (obj == null ? "" : unescapeHTML2(nvl(obj.wcTitle, "")));
	}
	
	$("textDesc").observe("click", function () {
		showEditor("wcDesc", 32767, 'true');
	});
	
	function displayTG100(){
		try{
			var wcTableModel = {
				url:contextPath+ "/GIPIPolwcController?action=refreshRelatedWcInfo&refresh=1&policyId="+$F("hidPolicyId")
					,
				options:{
						hideColumnChildTitle: true,
						title: '',
						width: '900px',
						onCellFocus: function(element, value, x, y, id){
							wcTableGrid.keys.removeFocus(wcTableGrid.keys._nCurrentFocus, true);
							wcTableGrid.keys.releaseKeys();	
							var obj = wcTableGrid.geniisysRows[y];
							viewText(obj);
		
						},
						onRowDoubleClick: function(param){
							var row = wcTableGrid.geniisysRows[param];
							
						},
						onRemoveRowFocus:function(element, value, x, y, id){		//Gzelle 06.15.2013
							viewText(null);
						},
						onSort: function() {										//Gzelle 06.15.2013
							viewText(null);	
						}
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
						{
							id: 'policyId',
							title: 'Policy Id',
							width: '0px',
							visible: false
			
						},
						{	id: 'printSw',
							title: 'P',
							width: '25%',
							defaultValue: false,
							otherValue: false,
							editor: new MyTableGrid.CellCheckbox({
							    getValueOf: function(value) {
							        var result = 'N';
							        if (value) result = 'Y';
							        return result;
							    }
							})
						},
						{	id: 'printSeqNo',
							title: 'PSN',
							width: '50%'
						},
						{	id: 'wcCd',
							title: 'WC Code',
							width: '100%'
						},
						{	id: 'swcSeqNo',
							title: 'SWC No.',
							width: '50%'
						},
						{	id: 'wcTitle',
							title: 'WC Title',
							width: '200%'
												
						},
						{	id: 'wcText',
							title: 'Text',
							width: '350%'
						},
						{	id: 'wcRemarks',
							title: 'Remarks',
							width: '100%'
						}
				],
				rows:objWc.objWcList
			};
	
			wcTableGrid = new MyTableGrid(wcTableModel);
			wcTableGrid.pager = objWc.objWcListTableGrid;
			wcTableGrid.render('polWcListing');
		}catch(e){

		}
	}
	
	// function for GIPIS101
	function displayTG101(){
		try{
			var wcTableModel = {
				url:contextPath+ "/GIXXPolwcController?action=getGIXXRelatedWcInfo&refresh=1&extractId="+$F("hidExtractId")
					,
				options:{
						hideColumnChildTitle: true,
						title: '',
						width: '900px',
						onCellFocus: function(element, value, x, y, id){
							wcTableGrid.keys.removeFocus(wcTableGrid.keys._nCurrentFocus, true);
							wcTableGrid.keys.releaseKeys();	
							var obj = wcTableGrid.geniisysRows[y];
							viewText(obj);
		
						},
						onRowDoubleClick: function(param){
							var row = wcTableGrid.geniisysRows[param];
							
						}
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
						{
							id: 'policyId',
							title: 'Policy Id',
							width: '0px',
							visible: false
			
						},
						{	id: 'printSeqNo',
							title: 'PSN',
							width: '50%'
						},
						{	id: 'wcCd',
							title: 'WC Code',
							width: '100%'
						},
						{	id: 'swcSeqNo',
							title: 'SWC No.',
							width: '50%'
						},
						{	id: 'wcTitle',
							title: 'WC Title',
							width: '200%'
												
						},
						{	id: 'wcText',
							title: 'Text',
							width: '350%'
						},
						{	id: 'wcRemarks',
							title: 'Remarks',
							width: '130%'
						}
				],
				rows:objWc.objWcList
			};
	
			wcTableGrid = new MyTableGrid(wcTableModel);
			wcTableGrid.pager = objWc.objWcListTableGrid;
			wcTableGrid.render('polWcListing');
		}catch(e){
			showErrorMessage("displayTG101", e);
		}
	}
</script>