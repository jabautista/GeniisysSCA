<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<!-- <jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include> -->

<div id="viewUploadedFiles" style="width:98%; margin:auto; margin-top:10px;">
	<div id="outerDiv" name="outerDiv" style="width:100%;  margin:auto;" >
		<div id="innerDiv" name="innerDiv">
			<label>View Uploaded Files</label>
		</div>
	</div>	
	<div id="uploadEnrolleesDiv" name="uploadEnrolleesDiv" class="sectionDiv" style="display: block; width:100%; margin:auto;" align="center">
		<jsp:include page="/pages/underwriting/overlay/enrollees/uploadEnrolleesTableGridListing.jsp"></jsp:include>
		<div id="createToParDiv" style="width:100%; margin:auto; display:none;">
			<table style="align:center;">
				<tr><td>
				<input type="hidden" id="parNo" name="parNo" value="${gipiParlist.parNo}" />				
				<input type="hidden" id="itemNo" name="itemNo" value="${itemNo}" />				
				<input type="hidden" id="uploadEnrolleesSaved" name="uploadEnrolleesSaved" value="${uploadEnrolleesSaved }" />
				<input type="hidden" id="uploadNo" name="uploadNo" value="" />
				<label style="margin:auto; font-weight:bold;"></label>
				</td></tr>
			</table>
			<div id="progressBarMainDiv" name="progressBarMainDiv" style="float:center; width:228px; heigth: 14px; border:1px solid #456179;">
 				<div id="progressBarDivDummy" name="progressBarDivDummy" style="display:none; width:0%; float:center; background-color:red;">&nbsp;</div>
 				<div id="progressBarDiv" name="progressBarDiv" style="width:0%; float:center; background-color:#456179; color:white;">&nbsp;</div>
			</div>
			<!--
			<div id="statusMainDiv" name="statusMainDiv" style="float:center; width:350px; margin-left:4.5%; margin-top:5px; height:20px auto;">
				<div style="float:left; width:100%; text-align:left;">&nbsp;</div>
			</div>
			 -->
			<div style="float:left; width:100%; margin-top:15px; margin-bottom:10px;">
				<input type="button" class="button" id="btnCreateToParOk" 		name="btnCreateToParOk" 		value="Start Upload" />
				<input type="button" class="button" id="btnCreateToParCancel" 	name="btnCreateToParCancel" 	value="Cancel" />
			</div>
		</div>
		<div style="float:left; width:100%; margin-top:15px; margin-bottom:10px;">
			<input type="button" class="disabledButton" id="btnUploadEnrolleesDetails" 		name="btnUploadEnrolleesDetails" 		value="Details" style="width:60px;"/>
			<input type="button" class="button" id="btnUploadEnrolleesUploadFiles" 	name="btnUploadEnrolleesUploadFiles" 	value="Upload Files" />
			<input type="button" class="disabledButton" id="btnUploadEnrolleesCreateToPar" 	name="btnUploadEnrolleesCreateToPar" 	value="Create to PAR" />
			<input type="button" class="button" id="btnUploadEnrolleesExit" 		name="btnUploadEnrolleesExit" 			value="Exit" style="width:60px;" />
		</div>
	</div>
	<div id="viewUploadedFilesDetail" style="width: 100%; margin:auto; margin-top:0px; display:none;">
		<div id="outerDiv" name="outerDiv" style="width:100%;  margin:auto; margin-bottom:0px;" >
			<div id="innerDiv" name="innerDiv">
				<label>View Uploaded Files Details</label>
			</div>
		</div>	
		<div id="uploadEnrolleesDiv2" name="uploadEnrolleesDiv2" class="sectionDiv" style="display:block; width:100%; margin:auto; margin-top:0px;" align="center">
			<div id="uploadEnrolleeDetailsTable" name="uploadEnrolleeDetailsTable" style="width : 100%;">
				<div id="uploadEnrolleeDetailsTableGridSectionDiv" class="">
					<div id="uploadEnrolleeDetailsTableGridDiv" style="padding: 10px;">
						<div id="uploadEnrolleeDetailsTableGrid" style="height: 198px; width: 100%;"></div>
					</div>
				</div>	
			</div>
			<div style="float:left; width:100%; margin-top:10px; margin-bottom:10px;">
				<input type="button" class="button" id="btnUploadEnrolleesDetailsHide" 	name="btnUploadEnrolleesDetailsHide" value="Hide" style="width:60px;" />
			</div>		
		</div>
	</div>
	<div id="uploadEnrolleesFileDiv" style="width: 100%; margin:auto; margin-top:2px; display:none;">
		<div id="outerDiv" name="outerDiv" style="width:100%;  margin:auto; margin-bottom:0px;" >
			<div id="innerDiv" name="innerDiv">
				<label>Grouped Accident Uploading Module</label>
			</div>
		</div>	
		<jsp:include page="/pages/underwriting/overlay/enrollees/subPages/uploadEnrollees.jsp"></jsp:include>
	</div>
</div>

<script type="text/javascript">
try{
	$("btnUploadEnrolleesExit").observe("click", function(){
		var parId = (objUWGlobal.packParId != null ? objCurrPackPar.parId : objUWParList.parId);
		
		overlayUploadEnrollees.close();
		
		//$("btnGroupedItems").click();  //marco - 10.01.2012 - added condition when called from endorsement
		if(nvl(objUWGlobal.callingForm, "") == "GIPIS065"){
			groupedItemsOverlay.close();
			objUW.showEndtAccidentGroupedItemsOverlay();
		}
		
		/*
		hideOverlay();
		if ($("uploadEnrolleesSaved").value == "Y"){
			$("uploadEnrolleesSaved").value = "";
			showNotice("Please wait,refreshing Grouped Items...");
			//showAccidentGroupedItemsModal($F("globalParId"),$F("itemNo"),"Y");
		}
		*/
		if($("groupedItemsDetail") != null)
			$($("groupedItemsDetail").up().up().up().identify()).setStyle({overflow: "auto"}); // added by apollo cruz 04.20.2015 - to show the scrollbar of Additional Information Overlay after uploading a file
	});
	
	$("btnUploadEnrolleesDetails").observe("click", function(){
		if($$("#uploadEnrolleeTable .selectedRow").length > 0){
			$("createToParDiv").hide();	
			$("uploadEnrolleesFileDiv").hide();
			$("viewUploadedFilesDetail").show();	
			$("uploadEnrolleesDiv2").show();
			window.scrollTo(0,0); 
			
			tbgUploadDetails.resize();
		}else{
			showMessageBox("Please select an Uploaded Files first.", imgMessage.ERROR);
			return false;
		}
	});
	
	$("btnUploadEnrolleesDetailsHide").observe("click", function(){
		$("viewUploadedFilesDetail").hide();
		window.scrollTo(0,0);
	});
	
	function defaultUploadEnrollee(){
		try{
			window.scrollTo(0,0); 
			$("file").clear();
			$("pct").update();
			$("progressBar").style.width = "0%";
			$("uploadMessage").update();
			$("uploadEnrolleesPolicyForm").enable();
			$("trgID").contentWindow.document.body.innerHTML = "";
			$("progressBar").hide();
			enableButton("btnStart");
			enableButton("btnErrorLog");
			enableButton("btnCancelUpload");
			Effect.Fade("errors", {duration: .3});
		}catch(e){
			showErrorMessage("defaultUploadEnrollee", e);
		}		
	}	
	
	$("btnUploadEnrolleesUploadFiles").observe("click", function(){
		$("uploadEnrolleesFileDiv").show();
		$("createToParDiv").hide();	
		$("viewUploadedFilesDetail").hide();
		$("btnErrorLog").value = "Show Error Log";
		defaultUploadEnrollee();
	});	
	
	$("btnUploadEnrolleesCreateToPar").observe("click", function(){
		if ($$("#uploadEnrolleeTable .selectedRow").length > 0){
			var filename = tbgUploadEnrollees.getValueAt(tbgUploadEnrollees.getCurrentPosition()[0], tbgUploadEnrollees.getCurrentPosition()[1]);
			$("viewUploadedFilesDetail").hide();
			$("uploadEnrolleesFileDiv").hide();	
			window.scrollTo(0,0); 
			
			$("createToParDiv").down("label",0).update("Loading data " + filename + " to " + $F("parNo"));
			$("createToParDiv").show();	
			window.scrollTo(0,0); 
		}else{
			showMessageBox("Please select an Uploaded Files first.", imgMessage.ERROR);
			return false;
		}
	});

	$("btnCreateToParCancel").observe("click", function(){
		$("createToParDiv").hide();	
	});
	
	$("btnCreateToParOk").observe("click", function(){
		var parId = (objUWGlobal.packParId != null ? objCurrPackPar.parId : objUWParList.parId);
		var uploadNo = $F("uploadNo");//getSelectedRowAttrValue("uploadEnr","uploadNo");
		
		/* if(objUWParList.parType == "E"){ //added by christian 04/29/2013
			new Ajax.Request(contextPath + "/GIPILoadHistController?action=getCreatedPar&parId="+parId+"&itemNo="+$F("itemNo")+"&uploadNo="+uploadNo, {
				method : "POST",
				asynchronous : false,
				evalScripts : true,
				onCreate : 
					function(){
						//showNotice("Saving, please wait...");
						showLoading("progressBarMainDiv", "Saving, please wait...", "0");
					},
				onComplete :
					function(response){
						if (checkErrorOnResponse(response)) {		
							hideNotice();
							$("uploadEnrolleesSaved").value = "Y";		
							
							var createdParArray = eval(response.responseText);
							objACGlobal.addCreatedParEndt(createdParArray);
							objACGlobal.createdParArray = createdParArray;
							
							overlayUploadEnrollees.close();
	                		showUploadEnrolleesOverlay2(parId, $F("itemNo"), "");
						}	
						$("progressBarMainDiv").update("&nbsp;");
					}
			});
		}else{ */ //marco - 05.08.2014 - records should automatically be saved - QA-Testing SR #413 (uncomment to revert to manual saving)
			new Ajax.Request(contextPath + "/GIPILoadHistController?action=saveCreateToPar&parId="+parId+"&itemNo="+$F("itemNo")+"&uploadNo="+uploadNo, {
				method : "POST",
				parameters:{
					lineCd: (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : objUWParList.lineCd),
					issCd: (objUWGlobal.packParId != null ? objCurrPackPar.issCd : objUWParList.issCd)
				},
				asynchronous : false,
				evalScripts : true,
				onCreate : 
					function(){
						//showNotice("Saving, please wait...");
						showLoading("progressBarMainDiv", "Saving, please wait...", "0");
					},
				onComplete :
					function(response){
						if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {		
							if (response.responseText == "SUCCESS"){
								hideNotice();
								$("uploadEnrolleesSaved").value = "Y";							
								//$("createToParDiv").hide();							
								showWaitingMessageBox("Creation to PAR successful.", imgMessage.SUCCESS, function(){
									if(typeof tbgGroupedItems !== 'undefined' && tbgGroupedItems != null){
										tbgGroupedItems._refreshList(); // added by apollo cruz 04.20.2015 - to show new uploaded records in the tablegrid after uploading										
									}
									var parId = (objUWGlobal.packParId != null ? objCurrPackPar.parId : objUWParList.parId);
		                    		changeTag = 1; // bonok :: 01.14.2013 :: UCPBGEN-QA SR: 11911
		                    		overlayUploadEnrollees.close();
		                    		showUploadEnrolleesOverlay2(parId, $F("itemNo"), "");
		                    	});
							}			
						}	
						$("progressBarMainDiv").update("&nbsp;");
					}
			});
		//}
	});
}catch(e){
	showErrorMessage("Upload Enrollees Page", e);
}
</script>