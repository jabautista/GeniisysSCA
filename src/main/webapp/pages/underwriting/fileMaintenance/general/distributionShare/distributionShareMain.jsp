<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>  
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="distributionShareMainDiv">
	<div id="distributionShareMenuDiv" style="display: none;">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="distributionShareExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	
	
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Line Listing</label>
				<span class="refreshers" style="margin-top: 0;">
					<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
					<label id="distributionShareReloadForm" name="distributionShareReloadForm">Reload Form</label>
				</span>
		</div>
	</div>
	<div id="tableGridSectionDiv" class="sectionDiv" style="height: 370;">
		<div id="lineListingTableGridDiv" style="padding: 10px;"> 
			<jsp:include page="/pages/underwriting/fileMaintenance/general/distributionShare/subPages/lineListingTableGrid.jsp"></jsp:include>
		</div>
	</div>

	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Distribution Share Maintenance</label>
			<span class="refreshers" style="margin-top: 0;">
				<label name="gro" style="margin-left: 5px;">Hide</label>
			</span>
		</div>
	</div>
	<div id="tableGridSectionDivRes" class="sectionDiv" style="height: 370;">
		<div id="distributionShareResTableGridDiv" style= "padding: 10px; height: 470px;">
			<jsp:include page="/pages/underwriting/fileMaintenance/general/distributionShare/subPages/distributionShareTableGrid.jsp"></jsp:include> 	 
		</div>
	</div>	
	
	<div class="buttonsDiv" style="float:left; width: 100%;">
		<input type="button" class="button" id="btnCancelShare" name="btnCancelShare" value="Cancel" tabindex=301 />
		<input type="button" class="button" id="btnSaveShare" name="btnSaveShare" value="Save" tabindex=302/>
	</div>	
</div>

<script>

	objGIIS060 = {};
	$("distributionShareMenuDiv").show();
	
	function exitDistributionShare(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main" , null);
	}
	
	function reloadDistributionShare(){
		showDistributionShare("GIPIS000");
	}
	
	function loadDistShare(shareType, focus){
		if(shareType != "4"){
			distShareTableGrid.url = contextPath+"/GIISDistributionShareController?action=getDistShareMaintenance&lineCd="+encodeURIComponent(unescapeHTML2(objUW.hideGIIS060.lineCd))+"&shareType="+shareType;
    		distShareTableGrid.refreshURL(distShareTableGrid);
    		distShareTableGrid._refreshList();	
 		}else{
 			xolTableGrid.url = contextPath+"/GIISXolController?action=getXolList&lineCd="+encodeURIComponent(unescapeHTML2(objUW.hideGIIS060.lineCd));
			xolTableGrid.refreshURL(xolTableGrid);
			xolTableGrid._refreshList();
		} 
		
		if(shareType == "1" || shareType == "3"){
			disableButton("btnTreatyDetails");
			if(distShareTableGrid.rows.length > 0){ // Nica 05.27.2013 - to disallow addition of records for share_type = 1 or share_type = 3 
				disableButton("btnAddDShare");
			}else{
				if(focus == "removeFocus"){
					disableButton("btnAddDShare");	
				} else {
					enableButton("btnAddDShare");	
				}
			}
		}/* else{
			enableButton("btnTreatyDetails");
		} */
	}
 	
	function saveDistShare(objLineCd){
 		var objParams = new Object();
 		objParams.delRows = getDeletedJSONObjects(objUW.hideGIIS060.distShareRows);
		objParams.setRows = getAddedAndModifiedJSONObjects(objUW.hideGIIS060.distShareRows);
		
		new Ajax.Request(contextPath+"/GIISDistributionShareController",{
			parameters:{
				action: "saveDistShare",
				//lineCd: objLineCd, Removed muna para makapagsave upon logout, imbis na objLineCd gamitin, yung obj nalang na niset para kay line_cd.
				lineCd: unescapeHTML2(objUW.hideGIIS060.lineCd),
				shareType: shareType,
				param: JSON.stringify(objParams)
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
				showNotice("Saving, please wait...");
			},
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					if(response.responseText == "SUCCESS"){
						/* showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
						changeTag = 0;
						delChangeTag = 0;
						distShareTableGrid.refresh(); */
						
						changeTagFunc = "";
						showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
							if(objGIIS060.exitPage != null) {
								objGIIS060.exitPage();
							} else if(objGIIS060.changeShareType != null){
								objGIIS060.changeShareType(objGIIS060.showTGShareType);
							} else {
								distShareTableGrid.refresh();
							}
						});
						changeTag = 0;
						delChangeTag = 0;
					}else{
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}else{
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}
	
	function saveXol(objLineCd){
 		var objParams = new Object();
 		objParams.delRows = getDeletedJSONObjects(objUW.hideGIIS060.xolRows);
		objParams.setRows = getAddedAndModifiedJSONObjects(objUW.hideGIIS060.xolRows);
		new Ajax.Request(contextPath+"/GIISXolController",{
			parameters:{
				action: "saveXol",
				//lineCd: objLineCd, Removed muna para makapagsave upon logout, imbis na objLineCd gamitin, yung obj nalang na niset para kay line_cd.
				lineCd: unescapeHTML2(objUW.hideGIIS060.lineCd),
				param: JSON.stringify(objParams)
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
				showNotice("Saving, please wait...");
			},
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					if(response.responseText == "SUCCESS"){
						/* showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
						changeTag = 0;
						delChangeTag = 0;
						xolTableGrid.refresh(); */
						
						changeTagFunc = "";
						showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
							if(objGIIS060.exitPage != null) {
								objGIIS060.exitPage();
							} else {
								xolTableGrid.refresh();
							}
						});
						changeTag = 0;
						delChangeTag = 0;
					}else{
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}else{
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}
	
	observeReloadForm("distributionShareReloadForm", reloadDistributionShare);
	/* observeCancelForm("btnCancelShare", saveDistShare, exitDistributionShare); replaced by: Nica 05.27.2013
	observeCancelForm("distributionShareExit", saveDistShare, exitDistributionShare);
	observeCancelForm("btnCancelShare", function(){
		if(shareType != "4"){
			saveDistShare(objUW.hideGIIS060.lineCd);
		}else{
			saveXol(objUW.hideGIIS060.lineCd);
		}
	}, exitDistributionShare);
	
	observeCancelForm("distributionShareExit", function(){
		if(shareType != "4"){
			saveDistShare(objUW.hideGIIS060.lineCd);
		}else{
			saveXol(objUW.hideGIIS060.lineCd);
		}
	}, exitDistributionShare); */
	
	$("btnCancelShare").observe("click", cancelDistShare);
	
	$("distributionShareExit").observe("click", function(){
		fireEvent($("btnCancelShare"), "click");
	});
	
	function cancelDistShare(){
		if(changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
				        objGIIS060.exitPage = exitDistributionShare;
				        if(shareType != "4"){
							saveDistShare(objUW.hideGIIS060.lineCd);
						}else{
							saveXol(objUW.hideGIIS060.lineCd);
						}
					}, function(){
						exitDistributionShare();
					}, "");
		} else {
			exitDistributionShare();
		}
	}
	
	$("btnSaveShare").observe("click", function(response){
		if (changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, imgMessage.NO_CHANGES);
		} else {
			if(shareType != "4"){
				saveDistShare(objUW.hideGIIS060.lineCd);
			}else{
				saveXol(objUW.hideGIIS060.lineCd);
			}
		}
	});	
	
	objGIIS060.saveDistShare = saveDistShare;
	objGIIS060.saveXol = saveXol;
	objGIIS060.loadDistShare = loadDistShare;
	objGIIS060.exitPage = null;
	objGIIS060.changeShareType = null;
	objGIIS060.showTGShareType = null;
	objGIIS060.savefocus = function () {
		$("btnSaveShare").focus();
	};
  	changeTag = 0;
	setDocumentTitle("Distribution Share Maintenance");
	setModuleId("GIISS060");
 	initializeAccordion();
	addStyleToInputs(); 
	initializeAll();
	
	$("txtShareCode").readOnly = true;
	$("txtShareName").readOnly = true;
	$("txtRemarks").readOnly = true;
	$("editRemarksText").hide();
	disableButton("btnAddDShare");
</script>