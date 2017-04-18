<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="packParCarrierInformationMainDiv" name="packParCarrierInformationMainDiv" style="margin-top: 1px;">
	<jsp:include page="/pages/underwriting/subPages/parInformation.jsp"></jsp:include>
	<jsp:include page="/pages/underwriting/packPar/packCommon/packParPolicyListingTable.jsp"></jsp:include>
	<div id="packCarrierInfoDiv">		
	</div>
</div>
<script type="text/javascript" defer="defer">
	var firstRow = null;
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
								function () {objUW.hidObjGIPIS007.saveCarInfoPageChanges();clickPackParRow(row);},  //edited by steven 11/13/2012 from: saveCarrierInfo(true)    to: objUW.hidObjGIPIS007.saveCarInfoPageChanges();clickPackParRow(row);
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
	
	function clickPackParRow(row){
		try {
			if(!row.hasClassName("selectedRow")){
				row.addClassName("selectedRow");
				($$("div#packageParPolicyTable div:not([id='" + row.id + "'])")).invoke("removeClassName", "selectedRow");
				
				for(var i=0; i<objGIPIParList.length; i++){
					if(objGIPIParList[i].parId == parseInt(row.getAttribute("parId"))){
						objCurrPackPar = objGIPIParList[i];
						objCurrPackPar.containerDiv = "packCarrierInfoDiv";						
						objGIPIWPolbas.parId = objCurrPackPar.parId;
						objGIPIWPolbas.lineCd = objCurrPackPar.lineCd;
						objGIPIWPolbas.sublineCd = objCurrPackPar.sublineCd;
					}
				}

				showCarrierInfoPage();
			}
		} catch (e){
			showErrorMessage("clickPackParRow", e);
		}
	}
	
	function initializePackCarrierInfoPage(){
		try {		
			$("lblPkgParListSubPage").update("Package PAR for MARINE CARGO");		
			setDocumentTitle("Package - Enter Vessel Information");
			fireEvent(firstRow, "click");
		} catch (e){
			showErrorMessage("initializePackCarrierInfoPage", e);
		}
	}
	
	initializePackCarrierInfoPage();
</script>