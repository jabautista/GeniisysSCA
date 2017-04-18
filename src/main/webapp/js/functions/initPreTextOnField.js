/*
 * Created by	: Jerome Orio
 * Date			: February 23, 2011
 * Description 	: generate pre-text on field
 * Parameters	: id - id field
 */
function initPreTextOnField(id){
	var preText = "";
	$(id).observe("focus", function(){
		$(id).setAttribute("pre-text", $(id).value);
	});
	/*$(id).observe("keyup", function(){ commented out by christian
		if (getPreTextValue(id) != $(id).value) setPreText(id, ""); 
	});*/		
	$(id).setAttribute("pre-text", $(id).value);
}