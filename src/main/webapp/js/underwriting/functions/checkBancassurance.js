/* Created by	: Jerome Orio
 * Date			: November 24, 2010
 * Description	: to check if it has bancassurance		
 */
function checkBancassurance(){
	if ($("bancaTag").checked){
		enableButton("btnBancaDetails");
		$("bancaDetailsDiv").show();
	}else{
		disableButton("btnBancaDetails");
		$("bancaDetailsDiv").hide();
	}		
}	