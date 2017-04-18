/**
 * Get current year
 * @author royencela 05.03.2011
 * @returns {Integer} - Current Year in yyyy format
 */
function getCurrentYear(){
	try{
		var sysDate = new Date();
		return sysDate.getFullYear();
	} catch(e) {
		showErrorMessage("getCurrentYear", e);
	}
}