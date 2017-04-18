/**
 * Sets the required field for endt fire additional information form
 * @author andrew
 * @date 05.19.2011
 */
function setEndtFIAddlRequiredFields(recFlag){
	try {
		if(recFlag == "A"){
			$("tariffZone").addClassName("required");
			$("tarfCd").addClassName("required");
			$("front").addClassName("required");
			$("right").addClassName("required");
			$("left").addClassName("required");
			$("rear").addClassName("required");
			$("frontDiv").addClassName("required");
			$("rightDiv").addClassName("required");
			$("leftDiv").addClassName("required");
			$("rearDiv").addClassName("required");
		} else {
			$("tariffZone").removeClassName("required");
			$("tarfCd").removeClassName("required");
			$("front").removeClassName("required");
			$("right").removeClassName("required");
			$("left").removeClassName("required");
			$("rear").removeClassName("required");
			$("frontDiv").removeClassName("required");
			$("rightDiv").removeClassName("required");
			$("leftDiv").removeClassName("required");
			$("rearDiv").removeClassName("required");
		}
	} catch (e){
		showErrorMessage("setEndtFIAddlRequiredFields", e);
	}
}