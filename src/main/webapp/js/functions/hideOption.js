/*
 * Created by	: Bryan
 * Date			: October 8, 2010
 * Description	: Hides an option in the select element and makes it non-keyboard-navigable
 * Parameter	: option - the option object itself 
 */
function hideOption(option){
	option.hide();
	option.disabled = true;
}