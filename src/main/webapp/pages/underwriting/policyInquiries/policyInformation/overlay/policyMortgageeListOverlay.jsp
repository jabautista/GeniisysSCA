<div style="">
	<div id="mortgageeTableGridSectionDiv"style="height:160px;">
			<div id="mortgageeTableGridDiv" style="height:156px;width:542px;margin:10px auto 10px auto;">
				<div id="mortgageeListing" style="height:156px;width:542px;"></div>
			</div>
	</div>
	<div style="text-align:right;margin-bottom:10px;">
		Total Amount&nbsp;&nbsp;<input type="text" id="txtMortgSumAmount" name="txtMortgSumAmount" style="width:100px;margin-right:78px;text-align:right;" class="rightAligned" readonly="readonly">
	</div>
	<div>
		<table>
			<tr>
				<td style="padding-right: 3px;">Remarks</td>
				<td style="width:490px;">
					<!-- <input type="text" id="txtMortgRemarks" style="width:98.2%;" readonly="readonly"> -->
					<div style="border: 1px solid gray; height: 21px; width: 470px; ">
						<textarea id="txtMortgRemarks" name="txtMortgRemarks" maxlength="4000" style="width: 444px; border: none; height: 13px; resize: none;"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="EditRemark" id="editMortgRemarks" />
					</div>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<div style="padding:10px;text-align:center;">
						<input type="button" class="button" id="btnMortgAddtlInfo" value="Additional Information" style="width: 150px;"/>
						<input type="hidden" id="hidMortgPolicyId" name="hidMortgPolicyId" value="${policyId}">
					</div>
				</td>
				
			</tr>
		</table>
	</div>
	
</div>

<script>
	var mortgageeSelectedIndex;
	var objMortgagee = new Object();
	objMortgagee.objMortgageeListTableGrid = JSON.parse('${mortgageeList}'.replace(/\\/g, '\\\\'));
	objMortgagee.objMortgageeList = objMortgagee.objMortgageeListTableGrid.rows || [];
	
	$("hidMortgPolicyId").value = '${policyId}';

	var moduleId = $F("hidModuleId");
	moduleId == "GIPIS101" ? initializeGIPIS101() : initializeGIPIS100() ;
	$("btnMortgAddtlInfo").value = moduleId == "GIPIS101" ? "Return" : "Additional Information";
	
	function initializeGIPIS100() {
		try{
			var mortgageeTableModel = {
				url:contextPath+"/GIPIMortgageeController?action=getPolicyMortgageeList&policyId="+$("hidMortgPolicyId").value+
					"&refresh=1",
				options:{
						title: '',
						width:'542px',
						onCellFocus: function(element, value, x, y, id){
							var mtgId = mortgageeTableGrid._mtgId;
							mortgageeSelectedIndex = -1;
							if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
								mortgageeSelectedIndex = y;
							}
							$("txtMortgRemarks").value = unescapeHTML2(mortgageeTableGrid.geniisysRows[y].remarks);
							mortgageeTableGrid.keys.removeFocus(mortgageeTableGrid.keys._nCurrentFocus, true);
							mortgageeTableGrid.keys.releaseKeys(); 	
						},
						onRemoveRowFocus:function(element, value, x, y, id){
							mortgageeSelectedIndex = -1;
							$("txtMortgRemarks").clear();
							mortgageeTableGrid.keys.removeFocus(mortgageeTableGrid.keys._nCurrentFocus, true);
							mortgageeTableGrid.keys.releaseKeys(); 	
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
						{	id: 'rowNum',
							title: 'rowNum',
							width: '0px',
							visible: false
						},
						{	id: 'rowCount',
							title: 'rowCount',
							width: '0px',
							visible: false
						},
						{	id: 'sumAmount',
							title: 'sumAmount',
							width: '0px',
							visible: false,
							geniisysClass: 'money'
						},
						{	id: 'deleteSw',
							title: 'D',
							width: '22%',
							visible: true,
							editor: new MyTableGrid.CellCheckbox({
						        getValueOf: function(value){
					            	if (value){
										return "Y";
					            	}else{
										return "N";	
					            	}
				            	}
				            })
						},
						{	id: 'mortgCd',
							title: 'Code',
							width: '100%',
							visible: true
						},
						{	id: 'mortgName',
							title: 'Mortgagee',
							width: '250%',
							visible: true
						},
						{	id: 'amount',
							title: 'Amount',
							geniisysClass: 'money',
							align: 'right',
							width: '100%',
							visible: true
						},
						{	id: 'itemNo',
							title: 'Item',
							type: 'number',
							width: '48%',
							visible: true
						},
				],
				rows:objMortgagee.objMortgageeList
			};
			mortgageeTableGrid = new MyTableGrid(mortgageeTableModel);
			//mortgageeTableGrid.pager = objMortgagee.objMortgageeListTableGrid;
			mortgageeTableGrid.render('mortgageeListing');
			mortgageeTableGrid.afterRender = function(){
				try{
					if(mortgageeTableGrid.geniisysRows.length > 0){
						$("txtMortgSumAmount").value = formatCurrency(mortgageeTableGrid.geniisysRows[0].totalAmount); 	
					}else{
						$("txtMortgSumAmount").value = formatCurrency(0);
					}
					
				}catch(e){
					showErrorMessage("mortgageeTableGrid.afterRender", e);
				}
			};
			/* try {
				$("txtMortgSumAmount").value = mortgageeTableGrid == null ? "0.00" : formatCurrency(mortgageeTableGrid.getValueAt(mortgageeTableGrid.getColumnIndex("sumAmount"),0));
			} catch (e){} */
			
		}catch(e){
			showErrorMessage("initializeGIPIS100", e);
		}
	}
	
	
	$("btnMortgAddtlInfo").observe("click", function(){
		overlayMortgageeList.close();
	});
	
	
	// function for GIPIS101
	function initializeGIPIS101(){
		try{
			var mortgageeTableModel = { //robert 10.07.2013 added parameter extractId
				url:contextPath+"/GIXXMortgageeController?action=getGIXXMortgageeList&extractId="+$("hidExtractId").value+
					"&refresh=1",
				options:{
						title: '',
						width:'542px',
						onCellFocus: function(element, value, x, y, id){
							var mtgId = mortgageeTableGrid._mtgId;
							mortgageeSelectedIndex = -1;
							if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
								mortgageeSelectedIndex = y;
								//$("txtMortgRemarks").value = unescapeHTML2(mortgageeTableGrid.getValueAt(5, y));
							}
						},
						onRemoveRowFocus:function(element, value, x, y, id){
							mortgageeSelectedIndex = -1;
						},
						onRowDoubleClick: function(param){
							//var row = mortgageeTableGrid.geniisysRows[param];
							//getPolicyEndtSeq0(row.policyId);
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
						{	id: 'rowNum',
							title: 'rowNum',
							width: '0px',
							visible: false
						},
						{	id: 'rowCount',
							title: 'rowCount',
							width: '0px',
							visible: false
						},
						{	id: 'totalAmount',
							title: 'totalAmount',
							width: '0px',
							visible: false,
							geniisysClass: 'money'
						},
						{	id: 'remarks',
							title: 'Remarks',
							width: '0px',
							visible: false
						},
						{	id: 'mortgCd',
							title: 'Code',
							width: '100%',
							visible: true
						},
						{	id: 'mortgName',
							title: 'Mortgagee',
							width: '250%',
							visible: true
						},
						{	id: 'amount',
							title: 'Amount',
							titleAlign:'right',
							width: '120%',
							align: 'right',
							visible: true,
							geniisysClass: 'money'
						},
						{	id: 'itemNo',
							title: 'Item',
							width: '50%',
							visible: true
						}						
				],
				rows:objMortgagee.objMortgageeList
			};
			mortgageeTableGrid = new MyTableGrid(mortgageeTableModel);
			//mortgageeTableGrid.pager = objMortgagee.objMortgageeListTableGrid;
			mortgageeTableGrid.render('mortgageeListing');
		}catch(e){
			showErrorMessage("initializeGIPIS101", e);
		}
		
		try {
			$("txtMortgSumAmount").value = mortgageeTableGrid == null ? "0.00" : formatCurrency(mortgageeTableGrid.getValueAt(4,0));
			//$("txtMortgSumAmount").value = formatCurrency(objMortgagee.objMortgageeList.getValueAt(4,0));
		} catch (e){}
	}
	
	$("editMortgRemarks").observe("click", function () {
		showEditor("txtMortgRemarks", 4000, "true");
	});
</script>