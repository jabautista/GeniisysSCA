//moved from carrierInformation.jsp
function setCarrierInfoForm(bool, row){
	try {
		if(!bool){
			$("inputVessel").selectedIndex = 0;
			$("inputVesselDisplay").clear();
			$("inputVesselDisplay").hide();
			$("inputVessel").show();
			$("inputVesselFlag").value = "";
		} else {
			var s = $("inputVessel");
			var rowSelected;
			for (var i=0; i<s.length; i++)	{
				
				if (s.options[i].value == row.down("input", 0).value)	{
					s.selectedIndex = i;
					rowSelected = row.down("input", 1).value;
				}
			}
			s.hide();
			$("inputVesselDisplay").value = rowSelected;
			$("inputVesselDisplay").show();
			$("inputVesselFlag").value = row.down("input", 3).value;
		}
		
		//$("inputVesselFlag").value = (!bool ? "" : row.down("input", 3).value);
		
		//(!bool ? $("inputVessel").enable() : $("inputVessel").disable());
		(row == null ? enableButton("btnAdd") : disableButton("btnAdd"));
		(row == null ? disableButton("btnDelete") : enableButton("btnDelete"));
	} catch(e){
		showErrorMessage("setCarrierInfoForm", e);
	}
}