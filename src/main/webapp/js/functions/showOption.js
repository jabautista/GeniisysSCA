/*
 * Created by	: Bryan
 * Date			: October 8, 2010
 * Description	: Shows an option in the select element and makes it keyboard-navigable
 * Parameter	: option - the option object itself 
 */
function showOption(option){
	option.show();
	option.disabled = false;
}