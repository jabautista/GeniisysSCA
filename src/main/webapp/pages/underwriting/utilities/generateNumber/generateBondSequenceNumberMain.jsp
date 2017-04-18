<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="genBondSeqNoMainDiv">
	<!-- Menu section -->
	<div id="genBondSeqNoMenuDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="exit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	
	<!-- Body Section -->
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;"><!-- Header -->
		<div id="innerDiv" name="innerDiv">
			<label>Generate Bond Sequence Number</label>  
			<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
		</div>
	</div>
	<div id="genBondSeqNoBodyDiv" name="genBondSeqNoBodyDiv" class="sectionDiv"><!-- Body -->
		<div id="genBondSeqNoInnerDiv" name="genBondSeqNoInnerDiv" align="center" style="margin: 10px; padding-top: 25px; padding-bottom: 20px; font-size: 24px">
			Generate Bond Sequence Number
		</div>
		<div id="bondSeqNoReqFields" class="roundCorner" align="center" style="margin: 0 auto; height: relative; width: 650px;"  >
			<table align="center" style="padding-top: 30px; padding-bottom: 30px;">
				<tr>
					<td class="rightAligned">Line Code </td>
					<td>
						<span class="required lovSpan" style="width: 87px;">
							<input id="txtLineCd" name="txtLineCd" class="required validate upper" type="text" maxlength="2" style="width: 60px; float: left; border: medium none; height: 13px; margin: 0pt;" lastValidValue="" tabindex="101">
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineCd" name="searchLineCd" alt="Go" style="float: right;"/>
						</span>
					</td>
					<td><input id="txtLineName" name="txtLineName" class="required" type="text" style="width: 280px" readonly="readonly" tabindex="102"></td>
				</tr>
				<tr>
					<td class="rightAligned">Bond Type/Subline </td>
					<td>
						<span class="required lovSpan" style="width: 87px;">
							<input id="txtSublineCd" name="txtSublineCd" class="required validate upper" type="text" maxlength="7" style="width: 60px; float: left; border: medium none; height: 13px; margin: 0pt;" lastValidValue="" tabindex="103">
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchSublineCd" name="searchSublineCd" alt="Go" style="float: right;"/>
						</span>
					</td>
					<td><input id="txtSublineName" class="required" type="text" style="width: 280px" readonly="readonly" tabindex="104"></td>
				</tr>
				<tr>
					<td class="rightAligned">No. of Sequence </td>
					<td colspan="2"><input id="txtNoOfSequence" name="txtNoOfSequence" class="required rightAligned validate integerNoNegativeUnformatted" type="text" maxlength="7" style="width: 373px" tabindex="105"></td>
					
				</tr>
				<tr id="trGeneratedBondSeq" style="display: none;">
					<td class="rightAligned">Bond Sequence No. </td>
					<td colspan="2"><input id="txtGeneratedBondSeq" class="rightAligned" type="text" style="width: 373px" maxlength="7" readonly="readonly" tabindex="106"></td>
				</tr>
			</table>
		</div>
		<div style="width: 100%; margin: 10px 0; padding-top: 15px; padding-bottom: 15px" align="center" >
			<input type="button" class="button" style="width: 100px;" id="btnGenerate" name="btnGenerate" value="Generate" tabindex="107"/>
			<input type="button" class="button" style="width: 100px;" id="btnHistory" name="btnHistory" value="History" tabindex="108"/>
		</div>
	</div>
</div>

<script type="text/javascript">
	function initializeModule(){
		changeTag = 0;
		setModuleId("GIUTS036");
		setDocumentTitle("Generate Bond Sequence Number");
		addStyleToInputs();
		initializeAll();
		initializeChangeAttribute();
		makeInputFieldUpperCase();
		observeReloadForm("reloadForm", showGenerateBondSeqNoPage);
		$("txtLineCd").focus();
	};
	
	function showLineCdLOV(){
		try{
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {
					action : "getLineCdLOVGiuts036",
					filterText: ($F("txtLineCd") != $("txtLineCd").getAttribute("lastValidValue") ? nvl($F("txtLineCd"), "%") : "%").toUpperCase(),
					page : 1
				},
				title: "List of Lines",
				width: 650,
				height: 386,
				columnModel:[
							{	id : "lineCd",
								title: "Line Code",
								width: '300px'
							},
							{	id : "lineName",
								title: "Line Name",
								width: '300px'
							}
							],
				draggable: true,
				showNotice: true,
				autoSelectOneRecord : true,
				filterText: ($F("txtLineCd") != $("txtLineCd").getAttribute("lastValidValue") ? nvl($F("txtLineCd"), "%") : "%").toUpperCase(),
				noticeMessage: "Getting list, please wait...",
				onSelect: function(row){
					$("txtLineCd").value = row.lineCd;
					$("txtLineName").value = row.lineName;
					$("txtLineCd").setAttribute("lastValidValue", row.lineCd);
					$("trGeneratedBondSeq").hide();
				},
				onCancel: function(){
					$("txtLineCd").value = $("txtLineCd").getAttribute("lastValidValue");
				},
				onUndefinedRow: function(){
					showMessageBox("No record selected.", "I");
					$("txtLineCd").value = $("txtLineCd").getAttribute("lastValidValue");
				},
				onShow: function(){
					$(this.id+"_txtLOVFindText").focus();
				}
			});
		} catch (e){
			showErrorMessage("showLineCdLOV", e);
		}
	};
	
	function validateLineCd(){
		try {
			$("trGeneratedBondSeq").hide();
			if ($("txtLineCd").value == ""){
				$("txtLineName").value = "";
				$("txtLineCd").setAttribute("lastValidValue", "");
				
				$("txtSublineCd").value = "";
				$("txtSublineName").value = "";
				$("txtSublineCd").setAttribute("lastValidValue", "");
				return;
			} else {
				new Ajax.Request(contextPath+"/GenerateBondSeqController", {
					method: "POST",
					parameters: {
						action : "validateLineCd",
						lineCd : $("txtLineCd").value 
					},
					onComplete: function (response)	{
						if (response.responseText.slice(0, 1) + response.responseText.slice(-1) != "{}"){
							showMessageBox(response.responseText, imgMessage.ERROR);
						} else {
							r = JSON.parse(response.responseText);
							if (r.result == "VALID"){
								$("txtLineCd").setAttribute("lastValidValue", $F("txtLineCd"));
								$("txtLineName").value = r.giisLine.lineName;
							} else {
								showLineCdLOV();
							}					
						}
					}
				});
			}
		} catch (e){
			showErrorMessage("validateLineCd", e);
		}
	};
	
	function showSublineCdLOV(){
		try{
			if ($("txtLineCd").value == ""){
				showWaitingMessageBox("Please enter Line Code first.", imgMessage.ERROR, function(){
					$("txtLineCd").focus();
				});
				return;
			}
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {
					action : "getSublineLOVGiuts036",
					lineCd : $("txtLineCd").value.toUpperCase(),
					filterText: ($F("txtSublineCd") != $("txtSublineCd").getAttribute("lastValidValue") ? nvl($F("txtSublineCd"), "%") : "%").toUpperCase(),
					page : 1
				},
				title: "List of Sublines",
				width: 650,
				height: 386,
				columnModel : [
				    {
						id : "sublineCd",
						title: "Subline Code",
						width: '300px'
					},
					{	id : "sublineName",
						title: "Subline Name",
						width: '300px'
					}
				],
				draggable: true,
				showNotice: true,
				autoSelectOneRecord : true,
				filterText: ($F("txtSublineCd") != $("txtSublineCd").getAttribute("lastValidValue") ? nvl($F("txtSublineCd"), "%") : "%").toUpperCase(),
				noticeMessage: "Getting list, please wait...",
				onSelect: function(row){
					$("txtSublineCd").value = row.sublineCd;
					$("txtSublineName").value = unescapeHTML2(row.sublineName);
					$("txtSublineCd").focus();
					$("txtNoOfSequence").value = "";
					$("trGeneratedBondSeq").hide();
					$("txtSublineCd").setAttribute("lastValidValue", row.sublineCd);
				},
				onCancel: function(){
					$("txtSublineCd").value = $("txtSublineCd").getAttribute("lastValidValue");
				},
				onUndefinedRow: function(){
					showMessageBox("No record selected.", "I");
					$("txtSublineCd").value = $("txtSublineCd").getAttribute("lastValidValue");
				},
				onShow: function(){
					$(this.id+"_txtLOVFindText").focus();
				}
			});
			
		} catch (e){
			showErrorMessage("showSublineCdLOV", e);
		}
	};
	
	function validateSublineCd(){
		try {
			$("trGeneratedBondSeq").hide();
			if ($("txtSublineCd").value == ""){
				$("txtSublineName").value = "";
				$("txtSublineCd").setAttribute("lastValidValue", "");
				return;
			} else if ($("txtLineCd").value == ""){
				showWaitingMessageBox("Please enter Line Code first.", imgMessage.ERROR, function(){
					$("txtSublineCd").value = "";
					$("txtSublineName").value = "";
					$("txtLineCd").focus();
				});
				return;
			}
			new Ajax.Request(contextPath+"/GenerateBondSeqController", {
				method: "POST",
				parameters: {
					action : "validateSublineCd",
					lineCd : $("txtLineCd").value,
					sublineCd : $("txtSublineCd").value
				},
				onComplete: function (response)	{
					if (response.responseText.slice(0, 1) + response.responseText.slice(-1) != "{}"){
						showMessageBox(response.responseText, imgMessage.ERROR);
					} else {
						r = JSON.parse(response.responseText);
						if (r.result == "VALID"){
							$("txtSublineName").value = r.giisSubline.sublineName;
							$("txtNoOfSequence").value = "";
							$("txtSublineCd").setAttribute("lastValidValue", $F("txtSublineCd"));
						}else{
							showSublineCdLOV();
						}
					}
				}
			});
		
		} catch (e){
			showErrorMessage("validateSublineCd", e);
		}
	};
	
	function validateNoOfSequence(){
		var s = $("txtNoOfSequence").value;
		if (s == ""){
			return;
		} else if (parseInt(s) != s || parseInt(s) < 1){
			showWaitingMessageBox("Invalid No. of Sequence. Valid value should be from 1 to 9999999.", "E", function(){
				$("txtNoOfSequence").value = "";
				$("txtNoOfSequence").focus();
				$("txtNoOfSequence").select();
				return;
			});
		}
	};
	
	function generateBondSequence(){
		if(!checkAllRequiredFieldsInDiv("bondSeqNoReqFields")){
			return false;
		}
		
		validateNoOfSequence();
		
		new Ajax.Request(contextPath+"/GenerateBondSeqController", {
			method: "POST",
			parameters: {
				action : "generateBondSequence",
				lineCd : $("txtLineCd").value,
				sublineCd : $("txtSublineCd").value,
				noOfSequence : $("txtNoOfSequence").value,
				moduleId : "GIUTS036"
			},
			onCreate: showNotice("Generating Bond Sequence, please wait..."),
			onComplete: function (response)	{
				hideNotice("");
				if (response.responseText.slice(0, 1) + response.responseText.slice(-1) != "{}"){
					showMessageBox(response.responseText, imgMessage.ERROR);
				} else {
					r = JSON.parse(response.responseText);
					if ("VALID" == r.result){
						showMessageBox("Bond Sequence Number for " + $("txtLineCd").value.toUpperCase() + 
								" - " + $("txtSublineCd").value.toUpperCase() + "\nSuccessfully generated.", imgMessage.CONFIRMATION);
						if (r.generatedBondSeq != null){
							$("txtGeneratedBondSeq").value = r.generatedBondSeq;
							$('trGeneratedBondSeq').show();
						} else {
							$('trGeneratedBondSeq').value = "";
							$('trGeneratedBondSeq').hide();
						}
					} else if ("INVALID_LINECD" == r.result){
						showWaitingMessageBox("Please enter a valid Line Code.", imgMessage.ERROR, function(){
							$("txtLineCd").focus();
						});
					} else if ("INVALID_SUBLINE" == r.result){
						showWaitingMessageBox("Please enter a valid Bond Type/Subline.", imgMessage.ERROR, function(){
							$("txtSublineCd").focus();
						});
					} else if ("INVALID_NOOFSEQUENCE" == r.result) {
						showWaitingMessageBox("No. of Sequence must be a number in range 1 to 9999999.", imgMessage.ERROR, function(){
							$("txtNoOfSequence").focus();
						});
					} else if ("ERROR" == r.result){
						showMessageBox(r.errorMessage, imgMessage.ERROR);
					}
				}
			}
		});
	};
	
	function showHistory(){
		overlayBondSeqHistory = Overlay.show(contextPath+"/GenerateBondSeqController", {
			urlContent: true,
			urlParameters: {
				action : "showBondSeqHistoryOverlay"
			},
		    title: "Bond Sequence History",
		    height: 340,
		    width: 800,
		    draggable: true
		});
		
	};

	$("txtLineCd").observe("change", validateLineCd);
	$("searchLineCd").observe("click", showLineCdLOV);
	$("txtSublineCd").observe("change", validateSublineCd);
	$("searchSublineCd").observe("click", showSublineCdLOV);
	$("txtNoOfSequence").observe("change", validateNoOfSequence);
	$("btnGenerate").observe("click", generateBondSequence);
	$("btnHistory").observe("click", showHistory);
	$("exit").observe("click", function(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});
	
	initializeModule();
</script>