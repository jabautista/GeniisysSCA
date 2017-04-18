function deleteDiscounts(){
	try {
		$("delDiscSw").value = "Y";
		$("deldiscItemNos").value = $F("deldiscItemNos") + ($F("deldiscItemNos") == "" ? "" : " ") + $F("itemNo");
		//objUWParList.discExists = "N";
		$("hidDiscountExists").value = "N";
		parItemDeleteDiscount(true);
		disableButton("btnDeleteDiscounts");
		$("chkDiscountSw").checked = false;
		
		$$("label[name='discountSwPeril']").each(function (label)	{
				label.innerHTML = '<span style="float: right; width: 10px; height: 10px;">-</span>';
		});

	} catch (e){
		showErrorMessage("deleteDiscounts", e);
	}
}