<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="parCreationMainDiv" name="parCreationMainDiv">
	<div id="endtParCreationMenu">
			<div id="mainNav" name="mainNav">
				<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
					<ul>
						<li><a id="basicInformation">Basic Information</a></li>
						<li><a id="endtParCreationExit">Exit</a></li>
					</ul>
				</div>
			</div>
	</div>
	
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="outerDiv">
			<label id="">PAR Creation - Endorsement</label> 
			<span class="refreshers" style="margin-top: 0;">
			 	<label name="gro" style="margin-left: 5px;">Hide</label> 
			 	<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
		</div>
	</div>
	<form id="createEndtParForm">
	   <div class="sectionDiv" id="endtParInformationDiv" style="margin-bottom:10px;" changeTagAttr="true">
	   	   <div id="endtParInformation" style="margin: 10px 0;">
	   	   		<table width="80%" align="center" cellspacing="1" border="0">
	   	   			<tr>
	   	   				<td class="rightAligned" style="width: 20%;">Line of Business</td>
	   	   				<td class="leftAligned" style="width: 30%;"> 
	   	   					<select id="endtLineCd" name="endtLineCd" class="required" style="text-align: left; width: 80%;">
	   	   						<option> </option>
	   	   							<c:forEach var="line" items="${lineListing}">
									<option menuLineCd="${line.menuLineCd}" value="${line.lineCd}">${line.lineName}</option>				
								</c:forEach>
	   	   					</select>
	   	   				</td>
	   	   				<td class="rightAligned" style="width: 20%;">Issuing Source </td>
	   	   				<td class="leftAligned" style="width: 30%;">
	   	   					<select id="endtIssueSource" name="endtIssueSource" class="required" style="text-align: left; width: 80%;">
	   	   						<option></option>
	   	   						<c:forEach var="issource" items="${issourceListing}">
									<option value="${issource.issCd}">${issource.issName}</option>				
								</c:forEach>
	   	   					</select>
	   	   				</td>
	   	   			</tr>
	   	   			<tr>
	   	   				<td class="rightAligned" style="width: 20%;">Year </td>
	   	   				<td class="leftAligned" style="width: 30%;">
	   	   					<input type="text"  style="width: 77%" id="year" name="year" value="${year}" class="required" maxlength="4"/>
	   	   				</td>
	   	   				<td class="rightAligned" style="width: 20%;"> PAR Sequence No. </td>
	   	   				<td class="leftAligned" style="width: 30%;"> 
	   	   					<input type="text" style="width: 77%" id="inputParSeqNo" name="inputParSeqNo" readonly="readonly" value="${savedPAR.parSeqNo}"/>
	   	   				</td>
	   	   			</tr>
	   	   			<tr>
	   	   				<td class="rightAligned" style="width: 20%;">Quote Sequence No.</td>
	   	   				<td class="leftAligned" style="width: 30%;">
	   	   					<input type="text" style="width: 77%" id="quoteSeqNo" name="quoteSeqNo" value="00" readonly="readonly"/>
	   	   				</td>
	   	   			</tr>
	   	   			<tr>
						<td class="rightAligned" style="width:20%;">Remarks </td>
						<td class="leftAligned" colspan="3" style="width: 80%;">
							<div style="border: 1px solid gray; height: 20px; width: 92.5%;">
								<textarea id="remarks" class="leftAligned" name="remarks" style="width: 94%; border: none; height: 13px;" ></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" />
							</div>
						</td>
					</tr>
	   	   		</table>
	   	    </div>
	   </div>
	   <div  id="endtParCreationButtonsDiv" name="endtParCreationButtonsDiv" class="sectionDiv" style="border: 0;">
	   		<table align="center">
	   			<tr>
					<td colspan="4" align="center">
						<input id="btnCreateNew" class="button" type="button" value="Create New" name="btnCreateNew" style="display: none;">
						<input id="btnCancel" class="button" type="button" value="Cancel" name="btnCancel"/>
						<input id="btnSave" class="button" type="button" value="Save" name="btnSave"/>
						<br/>
					</td>
				</tr>
	   		</table>
	   
	   </div>
	   
	   
	   <div id="hiddenEndtDiv" name="hiddenEndtDiv" style="display: none;">
				<input type="hidden" name="assuredNo"   	id="assuredNo" 		value=""/>
				<input type="hidden" name="address1" 		id="address1"/>
				<input type="hidden" name="address2" 		id="address2"/>
				<input type="hidden" name="address3" 		id="address3"/>
				<input type="hidden" name="vlineCd" 		id="vlineCd"/>
				<input type="hidden" name="vissCd" 	 		id="vissCd"/>
				<input type="hidden" name="sublineCd" 		id="sublineCd"/>
				<input type="hidden" name="defaultIssCd"	id="defaultIssCd"	value="${defaultIssCd}"/>
				<input type="hidden" name="parType"			id="parType" 		value="E"/>
				<input type="hidden" name="parYy"			id="parYy" 			value="${year}"/>
				<input type="hidden" name="quoteId"			id="quoteId"		value="0" />
				<input type="hidden" name="keyWord" 		id="keyWord"/>
				<input type="hidden" name="defaultYear"		id="defaultYear"/>
				<input type="hidden" name="parId"			id="parId" 			value="${globalParId}"/>
				<input type="hidden" name="parSeqNo"		id="parSeqNo" 		value="${savedPar.parSeqNo}">
			</div>
	</form>
</div>
<div id="parListingMainDiv" style="display: none;" module="parCreation">
	<div id="parListingMenu">
		<div id="mainNav" name="mainNav">
			<div id="" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="endtParListingExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
</div>
<jsp:include page="/pages/underwriting/menus/basicInfoMenu.jsp"></jsp:include>
<div id="parInfoDiv" style="display: none;">
</div>


<script type="text/javascript">
	setModuleId("GIPIS056");
	setDocumentTitle("PAR Creation - Endorsement");
	clearObjectValues(objUWParList);
	clearObjectValues(objGIPIWPolbas);
	clearObjectValues(objUWGlobal);
	clearParParameters();
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	$("basicInformation").hide();
	$("defaultYear").value = $("year").value;
	$("endtIssueSource").value = $("defaultIssCd").value;
	$("vissCd").value = $("endtIssueSource").value;
	changeTag = 0;

	var validLineIssueSource = JSON.parse('${validLineIssueSourceList}');
	var selectedLine = "${selectedLineCd}";
	
	synchLineWithIssueSource();
	
	$("endtLineCd").observe("change", function(){
		if(this.value != ""){
			synchIssSourceWithLine();
		}else{
			$("endtIssueSource").childElements().each(function(o){
				o.show(); o.disabled = false;
			});
		}
		$("vlineCd").value = $("endtLineCd").value;
		$("vlineCd").writeAttribute("menuLineCd", $("endtLineCd").options[$("endtLineCd").selectedIndex].getAttribute("menuLineCd"));
	});
	
	$("endtIssueSource").observe("change", function(){
		if(this.value != ""){
			synchLineWithIssueSource();
			$("endtLineCd").value = "";
		}else{
			$("endtLineCd").childElements().each(function(o){
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


	$("remarks").observe("keyup", function () {
		limitText(this, 4000);
	});

	$("editRemarks").observe("click", function () {
		if($("btnSave").hasClassName("button")){
			showEditor("remarks", 4000);
		}
	});
	
	observeReloadForm("reloadForm", reloadEndtParCreation);

	$("btnCreateNew").observe("click", reloadEndtParCreation);

	$("btnSave").observe("click", function(){
		if(changeTag == 0 && $("btnCreateNew").style.display != "none"){
			showMessageBox(objCommonMessage.NO_CHANGES, imgMessage.INFO);
			return false;
		}
		if(validatePar()){
				saveEndtPar();
				changeTag = 0;
		}
	});

	$("btnCancel").observe("click", checkChangeTagBeforeUWMain);

	function reloadEndtParCreation(){
		showEndtParCreationPage($("endtLineCd").value);
		clearParParameters();
	}

	function validatePar(){
		var result = true;

		if ($F("endtLineCd") == ""){
			result = false;
			$("endtLineCd").focus();
			showMessageBox("Please select a line.");
		}else if ($F("endtIssueSource")==""){
			result = false;
			$("endtIssueSource").focus();
			showMessageBox("Please select an issue source.");
		}else if ($F("year")==""){
			result = false;
			$("year").focus();
			showMessageBox("Year is required.");
		}
		
		return result;
	}

	function synchLineWithIssueSource(){
		var endtLine = $("endtLineCd");
		var lineIss = validLineIssueSource;
		
		$("endtLineCd").childElements().each(function(o){
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

	function synchIssSourceWithLine(){
		var endtIssSource = $("endtIssueSource");
		var lineIss = validLineIssueSource;
		
		$("endtIssueSource").childElements().each(function(o){
			o.hide(); o.disabled = true;
		});

		for(var i=0; i<validLineIssueSource.length; i++){
			var lineCd = $("endtLineCd").options[$("endtLineCd").selectedIndex].value;
			for(var c=0; c<endtIssSource.length; c++){
				if(endtIssSource.options[c].value == lineIss[i].issCd && lineCd == lineIss[i].lineCd || endtIssSource.options[c].value == ""){
				   endtIssSource.options[c].show();
				   endtIssSource.options[c].disabled = false;
				}			
			}
		}
	}

	// menus for endt par creation
	$("endtParCreationExit").observe("click", function () {
		checkChangeTagBeforeUWMain();
	});

	$("basicInformation").observe("click", function () {
		try {
			creationFlag = true; // added by: nica 02.17.2011 - for UW menu exit to determine if PAR originates from creation
			if ($F("globalLineCd") == "SU"){
				//showBondBasicInfo();
				showEndtBondBasicInfo();
			}else{	
				showBasicInfo();
			}
		} catch (e) {
			showErrorMessage("endtParCreation- basicInformation", e);
		}
	});
	
	// to assign selected line if called from Endt. PAR listing - Nica 08.18.2012
	for(var i=0; i<$("endtLineCd").options.length; i++){
		if(selectedLine == $("endtLineCd").options[i].value && !($("endtLineCd").options[i].disabled)){
			$("endtLineCd").value = selectedLine;
			fireEvent($("endtLineCd"), "change");
		}
	}
	
	initializeChangeTagBehavior(function(){fireEvent($("btnSave"), "click");});

</script>