function toggleEditableOtherDetails(toggle){
	try{
		$("btnRemarks").stopObserving("click");
		if(toggle){
			enableDate("hrefInspectDate");
			enableInputField("inspectPlace");	
			enableSearch("dspAdjusterDescIcon");
			
			enableInputField("remarks");	
			$("btnRemarks").observe("click", function(){
				showEditor("remarks", 2000);
			});
		}else{
			disableDate("hrefInspectDate");
			disableInputField("inspectPlace");	
			disableSearch("dspAdjusterDescIcon");
			
			disableInputField("remarks");	
			$("btnRemarks").observe("click", function(){
				showEditor("remarks", 2000, "true");
			});
		}
		
	}catch(e){
		showErrorMessage("toggleEditableOtherDetails");
	}
}