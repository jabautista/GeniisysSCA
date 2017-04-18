/**
 * Checks if the value of the element is a number within the specified bounds
 * @param element ID
 * @param lowerLimit
 * @param upperLimit
 * @param message
 * @param allowDecimals
 * @author rencela
 * @return
 */
function isWithinBounds(id, lowerLimit, upperLimit, message, allowDecimals){
	var value = rtrim($F(id).replace(/^[0]+/g,""));
	var upperLim = parseFloat(upperLimit);
	var lowerLim = parseFloat(lowerLimit);
	var diff = (parseFloat(value) - parseInt(value)) * 1000000000000;
	if( parseFloat(value) < lowerLimit || parseFloat(value) > upperLimit){
		showMessageBox(message, imgMessage.ERROR);
		$(id).value = "";
	} else if(isNaN(value)){
		showMessageBox(message, imgMessage.ERROR);
		$(id).value = "";
	} else if(allowDecimals == false && diff > parseFloat("0.000000000")){
		showMessageBox(message, imgMessage.ERROR);
		$(id).value = "";
	}
} 