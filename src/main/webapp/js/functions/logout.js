/* logout - from mainNav.jsp by whofeih */
function logout(){
	if(changeTag == 1) {		
		if (changeTagFunc == null || changeTagFunc == undefined || changeTagFunc == ""){
			showConfLogOut();
		}else{
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						changeTagFunc();
						logOutOngoing = "Y"; 
					}, 
					function(){
						showConfLogOut();
					}, 
					"");
		}	
	}else{
		showConfLogOut();
	}
	//end Nok   
}