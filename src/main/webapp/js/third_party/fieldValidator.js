function validateField(id, name){
	var el = $(id);
	var error = '';
	if(el.value==""||el.value=="0"||el.value=="NA"){
		//alert(el.type+el.name)
		if(el.type=="select"){
			applyErrorColorsSelect(el);
		}else{
			applyErrorColors(el);
		}
		
		error = name+" is required \n";
	}
	return error;
}

function noSingleChar(id, name){
	var el = $(id);
	var error = '';
	if(el.value.trim<1){
			applyErrorColors(el);
		error = name+" is requires at least 2 chars. \n";
	}
	return error;
}

// email checker
function validateEmail(str) {
	var at="@";
	var dot=".";
	var lat=str.indexOf(at);
	var lstr=str.length-1;
	var ldot=str.indexOf(dot);
	if (str.indexOf(at)==-1){
	   return false;
	}
	if (str.indexOf(at)==-1 || str.indexOf(at)==0 || str.indexOf(at)==lstr){
	   return false;
	}

	if (str.indexOf(dot)==-1 || str.indexOf(dot)==0 || str.indexOf(dot)==lstr){
		return false;
	}

	 if (str.indexOf(at,(lat+1))!=-1){
	   return false;
	 }

	 if (str.substring(lat-1,lat)==dot || str.substring(lat+1,lat+2)==dot){
	   return false;
	 }

	 if (str.indexOf(dot,(lat+2))==-1){
	    return false;
	 }
		
	 if (str.indexOf(" ")!=-1){
	   return false;
	 }

	 return true;

}
		
function applyErrorColors(el){
	el.style.border = "1px solid #CF3339";
	el.style.background = "#FFFF66";
	el.onfocus = function () {
		el.style.border = "1px solid #999999";
		el.style.background = "#FFFF66";
	};
}

function applyErrorColorsSelect(el){
	el.style.border = "1px solid #CF3339";
	el.style.background = "#FFFF66";
	el.onfocus = function () {
		el.style.background = "#FFFF66";
	};
}

//INPUT RESTRICTIONS
var phone = "+()- 0123456789loc";
var numb = "0123456789";
var money = numb+".,";
var alpha = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZñÑ";
var email = numb+alpha+"_-@.\\";
var posNumb = alpha+'-';
var answer = alpha+numb+" .-,";
var receipt = alpha+numb+"-";
var relationship = alpha+".- ";
var posN = alpha+numb+"/-,.' \n";
var posN2 = alpha+numb+"-/.,' \n";
var posTIN = numb+"- ";
var posA = alpha+numb+"' .-,\n";

function res(t,v){
	var w = "";
	for (i=0; i < t.value.length; i++) {
		x = t.value.charAt(i);
		if (v.indexOf(x,0) != -1)
			w += x;
	}
	w = w.replace("  "," ").replace(" ,",",");
	t.value = ltrim(w);
}

function res(t,v, moduleCd, uSwitch){
	//alert(t+", "+v+", "+moduleCd+", "+uSwitch);
	var position = 	doGetCaretPosition(t);
	if (moduleCd){
		if (moduleCd.value!= undefined){
	 		moduleCd = moduleCd.value;
		}
	}
	var w = "";
	for (i=0; i < t.value.length; i++) {
		x = t.value.charAt(i);
		if (v.indexOf(x,0) != -1)
			w += x;	
	}
	if (moduleCd == 'L005'||moduleCd == 'L007'||moduleCd == 'L001'||moduleCd == 'L002'||moduleCd == 'L003'||
		moduleCd == 'L010'||
		moduleCd == 'P001'||moduleCd == 'P002'||moduleCd == 'P003' || moduleCd == 'P004'|| moduleCd == 'P006'){
		 if (uSwitch=="Y"||uSwitch=='Y'){
		    w = w.toUpperCase();
		 } 
		 w = w.replace("  "," ");
	} 
	t.value = ltrim(w);
	setCaretToPos(t, position);
}
function doGetCaretPosition (oField) {
	//alert(oField.type);
	// Initialize
	var iCaretPos = 0;
	
	// IE Support
	if (document.selection) {
		//alert("IE");
		// Set focus on the element
		oField.focus ();
		
		// To get cursor position, get empty selection range
		var oSel = document.selection.createRange ();
		
		// Move selection start to 0 position
		oSel.moveStart ('character', -oField.value.length);
		if (oField.type == 'textarea'||oField.type == 'TEXTAREA'){
			iCaretPos=caret(oField);	
			//alert('iCaretPos:'+iCaretPos);
			if (iCaretPos == -1) {
				iCaretPos = oSel.text.length;//alert('iCaretPos:'+iCaretPos);
			}	
		} else {
			// The caret position is selection length
			iCaretPos = oSel.text.length;
		}
	}
	
	// Firefox support
	else if (oField.selectionStart || oField.selectionStart == '0')
	{	//alert("FireFox");
		iCaretPos = oField.selectionStart;
	}
	// Return results
	return (iCaretPos);
}

function setCaretToPos (elm, pos) {
	setSelectedTextRange(elm, pos, pos);
}
function setSelectedTextRange(elm, selectionStart, selectionEnd) {
	if (elm.setSelectionRange) {
		elm.focus();
		elm.setSelectionRange(selectionStart, selectionEnd);
	}
	else if (elm.createTextRange) {
		var range = elm.createTextRange();
		range.collapse(true);
		range.moveEnd('character', selectionEnd);
		range.moveStart('character', selectionStart);
		range.select();
	}
}

function resBlur(t,v, moduleCd, uSwitch){
	var w = "";
	for (i=0; i < t.value.length; i++) {
		x = t.value.charAt(i);
		if (v.indexOf(x,0) != -1)
			w += x;
	}
	if (moduleCd == 'L005'||moduleCd == 'L007'||moduleCd == 'L001'||moduleCd == 'L002'||moduleCd == 'L003'||
		moduleCd == 'L010'||
		moduleCd == 'P001'||moduleCd == 'P002'||moduleCd == 'P003'){
		if (uSwitch=="Y"||uSwitch=='Y'){
		   w = w.toUpperCase();
		} 
	 	w = w.replace("  "," ");
	} 
	t.value = ltrim(w);
}

function resOrig(t,v){	
	var w = "";
	for (i=0; i < t.value.length; i++) {
		x = t.value.charAt(i);
		if (v.indexOf(x,0) != -1)
			w += x;
	}
	w = w.replace("  "," ");
	t.value = ltrim(w);
}

function caret(node) {
	 //node.focus(); 
	 /* without node.focus() IE will returns -1 when focus is not on node */
	if(node.selectionStart) 
		return node.selectionStart;
	else if(!document.selection) 
		return 0;
	var c		= "\001";
	var sel	= document.selection.createRange();
	var dul	= sel.duplicate();
	var len	= 0;
	dul.moveToElementText(node);
	sel.text = c;
	len	= (dul.text.indexOf(c));
	sel.moveStart('character',-1);
	sel.text = "";
	return len;
}

function trim(stringToTrim) {
	return stringToTrim.replace(/^\s+|\s+$/g,"");
}
function ltrim(stringToTrim) {
	return stringToTrim.replace(/^\s+/,"");
}
function rtrim(stringToTrim) {
	return stringToTrim.replace(/\s+$/,"");
}