var timesFailed = 1;
var checkImgSrc = contextPath+"/css/image_themes/check-darkblue.gif";
var showMBox = "N";
var showNoticeSw = "Y"; // andrew - 10.20.2011 - switch to avoid overlapping notice in message box
var assuredListingTableGridExit = "0"; //markS 04.08.2016 for SR-21916 assured listing exit global 
var geniisys = new Object();
var accessType = new Object();

accessType.MENU 		= "menu";
accessType.BUTTON 		= "button";
accessType.SUBPAGE 		= "subpage";
accessType.TOOLBUTTON 	= "toolbutton";
accessType.TAB			= "tab";
accessType.WIDGET		= "widget";
accessType.ROW			= "row"; // for double click event of row; 

var objKeyCode = new Object();
objKeyCode.BACKSPACE 	= 8;
objKeyCode.TAB			= 9;
objKeyCode.ENTER 		= 13;
objKeyCode.ESC     		= 27;
objKeyCode.DELETE 		= 35;
objKeyCode.ARROW_DOWN 	= 38;
objKeyCode.ARROW_UP 	= 40;

var objCommonMessage = new Object();
objCommonMessage.NO_MODULE_ACCESS = "You are not allowed to access this module.";
objCommonMessage.NO_CHANGES = "There are no changes to save.";
objCommonMessage.WITH_CHANGES = "Do you want to save the changes you have made?"; // with cancel button
objCommonMessage.RELOAD_WCHANGES = "Reloading form will disregard all changes. Proceed?"; // without cancel button
objCommonMessage.SUCCESS = "Saving successful.";
objCommonMessage.REQUIRED = "Required fields must be entered.";
objCommonMessage.SAVE_CHANGES = "Please save changes first.";
objCommonMessage.UNAVAILABLE_MODULE = "The module you are trying to access is not yet available.";
objCommonMessage.UNAVAILABLE_REPORT = "The report you are trying to access is not yet available."; //added by steven 06.08.2013

var commonOverrideOkFunc;
var commonOverrideOptionalParam;
var commonOverrideNotOkFunc;
var commonOverrideOptionalParam2;
var commonOverrideCancelFunc;

var genericObjOverlay;

//var commonOverrideAccessed = eval("[]"); alfie 03/11/2011

var logOutOngoing = "N";
var serverDate;
var timerIsOn = 0;

// kung anu anung modification
var modalPageNo2 = 0;

var textFieldForWysiwyg;
var wysiwygTemp;
var wysiwygTempTextId;

var acctPageNo = 1;

var ojbGlobalTextArea = new Object();
ojbGlobalTextArea.origValue = "";

var overlayEditor;
var funcHolder = new Object();

/**
 * Validates the manual TIME input
 * @author Irwin Tabisora
 * @param HH:MM:SS AM/PM format.
 * @return boolean
 */

/*function IsValidTime(element) {
	// Checks if time is in HH:MM:SS AM/PM format.
	// The seconds and AM/PM are optional.
	var timeStr = $F(element);
	var timePat = /^(\d{1,2}):(\d{2})(:(\d{2}))?(\s?(AM|am|PM|pm))?$/;
	// var Timefield=timestr;
	var matchArray = timeStr.match(timePat);
	if (matchArray == null) {
		showMessageBox("Time must be entered in a format like HH:MI:SS AM.", "I");
		//$("time").value = "";  replaced by kenneth L.
		$(element).value = "";
		return false;
	}
	var hour = matchArray[1];
	var minute = matchArray[2];
	var second = matchArray[4];
	var ampm = matchArray[6];

	if (second=="") {  //commented by kenneth L.
	second = null; 
	}
	if (ampm=="") { 
		ampm = null; 
	}

	if (hour < 0 || hour > 12) {
		showMessageBox("Hour must be between 1 and 12.", "I");
		$(element).value = "";
		return false;
	}
	if (minute<0 || minute > 59) {
		showMessageBox("Minute must be between 0 and 59.", "I");
		$(element).value = "";
		return false;
	}
	if (hour <= 12 && ampm == null) {
		showMessageBox("You must specify AM or PM.", "I");
		$(element).value = "";
		return false;
	}
	if (hour > 12 && ampm != null) {
		showMessageBox("You can't specify AM or PM for military time.", imgMessage.ERROR);
		$(element).value = "";
		return false;
	}
	if (second != null && (second < 0 || second > 59)) {
		showMessageBox("Second must be between 0 and 59.", "I");
		$(element).value = "";
		return false;	
	}
	
	if (second == null) {
		$(element).value = hour+":"+minute+":"+"00"+" "+ampm;
	}
		$(element).focus();	//added by kenneth L. 06.15.2013
		return true;
}*/

/** @author niknok 10.20.2011
 ** @returns true - if all required fields has a value else false
 *  @deprecated
 *  @comment use the function checkAllRequiredFieldsInDiv instead.
 */
function checkAllRequiredFields() {
	var isComplete = true;
	/*input[type='hidden'].required, input[type='password'].required,*/ //di ko muna isama mga to
	$$("input[type='text'].required, textarea.required, select.required").each(function (o) {
		if (o.value.blank()){
			isComplete = false;
			customShowMessageBox(objCommonMessage.REQUIRED, "I", o.id);
			throw $break;
		}
	});
	return isComplete;
}

/**
 * created by irwin 
 * @deprecated
 * */
function noChanges(){
	showMessageBox("No Changes to Save.", imgMessage.INFO);
}