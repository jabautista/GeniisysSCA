	
<div id="policyPremCollDiv" style="width:776px;margin:20px auto 0px auto;">
	<div>
		<input type="hidden" id="hidInvIssCd" name="hidInvIssCd" readonly="readonly"/>
		<input type="hidden" id="hidInvPremSeqNo" name="hidInvPremSeqNo" readonly="readonly"/>
		<input type="hidden" id="hidPremCollMode" name="hidPremCollMode" readonly="readonly">
	</div>
	<div id="policyInvoiceDiv" style="margin-bottom:10px;">
		<div style="height:156px;">
			<div id="policyInvoiceListing" style="height:156px;"></div>
		</div>
		
	</div>

	<div id="relatedCollsDiv" style="height:305px;"></div>
	
	<div style="margin-top:20px;text-align:right;height:50px;">
		Total:
		<input type="text" id="txtTotalPrem" name="txtTotalPrem" style="width:145px; text-align: right;" readonly="readonly"/>
		<input type="text" id="txtTotalTaxOrComm" name="txtTotalTaxOrComm" style="width:145px; text-align: right;" readonly="readonly"/>
		<input type="text" id="txtTotalCollection" name="txtTotalCollection" style="width:145px; text-align: right;" readonly="readonly"/>
	</div>
	
	<div class="sectionDiv" style="margin-bottom:20px;">
		<table style="width:80%;margin-left:auto;margin-right:auto;">
			<tr>
				<td>Particulars</td>
				<td colspan="3">
					<!-- <input type="text" id="txtParticulars" name="txtParticulars" style="width:98.7%;" readonly="readonly"/> -->
					<div style="float:left; width: 576px; height: 20px;" class="withIconDiv">
						<textarea class="withIcon" id="txtParticulars" name="txtParticulars" style="width: 540px; resize:none;" readonly="readonly"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editParticulars" />
					</div>
				</td>
			</tr>
			<tr>
				<td>User ID</td>
				<td>
					<input type="text" id="txtUserId" name="txtUserId" style="width:200px;" readonly="readonly"/>
				</td>
				<td class="rightAligned" style="width: 150px;">Last Update</td>
				<td>
					<input type="text" id="txtLastUpdate" name="txtLastUpdate" style="width:200px;" readonly="readonly"/>
				</td>
			</tr>
		</table>
	</div>
	
</div>

<script>
/*
	var objPolicyInvoice = JSON.parse('${policyInvoice}'.replace(/\\/g, '\\\\'));
	$("txtInvIssCd").value			=		 objPolicyInvoice.issCd;
	$("txtInvPremSeqNo").value		=		 objPolicyInvoice.premSeqNo;
	$("hidPremCollMode").value		=		 objPolicyInvoice.premCollMode;

	searchRelatedColls(objPolicyInvoice.premCollMode);
	*/	
	searchRelatedColls2();
	
	function loadInvoiceInfo(invoice){
		$("hidInvIssCd").value			= invoice.issCd;
		$("hidInvPremSeqNo").value		= invoice.premSeqNo;
		$("hidPremCollMode").value		= invoice.premCollMode;
	}
	function unloadInvoiceInfo(){
		
		$("hidInvIssCd").value			= "";
		$("hidInvPremSeqNo").value		= 0;
		$("hidPremCollMode").value		= "";

		$("txtTotalPrem").value			= "";
		$("txtTotalTaxOrComm").value	= "";
		$("txtTotalCollection").value	= "";

		$("txtParticulars").value		= "";
		$("txtUserId").value			= "";
		$("txtLastUpdate").value		= "";

	}

	$("editParticulars").observe("click", function(){
		showEditor("txtParticulars", 500, 'true');
	});
	
	function searchRelatedColls(collMode){

		if(collMode == "INWFACUL"){
			var url = "GIACInwFaculPremCollnsController?action=getRelatedInwPremColl";
		}else{
			var url = "GIACDirectPremCollnsController?action=getRelatedDirectPremColl";
		}
		
		new Ajax.Updater("relatedCollsDiv",url,{
			method:"get",
			evalScripts: true,
			parameters:{
				policyId 	:	$F("hidPolicyId"),
				lineCd	 	:	$F("hidLineCd"),
				issCd 	 	:	$F("hidInvIssCd"),
				premSeqNo	:	$F("hidInvPremSeqNo")
			}
		});
	}
	
	function searchRelatedColls2(){

			var url = "GIACDirectPremCollnsController?action=getRelatedDirectPremColl";
		
		new Ajax.Updater("relatedCollsDiv",url,{
			method:"get",
			evalScripts: true,
			parameters:{
				policyId 	:	nvl($F("hidPolicyId"),null),
				lineCd	 	:	nvl($F("hidLineCd"),""),
				issCd 	 	:	nvl($F("hidInvIssCd"),""),
				premSeqNo	:	nvl($F("hidInvPremSeqNo"),0)
			}
		});
	}
	
	
	/*****************************************************************************************/
	
	var objPolicyInvoice = new Object();
	objPolicyInvoice.objPolicyInvoiceListTableGrid = JSON.parse('${invoiceList}'.replace(/\\/g, '\\\\'));
	objPolicyInvoice.objPolicyInvoiceList = objPolicyInvoice.objPolicyInvoiceListTableGrid.rows || [];
	
	try{
		var policyInvoiceTableModel = {
			url:contextPath+"/GIPIInvoiceController?action=showPremiumColl"+
			"&policyId="+$F("hidPolicyId")+
			"&refresh=1",
			options:{
					title: '',
					width: '252',
					onCellFocus: function(element, value, x, y, id){
						//$("txtDeductibleText").value = policyInvoiceTableGrid.geniisysRows[y].deductibleText;
						loadInvoiceInfo(policyInvoiceTableGrid.geniisysRows[y]);
						searchRelatedColls(policyInvoiceTableGrid.geniisysRows[y].premCollMode);
						policyInvoiceTableGrid.keys.removeFocus(policyInvoiceTableGrid.keys._nCurrentFocus, true);
						policyInvoiceTableGrid.keys.releaseKeys();	
						//$("relatedCollsDiv").show();
					},
					onRemoveRowFocus:function(element, value, x, y, id){
						//$("txtDeductibleText").value = "";
						$("relatedCollsDiv").innerHTML = "";
						//$("relatedCollsDiv").hide();
						unloadInvoiceInfo();
						searchRelatedColls2();
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
						title: 'Policy id',
						width: '0px',
						visible: false
					},
					{
						id: 'issCd',
						title: 'Iss Cd',
						width: '120px',
						visible: true
					},
					{
						id: 'premSeqNo',
						title: 'Prem Seq No',
						width: '120px',
						visible: true,
						renderer : function(value){
		                	return formatNumberDigits(value,12);
			   			}
					},
					
			],
			rows:objPolicyInvoice.objPolicyInvoiceList
		};

		policyInvoiceTableGrid = new MyTableGrid(policyInvoiceTableModel);
		policyInvoiceTableGrid.render('policyInvoiceListing');
	}catch(e){
		showErrorMessage("Prem Colln tab", e);
	}
	
</script>