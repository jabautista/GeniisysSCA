/*	Created by	: mark jm 01.24.2011
 * 	Description	: enabled and show options list
 */
function reloadItemLOV(){
	var lineCd = getLineCd();
	
	
	if(lineCd == "MC"){
		(($("mortgageeName").childElements()).invoke("show")).invoke("removeAttribute", "disabled");
		(($("selAccessory").childElements()).invoke("show")).invoke("removeAttribute", "disabled");
	}
}