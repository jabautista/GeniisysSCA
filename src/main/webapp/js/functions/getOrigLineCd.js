/*	Created by	: mark jm 07.08.2011
 * 	Description	: returns the original line cd
 * 	Parameters	: lineCdValue - current line cd
 */
function getOrigLineCd(lineCdValue){
	try{
		var lineCd = "";
		
		for(attr in objLineCds){
			if(attr == lineCdValue || objLineCds[attr] == lineCdValue){
				lineCd = attr;
				break;
			}
		}
		
		return lineCd;
	}catch(e){
		showErrorMessage("getOrigLineCd", e);
	}
}