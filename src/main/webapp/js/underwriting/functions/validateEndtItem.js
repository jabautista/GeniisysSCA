/**
 * Used in endt item information modules, executed when item number is entered
 * @author andrew
 * @date 05.14.2011
 * @returns {Boolean}
 */
function validateEndtItem(){
	var lineCd = getLineCd();
	var controller = "";
	var action = "";

	if(lineCd == "MC"){
		controller = "GIPIWVehicleController";
		action = "gipis060ValidateItem";
	} else if(lineCd == "FI"){
		controller = "GIPIWFireItmController";
		action = "gipis039B540WhenValidateItem";
	}
	
	//if($F("itemNo").trim() != ""){
		var tempRows = $("parItemTableContainer").childElements(); 
		var exist = false;

		for(var i=0; i<tempRows.length; i++){
			if(parseInt(tempRows[i].down("label", 0).innerHTML.trim()) == parseInt($F("itemNo"))){
				exist = true;
			}
		}
		
		if($F("btnAddItem") == "Add" && exist){
			showMessageBox("Item Number already exists.", imgMessage.ERROR);
			return false;
		}	
		new Ajax.Request(contextPath+"/"+controller,{
			parameters: {action : action,
					     parId : $F("globalParId"),
					     itemNo : $F("itemNo"),
					     backEndt : $F("globalBackEndt")},
			onComplete: function(response){
				try {
					if(checkErrorOnResponse(response)){						
						var objTemp = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
						
						if(objTemp.message != null){
							showMessageBox(objTemp.message);
						} 
						
						if(objTemp.endtItem.length > 0){
							objTemp.endtItem[0].itemGrp = null;
							objTemp.endtItem[0].tsiAmt = null;
							objTemp.endtItem[0].premAmt = null;
							objTemp.endtItem[0].packLineCd = null;
							objTemp.endtItem[0].packSublineCd = null;
							objTemp.endtItem[0].riskNo = nvl(objTemp.endtItem[0].riskNo, null);
							objTemp.endtItem[0].riskItemNo = nvl(objTemp.endtItem[0].riskItemNo, null);
							objTemp.endtItem[0].fromDate = nvl(objTemp.endtItem[0].fromDate, null);
							objTemp.endtItem[0].toDate = nvl(objTemp.endtItem[0].toDate, null);
							onEndtItemNoEntered(objTemp.endtItem[0]);
						} else {
							setParItemForm(null);
						}
					}
				} catch (e){
					showErrorMessage("validateEndtItem", e);
				}
			}
		});			
	//}
}