/**
 * Description: Disables edit icon
 * Date Created : 12.18.2013
 * @author Ildefonso Ellarina Jr
 * */
function disableEdit(imgId){
	try {
		if($(imgId).next("img",0) == undefined){
			var alt = new Element("img");
			alt.alt = 'Go';
			alt.src = contextPath + "/images/misc/disabledEdit.png";
			alt.setStyle({ 
			  float: 'right'
			});
			$(imgId).hide();
			$(imgId).insert({after : alt});			
		}		
	} catch(e){
		showErrorMessage("disableEdit", e);
	}	
};