
<div id="invTaxDiv">
	<div id="invTaxYourDiv" class="sectionDiv" style="width:393px;height:20px;padding:5px;">
		<div style="margin:0px auto 5px auto" align="center">
			<div id="" class="toolbar">
				<center id="" style="margin:2.5px auto auto auto;font-weight:bold;">Your Share</center>
			</div>
		</div>
	</div>
			
	<div id="invTaxFullDiv" class="sectionDiv" style="width:393px;height:20px;padding:5px;">
		<div style="margin:0px auto 5px auto" align="center">
			<div id="" class="toolbar">
				<center id="" style="margin:2.5px auto auto auto;font-weight:bold;">Full Share</center>
			</div>
		</div>
	</div>
</div>
	
<div id="invTaxTableDiv" style="height:190px;"></div>

<div style="float:left;width:810px;margin:20px auto 20px auto;text-align:center;">
	<input type="button" class="button" id="btnReturnFromInvTax" name="btnReturnFromInvTax" value="Return" style="width:130px;"/>
</div>

<script>
	
	loadInvTaxTableGrid( $("hidPolLeadInvoicePolicyId").value, $("hidPolLeadInvoiceItemGrp").value );

	//button actions 
	$("btnReturnFromInvTax").observe("click", function(){
		
		$("taxContentDiv").hide();
		$("invoiceContentDiv").show();
		
	});
	
</script>