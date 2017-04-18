<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="ajax" uri="http://ajaxtags.org/tags/ajax" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<!-- comment by Niknok 11.29.2011 no need na po -->
<!--<jsp:include page="/pages/claims/claimBasicInformation/basicMenu.jsp"></jsp:include>-->

<div id="clmReportsPrintDocsTableGridDiv">
<jsp:include page="/pages/claims/claimReportsPrintDocs/subPages/claimInfo.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Item Information</label>
	   		<span class="refreshers" style="margin-top: 0;">
	   			<label name="gro" style="margin-left: 5px;">Hide</label>
	   		</span>
	   	</div>
	</div>
	<div id="claimsItemInfoTableGridSectionDiv" class="sectionDiv" style="height: 250px;" changeTagAttr="true"  >
			<div id="claimsItemInfoTableGridDiv" style="padding: 10px; height: 200px; margin-left: 50px; margin-top:10px;"></div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>History Information</label>
	   		<span class="refreshers" style="margin-top: 0;">
	   			<label name="gro" style="margin-left: 5px;">Hide</label>
	   		</span>
	   	</div>
	</div>
	<div id="claimsHistInfoTableGridSectionDiv" class="sectionDiv" style="height: 280px;" changeTagAttr="true">
			<div id="claimsHistInfoTableGridDiv" style="padding: 10px; height: 200px;  margin-left: 50px; margin-top:10px;"></div>
			<div class="buttonsDiv" align="center">
				<input type="button" id="btnUntagAll" name="btnUntagAll"  style="width: 100px;" class="button hover"   value="Untag All" />
			</div>
	</div>
	<div class="buttonsDiv" align="center">
		<input type="button" id="btnPrintDocs" name="btnPrintDocs"  style="width: 100px;" class="button hover"   value="Print Document" />
	</div>
</div>


<script type="text/javascript">
initializeMenu();
initializeAccordion(); 
loadPrintDocsItemInfoTableListing();


//belle 09222011 GICLS041 loads table grid listing for item info
function loadPrintDocsItemInfoTableListing(){	
	new Ajax.Updater("claimsItemInfoTableGridDiv", contextPath+"/GICLItemPerilController",{
		method: "GET",	
		parameters: {
			action : "getItemPerilGrid2",
			claimId: objCLMGlobal.claimId,
			lineCd : objCLMGlobal.lineCd
		},
		evalScripts: true,
		asynchronous: false,
		onComplete: function(response){
			hideNotice();
		}
	});	
}

// belle 09302011 GICLS041 shows list of reports per line
function showReportListing(){
	try{
		overlayReportsList = Overlay.show(contextPath+"/PrintDocumentsController", {
			urlContent: true,
			urlParameters: {action : "showReportListing",
							lineCd : objCLMGlobal.lineCd},
		    height: 305,
		    width: 800,
		    draggable: true
		    //closable: true
		});
	} catch(e){
		showErrorMessage("showReportListing", e);
	}
}

function unCheckAllRows(){
	var rows = histInfoTableGrid.geniisysRows;
	for(i=0; i<rows.length; i++){
		histInfoTableGrid.setValueAt(false, histInfoTableGrid.getColumnIndex('checkBox1'), rows[i].divCtrId);
	}
}

observeReloadForm("reloadForm", printClaimsDocs);
$("clmExit").stopObserving("click"); //Niknok to avoid duplicate observe
//$("clmExit").observe("click",showClaimListing);
// commented out by Kris 08.06.2013 and replaced with the ff:
$("clmExit").observe("click",function(){
	if(objGICLS051.previousModule == "GICLS051"){
		objGICLS051.previousModule = null;
		showGeneratePLAFLAPage(objGICLS051.currentView, objCLMGlobal.lineCd);
	} else {
		showClaimListing();
	}
});

$("btnUntagAll").observe("click", unCheckAllRows);

$("btnPrintDocs").observe("click", function(){
	if(($$("div#claimsItemInfoTableGridDiv .selectedRow")).length < 1) {
		showMessageBox("Please select an item first.", imgMessage.INFO);					
		return false;
	}else if(histInfoTableGrid.geniisysRows != ""){
		/* if (($$("div#claimsHistInfoTableGridDiv .selectedRow")).length < 1) {
			showMessageBox("Please select a record first.", imgMessage.INFO);
			return false;
		}else{
			printDocsItemInfoTableGrid.keys.releaseKeys();
			histInfoTableGrid.keys.releaseKeys();
			showReportListing();
		} */ //belle 07.02.2012
		var rows = histInfoTableGrid.getModifiedRows();
		var count = 0;
		
		for (var i=0; i<rows.length; i++){
			if (rows[i].checkBox1 == true){
				count = count +1;
			}
		}	
		
		if (count > 0){
			histInfoTableGrid.keys.releaseKeys();
			showReportListing();
		}else {
			showMessageBox("Please check/tag settlement history before printing.", imgMessage.INFO);	 			
			return false;
		}
	}else{
		printDocsItemInfoTableGrid.keys.releaseKeys();
		histInfoTableGrid.keys.releaseKeys();
		showReportListing();
	}
});
</script>