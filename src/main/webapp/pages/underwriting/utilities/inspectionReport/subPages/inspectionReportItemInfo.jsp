<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
		<label id="itemInfo">Item Information</label>
		<span class="refreshers" style="margin-top: 0;">
 			<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
		</span>
	</div>
</div>
<div id="inspectionReportItemDiv" class="sectionDiv">
	<div id="inspItemInformation" name="inspItemInformation" style="width : 100%;">
		<div id="inspItemInfoTable" style="margin : 10px;">
			<div class="tableHeader">
				<label style="text-align: right; width: 12%;">Item No.</label>
				<label style="text-align: left; width: 25%; margin-left: 10px;">Item Title</label>
				<label style="text-align: left; width: 25%; margin-left: 10px;">Description</label>
				<label style="text-align: right; width: 16%; margin-left: 10px;">TSI Amount</label>
				<label style="text-align: right; width: 16%; margin-left: 10px;">Premium Rate</label>
			</div>
			<div id="inspItemInfoContainer" class="tableContainer">
	
			</div>
		</div>
	</div>
	<table id="itemInfoFormTable" style="width: 100%; margin-top: 20px; margin-bottom: 20px;" cellpadding="0" cellspacing="0">
		<tr>
			<td style="width: 3%;"></td>
			<td style="width: 8%;" align="right">Property</td>
			<td colspan="5"><input class="integerUnformatted" lpad="10" type="text" id="itemNo" name="itemNo" style="margin-left: 3px; width: 120px; text-align: right;" tabindex="201" maxlength="9"/><input type="text" id="itemNo2" name="itemNo2" style="margin-left: 2px; width: 630px;" tabindex="202" maxlength="50" class="required upper"/></td>
			<td></td>
		</tr>
		<tr>
			<td style="width: 3%;"></td>
			<td style="width: 8%;" align="right">Description</td>
			<td colspan="5"><input type="text" id="propertyDesc" name="propertyDesc" style="margin-left: 3px; width: 760px;" tabindex="203" maxlength="2001" onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);"/></td>
			<td></td>
		</tr>
		<tr>
			<td style="width: 3%;"></td>
			<td style="width: 8%;" align="right">Province</td>
			<td style="width: 11%;">
				<div style="margin-left: 3px; width: 97.5%; float: left; border: 1px solid gray; height: 21px;" class="required">
					<input type="hidden" id="provinceCd" name="provinceCd" />
					<input type="text" id="province" name="province" style="width: 83%; border: none; float: left; height: 13px;" readonly="readonly" tabindex="204" ignoreDelKey="Y" class="required"/>
					<img style="float: left;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchProvince" name="searchProvince" alt="Go" tabindex="205"/>
				</div>
			</td>
			<td style="width: 8%;" align="right">EQ Zone</td>
			<td style="width: 11%;">
				<select id="eqZone" style="margin-left: 3px; width: 99%; margin-top: 2px;" tabindex="215">
					<option value=""></option>
					<c:forEach var="eqZoneList" items="${eqZoneList}">
						<option value="${eqZoneList.eqZone}"
						>${fn:escapeXml(eqZoneList.eqDesc)}</option>
					</c:forEach>
				</select>
			</td>
			<td style="width: 8%;" align="right">TSI Amount</td>
			<td style="width: 11%;"><input class="money2" type="text" id="tsiAmt" name="tsiAmt" style="margin-left: 3px; width: 93.5%; margin-top: 2px; text-align: right;" tabindex="224" errorMsg="Field must be of form 9,999,999,999,999,999.99"/></td>
			<td></td>
		</tr>
		<tr>
			<td style="width: 3%;"></td>
			<td style="width: 8%;" align="right">City</td>
			<td style="width: 11%;">
				<div style="margin-left: 3px; width: 97.5%; float: left; border: 1px solid gray; height: 21px;" class="required">
					<input type="hidden" id="cityCd" name="cityCd" />
					<input type="text" id="city" name="city" style="width: 83%; border: none; float: left; height: 13px;" readonly="readonly" tabindex="206" ignoreDelKey="Y" class="required"/>
					<img style="float: left;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchCity" name="searchCity" alt="Go"  tabindex="207"/>
				</div>
			</td>
			<td style="width: 8%;" align="right">Typhoon Zone</td>
			<td style="width: 11%;">
				<select id="typhoonZone" style="margin-left: 3px; width: 99%; margin-top: 2px;" tabindex="216">
					<option value=""></option>
						<c:forEach var="typhoon" items="${typhoonList}">
							<option value="${typhoon.typhoonZone}"
							>${fn:escapeXml(typhoon.typhoonZoneDesc)}</option>
					</c:forEach>
				</select>
			</td>
			<td style="width: 8%;" align="right">Premium Rate</td>
			<td style="width: 11%;"><input class="money2" type="text" id="premRt" name="premRt" style="margin-left: 3px; width: 93.5%; margin-top: 2px; text-align: right;" tabindex="225"  errorMsg="Field must be of form 9,999,999,999,999,999.99"/></td>
			<td></td>
		</tr>
		<tr>
			<td style="width: 3%;"></td>
			<td style="width: 8%;" align="right">District</td>
			<td style="width: 11%;">
				<div style="margin-left: 3px; width: 97.5%; float: left; border: 1px solid gray; height: 21px;" tabindex="11" class="required">
					<input type="hidden" id="districtNo" name="districtNo" />
					<input type="text" id="district" name="district" style="width: 83%; border: none; float: left; height: 13px;" readonly="readonly" tabindex="208" ignoreDelKey="Y" class="required"/>
					<img style="float: left;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchDistrict" name="searchDistrict" alt="Go" tabindex="209"/>
				</div>
			</td>
			<td style="width: 8%;" align="right">Flood Zone</td>
			<td style="width: 11%;">
				<select id="floodZone" style="margin-left: 3px; width: 99%; margin-top: 2px;" tabindex="217">
					<option value=""></option>
						<c:forEach var="flood" items="${floodList}">
							<option value="${flood.floodZone}"
							>${fn:escapeXml(flood.floodZoneDesc)}</option>
					</c:forEach>
				</select>
			</td>
			<td style="width: 8%;" align="right">Tariff Code</td>
			<td style="width: 11%;">
				<select id="tariffCd" name="tariffCd" style="margin-left: 3px; width: 98%; margin-top: 2px;" tabindex="226">
					<option value=""></option>
						<c:forEach var="tariff" items="${tariffList}">
							<option value="${tariff.tariffCd}"
							>${fn:escapeXml(tariff.tariffCd)} - ${fn:escapeXml(tariff.tariffDesc)}</option>
					</c:forEach>
				</select>
			</td>
			<td></td>
		</tr>
		<tr>
			<td style="width: 3%;"></td>
			<td style="width: 8%;" align="right">Block</td>
			<td style="width: 11%;">
				<div style="margin-left: 3px; width: 97.5%; float: left; border: 1px solid gray; height: 21px;" tabindex="12" class="required">
					<input type="text" id="block" name="block" style="width: 83%; border: none; float: left; height: 13px;" readonly="readonly" tabindex="210" ignoreDelKey="Y" class="required"/>
					<img style="float: left;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBlock" name="searchBlock" alt="Go" tabindex="211"/>
				</div>
			</td>
			<td style="width: 8%;" align="right">Construction</td>
			<td style="width: 11%;">
				<select id="construction" style="margin-left: 3px; width: 99%; margin-top: 2px;" tabindex="218">
					<option value=""></option>
						<c:forEach var="construction" items="${constructionList}">
							<option value="${construction.constructionCd}"
							>${fn:escapeXml(construction.constructionDesc)}</option>
					</c:forEach>
				</select>
			</td>
			<td style="width: 8%;" align="right">Tariff Zone</td>
			<td style="width: 11%;">
				<select id="tariffZn" name="tariffZn" style="margin-left: 3px; width: 98%; margin-top: 2px;" tabindex="227">
					<option value=""></option>
						<c:forEach var="tariffZone" items="${tariffZoneList}">
							<option value="${tariffZone.tariffZone}"
							>${fn:escapeXml(tariffZone.tariffZone)} - ${fn:escapeXml(tariffZone.tariffZoneDesc)}</option>
					</c:forEach>
				</select>
			</td>
			<td></td>
		</tr>
		<tr>
			<td style="width: 3%;"></td>
			<td style="width: 8%;" align="right">Location</td>
			<td style="width: 11%;"><input type="text" id="location" name="location" style="margin-left: 3px; width: 94%; margin-top: 3px;" tabindex="212" maxlength="50"/></td>
			<td style="width: 8%;" align="right">Construction Remarks</td>
			<td style="width: 11%;">
				<div style="margin-left: 3px; width: 98%; float: left; border: 1px solid gray; height: 23px;">
					<!-- emsy 07312012 <input type="text" id="constRmrk" name="constRmrk" style="width: 85%; border: none; float: left; height: 15px;" maxlength="2000" tabindex="219"/> -->
					<textarea onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" id="constRmrk" name="constRmrk" style="width: 85%; border: none; float: left; height: 15px;" maxlength="2001" tabindex="219"></textarea>
					<img style="float: left;" src="${pageContext.request.contextPath}/images/misc/edit.png" id="editConstRmrk" name="edit" alt="Go" tabindex="220"/>
				</div>
			</td>
			<td style="width: 8%;" align="right">Boundary Front</td>
			<td style="width: 11%;">
				<div style="margin-left: 3px; width: 97%; margin-top: 3px; float: left; border: 1px solid gray; height: 23px;">
					<!-- emsy 07312012  <input type="text" id="bndrFrnt" name="bndrFrnt" style="width: 84.5%; border: none; float: left; height: 15px;" maxlength="2000" tabindex="228"/> -->
					<textarea onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" id="bndrFrnt" name="bndrFrnt" style="width: 84.5%; border: none; float: left; height: 15px;" maxlength="2001" tabindex="228"/></textarea>
					<img style="float: left;" src="${pageContext.request.contextPath}/images/misc/edit.png" id="editBndrFrnt" name="edit" alt="Go" tabindex="229"/>
				</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td style="width: 3%;"></td>
			<td style="width: 8%;"></td>
			<td style="width: 11%;"><input type="text" id="location2" name="location2" style="margin-left: 3px; width: 94%; margin-top: 3px;" tabindex="213" maxlength="50"/></td>
			<td style="width: 8%;" align="right">Occupancy</td>
			<td style="width: 11%;">
				<select id="occupancy" style="margin-left: 3px; width: 99%; margin-top: 2px;" tabindex="221">
					<option value=""></option>
						<c:forEach var="occupancy" items="${occupancyList}">
							<option value="${occupancy.occupancyCd}"
							 style="width:250px; ">${fn:escapeXml(occupancy.occupancyDesc)}</option>
					</c:forEach>
				</select>
			</td>
			<td style="width: 8%;" align="right">Right</td>
			<td style="width: 11%;">
				<div style="margin-left: 3px; width: 97%; margin-top: 3px; float: left; border: 1px solid gray; height: 23px;">
					<!-- emsy 07312012 <input type="text" id="right" name="right" style="width: 84.5%; border: none; float: left; height: 15px;" maxlength="2000" tabindex="230"/> -->
					<textarea onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" id="right" name="right" style="width: 84.5%; border: none; float: left; height: 15px;" maxlength="2001" tabindex="230"/></textarea>
					<img style="float: left;" src="${pageContext.request.contextPath}/images/misc/edit.png" id="editRight" name="edit" alt="Go"  tabindex="231"/>
				</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td style="width: 3%;"></td>
			<td style="width: 8%;"></td>
			<td style="width: 11%;"><input type="text" id="location3" name="location3" style="margin-left: 3px; width: 94%; margin-top: 3px;" tabindex="214" maxlength="50"/></td>
			<td style="width: 8%;" align="right">Occupancy Remarks</td>
			<td style="width: 11%;">
				<div style="margin-left: 3px; width: 98%; float: left; border: 1px solid gray; height: 23px;">
					<!-- emsy 07312012 <input type="text" id="occRmrk" name="occRmrk" style="width: 85%; border: none; float: left; height: 15px;" maxlength="2000" tabindex="222"/> -->
					<textarea onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" id="occRmrk" name="occRmrk" style="width: 85%; border: none; float: left; height: 15px;" maxlength="2001" tabindex="222"/></textarea>
					<img style="float: left;" src="${pageContext.request.contextPath}/images/misc/edit.png" id="editOccRmrk" name="edit" alt="Go" tabindex="223"/>
				</div>
			</td>
			<td style="width: 8%;" align="right">Left</td>
			<td style="width: 11%;">
				<div style="margin-left: 3px; margin-top: 3px; width: 97%; float: left; border: 1px solid gray; height: 23px;">
					<!-- emsy 07312012 <input type="text" id="left" name="left" style="width: 84.5%; border: none; float: left; height: 15px;" maxlength="2000" tabindex="232"/> -->
					<textarea onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" id="left" name="left" style="width: 84.5%; border: none; float: left; height: 15px;" maxlength="2001" tabindex="232"/></textarea>
					<img style="float: left;" src="${pageContext.request.contextPath}/images/misc/edit.png" id="editLeft" name="edit" alt="Go"  tabindex="233"/>
				</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<!-- Added By MarkS SR-5918 02/09/2017 -->
			<td style="width: 3%;"></td>
			<td style="width: 8%;" align="right">LAT</td>
			<td style="width: 11%;"><input type="text" id="txtLatitude" name="txtLatitude" style="margin-left: 3px; width: 31.7%; margin-top: 3px;" tabindex="212" maxlength="50"/>
			LONG
			<input type="text" id="txtLongitude" name="txtLongitude" style="margin-left: 3px; width: 31.7%; margin-top: 3px;" tabindex="212" maxlength="50"/></td>
			<!-- Added by MarkS 02/09/2017 -->
			<td style="width: 8%;" align="right" colspan="3">Rear</td>
			<td style="width: 11%;">
				<div style="margin-left: 3px; margin-top: 3px; width: 97%; float: left; border: 1px solid gray; height: 23px;">
					<!--emsy 07312012 <input type="text" id="rear" name="rear" style="width: 84.5%; border: none; float: left; height: 15px;" maxlength="2000"  tabindex="234"/> -->
					<textarea onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" id="rear" name="rear" style="width: 84.5%; border: none; float: left; height: 15px;" maxlength="2001"  tabindex="234"/></textarea>
					<img style="float: left;" src="${pageContext.request.contextPath}/images/misc/edit.png" id="editRear" name="edit" alt="Go"  tabindex="235"/>
				</div>
			</td>
			<td></td>
		</tr>
		
	</table>
	<div id="itemInfoBtnDiv" align="center" style="margin-bottom: 20px;">
		<input type="button" class="button" id="btnAddItem" name="btnAddItem" value="Add" tabindex="236"/>
		<input type="button" class="button" id="btnDeleteItem" name="btnDeleteItem" value="Delete" tabindex="237"/>
	</div>
	<input type="hidden" id="region" name="region" value="" />
	<input type="hidden" id="regionCd" name="regionCd" value="" />
	<input type="hidden" id="blockId" name="blockId" value="" />
	<input type="hidden" id="blockId" name="blockId" value="" />
	<input type="hidden" id="eqZoneDesc" name="eqZoneDesc" value="" />
	<input type="hidden" id="typhoonZoneDesc" name="typhoonZoneDesc" value="" />
	<input type="hidden" id="floodZoneDesc" name="floodZoneDesc" value="" />
	<input type="hidden" id="approvedTagHid" name="approvedTagHid" value="" />
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnWarrantyClause" name="btnWarrantyClause" value="Warranty/Clause" tabindex="238"/>
	<input type="button" class="button" id="btnAttachViewPic" name="btnAttachViewPic" value="Attach/View Pictures" tabindex="239"/>
	<input type="button" class="button" id="btnOtherDetails" name="btnOtherDetails" value="Other Details" tabindex="240"/>
	<input type="button" class="button" id="btnPrint" name="btnPrint" value="Print" style="width: 80px;"tabindex="241"/>
	<input type="button" class="button" id="btnCancel" name="btnCancel" value="Cancel" tabindex="242"/>
	<input type="button" class="button" id="btnSave" name="btnSave" value="Save" tabindex="243"/>
</div>
<script type="text/javascript">
// 	$("itemNo").value = generateItemNo();
	makeInputFieldUpperCase();
	initializeAll();
	initializeAccordion();
	
	inspDataChangeTag = 0;
	objUW.hidObjGIPIS197 = {};
	disableButton("btnAddItem");
	disableButton("btnDeleteItem");
	
	$$("input[inspData='Y']").each(function (inspInput){
		inspInput.observe("change", function (){
			inspDataChangeTag = 1;
		});
	});
	
	//functions
	function proceedItemSaving(){
		var addSw = "Y"; //Added by Jerome 09.29.2016 SR 5690
		if ($("btnAddItem").value == "Add"){
			$$("div[name='inspItemInfo']").each(function (row){// Added by Jerome 08.19.2016 SR 5615
				if(lpad(row.getAttribute("itemno"), 10, 0) == $F("itemNo")){
					showMessageBox("Cannot add item. Item no. already exists.");
					addSw = "N";
					return false;
				}
			});
			
			if (addSw == "Y"){ //Added by Jerome 09.29.2016 SR 5690
				addNewItemRow("A");
			}
			//addNewItemRow("A"); //Commented out by Jerome 09.29.2016 SR 5690
		} else {
			addNewItemRow("U");
		}
	}

	function checkParlistDependency(inspNo){
		var isValid = false;
		var inspNoParam = parseInt(inspNo);
		new Ajax.Request(contextPath+"/GIPIPARListController?",{
			method: "POST",
			parameters: {
				action: "checkParlistDependency",
				inspNo: inspNoParam
			},
			evalScripts: true,
			asynchronous: false,
			onSuccess: function (response){
				if (checkErrorOnResponse(response)){
					if (response.responseText == "Valid"){
						isValid = true;
					} else {
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			}
		});

		return isValid;
	}

	function showCity(column){
		var provinceCd = $F("provinceCd");
		var url	= contextPath + "/GIPIInspectionReportController?action=showCity&column="+column+"&provinceCd="+provinceCd;

		showOverlayContent2(url, "List of Province and City", 620, "");
	}

	function showBlock(column){
		var provinceCd 	= $F("provinceCd");
		var cityCd 		= $F("cityCd");
		var districtNo 	= $F("districtNo");
		var url			= contextPath + "/GIPIInspectionReportController?action=showBlock&column=" + column + "&regionCd=&provinceCd=" + provinceCd + "&cityCd=" + cityCd + "&districtNo=" + districtNo;
		
		showOverlayContent2(url, "List of Disctrict and Block", 820, "");
	}
	
	$("btnCancel").observe("click", function (){
		if (changeTag == 1){
			showConfirmBox4("Confirm", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function() {
				//saveInspectionReport();
				fireEvent($("btnSave"), "click");
				exitInspectionReport();
			}, exitInspectionReport, "");
		} else {
			showInspectionListing(); // changed by robert 01.22.2014 from exitInspectionReport();
		}
	});

	/*$$("img[name='edit']").each(function (edit){
		var id = edit.id;
		$(id).observe("click", function (){
			var textbox = $(id).previous("input", 0).id;
			var readonly = ($(textbox).getAttribute("readonly") == 'readonly');
			var charlimit = $(textbox).getAttribute("maxlength");
			showEditor(textbox, charlimit, readonly.toString());
		});
	});*/ // commented by: Nica 08.17.2012

	$("btnAddItem").observe("click", function (){
		if(checkAllRequiredFieldsInDiv("inspectionReportItemDiv")){
			var tsiAmt = nvl(unformatCurrency("tsiAmt"), 0);
			var premRt = nvl(unformatCurrency("premRt"), 0);
			
			if ($F("inspector") == ""){
				customShowMessageBox("Inspector must be entered.", imgMessage.ERROR, "inspector");
				return false;
			} else if ($F("txtIntmName") == ""){
				customShowMessageBox("Intermediary must be entered.", imgMessage.ERROR, "txtIntmName");
				return false;
			} /*else if ($F("txtAssuredName") == ""){
				customShowMessageBox("Assured must be entered.", imgMessage.ERROR, "txtAssuredName");
				return false;
			}*/else if ($F("assuredName") == ""){
				customShowMessageBox("Assured must be entered.", imgMessage.ERROR, "assuredName");
				return false;
			} else if ($F("itemNo2") == ""){
				customShowMessageBox("Item title is required.", imgMessage.ERROR, "itemNo2");
				return false;
			}else if (parseFloat(tsiAmt) > 9999999999999999.99){
				customShowMessageBox("Value must not be greater than 9,999,999,999,999,999.99", imgMessage.ERROR, "tsiAmt");
				return false;
			}else if (parseFloat(premRt) > 100.00 || parseFloat(premRt) < 0){
				customShowMessageBox("Value must be between 0 and 100.", imgMessage.ERROR, "premRt");
				return false;
			} else {
				Effect.Appear("inspItemInfoContainer", {
					duration: .001
				});
				if ($F("itemNo") == ""){
					$("itemNo").value = generateItemNo();
					$("itemNo2").focus();
					proceedItemSaving();
				} else {
					proceedItemSaving();
				}
				itemNoField();
			}
			if ($F("tariffZn") == "null"){
				$("tariffZn").value == "";
			}
			if ($F("tariffCd") == "null"){
				$("tariffCd").value == "";
			}
		}
	});

	function generateItemNo(){ //edited by steven 12/11/2012
		var exist = true;
		var itemNoTemp = 1;
		var itemNoArray = [];
		$$("div[name='inspItemInfo']").each(function (row){
			var newObj = new Object();
			newObj.itemNo = row.getAttribute("itemno");
			itemNoArray.push(newObj);
		});
		if (itemNoArray.length > 0) {
			for ( var i = 1; i < 1000000000; i++) {
				if (exist) {
					for ( var j = 0; j < itemNoArray.length; j++) {
						if (itemNoArray[j].itemNo == i) {
							exist = true;
							break;
						}else{
							itemNoTemp = i;
							exist = false;
						}
					}
				}else{
					break;
				}
			}
		}
		return lpad(itemNoTemp, 10, 0); //edited by steven 12/10/2012 newItemNo.toPaddedString(10);
	}
	objUW.hidObjGIPIS197.generateItemNo = generateItemNo;

	function addNewItemRow(tag){
		var itemInfoObj = prepareNewItem();
		if ($F("inspNo") == ""){
			$("inspNo").value = itemInfoObj.inspNo;
		}
		
		var newRow = new Element("div");
		newRow.setAttribute("id", "inspItemInfo"+itemInfoObj.inspNo+itemInfoObj.itemNo);
		newRow.setAttribute("name", "inspItemInfo");
		newRow.setAttribute("class", "tableRow");
		newRow.setAttribute("inspNo", itemInfoObj.inspNo);
		newRow.setAttribute("itemNo", itemInfoObj.itemNo);
		newRow.setAttribute("recordStatus", 1);
		newRow.setAttribute("status", $("approvedTag").checked ? "A" : "N");
		content = fillInspItemInfo(itemInfoObj);
		newRow.update(content);
		if (tag == "A"){
			inspectionReportObj.addedItems.push(itemInfoObj);
			$("inspItemInfoContainer").insert(newRow);
		} else {
			var selectedRowId;
			var selectedInspNo;
			var selectedItemNo;
			var isReplaced = false;
			$$("div[name='inspItemInfo']").each(function (row){
				if (row.hasClassName("selectedRow")){
					selectedRowId = row.id;
					selectedInspNo = row.getAttribute("inspNo");
					selectedItemNo = row.getAttribute("itemNo");
				}
			});
			for (var i = 0; i < inspectionReportObj.addedItems.length; i++){
				var obj = inspectionReportObj.addedItems[i];
				if (obj.inspNo == selectedInspNo && obj.itemNo == selectedItemNo){
					inspectionReportObj.addedItems.splice(i, 1, itemInfoObj);
					isReplaced = true;
				}
			}
			if (!isReplaced){
				inspectionReportObj.addedItems.push(itemInfoObj);
			}
			$(selectedRowId).insert({after : newRow});
			$(selectedRowId).remove();
		}
		checkIfToResizeTable("inspItemInfoContainer", "inspItemInfo");
		clearInspItemInformation();

		putRowObserver(newRow, itemInfoObj);
	}

	function fetchBlockId(provCd, cityCd, distNo, blkNo){
		var blockId;
		new Ajax.Request(contextPath+"/GIPIInspectionReportController?",{
			method: "GET",
			parameters: {
				action: "getBlockId",
				provinceCd: nvl(provCd, ''),
				cityCd: nvl(cityCd, ''),
				districtNo: nvl(distNo, ''),
				blockNo: nvl(blkNo, '')
			},
			evalScripts: true,
			asynchronous: false,
			onSuccess: function (response){
				if (checkErrorOnResponse(response)){
					blockId = response.responseText;
				}
			}
		});

		return blockId;
	}
	
	function showAttachMedia(uploadMode) {  // added by steven 7.13.2012
		/* try{
			objUW.hidObjGIPIS197.id = getGenericId(uploadMode);
			objUW.hidObjGIPIS197.itemNo = $F("itemNo");
			overlayAttachedMedia = Overlay.show(contextPath+"/GIPIInspectionReportAttachedMediaController?action=showAttachMedia&ajax=1&genericId=" + objUW.hidObjGIPIS197.id + "&itemNo=" + objUW.hidObjGIPIS197.itemNo, 
					{urlContent: true,
					 title: "Attach/View Pictures or Videos",
					 height: 370,
					 width: 600,
					 draggable: false
					});
		}catch(e){
			showErrorMessage("showAttachMedia",e);
		} */
		objUW.hidObjGIPIS197.id = getGenericId(uploadMode);
		
		openAttachMediaOverlay2("inspection", objUW.hidObjGIPIS197.id, $F("itemNo")); // SR-5931 JET FEB-21-2017
	}
	
	function prepareNewItemForDelete(){
		var itemInfoObj = new Object();
		itemInfoObj.inspNo = $F("inspNo");
		var itemNoTemp = ($("itemNo").value).replace(/^[0]+/g,"");// added by steven 12/11/2012 - ltrim of zero
		itemInfoObj.itemNo = parseInt(itemNoTemp);
		return itemInfoObj;
	}
	
	function prepareNewItem(){
		var itemInfoObj = new Object();
		//itemInfoObj.inspNo = parseInt(nvl($F("inspNo"), generateInspNo()));
		itemInfoObj.inspNo = $F("inspNo");
		itemInfoObj.inspCd = $F("inspectorCd");
		//itemInfoObj.assdNo = $F("txtAssdNo");
		//itemInfoObj.assdName = $F("txtAssuredName");
		itemInfoObj.assdNo = $F("assuredNo");
		itemInfoObj.assdName = $F("assuredName");
		itemInfoObj.intmNo = $F("txtIntmNo");
		itemInfoObj.dateInsp = $F("dateInspected"); 
		itemInfoObj.status = nvl($F("approvedTag"), "N"); 
		itemInfoObj.remarks = $F("remarks");
		
		var itemNoTemp = ($("itemNo").value).replace(/^[0]+/g,"");// added by steven 12/11/2012 - ltrim of zero
		itemInfoObj.itemNo = parseInt(itemNoTemp);
		itemInfoObj.itemTitle = $F("itemNo2");
		itemInfoObj.itemDesc = $F("propertyDesc");
		itemInfoObj.tsiAmt = unformatCurrency("tsiAmt");
		itemInfoObj.premRate = unformatCurrency("premRt");

		itemInfoObj.provinceCd = $F("provinceCd");
		itemInfoObj.province = $F("province");
		itemInfoObj.cityCd = $F("cityCd");
		itemInfoObj.city = $F("city");
		itemInfoObj.districtNo = $F("district");
		itemInfoObj.blockNo = $F("block");
		itemInfoObj.blockId = fetchBlockId($F("provinceCd"), $F("cityCd"), $F("district"), $F("block"));
		itemInfoObj.locRisk1 = $F("location");
		itemInfoObj.locRisk2 = $F("location2");
		itemInfoObj.locRisk3 = $F("location3");
		itemInfoObj.approvedBy = $F("approvedBy");

		itemInfoObj.eqZone = $F("eqZone");
		itemInfoObj.typhoonZone = $F("typhoonZone");
		itemInfoObj.floodZone = $F("floodZone");
		itemInfoObj.constructionCd = $F("construction");
		itemInfoObj.constructionRemarks = $F("constRmrk");
		itemInfoObj.occupancyCd = $F("occupancy");
		itemInfoObj.occupancyRemarks = $F("occRmrk");
		itemInfoObj.dateApproved = $F("dateApproved"); 
		
		itemInfoObj.tarfCd = $F("tariffCd");
		itemInfoObj.tariffZone = nvl($F("tariffZn"),"");
		itemInfoObj.front = $F("bndrFrnt");
		itemInfoObj.right = $F("right");
		itemInfoObj.left = $F("left");
		itemInfoObj.rear = $F("rear");
		/* Added by MarkS 02/09/2017 SR5919 */
		itemInfoObj.latitude = $F("txtLatitude");
		itemInfoObj.longitude = $F("txtLongitude");
		/* end SR5919 */
		
		//these properties are blank for now
		itemInfoObj.wcCd = "";
		itemInfoObj.parId = "";
		itemInfoObj.quoteId = "";
		itemInfoObj.itemGrp = 1;
		itemInfoObj.arcExtData = "";
		
		return itemInfoObj;
	}

	function putRowObserver(row, itemObj){
		loadRowMouseOverMouseOutObserver(row);
		
		inspectionReportObj.selectedItem = "";

		row.observe("click", function (){
			row.toggleClassName("selectedRow");
			if (row.hasClassName("selectedRow")){
				$$("div[name='inspItemInfo']").each(function (row2){
					if (row.id != row2.id){
						row2.removeClassName("selectedRow");
						clearInspItemInformation();
					}
				});
				//fillInspItemInformation2(itemObj.inspNo, itemObj.itemNo);
				if (row.getAttribute("status") == "C"){
					itemObject = inspectionReportObj.currentItems;
				} else {
					itemObject = inspectionReportObj.addedItems;
				}
				$("itemNo").readOnly = true; //added by steven 12/11/2012
				fillInspItemInformation(row.getAttribute("inspNo"), row.getAttribute("itemNo"), itemObject);
				$("btnAddItem").value = "Update";
				enableButton("btnDeleteItem");
				inspectionReportObj.selectedItem = row.getAttribute("itemNo");
			} else {
				clearInspItemInformation();
				$("itemNo").value = generateItemNo(); //added by steven 12/11/2012
				$("itemNo").readOnly = false; //added by steven 12/11/2012
				$("btnAddItem").value = "Add";
				disableButton($("btnDeleteItem"));
				inspectionReportObj.selectedItem = "";
			}
		});
	}
	var deletedItemObj = [];
	var clr = 0;
	$("btnDeleteItem").observe("click", function (){
		/* if ($F("inspNo") == ""){
			showMessageBox("Please select an inspection report to be deleted.", imgMessage.ERROR);
			return false;
		} else { */
			if ($F("inspNo") == "" ? true : checkParlistDependency($F("inspNo"))){
				//inspectionReportObj.deletedInspNo = $F("inspNo");
				//inspectionReportObj.deletedInspNo = $F("inspNo")				
			
				$$("div[name='inspItemInfo']").each(function (row){
					if(removeLeadingZero(row.down("label", 0).innerHTML) == removeLeadingZero($F("itemNo"))){
						/* var del = inspectionReportObj.deletedItems[clr];
						del.inspNo = $F("inspNo");
						del.itemNo = removeLeadingZero($F("itemNo")); */
						var deleteItemObj = prepareNewItem();
						//var deleteItemObj = prepareNewItemForDelete();
						$F("inspNo") == "" ? null : inspectionReportObj.deletedItems.push(deleteItemObj); 
						//deletedItemObj.push(removeLeadingZero($F("itemNo")));
						row.remove();						
					}
				});			
				//inspectionReportObj.deletedItemNo = deletedItemObj;	
				//$("inspNo").value = "";
				//$("inspectorCd").value = "";
				//$("inspector").value = "";
				//$("txtAssdNo").value = "";
				//$("txtDrvAssuredName").value = "";
				//$("txtAssuredName").value = "";
				//proceedItemSaving();
				//$("assuredNo").value = "";
				//$("assuredName").value = "";
				//$("txtIntmNo").value = "";
				//$("txtDrvIntmName").value = "";
				//$("txtIntmName").value = "";
				clearInspItemInformation();
				checkTableIfEmpty("inspItemInfo", "inspItemInfoContainer");
				disableButton("btnDeleteItem");
				enableButton("btnAddItem");
				itemNoField();
			}
			clr+=1;
		//}
	});

	$("searchProvince").observe("click", function (){
		//showCity("province");
		showProvinceLOV();
	});
	
	$("searchCity").observe("click", function(){
		//showCity("city");
		showCityLOV();
	});	

	$("searchDistrict").observe("click", function(){
		//showBlock("district");
		showDistrictBlock($F("regionCd"),$F("provinceCd"),$F("cityCd"),$F("districtNo"));
	});	

	$("searchBlock").observe("click", function(){
		//showBlock("block");
		showDistrictBlock($F("regionCd"),$F("provinceCd"),$F("cityCd"),$F("districtNo"));
	});	

	$("itemNo").observe("click", function (){
		if ($F("itemNo") == ""){
			$("itemNo").value = generateItemNo();
			$("itemNo2").focus();
		}
	});   
	
 	function itemNoField(){
		if ($F("itemNo") == ""){
			var itemNo = generateItemNo();
			$("itemNo").value = itemNo;
			$("itemNo2").focus();
		}
	}
	
	$("tsiAmt").observe("change", function (){
		var entered = $F("tsiAmt");
		if (isNaN(entered)){
			customShowMessageBox("Field must be of form 9,999,999,999,999,999.99", imgMessage.ERROR, "tsiAmt");
			this.clear();
			return false;
		} else if (parseFloat(entered) > 9999999999999999.99){
			customShowMessageBox("Value must not be greater than 9,999,999,999,999,999.99", imgMessage.ERROR, "tsiAmt");
			this.clear();
			return false;
		} else {
			$("tsiAmt").value = formatCurrency(entered);
		}
	});

	$("premRt").observe("change", function (){
		var entered = $F("premRt");
		if (isNaN(entered)){
			customShowMessageBox("Field must be of form 9,999,999,999,999,999.99", imgMessage.ERROR, "premRt");
			this.clear();
			return false;
		} else if (parseFloat(entered) > 100.00 || parseFloat(entered) < 0){
			customShowMessageBox("Value must be between 0 and 100.", imgMessage.ERROR, "premRt");
			this.clear();
			return false;
		} else {
			$("premRt").value = formatToNineDecimal(entered);
		}
	});

	$("btnWarrantyClause").observe("click", function (){
		if ($F("inspNo") == ""){
			showMessageBox("Please save Inspection Information.", imgMessage.INFO);
			return false;
		} else {
			if (changeTag == 0){
				openWarrantyAndClauseModal($F("inspNo"));
			} else {
				showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
			}
		}
	});
	
	$("btnAttachViewPic").observe("click", function (){
		var selected = false;
		$$("div[name='inspItemInfo']").each(function (row){
			if (row.hasClassName("selectedRow")){
				selected = true;
// 				  openAttachMediaModal("inspection");
			}
		});
		if(!selected){	//added by steven 7.17.2012
			showMessageBox("Please select an item information", imgMessage.INFO);
		}else{
			if(changeTag == 1 || inspDataChangeTag == 1){ // lara 10-3-2013
				showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
			}else{
				showAttachMedia("inspection");
			}
			
		}
		
	});
    //dito siya nag aadd ng record nung  Inspection Information block.
	function updateInspData1(){
		for (var j = 0; j < inspectionReportObj.currentItems.length; j++){
			var exist = false;
			var object = inspectionReportObj.currentItems[j];
			for (var k = 0; k < inspectionReportObj.addedItems.length; k++){
				if(object.itemNo == inspectionReportObj.addedItems[k].itemNo){
					exist = true;
				}
			}
			if (!exist){
				inspectionReportObj.addedItems.push(object);
			}
		}
		for (var i = 0; i < inspectionReportObj.addedItems.length; i++){
			var object = inspectionReportObj.addedItems[i];
			object.inspNo = $F("inspNo");
			object.inspCd = $F("inspectorCd");
			object.assdNo = $F("assuredNo");
			object.assdName = $F("assuredName");
			object.intmNo = $F("txtIntmNo");
			object.remarks = escapeHTML2($F("remarks"));
			//object.strDateInsp = $F("dateInspected"); //object.dateInsp before - modified by christian 08.23.2012
			object.dateInsp = $F("dateInspected"); 
			object.status = $("approvedTag").checked ? "A" : "N"; 
			//object.strDateApproved = (object.strDateApproved == "" || object.strDateApproved == null) ? "" : dateFormat(object.strDateApproved, "mm-dd-yyyy");
			object.dateApproved = (nvl(object.dateApproved, "") == "") ? "" : dateFormat(object.dateApproved, "mm-dd-yyyy");
		}
		inspDataChangeTag = 0;
	}
	
	function checkIfItemNoExist(itemNo) { //added by steven 12/10/2012 
		var exist = false;
		var itemNoTemp = null;
		$$("div[name='inspItemInfo']").each(function (row){
			itemNoTemp = parseInt(row.getAttribute("itemno"));
			if (itemNoTemp === itemNo){
				exist = true;
				return exist;
			}
		});
		return exist;
	}

	$("btnSave").observe("click", function (){
		if(checkAllRequiredFieldsInDiv("inspectionReportHeaderDiv") && checkInspItem()){ //marco - 08.28.2012 - prevent saving without date inspected
			if(changeTag == 0){
				showMessageBox(objCommonMessage.NO_CHANGES, "I");
			}else{
				if(($F("inspNo")== "") && (inspectionReportObj.addedItems.length != 0)){ //modified by: Nica 06.18.2012 -> added inspectionReportObj field condition - Wilmar 10.08.2015											  
					$("inspNo").value = parseInt(generateInspNo());
				}
				if (inspDataChangeTag == 1){
					updateInspData1();
				}
				for (var i = 0; i < inspectionReportObj.addedItems.length; i++){
					inspectionReportObj.addedItems[i].status = $("approvedTag").checked ? "A" : "N";
				}
				inspectionReportObj.addedItems2 = [];
				//inspectionReportObj.addedItems2 = inspectionReportObj.addedItems;
				
				$$("div[name='inspItemInfo']").each(function (row){
					if(row.getAttribute("recordStatus") == 1){
						for (var i = 0; i < inspectionReportObj.addedItems.length; i++){
							if (row.getAttribute("itemNo") == inspectionReportObj.addedItems[i].itemNo){
								inspectionReportObj.addedItems2.push(inspectionReportObj.addedItems[i]);
							}
						}
					}
				});
				inspectionReportObj.addedItems = inspectionReportObj.addedItems2;
				new Ajax.Request(contextPath+"/GIPIInspectionReportController",{
					method: "POST",
					parameters: {
						action: "saveInspectionInformation",
						inspNo: $F("inspNo"),
						assdNo: $F("assuredNo"),
						assdName: $F("assuredName"),
						intmNo: $F("txtIntmNo"), 
						inspCd: $F("inspectorCd"),
						remarks:escapeHTML2($F("remarks")),
						status : $("approvedTag").checked ? "A" : "N"
					},
					asynchronous: true,
					evalScripts: true,
					onCreate: function (){
						showNotice("Saving inspection report. Please wait...");
					},
					onComplete: function (response){
						hideNotice("");
						if (checkErrorOnResponse(response)){
							hideNotice(""); 
							saveInspectionReport();
						}
					}
				}); 
				
				
			}
		}
	});
	
	//marco - 08.28.2012 - check if inspection has items
	function checkInspItem(){
		if(nvl($("inspItemInfoContainer").down("div", 0), "") == ""){
			showMessageBox("Please enter item title.", "I");
			return false;
		}
		return true;
	}

	$("btnOtherDetails").observe("click", function (){
		if ($F("inspNo") == ""){
			showMessageBox("Inspection number is not yet generated.", imgMessage.ERROR);
			return false;
		} /* else if(!selected){
			showMessageBox("Please select an item number", imgMessage.INFO);
			return false;
		} */ else if(changeTag != 0){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		} else{
			Modalbox.show(contextPath+"/GIPIInspectionReportController?action=showOtherDetails&inspNo="+$F("inspNo")+"&itemNo="+$F("itemNo"), {
				title: "Other Details",
				width: 700,
				asynchronous:false
			});
		}
	});

	$("btnPrint").observe("click", function (){
		if ($F("inspNo") == ""){
			showMessageBox("Inspection number is not yet generated.", imgMessage.ERROR);
			return false;
		} else {
			printInspectionReport($F("inspNo"));
		}
	});
	
	//itemNoField();
	
	/*
	function fillInspItemInformation2(inspNo, itemNo){
		var selectedObj;
		for (var i = 0; i < inspectionReportObj.addedItems.length; i++){
			itemInfoList = inspectionReportObj.addedItems[i];
			if (itemInfoList.inspNo == inspNo &&
				itemInfoList.itemNo == itemNo){
				selectedObj = itemInfoList;
			}
		}

		fillItemInfoUsingObject(selectedObj);
	}*/
	
	
	$("editConstRmrk").observe("click", function () {
		var readOnly = ($("approvedTag").checked) ? 'true' : 'false';
		showEditor("constRmrk", 2000, readOnly);
	});
	$("editBndrFrnt").observe("click", function () {
		var readOnly = ($("approvedTag").checked) ? 'true' : 'false';
		showEditor("bndrFrnt", 2000, readOnly);
	});
	$("editOccRmrk").observe("click", function () {
		var readOnly = ($("approvedTag").checked) ? 'true' : 'false';
		showEditor("occRmrk", 2000, readOnly);
	});
	$("editRight").observe("click", function () {
		var readOnly = ($("approvedTag").checked) ? 'true' : 'false';
		showEditor("right", 2000, readOnly);
	});
	$("editLeft").observe("click", function () {
		var readOnly = ($("approvedTag").checked) ? 'true' : 'false';
		showEditor("left", 2000, readOnly);
	});
	$("editRear").observe("click", function () {
		var readOnly = ($("approvedTag").checked) ? 'true' : 'false';
		showEditor("rear", 2000, readOnly);
	});
// 	$("editRemarks").observe("click", function () {
// 		if($("approvedTag").checked){
// 			showEditor("remarks", 2000, 'true');
// 		}else{
// 			showEditor("remarks", 2000);
// 		}
// 	});move by steven 9.19.2013
</script>