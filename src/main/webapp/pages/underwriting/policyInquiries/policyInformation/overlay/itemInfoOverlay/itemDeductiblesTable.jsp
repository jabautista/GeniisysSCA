<div id="itemDeductibleDiv" style="width:618px;margin:10px auto 10px auto;">
	<div id="itemDeductibleDiv2" style="height:160px;margin:5px auto 5px auto;width:618px;">
		<div id="itemDeductibleListing" style="height:156px;width:618px;float:left;"></div>
	</div>
	<div style="margin: 5px auto 5px auto;text-align:right">
		Total Amount <input type="text" id="txtItemDeductibleTotalAmount" name="txtItemDeductibleTotalAmount" style="width:145px; text-align: right;" readonly="readonly">
	</div>
	<div id="itemDeductibleTextDiv" style="margin: 10px auto 10px auto;">
		<table style="width:100%;">
			<tr>
				<td style="width:50px;" class="rightAligned">Text </td>
				<td style="">
					<textArea id="txtItemDeductibleText" name="txtItemDeductibleText" style="width: 95%; resize: none;" readonly="readonly"></textArea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="ViewDeductibleDesc" id="textPixDeduc" class="hover" />
				</td>
			</tr>
		</table>
	</div>
	<div style="margin: 5px auto 5px auto;text-align:center">
		<input type="button" class="button" id="btnReturnFromItemDeductibles" name="btnReturnFromItemDeductibles" value="Return" style="width:100px;"/>
	</div>
</div>

<script>
	$("textPixDeduc").observe("click", function () {
		showOverlayEditor("txtItemDeductibleText", 2000, 'true');
	});
	
	//initialization
	var objItemDeductible = new Object();
	objItemDeductible.objItemDeductibleListTableGrid = JSON.parse('${itemDeductibles}');
	objItemDeductible.objItemDeductibleList = objItemDeductible.objItemDeductibleListTableGrid.rows || [];
	
	var moduleId = $F("hidModuleId");
	
	moduleId == "GIPIS101" ? initializeGIPIS101() : initializeGIPIS100();
	
	try{
		$("txtItemDeductibleTotalAmount").value = formatCurrency(itemDeductibleTableGrid.getValueAt(4,0));
	}catch(e){}

	$("btnReturnFromItemDeductibles").observe("click", function(){
		overlayItemDeductibles.close();
	});
	
	function initializeGIPIS100(){
		try{
			var itemDeductibleTableModel = {
				url:contextPath+"/?action=getItemDeductibles"+
				"&policyId="+$("hidItemPolicyId").value+
				"&itemNo="+$("hidItemNo").value
					,
				options:{
						querySort: false, // added by Nica 05.11.2013 - to sort deductibles
						title: '',
						width: '618px',
						onCellFocus: function(element, value, x, y, id){
							$("txtItemDeductibleText").value = unescapeHTML2(itemDeductibleTableGrid.geniisysRows[y].deductibleText);
							itemDeductibleTableGrid.releaseKeys();
						},
						onRemoveRowFocus:function(element, value, x, y, id){
							$("txtItemDeductibleText").value = "";
							itemDeductibleTableGrid.releaseKeys();
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
							id: 'totalDeductibleAmt',
							title: 'totalDeductibleAmt',
							width: '0px',
							visible: false
						},
						{
							id: 'aggregateSw',
							title: 'A',
							width: '22%',
							defaultValue: false,
							otherValue: false,
							editor: new MyTableGrid.CellCheckbox({
							    getValueOf: function(value) {
							        var result = 'N';
							        if (value) result = 'Y';
							        return result;
							    }
							}),
							visible: true
						},
						{
							id: 'ceilingSw',
							title: 'C',
							width: '22%',
							defaultValue: false,
							otherValue: false,
							editor: new MyTableGrid.CellCheckbox({
							    getValueOf: function(value) {
							        var result = 'N';
							        if (value) result = 'Y';
							        return result;
							    }
							}),
							visible: true
						},
						{
							id: 'dedDeductibleCd',
							title: 'Code',
							width: '100%',
							visible: true
						},
						{
							id: 'deductibleTitle',
							title: 'Deductible Title',
							width: '200%',
							visible: true
						},
						{
							id: 'deductibleRt',
							title: 'Rate',
							width: '100%',
							visible: true,
							titleAlign: 'right',
							align: 'right',
							geniisysClass : 'money',     
				            geniisysMinValue: '-999999999999.99',     
				            geniisysMaxValue: '999,999,999,999.99',
				            renderer: function(value){
								return formatToNineDecimal(value);
							}
						},
						{
							id: 'deductibleAmt',
							title: 'Deductible Amount',
							width: '150%',
							visible: true,
							titleAlign: 'right',
							align:'right',
							geniisysClass : 'money',     
						    geniisysMinValue: '-999999999999.99',     
						    geniisysMaxValue: '999,999,999,999.99'
						},
				],
				rows:objItemDeductible.objItemDeductibleList
			};
		
			itemDeductibleTableGrid = new MyTableGrid(itemDeductibleTableModel);
			itemDeductibleTableGrid.render('itemDeductibleListing');
		}catch(e){
			showErrorMessage("Item Deductibles - initializeGIPIS100", e);
		}
	}
	
	// method for GIPIS101
	function initializeGIPIS101(){
		try{
			var itemDeductibleTableModel = {
				url:contextPath+"/GIXXDeductiblesController?action=getGIXXItemDeductibles"+ "&refresh=1" + 
				"&extractId="+$F("hidItemExtractId")+
				"&itemNo="+$F("hidItemNo")
					,
				options:{
						title: '',
						width: '480px',
						onCellFocus: function(element, value, x, y, id){
						//	$("txtItemDeductibleText").value = itemDeductibleTableGrid.geniisysRows[y].deductibleText;
							itemDeductibleTableGrid.releaseKeys();
						},
						onRemoveRowFocus:function(element, value, x, y, id){
						//	$("txtItemDeductibleText").value = "";
							itemDeductibleTableGrid.releaseKeys();
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
							id: 'totalDeductibleAmt',
							title: 'totalDeductibleAmt',
							width: '0px',
							visible: false
						},						
						{
							id: 'dedDeductibleCd',
							title: 'Code',
							width: '100%',
							visible: true
						},
						{
							id: 'deductibleTitle',
							title: 'Deductible Title',
							width: '212%',
							visible: true
						},						
						{
							id: 'deductibleAmt',
							title: 'Deductible Amount',
							width: '150%',
							visible: true,
							titleAlign: 'right',
							align:'right',
							geniisysClass : 'money',     
						    geniisysMinValue: '-999999999999.99',     
						    geniisysMaxValue: '999,999,999,999.99'
						}
				],
				rows:objItemDeductible.objItemDeductibleList
			};
		
			itemDeductibleTableGrid = new MyTableGrid(itemDeductibleTableModel);
			itemDeductibleTableGrid.render('itemDeductibleListing');
		}catch(e){
			showErrorMessage("Item Deductibles - initializeGIPIS100", e);
		}
		
		$("itemDeductibleTextDiv").hide();
		$("itemDeductibleDiv").writeAttribute("style", "width:480px;margin:10px auto 10px auto;");
		$("itemDeductibleDiv2").writeAttribute("style", "height:160px;margin:5px auto 5px auto;width:480px;");
		$("itemDeductibleListing").writeAttribute("style", "height:156px;width:480px;float:left;");
		//$("itemDeductibleDiv").style = "width:418px;margin:10px auto 10px auto;";
		//$("itemDeductibleDiv2").style = "height:160px;margin:5px auto 5px auto;width:418px;";
		//$("itemDeductibleListing").style = "height:156px;width:418px;float:left;";
	}
	
</script>