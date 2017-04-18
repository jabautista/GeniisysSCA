<div style="width:594px;margin:10px auto 10px auto;">
	<div style="height:160px;width:594px;margin:5px auto 5px auto;">
		<div id="itemMortgageeListing" style="height:156px;width:594px;float:left;"></div>
	</div>
	<div style="margin: 5px auto 5px auto; text-align:right">
		Total Amount&nbsp;&nbsp;<input type="text" id="txtMortgageeTotalAmount" name="txtMortgageeTotalAmount" style="width:145px;margin-right:125px;" class="rightAligned" readonly="readonly">
	</div>
	<div style="margin: 10px auto 10px auto;">
		<table style="width:100%;">
			<tr>
				<td style="width:75px;padding-right: 5px;" class="rightAligned">Remarks </td>
				<td style="">
					<textArea id="txtItemMortgageeRemarks" name="txtItemMortgageeRemarks" style="width:95%; resize:none;" readonly="readonly"></textArea>
				</td>
			</tr>
		</table>
		
	</div>
	<div style="margin: 5px auto 5px auto;text-align:center">
		<input type="button" class="button" id="btnReturnFromItemMortgagee" name="btnReturnFromItemMortgagee" value="Return" style="width:100px;"/>
	</div>
</div>

<script>
		//initialization
	var objItemMortgagee = new Object();
	objItemMortgagee.objItemMortgageeListTableGrid = JSON.parse('${itemMortgagees}'.replace(/\\/g, '\\\\'));
	objItemMortgagee.objItemMortgageeList = objItemMortgagee.objItemMortgageeListTableGrid.rows || [];
	
	//added by Kris 03.06.2013 for GIPIS101
	var moduleId = $F("hidModuleId");
	moduleId == "GIPIS101" ? initializeGIPIS101() : initializeGIPIS100() ;
	
	function initializeGIPIS100(){
		try{
			var itemMortgageeTableModel = {
				url:contextPath+"/GIPIMortgageeController?action=getItemMortgagees&refresh=1"+
				"&policyId="+$("hidItemPolicyId").value+
				"&itemNo="+$("hidItemNo").value
					,
				options:{
						title: '',
						width: '594px',
						onCellFocus: function(element, value, x, y, id){
							$("txtItemMortgageeRemarks").value = unescapeHTML2(itemMortgageeTableGrid.geniisysRows[y].remarks);
							itemMortgageeTableGrid.releaseKeys();
						},
						onRemoveRowFocus:function(element, value, x, y, id){
							$("txtItemMortgageeRemarks").value = "";
							itemMortgageeTableGrid.releaseKeys();
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
							id: 'sumAmount',
							title: 'sumAmount',
							width: '0px',
							visible: false
						},
						{
							id: 'mortgCd',
							title: 'Code',
							width: '100%',
							visible: true
						},
						{
							id: 'mortgName',
							title: 'Mortgagee',
							width: '200%',
							visible: true
						},
						{
							id: 'amount',
							title: 'Amount',
							width: '150%',
							visible: true,
							geniisysClass: 'money',
							align: 'right'
						},
						{
							id: 'itemNo',
							title: 'Item',
							width: '100%',
							visible: true
						},
						{
							id: 'deleteSw',
							title: 'D',
							width: '22%',
							defaultValue: false,
							otherValue: false,
							hideSelectAllBox : true,
							editor: new MyTableGrid.CellCheckbox({
							    getValueOf: function(value) {
							        var result = 'N';
							        if (value) result = 'Y';
							        return result;
							    }
							}),
							visible: true
							
						}
				],
				rows:objItemMortgagee.objItemMortgageeList
			};
		
			itemMortgageeTableGrid = new MyTableGrid(itemMortgageeTableModel);
			itemMortgageeTableGrid.render('itemMortgageeListing');
		}catch(e){
			showErrorMessage("Item Mortgagee - GIPIS101", e);
		}
	}
	
	try{
		$("txtMortgageeTotalAmount").value = formatCurrency(itemMortgageeTableGrid.getValueAt(4,0));
	}catch(e){}
	
	
	$("btnReturnFromItemMortgagee").observe("click", function(){
		overlayItemMortgagees.close();
	});

	// function for GIPIS101
	function initializeGIPIS101(){
		try{
			var itemMortgageeTableModel = {
				url:contextPath+"/GIXXMortgageeController?action=getGIXXItemMortgagees"+
				"&extractId="+$("hidItemExtractId").value+
				"&itemNo="+$("hidItemNo").value
					,
				options:{
						title: '',
						width: '594px',
						onCellFocus: function(element, value, x, y, id){
							$("txtItemMortgageeRemarks").value = unescapeHTML2(itemMortgageeTableGrid.geniisysRows[y].remarks);
							itemMortgageeTableGrid.releaseKeys();
						},
						onRemoveRowFocus:function(element, value, x, y, id){
							$("txtItemMortgageeRemarks").value = "";
							itemMortgageeTableGrid.releaseKeys();
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
							id: 'extractId',
							title: 'extractId',
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
							id: 'totalAmount',
							title: 'totalAmount',
							width: '0px',
							visible: false
						},
						{
							id: 'mortgCd',
							title: 'Code',
							width: '100%',
							visible: true
						},
						{
							id: 'mortgName',
							title: 'Mortgagee',
							width: '200%',
							visible: true
						},
						{
							id: 'amount',
							title: 'Amount',
							titleAlign: 'right',
							width: '150%',
							align: 'right',
							visible: true,
							geniisysClass: 'money'
						},
						{
							id: 'dspItemNo',
							title: 'Item',
							width: '124%',							
							visible: true
						}
				],
				rows:objItemMortgagee.objItemMortgageeList
			};
		
			itemMortgageeTableGrid = new MyTableGrid(itemMortgageeTableModel);
			itemMortgageeTableGrid.render('itemMortgageeListing');
		}catch(e){
			showErrorMessage("Item Mortgagee - GIPIS101", e);
		}
	}
</script>