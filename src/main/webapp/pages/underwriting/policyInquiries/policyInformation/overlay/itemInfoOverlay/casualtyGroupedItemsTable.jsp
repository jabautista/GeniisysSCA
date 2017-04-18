<div style="width:746px;margin:10px auto 10px auto;">
	<div style="height:160px;margin:5px auto 0px auto;width:746px;">
		<div id="casualtyGroupedItemListing" style="height:156px;width:746px;float:left;"></div>
	</div>
	<div>
		<table style="width:746px;">
			<tr>
				<td style="width:10px;">
					<input type="checkbox" id="chkCasualtyItemIncludeTag" name="chkCasualtyItemIncludeTag" value="Y" disabled="disabled"/>
				</td>
				<td style="width:520px;">Include</td>
				<td style="width:30px; padding-right: 5px;">Total</td>
				<td style="width:150px;">
					<input class="rightAligned" type="text" id="txtCasualtyItemSumAmt" style="width:96.4%;" readonly="readonly"/>
				</td>
			</tr>
		</table>
		
	
	</div>
		
	<div>
		<table style="width:746px;">
			<tr>
				<td class="rightAligned" style="padding-right: 5px;">Occupation</td>
				<td style="width:258px;">
					<input type="text" id="txtCasualtyItemPosition" style="width:200px;" readonly="readonly"/>
				</td>
				<td class="rightAligned" style="padding-right: 5px;">Salary</td>
				<td>
					<input class="rightAligned" type="text" id="txtCasualtyItemSalary" readonly="readonly"/>
				</td>
				<td  class="rightAligned" style="width:100px; padding-right: 5px;">Salary Grade</td>
				<td style="width:50px;">
					<input type="text" id="txtCasualtyItemSalaryGrade" style="width:88%;" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 5px;">Remarks</td>
				<td colspan="5">
					<textArea id="txtCasualtyItemRemarks" style="width:99.1%; resize:none;" readonly="readonly"></textArea>
				</td>
				
			</tr>
		</table>
				
	</div>
	
	<div style="margin: 10px auto 5px auto;text-align:center">
		<input type="button" class="button" id="btnReturnFromCasualtyGroupedItems" name="btnReturnFromCasualtyGroupedItems" value="Ok" style="width:100px;"/>
	</div>
	
</div>

<script>

	//initialization
	try {
		var objCasualtyGroupedItem = new Object();
		objCasualtyGroupedItem.objCasualtyGroupedItemListTableGrid = JSON.parse('${casualtyGroupedItems}'.replace(/\\/g, '\\\\'));
		objCasualtyGroupedItem.objCasualtyGroupedItemList = objCasualtyGroupedItem.objCasualtyGroupedItemListTableGrid.rows || [];
	} catch(e){}
	
	
	var moduleId = $F("hidModuleId");
	var gipis100path = "/?action=getCasualtyGroupedItems"+
					   "&policyId="+$("hidItemPolicyId").value+
					   "&itemNo="+$("hidItemNo").value;
	var gipis101path = "/GIXXGroupedItemsController?action=getGIXXCasualtyGroupedItems" + 
					   "&extractId=" + $F("hidItemExtractId") +
					   "&itemNo=" + $F("hidItemNo");
	$("btnReturnFromCasualtyGroupedItems").value = moduleId == "GIPIS101" ? "Return" : "Ok";
	
	try{
		var casualtyGroupedItemTableModel = {
			url:contextPath+ ( moduleId == "GIPIS101" ? gipis101path : gipis100path)
				,
			options:{
					title: '',
					width: '746px',
					onCellFocus: function(element, value, x, y, id){
						loadCasualtyGroupedItem(casualtyGroupedItemsTableGrid.geniisysRows[y]);
						casualtyGroupedItemsTableGrid.releaseKeys();
					},
					onRemoveRowFocus:function(element, value, x, y, id){
						unloadCasualtyGroupedItem();
						casualtyGroupedItemsTableGrid.releaseKeys();
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
						title: 'policyId',
						width: '0px',
						visible: false
					},
					{
						id: 'itemNo',
						title: 'itemNo',
						width: '0px',
						visible: false
					},
					{
						id: 'sumAmt',
						title: 'sumAmt',
						width: '0px',
						geniisysClass: 'money',
						visible: false
					},
					{
						id: 'groupedItemNo',
						title: 'No.',
						titleAlign: 'center',
						width: '50%',
						visible: true
					},
					{
						id: 'groupedItemTitle',
						title: 'Title',
						titleAlign: 'center',
						width: '200%',
						visible: true
					},
					{
						id: 'meanSex',
						title: 'Sex',
						titleAlign: 'center',
						width: '70%',
						visible: true
					},
					{
						id: 'dateOfBirth',
						title: 'Date of Birth',
						titleAlign: 'center',
						width: '100%',
						visible: true
					},
					{
						id: 'age',
						title: 'Age',
						titleAlign: 'center',
						width: '50%',
						visible: true
					},
					{
						id: 'civilStatusDesc',
						title: 'Status',
						titleAlign: 'center',
						width: '100%',
						visible: true
					},
					{
						id: 'amountCoverage',
						title: 'Amount Covered',
						titleAlign: 'center',
						width: '150%',
						align: 'right',
						geniisysClass: 'money',
						visible: true
					},
					
			],
			rows:objCasualtyGroupedItem.objCasualtyGroupedItemList
		};
	
		casualtyGroupedItemsTableGrid = new MyTableGrid(casualtyGroupedItemTableModel);
		casualtyGroupedItemsTableGrid.render('casualtyGroupedItemListing');
	}catch(e){
		showErrorMessage("casualtyGroupedItemsTable.jsp: " + e.message);
	}
	
    // added condition to prevent error when policy has no grouped items by robert SR 21748 03.08.16
	if(casualtyGroupedItemsTableGrid.geniisysRows.length > 0){
		$("txtCasualtyItemSumAmt").value = formatCurrency(casualtyGroupedItemsTableGrid.getValueAt(4,0));
	}
	
	function loadCasualtyGroupedItem(casualtyGroupedItem){
		if ($("chkCasualtyItemIncludeTag").value   == casualtyGroupedItem.includeTag){
			$("chkCasualtyItemIncludeTag").checked  = true;
		}
		$("txtCasualtyItemSalary").value			= formatCurrency(casualtyGroupedItem.salary);
		$("txtCasualtyItemSalaryGrade").value		= casualtyGroupedItem.salaryGrade;
		$("txtCasualtyItemRemarks").value			= unescapeHTML2(casualtyGroupedItem.remarks);
		$("txtCasualtyItemPosition").value 			= unescapeHTML2(casualtyGroupedItem.position);
	}

	function unloadCasualtyGroupedItem(){		
		$("txtCasualtyItemSalary").value			= "";
		$("txtCasualtyItemSalaryGrade").value		= "";
		$("txtCasualtyItemRemarks").value			= "";
		$("txtCasualtyItemPosition").value 			= "";
		$("chkCasualtyItemIncludeTag").checked  	= false;
	}
	
	$("btnReturnFromCasualtyGroupedItems").observe("click", function(){
		overlayCasualtyGroupedItemsTable.close();
	});
	
	
	
</script>