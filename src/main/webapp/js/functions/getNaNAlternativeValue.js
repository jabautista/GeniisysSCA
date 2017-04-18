/*
 * Created by 	: emman 09.28.2010
 * Description 	: Returns a default value if specified value is NaN
 * Parameters 	: val - The value to be checked
 * 				  dflt - The default value to be returned if val is NaN 
 */
function getNaNAlternativeValue(val, dflt) {
	return isNaN(val) ? dflt : val;
}
