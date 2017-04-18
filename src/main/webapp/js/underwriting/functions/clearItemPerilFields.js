function clearItemPerilFields(){
	try {
		$("perilCd").value 				= "";
		$("txtPerilCd").value			= "";
		$("perilRate").value 		    = "";//0.000000000;
		//$("perilTsiAmt").value			= 0.00;
		$("perilTsiAmt").value			= "";
		$("premiumAmt").value			= ""; //0.00;
		$("compRem").value				= "";
		$("compRemRi").value			= "";
		$("perilTarfCd").value			= "";
		$("perilAnnTsiAmt").value		= 0.00;
		$("perilAnnPremAmt").value		= 0.00;
		$("perilPrtFlag").value			= "";
		$("perilRiCommRate").value		= "";//0.000000000; 
		$("perilRiCommAmt").value		= "";//0.00; 
		$("perilSurchargeSw").value		= "";
		$("perilBaseAmt").value			= "";
		$("perilAggregateSw").value		= "";
		$("perilDiscountSw").value		= "";
		$("perilNoOfDays").value		= "";
		
		$("riCommRt").value 			= formatToNineDecimal(0);
		$("perilType").value 			= "";
		$("bascPerlCd").value 			= "";
		$("wcSw").value 				= "";
		$("perilTarfCd").value 			= "";
		$("defaultRate").value 			= formatToNineDecimal(0);
		showPerilTarfOption(null);
		$("perilTarfCd").hide();
		$("selPerilTarfCd").show();
		$("perilCd").show();
		$("txtPerilName").hide();
		$("tempPerilCd").value			= "";
		$("tempPerilRate").value 		= 0.000000000;
		$("tempTsiAmt").value			= 0.00;
		$("tempPremAmt").value			= 0.00;
		$("tempCompRem").value			= "";
		
		$("btnAddItemPeril").value = "Add";
		$("btnDeletePeril").removeClassName("button");
		$("btnDeletePeril").addClassName("disabledButton");
		$("btnDeletePeril").disable();
		
		$("chkAggregateSw").checked = false;
		$("chkDiscountSw").checked = false;
		$("chkSurchargeSw").checked = false;
		$$("div[name='row2']").each(function (r)	{
			r.removeClassName("selectedRow");
		});
		$("chkAggregateSw").disabled = false;
		$("perilRate").readOnly = false;
		$("perilTsiAmt").readOnly = false;
		$("premiumAmt").readOnly = false;
		$("compRem").readOnly = false;
		$("perilBaseAmt").readOnly = false;
		$("perilNoOfDays").readOnly = false;
		$("varPerilTsiAmt").value = "";
		$("dumPerilCd").value = "";	
	} catch (e){
		showErrorMessage("clearItemPerilFields", e);
	}
}