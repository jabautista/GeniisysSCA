<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="inspectionReportMainDiv" name="inspectionReportMainDiv">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label id="inspectionInfo">Inspection Information</label>
			<span class="refreshers" style="margin-top: 0;">
	 			<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
	 			<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
		</div>
	</div>
	<div id="inspectionReportHeaderDiv" class="sectionDiv">
		<table style="width: 100%; margin-top: 15px; margin-bottom: 15px;" cellpadding="0" cellspacing="0">
			<tr>
				<td align="left" style="width: 8%;"></td>
				<td align="right" style="width: 10%;"><label>Inspection No.</label></td>
				<td align="left" style="width: 29%;">
					<!-- 
					<div style="float: left; border: 1px solid gray; height: 18.5px; width: 53%; margin-top: 3px;">
						<input type="text" id="inspNo" name="inspNo" style="width: 82%; border: none; float: left; height: 10px; text-align: right;" readonly="readonly" tabindex="1"/>
						<img style="float: left;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchInspectionNo" name="searchInspectionNo" alt="Go" />
					</div>
					 -->
					<input type="text" id="inspNo" name="inspNo" style="width: 53%; float: left; text-align: right;" readonly="readonly" tabindex="101" /> 
				</td>
				<td></td>
				<td align="left" style="width: 15%;"><label style="margin-left: 70px;">Approved?</label></td>
				<td align="left" style="width: 25%;"><input type="checkbox" id="approvedTag" name="approvedTag" value="A" tabindex="109"/></td>
				<td></td>
			</tr>
			<tr>
				<td align="left" style="width: 8%;"></td>
				<td align="right" style="width: 10%;"><label style="margin-left: 25px;">Inspector</label></td>
				<td align="left" style="width: 15%;">
					<div style="float: left; border: 1px solid gray; height: 20px; width: 96%;" class="required">
						<input type="hidden" id="inspectorCd" name="inspectorCd" />
						<input type="text" id="inspector" name="inspector" style="width: 89%; border: none; float: left; height: 10px;" class="required" tabindex="102" readonly="readonly" inspData="Y" ignoreDelKey="Y"/>
						<img style="float: left;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchInspector" name="searchInspector" alt="Go"tabindex="103"/>
					</div>
				</td>
				<td></td>
				<td align="left" style="width: 15%;"><label style="margin-left: 44px;">Date Inspected</label></td>
				<td align="left" style="width: 23%;">
					<div style="float: left; border: 1px solid gray; height: 20px;" class="required">
						<input type="text" id="dateInspected" name="dateInspected" style="width: 84%; border: none; float: left; height: 10px;" class="required" tabindex="110" readonly="readonly" ignoreDelKey="Y"/><!-- Added inspDataChangeTag = 1; reymon 05042013 -->
						<img id="hrefDateInsp" style="float: left;" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('dateInspected'),this, null); changeTag=1; inspDataChangeTag = 1;" alt="Inspection Date" tabindex="111"/>
					</div>
				</td>
				<td></td>
			</tr>
			<tr>
				<td align="left" style="width: 8%;"></td>
				<td align="right" style="width: 10%;"><label style="margin-left: 33px;">Assured</label></td>
				<td align="left" style="width: 15%;">
					<div style="float: left; border: 1px solid gray; height: 20px; width: 96%; margin-top: 3px;" class="required">
						<!-- <input type="hidden" id="txtAssdNo" name="txtAssdNo" /> -->
						<input type="hidden" id="assuredNo" name="assuredNo" />
						<input type="hidden" id="txtDrvAssuredName" name="txtDrvAssuredName" />
						<input type="hidden" id="address1" name="address1" />
						<input type="hidden" id="address2" name="address2" />
						<input type="hidden" id="address3" name="address3" />
						<input type="text" id="assuredName" name="assuredName" style="width: 89%; border: none; float: left; height: 10px;" class="required" tabindex="104" readonly="readonly" inspData="Y" ignoreDelKey="Y"/>
						<img style="float: left;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchAssured" name="searchAssured" alt="Go" tabindex="105"/>
					</div>
				</td>
				<td></td>
				<td align="left" style="width: 15%;"><label style="margin-left: 64px;">Referred by</label></td>
				<td align="left" style="width: 23%;">
					<div style="float: left; border: 1px solid gray; height: 20px; width: 96.5%; margin-top: 3px;" class="required">
						<input type="hidden" id="txtIntmNo" name="txtIntmNo" />
						<input type="hidden" id="txtDrvIntmName" name="txtDrvIntmName" />
						<input type="text" id="txtIntmName" name="txtIntmName" style="width: 88%; border: none; float: left; height: 10px;" tabindex="112" class="required" readonly="readonly" inspData="Y" ignoreDelKey="Y"/>
						<img style="float: left;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIntermediary" name="searchIntermediary" alt="Go" tabindex="113"/>
					</div>
				</td>
				<td></td>
			</tr>
			<tr>
				<td style="width: 3%;"></td>
				<td style="width: 10%; text-align: right;"><label style="margin-left: 5px;">Approved by</label></td>
				<td style="width: 11%;">
					<input type="hidden" id="currentUser" name="currentUser" value="${currentUser}" />
					<input type="text" id="approvedBy" name="approvedBy" style="margin-left: 0px; width: 93.7%; margin-top: 3px;" readonly="readonly" tabindex="106"/>
				</td>
				<td style="width: 10%; text-align: right; padding-right: 6px;" colspan="2">Date Approved</td>
				<td style="width: 11%;"><input type="text" id="dateApproved" name="dateApproved" style="width: 94%; margin-left: 0px; margin-top: 3px; float: left;" readonly="readonly" tabindex="114"/></td>
			</tr>
			<tr>
				<td style="width: 8%;"></td>
				<td style="width: 10%;" align="right"><label style="margin-left: 25px;">Remarks</label></td>
				<td align="left" style="width: 15%;" colspan="5">
					<div style="width: 93.3%; float: left; border: 1px solid gray; height: 20px;">
						<textarea onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" id="remarks" name="remarks" style="width: 96%; border: none; float: left; height: 12px;" maxlength="2001" tabindex="107"></textarea>
						<img style="float: left;" src="${pageContext.request.contextPath}/images/misc/edit.png" id="editRemarks" alt="Go" tabindex="108" />
					</div>
				</td>
				<td></td>
			</tr>
		</table>
	</div>
	<jsp:include page="/pages/underwriting/utilities/inspectionReport/subPages/inspectionReportItemInfo.jsp"></jsp:include>
</div>
<script type="text/javascript">
	var today = new Date();
	objUW.hidFuncGIPIS197 = {}; //added by steven 7.18.2012
	//$("dateInspected").value = dateFormat(today, "mm-dd-yyyy");
	
	function reloadInspectionReport(){
		showInspectionReport(inspData1Obj);
		hideNotice();
	}
	
	objUW.hidFuncGIPIS197.reloadInspectionReport = reloadInspectionReport;
	/* $("reloadForm").observe("click", function(){
		if (changeTag == 1){
			showConfirmBox4("Confirm", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", saveInspectionReport, reloadInspectionReport, "");
		} else {
			reloadInspectionReport();
		}
	}); */
	observeReloadForm("reloadForm", reloadInspectionReport);

	/*
	$("searchInspectionNo").observe("click", function(){
		if (changeTag == 1){
			showConfirmBox4("Confirm", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", saveInspectionReport, showInspectionModal, "");
		} else {
			showInspectionModal();
		}
	});*/
	
	function showInspectorLOV() {
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getInspectorLOV",
							page : 1},
			title: "Inspector",
			width: 380,
			height: 386,
			columnModel: [ 		
		               		{   		
								id: 'inspCd',
								title: 'Insp Cd',
								titleAlign: 'right',
								align: 'right',
								width: '100px'
							},
							{
								id: 'inspName',
								title: 'Insp Name',
								titleAlign: 'left',
								width: '261px'
							}
			              ],
			draggable: true,
	  		onSelect: function(row) {
	  			$("inspectorCd").value = row.inspCd;
				$("inspector").value = unescapeHTML2(row.inspName);
				changeTag = 1;
	  		}
		});
	}

	$("searchInspector").observe("click", function (){
		if ($F("approvedTag") != "A"){
			//openSearchInspector();
			showInspectorLOV();
			fireEvent($("inspector"), "change");
		}
	});

	$("searchAssured").observe("click", function (){
		if ($F("approvedTag") != "A"){
			//openSearchAssured();
			//openSearchClientModal();
			//fireEvent($("txtAssuredName"), "change");
			showGIISAssuredLOV("getGIISAssuredLOVTG", 
				function(row) {
					$("assuredNo").value = row.assdNo;
					$("txtDrvAssuredName").value = row.assdName;
					$("address1").value = row.mailAddress1;
					$("address2").value = row.mailAddress2;
					$("address3").value = row.mailAddress3;
					$("assuredName").value = unescapeHTML2(nvl(row.assdName,"")); //added by steven 9/21/2012
					changeTag = 1; 
				});
			fireEvent($("assuredName"), "change");
		}
	});

	$("searchIntermediary").observe("click", function (){
		function assignIntm(row) {
			$("txtIntmNo").value = row.intmNo;
			$("txtIntmName").value = unescapeHTML2(row.intmName); //added by christian 01/15/2012
			changeTag = 1;
		}
		
		if ($F("approvedTag") != "A"){
			//openSearchIntermediary();
			showIntermediaryLOV("UnderwritingLOVController", "getIntmCdNameLOV", 
				function(row) {
					$("txtIntmNo").value = row.intmNo;
					$("txtIntmName").value = unescapeHTML2(row.intmName); //added by christian 01/15/2012
					changeTag = 1;
				});
			fireEvent($("txtIntmName"), "change");
		}
	});
	
	$("editRemarks").observe("click", function () {
		if($("approvedTag").checked){
			showEditor("remarks", 2000, 'true');
		}else{
// 			showEditor("remarks", 2000);
			showEditor2("remarks", 2000, null, null, null, function() {
				inspDataChangeTag = 1;
				changeTag = 1;
			}); //added by steven 9.20.2013
		}
	});
	
	$("remarks").observe("change", function () {
		inspDataChangeTag = 1;
	});
	
	inspectionReportObj.insertedWcObjects = []; // added by: Nica 06.18.2012 - to reset added warranty and clause
	
	$$("div#inspectionReportHeaderDiv img").each(function (img) {
		var src = img.src;
		if ($("approvedTag").checked) {
			if(nvl(img, null) != null){
				if(src.include("searchIcon.png")){
					disableSearch(img);
				}else if(src.include("but_calendar.gif")){
					disableDate(img); 
				}
			}
		}
	});
</script>