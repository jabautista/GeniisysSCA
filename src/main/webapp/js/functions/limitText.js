//modified by J. Diago 9.18.2013 para macatch yung value if after ni user magedit sa editor overlay, ginalaw nya pa yung field ng page na mismo.
//common na nangyayari kapag 4000 plus characters na.
function limitText(limitField, limitNum) {
	//edited by steven 11.12.2013 
	if(ojbGlobalTextArea.origValue.length >= (limitNum-1)){ 
		if (limitField.value.length > limitNum) {
	    	limitField.value = ojbGlobalTextArea.origValue;
	    	limitField.blur();
	    	showMessageBox('You have exceeded the maximum number of allowed characters ('+limitNum+') for this field.', imgMessage.INFO);
	    	return false;
	    } else {
	    	ojbGlobalTextArea.origValue = limitField.value;
	    }
	}else{
		if (limitField.value.length > limitNum) {
	    	limitField.value = limitField.value.substring(0, limitNum);
	    	ojbGlobalTextArea.origValue = limitField.value;
	    	limitField.blur();
	    	showMessageBox('You have exceeded the maximum number of allowed characters ('+limitNum+') for this field.', imgMessage.INFO);
	    	return false;
	    }else {
	    	ojbGlobalTextArea.origValue = limitField.value;
	    }
	}
}