<div id="leadPolicyDiv">
	<div id="itemTableGridSectionDiv" style="">
			<input type="hidden" id="hidItemPolicyId2" name="hidItemPolicyId2"/>
			<input type="hidden" id="hidItemNo2" name="hidItemNo2"/>
			<input type="hidden" id="hidPerilViewType2" name="hidPerilViewType2"/>
			<input type="hidden" id="itemGrp2" name="itemGrp2"/>
			<input type="hidden" id="hidGIPIS100ItemNo" name="hidGIPIS100ItemNo"/> <!-- added by robert -->
			<div style="">
				<div id="itemTableGridDiv" style="height:156px;width:810px;margin:10px auto 10px auto;">
					<div id="itemListing" style="height:156px;width:100%;"></div>
				</div>
			</div>
			
			<div>
				<div id="yourDiv" class="sectionDiv" style="width:400px;height:100px;padding:5px;">
					<div style="margin:0px auto 5px auto" align="center">
						<div id="" class="toolbar">
							<center id="yourShareHeader" style="margin:2.5px auto auto auto;font-weight:bold;">Your Share</center>
						</div>
						<table cellspacing="10" style="margin:5px auto 5px auto;">
							<tr>
								<td class="rightAligned">TSI</td>
								<td>
									<input type="text" id="txtYourTsiAmt" name="txtYourTsiAmt" class="rightAligned" readonly="readonly"/>
								</td>
								<td>Premium</td>
								<td>
									<input type="text" id="txtYourPremAmt" name="txtYourPremAmt" class="rightAligned" readonly="readonly"/>
								</td>
							</tr>
							<tr>
								<td colspan="5" id="tdYourCurrency">Currency</td>
							</tr>
						</table>
					</div>
				</div>
			
				<div id="fullDiv" class="sectionDiv" style="width:400px;height:100px;padding:5px;">
					<div style="margin:0px auto 5px auto" align="center">
						<div id="" class="toolbar">
							<center id="" style="margin:2.5px auto auto auto;font-weight:bold;">Full Share</center>
						</div>
						<table cellspacing="10" style="margin:5px auto 5px auto;">
							<tr>
								<td class="rightAligned">TSI</td>
								<td>
									<input type="text" id="txtFullTsiAmt" name="txtFullTsiAmt" readonly="readonly"/>
								</td>
								<td>Premium</td>
								<td>
									<input type="text" id="txtFullPremAmt" name="txtFullPremAmt" readonly="readonly"/>
								</td>
							</tr>
							<tr>
								<td colspan="5" id="tdFullCurrency">Currency</td>
							</tr>
						</table>
					</div>
				</div> 
			</div>
			
			<div id="itmPerilsDiv" style="width:825px;height:156px;float:left;"></div>
			
			<div style="float:left;width:820px;">
				<table style="margin:10px auto 10px auto;">
					<tr>
						<td class="rightAligned" style="padding-right: 5px;">Peril Description</td>
						<td width="500px">
							<input type="text" id="txtLeadPolicyPerilDesc" name="txtLeadPolicyPerilDesc" style="width:98%" readonly="readonly"/>
						</td>
						
					</tr>
					<tr>
						<td class="rightAligned" style="padding-right: 5px;">Remarks</td>
						<td>
							<textArea  id="txtItemPerilRemarks" name="txtItemPerilRemarks" style="width:98%; resize:none;" readonly="readonly"></textArea>
						</td>
						
					</tr>
					<tr>
						<td colspan="2">
							<div align="center" style="margin-top: 10px;">
								<input type="button" class="button" id="btnReturn" value="Return" style="width:100px;"/>
								<input type="button" class="button" id="btnInvoice" value="Invoice" style="width:100px;"/>
							</div>
						</td>
					</tr>
					
				</table>
			</div>
	</div>
</div>

<div id="leadPolicyInvoice"></div>
<script>
	var moduleId = $F("hidModuleId"); // added by Kris 03.13.2013
	
	//initialization
	var objItem = new Object();
	objItem.objItemListTableGrid = JSON.parse('${gipiRelatedItemInfoTableGrid}'.replace(/\\/g, '\\\\'));
	objItem.objItemList = objItem.objItemListTableGrid.rows || [];
	
	moduleId == "GIPIS101" ? initializeGIPIS101() : initializeGIPIS100();
	
	// tablegrid for GIPIS100 
	function initializeGIPIS100(){
		try{
			var itemTableModel = { //robert 10.07.2013 added parameter pageCalling
				url:contextPath+"/GIPIItemMethodController?action=refreshRelatedItemInfo&pageCalling=policyItemInfo&policyId="+$F("hidPolicyId")
					,
				options:{
						title: '',
						width: '810px',
						
						onCellFocus: function(element, value, x, y, id){

							loadItemInfo(itemTableGrid.geniisysRows[y]);
							getItmPerils(itemTableGrid.geniisysRows[y].policyId,
									itemTableGrid.geniisysRows[y].itemNo);
							itemTableGrid.releaseKeys();
						},
						onRemoveRowFocus:function(element, value, x, y, id){
							
							unloadItemInfo();
							itemTableGrid.releaseKeys();
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
							id: 'itemNo',
							title: 'Item No',
							width: '100%',
							visible: true
						},
						{
							id: 'itemTitle',
							title: 'Item Name',
							width: '697%',
							visible: true
						},
						
						
				],
				rows:objItem.objItemList
			};

			itemTableGrid = new MyTableGrid(itemTableModel);
			itemTableGrid.render('itemListing');
		}catch(e){
			showErrorMessage("Lead Policy - initializeGIPIS100", e);
		}
		
		if(itemTableGrid.geniisysRows[0] != null){		
			getItmPerils(itemTableGrid.geniisysRows[0].policyId,itemTableGrid.geniisysRows[0].itemGrp);
			loadItemInfo(itemTableGrid.geniisysRows[0]);	
		}
	} // end of initializeGIPIS100

	

	//tablegrid-option function definitions 
	function loadItemInfo(item){	
		try{
			$("txtYourTsiAmt").value 		= formatCurrency(item.tsiAmt);
			$("txtYourPremAmt").value 		= formatCurrency(item.premAmt);
			$("tdYourCurrency").innerHTML 	= item.currencyDesc;
			$("tdFullCurrency").innerHTML 	= item.currencyDesc;
			$("hidGIPIS100ItemNo").value	= item.itemNo;
			if(moduleId != "GIPIS101"){
				$("hidItemPolicyId2").value		= item.policyId;
				$("itemGrp2").value				= item.itemGrp;
			}			
		}catch(e){
			showErrorMessage("loadItemInfo", e);
		}	
	}
	
	
	function unloadItemInfo(){
		$("itmPerilsDiv").innerHTML 	= "";
		$("txtYourTsiAmt").value 		= "";
		$("txtYourPremAmt").value 		= "";
		$("tdYourCurrency").innerHTML 	= "";
		$("tdFullCurrency").innerHTML 	= "";
		$("txtFullPremAmt").value 		= "";
		$("txtFullTsiAmt").value 		= "";

		$("txtLeadPolicyPerilDesc").value	= "";
		$("txtItemPerilRemarks").value 		= "";

		if(moduleId != "GIPIS101"){
			$("hidItemPolicyId2").value		= "";
			$("itemGrp2").value				= "";
		}	
		
	}
	
	// modified by Kris 03.13.2013 for GIPIS101
	function getItmPerils(policyOrExtractId, itemNo){
		if(moduleId == "GIPIS101") {
			/*new Ajax.Updater("itmPerilsDiv","GIPIOrigItmPerilController?action=getItmPerils",{
				method		:"get",
				evalScripts	: true,
				parameters	: {
								extractId	:		policyOrExtractId,
								itemNo		:		itemNo
				}						
			});	 */
		} else {
			new Ajax.Updater("itmPerilsDiv","GIPIOrigItmPerilController?action=getItmPerils",{
				method:"get",
				evalScripts: true,
				parameters: {
					policyId:		policyOrExtractId,
					itemNo:			itemNo
				}
						
			});	
		}		
	}


	//button actions
	$("btnReturn").observe("click", function(){
		overlayLeadPolicy.close();		
	});

	$("btnInvoice").observe("click", function(){
		
		
		if($("leadInvoiceDiv") == null){
			new Ajax.Updater("leadPolicyInvoice","GIPIInvoiceController?action=showPremiumColl",{
				method:"get",
				evalScripts: true,
				parameters: {
					policyId 	: $("hidPolicyId").value,
					pageCalling	: "policyLeadOverlay"
				}
						
			});
		}
		$("leadPolicyDiv").hide();
		$("leadPolicyInvoice").show();
		
		/**
		
		overlayLeadPolicyInvoice = Overlay.show(contextPath+"/GIPIInvoiceController", {
			urlContent: true,
			urlParameters: {
				action 	 	: "showPremiumColl",
				policyId 	: $("hidPolicyId").value,
				pageCalling	: "policyLeadOverlay"
			},
			title: "Lead Policy",
			width: 825,
			height: 500,
			draggable: true
		});

		**/

		
	});
	
	
	
	// function for GIPIS101
	function initializeGIPIS101(){
		try{
			var itemTableModel = {
				url: contextPath + "/GIXXItemController?action=getGIXXItemInfo&refresh=1&extractId="+$F("hidExtractId")
					,
				options:{
						title: '',
						width: '810px',						
						onCellFocus: function(element, value, x, y, id){
							loadItemInfo(itemTableGrid.geniisysRows[y]);
							getItmPerils(itemTableGrid.geniisysRows[y].extractId,
										 itemTableGrid.geniisysRows[y].itemNo);
							itemTableGrid.releaseKeys();
						},
						onRemoveRowFocus:function(element, value, x, y, id){							
							unloadItemInfo();
							itemTableGrid.releaseKeys();
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
							id: 'itemNo',
							title: 'Item No',
							width: '100%',
							visible: true
						},
						{
							id: 'itemTitle',
							title: 'Item Name',
							width: '697%',
							visible: true
						}
				],
				rows:objItem.objItemList
			};

			itemTableGrid = new MyTableGrid(itemTableModel);
			itemTableGrid.render('itemListing');
		}catch(e){
			showErrorMessage("Lead Policy - initializeGIPIS101", e);
		}
		
		if(itemTableGrid.geniisysRows[0] != null){		
			getItmPerils(itemTableGrid.geniisysRows[0].extractId,itemTableGrid.geniisysRows[0].itemGrp);
			loadItemInfo(itemTableGrid.geniisysRows[0]);	
		}
		
		$("yourShareHeader").innerHTML = "Your Share " + $F("hidDspRate");
	} // end of initializeGIPIS101
	
</script>