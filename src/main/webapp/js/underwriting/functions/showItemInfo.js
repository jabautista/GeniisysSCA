/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	01.05.2010	mark jm 		show item info page
 * 	08.31.2011	mark jm			added temporary condition while table grid is not yet 100%
 * 								in all lines. condition will be deleted once tablegrid conversion is complete 
 */
function showItemInfo(){
	try {		

		//if(itemTablegridSw == "Y"){
			showItemInfoTG();
		/*}else{
			//updateParParameters(); commented out by Grace - 05.18.11 
			var parId	 	= "";
			var lineCd	 	= "";
			var sublineCd	= "";
			var linePage 	= "";
			var triggerForm;
			var formName;
			var parStatus = "";
			var parType = (objUWGlobal.parType != null ? objUWGlobal.parType : $F("globalParType"));
			var typeMsg = "";

			//updateParParameters();
			
			parId = (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId")); // modified by andrew - 03.17.2011 added condition for package par
			lineCd = (objUWGlobal.packParId != null ? getOrigLineCd(objCurrPackPar.menuLineCd) : $F("globalLineCd")); 	
			
			if(objUWGlobal.lineCd == objLineCds.MC || objUWGlobal.menuLineCd == objLineCds.MC || lineCd == "MC"){	// mark jm 07.08.2011 hard-coded this side for package. these are the original line cds
				linePage = "/GIPIWVehicleController?action=" + (parType == "E" ? "showEndtMotorItemInfo&" : "getGIPIWItemTableGridMC&");
			} else if(objUWGlobal.lineCd == objLineCds.FI || objUWGlobal.menuLineCd == objLineCds.FI || lineCd == "FI"){
				linePage = "/GIPIWFireItmController?action=" + (parType == "E" ? "showEndtFireItemInfo&" : "getGIPIWItemTableGridFI&");
			} else if(objUWGlobal.lineCd == objLineCds.MN || objUWGlobal.menuLineCd == objLineCds.MN || lineCd== "MN"){
				linePage = "/GIPIWCargoController?action=" + (parType == "E" ? "showEndtMarineCargoItemInfo&" : "showMarineCargoItemInfo&");	
			} else if(objUWGlobal.lineCd == objLineCds.AV || objUWGlobal.menuLineCd == objLineCds.AV || lineCd== "AV"){
				linePage = "/GIPIWAviationItemController?action=" + (parType == "E" ? "showEndtAviationItemInfo&" : "showAviationItemInfo&");
			} else if(objUWGlobal.lineCd == objLineCds.CA || objUWGlobal.menuLineCd == objLineCds.CA || lineCd== "CA"){
				linePage = "/GIPIWCasualtyItemController?action=" + (parType == "E" ? "showEndtCasualtyItemInfo&" : "getGIPIWItemTableGridCA&");		
			} else if(objUWGlobal.lineCd == objLineCds.MH || objUWGlobal.menuLineCd == objLineCds.MH || lineCd== "MH"){
				linePage = "/GIPIWItemVesController?action=" + (parType == "E" ? "showEndtMarineHullItemInfo&" : "showMHItemInfo&");
			} else if(objUWGlobal.lineCd == objLineCds.AC || objUWGlobal.menuLineCd == objLineCds.AC || objUWGlobal.menuLineCd == "AC" || lineCd== "AC"){
				linePage = "/GIPIWAccidentItemController?action=" + (parType == "E" ? "showEndtAccidentItemInfo&" : "showGIPIWAccidentInfo&");	
			} else if(objUWGlobal.lineCd == objLineCds.EN || objUWGlobal.menuLineCd == objLineCds.EN || lineCd== "EN") {	
				linePage = "/GIPIWEngineeringItemController?action=" + (parType == "E" ? "showEndtEngineeringItemInfo&" : "showENItemInfo&");
			} else{
				showMessageBox("Page cannot be displayed right now.", imgMessage.ERROR);
				return false;
			}
			
			var url = contextPath+linePage;//+Form.serialize("uwParParametersForm"); // andrew - 07.11.2011 - removed form.serialize
			var containerDiv = (objUWGlobal.packParId != null ? objCurrPackPar.containerDiv : "parInfoDiv"); // modified by andrew - 03.17.2011 added condition for package par
		    
			new Ajax.Updater(containerDiv, url,{
				parameters : {
					parId : parId,
					lineCd : lineCd,
					sublineCd : sublineCd,
					//globalParId: parId,	//added 03.07.2011 // comment out by andrew - 07.08.2011
					isPack : (objUWGlobal.packParId != null ? "Y" : "N") // added by andrew - 03.17.2011 - to determine if package or not
				},
				asynchronous: true,
				evalScripts: true,
				onCreate: function() {
					$("parInfoDiv").writeAttribute("url", url);
					//$("parInfoDiv").hide(); // comment out by andrew - 03.17.2011
					var noticeMessage = "";
					if (parType == "E") {
						typeMsg = "Endt ";
					}
					if(objUWGlobal.lineCd == objLineCds.MC || objUWGlobal.menuLineCd == objLineCds.MC || lineCd== objLineCds.MC){
						noticeMessage = "Getting " + typeMsg + "Motor Item Information, please wait...";
					} else if(objUWGlobal.lineCd == objLineCds.FI || objUWGlobal.menuLineCd == objLineCds.FI || lineCd== objLineCds.FI){
						noticeMessage = "Getting " + typeMsg + "Fire Item Information, please wait...";
					} else if(objUWGlobal.lineCd == objLineCds.MN || objUWGlobal.menuLineCd == objLineCds.MN || lineCd== objLineCds.MN){
						noticeMessage = "Getting " + typeMsg + "Marine Cargo Item Info, please wait...";
					} else if(objUWGlobal.lineCd == objLineCds.AV || objUWGlobal.menuLineCd == objLineCds.AV || lineCd== objLineCds.AV){
						noticeMessage = "Getting " + typeMsg + "Aviation Item Information, please wait...";
					} else if(objUWGlobal.lineCd == objLineCds.CA || objUWGlobal.menuLineCd == objLineCds.CA || lineCd== objLineCds.CA){
						noticeMessage = "Getting " + typeMsg + "Casualty Item Information, please wait...";
					} else if(objUWGlobal.lineCd == objLineCds.MH || objUWGlobal.menuLineCd == objLineCds.MH || lineCd== objLineCds.MH){
						noticeMessage = "Getting " + typeMsg + "Marine Hull Item Information, please wait...";
					} else if(objUWGlobal.lineCd == objLineCds.AC || objUWGlobal.menuLineCd == objLineCds.AC || lineCd== objLineCds.AC){ 
						noticeMessage = "Getting " + typeMsg + "Accident Item Information, please wait...";
					} else if(objUWGlobal.lineCd == objLineCds.EN || objUWGlobal.menuLineCd == objLineCds.EN || lineCd== objLineCds.EN){
						noticeMessage = "Getting " + typeMsg + "Engineering Item Information, please wait...";
					}
					
					objDeductibles = null;
					objMortgagees = null;
					objGIPIWMcAcc = null;
					showNotice(noticeMessage);
				},
				onComplete: function(){
					hideNotice("");
					$("parInfoDiv").show();
					updateParParameters();
					
					if(nvl(objUWGlobal.packParId, null) == null){
						Effect.Appear($("parInfoDiv").down("div", 0), {
							duration: .001,
							afterFinish: function (){
								$("parNo").focus();
								setParMenus(parseInt($F("globalParStatus")), $F("globalLineCd"), $F("globalSublineCd"), $F("globalOpFlag"), $F("globalIssCd"));
								initializeMenu();
							}
						});
					}
				}
			});
		}*/
	} catch(e){
		showErrorMessage("showItemInfo", e);
	}
}