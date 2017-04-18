/*	Created by	: mark jm 10.04.2010
 * 	Description	: returns item object based on lineCd 
 */
function getItemObjects(){
	try{
		var lineCd = getLineCd();
		var itemObjects = new Object();
		
		if(lineCd == "MC" || lineCd == "FI" || lineCd == "AC" || lineCd == "CA" || lineCd == "EN"|| lineCd == "AV" || lineCd == "MN" || lineCd == "MH"){
			itemObjects = objGIPIWItem;		
		}else if(lineCd == "CA"){
			itemObjects = objEndtCAItems;
		} else if(lineCd == "MN"){
			itemObjects = objEndtMNItems;
		} else if(lineCd == "MH"){
			itemObjects = objEndtMHItems;
		} /* else if(lineCd == "EN"){
			itemObjects = objEndtENItems;
		}*/
		
		return itemObjects;
	}catch(e){
		showErrorMessage("getItemObjects", e);
		//showMessageBox("getItemObjects : " + e.message);
	}	
}