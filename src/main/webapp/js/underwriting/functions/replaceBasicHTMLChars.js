/*	Created by	: mark jm 02.11.2011
 * 	Description	: replace html codes to entity
 * 	Parameters	: str - source data
 */
function replaceBasicHTMLChars(str) {
	if(str == null){ // andrew - 02.25.2011- added condition to skip replace if string is null
		return null;
	}
	return (((str.replace(/&#039;/g, "'")).replace(/&#34;/g, "\"")).replace(/&#62;/g, ">").replace(/&#60;/g, "<").replace("/&#38;/g", "&"));
}