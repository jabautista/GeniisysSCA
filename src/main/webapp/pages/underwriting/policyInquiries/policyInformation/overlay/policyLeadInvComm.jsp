<div id="invCommDiv">

	<div id="invCommYourDiv" class="sectionDiv" style="width:393px;height:20px;padding:5px;">
		<div style="margin:0px auto 5px auto" align="center">
			<div id="" class="toolbar">
				<center id="" style="margin:2.5px auto auto auto;font-weight:bold;">Your Share</center>
			</div>
		</div>
	</div>
	<div id="invCommFullDiv" class="sectionDiv" style="width:393px;height:20px;padding:5px;">
		<div style="margin:0px auto 5px auto" align="center">
			<div id="" class="toolbar">
				<center id="" style="margin:2.5px auto auto auto;font-weight:bold;">Full Share</center>
			</div>
		</div>
	</div>
</div>
<div id="invCommTableDiv" style="height:190px;"></div>
<div id="commInvPerilTableDiv" style="height:190px;"></div>

<div style="float:left;width:810px;margin:20px auto 20px auto;text-align:center;">
	<input type="button" class="button" id="btnReturnFromInvComm" name="btnReturnFromInvComm" value="Return" style="width:130px;"/>
</div>

<script>
//button actions 

loadInvoiceCommissionsTableGrid( $("hidPolLeadInvoicePolicyId").value, $("hidPolLeadInvoiceItemGrp").value );

$("btnReturnFromInvComm").observe("click", function(){
	
	$("invCommContentDiv").hide();
	$("invoiceContentDiv").show();
	
});
</script>