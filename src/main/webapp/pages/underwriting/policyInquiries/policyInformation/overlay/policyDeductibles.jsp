<div id="polDeductiblesInfoTableGridSectionDiv" style="margin:0px auto 0px auto;">
		<div id="polDeductiblesInfoTableGridDiv" style="padding:10px;">
			<div id="polDeductiblesInfoListing" style="height:156px;width:620px;margin:0px auto 0px auto;"></div>
			<div style="text-align:right;margin:0px auto 0px auto;width:620px;">
				Total Deductible Amount&nbsp;&nbsp;<input type="text" id="txtTotalDeductibleAmt" name="txtTotalDeductibleAmt" style="width:148px; text-align: right;" readonly="readonly"/>
			</div>
			<div style="margin:10px auto 0px auto;width:620px;">
				<table style="width:90%;margin:0px auto 0px auto;">
					<tr>
						<td class="rightAligned" style="width:30px; padding-right: 5px;">Text </td>
						<td class="leftAligned">
							<textArea id="txtDeductibleText" name="txtDeductibleText" style="width:99%;resize:none;" readonly="readonly"></textArea>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div style="text-align:center;">
			<input type="button" class="button" id="btnReturn" value="Return" style="width: 100px;"/>
		</div>
</div>
<script>
	
	var objDeductibles = new Object();
	objDeductibles.objDeductiblesListTableGrid = JSON.parse('${policyDeductibles}'.replace(/\\/g, '\\\\'));
	objDeductibles.objDeductiblesList = objDeductibles.objDeductiblesListTableGrid.rows || [];
	
	try{
		var deductiblesTableModel = {
			url:contextPath+"/GIPIDeductiblesController?action=getDeductibles"+
			"&policyId="+$F("hidPolicyId")+
			"&refresh=1",
			options:{
					querySort: false, // added by Nica 05.11.2013 - to sort deductibles
					title: '',
					width: '620',
					onCellFocus: function(element, value, x, y, id){
						$("txtDeductibleText").value = unescapeHTML2(deductiblesTableGrid.geniisysRows[y].deductibleText);
						deductiblesTableGrid.releaseKeys();
					},
					onRemoveRowFocus:function(element, value, x, y, id){
						$("txtDeductibleText").value = "";
						deductiblesTableGrid.releaseKeys();
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
					{	id: 'policyId',
						title: 'Policy id',
						width: '0px',
						visible: false
					},
					{	id: 'totalDeductibleAmt',
						title: 'totalDeductibleAmt',
						width: '0px',
						visible: false
					},
					{	id: 'deductibleText',
						title: 'deductibleText',
						width: '0px',
						visible: false
					},
					{	id: 'aggregateSw',
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
						})
					},
					{	id: 'ceilingSw',
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
						}) 	
					},
					{	id: 'dedDeductibleCd',
						title: 'Code',
						width: '100%',
						visible: true
					},
					/*{	id: 'dedDeductibleCd',
						title: 'Code',
						width: '100%',
						visible: true
					},*/ // removed by: Nica 05.11.2013
					{	//id: 'deductibleName', replaced by: Nica 05.11.2013
						id: 'deductibleName',
						title: 'Deductible Title',
						width: '200%',
						visible: true
					},
					{	id: 'deductibleRt',
						title: 'Rate',
						width: '100%',
						visible: true
					},
					{	id: 'deductibleAmt',
						title: 'Deductible Amount',
						width: '150%',
						visible: true,
						align: "right",
						geniisysClass: "money"
					}
			],
			rows:objDeductibles.objDeductiblesList
		};

		deductiblesTableGrid = new MyTableGrid(deductiblesTableModel);
		deductiblesTableGrid.render('polDeductiblesInfoListing');
		deductiblesTableGrid.afterRender = function(){
			try{
				if(deductiblesTableGrid.geniisysRows.length > 0){
					$("txtTotalDeductibleAmt").value = formatCurrency(deductiblesTableGrid.geniisysRows[0].totalDeductibleAmt);
				}else{
					$("txtTotalDeductibleAmt").value = formatCurrency(0);
				}
			}catch(e){
				showErrorMessage("deductiblesTableGrid.afterRender", e);
			}
		};
	}catch(e){
		showErrorMessage("Policy Deductibles", e);
	}
	//load totals
	try{
	$("txtTotalDeductibleAmt").value = formatCurrency(deductiblesTableGrid.getValueAt(3,0));
	}catch(e){}
	
	$("btnReturn").observe("click", function(){
		overlayDeductibles.close();
	});

</script>