//emman 08.10.2010
//This function returns a default value if specified value of the element is blank, otherwise, returns the original value of the element
//This is the counterpart of NVL function in PLSQL
//Parameters: val - the original value of the element, dflt - the default value if element is blank
//edited by robert SR 20425 09.24.15: removed String(val).blank() to prevent error when the specified value of the element is space/s only
function nvl(val, dflt) {
	return (/*String(val).blank() || */val == undefined || val == null || val == "undefined" || val == "" || val == "null") ? dflt : val; //nok added val==null
}