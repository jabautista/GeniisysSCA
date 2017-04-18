//created by steven 7/29/2013
function limitText2(limitField, limitNum, origValue) { 
    if (limitField.value.length > limitNum) {
    	limitField.value = origValue;
    	limitField.blur();
    	showMessageBox('You have exceeded the maximum number of allowed characters ('+limitNum+') for this field.', imgMessage.INFO);
    }else{
    	origValue = limitField.value;
    }
    return origValue;
}