/*	Created by	: Jerome Orio 11.17.2010
 * 	Description	: check if company or employee is required or not
 * 	Parameters	: 
 */
function checkCompanyEmployee(){
	if ($F("companyCd") != "" || $F("employeeCd") != ""){
		$("companyCd").addClassName("required");
		$("employeeCd").addClassName("required");
	}else{
		$("companyCd").removeClassName("required");
		$("employeeCd").removeClassName("required");
	}		
}