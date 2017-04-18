<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
	<jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include>
	<div style="float:left; margin-bottom:10px; width:100%;">
	<div id="viewUploadedFiles" style="width:98%; margin:auto; margin-top:10px;">
		<div id="outerDiv" name="outerDiv" style="width:100%;  margin:auto;" >
			<div id="innerDiv" name="innerDiv">
				<label>View Uploaded Files</label>
			</div>
		</div>	
		<div id="uploadEnrolleesDiv" name="uploadEnrolleesDiv" class="sectionDiv" style="display:none; width:100%; margin:auto;" align="center">
			<jsp:include page="/pages/underwriting/overlay/subPages/uploadEnrolleesUploadedFilesListing.jsp"></jsp:include>
	
			<div id="createToParDiv" style="width:100%; margin:auto; display:none;">
				<table style="align:center;">
					<tr><td>
					<input type="hidden" id="parNo" name="parNo" value="${gipiParlist.parNo }" />	
					<input type="hidden" id="parId" name="parId" value="${gipiParlist.parId }" />
					<input type="hidden" id="itemNo" name="itemNo" value="${itemNo }" />
					<input type="hidden" id="uploadEnrolleesSaved" name="uploadEnrolleesSaved" value="${uploadEnrolleesSaved }" />
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
				<input type="button" class="button" id="btnUploadEnrolleesDetails" 		name="btnUploadEnrolleesDetails" 		value="Details" style="width:60px;"/>
				<input type="button" class="button" id="btnUploadEnrolleesUploadFiles" 	name="btnUploadEnrolleesUploadFiles" 	value="Upload Files" />
				<input type="button" class="button" id="btnUploadEnrolleesCreateToPar" 	name="btnUploadEnrolleesCreateToPar" 	value="Create to PAR" />
				<input type="button" class="button" id="btnUploadEnrolleesExit" 		name="btnUploadEnrolleesExit" 			value="Exit" style="width:60px;" />
			</div>
		</div>
	</div>	
	
	<div id="viewUploadedFilesDetail" style="width:98%; margin:auto; margin-top:0px; display:none;">
		<div id="outerDiv" name="outerDiv" style="width:100%;  margin:auto; margin-bottom:0px;" >
			<div id="innerDiv" name="innerDiv">
				<label>View Uploaded Files Details</label>
			</div>
		</div>	
		<div id="uploadEnrolleesDiv2" name="uploadEnrolleesDiv2" class="sectionDiv" style="display:block; width:100%; margin:auto; margin-top:0px;" align="center">
			<jsp:include page="/pages/underwriting/overlay/subPages/uploadEnrolleesUploadedFilesListingDetail.jsp"></jsp:include>
			<div style="float:left; width:100%; margin-top:10px; margin-bottom:10px;">
				<input type="button" class="button" id="btnUploadEnrolleesDetailsHide" 	name="btnUploadEnrolleesDetailsHide" value="Hide" style="width:60px;" />
			</div>		
		</div>
	</div>

	<div id="uploadEnrolleesFileDiv" style="width:98%; margin:auto; margin-top:2px; display:none;">
		<div id="outerDiv" name="outerDiv" style="width:100%;  margin:auto; margin-bottom:0px;" >
			<div id="innerDiv" name="innerDiv">
				<label>Grouped Accident Uploading Module</label>
			</div>
		</div>	
		<jsp:include page="/pages/underwriting/overlay/subPages/uploadEnrollees.jsp"></jsp:include>
	</div>
</div>	
<script type="text/javascript">
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	disableButton("btnUploadEnrolleesDetails");
	disableButton("btnUploadEnrolleesCreateToPar");

	$("btnUploadEnrolleesExit").observe("click", function(){
		hideOverlay();
		if ($("uploadEnrolleesSaved").value == "Y"){
			$("uploadEnrolleesSaved").value = "";
			showNotice("Please wait,refreshing Grouped Items...");
			showAccidentGroupedItemsModal($F("globalParId"),$F("itemNo"),"Y");
		}	
	});

	$("close").observe("click", function(){
		if ($("uploadEnrolleesSaved").value == "Y"){
			$("uploadEnrolleesSaved").value = "";
			showNotice("Please wait,refreshing Grouped Items...");
			showAccidentGroupedItemsModal($F("globalParId"),$F("itemNo"),"Y");
		}
	});


	$("btnUploadEnrolleesDetails").observe("click", function(){
		if (checkUploadNoExist()){
			$("createToParDiv").hide();	
			$("uploadEnrolleesFileDiv").hide();
			$("viewUploadedFilesDetail").show();	
			$("uploadEnrolleesDiv2").show();
			window.scrollTo(0,0); 
		}else{
			return false;
		}
	});
	$("btnUploadEnrolleesDetailsHide").observe("click", function(){
		$("viewUploadedFilesDetail").hide();	
		window.scrollTo(0,0);
	});

	$("btnUploadEnrolleesCreateToPar").observe("click", function(){
		if (checkUploadNoExist()){
			$("viewUploadedFilesDetail").hide();
			$("uploadEnrolleesFileDiv").hide();	
			window.scrollTo(0,0); 
			
			$("createToParDiv").down("label",0).update("Loading data "+getSelectedRowAttrValue("uploadEnr","filename")+" to "+$F("parNo"));
			$("createToParDiv").show();	
			window.scrollTo(0,0); 
		}else{
			return false;
		}
	});

	$("btnCreateToParCancel").observe("click", function(){
		$("createToParDiv").hide();	
	});

	$("btnCreateToParOk").observe("click", function(){
		var uploadNo = getSelectedRowAttrValue("uploadEnr","uploadNo");
		new Ajax.Request(contextPath + "/GIPILoadHistController?action=saveCreateToPar&parId="+$F("parId")+"&itemNo="+$F("itemNo")+"&uploadNo="+getSelectedRowAttrValue("uploadEnr","uploadNo"), {
			method : "POST",
			parameters:{
				lineCd: $F("globalLineCd"),
				issCd: $F("globalIssCd")
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
					if (checkErrorOnResponse(response)) {		
						if (response.responseText == "SUCCESS"){
							//hideNotice();
							$("uploadEnrolleesSaved").value = "Y";
							$$("div[name='uploadEnr']").each(function(row){
								if (row.getAttribute("uploadNo") == uploadNo){
									row.remove();
								}	
							});	
							$("createToParDiv").hide();	
							checkTableItemInfo("uploadEnrolleesTable","uploadEnrolleesListing","uploadEnr");
							showMessageBox("Creation to PAR successful.", imgMessage.SUCCESS);
						}			
					}	
					$("progressBarMainDiv").update("&nbsp;");
				}
		});	
	});

	function checkUploadNoExist(){
		var ok = true;
		var selected = 0;
		
		$$("div[name='uploadEnr']").each(function(row){
			if (row.hasClassName("selectedRow")){
				selected = 1;
			}	
		});	
		
		if (selected == 0){
			showMessageBox("Please select an Uploaded Files first.", imgMessage.ERROR);
			ok = false;
		}
		return ok;
	}

	$$("div[name='uploadEnr']").each(function(row){
		enableButton("btnUploadEnrolleesDetails");	
		enableButton("btnUploadEnrolleesCreateToPar");	
	});

	$("btnCancelUpload").observe("click", function(){
		$("uploadEnrolleesFileDiv").hide();
		defaultUploadEnrollee();
	});
	$("btnUploadEnrolleesUploadFiles").observe("click", function(){
		$("uploadEnrolleesFileDiv").show();
		$("createToParDiv").hide();	
		$("viewUploadedFilesDetail").hide();	
		defaultUploadEnrollee();
	});

	function defaultUploadEnrollee(){
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
	}	
</script>	