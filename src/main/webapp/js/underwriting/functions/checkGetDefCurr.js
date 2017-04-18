/*This function : 
 * 1. Validates if giacp.v('DEFAULT_CURRENCY') and giacp.n('CURRENCY_CD')
 * are compatible.
 * 2. Retrieves currency rate of the default currency.
 * Gzelle 10242014
 * */
function checkGetDefCurr() {
	new Ajax.Request(contextPath + "/GIPIWItemController", {
		parameters : {action : "checkGetDefCurrRt",},
		onComplete : function(response){
			function preventChanges() {
				tbgItemTable.unselectRows();
				objCurrItem = null;
				objCurrItemPeril = null;
				setParItemFormTG(null);
				setDefaultItemForm();
				clearItemRelatedTableGrid();
				clearItemRelatedDetails();
				tbgItemTable.keys.releaseKeys();
				$("rate").value = "";
				$("currency").value  = "";
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
					   btn.id !="btnGroupedItems" && btn.id !="btnCancelGrp" && 
					   btn.id !="btnMsgBoxOk" && btn.id !="btnCancel"){
						if (btn.getAttribute("toEnable") != "true"){
							disableButton(btn);
						}
					}
				});
				$$("img").each(function(img){
					var src = img.src;
					var id = img.id;
					if(nvl($(id), null) != null){
						if(src.include("searchIcon.png")){
							if (id != "oscmIntm"){
								img.src = contextPath + "/images/misc/disabledSearchIcon.png";
								$(id).stopObserving("click");
							}
						}else if(src.include("but_calendar.gif")){
							img.src = contextPath + "/images/misc/disabledCalendarIcon.gif";
							$(id).stopObserving("click");
							disableDate(id);
						}else if(src.include("edit.png")){
							makeItemInfoTextEditorReadOnly(id);
						}
					}
				});
			}
			if (response.responseText.include("Geniisys Exception")){
				var message = response.responseText.split("#"); 
				showWaitingMessageBox(message[2], message[1], preventChanges);
				return false;
			} else {
				$("rate").value = formatToNineDecimal(response.responseText);
			}
		}
	});
}