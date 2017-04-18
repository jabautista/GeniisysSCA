function togglePerilTariff(perilCd) {
	try {
		$$("select[name='inputPerilTariff']").each(function (select)	{		
			if(select.getAttribute("id") == "inputPerilTariff"+perilCd){
				select.show();
			} else {
				select.hide();
			}
		});
	} catch(e){
		showErrorMessage("togglePerilTariff", e);
	}
}