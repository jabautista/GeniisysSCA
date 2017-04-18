/*
 * Created by	: Jerome Orio
 * Date			: January 27, 2011
 * Description 	: Set value based on pre-text attribute value
 * Parameters	: id - id 
 */
function backToPreTextValue(id){
	$(id).value = $(id).getAttribute("pre-text");
}