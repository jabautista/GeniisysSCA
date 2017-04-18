<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="packParItemInformationMainDiv" name="packParItemInformationMainDiv" style="margin-top: 1px;">
	<jsp:include page="/pages/underwriting/subPages/parInformation.jsp"></jsp:include>
	<jsp:include page="/pages/underwriting/packPar/packCommon/packParPolicyListingTable.jsp"></jsp:include>
	<div id="packParItemInfoDiv">		
	</div>
</div>
<script type="text/javascript" defer="defer">
	var firstRow = null;
	var packLineCd = "${packLineCd}";
	objGIPIParList = JSON.parse('${packParList}');
	showPackagePARPolicyList(objGIPIParList);
	loadPackParRowObservers();
	objCurrPackPar = new Object();
	
	function loadPackParRowObservers() {
		try{
			$$("div#packageParPolicyTable div[name='rowPackPar']").each(function(row){
				if(firstRow==null) firstRow = row;
				loadRowMouseOverMouseOutObserver(row);
				row.observe("click", function(){
					if(changeTag == 1){
						showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
								function(){doSaving(packLineCd);},
								function(){changeTag = 0; clickPackParRow(row);},"");
					} else {
						clickPackParRow(row);
					}
				});
			});
		} catch (e) {
			showErrorMessage("loadPackParRowObservers", e);
		}
	}
	
	function doSaving(packLineCd){
		if(packLineCd == objLineCds.MC){
			saveVehicleItems();
		} else if (packLineCd == objLineCds.FI) {
			saveFireItems();
		} else if (packLineCd == objLineCds.AV) {
			saveAviationItems();
		} else if (packLineCd == objLineCds.EN) {
			saveENItems();
		} else if (packLineCd == objLineCds.CA) {
			saveCasualtyItems();
		} else if (packLineCd == objLineCds.AC) {
			saveAHItem();
		} else if (packLineCd == objLineCds.MN) {
			saveMarineCargoItems();
		} else if (packLineCd == objLineCds.MH) {
			saveMHItems();
		}
	}
	
	function clickPackParRow(row){
		try {
			if(!row.hasClassName("selectedRow")){
				row.addClassName("selectedRow");
				($$("div#packageParPolicyTable div:not([id='" + row.id + "'])")).invoke("removeClassName", "selectedRow");
				
				for(var i=0; i<objGIPIParList.length; i++){
					if(objGIPIParList[i].parId == parseInt(row.getAttribute("parId"))){
						objCurrPackPar = objGIPIParList[i];	
						objCurrPackPar.containerDiv = "packParItemInfoDiv";						
						objGIPIWPolbas.parId = objCurrPackPar.parId;
						objGIPIWPolbas.lineCd = objCurrPackPar.lineCd;
						objGIPIWPolbas.sublineCd = objCurrPackPar.sublineCd;
						//added by d.alcantara, 11-17-2011
						if(objCurrPackPar.parType == null) {objCurrPackPar.parType = objUWGlobal.parType;}
					}
				}

				showItemInfo();
			}
		} catch (e){
			showErrorMessage("clickPackParRow", e);
		}
	}
	
	function initializePackParItemInfoPage(){
		try {
			var packLineName = getPackLineName(packLineCd);
			
			$("lblPkgParListSubPage").update("Package PAR for " + packLineName.toUpperCase());			
			setDocumentTitle("Package - Item Information - " + packLineName);
			fireEvent(firstRow, "click");
		} catch (e){
			showErrorMessage("initializePackParItemInfoPage", e);
		}
	}
	
	function getPackLineName(packLineCd){
		switch(packLineCd){
			case objLineCds.MC: return "Motor Car";
			case objLineCds.FI: return "Fire";
			case objLineCds.AV: return "Aviation";
			case objLineCds.EN: return "Engineering";
			case objLineCds.CA: return "Casualty";
			case objLineCds.AC: return "Personal Accident";
			case objLineCds.MH: return "Marine Hull";
			case objLineCds.MN: return "Marine Cargo";
		}
	}

	initializePackParItemInfoPage();	
</script>