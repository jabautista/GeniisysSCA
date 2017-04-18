/**
 * Set Selected Intermediary
 * @author rencela
 * @param intmNo
 * @return
 */
function setSelectedIntermediary(intmNo){
	try{
		var opts = $("selIntermediary").options;
		for(var i=0; i < opts.length; i++){
			if(opts[i].readAttribute("value") == intmNo){
				opts[i].setAttribute("selected", "selected");
				return true;
			}
		}
	}catch(e){
		// showErrorMessage("setSelectedIntermediary", e);
	}
	return false;
}