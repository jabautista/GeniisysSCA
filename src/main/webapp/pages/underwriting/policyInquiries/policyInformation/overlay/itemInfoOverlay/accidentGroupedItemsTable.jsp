
<div>
	
	<div id="div2" style="height:210px;margin:10px auto 0px auto;width:780px;">
			<div id="accidentGroupedItemListing" style="height:190px;width:750px;float:left;"></div>
	</div>
	
	<div id="div3" style="width:750px;margin:10px auto 0px auto;">
		<table id="table1" style="width:750px;" border="0">
			<tr>
				<td id="col1" class="rightAligned" style="width:65px; padding-right: 5px;">Sex</td>
				<td colspan="3" style="width:200px;">
					<input type="text" id="txtAccidentItemSex" style="width:200px;" readonly="readonly"/>
				</td>
				<td id="col3" class="rightAligned" style="width:300px; padding-right: 5px;">Control Type</td>
				<td>
					<input type="text" id="txtAccidentItemControlType" style="width:200px;" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 5px;">Birthday</td>
				<td style="width:25px;">
					<input type="text" id="txtAccidentItemBirthday" style="width:95%;" readonly="readonly"/>
				</td>
				<td class="rightAligned" style="width:5%;padding-right: 5px;">Age</td>
				<td style="width:10px;">
					<input type="text" id="txtAccidentItemAge" style="width:65%" readonly="readonly" class="rightAligned" />
				</td>
				<td class="rightAligned" style="padding-right: 5px;">Control Code</td>
				<td>
					<input type="text" id="txtAccidentItemControlCode" style="width:200px;" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 5px;">Status</td>
				<td colspan="3">
					<input type="text" id="txtAccidentItemStatus" style="width:200px;" readonly="readonly"/>
				</td>
				<td class="rightAligned" style="padding-right: 5px;">Salary</td>
				<td>
					<input type="text" id="txtAccidentItemSalary" style="width:200px;" readonly="readonly" class="rightAligned" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 5px;">Occupation</td>
				<td colspan="3">
					<input type="text" id="txtAccidentItemOccupation" style="width:200px;" readonly="readonly"/>
				</td>
				<td class="rightAligned" style="padding-right: 5px;">Salary Grade</td>
				<td>
					<input type="text" id="txtAccidentItemSalaryGrade" style="width:200px;" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 5px;">Group</td>
				<td colspan="3">
					<input type="text" id="txtAccidentItemGroup" style="width:200px;" readonly="readonly"/>
				</td>
				<td class="rightAligned" style="padding-right: 5px;">Amount Covered</td>
				<td>
					<input type="text" id="txtAccidentItemAmountCovered" style="width:200px;" readonly="readonly" class="rightAligned" />
				</td>
			</tr>
		</table>
	</div>
	<div style="margin: 10px auto auto auto;text-align:center">
		<input type="button" class="button" id="btnReturnFromAccidentGroupedItems" name="btnReturnFromAccidentGroupedItems" value="Ok" style="width:150px;" readonly="readonly"/>
		<input type="button" class="button" id="btnAccidentItemBeneficiary" value="Beneficiary" style="width:150px;" readonly="readonly"/>
		<input type="button" class="button" id="btnAccidentItemCoverage" value="Coverage" style="width:150px;" readonly="readonly"/>
	</div>
	
	
</div>
<script>
//initialization
	var enrollee = new Object();
	var moduleId = $F("hidModuleId");
	
	var objAccidentGroupedItem = new Object();
	objAccidentGroupedItem.objAccidentGroupedItemListTableGrid = JSON.parse('${accidentGroupedItems}'.replace(/\\/g, '\\\\'));
	objAccidentGroupedItem.objAccidentGroupedItemList = objAccidentGroupedItem.objAccidentGroupedItemListTableGrid.rows || [];

	moduleId == "GIPIS101" ? initializeGIPIS101() : initializeGIPIS100();

	// function to create table grid for GIPIS100
	function initializeGIPIS100(){
		try{
			var accidentGroupedItemTableModel = {
				url:contextPath+"/GIPIGroupedItemsController?refresh=1&action=getAccidentGroupedItems"+
				"&policyId="+$("hidItemPolicyId").value+
				"&itemNo="+$("hidItemNo").value
					,
				options:{
						title: '',
						width: '780px',
						toolbar: {
							elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
						},
						onCellFocus: function(element, value, x, y, id){
							loadAccidentGroupedItem(accidentGroupedItemsTableGrid.geniisysRows[y]);
							accidentGroupedItemsTableGrid.releaseKeys();
						},
						onRemoveRowFocus:function(element, value, x, y, id){
							unloadAccidentGroupedItem();
							accidentGroupedItemsTableGrid.releaseKeys();
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
							id: 'includeTag',
							title: 'I',
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
							visible: true,
							sortable: false
						},
						{
							id: 'groupedItemNo',
							title: 'Enrollee Code',
							width: '85%',
							visible: true,
							filterOptionType: 'integerNoNegative',
							filterOption: true
						},
						{
							id: 'groupedItemTitle',
							title: 'Enrollee Name',
							width: '162%',
							visible: true,
							filterOption: true
						},
						{
							id: 'principalCd',
							title: 'Principal Code',
							width: '90%',
							visible: true
						},
						{
							id: 'packageCd',
							title: 'Plan',
							width: '75%',
							visible: true
						},
						{
							id: 'paytTermsDesc',
							title: 'Payment Mode',
							width: '90%',
							visible: true
						},
						{
							id: 'fromDate',
							title: 'Effectivity',
							width: '100%',
							type: 'date',
							visible: true
						},
						{
							id: 'toDate',
							title: 'Expiry',
							width: '100%',
							type: 'date',
							visible: true
						},
						
				],
				rows:objAccidentGroupedItem.objAccidentGroupedItemList
			};

			accidentGroupedItemsTableGrid = new MyTableGrid(accidentGroupedItemTableModel);
			accidentGroupedItemsTableGrid.pager = objAccidentGroupedItem.objAccidentGroupedItemListTableGrid
			accidentGroupedItemsTableGrid.render('accidentGroupedItemListing');
		}catch(e){
			showErrorMessage("initializeGIPIS100", e);
		}
	}

	$("btnReturnFromAccidentGroupedItems").observe("click", function(){
		$("hidGroupedItemsPolicyId").value		= "";
		$("hidGroupedItemsItemNo").value		= "";
		$("hidGroupedItemsGroupedItemNo").value	= "";
		overlayAccidentGroupedItemsTable.close();
	});
	
	$("btnAccidentItemCoverage").observe("click", function(){
		
		overlayAccidentItemCoverage = Overlay.show(contextPath+"/GIPIItmPerilGroupedController", {
			urlContent: true,
			urlParameters: {
				action 		: "getItmPerilGroupedList",
				policyId		:nvl($F("hidGroupedItemsPolicyId"),0),
				itemNo			:nvl($F("hidGroupedItemsItemNo"),0),
				groupedItemNo	:nvl($F("hidGroupedItemsGroupedItemNo"),0),
				enrollee	: JSON.stringify(enrollee)
			},
			title: "Coverage",
			width: 700,
			height: 350,
			draggable: true
		});
		
	});
	
	$("btnAccidentItemBeneficiary").observe("click", function(){
		
		overlayAccidentGrpItemsBeneficiary = Overlay.show(contextPath+"/GIPIAccidentItemController", {
			urlContent: true,
			urlParameters: {
				action 		: "showGrpItemsBeneficiaryPage",
				enrollee	: JSON.stringify(enrollee)
			},
			title: "Beneficiaries",
			width: 900,
			height: (moduleId == "GIPIS101" ? 300 : 430), // modified by Kris 02.28.2013 to adjust size
			draggable: true
		  });
	});

	function loadAccidentGroupedItem(accidentGroupedItem){
		//var dateOfBirth = Date.parse(accidentGroupedItem.dateOfBirth);

		$("txtAccidentItemSex").value				= unescapeHTML2(accidentGroupedItem.sex);
		$("txtAccidentItemAge").value				= accidentGroupedItem.age;
		$("txtAccidentItemGroup").value				= unescapeHTML2(accidentGroupedItem.groupDesc);
		$("txtAccidentItemStatus").value			= unescapeHTML2(accidentGroupedItem.meanCivilStatus);
		$("txtAccidentItemSalary").value			= formatCurrency(accidentGroupedItem.salary);
		//$("txtAccidentItemBirthday").value			= accidentGroupedItem.dateOfBirth == null ? accidentGroupedItem.dateOfBirth : Date.parse(accidentGroupedItem.dateOfBirth).format('mm-dd-yyyy'); //dateOfBirth.format('mm-dd-yyyy');  //
		$("txtAccidentItemBirthday").value			= nvl(accidentGroupedItem.dateOfBirth, "") == "" ? "" : dateFormat(accidentGroupedItem.dateOfBirth, "mm-dd-yyyy"); // replaced by: Nica 05.15.2013
		$("txtAccidentItemOccupation").value		= unescapeHTML2(accidentGroupedItem.position);
		$("txtAccidentItemSalaryGrade").value		= accidentGroupedItem.salaryGrade;
		$("txtAccidentItemControlCode").value		= accidentGroupedItem.controlCd;
		$("txtAccidentItemControlType").value		= unescapeHTML2(accidentGroupedItem.controlTypeDesc);
		$("txtAccidentItemAmountCovered").value		= formatCurrency(accidentGroupedItem.amountCoverage); //kris 02.28.2013

		$("hidGroupedItemsPolicyId").value		= accidentGroupedItem.policyId;
		$("hidGroupedItemsItemNo").value		= accidentGroupedItem.itemNo;
		$("hidGroupedItemsGroupedItemNo").value	= accidentGroupedItem.groupedItemNo;		
		if(moduleId == "GIPIS101"){ //added by Kris 02.28.2013
			$("hidGroupedItemsExtractId").value		= accidentGroupedItem.extractId;
			enrollee.enrolleeRemarks = accidentGroupedItem.remarks;
		}

		enrollee.enrolleeCode	= accidentGroupedItem.groupedItemNo;
		enrollee.enrolleeName	= accidentGroupedItem.groupedItemTitle;
		
	}
	function unloadAccidentGroupedItem(){
		
		$("txtAccidentItemSex").value				= "";
		$("txtAccidentItemAge").value				= "";
		$("txtAccidentItemGroup").value				= "";
		$("txtAccidentItemStatus").value			= "";
		$("txtAccidentItemSalary").value			= "";
		$("txtAccidentItemBirthday").value			= "";
		$("txtAccidentItemOccupation").value		= "";
		$("txtAccidentItemSalaryGrade").value		= "";
		$("txtAccidentItemControlCode").value		= "";
		$("txtAccidentItemControlType").value		= "";
		$("txtAccidentItemAmountCovered").value		= "";

		$("hidGroupedItemsPolicyId").value		= "";
		$("hidGroupedItemsItemNo").value		= "";
		$("hidGroupedItemsGroupedItemNo").value	= "";
		if(moduleId == "GIPIS101"){ //added by Kris 02.28.2013
			$("hidGroupedItemsExtractId").value		= "";
			enrollee.enrolleeRemarks = "";
		}

		enrollee.enrolleeCode	= "";
		enrollee.enrolleeName	= "";
		
		
	}
	
	
	// functions for GIPIS101 -- added by Kris 02.28.2013
	function initializeGIPIS101(){
		try{
			var accidentGroupedItemTableModel = {
				url:contextPath+"/GIXXGroupedItemsController?action=getGIXXAccidentGroupedItems"+
				"&extractId="+$("hidItemExtractId").value+
				"&itemNo="+$("hidItemNo").value
					,
				options:{
						title: '',
						width: '774px',
						onCellFocus: function(element, value, x, y, id){
							loadAccidentGroupedItem(accidentGroupedItemsTableGrid.geniisysRows[y]);
							accidentGroupedItemsTableGrid.releaseKeys();
						},
						onRemoveRowFocus:function(element, value, x, y, id){
							unloadAccidentGroupedItem();
							accidentGroupedItemsTableGrid.releaseKeys();
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
							id: 'includeTag',
							title: 'I',
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
							id: 'deleteSw',
							title: 'D',
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
							id: 'groupedItemNo',
							title: 'Enrollee Code',
							width: '85%',
							visible: true
						},
						{
							id: 'groupedItemTitle',
							title: 'Enrollee Name',
							width: '162%',
							visible: true
						},
						{
							id: 'principalCd',
							title: 'Principal Code',
							width: '90%',
							visible: true
						},
						{
							id: 'packageCd',
							title: 'Plan',
							width: '75%',
							visible: true
						},
						{
							id: 'paytTermsDesc',
							title: 'Payment Mode',
							width: '90%',
							visible: true
						},
						{
							id: 'fromDate',
							title: 'Effectivity',
							width: '100%',
							type: 'date',
							visible: true
						},
						{
							id: 'toDate',
							title: 'Expiry',
							width: '100%',
							type: 'date',
							visible: true
						},
						
				],
				rows:objAccidentGroupedItem.objAccidentGroupedItemList
			};

			accidentGroupedItemsTableGrid = new MyTableGrid(accidentGroupedItemTableModel);
			accidentGroupedItemsTableGrid.render('accidentGroupedItemListing');
		}catch(e){
			showErrorMessage("initializeGIPIS101", e);
		}
		
		$("div2").writeAttribute("style", "height:160px;margin:10px 10px 10px 10px;width:790px;");
		$("accidentGroupedItemListing").writeAttribute("style", "height:156px;width:790px;float:left;");
		$("div3").writeAttribute("style", "width:790px;margin:10px auto 0px auto;");
		$("table1").writeAttribute("style", "width:775px;");
		$("col1").writeAttribute("style", "width:125px;");
		$("col3").writeAttribute("style", "width:150px;");
		$("btnAccidentItemCoverage").hide();
	}
</script>
	
	