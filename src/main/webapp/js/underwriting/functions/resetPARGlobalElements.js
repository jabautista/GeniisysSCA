/**
 * @author irwin tabisora
 * */
function resetPARGlobalElements(){
	try{
		$("globalParId").value = "0";
		$("globalQuoteId").value = "0";
		$("globalParStatus").value = "0";
		$("globalPolFlag").value = "0";
		$("globalOpFlag").value = "0";
		
	}catch(e){
		showErrorMessage("resetUnderwritingGlobalElements",e);
	}
}