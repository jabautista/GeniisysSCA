/*
 * Created by	: Jerome Orio
 * Date			: May 04, 2012
 * Description 	: Clear all pre-text attribute
 * Parameters	:  
 */
function clearAllPreTextAttribute(){
	$$("input[type='text'], input[type='hidden'], select").each(function (m) {
		m.setAttribute("pre-text", "");
	});	
}