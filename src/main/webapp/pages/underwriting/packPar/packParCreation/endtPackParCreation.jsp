<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="packPackCreationDiv">	
	<div id="endtPackParCreationMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<input type="hidden" 	id="basicEnabled" 	name="basicEnabled" value="" />
				<ul>
					<li><a id="packBasicInformation">Basic Information</a></li>
					<li><a id="endtPackParCreationExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="outerDiv">
			<label id="">Package PAR Information - Endorsement</label>
			<span class="refreshers" style="margin-top: 0;">
				<label name="gro" style="margin-left: 5px;">Hide</label>
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
		</div>
	</div>
	<form id="createPackPARForm">
		<div class="sectionDiv" id="endtPackParInformationDiv" style="margin-bottom: 10px;" changeTagAttr="true">
			<div id="endtPackParInformation" style="margin: 20px 0;">
				<table width="80%" align="center" cellspacing="1" border="0">
					<tr>
						<td class="rightAligned" style="20%">Line of Business</td>
						<td class="leftAligned" style="30%">
							<select id="endtPackLineCd" name="endtPackLineCd" class="required" style="text-align:left; width:80%;">
								<option value=""></option>
								<c:forEach var="line" items="${lineListing}">
									<option value="${line.lineCd}">${line.lineName}</option>
								</c:forEach>
							</select>
						</td>
						<td class="rightAligned" style="width: 20%">Issuing Source</td>
						<td class="leftAligned" style="width: 30%;">
							<select id="endtIssueSource" name="endtIssueSource" class="required" style="text-align: left; width:80%;">
								<option value=""></option>
								<c:forEach var="issueSource" items="${issourceListing}">
									<option value="${issueSource.issCd}">${issueSource.issName}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 20%">Year</td>
						<td class="leftAligned" style="width: 30%;">
							<input type="text" style="width:77%;" id="year" name="year" value="${year}" class="required" maxlength="4">
						</td>
						<td class="rightAligned" style="20%">Pack PAR Sequence No.</td>
						<td class="leftAligned" style="width: 30%">
							<input type="text" style="width:77%;" id="parSeqNo" name="parSeqNo" readonly="readonly" value="${savedPackPAR.parSeqNo}"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 20%;">Quote Sequence No.</td>
						<td class="leftAligned" style="width: 30%">
							<input type="text" style="width:77%;" id="quoteSeqNo" name="quoteSeqNo" value="00" readonly="readonly">
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width:20%;">Remarks</td>
						<td class="leftAligned" colspan="3" style="80%">
							<div style="border: 1px solid gray; height: 20px; width: 92.5%;">
								<textarea id="remarks" class="leftAligned" name="remarks" style="width: 94%; border: none; height: 13px;"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" />
							</div>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div id="endtPackParCreationButtonsDiv" name="endtPackParCreationButtonsDiv" class="sectionDiv" style="border:0;">
			<table align="center">
				<tr>
					<td colspan="4" align="center">
						<input id="btnCreateNew" class="button" type="button" value="Create New" name="btnCreateNew" style="display: none;"/>
						<input id="btnCancel" class="button" type="button" value="Cancel" name="btnCancel"/>
						<input id="btnSave" class="button" type="button" value="Save" name="btnSave">
						<br/>
					</td>
				</tr>
			</table>
		</div>
		<div id="endtPackParHidDiv" name="endtPackParHidDiv" style="display: none;">
			<input type="hidden"	name="packParId"	id="packParId"		value="0">
			<input type="hidden" 	name="vlineCd" 		id="vlineCd"/>
			<input type="hidden" 	name="vissCd" 	 	id="vissCd"/>
			<input type="hidden"  	name="defaultYear"	id="defaultYear" 	value="${year}">
			<input type="hidden"	name="defaultIssCd"	id="defaultIssCd"  	value="${defaultIssCd}">
			<input type="hidden"	name="parType"		id="parType" 		value="E">
			<input type="hidden"	name="quoteId"		id="quoteId">
			<input type="hidden"	name="assuredNo"	id="assuredNo"		value="">
		</div>
	</form>
</div>

<jsp:include page="/pages/underwriting/menus/basicInfoMenu.jsp"></jsp:include>
<div id="parInfoDiv" name="parInfoDiv" style="display: none;"></div>

<script type="text/javascript">
	setModuleId("GIPIS056A");
	setDocumentTitle("Package PAR Creation - Endorsement");
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	clearObjectValues(objUWGlobal);// added by: nica 02.17.2011 - to clear objUWGlobal object
	clearPackParParameters();
	$("packBasicInformation").hide();
	$("endtIssueSource").value = $("defaultIssCd").value;
	$("vissCd").value = $("endtIssueSource").value;
	changeTag = 0;

	var validLineIssueSource = JSON.parse('${validPackLineIssueSourceList}');
	//synchPackLineWithIssueSource();
	var selectedLine = "${selectedLineCd}";
	
	$("endtPackLineCd").observe("change", function(){
		$("vlineCd").value = $("endtPackLineCd").value;
		resetEndtPackCreationFields();
		
		if(this.value != ""){
			synchIssSourceWithPackLine();
		}else{
			$("endtIssueSource").childElements().each(function(o){
				o.show(); o.disabled = false;
			});
		}
	});

	$("endtIssueSource").observe("change", function(){
		if(this.value != ""){
			synchPackLineWithIssueSource();
			$("endtPackLineCd").value = "";
		}else{
			$("endtPackLineCd").childElements().each(function(o){
				o.show(); o.disabled = false;
			});
		}
		$("vissCd").value = $("endtIssueSource").value;
	});

	$("year").observe("blur", function(){
		var yearCharacters = ($("year").value.split("")).length;

		if($("year").value == ""){
			showMessageBox("Year is required.");
			$("year").focus();
		}else if(isNaN($("year").value) || yearCharacters != 4){
			showMessageBox( "Field should be in form 0009.");
			$("year").value = $("defaultYear").value;
		}else if($("year").value <= 0){
			$("year").value = $("defaultYear").value;
		}
	});

	$("year").observe("keyup", function(){
		if(isNaN($("year").value)){
			showMessageBox( "Field should be in form 0009.");
		}
	});

	$("remarks").observe("keyup", function () {
		limitText(this, 4000);
	});

	$("editRemarks").observe("click", function () {
		if($("btnSave").hasClassName("button")){
			showEditor("remarks", 4000);
		}
	});

	$("btnSave").observe("click", function(){
		if(changeTag == 0 && $("btnCreateNew").style.display != "none"){
			showMessageBox(objCommonMessage.NO_CHANGES, imgMessage.INFO);
			return false;
		}
		if(validateEndtPackPar()){
			savePackPAR("E");
			changeTag = 0;
		}
	});

	$("btnCancel").observe("click", checkChangeTagBeforeUWMain);

	$("packBasicInformation").observe("click", function(){
		creationFlag = true; // added by: nica 02.17.2011 - for UW menu exit to determine if PAR originates from creation
		showEndtPackParBasicInfo();
	});

	$("endtPackParCreationExit").observe("click", function () {
		checkChangeTagBeforeUWMain();
	});

	$("btnCreateNew").observe("click", reloadEndtPackParCreationPage);

	observeReloadForm("reloadForm", reloadEndtPackParCreationPage);

	function reloadEndtPackParCreationPage(){
		showEndtPackParCreationPage($("endtPackLineCd").value);
		clearPackParParameters();
	}

	function validateEndtPackPar(){
		var result = true;
		var fields = ["endtPackLineCd", "endtIssueSource", "year"];
		var msg = ["Line of Business", "Issuing Source", "Year"];

		for(var i=0; i<fields.length; i++){
			if($(fields[i]).value.blank()){
				showMessageBox(msg[i] + " is required.");
				$(fields[i]).focus();
				result = false;
			}
		}
		return result;
	}

	function resetEndtPackCreationFields(){
		$("parSeqNo").value = "";
		$("year").value = $("defaultYear").value;
		$("packBasicInformation").hide();
	}

	/*function getIssCdsOfLineCdSelected(lineCd){
		new Ajax.Request(contextPath+"/GIPIPackPARListController?action=getIssCds", {
			asynchronous: true,
			parameters:{lineCd: lineCd,
						parType: "E"
			},
			onComplete:function(response){
				if(checkErrorOnResponse(response)){
					objIssCds = JSON.parse(response.responseText);
					updateIssCdField(objIssCds);
				}
			}
		});
	}

	function updateIssCdField(list){
		var opt = "";
		opt += '<option value=""></option>';
		
		for(var i=0; i<list.length; i++){
			opt+= '<option value="'+list[i].issCd+'">'+list[i].issName+'</option>';			
		}
		$("endtIssueSource").update(opt);
		$("endtIssueSource").value = $("defaultIssCd").value;
	}*/

	function synchPackLineWithIssueSource(){
		var endtLine = $("endtPackLineCd");
		var lineIss = validLineIssueSource;
		
		$("endtPackLineCd").childElements().each(function(o){
			o.hide(); o.disabled = true;
		});

		for(var i=0; i<validLineIssueSource.length; i++){
			var issCd = $("endtIssueSource").options[$("endtIssueSource").selectedIndex].value;
			for(var c=0; c<endtLine.length; c++){
				if(endtLine.options[c].value == lineIss[i].lineCd && issCd == lineIss[i].issCd || endtLine.options[c].value == ""){
					endtLine.options[c].show();
					endtLine.options[c].disabled = false;
				}			
			}
		}
	}

	function synchIssSourceWithPackLine(){
		var endtIssSource = $("endtIssueSource");
		var lineIss = validLineIssueSource;
		
		$("endtIssueSource").childElements().each(function(o){
			o.hide(); o.disabled = true;
		});

		for(var i=0; i<validLineIssueSource.length; i++){
			var lineCd = $("endtPackLineCd").options[$("endtPackLineCd").selectedIndex].value;
			for(var c=0; c<endtIssSource.length; c++){
				if(endtIssSource.options[c].value == lineIss[i].issCd && lineCd == lineIss[i].lineCd || endtIssSource.options[c].value == ""){
				   endtIssSource.options[c].show();
				   endtIssSource.options[c].disabled = false;
				}			
			}
		}
	}
	
	// to assign selected line if called from Endt Package PAR listing - Nica 08.18.2012
	for(var i=0; i<$("endtPackLineCd").options.length; i++){
		if(selectedLine == $("endtPackLineCd").options[i].value && !($("endtPackLineCd").options[i].disabled)){
			$("endtPackLineCd").value = selectedLine;
			fireEvent($("endtPackLineCd"), "change");
		}
	}

	initializeChangeTagBehavior(function(){fireEvent($("btnSave"), "click");});
	
</script>

