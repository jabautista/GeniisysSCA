<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>
<% 
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="createMissingDistRecMainDiv" name="createMissingDistRecMainDiv" style="margin-top : 1px;">
	<div id="createMissingDistRecMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="createMissingDistRecQuery">Query</a></li>
					<li><a id="createMissingDistRecExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<form id="createMissingDistRecForm" name="createMissingDistRecForm">
		<div id="createMissingDistRecDiv">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
			   		<label>Create Missing Distribution Records for Posted Policy</label>
			   		<span class="refreshers" style="margin-top: 0;">
			   			<label id="showMissingDistRec" name="gro" style="margin-left: 5px;">Hide</label>
			   			<label id="reloadForm" name="reloadForm">Reload Form</label>
			   		</span>
			   	</div>
			</div>
			<div id="missingDistRec" class="sectionDiv">	
				<div id="policyInformation" style="margin: 10px;">
					<table cellspacing="2" border="0" style="margin: 10px auto;">
			 			<tr>
							<td class="rightAligned" style="width: 80px;" id="lblPolNo">Policy No. </td>
							<td class="leftAligned" style="width: 350px;">
								<input type="text" id="txtPolLineCd" name="txtPolLineCd" style="float: left; width: 30px; margin-right: 3px;" maxlength="2"/>
								<input type="text" id="txtPolSublineCd" name="txtPolSublineCd" class="" style="float: left; width: 70px; margin-right: 3px;" maxlength="7"/>
								<input type="text" id="txtPolIssCd" name="txtPolIssCd" class="" style="float: left; width: 30px; margin-right: 3px;" maxlength="2"/>
								<input type="text" id="txtPolIssueYy" name="txtPolIssueYy" class="" style="float: left; width: 30px; margin-right: 3px; text-align: right;" maxlength="2"/>
								<input type="text" id="txtPolPolSeqNo" name="txtPolPolSeqNo" class="" style="float: left; width: 70px; margin-right: 3px; text-align: right;" maxlength="7"/>
								<input type="text" id="txtPolRenewNo" name="txtPolRenewNo" class="" style="float: left; width: 30px; margin-right: 3px; text-align: right;" maxlength="2"/>
								<img id="hrefPolicyNo" alt="Policy No" style="height: 20px; margin-top: 3px; cursor: pointer;" class="" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />
							</td>
							<%-- <td class="leftAligned" style="width: 210px;">
								<div style="float: left; border: solid 1px gray; width: 216px; height: 20px; margin-right: 3px;">
									<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 185px; border: none; background-color: transparent;" name="txtPolicyNo" id="txtPolicyNo" readonly="readonly"/>
									<img id="hrefPolicyNo" alt="goPolicyNo" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
								</div>
							</td> --%>
							<td class="rightAligned" style="width: 80px;">Endt No.</td>
							<td class="leftAligned">
								<input id="txtEndtNo" name="txtEndtNo" type="text" style="width: 200px;" value="" readonly="readonly" />
							</td>
						</tr>
						<tr>
							<td class="rightAligned" style="width: 90px;" id="lblAssdName">Assured Name </td>
							<td class="leftAligned" colspan="3">
								<input id="txtAssdName" name="txtAssdName" type="text" style="width: 643px;" value="" readonly="readonly" />
							</td>
						</tr>
						<tr>
							<td class="rightAligned" style="width: 80px;">Dist. No.</td>
							<td class="leftAligned">
								<input id="txtDistNo" name="txtDistNo" type="text" style="width: 150px;" value="">
							</td>
							<td class="rightAligned" style="width: 80px;">Dist. Status</td>
							<td class="leftAligned">
								<input id="txtDistFlag" name="txtDistFlag" type="text" style="width: 38px;" value="" readonly="readonly" />
								<input id="txtMeanDistFlag" name="txtMeanDistFlag" type="text" style="width: 150px;" value="" readonly="readonly" />
							</td>
						</tr>
					</table>
					<!-- Hidden fields for corresponding columns of GIPI_POLBASIC_DIST_V1 -->
					<input type="hidden" id="txtPolDistV1LineCd" name="txtPolDistV1LineCd" readonly="readonly" value="" />
					<input type="hidden" id="txtMultiBookingMm" name="txtMultiBookingMm" readonly="readonly" value="" />
					<input type="hidden" id="txtMultiBookingYy" name="txtMultiBookingYy" readonly="readonly" value="" />
				</div>
			</div>
		</div>	
		<div class="buttonsDiv">
			<input type="button" id="btnCreateMissingRec" 	name="btnSave" 	class="disabledButton"	value="Create Distribution Records" />			
		</div>
	</form>
</div>	
<script type="text/javascript">
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	objGIPIPolbasicPolDistV1 = null;
	
	/*+ Menu +*/
	$("createMissingDistRecExit").observe("click", function(){
		checkChangeTagBeforeUWMain();
	});

	/*+ B2502 Block - GIPI_POLBASIC_POL_DIST_V1 +*/
	$("hrefPolicyNo").observe("click", function() {
		//showPolbasicPolDistV1Listing("showV1ListPopuMissDistRec&ajax=1"); replaced by: Nica 12.27.2012
		action = "showV1ListPopuMissDistRec&ajax=1&paramLineCd="+$("txtPolLineCd").value+"&paramSublineCd="+$("txtPolSublineCd").value+
		         "&paramIssCd="+$("txtPolIssCd").value+"&paramIssueYy="+$("txtPolIssueYy").value+"&paramPolSeqNo="+$("txtPolPolSeqNo").value+
		         "&paramRenewNo="+$("txtPolRenewNo").value+"&paramDistNo="+$("txtDistNo").value;
		showPolbasicPolDistV1Listing(action);
	});
	
	$("txtPolLineCd").observe("keyup", function(){
		$("txtPolLineCd").value = $F("txtPolLineCd").toUpperCase();
	});

	$("txtPolSublineCd").observe("keyup", function(){
		$("txtPolSublineCd").value = $F("txtPolSublineCd").toUpperCase();
	});

	$("txtPolIssCd").observe("keyup", function(){
		$("txtPolIssCd").value = $F("txtPolIssCd").toUpperCase();
	});

	$("txtPolIssueYy").observe("keyup", function(){
		if(isNaN($F("txtPolIssueYy"))){
			$("txtPolIssueYy").value = "";
		}
	});
	
	$("txtPolIssueYy").observe("blur", function(){
		if($("txtPolIssueYy").value != ""){
			$("txtPolIssueYy").value = formatNumberDigits($("txtPolIssueYy").value, 2);
		}
	});

	$("txtPolPolSeqNo").observe("keyup", function(){
		if(isNaN($F("txtPolPolSeqNo"))){
			$("txtPolPolSeqNo").value = "";
		}
	});
	
	$("txtPolPolSeqNo").observe("blur", function(){
		if($("txtPolPolSeqNo").value != ""){
			$("txtPolPolSeqNo").value = formatNumberDigits($("txtPolPolSeqNo").value, 7);
		}
	});

	$("txtPolRenewNo").observe("keyup", function(){
		if(isNaN($F("txtPolRenewNo"))){
			$("txtPolRenewNo").value = "";
		}
	});
	
	$("txtPolRenewNo").observe("blur", function(){
		if($("txtPolRenewNo").value != ""){
			$("txtPolRenewNo").value = formatNumberDigits($("txtPolRenewNo").value, 2);			
		}
	});
	
	$("txtDistNo").observe("keyup", function(){
		if(isNaN($F("txtDistNo"))){
			$("txtDistNo").value = "";
		}
	});
	
	$("txtDistNo").observe("blur", function(){
		if($("txtDistNo").value != ""){
			$("txtDistNo").value = formatNumberDigits($("txtDistNo").value, 8);
		}
	});

	$("btnCreateMissingRec").observe("click", function() {
		try{
			//if ($F("txtPolicyNo").blank()) return; replaced by: Nica 12.27.2012
			if($F("txtPolLineCd").blank() || $F("txtPolSublineCd").blank()||
			   $F("txtPolIssCd").blank() || $F("txtPolIssueYy").blank()||
			   $F("txtPolPolSeqNo").blank() || $F("txtPolRenewNo").blank()||
			   $F("txtDistNo").blank() ||objGIPIPolbasicPolDistV1 == null){
				showMessageBox("Please select record first.", "I");
				return false;
			}
			new Ajax.Request(contextPath+"/GIPIPolbasicPolDistV1Controller",{
				parameters:{
					action: "createMissingDistRec",
					distNo: objGIPIPolbasicPolDistV1.distNo,
					policyId: objGIPIPolbasicPolDistV1.policyId,
					packPolFlag: objGIPIPolbasicPolDistV1.packPolFlag,
					lineCd:	objGIPIPolbasicPolDistV1.lineCd,
					sublineCd: objGIPIPolbasicPolDistV1.sublineCd,
					issCd: objGIPIPolbasicPolDistV1.issCd 	
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function(){
					showNotice("Creating distribution records, please wait...");
				},
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));	
						if (res.message != "SUCCESS"){
							showMessageBox(res.message, "E");
						}else{
							disableButton("btnCreateMissingRec");
							showMessageBox("Distribution records for  policy "+nvl(objGIPIPolbasicPolDistV1.policyNo,"")+ (nvl(objGIPIPolbasicPolDistV1.endtNo,null) != null ? ("/"+objGIPIPolbasicPolDistV1.endtNo) :"") +" had been corrected.", "S");
						}	
					}	
				}	
			});
		}catch(e){
			showErrorMessage("btnCreateMissingRec observe", e);
		}		
	});
	
	observeReloadForm("reloadForm", showPopuMissDistRec);
	observeReloadForm("createMissingDistRecQuery", showPopuMissDistRec); // Nica - 12.27.2012
	window.scrollTo(0,0); 	
	hideNotice("");
	setModuleId("GIUTS999");
	setDocumentTitle("Create Missing Records for Posted Distribution");
</script>