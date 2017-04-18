
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="enrolleeCertificate">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="parExit">Exit</a></li>
			</ul>
		</div>
	</div>
</div>

<jsp:include page="/pages/toolbar.jsp"></jsp:include> 

<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
		<label>Policy Information</label>
		<span class="refreshers" style="margin-top: 0;">
 			<label id="showHidePolicyInfo" name="gro" style="margin-left: 5px;">Hide</label>
		</span>
	</div>
</div>

<div id="policyInformationDiv" class="sectionDiv">
	<div style="margin: 10px;">
		<input id="hidPolicyId" type="hidden" />
		<table cellspacing="2" style="margin: 10px auto;">
			<tr>
				<td class="rightAligned">Policy No. </td>
				<td class="leftAligned" style="width: 350px;">
					<input type="text" id="txtLineCd" class="required allCaps" maxlength="2" tabindex="101" style="float: left; width: 30px; margin-right: 3px;" />
					<input type="text" id="txtSublineCd" class="allCaps" maxlength="7" tabindex="102" style="float: left; width: 70px; margin-right: 3px;" />
					<input type="text" id="txtIssCd" class="allCaps" maxlength="2" tabindex="103" style="float: left; width: 30px; margin-right: 3px;" />
					<input type="text" id="txtIssueYy" class="integerNoNegativeUnformattedNoComma" maxlength="2" tabindex="104" style="float: left; width: 30px; margin-right: 3px; text-align: right;" />
					<input type="text" id="txtPolSeqNo" class="integerNoNegativeUnformattedNoComma" maxlength="7" tabindex="105" style="float: left; width: 70px; margin-right: 3px; text-align: right;" />
					<input type="text" id="txtRenewNo" class="integerNoNegativeUnformattedNoComma" maxlength="2" tabindex="106" style="float: left; width: 30px; margin-right: 3px; text-align: right;" />
					<img id="imgPolicyInfo" src="/Geniisys/images/misc/searchIcon.png" style="height: 20px; margin-top: 3px; cursor: pointer; float: right;" alt="Policy Info">
				</td>
				<td class="rightAligned" style="width: 120px;">Endorsement No. </td>
				<td class="leftAligned">
					<input type="text" id="txtEndtNo" readonly="readonly" tabindex="107" style="width: 200px;" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Assured Name </td>
				<td class="leftAligned">
					<input type="text" id="txtAssdName" readonly="readonly" tabindex="108" style="width: 315px;" />
				</td>
			</tr>
		</table>
	</div>
</div>

<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
		<label>Item Information</label>
		<span class="refreshers" style="margin-top: 0;">
 			<label id="showHideItemInformation" name="gro" style="margin-left: 5px;">Hide</label>
		</span>
	</div>
</div>

<div id="itemInfoDiv" class="sectionDiv">
	<input id="hidItemNo" type="hidden" />
	<div style="margin: 10px; padding: 10px 0 10px 0;">
		<div id="itemInformationTable" style="height: 203px;"></div>
	</div>
</div>

<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
		<label>Grouped Items Information</label>
		<span class="refreshers" style="margin-top: 0;">
 			<label id="showHideGroupedItemsInformation" name="gro" style="margin-left: 5px;">Hide</label>
		</span>
	</div>
</div>

<div id="groupedItemsInfoMainDiv" class="sectionDiv">
	<div style="margin: 10px; padding: 10px 0 10px 0;">
		<div id="groupedItemsInfoTable" style="height: 203px;"></div>
	</div>
	<div id="groupedItemsInfoDiv" style="margin: 10px">
		<input type="hidden" id="hidGIGroupedItemNo" />
		<input type="hidden" id="hidGISublineCd" />
		<input type="hidden" id="hidGILineCd" />
		<table style="margin: 10px auto 0;">
			<tr>
				<td class="rightAligned">
					<label for="txtGIEnrolleeCode" style="float: right;">Enrollee Code</label>
				</td>
				<td class="leftAligned">
					<input type="text" id="txtGIEnrolleeCode" class="required integerNoNegativeUnformattedNoComma" maxlength="9" tabindex="301" style="width: 150px; text-align: right;" />
				</td>
				<td class="rightAligned" style="width: 80px;">
					<label for="txtGIBirthdate" style="float: right;">Birthday</label>
				</td>
				<td class="leftAligned">
					<div id="txtBirthDateDiv" style="width: 120px; height: 21px; margin: 0" class="withIconDiv">
						<input type="text" id="txtGIBirthdate" class="withIcon" tabindex="304" readonly="readonly" style="width: 96px;" />
						<img id="imgGIBirthDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" style="margin : 2px 1px 0 0; cursor: pointer;" alt="birthday"/>
					</div>
				</td>
				<td class="rightAligned" style="width: 28px;">
					<label for="txtGIAge" style="float: right;">Age</label>
				</td>
				<td class="leftAligned">
					<input type="text" id="txtGIAge" tabindex="305" readonly="readonly" style="width: 50px; text-align: right;" />
				</td>
				<td class="rightAligned">
					<label for="txtGISalary" style="float: right;">Salary</label>
				</td>
				<td class="leftAligned">
					<!-- <input type="text" id="txtGISalary" tabindex="308" class="integerNoNegativeUnformattedNoComma" style="width: 150px; text-align: right;" /> -->
					<input type="text" id="txtGISalary" tabindex="308" class="money" style="width: 150px; text-align: right;" maxlength="16" max="9999999999.99" errorMsg="Invalid Salary. Valid value should be from 0 to 9,999,999,999.99."/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">
					<label for="txtGIEnrolleeName">Enrollee Name</label>
				</td>
				<td class="leftAligned">
					<input type="text" id="txtGIEnrolleeName" class="required allCaps" tabindex="302" style="width: 150px;" maxlength="50"/>
				</td>
				<td class="rightAligned">
					<label for="grpGICivilStatus" style="float: right;">Civil Status</label>
				</td>
				<td class="leftAligned" colspan="3">
					<select id="grpGICivilStatus" tabindex="306" style="width: 220px;">
						<option value=""></option>
						<c:forEach var="civilStats" items="${civilStats}">
						<option value="${civilStats.rvLowValue}">${civilStats.rvMeaning}</option>
					</c:forEach>
					</select>
				</td>
				<td class="rightAligned" style="width: 110px;">
					<label for="txtGISalaryGrade" style="float: right;">Salary Grade</label>
				</td>
				<td class="leftAligned">
					<input type="text" id="txtGISalaryGrade" tabindex="309" class="allCaps" maxlength="3" style="width: 150px;" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned">
					<label for="grpGIGender" style="float: right;">Gender</label>
				</td>
				<td class="leftAligned">
					<select id="grpGIGender" tabindex="303" style="width: 158px">
						<option value=""></option>
						<option value="F">Female</option>
						<option value="M">Male</option>
					</select>
				</td>
				<td class="rightAligned">
					<label for="grpGIOccupation" style="float: right">Occupation</label>
				</td>
				<td colspan="3" class="leftAligned">
					<select id="grpGIOccupation" tabindex="307" style="width: 220px">
						<option value=""></option>
						<c:forEach var="position" items="${positionListing}">
							<option value="${position.positionCd}">${position.position}</option>
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned">
					<label for="txtGIAmtCovered" style="float: right;">Amount Covered</label>
				</td>
				<td class="leftAligned">
					<!-- <input type="text" id="txtGIAmtCovered" class="integerNoNegativeUnformattedNoComma" tabindex="310" style="width: 150px;" /> -->
					<input type="text" id="txtGIAmtCovered" class="money" tabindex="310" style="width: 150px;" maxlength="21" max="99999999999999.99" errorMsg="Invalid Amount Covered. Valid value should be from 0 to 99,999,999,999,999.99"/>
				</td>
			</tr>
		</table>
		<div style="float: left; width: 278px;">
			<div style="width: 60px; margin-left: 120px;">
				<input type="checkbox" id="chkGIInclude" tabindex="311" />
				<label for="chkGIInclude" style="float: right;">Include</label>
			</div>
		</div>
		<div style="clear: both; text-align: center; margin-bottom: 70px;" >
			<div style="float: right; width: 203px;">
				<input type="radio" name="rdoTag" id="rdoTagAll" tabindex="315" style="float: left;" />
				<label for="rdoTagAll" style="float: left; margin-top: 2px">Tag All</label>
				<input type="radio" name="rdoTag" id="rdoUntagAll" tabindex="316" style="clear: both; float: left; margin-top: 10px;" />
				<label for="rdoUntagAll" style="float: left; margin-top: 10px">Untag All</label>
				<input type="radio" name="rdoTag" id="rdoSelected" tabindex="317" style="clear: both; float: left; margin-top: 10px;" />
				<label for="rdoSelected" style="float: left; margin-top: 10px">Selected Grouped Items</label>
			</div>
			<div style="background: white; width: 300px; float: right; margin-right: 98px;">
				<input type="button" id="btnGIAddUpdate" tabindex="312" class="disabledButton" value="Add" />
				<input type="button" id="btnGIDelete" tabindex="313" class="disabledButton" value="Delete" />
				</br>
				<table>
					<tr>
						<td style="text-align:right; width: 90px;" >
							<input type="checkbox" id="printOtherCert" style="margin-top: 5px;"/>
						</td>
						<td class="leftAligned" style="width: 150px;">
							<label id="lblPrintOtherCert" for="printOtherCert" style="margin-top: 5px;">Print Other Certificate</label>
						</td>
					</tr>
				</table>
				<input type="button" id="btnGIPrint" tabindex="314" class="disabledButton" value="Print Certificate of Group Insurance" style="margin-top: 5px; margin-bottom: 10px;" />
		</div>
		</div>
	</div>
</div>

<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
		<label>Beneficiary Information</label>
		<span class="refreshers" style="margin-top: 0;">
 			<label id="showHideBeneficiaryInformation" name="gro" style="margin-left: 5px;">Hide</label>
		</span>
	</div>
</div>

<div id="beneficiaryInfoMainDiv" class="sectionDiv">
	<div style="margin: 10px; padding: 10px 0 10px 0;">
		<div id="beneficiaryInfoTable" style="height: 203px;"></div>
	</div>
	<div id="beneficiaryInfoDiv">
		<table align="center" border="0" style="margin-top: 0px;">
			<tr>
				<td class="rightAligned">
					<label style="float: right;">No.</label>
				</td>
				<td class="leftAligned">
					<input id="txtBeneficiaryNo" tabindex="401" type="text" class="required integerNoNegativeUnformattedNoComma" maxlength="5" style="width: 150px; text-align: right;" />
				</td>
				<td class="rightAligned" style="width: 80px;">
					<label style="float: right">Name</label>
				</td>
				<td colspan="3" class="leftAligned">	<!--Gzelle 05.25.2013 added maxlength-->
					<input type="text" id="txtBeneficiaryName" tabindex="402" class="required" maxlength="30" style="width: 200px;" /> 
				</td>
			</tr>
			<tr>
				<td class="rightAligned">
					<label style="float: right">Address</label>
				</td>
				<td colspan="5" class="leftAligned">	<!--Gzelle 05.25.2013 added maxlength-->
					<input id="txtBeneficiaryAddr" tabindex="403" type="text" maxlength="50" style="width: 450px;" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned">
					<label style="float: right;">Birthday</label>
				</td>
				<td class="leftAligned">
					<div id="benBirthDateDiv" style="width: 156px; height: 21px; margin: 0" class="withIconDiv">
						<input type="text" id="txtBenBirthDate" tabindex="404" class="withIcon" readonly="readonly" style="width: 132px;" />
						<img id="imgBenBirthDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" style="margin : 2px 1px 0 0; cursor: pointer;" alt="birthday"/>
					</div>
				</td>
				<td class="rightAligned">
					<label style="float: right;">Age</label>
				</td>
				<td class="leftAligned">
					<input id="txtBenAge" type="text" tabindex="405" readonly="readonly" style="width: 60px; text-align: right;"/>
				</td>
				<td class="rightAligned" style="width: 48px;">
					<label style="float: right;">Gender</label>
				</td>
				<td class="leftAligned">
					<select id="grpBenGender" tabindex="406" style="width: 80px;">
						<option value=""></option>
						<option value="F">Female</option>
						<option value="M">Male</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">
					<label style="float: right;">Relation</label>
				</td>
				<td class="leftAligned">
					<input id="txtRelation" tabindex="407" type="text" style="width: 150px;" maxlength="15"/>
				</td>
				<td class="rightAligned">
					<label style="float: right;">Civil Status</label>
				</td>
				<td colspan="4" class="leftAligned">
					<select id="grpBenCivilStatus" tabindex="408" style="width: 208px;">
						<option value=""></option>
						<c:forEach var="civilStats" items="${civilStats}">
						<option value="${civilStats.rvLowValue}">${civilStats.rvMeaning}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<td colspan="6" style="text-align: center; height: 40px;">
					<input type="button" tabindex="409" class="disabledButton" value="Add" id="btnBenAddUpdate" />
					<input type="button" tabindex="410" class="disabledButton" value="Delete" id="btnBenDelete" style="margin: 5px auto 15px;" />
				</td>
			</tr>
		</table>
	</div>
</div>

<div style="clear: both; text-align: center; padding: 10px; margin-bottom: 50px;">
	<input type="button" id="btnCancel" tabindex="501" class="button" value="Cancel" />
	<input type="button" id="btnSave" tabindex="502" class="button" value="Save" />
</div>

<script type="text/javascript">
	try {
		$("mainNav").hide();
		var onLOV = false;
		var GIChangeTag = 0;
		var BenChangeTag = 0;
		var nextMove = '';
		var groupedItems = null;
		var beneficiaryNos = null;
		var GIRenderTag = false;
		var BenRenderTag = false;
		var otherCertTag = null;
		
		$("printOtherCert").hide();
		$("lblPrintOtherCert").hide();
		
		function initGIUTS023() {
			setModuleId("GIUTS023");
			setDocumentTitle("Add/Edit Grouped Item(s) / Beneficiary Information");
			onLOV = false;
			GIChangeTag = 0;
			BenChangeTag = 0;
			nextMove = '';
			groupedItems = null;
			beneficiaryNos = null;
			$("txtLineCd").focus();
			disableToolbarButton('btnToolbarEnterQuery');
			disableToolbarButton('btnToolbarExecuteQuery');
			disableToolbarButton('btnToolbarPrint');
			Effect.toggle("itemInfoDiv", "blind", {duration: .3});
			Effect.toggle("groupedItemsInfoMainDiv", "blind", {duration: .3});
			Effect.toggle("beneficiaryInfoMainDiv", "blind", {duration: .3});
			$("showHideItemInformation").innerHTML = "Show";
			$("showHideGroupedItemsInformation").innerHTML = "Show";
			$("showHideBeneficiaryInformation").innerHTML = "Show";
			objGIUTS023 = new Object();
			objGIUTS023GroupedItems = new Object();
			objGIUTS023Beneficiary = new Object();
			disableGroupedItemInfoFields();
			disableBeneficiaryFields();
		}
		
		function resetForm(){
			onLOV = false;
			GIChangeTag = 0;
			BenChangeTag = 0;
			nextMove = '';
			groupedItems = null;
			beneficiaryNos = null;
			objGIUTS023 = new Object();
			objGIUTS023GroupedItems = new Object();
			objGIUTS023Beneficiary = new Object();
			$$("input[type='text']").each(function(obj){obj.clear();});
			disableToolbarButton('btnToolbarEnterQuery');
			disableToolbarButton('btnToolbarExecuteQuery');
			disableToolbarButton('btnToolbarPrint');
			enableSearch('imgPolicyInfo');
			tbgItemInfo.url = contextPath+"/GIUTS023BeneficiaryInfoController?action=populateGIUTS023ItemInfoTableGrid&refresh=1";
			tbgItemInfo._refreshList();
			tbgGroupedItemsInfo.url = contextPath+"/GIUTS023BeneficiaryInfoController?action=populateGIUTS023GroupedItemsInfoTableGrid&refresh=1",
			tbgGroupedItemsInfo._refreshList();
			$("txtLineCd").focus();
			disableGroupedItemInfoFields();
			
			if($("policyInformationDiv").getStyle('display') == 'none') {
				Effect.toggle("policyInformationDiv", "blind", {duration: .3});
				$("showHidePolicyInfo").innerHTML = "Hide";
			}
			
			if($("itemInfoDiv").getStyle('display') != 'none') {
				Effect.toggle("itemInfoDiv", "blind", {duration: .3});
				$("showHideItemInformation").innerHTML = "Show";
			}
			
			if($("groupedItemsInfoMainDiv").getStyle('display') != 'none') {
				Effect.toggle("groupedItemsInfoMainDiv", "blind", {duration: .3});
				$("showHideGroupedItemsInformation").innerHTML = "Show";
			}
			
			if($("beneficiaryInfoMainDiv").getStyle('display') != 'none') {
				Effect.toggle("beneficiaryInfoMainDiv", "blind", {duration: .3});
				$("showHideBeneficiaryInformation").innerHTML = "Show";
			}
			
			$('hidPolicyId').clear();
			
		}
		
		function executeQuery() {
			tbgItemInfo.url = contextPath+"/GIUTS023BeneficiaryInfoController?action=populateGIUTS023ItemInfoTableGrid&refresh=1&policyId=" + objGIUTS023.policyId;
			tbgItemInfo._refreshList();
			
			if($("policyInformationDiv").getStyle('display') == 'none') {
				Effect.toggle("policyInformationDiv", "blind", {duration: .3});
				$("showHidePolicyInfo").innerHTML = "Hide";
			}
			
			if($("itemInfoDiv").getStyle('display') == 'none') {
				Effect.toggle("itemInfoDiv", "blind", {duration: .3});
				$("showHideItemInformation").innerHTML = "Hide";
			}
			
			if($("groupedItemsInfoMainDiv").getStyle('display') != 'none') {
				Effect.toggle("groupedItemsInfoMainDiv", "blind", {duration: .3});
				$("showHideGroupedItemsInformation").innerHTML = "Show";
			}
			
			if($("beneficiaryInfoMainDiv").getStyle('display') != 'none') {
				Effect.toggle("beneficiaryInfoMainDiv", "blind", {duration: .3});
				$("showHideBeneficiaryInformation").innerHTML = "Show";
			}
			
			disableToolbarButton("btnToolbarExecuteQuery");
			showOtherCert($F("txtLineCd"));
		}
		
		function disableGroupedItemInfoFields(){
			disableDate('imgGIBirthDate');
			disableButton('btnGIAddUpdate');
			$("btnGIAddUpdate").value = 'Add';
			disableButton('btnGIDelete');
			disableButton('btnGIPrint');
			disableToolbarButton('btnToolbarPrint');
			$("txtBirthDateDiv").setStyle({background : '#F0F0F0'});
			$$("div#groupedItemsInfoDiv input[type='text'], div#groupedItemsInfoDiv input[type='radio'], div#groupedItemsInfoDiv input[type='checkbox'], div#groupedItemsInfoDiv select").each(
				function(obj) {
					obj.disable();
					if(obj.type == 'text')
						obj.clear();
					else if (obj.type == 'select-one')
						obj.selectedIndex = 0;
					else if (obj.type == 'checkbox' || obj.type == 'radio')
						obj.checked = false;
				}		
			);
		}
		
		function enableGroupedItemInfoFields(){
			enableDate('imgGIBirthDate');
			enableButton('btnGIAddUpdate');
			$("btnGIAddUpdate").value = 'Add';
			$("txtBirthDateDiv").setStyle({background : 'white'});
			$$("div#groupedItemsInfoDiv input[type='text'], div#groupedItemsInfoDiv input[type='radio'], div#groupedItemsInfoDiv input[type='checkbox'], div#groupedItemsInfoDiv select").each(
				function(obj) {
					obj.enable();
				}		
			);
		}
		
		function disableBeneficiaryFields(){
			disableDate('imgBenBirthDate');
			disableButton('btnBenAddUpdate');
			$("btnBenAddUpdate").value = 'Add';
			disableButton('btnBenDelete');
			$("benBirthDateDiv").setStyle({background : '#F0F0F0'});
			$$("div#beneficiaryInfoDiv input[type='text'], div#beneficiaryInfoDiv select").each(
				function(obj) {
					obj.disable();
					if(obj.type == 'text')
						obj.clear();
					else if (obj.type == 'select-one')
						obj.selectedIndex = 0;
				}		
			);
		}
		
		function enableBeneficiaryFields(){
			enableDate('imgBenBirthDate');
			enableButton('btnBenAddUpdate');
			$("btnBenAddUpdate").value = 'Add';
			$("benBirthDateDiv").setStyle({background : 'white'});
			$$("div#beneficiaryInfoDiv input[type='text'], div#beneficiaryInfoDiv select").each(
				function(obj) {
					obj.enable();
				}		
			);
		}
		
		var updateSw = "Y";
		
		function populateGroupedItemsInfoTableGrid(obj) {
			if(obj!= null){
				$("hidItemNo").value = obj.itemNo;
				
				updateSw = obj.updateSw;
				
				if(updateSw == "N") { // items with records in gipi_itmperil_grouped must not be editable - apollo cruz 04.13.2015 
					disableGroupedItemInfoFields();
					
					// added by apollo cruz to enable printing-related elements
					$("rdoTagAll").enable();
					$("rdoUntagAll").enable();
					$("rdoSelected").enable();
					$("printOtherCert").enable();
				} else
					enableGroupedItemInfoFields();
				
				objGIUTS023.itemNo = obj.itemNo;
				groupedItems = getGroupedItems();
				tbgGroupedItemsInfo.url = contextPath+"/GIUTS023BeneficiaryInfoController?action=populateGIUTS023GroupedItemsInfoTableGrid&refresh=1" + 
						"&policyId=" + objGIUTS023.policyId +
						"&itemNo=" + objGIUTS023.itemNo;
				tbgGroupedItemsInfo._refreshList();
				
				if($("groupedItemsInfoMainDiv").getStyle('display') == 'none') {
					Effect.toggle("groupedItemsInfoMainDiv", "blind", {duration: .3});
					$("showHideGroupedItemsInformation").innerHTML = "Hide";
				}	
			} else {
				disableGroupedItemInfoFields();
				objGIUTS023.itemNo = null;
				groupedItems = null;
				if(GIRenderTag) {
					tbgGroupedItemsInfo.url = contextPath+"/GIUTS023BeneficiaryInfoController?action=populateGIUTS023GroupedItemsInfoTableGrid&refresh=1";
					tbgGroupedItemsInfo._refreshList();	
				}
				
			}
		}
		
		function setDetailsGroupedItemsInfo(obj) {
			if(obj != null) {
				$("hidGIGroupedItemNo").value = obj.groupedItemNo;
				beneficiaryNos = getBeneficiaryNos();
				$("hidGISublineCd").value = obj.sublineCd;
				$("hidGILineCd").value = obj.lineCd;
				$("txtGIEnrolleeCode").value = formatNumberDigits(obj.groupedItemNo, 9);
				$("txtGIBirthdate").value = obj.dateOfBirth == '' ? '' : obj.dateOfBirth == null ? '' : dateFormat(obj.dateOfBirth, 'mm-dd-yyyy');
				$("txtGIAge").value = obj.age;
				$("txtGISalary").value = formatCurrency(obj.salary);
				$("txtGIEnrolleeName").value = unescapeHTML2(obj.groupedItemTitle);
				$("grpGICivilStatus").value = obj.civilStatus;
				$("txtGISalaryGrade").value = unescapeHTML2(obj.salaryGrade);
				$("grpGIGender").value = obj.sex;
				$("grpGIOccupation").value = obj.positionCd;
				$("txtGIAmtCovered").value = formatCurrency(obj.amountCoverage);
				if(obj.includeTag == 'Y')
					$("chkGIInclude").checked = true;
				else
					$("chkGIInclude").checked = false;
				
				$("txtGIEnrolleeCode").readOnly = true;				
				
				tbgBeneficiaryInfo.url = contextPath+"/GIUTS023BeneficiaryInfoController?action=populateGIUTS023beneficiaryInfoTableGrid&refresh=1" 
						+ "&policyId=" + $("hidPolicyId").value
						+ "&itemNo=" + $("hidItemNo").value
						+ "&groupedItemNo=" + $("hidGIGroupedItemNo").value;
				tbgBeneficiaryInfo._refreshList();
				
				if(updateSw == "N") { //items with records in gipi_itmperil_grouped must not be editable - apollo cruz 04.13.2015
					disableButton('btnGIAddUpdate');
					disableButton('btnGIDelete');
					disableButton('btnBenAddUpdate');
					$("btnGIAddUpdate").value = "Add";
					disableBeneficiaryFields();
				} else {
					enableButton('btnGIAddUpdate');
					enableButton('btnGIDelete');
					enableButton('btnBenAddUpdate');
					$("btnGIAddUpdate").value = "Update";
					enableBeneficiaryFields();
				}
				
				if($("beneficiaryInfoMainDiv").getStyle('display') == 'none') {
					Effect.toggle("beneficiaryInfoMainDiv", "blind", {duration: .3});
					$("showHideBeneficiaryInformation").innerHTML = "Hide";
				}
			} else {
				$("btnGIAddUpdate").value = "Add";
				$("txtGIEnrolleeCode").readOnly = false;
				disableButton('btnGIDelete');
				disableButton('btnBenAddUpdate');
				$$("div#groupedItemsInfoDiv input[type='text'], div#groupedItemsInfoDiv input[type='radio'], div#groupedItemsInfoDiv input[type='checkbox'], div#groupedItemsInfoDiv select").each(
						function(obj) {
							if(obj.type == 'text')
								obj.clear();
							else if (obj.type == 'select-one')
								obj.selectedIndex = 0;
							else if (obj.type == 'checkbox' || obj.type == 'radio')
								obj.checked = false;
						}		
					);
				$('rdoSelected').checked = true;
				if(BenRenderTag){
					tbgBeneficiaryInfo.url = contextPath+"/GIUTS023BeneficiaryInfoController?action=populateGIUTS023beneficiaryInfoTableGrid&refresh=1";
					tbgBeneficiaryInfo._refreshList();	
				}
				setDetailsBeneficiaryInfo(null);
				disableBeneficiaryFields();
			}
		}
		
		function setDetailsBeneficiaryInfo(obj){
			if (obj != null) {
				$("txtBeneficiaryNo").value = formatNumberDigits(obj.beneficiaryNo, 5);
				$('txtBeneficiaryName').value = unescapeHTML2(obj.beneficiaryName);
				$('txtBeneficiaryAddr').value = unescapeHTML2(obj.beneficiaryAddr);
				$('txtBenBirthDate').value = obj.dateOfBirth == '' ? '' : obj.dateOfBirth == null ? '' : dateFormat(obj.dateOfBirth, 'mm-dd-yyyy');
				$('txtBenAge').value = obj.age;
				$('grpBenGender').value = obj.sex;
				$('txtRelation').value = unescapeHTML2(obj.relation);
				$('grpBenCivilStatus').value = obj.civilStatus;
				
				$("txtBeneficiaryNo").readOnly = true;
				
				if(updateSw == "N") { //items with records in gipi_itmperil_grouped must not be editable - apollo cruz 04.13.2015
					$('btnBenAddUpdate').value = 'Add';
					disableButton('btnBenAddUpdate');
					disableButton('btnBenDelete');
				} else {
					$('btnBenAddUpdate').value = 'Update';
					enableButton('btnBenAddUpdate');
					enableButton('btnBenDelete');
				}
			} else {
				$$("div#beneficiaryInfoDiv input[type='text'], div#beneficiaryInfoDiv select").each(
						function(obj) {
							if(obj.type == 'text')
								obj.clear();
							else if (obj.type == 'select-one')
								obj.selectedIndex = 0;
						}		
					);
				
				if(updateSw == "N") {
					$("txtBeneficiaryNo").readOnly = true;					
					disableButton('btnBenDelete');
				} else {
					$("txtBeneficiaryNo").readOnly = false;
					disableButton('btnBenDelete');
				}
				
				$('btnBenAddUpdate').value = 'Add';
			}
		}
		
		function populatePolicyInformation(row){
			$("hidPolicyId").value = row.policyId;
			$("txtLineCd").value = row.lineCd;
			$("txtSublineCd").value = row.sublineCd;
			$("txtIssCd").value = row.issCd;
			$("txtIssueYy").value = row.issueYy;
			$("txtPolSeqNo").value = formatNumberDigits(row.polSeqNo, 7);
			$("txtRenewNo").value = formatNumberDigits(row.renewNo, 2);
			$("txtAssdName").value = unescapeHTML2(row.assdName);
			$("txtEndtNo").value = row.endorsementNo;
			disableSearch('imgPolicyInfo');
			$("imgPolicyInfo").next().setStyle({
				height : '20px',
				width : '20px',
				marginTop : '3px',
				cursor : 'pointer'
			});
			
			enableToolbarButton('btnToolbarExecuteQuery');
			
			objGIUTS023.policyId = row.policyId;
		}
		
		function getGroupedItems(){
			var groupedItems = null;
			new Ajax.Request(contextPath + "/GIUTS023BeneficiaryInfoController", {
				parameters : {
					action			: 'validateGroupedItem',
					policyId		: objGIUTS023.policyId,
					itemNo			: objGIUTS023.itemNo
				},
				asynchronous : false,
				onComplete : function(response){
					if(checkErrorOnResponse(response))
						groupedItems = eval(response.responseText);
				}
			});
			return groupedItems;
		}
		
		function getBeneficiaryNos(){
			var beneficiaryNos = null;
			new Ajax.Request(contextPath + "/GIUTS023BeneficiaryInfoController", {
				parameters : {
					action			: 'validateBeneficiary',
					policyId		: objGIUTS023.policyId,
					itemNo			: objGIUTS023.itemNo,
					groupedItemNo   : $("hidGIGroupedItemNo").value
				},
				asynchronous : false,
				onComplete : function(response){
					if(checkErrorOnResponse(response)){
						beneficiaryNos = eval(response.responseText);
					}
						
				}
			});
			return beneficiaryNos;
		}
		
		function validateGroupedItemNo() {
			if(removeLeadingZero($F('txtGIEnrolleeCode')) == 0) {
				customShowMessageBox("Invalid Enrollee Code. Valid value should be from 1 to 999999999.", imgMessage.ERROR, "txtGIEnrolleeCode");
				return false;
			}
			
			for(var x = 0; x < groupedItems.length; x ++) {
				if(removeLeadingZero(groupedItems[x].groupedItemNo) == removeLeadingZero($F('txtGIEnrolleeCode'))){
					customShowMessageBox("Enrollee Code must be unique.", imgMessage.ERROR, "txtGIEnrolleeCode");
					return false;
				}
			}
			return true;
		}
		
		function validateGroupedItemTitle() {
			for(var x = 0; x < groupedItems.length; x ++) {
				if(unescapeHTML2(groupedItems[x].groupedItemTitle) == $F('txtGIEnrolleeName') && removeLeadingZero(groupedItems[x].groupedItemNo) != removeLeadingZero($F('txtGIEnrolleeCode'))){
					customShowMessageBox("Enrollee Name must be unique.", imgMessage.ERROR, "txtGIEnrolleeName");
					return false;
				}
			}
			return true;
		}
		
		function validateBeneficiaryNo(){
			for(var x = 0; x < beneficiaryNos.length; x ++) {
				if(removeLeadingZero(beneficiaryNos[x].beneficiaryNo) == removeLeadingZero($F('txtBeneficiaryNo'))){
					customShowMessageBox("Beneficiary No. must be unique.", imgMessage.ERROR, "txtBeneficiaryNo");
					return false;
				}
			}
			return true;
		}
		
		function setGroupedItems(action) {
			var GI = new Object();
			GI.recordStatus = action == 'Add' ? 0 : action == 'Update' ? 1 : -1;
			GI.policyId = $("hidPolicyId").value;
			GI.itemNo = $("hidItemNo").value;
			GI.groupedItemNo = removeLeadingZero($("txtGIEnrolleeCode").value);
			GI.groupedItemTitle = escapeHTML2($("txtGIEnrolleeName").value);
			GI.sex = $("grpGIGender").value;
			GI.age = $("txtGIAge").value;
			GI.dateOfBirth = $("txtGIBirthdate").value;
			GI.civilStatus = escapeHTML2($("grpGICivilStatus").value);
			GI.amountCoverage = $("txtGIAmtCovered").value;
			GI.salary = $("txtGISalary").value;
			GI.salaryGrade = escapeHTML2($("txtGISalaryGrade").value);
			GI.sublineCd = $("hidGISublineCd").value;
			GI.lineCd = $("hidGILineCd").value;
			GI.includeTag = $("chkGIInclude").checked == true ? 'Y' : 'N';
			GI.positionCd = $("grpGIOccupation").value;
			GI.position = escapeHTML2($("grpGIOccupation").options[$("grpGIOccupation").selectedIndex].text);
			return GI;
		}
		
		function setBeneficiary(action) {
			var ben = new Object();
			
			ben.recordStatus = action == 'Add' ? 0 : action == 'Update' ? 1 : -1;
			ben.policyId = $("hidPolicyId").value;
			ben.itemNo = $("hidItemNo").value;
			ben.groupedItemNo = removeLeadingZero($("txtGIEnrolleeCode").value);
			ben.beneficiaryNo = removeLeadingZero($("txtBeneficiaryNo").value);
			ben.beneficiaryName = escapeHTML2($('txtBeneficiaryName').value);
			ben.relation = escapeHTML2($('txtRelation').value);
			ben.sex = $('grpBenGender').value;
			ben.civilStatus = $('grpBenCivilStatus').value;
			ben.dateOfBirth = $('txtBenBirthDate').value;
			ben.age = $('txtBenAge').value;
			ben.beneficiaryAddr = escapeHTML2($('txtBeneficiaryAddr').value);
			return ben;
		}
		
		function addUpdateGroupedItems(){
			if(checkAllRequiredFieldsInDiv('groupedItemsInfoMainDiv')) {
				if($("btnGIAddUpdate").value == 'Add'){
					if(validateGroupedItemNo() && validateGroupedItemTitle()){
						var rowObj = setGroupedItems('Add');
						var x = new Object();
						x.groupedItemNo = rowObj.groupedItemNo;
						x.groupedItemTitle = rowObj.groupedItemTitle;
						groupedItems.push(x); //for validation
						objGIUTS023GroupedItems.push(rowObj);
						tbgGroupedItemsInfo.addBottomRow(rowObj);
						setDetailsGroupedItemsInfo(null);
						GIChangeTag = 1;
					}
				} else {
					if(validateGroupedItemTitle()){
						var rowObj = setGroupedItems('Update');
						var no = rowObj.groupedItemNo;
						var title = rowObj.groupedItemTitle;
						for(var i = 0; i < groupedItems.length; i++){
							if(no == groupedItems[i].groupedItemNo){
								groupedItems[i].groupedItemNo = no;
								groupedItems[i].groupedItemTitle = title;
								break;
							}
						}
						objGIUTS023GroupedItems.splice(objGIUTS023.GISelectedIndex, 1, rowObj);
						tbgGroupedItemsInfo.updateVisibleRowOnly(rowObj, objGIUTS023.GISelectedIndex);
						setDetailsGroupedItemsInfo(null);
						GIChangeTag = 1;
					}
				}
			}
		}
		
		function addUpdateBeneficiary(){
			if(checkAllRequiredFieldsInDiv('beneficiaryInfoDiv')) {
				if($('btnBenAddUpdate').value == 'Add') {
					if(validateBeneficiaryNo()) {
						var rowObj = setBeneficiary('Add');
						var x = new Object();
						x.beneficiaryNo = rowObj.beneficiaryNo;
						beneficiaryNos.push(x);
						objGIUTS023Beneficiary.push(rowObj);
						tbgBeneficiaryInfo.addBottomRow(rowObj);
						BenChangeTag = 1;
						setDetailsBeneficiaryInfo(null);
					}
				} else {
					var rowObj = setBeneficiary('Update');
					objGIUTS023Beneficiary.splice(objGIUTS023.BenSelectedIndex, 1, rowObj);
					tbgBeneficiaryInfo.updateVisibleRowOnly(rowObj, objGIUTS023.BenSelectedIndex);
					BenChangeTag = 1;
					setDetailsBeneficiaryInfo(null);
				}
			}
		}
		
		function deleteGroupedItems() {
			var delObj = setGroupedItems("Delete");
			var no = delObj.groupedItemNo;
			for(var i = 0; i < groupedItems.length; i++){
				if(groupedItems[i].groupedItemNo == no)
					groupedItems.splice(i, 1);
			}
			GIChangeTag = 1;
			objGIUTS023Beneficiary = null;
			objGIUTS023GroupedItems.splice(objGIUTS023.GISelectedIndex, 1, delObj);
			tbgGroupedItemsInfo.deleteVisibleRowOnly(objGIUTS023.GISelectedIndex);
			tbgGroupedItemsInfo.onRemoveRowFocus();
		}
		
		function deleteBeneficiary() {
			var delObj = setBeneficiary("Delete");
			var no = delObj.beneficiaryNo;
			for(var i = 0; i < beneficiaryNos.length; i++){
				if(beneficiaryNos[i].beneficiaryNo == no)
					beneficiaryNos.splice(i, 1);
			}
			objGIUTS023Beneficiary.splice(objGIUTS023.BenSelectedIndex, 1, delObj);
			tbgBeneficiaryInfo.deleteVisibleRowOnly(objGIUTS023.BenSelectedIndex);
			tbgBeneficiaryInfo.onRemoveRowFocus();
			BenChangeTag = 1;
		}
		
		function saveAll(){
			var objParams = new Object();
			objParams.setRowsGI = getAddedAndModifiedJSONObjects(objGIUTS023GroupedItems);
			objParams.delRowsGI = getDeletedJSONObjects(objGIUTS023GroupedItems);
			objParams.setRowsBen = getAddedAndModifiedJSONObjects(objGIUTS023Beneficiary);
			objParams.delRowsBen = getDeletedJSONObjects(objGIUTS023Beneficiary);
			
			new Ajax.Request(contextPath+"/GIUTS023BeneficiaryInfoController",{
				method: "POST",
				parameters:{
					action     : "saveGIUTS023",
					parameters : JSON.stringify(objParams)
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function(){
					showNotice("Saving, please wait...");
				},
				onComplete: function(response){
					hideNotice("");
					if(checkErrorOnResponse(response)) {
							showWaitingMessageBox(objCommonMessage.SUCCESS, "S", function(){
								GIChangeTag = 0;
								BenChangeTag = 0;
								tbgItemInfo.refresh();
								if(nextMove == 'exit')
									exit();
								else if(nextMove == 'reset'){
									nextMove = '';
									resetForm();
								}
							});
					}else{
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		}
		
		$("btnGIAddUpdate").observe("click", function(){
			var x = getDeletedJSONObjects(objGIUTS023GroupedItems);
			if(x.length > 0 && this.value == 'Add')
				showMessageBox('Please save before adding a new grouped item.','I');
			else
				addUpdateGroupedItems();
		});
		
		$('btnBenAddUpdate').observe('click', function(){
			addUpdateBeneficiary();
		});		
		
		$("btnGIDelete").observe("click", function(){
			deleteGroupedItems();
		});
		
		$('btnBenDelete').observe("click", function(){
			deleteBeneficiary();
		});
		
		$("btnSave").observe("click", function(){
			if(GIChangeTag == 0 && BenChangeTag == 0){
				showMessageBox(objCommonMessage.NO_CHANGES, "I");
			} else {
				saveAll();
			}
			
		});
		
		function checkUnsavedChanges() {
			if(GIChangeTag == 1 || BenChangeTag == 1){
				showConfirmBox4('Confirmation', objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", saveAll,
						function(){
							GIChangeTag = 0;
							BenChangeTag = 0;
							tbgItemInfo.onRemoveRowFocus();
							tbgItemInfo._refreshList();
						}, null);
				return false;
			} else {
				return true;
			}
		}
		
		function checkUnsavedChanges2() {
			if(BenChangeTag == 1){
				showConfirmBox4('Confirmation', objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", saveAll,
						function(){
							//GIChangeTag = 0;
							BenChangeTag = 0;
							tbgGroupedItemsInfo.onRemoveRowFocus();
							tbgGroupedItemsInfo._refreshList();
						}, null);
				return false;
			} else {
				return true;
			}
		}
		
		var jsonItemInfoTableGrid = [];
		itemInformationTableModel = {
				url: contextPath+"/GIUTSBeneficiaryInfoController?action=populateGIUTS023ItemInfoTableGrid&refresh=1",
				id : "itemInformation",
				options: {
					toolbar: {
						elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
						onFilter : function(element, value, x, y, id){
							GIChangeTag = 0;
							BenChangeTag = 0;
							tbgItemInfo.keys.removeFocus(tbgItemInfo.keys._nCurrentFocus, true);
							tbgItemInfo.keys.releaseKeys();
							populateGroupedItemsInfoTableGrid(null);
						}
					},
					height: '180px',
					beforeClick : function(element, value, x, y, id) {
						return checkUnsavedChanges();
						tbgItemInfo.keys.removeFocus(tbgItemInfo.keys._nCurrentFocus, true);
						tbgItemInfo.keys.releaseKeys();
					},
					beforeSort : function(element, value, x, y, id) {
						return checkUnsavedChanges();
						tbgItemInfo.keys.removeFocus(tbgItemInfo.keys._nCurrentFocus, true);
						tbgItemInfo.keys.releaseKeys();
					},
					onSort : function(element, value, x, y, id) {
						tbgItemInfo.keys.removeFocus(tbgItemInfo.keys._nCurrentFocus, true);
						tbgItemInfo.keys.releaseKeys();
						populateGroupedItemsInfoTableGrid(null);
					},
					onRefresh : function(element, value, x, y, id) {
						GIChangeTag = 0;
						BenChangeTag = 0;
						tbgItemInfo.keys.removeFocus(tbgItemInfo.keys._nCurrentFocus, true);
						tbgItemInfo.keys.releaseKeys();
						//populateGroupedItemsInfoTableGrid(null);
					},
					onCellFocus : function(element, value, x, y, id) {
						tbgItemInfo.keys.removeFocus(tbgItemInfo.keys._nCurrentFocus, true);
						tbgItemInfo.keys.releaseKeys();
						populateGroupedItemsInfoTableGrid(tbgItemInfo.geniisysRows[y]);
					},
					onRemoveRowFocus : function(element, value, x, y, id){
						GIChangeTag = 0;
						BenChangeTag = 0;
						tbgItemInfo.keys.removeFocus(tbgItemInfo.keys._nCurrentFocus, true);
						tbgItemInfo.keys.releaseKeys();
						populateGroupedItemsInfoTableGrid(null);
					}
				},									
				columnModel: [
					{
					    id: 'recordStatus',
					    title: '',
					    width: '0',
					    visible: false
					},
					{
						id: 'divCtrId',
						width: '0',
						visible: false 
					},
					{
						id: 'itemNo',
						title : 'Item No.',
						width : "70px",
						filterOption : true,
					    filterOptionType : 'number',
					    align : 'right',
					    titleAlign : 'right',
					    renderer : function(value) {
					    	return value == 0 ? '' : formatNumberDigits(value, 9);
					    }
					},
					{
						id: 'itemTitle',
						title: 'Item Title',
						width: "280px",
						filterOption: true,
						renderer: function(value){
							return unescapeHTML2(value);
						}
						
					},
					{
						id: 'itemDesc',
						title : 'Description',
						width: "522px",
						filterOption: true,
						renderer : function(value){
							return unescapeHTML2(value);
						}
					}
				],
				rows: []
			};
		
		tbgItemInfo = new MyTableGrid(itemInformationTableModel);
		tbgItemInfo.pager = [];
		tbgItemInfo.render('itemInformationTable');
		tbgItemInfo.afterRender = function() {
			GIChangeTag = 0;
			BenChangeTag = 0;
			tbgItemInfo.keys.removeFocus(tbgItemInfo.keys._nCurrentFocus, true);
			tbgItemInfo.keys.releaseKeys();
			populateGroupedItemsInfoTableGrid(null);
		};
		
		groupedItemsInfoTableModel = {
				url: contextPath+"/GIUTS023BeneficiaryInfoController?action=populateGIUTS023GroupedItemsInfoTableGrid&refresh=1",
				id : "groupedItemsInfo",
				options: {
					toolbar: {
						elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
						onFilter : function(element, value, x, y, id){
							//GIChangeTag = 0;
							BenChangeTag = 0;
							tbgGroupedItemsInfo.keys.removeFocus(tbgGroupedItemsInfo.keys._nCurrentFocus, true);
							tbgGroupedItemsInfo.keys.releaseKeys();
							setDetailsGroupedItemsInfo(null);
						}
					},
					height: '180px',
					beforeClick : function(element, value, x, y, id) {
						return checkUnsavedChanges2();
						tbgGroupedItemsInfo.keys.removeFocus(tbgGroupedItemsInfo.keys._nCurrentFocus, true);
						tbgGroupedItemsInfo.keys.releaseKeys();
					},
					beforeSort : function(element, value, x, y, id) {
						return checkUnsavedChanges2();
						tbgGroupedItemsInfo.keys.removeFocus(tbgGroupedItemsInfo.keys._nCurrentFocus, true);
						tbgGroupedItemsInfo.keys.releaseKeys();
					},
					onSort : function(element, value, x, y, id) {
						tbgGroupedItemsInfo.keys.removeFocus(tbgGroupedItemsInfo.keys._nCurrentFocus, true);
						tbgGroupedItemsInfo.keys.releaseKeys();
						setDetailsGroupedItemsInfo(null);
					},
					onRefresh : function(element, value, x, y, id) {
						GIChangeTag = 0;
						BenChangeTag = 0;
						tbgGroupedItemsInfo.keys.removeFocus(tbgGroupedItemsInfo.keys._nCurrentFocus, true);
						tbgGroupedItemsInfo.keys.releaseKeys();
						//setDetailsGroupedItemsInfo(null);
					},
					onCellFocus : function(element, value, x, y, id) {
						tbgGroupedItemsInfo.keys.removeFocus(tbgGroupedItemsInfo.keys._nCurrentFocus, true);
						tbgGroupedItemsInfo.keys.releaseKeys();
						setDetailsGroupedItemsInfo(tbgGroupedItemsInfo.geniisysRows[y]);
						objGIUTS023.GISelectedIndex = y;
						setDetailsBeneficiaryInfo(null); //added by jeffdojello 10.30.2013
						if(x == 2){
							$('rdoSelected').checked = true;
						}
					},
					onRemoveRowFocus : function(element, value, x, y, id){
						tbgGroupedItemsInfo.keys.removeFocus(tbgGroupedItemsInfo.keys._nCurrentFocus, true);
						tbgGroupedItemsInfo.keys.releaseKeys();
						setDetailsGroupedItemsInfo(null);
						setDetailsBeneficiaryInfo(null); //added by jeffdojello 10.30.2013
						objGIUTS023.GISelectedIndex = -1;
					}
				},									
				columnModel: [
					{
					    id: 'recordStatus',
					    title: '',
					    width: '0',
					    visible: false
					},
					{
						id: 'divCtrId',
						width: '0',
						visible: false 
					},
					{
						id : "printTag",
						title: "P",
						width: '30px',	
						editable: true,
						sortable: false,
						editor:new MyTableGrid.CellCheckbox({getValueOf : function(value) {
							if (value){
								return"Y";
							}else{
								return"N";
							}
						}})
					},
					{
						id: 'groupedItemNo',
						title : 'Code',
						width : "65px",
						align : 'right',
						titleAlign : 'right',
						filterOption : true,
						filterOptionType : 'number',
						renderer : function(val){
							return formatNumberDigits(val, 9);
						}
					},
					{
						id: 'groupedItemTitle',
						title : 'Enrollee Name',
						width : "200px",
						filterOption : true,
						renderer : function(val){
							return unescapeHTML2(val);
						}
					},
					{
						id: 'sex',
						title : 'Gender',
						width : "50px",
						filterOption : true
					},
					{
						id: 'age',
						title : 'Age',
						width : "50px",
						align: 'right',
						titleAlign : 'right',
						filterOption : true,
						filterOptionType : 'number'
					},
					{
						id: 'dateOfBirth',
						title : 'Birthday',
						width : "80px",
						align : 'center',
						filterOption : true,
						filterOptionType : 'formattedDate',
						renderer : function(val){
							return val == '' ? '' : val == null ? '' :dateFormat(val, 'mm-dd-yyyy');
						}
					},
					{
						id: 'civilStatus',
						title : 'Status',
						width : "50px",
						filterOption : true
					},
					{
						id: 'amountCoverage',
						title : 'Amt Covered',
						width : "80px",
						filterOption : true,
						filterOptionType : 'number',
						geniisysClass : 'money',
						align: 'right',
						titleAlign : 'right'
						
					},
					{
						id: 'position',
						title : 'Occupation',
						width : "91px",
						filterOption : true,
						renderer : function(val){
							return unescapeHTML2(val);
						}
					},
					{
						id: 'salary',
						title : 'Salary',
						width : "80px",
						filterOption : true,
						filterOptionType : 'number',
						geniisysClass : 'money',
						align: 'right',
						titleAlign : 'right'
					},
					{
						id: 'salaryGrade',
						title : 'Salary Grade',
						width : "80px",
						filterOption : true
					}
				],
				rows: []
			};
		
		tbgGroupedItemsInfo = new MyTableGrid(groupedItemsInfoTableModel);
		tbgGroupedItemsInfo.pager = [];
		tbgGroupedItemsInfo.render('groupedItemsInfoTable');
		tbgGroupedItemsInfo.afterRender = function() {
			if(tbgGroupedItemsInfo.geniisysRows.length > 0){
				enableButton('btnGIPrint');
				enableToolbarButton('btnToolbarPrint');
			} else {
				disableButton('btnGIPrint');
				disableToolbarButton('btnToolbarPrint');
			}
				
			GIRenderTag = true;
			setDetailsGroupedItemsInfo(null);
			setDetailsBeneficiaryInfo(null); //added by jeffdojello 10.30.2013
			objGIUTS023GroupedItems = tbgGroupedItemsInfo.geniisysRows;
		};
		
		beneficiaryInformationTableModel = {
				url: contextPath+"/GIUTS023BeneficiaryInfoController?action=populateGIUTS023beneficiaryInfoTableGrid&refresh=1",
				id : "beneficiaryInfo",
				options: {
					toolbar: {
						elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
					},
					height: '180px',
					onCellFocus : function(element, value, x, y, id) {
						tbgBeneficiaryInfo.keys.removeFocus(tbgBeneficiaryInfo.keys._nCurrentFocus, true);
						tbgBeneficiaryInfo.keys.releaseKeys();
						setDetailsBeneficiaryInfo(tbgBeneficiaryInfo.geniisysRows[y]);
						objGIUTS023.BenSelectedIndex = y;
					}, 
					onRemoveRowFocus : function(element, value, x, y, id){
						tbgBeneficiaryInfo.keys.removeFocus(tbgBeneficiaryInfo.keys._nCurrentFocus, true);
						tbgBeneficiaryInfo.keys.releaseKeys();
						setDetailsBeneficiaryInfo(null);
						objGIUTS023.BenSelectedIndex = -1;
					}
				},									
				columnModel: [
					{
					    id: 'recordStatus',
					    title: '',
					    width: '0',
					    visible: false
					},
					{
						id: 'divCtrId',
						width: '0',
						visible: false 
					},
					{
						id: 'beneficiaryNo',
						title : 'No.',
						width : "40px",
						filterOption : true,
					    filterOptionType : 'number',
					    align : 'right',
					    titleAlign : 'right',
					    renderer : function(value) {
					    	return value == 0 ? '' : formatNumberDigits(value, 5);
					    }
					},
					{
						id: 'beneficiaryName',
						title: 'Beneficiary Name',
						width: "200px",
						filterOption: true,
						renderer: function(value){
							return unescapeHTML2(value);
						}
						
					},
					{
						id: 'relation',
						title : 'Relation',
						width: "150px",
						filterOption: true,
						renderer : function(val){
							return unescapeHTML2(val);
						}
					},
					{
						id: 'sex',
						title : 'Gender',
						width: "50px",
						filterOption: true
					},
					{
						id: 'age',
						title : 'Age',
						width: "50px",
						align: 'right',
						titleAlign: 'right',
						filterOption: true,
						filterOptionType : 'number'
					},
					{
						id: 'dateOfBirth',
						title : 'Birthday',
						width: "80px",
						filterOption: true,
						filterOptionType : 'formattedDate',
						renderer : function(val){
							return val == '' ? '' : val == null ? '' :dateFormat(val, 'mm-dd-yyyy');
						}
					},
					{
						id: 'civilStatus',
						title : 'Status',
						width: "50px",
						filterOption: true
					},{
						id: 'beneficiaryAddr',
						title : 'Address',
						width: "242px",
						filterOption: true,
						renderer : function(val){
							return unescapeHTML2(val);
						}
					}
					
				],
				rows: []
			};
		
		tbgBeneficiaryInfo = new MyTableGrid(beneficiaryInformationTableModel);
		tbgBeneficiaryInfo.pager = [];
		tbgBeneficiaryInfo.render('beneficiaryInfoTable');
		tbgBeneficiaryInfo.afterRender = function(){
			BenRenderTag = true;
			objGIUTS023Beneficiary = tbgBeneficiaryInfo.geniisysRows;
			setDetailsBeneficiaryInfo(null); //apollo cruz 04.13.2015
		};
		
		function showPolicyInfoLOV(){
			onLOV = true;
			LOV.show({
				id : "GIUTS023PolicyInformationLOV",
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGIUTS023PolicyInformationLOV",
					lineCd : $F('txtLineCd'),
					sublineCd : $F('txtSublineCd'),
					issCd : $F('txtIssCd'),
					issueYy : $F('txtIssueYy'),
					polSeqNo : $F('txtPolSeqNo'),
					renewNo : $F('txtRenewNo'),
					page : 1
				},
				hideColumnChildTitle : true,
				filterVersion: "2",
				title : "",
				width : 700,
				height : 386,
				columnModel : [
               		{
						id : "policyNo",
						title : "Policy No.",
						width : 180,
						filterOption : true
					},
					{
						id : 'endorsementNo',
						title : 'Endt No.',
						width : 100,
						filterOption : true
					},
					{
						id : 'assdName',
						title : 'Assured Name',
						width : 403,
						filterOption : true,
						renderer : function(val){
							return unescapeHTML2(val);
						}
					}
          		],
				draggable : true,
				autoSelectOneRecord: true,
				onSelect : function(row) {
					onLOV = false;
					populatePolicyInformation(row);
				},
				onCancel : function () {
					onLOV = false;
					$("txtLineCd").focus();
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtLineCd");
					$("txtLineCd").focus();
					onLOV = false;
				}
			});
		}
		
		function showOtherCert(lineCd){
			 new Ajax.Request(contextPath + "/GIUTS023BeneficiaryInfoController", {
				parameters : {
					action			: 'showOtherCert',
					lineCd			: lineCd
				},
				asynchronous : false,
				onComplete : function(response){
					if(checkErrorOnResponse(response)){
						otherCertTag = response.responseText; 
						if (otherCertTag == "Y"){
							$("printOtherCert").show();		
							$("lblPrintOtherCert").show();
						}else{
							$("printOtherCert").hide();
							$("lblPrintOtherCert").hide();
						}
		 			}
						
				}
			}); 
		}
		
		function validateLineCd(lineCd){	//Added by Gzelle 05.25.2013 SR13198
			try{
				new Ajax.Request(contextPath+"/GIUTS008CopyPolicyController",{
					parameters:{
						action: 	"validateCopyLineCd",
						lineCd:		$F("txtLineCd"),
						issCd:		$F("txtIssCd")
					},
					asynchronous: false,
					evalScripts: true,
					onCreate: showNotice("Validating Line Code, please wait..."),
					onComplete: function(response){
						hideNotice("");		
						if(checkErrorOnResponse(response)){
							if(nvl(response.responseText, "SUCCESS") != "SUCCESS"){
								showMessageBox(response.responseText, "I");
								fireEvent($("btnToolbarEnterQuery"), "click");
							}
						}else{
							showMessageBox(response.responseText, "E");
							fireEvent($("btnToolbarEnterQuery"), "click");
						}
					}
				});
			}catch(e){
				showErrorMessage("validateLineCd",e);
			}		
		}
		
		function checkUserPerIssCd(){	//Added by Gzelle 05.25.2013 SR13198
			try{
				new Ajax.Request(contextPath+"/GIUTS008CopyPolicyController",{
					parameters:{
						action: "checkUserPerIssCd",
						lineCd : $F("txtLineCd"),
						issCd: $F("txtIssCd"),
						moduleId: "GIUTS023"
					},
					asynchronous: false,
					evalScripts: true,
					onCreate: showNotice("Validating Issue Code, please wait..."),
					onComplete: function(response){
					hideNotice("");		
						if(response.responseText != "1"){
							showMessageBox( "You are not authorized to use this issue source.", "I");
							$("txtIssCd").value = "";
							$("txtIssCd").focus();
						}
					}
				});
			}catch(e){
				showErrorMessage("checkUserPerIssCd",e);
			}	
		}
		
		var groupItemsTest = [];
		var reports = [];
		function checkReport(){
			
			if($('rdoTagAll').checked) {
				for(var i = 0; i < groupedItems.length; i++) {
					if($("printOtherCert").checked){
						printReport(groupedItems[i].groupedItemNo);
					}else{
						groupItemsTest.push(groupedItems[i].groupedItemNo);
					}
				}
			} else {
				for(var i = 0; i < tbgGroupedItemsInfo.geniisysRows.length; i++){
					if($("mtgInput"+tbgGroupedItemsInfo._mtgId+"_2,"+i).checked == true)
						if($("printOtherCert").checked){
							printReport(tbgGroupedItemsInfo.geniisysRows[i].groupedItemNo);
						}else{
							groupItemsTest.push(tbgGroupedItemsInfo.geniisysRows[i].groupedItemNo);
						}
				}
			}
			if($("printOtherCert").checked){
				if ("screen" == $F("selDestination")) {
					showMultiPdfReport(reports);
					reports = [];
				}
			}else{
				printReport(groupItemsTest);
				groupItemsTest = [];
			}
			
		}
		
		function printReport(groupedItemNo){
			try {
				var reptTitle = null;
				if($("printOtherCert").checked){
					reptTitle = 'GIPIR311_OTH';
				}else{
					reptTitle = 'GIPIR311';
				}
				var content = contextPath + "/GIUTSPrintReportController?action=printReport"
						                  //+ "&reportId=GIPIR311"
						                  + "&reportId=" + reptTitle
						                  + "&moduleId=GIUTS023"
						                  + "&policyId=" + objGIUTS023.policyId
										  + "&itemNo=" + objGIUTS023.itemNo;
				
				//var reptTitle = 'GIPIR311';
				if("screen" == $F("selDestination")){
					//added by john sr#21486 to handle long parameters e.g groupedItemNo more than 2000
					function showPdfReportNew(reportUrl, reportTitle){
						var checkUrl = reportUrl + "&checkIfReportExists=true";
						new Ajax.Request(contextPath + "/GIUTSPrintReportController?action=printReport", {
							method: "POST",
							asynchronous : true,
							parameters : {
								reportId : reptTitle,
								moduleId : "GIUTS023",
								policyId : objGIUTS023.policyId,
								groupedItemNo : groupedItemNo,
								itemNo : objGIUTS023.itemNo,
								checkIfReportExists : true,
							},
							onComplete: function(r){
								if(r.responseText == "reportExists"){
									new Ajax.Request(contextPath + "/GIISUserController", {
										method: "POST",
										evalScripts: true,
										asynchronous : true,
										parameters : {action: "setReportParamsToSession",
													  reportUrl : reportUrl + "&groupedItemNo="+ groupedItemNo,
													  reportTitle : reportTitle
													  },
										onComplete: function(response){
											window.open('pages/report.jsp', '', 'location=0, toolbar=0, menubar=0, fullscreen=1');
										}
									});	
								} else {
									showMessageBox(r.responseText, "I");
								}
							}
						});	
					}
					
					if($("printOtherCert").checked){
						//reports.push({reportUrl : content, reportTitle : reptTitle});
                                                showPdfReportNew(content, reptTitle); //SR-5553 06.15.2016
					}else{
						showPdfReportNew(content, reptTitle);
						//showPdfReport(content, reptTitle);
					}
				}else if($F("selDestination") == "printer"){
					new Ajax.Request(content + "&groupedItemNo="+ groupedItemNo, {
						parameters : {noOfCopies : $F("txtNoOfCopies"),
									 printerName : $F("selPrinter")},
						onCreate: showNotice("Processing, please wait..."),				
						onComplete: function(response){
							hideNotice();
							if (checkErrorOnResponse(response)){
								showMessageBox("Printing complete.", "S");
							}
						}
					});
				}else if("file" == $F("selDestination")){
					new Ajax.Request(contextPath + "/GIUTSPrintReportController?action=printReport&groupedItemNo="+ groupedItemNo, {
						parameters : {destination : "file",
										reportId : reptTitle,
										moduleId : "GIUTS023",
										policyId : objGIUTS023.policyId,
										groupedItemNo : groupedItemNo,
										itemNo : objGIUTS023.itemNo,
									  fileType : "PDF"},
						onCreate: showNotice("Generating report, please wait..."),
						onComplete: function(response){
							hideNotice();
							if (checkErrorOnResponse(response)){
								copyFileToLocal(response);
							}
						}
					});
				}else if("local" == $F("selDestination")){
					new Ajax.Request(content + "&groupedItemNo="+ groupedItemNo, {
						parameters : {destination : "local"},
						onComplete: function(response){
							hideNotice();
							if (checkErrorOnResponse(response)){
								var message = printToLocalPrinter(response.responseText);
								if(message != "SUCCESS"){
									showMessageBox(message, imgMessage.ERROR);
								}
							}
						}
					});
				}
			} catch (e){
				showErrorMessage("printReport", e);
			}
		}
		
		
		
		$$("div#policyInformationDiv input[type='text']").each(
			function(obj){
				if(obj.id != 'txtEndtNo' && obj.id != 'txtAssdName'){
					obj.observe("keypress", function(event){
						if(event.keyCode == 8 || event.keyCode == 46 || event.keyCode == 0){
							$("txtAssdName").clear();
							$("txtEndtNo").clear();
							$('hidPolicyId').clear();
							enableSearch('imgPolicyInfo');
							disableToolbarButton('btnToolbarExecuteQuery');
							enableToolbarButton('btnToolbarEnterQuery');
						}
					});
				}
			}		
		);
		
		$("imgPolicyInfo").observe("click", function() {
			if(onLOV)
				return;
			if($F('txtLineCd') == "")
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, 'txtLineCd');
			else
				showPolicyInfoLOV();
		});
		
		$$("#policyInformationDiv input[type='text']").each(
			function(obj) {
				if(obj.id == 'txtLineCd' || obj.id == 'txtSublineCd' || obj.id == 'txtIssCd' || obj.id == 'txtIssueYy'
						|| obj.id == 'txtPolSeqNo' || obj.id == 'txtRenewNo') {
					obj.observe('keypress', function(event){
						if(event.keyCode == 13) {
							if(onLOV || $('hidPolicyId').value != '')
								return;
							if($F('txtLineCd') == "")
								customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, 'txtLineCd');
							else
								showPolicyInfoLOV();
						}
					});
					
				}
			}		
		);
		
		$$("label[name='gro']").each(
			function(obj){
				obj.observe("click", function(){
					obj.innerHTML = obj.innerHTML == "Hide" ? "Show" : "Hide";
					var div = obj.up("div", 1).next().id;
					Effect.toggle(div, "blind", {duration: .3});
				});
			}		
		);
		
		$("imgGIBirthDate").observe("click", function() {
			if ($("imgGIBirthDate").disabled == true)
				return;
			scwShow($('txtGIBirthdate'), this, null);
		});
		
		$("txtGIBirthdate").observe("focus", function(){
			if(this.value != ''){
				var sysdate = new Date();
				var date = Date.parse(this.value);
				if(date > sysdate){
					this.clear();
					$("txtGIAge").clear();
					customShowMessageBox('Date of birth should not be later than system date.', imgMessage.ERROR, this);
				} else
					$('txtGIAge').value = computeAge(this.value);
			}
				
		});
		
		$("txtGIBirthdate").observe("keypress", function(event){
			if(event.keyCode == 8 || event.keyCode == 46){
				this.clear();
				$("txtGIAge").clear();
			}
		});
		
		$("imgBenBirthDate").observe("click", function() {
			if ($("imgBenBirthDate").disabled == true)
				return;
			scwShow($('txtBenBirthDate'), this, null);
		});
		
		$("txtBenBirthDate").observe("focus", function(){
			if(this.value != ''){
				var sysdate = new Date();
				var date = Date.parse(this.value);
				if(date > sysdate){
					this.clear();
					$("txtBenAge").clear();
					customShowMessageBox('Date of birth should not be later than system date.', imgMessage.ERROR, this);
				} else
					$('txtBenAge').value = computeAge(this.value);
			}
				
		});
		
		$("txtBenBirthDate").observe("keypress", function(event){
			if(event.keyCode == 8 || event.keyCode == 46){
				this.clear();
				$("txtBenAge").clear();
			}
		});

		
		$("btnToolbarExecuteQuery").observe("click", executeQuery);
		
		$("btnToolbarEnterQuery").observe("click", function(){
			if(GIChangeTag == 1 || BenChangeTag == 1){
				nextMove = 'reset';
				showConfirmBox4('Confirmation', objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", saveAll, resetForm, null);
			} else
				resetForm();
		});
		
		$('txtGIEnrolleeCode').observe('change', function(){
			if($F('btnGIAddUpdate') == 'Add')
				validateGroupedItemNo();
			validateGroupedItemTitle();
		});
		
		$('txtGIEnrolleeName').observe('change', function(){
			if($F('btnGIAddUpdate') == 'Add')
				validateGroupedItemNo();
			validateGroupedItemTitle();
		});
		
		$('txtBeneficiaryNo').observe('change', function(){
			if($F('btnBenAddUpdate') == 'Add')
				validateBeneficiaryNo();
		});
		
		$("txtLineCd").observe("change", function name() {	//Added by Gzelle 05.25.2013 SR13198
			validateLineCd($F("txtLineCd"));
		});
		
		$("txtIssCd").observe("change", function name() {	//Added by Gzelle 05.25.2013 SR13198
			checkUserPerIssCd();
		});
		
		function exit() {
			delete objGIUTS023;
			delete objGIUTS023GroupedItems;
			delete objGIUTS023Beneficiary;
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		}
		
		$("parExit").observe("click", function () {
			if(GIChangeTag == 1 || BenChangeTag == 1){
				nextMove = 'exit';
				showConfirmBox4('Confirmation', objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", saveAll, exit, null);
			} else
				exit();
		});
		
		$("btnToolbarExit").observe("click", function () {
			if(GIChangeTag == 1 || BenChangeTag == 1){
				nextMove = 'exit';
				showConfirmBox4('Confirmation', objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", saveAll, exit, null);
			} else
				exit();
		});
		
		$("btnCancel").observe("click", function () {
			if(GIChangeTag == 1 || BenChangeTag == 1){
				nextMove = 'reset';
				showConfirmBox4('Confirmation', objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", saveAll, resetForm, null);
			} else
				resetForm();
		});
		
		$('btnGIPrint').observe('click', function(){
			if(GIChangeTag == 1 || BenChangeTag == 1)
				showMessageBox('Please save before printing the report.');
			else {
				var countChecked = 0;
				for(var i = 0; i < tbgGroupedItemsInfo.geniisysRows.length; i++){
					if($("mtgInput"+tbgGroupedItemsInfo._mtgId+"_2,"+i).checked == true)
						countChecked++;
				}
				
				if(countChecked > 0){
					showGenericPrintDialog("Print", checkReport, null, false);
				} else {
					showMessageBox("Please select record for printing.", "I");		
				}
			}
			
		});
		
		$('btnToolbarPrint').observe('click', function(){
			if(GIChangeTag == 1 || BenChangeTag == 1)
				showMessageBox('Please save before printing the report.');
			else {
				var countChecked = 0;
				for(var i = 0; i < tbgGroupedItemsInfo.geniisysRows.length; i++){
					if($("mtgInput"+tbgGroupedItemsInfo._mtgId+"_2,"+i).checked == true)
						countChecked++;
				}
				
				if(countChecked > 0){
					showGenericPrintDialog("Print", checkReport, null, false);
				} else {
					showMessageBox("Please select record for printing.", "I");		
				}
			}
			
		});
		
		$('mtgRefreshBtnitemInformation').stopObserving();
		
		$('mtgRefreshBtnitemInformation').observe('click', function(){
			if(GIChangeTag == 1 || BenChangeTag == 1){
				showConfirmBox4('Confirmation', objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", saveAll, function(){
					GIChangeTag = 0;
					BenChangeTag = 0;
					tbgItemInfo._refreshList();
				}, null);
			} else
				tbgItemInfo._refreshList();
		});
		
		$('mtgRefreshBtngroupedItemsInfo').stopObserving();
		
		$('mtgRefreshBtngroupedItemsInfo').observe('click', function(){
			if(GIChangeTag == 1 || BenChangeTag == 1){
				showConfirmBox4('Confirmation', objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", saveAll, function(){
					GIChangeTag = 0;
					BenChangeTag = 0;
					tbgGroupedItemsInfo._refreshList();
				}, null);
			} else
				tbgGroupedItemsInfo._refreshList();
		});
		
		$('mtgRefreshBtnbeneficiaryInfo').stopObserving();
		
		$('mtgRefreshBtnbeneficiaryInfo').observe('click', function(){
			if(BenChangeTag == 1){
				showConfirmBox4('Confirmation', objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", saveAll, function(){
					//GIChangeTag = 0;
					BenChangeTag = 0;
					tbgBeneficiaryInfo._refreshList();
				}, null);
			} else
				tbgBeneficiaryInfo._refreshList();
		});
		
		$('rdoTagAll').observe('click', function(){
			if(this.checked){
				for(var i = 0; i < tbgGroupedItemsInfo.geniisysRows.length; i++){
					$("mtgInput"+tbgGroupedItemsInfo._mtgId+"_2,"+i).checked = true;
				}
			}
		});
		
		$('rdoUntagAll').observe('click', function(){
			if(this.checked){
				for(var i = 0; i < tbgGroupedItemsInfo.geniisysRows.length; i++){
					$("mtgInput"+tbgGroupedItemsInfo._mtgId+"_2,"+i).checked = false;
				}
			}
		});
		
		initializeAll();
		initializeAllMoneyFields();
		initGIUTS023();
		
	} catch (e) {
		showErrorMessage("enrolleeCertificate", e);
	}
</script>