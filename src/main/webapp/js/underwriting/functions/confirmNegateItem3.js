function confirmNegateItem3(){
	var count = 0;
	
	objFormMiscVariables.miscNbtInvoiceSw = "Y";
	if (objUWParList.binderExist == "Y" && objFormMiscVariables.miscNbtInvoiceSw == "Y"){
		showMessageBox("This PAR has corresponding records in the posted tables for RI. Could not proceed.", imgMessage.ERROR);		
		objFormMiscVariables.miscNbtInvoiceSw = "N";
		return false;
	}
	
	if(objParPolbas.prorateFlag == "2" && (new Date(objParPolbas.endtExpiryDate) <= new Date(objParPolbas.effDate))){
		showMessageBox("Your endorsement expiry date is equal to or less than your effectivity date. " +
				"Restricted condition.", imgMessage.ERROR);
		return false;
	}		
	
	$$("div#endtPerilTable div[name='rowEndtPeril']").each(function(row){		
		if(row.getAttribute("item") == $F("itemNo")){				
			count += 1;				
		}			
	});

	if(count > 0){
		showConfirmBox("Peril", "Existing perils for this item will be automatically deleted. " +
                    "Do you want to continue?", "Yes", "No", function(){globalNegate = "Y"; $("btnRetrievePerils").click();}/*negateDeleteItem*/, stopProcess); //modified by edgar 01/22/2015
	}else{
		globalNegate = "Y"; //edgar 01/21/2015
		$("btnRetrievePerils").click();
		//negateDeleteItem(); edgar 01/21/2015
	}
}