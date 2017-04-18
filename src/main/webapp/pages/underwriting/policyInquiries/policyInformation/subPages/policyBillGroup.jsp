
<div id="policyBillGroupMainDiv" style="border: none; margin:10px auto 20px auto;">
	<div id="relatedItemForBillDiv" name="relatedItemForBillDiv" style="border: none;"></div>
	<!-- Rey 08-03-2011  -->
	<div id="policyPerilGroupList" name="policyPerilGroupList" style="border: none;"></div>
	<div id="policyTaxGroupList" name="policyTaxGroupList" style="border: none;"></div>
	<div id="policyPaymentSchedule" name="policyPaymentSchedule" style="border: none;"></div>
	<div id="policyInvoiceCommission" name="policyInvoiceCommission" style="border: none;"></div>
	<div id="policyDiscountSurcharge" name="policyDiscountSurcharge" style="border: none;"></div>
</div>
<script>
	
	searchRelatedItemInfoForBillGroup();
	function searchRelatedItemInfoForBillGroup(){
		new Ajax.Updater("relatedItemForBillDiv","GIPIItemMethodController?action=getRelatedItemInfo&pageCalling=policyBillGroup",{
			method:"get",
			evalScripts: true,
			parameters:{policyId : $F("hidPolicyId")}
		});
	}
		//rey 07-28-2011
	//showBillPerilPage({policyId : $F("hidPolicyId")});
		//rey 08-03-2011	
	//showBillTaxPage({policyId : $F("hidPolicyId")});
	
</script>