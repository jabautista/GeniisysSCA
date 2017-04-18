<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="packPrelimPerilDistMainDiv" name="packPrelimPerilDistMainDiv" style="margin-top: 1px;">
	<jsp:include page="/pages/underwriting/subPages/parInformation.jsp"></jsp:include>
	<jsp:include page="/pages/underwriting/packPar/packCommon/packParPolicyListingTable.jsp"></jsp:include>
	<div id="packPrelimPerilDistDiv">
	</div>
</div>
<script type="text/javascript">
	var firstRow = null;
	objGIPIParList = JSON.parse('${packParList}');
	showPackagePARPolicyList(objGIPIParList);
	loadPackParRowObservers();
	objCurrPackPar = new Object();
	
	function clickPackParRow(row){
		try {
			if(!row.hasClassName("selectedRow")){
				row.addClassName("selectedRow");
				($$("div#packageParPolicyTable div:not([id='" + row.id + "'])")).invoke("removeClassName", "selectedRow");
				
				for(var i=0; i<objGIPIParList.length; i++){
					if(objGIPIParList[i].parId == parseInt(row.getAttribute("parId"))){
						objCurrPackPar = objGIPIParList[i];	
						objUWGlobal.parId = objCurrPackPar.parId;
						objUWGlobal.lineCd = objCurrPackPar.lineCd;
						objUWGlobal.sublineCd = objCurrPackPar.sublineCd;
					}
				}

				showPreliminaryPerilDist();
			}
		} catch (e){
			showErrorMessage("clickPackParRow", e);
		}
	}
	
	function loadPackParRowObservers() {
		try{
			$$("div#packageParPolicyTable div[name='rowPackPar']").each(function(row){
				if(firstRow==null) firstRow = row;
				loadRowMouseOverMouseOutObserver(row);
				row.observe("click", function(){
					if(changeTag == 1){
						showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
								function(){objCurrPackPar.saveFunction();},
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
	
	fireEvent(firstRow, "click");
</script>