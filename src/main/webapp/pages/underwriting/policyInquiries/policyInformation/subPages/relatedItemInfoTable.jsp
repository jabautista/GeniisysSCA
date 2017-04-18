
<div id="polItemInfoTableGridSectionDiv" style="height:200px;">
		<input type="hidden" id="hidItemPolicyId" name="hidItemPolicyId"/>
		<input type="hidden" id="hidItemExtractId" name="hidItemExtractId"/> <!-- added by Kris 02.27.2013 -->
		<input type="hidden" id="hidItemPackLineCd" name="hidItemPackLineCd"/> <!-- added by Kris 03.14.2013 -->
		<input type="hidden" id="hidItemNo" name="hidItemNo"/>
		<input type="hidden" id="hidPerilViewType" name="hidPerilViewType"/>
		<input type="hidden" id="hidItemType" name="hidItemType"/>
		<div id="polItemInfoTableGridDiv" style="padding:10px;height:200px;">
			<div id="polItemInfoListing" style="height:156px;width:100%;"></div>
		</div>
</div>
<script>
	var moduleId = $F("hidModuleId");
	var objItem = new Object();
	objItem.objItemListTableGrid = JSON.parse('${gipiRelatedItemInfoTableGrid}'.replace(/\\/g, '\\\\'));
	objItem.objItemList = objItem.objItemListTableGrid.rows || [];
	
	moduleId == "GIPIS101" ? initializeGIPIS101() : initializeGIPIS100();
	
	function initializeGIPIS100(){
		try{
			var itemTableModel = {	//gzelle 06.27.2013 added parameter pageCalling
				url:contextPath+"/GIPIItemMethodController?action=refreshRelatedItemInfo&refresh=1&pageCalling=policyItemInfo&policyId="+$F("hidPolicyId")
						+ "&pageSize=" + objItem.objItemList.length  // added by pol cruz 01.09.2015
					,
				options:{
						title: '',
						width: '900px',
						onCellFocus: function(element, value, x, y, id){
							loadItemInfo(itemTableGrid.geniisysRows[y]);
							getItemPerils(itemTableGrid.geniisysRows[y].policyId,
									itemTableGrid.geniisysRows[y].itemNo,
									itemTableGrid.geniisysRows[y].perilViewType);
							
							itemTableGrid.keys.removeFocus(itemTableGrid.keys._nCurrentFocus, true);
							itemTableGrid.keys.releaseKeys();
						},
						onRemoveRowFocus:function(element, value, x, y, id){
							unloadItemInfo();
						},
						onSort: function() {	//Gzelle 06.15.2013
							unloadItemInfo();	
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
							width: '0px%',
							visible: false
						},
						{
							id: 'perilViewType',
							title: 'perilViewType',
							width: '0px%',
							visible: false
						},
						{
							id: 'itemNo',
							title: 'Item No',
							width: '50%',
							visible: true,
							align: 'right',
							titleAlign: 'center'
						},
						{	id: 'itemTitle',
							title: 'Title',
							width: '120%'//,		Gzelle 06.14.2013
							//sortable: false
						},
						{	id: 'tsiAmt',
							title: 'TSI Amount',
							width: '100%',
							align: 'right',
							titleAlign: 'right',
							//sortable: false,		Gzelle 06.14.2013
							filterOption: true,
							geniisysClass : 'money',     
				            geniisysMinValue: '-999999999999.99',     
				            geniisysMaxValue: '999,999,999,999.99'
							
						},
						{	id: 'itemDesc',
							title: 'Description1',
							width: '121%',
							filterOption: true
						},
						{	id: 'itemDesc2',
							title: 'Description2',
							width: '121%',
							filterOption: true
						},
						{	id: 'coverageDesc',
							title: 'Coverage',
							width: '130%',
							filterOption: true
						},
						{	id: 'premAmt',
							title: 'Prem Amount',
							width: '100%',
							align: 'right',
							titleAlign: 'right',
							filterOption: true,
							geniisysClass : 'money',     
				            geniisysMinValue: '-999999999999.99',     
				            geniisysMaxValue: '999,999,999,999.99'
						},
						{	id: 'currencyDesc',
							title: 'Currency',
							width: '100%',
							filterOption: true
						},
						{	id: 'currencyRt',
							title: 'Rate',
							width: '30%',
							filterOption: true
						},
				],
				rows:objItem.objItemList
			};

			itemTableGrid = new MyTableGrid(itemTableModel);
			itemTableGrid.render('polItemInfoListing');
		}catch(e){
			showErrorMessage("initializeGIPIS100", e);
		}
	}
	
	function loadItemInfo(item){
		$("txtItemNo").value 		= item.itemNo;
		$("txtItemTitle").value 	= unescapeHTML2(item.itemTitle);
		$("txtItemDesc").value 		= unescapeHTML2(item.itemDesc); //added by steven 1/14/2013
		$("txtItemDesc2").value 	= unescapeHTML2(item.itemDesc2); //added by steven 1/14/2013
		$("txtCurrencyDesc").value 	= item.currencyDesc;
		$("txtCurrencyRt").value 	= formatToNineDecimal(item.currencyRt);
		$("txtCoverageDesc").value 	= item.coverageDesc;
		$("txtPackLineCd").value 	= item.packLineCd;
		$("txtPackSubLineCd").value = item.packSublineCd;
		$("txtSumInsured").value 	= formatCurrency(item.tsiAmt);
		$("txtPremium").value 		= formatCurrency(item.premAmt);
		
		if($F("hidModuleId") != "GIPIS101"){ // modified by Kris 02.20.2013
			$("txtAnnSumInsured").value = formatCurrency(item.annTsiAmt);	
			$("txtAnnPremium").value 	= formatCurrency(item.annPremAmt); 
		} else {
			$("hidItemExtractId").value  = item.extractId;
			$("hidItemPackLineCd").value = item.packLineCd;
		}
		$("hidItemPolicyId").value  = item.policyId; 
		$("hidItemNo").value 		= item.itemNo;
		$("hidPerilViewType").value = item.perilViewType;
		$("hidItemType").value 		= item.itemType;
		$("hidItemOtherInfo").value = unescapeHTML2(item.otherInfo);
		
		if(item.packPolFlag.toUpperCase() == "Y"){
			$("tdRow7Column4ItemInfo").innerHTML = "Line/Subline";
			$("txtPackLineCd").show();
			$("txtPackSubLineCd").show();
		}
		if ($("chkSurchargeSw").value == item.surchargeSw){
			$("chkSurchargeSw").checked = true;
		}else{
			$("chkSurchargeSw").checked = false;
		}
		if ($("chkDiscountSw").value == item.discountSw){
			$("chkDiscountSw").checked = true;
		}else{
			$("chkDiscountSw").checked = false;
		}		
	}	
	
	function unloadItemInfo(){
		
		$("txtItemNo").value		= ""; 
		$("txtItemTitle").value		= "";
		$("txtItemDesc").value		= "";
		$("txtItemDesc2").value		= "";
		$("txtCurrencyDesc").value	= "";		
		$("txtCurrencyRt").value	= "";
		$("txtCoverageDesc").value	= "";
		$("txtPackLineCd").value	= "";
		$("txtPackSubLineCd").value	= "";
		$("txtSumInsured").value 	= "";
		$("txtPremium").value 		= "";
		if($F("hidModuleId") != "GIPIS101"){ // modified by Kris 02.20.2013 
			$("txtAnnSumInsured").value = "";
			$("txtAnnPremium").value 	= "";
		} else {
			$("hidItemExtractId").value  = "";
		}
		$("chkSurchargeSw").checked = false;
		$("chkDiscountSw").checked 	= false;

		$("hidItemPolicyId").value  = ""; 
		$("hidItemNo").value 		= "";
		$("hidPerilViewType").value = "";
		$("hidItemType").value 		= "";

		$("hidItemOtherInfo").value = "";
		clearItemPerilDiv();
	}
	
	
	function getItemPerils(policyId,itemNo,perilViewType){
		// added by Kris 02.26.2013: option for GIPIS101
		var gipis101Url = "GIXXItemPerilController?action=getGIXXItemPeril&extractId=" + policyId  + //+$F("hidExtractId") + 
						  "&packPolFlag=" + $F("hidPackPolFlag") + "&lineCd=" + $F("hidLineCd") + "&packLineCd=" + $F("hidItemPackLineCd");
		var gipis100Url = "GIPIItemPerilController?action=getItemPerils";
		
		//new Ajax.Updater("itemPerilDiv","GIPIItemPerilController?action=getItemPerils",{
		new Ajax.Updater("itemPerilDiv",(moduleId == "GIPIS101" ? gipis101Url : gipis100Url),{
				method:"get",
				evalScripts: true,
				parameters: {
				policyId:		policyId,
				itemNo:			itemNo,
				perilViewType:	perilViewType
			}
		});
		$("mainInfoSectionDiv").writeAttribute("style","margin:10px auto 5px auto;");
	}
	
	function clearItemPerilDiv(){
		$("itemPerilDiv").innerHTML = "";
		returnMainInfoDivAttribute();
	}
	
	function initializeGIPIS101(){
		try{
			var itemTableModel = {
				url:contextPath+"/GIXXItemController?action=getGIXXItemInfo&refresh=1&extractId=" + $F("hidExtractId") + "&policyId="+$F("hidPolicyId")
					,
				options:{
						title: '',
						width: '900px',
						onCellFocus: function(element, value, x, y, id){
							loadItemInfo(itemTableGrid.geniisysRows[y]);
							getItemPerils(itemTableGrid.geniisysRows[y].extractId,
									itemTableGrid.geniisysRows[y].itemNo,
									itemTableGrid.geniisysRows[y].perilViewType);
							
							itemTableGrid.keys.removeFocus(itemTableGrid.keys._nCurrentFocus, true);
							itemTableGrid.keys.releaseKeys();
						},
						onRemoveRowFocus:function(element, value, x, y, id){
							unloadItemInfo();
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
							width: '0px%',
							visible: false
						},
						{
							id: 'perilViewType',
							title: 'perilViewType',
							width: '0px%',
							visible: false
						},
						{
							id: 'itemNo',
							title: 'Item No',
							width: '50%',
							visible: true,
							align: 'right',
							titleAlign: 'center'
						},
						{	id: 'itemTitle',
							title: 'Title',
							width: '120%',		
							sortable: false
						},
						{	id: 'tsiAmt',
							title: 'TSI Amount',
							width: '100%',
							align: 'right',
							titleAlign: 'right',
							sortable: false,		
							filterOption: true,
							geniisysClass : 'money',     
				            geniisysMinValue: '-999999999999.99',     
				            geniisysMaxValue: '999,999,999,999.99'
							
						},
						{	id: 'itemDesc',
							title: 'Description1',
							width: '121%',
							filterOption: true
						},
						{	id: 'itemDesc2',
							title: 'Description2',
							width: '121%',
							filterOption: true
						},
						{	id: 'coverageDesc',
							title: 'Coverage',
							width: '130%',
							filterOption: true
						},
						{	id: 'premAmt',
							title: 'Prem Amount',
							width: '100%',
							align: 'right',
							titleAlign: 'right',
							filterOption: true,
							geniisysClass : 'money',     
				            geniisysMinValue: '-999999999999.99',     
				            geniisysMaxValue: '999,999,999,999.99'
						},
						{	id: 'currencyDesc',
							title: 'Currency',
							width: '100%',
							filterOption: true
						},
						{	id: 'currencyRt',
							title: 'Rate',
							width: '30%',
							filterOption: true
						},
				],
				rows:objItem.objItemList
			};

			itemTableGrid = new MyTableGrid(itemTableModel);
			itemTableGrid.render('polItemInfoListing');
		}catch(e){
			showErrorMessage("initializeGIPIS101", e);
		}
	}
	

</script>