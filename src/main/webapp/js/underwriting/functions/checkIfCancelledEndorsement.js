/**
 * Check if the PAR is a cancelled endorsement and disable the fields
 * of the item information page to disallow editing of information
 * @author Veronica V. Raymundo 
 */

function checkIfCancelledEndorsement(){
	try{
		var polFlag = objUWParList.packParId == null ? $F("globalPolFlag"): objUWGlobal.polFlag;
		if(nvl(polFlag, null) != null){ // modified - irwin 10.24.2012 
			var parType = (objUWGlobal.parType != null ? objUWGlobal.parType : $F("globalParType"));
			//var polFlag = $("globalPolFlag").value;
			
			if((parType == "E" && polFlag == "4") || objUWGlobal.cancelTag == 'Y'){ //added objUWGlobal.cancelTag by jdiago 08.05.2014
				$$("input[type=text]").each(function(txt){
					txt.readOnly = true;
				});
				$$("textarea").each(function(area){
					area.readOnly = true;
				});
				$$("select").each(function(sel){
					if(sel.id != "scwMonths"){
						sel.disable();
					}
				});
				$$("input[type=checkbox]").each(function(chk){
					chk.disable();
				});
				$$("input.button").each(function(btn){
					if(btn.id !="btnSubmitText" && btn.id !="btnCancelText" &&
					   btn.id !="btnGroupedItems" && btn.id !="btnPersonalAddtlInfo" && 
					   btn.id !="btnCancelGrp" && btn.id !="btnMsgBoxOk"){
						if (btn.getAttribute("toEnable") != "true"){ //added by steven 10/08/2012
							disableButton(btn);
						}
					}
				});
				$$("img").each(function(img){
					var src = img.src;
					var id = img.id;
					if(nvl($(id), null) != null){
						if(src.include("searchIcon.png")){
							if (id != "oscmIntm"){ //added by steve 10/08/2012
								img.src = contextPath + "/images/misc/disabledSearchIcon.png";
								$(id).stopObserving("click");
							}
						}else if(src.include("but_calendar.gif")){
							img.src = contextPath + "/images/misc/disabledCalendarIcon.gif";
							$(id).stopObserving("click");
							disableDate(id); //added by steven 10/08/2012
						}else if(src.include("edit.png")){
							makeItemInfoTextEditorReadOnly(id);
						}
					}
				});
			}
		}
	}catch(e){
		showErrorMessage("checkIfCancelledEndorsement", e);
	}
}