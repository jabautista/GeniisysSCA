<div>
	<div style="width:668px;margin:10px auto 10px auto;">
		<table style="width:668px;">
			<tr>
				<td class="rightAligned" style="width:75px; padding-right: 5px;">Enrollee</td>
				<td>
					<input type="text" id="txtCoverageEnrolleeCode" style="width:80px;" readonly="readonly"/>
					<input type="text" id="txtCoverageEnrolleeName" style="width:472px;" readonly="readonly"/>
				</td>
			</tr>
		</table>
	</div>
	
	<div style="margin:10px auto 0px auto;width:668px;">
		<table style="width:668px;">
			<tr>
				<td class="rightAligned" style="width:75px; padding-right: 5px;">TSI Amount</td>
				<td style="width:300px;">
					<input type="text" id="txtCoverageSumTsiAmt" readonly="readonly" style="width: 150px; text-align: right;"/>
				</td>
				<td class="rightAligned" style="width:105px; padding-right: 5px;">Premium Amount</td>
				<td>
					<input type="text" id="txtCoverageSumPremAmt" readonly="readonly" style="width: 150px; text-align: right;"/>
				</td>
			</tr>
		</table>
	</div>
	<div style="height:160px;margin:10px auto 0px auto;width:668px;">
		<div id="accidentItmPerilGroupedListing" style="height:156px;width:668px;float:left;"></div>
	</div>
	<div style="margin:10px auto 0px auto;width:668px;">
		<table style="width:668px;">
			<tr>
				<td class="rightAligned" style="width:75px; padding-right: 5px;" >No of Days</td>
				<td style="width:300px;">
					<input type="text" id="txtCoverageNoOfDays" readonly="readonly" style="width: 150px; text-align: right;"/>
				</td>
				<td class="rightAligned" style="width:105px; padding-right: 5px;">Base Amount</td>
				<td>
					<input type="text" id="txtCoverageBaseAmount" readonly="readonly" style="width: 150px; text-align: right;"/>
				</td>
			</tr>
		</table>
	</div>
	<div style="margin:10px auto 10px auto;text-align:center">
		<input type="button" class="button" id="btnReturnFromAccidentItemCoverage" name="btnReturnFromAccidentItmPerilGroupeds" value="Ok" style="width:150px;" readonly="readonly"/>
	</div>
	
</div>
	
<script>

	//initialization
	var objEnrollee = JSON.parse('${enrollee}'.replace(/\\/g, '\\\\'));
	if (objEnrollee.enrolleeCode == undefined){
		$("txtCoverageEnrolleeCode").value = "";
	}else{
		$("txtCoverageEnrolleeCode").value = objEnrollee.enrolleeCode;
	}
	if (objEnrollee.enrolleeCode == undefined){
		$("txtCoverageEnrolleeName").value = "";
	}else{
		$("txtCoverageEnrolleeName").value = unescapeHTML2(objEnrollee.enrolleeName);
	}

	var objAccidentItmPerilGrouped = new Object();
	objAccidentItmPerilGrouped.objAccidentItmPerilGroupedListTableGrid = JSON.parse('${itmperilGroupList}'.replace(/\\/g, '\\\\'));
	objAccidentItmPerilGrouped.objAccidentItmPerilGroupedList = objAccidentItmPerilGrouped.objAccidentItmPerilGroupedListTableGrid.rows || [];
	
	try{
		var accidentItmPerilGroupedTableModel = {
			url:contextPath+"/?action=getItmPerilGroupedList"+
			"&policyId="+$("hidGroupedItemsPolicyId").value+
			"&itemNo="+$("hidGroupedItemsItemNo").value+
			"&groupedItemNo="+$("hidGroupedItemsGroupedItemNo").value+
			"&refresh=1"
				,
			options:{
					title: '',
					width: '668px',
					onCellFocus: function(element, value, x, y, id){
						$("txtCoverageNoOfDays").value = accidentItmPerilGroupedTableGrid.geniisysRows[y].noOfDays;
						$("txtCoverageBaseAmount").value = formatCurrency(accidentItmPerilGroupedTableGrid.geniisysRows[y].baseAmt);
						accidentItmPerilGroupedTableGrid.releaseKeys();
					},
					onRemoveRowFocus:function(element, value, x, y, id){
						$("txtCoverageNoOfDays").value = "";
						$("txtCoverageBaseAmount").value = "";
						accidentItmPerilGroupedTableGrid.releaseKeys();
					}
			},
			columnModel:[
			 		{   
				 		id: 'recordStatus',
					    title: '',
					    width: '0px',
					    visible: false,
					    editor: 'checkbox' 			
					},
					{	
						id: 'divCtrId',
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
						id: 'groupedItemNo',
						title: 'groupedItemNo',
						width: '0px',
						visible: false
					},
					{
						id: 'sumTsiAmt',
						title: 'sumTsiAmt',
						width: '0px',
						visible: false
					},
					{
						id: 'sumPremAmt',
						title: 'sumPremAmt',
						width: '0px',
						visible: false
					},
					{
						id: 'perilName',
						title: 'Peril Name',
						width: '300%',
						visible: true
					},
					{
						id: 'premRt',
						title: 'Peril Rate',
						width: '80%',
						visible: true
					},
					{
						id: 'premAmt',
						title: 'Premium Amount',
						width: '120%',
						visible: true
					},
					{
						id: 'tsiAmt',
						title: 'TSI Amount',
						width: '120%',
						visible: true
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
					
			],
			rows:objAccidentItmPerilGrouped.objAccidentItmPerilGroupedList
		};
	
		accidentItmPerilGroupedTableGrid = new MyTableGrid(accidentItmPerilGroupedTableModel);
		accidentItmPerilGroupedTableGrid.render('accidentItmPerilGroupedListing');
	}catch(e){
		showErrorMessage("Accident Grouped Item Coverage", e);
	}
	try{
		$("txtCoverageSumTsiAmt").value = formatCurrency(accidentItmPerilGroupedTableGrid.getValueAt(5,0));
		$("txtCoverageSumPremAmt").value = formatCurrency(accidentItmPerilGroupedTableGrid.getValueAt(6,0));
	}catch(e){}
	

	
	$("btnReturnFromAccidentItemCoverage").observe("click", function(){
		overlayAccidentItemCoverage.close();
	});
</script>