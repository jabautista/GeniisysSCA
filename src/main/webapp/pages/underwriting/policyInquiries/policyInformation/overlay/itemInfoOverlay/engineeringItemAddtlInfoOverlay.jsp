<div>
	<div align="center" style="margin-top:5px">
		<div style="width:650px;">
			<table style="width:650px;">
				<tr>
					<td class="rightAligned" style="width:115px;">Item No.</td>
					<td>
						<input type="text" id="txtEngineeringItemItemNo" style="width:70px;" readonly="readonly"/>
						<input type="text" id="txtEngineeringItemItemTitle" style="width:435px;" readonly="readonly"/>
					</td>
				</tr>
			</table>
		</div>
		
		<div align="right" style="width:650px;">
			<div style="height:156px;width:525px;margin:5px 6px 5px auto;">
				<div id="enDeductibleListing" style="height:156px;width:525px;"></div>
			</div>
		</div>
		
		<div style="width:650px;">
			<table style="width:650px;">
				<tr>
					<td class="rightAligned" style="width:116px;">Deductible Text</td>
					<td>
						<textArea id="txtEngineeringItemDeductText" style="width:517px; resize: none;" readonly="readonly"></textArea>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Deductible Amount</td>
					<td>
						<input class="rightAligned" type="text" id="txtEngineeringItemDeductAmt" readonly="readonly"/>
					</td>
				</tr>
			</table>
		</div>
		
	</div>
	<div style="margin-top:10px;text-align:center">
		<input type="button" class="button" id="btnReturnFromEngineeringItemAddtlinfo" value="Item Information" style="width:150px;"/>
		<input type="button" class="button" id="btnEngineeringItemPicOrVid" value="View Picture or Video" style="width:150px;"/>
	</div>
	
	
</div>
<script>
	$("btnReturnFromEngineeringItemAddtlinfo").observe("click", function(){
		overlayEngineeringItemAdditionalInfo.close();
	});

	var objEnItem = JSON.parse('${enItem}'.replace(/\\/g, '\\\\'));
	if (objEnItem.itemNo == undefined){
		$("txtEngineeringItemItemNo").value = "";
	}else{
		$("txtEngineeringItemItemNo").value = objEnItem.itemNo;
	}
	if (objEnItem.itemTitle == undefined){
		$("txtEngineeringItemItemTitle").value = "";
	}else{
		$("txtEngineeringItemItemTitle").value = unescapeHTML2(objEnItem.itemTitle);
	}
	
	try {
		var objEnDeductible = new Object();
		objEnDeductible.objEnDeductibleListTableGrid = JSON.parse('${enDeductibles}'.replace(/\\/g, '\\\\'));
		objEnDeductible.objEnDeductibleList = objEnDeductible.objEnDeductibleListTableGrid.rows || [];
	}catch(e){

	}
	
	// added by Kris 03.05.2013 for GIPIS101
	var moduleId = $F("hidModuleId");
	var gipis100path = "/?action=getEnDeductibles"+
						"&policyId="+$("hidItemPolicyId").value+
						"&itemNo="+$("hidItemNo").value;
	var gipis101path = "/GIXXDeductiblesController?action=getGIXXEnDeductibles&refresh=1" + 
						"&extractId=" + $F("hidItemExtractId") +
						"&itemNo=" + $F("hidItemNo");
	
	try{
		var enDeductibleTableModel = {
			url:contextPath+ ( moduleId == "GIPIS101" ? gipis101path : gipis100path )
				,
			options:{
					title: '',
					width: '525px',
					onCellFocus: function(element, value, x, y, id){
						$("txtEngineeringItemDeductText").value = unescapeHTML2(enDeductibleTableGrid.geniisysRows[y].deductibleText);
						$("txtEngineeringItemDeductAmt").value = formatCurrency(enDeductibleTableGrid.geniisysRows[y].deductibleAmt);
					},
					onRemoveRowFocus:function(element, value, x, y, id){
						$("txtEngineeringItemDeductText").value = "";
						$("txtEngineeringItemDeductAmt").value  = "";
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
						id: 'itemTitle',
						title: 'itemTitle',
						width: '0px',
						visible: false
					},
					{
						id: 'deductibleTitle',
						title: 'Deductibles',
						width: '507px',
						visible: true
					},
	
					{
						id: 'deductibleText',
						title: 'deductibleText',
						width: '0px',
						visible: false
					},
	
					{
						id: 'deductibleAmt',
						title: 'deductibleAmt',
						width: '0px',
						visible: false
					},
					
					
			],
			rows:objEnDeductible.objEnDeductibleList
		};
	
		enDeductibleTableGrid = new MyTableGrid(enDeductibleTableModel);
		enDeductibleTableGrid.render('enDeductibleListing');
	}catch(e){
		showErrorMessage("enDeductibleTableModel", e);
	}

	$("btnEngineeringItemPicOrVid").observe("click", function(){
		showAttachmentList();
	});
	//try{
		//$("txtEngineeringItemItemNo").value 	= enDeductibleTableGrid.getValueAt(3,0);
		//$("txtEngineeringItemItemTitle").value 	= enDeductibleTableGrid.getValueAt(4,0);
	//}catch(e){}
</script>