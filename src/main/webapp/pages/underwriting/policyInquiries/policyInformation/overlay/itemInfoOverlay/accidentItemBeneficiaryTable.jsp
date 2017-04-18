<div style="margin-top:15px;">
	<div style="height:160px;width:748px;margin:0px auto 0px auto;">
			<div id="accidentItemBeneficiaryListing" style="height:156px;width:748px;float:left;"></div>
	</div>
	<div style="width:500px;margin:10px auto 0px auto">
		<table style="width:500px;">
			<tr>
				<td style="width:50px; padding-right: 5px;">Address</td>
				<td>
					<input type="text" id="accidentItemBeneficiaryAddress" style="width:95%;" readonly="readonly"/>
				</td>
				<td class="rightAligned" style="width:40px; padding-right: 5px;">Age</td>
				<td style="width:40px">
					<input type="text" id="accidentItemBeneficiaryAge" style="width:95%" readonly="readonly"/>
				</td>
			</tr>
		</table>
	</div>
	<div style="margin-top:10px;text-align:center">
		<input type="button" class="button" id="btnReturnFromAccidentItemBeneficiaryTable" value="Ok" style="width:100px;"/>
	</div>
</div>
<script>
	var moduleId = $F("hidModuleId");
	//initialization
	var objAccidentItemBeneficiary = new Object();
	objAccidentItemBeneficiary.objAccidentItemBeneficiaryListTableGrid = JSON.parse('${accidentItemBeneficiaryList}'.replace(/\\/g, '\\\\'));
	objAccidentItemBeneficiary.objAccidentItemBeneficiaryList = objAccidentItemBeneficiary.objAccidentItemBeneficiaryListTableGrid.rows || [];
	
	try{
		// added by Kris 03.01.2013 for GIPIS101		
		var gipis101path = "/GIXXBeneficiaryController?action=getGIXXAccidentBeneficiaries" + 
							"&extractId=" + nvl($("hidGroupedItemsExtractId").value,0) +
							"&itemNo="+nvl($("hidGroupedItemsItemNo").value,0) +
							"&refresh=1";
		var gipis100path = "/?action=GIPIBeneficiaryController"+
							"&policyId="+nvl($("hidGroupedItemsPolicyId").value,0)+
							"&itemNo="+nvl($("hidGroupedItemsItemNo").value,0)+
							"&refresh=1";
		
		var accidentItemBeneficiaryTableModel = {
			url:contextPath+ ( moduleId == "GIPIS101" ? gipis101path : gipis100path )
				,
			options:{
					title: '',
					width: '748px',
					onCellFocus: function(element, value, x, y, id){
						$("accidentItemBeneficiaryAddress").value = unescapeHTML2(accidentItemBeneficiaryTableGrid.geniisysRows[y].beneficiaryAddr);
						$("accidentItemBeneficiaryAge").value = accidentItemBeneficiaryTableGrid.geniisysRows[y].age;
						accidentItemBeneficiaryTableGrid.releaseKeys();
					},
					onRemoveRowFocus:function(element, value, x, y, id){
						$("accidentItemBeneficiaryAddress").value = "";
						$("accidentItemBeneficiaryAge").value = "";
						accidentItemBeneficiaryTableGrid.releaseKeys();
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
						id: 'beneficiaryNo',
						title: 'No.',
						width: '50%',
						visible: true
					},
					{
						id: 'beneficiaryName',
						title: 'Name.',
						width: '200%',
						visible: true
					},
					{
						id: 'relation',
						title: 'Relation',
						width: '100%',
						visible: true
					},
					{
						id: 'adultSw',
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
						id: 'meanSex',
						title: 'Sex',
						width: '50%',
						visible: true
					},
					{
						id: 'position',
						title: 'Occupation',
						width: '100%',
						visible: true
					},
					{
						id: 'meanCivilStatus',
						title: 'Status',
						width: '100%',
						visible: true
					},
					{
						id: 'dateOfBirth',
						title: 'Birthday',
						width: '100%',
						visible: true
					}					
			],
			rows:objAccidentItemBeneficiary.objAccidentItemBeneficiaryList
		};
	
		accidentItemBeneficiaryTableGrid = new MyTableGrid(accidentItemBeneficiaryTableModel);
		accidentItemBeneficiaryTableGrid.render('accidentItemBeneficiaryListing');
	}catch(e){
		showErrorMessage("Item Beneficiary", e);
	}

	$("btnReturnFromAccidentItemBeneficiaryTable").observe("click", function(){
		overlayAccidentBeneficiaryTable.close();
	});
</script>
