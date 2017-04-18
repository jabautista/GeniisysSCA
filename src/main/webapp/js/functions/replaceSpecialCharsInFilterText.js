/*
 * Created by	: Veronica V. Raymundo
 * Date 	 	: January 31, 2011
 * DesCription	: to replace special characters like *,(,),+,[,\ and ? that causes 
 * 				  unterminated parenthetical error in javascript
 * Parameters	: str - string to be modified
 */

function replaceSpecialCharsInFilterText(str){
	return str.replace(/\[/g, "[\[]").replace(/\(/g, "[(]").replace(/\)/g, "[)]").replace(/\+/g, "[+]").
			   replace(/\*/g, "[*]").replace(/\?/g, "[?]").replace(/\\/g, "[\]");
}