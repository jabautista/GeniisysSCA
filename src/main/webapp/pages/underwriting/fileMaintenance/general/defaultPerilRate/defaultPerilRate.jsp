<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss106MainDiv" name="giiss106MainDiv" style="">
	<div id="tariffRatesDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="tariffRatesExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Default Peril Rate Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	
	<input id="varMc" type="hidden" value="${varMc }"/>
	<input id="varFi" type="hidden" value="${varFi }"/>
	
	<div id="giiss106" name="giiss106">		
		<div class="sectionDiv">			
			<div id="tariffRatesHdrTableDiv" style="padding-top: 10px;">
				<div id="tariffRatesHdrTable" style="height: 240px; margin-left: 10px;"></div>
			</div>
			
			<div style="" align="center" id="tariffRatesHdrFormDiv">
				<table cellspacing="2" border="0" style="margin: 10px 10px 10px 10px;">	 
				    <!--lbeltran SR3955 090415  -->
				   <!--  <tr>   
				        <td class="rightAligned" style="" id="">Tariff Cd</td>
				    	<td class="leftAligned" colspan="3">
							<input id="txtTariffCd" name="txtTariffCd"  type="text" style="width: 94px; text-align: right;" value="" tabindex="100" readonly="readonly"/>
						</td>
				    </tr>		 -->
					<tr>
						<input id="hidTariffCd" type="hidden"/>
						<td class="rightAligned" style="" id="">Line</td>
						<td class="leftAligned">
							<span class="lovSpan required" style="float: left; width: 100px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="required allCaps" type="text" id="txtLineCd" name="txtLineCd" style="width: 75px; float: left; border: none; height: 15px; margin: 0;" maxlength="2" tabindex="101" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineLOV" name="searchLineLOV" alt="Go" style="float: right;" tabindex="102"/>
							</span>
							<input id="txtLineName" name="txtLineName" type="text" class="required" style="width: 250px;" value="" readonly="readonly" tabindex="103"/>
						</td>	
						<td class="rightAligned" style="padding-left: 7px;" id="">Subline Type</td>
						<td class="leftAligned">
							<span id="sublineTypeSpan" class="lovSpan required" style="float: left; width: 100px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="required allCaps" type="text" id="txtSublineTypeCd" name="mcField" style="width: 75px; float: left; border: none; height: 15px; margin: 0;" maxlength="3" tabindex="113" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchSublineTypeLOV" name="mcField" alt="Go" style="float: right;" tabindex="114"/>
							</span>
							<input id="txtSublineTypeDesc" name="mcField" type="text" class="required" style="width: 250px;" value="" readonly="readonly" tabindex="115"/>
						</td>	
					</tr>
					<tr>
						<td class="rightAligned" >Subline</td>
						<td class="leftAligned">
							<span class="lovSpan required" style="float: left; width: 100px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="required allCaps" type="text" id="txtSublineCd" name="txtSublineCd" style="width: 75px; float: left; border: none; height: 15px; margin: 0;" maxlength="7" tabindex="104" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchSublineLOV" name="searchSublineLOV" alt="Go" style="float: right;" tabindex="105"/>
							</span>
							<input id="txtSublineName" name="txtSublineName" class="required" type="text" style="width: 250px;" value="" readonly="readonly" tabindex="106"/>
						</td>		
						<td class="rightAligned" style="" id="">Motortype</td>
						<td class="leftAligned">
							<span id="motortypeSpan" class="lovSpan required" style="float: left; width: 100px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="required integerNoNegativeUnformattedNoComma rightAligned" type="text" id="txtMotortypeCd" name="mcField" style="width: 75px; float: left; border: none; height: 15px; margin: 0;" maxlength="2" tabindex="116" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchMotortypeLOV" name="mcField" alt="Go" style="float: right;" tabindex="117"/>
							</span>
							<input id="txtMotortypeDesc" name="mcField" type="text" class="required" style="width: 250px;" value="" readonly="readonly" tabindex="118"/>
						</td>				
					</tr>
					<tr>
						<td class="rightAligned" >Peril</td>
						<td class="leftAligned">
							<span class="lovSpan required" style="float: left; width: 100px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="required integerNoNegativeUnformattedNoComma rightAligned" type="text" id="txtPerilCd" name="txtPerilCd" style="width: 75px; float: left; border: none; height: 15px; margin: 0;" maxlength="5" tabindex="107" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchPerilLOV" name="searchPerilLOV" alt="Go" style="float: right;" tabindex="108"/>
							</span>
							<input id="txtPerilName" name="txtPerilName" class="required" type="text" style="width: 250px;" value="" readonly="readonly" tabindex="109"/>
						</td>		
						<td class="rightAligned" style="" id="">Tariff Code</td>
						<td class="leftAligned">
							<span id="tarfSpan" class="lovSpan required" style="float: left; width: 100px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="required allCaps" type="text" id="txtTarfCd" name="fiField" style="width: 75px; float: left; border: none; height: 15px; margin: 0;" maxlength="12" tabindex="119" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchTarfLOV" name="fiField" alt="Go" style="float: right;" tabindex="120"/>
							</span>
							<input id="txtTarfDesc" name="fiField" type="text" class="required" style="width: 250px;" value="" readonly="readonly" tabindex="121"/>
						</td>				
					</tr>
					<tr>
						<td class="rightAligned" >Tariff Zone</td>
						<td class="leftAligned">
							<span id="tariffZoneSpan" class="lovSpan" style="float: left; width: 100px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="required allCaps" type="text" id="txtTariffZone" name="txtTariffZone" style="width: 75px; float: left; border: none; height: 15px; margin: 0;" maxlength="2" tabindex="110" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchTariffZoneLOV" name="searchTariffZoneLOV" alt="Go" style="float: right;" tabindex="111"/>
							</span>
							<input id="txtTariffZoneDesc" name="txtTariffZoneDesc" class="" type="text" style="width: 250px;" value="" readonly="readonly" tabindex="112"/>
						</td>		
						<td class="rightAligned" style="" id="">Construction</td>
						<td class="leftAligned">
							<span id="constructionSpan" class="lovSpan required" style="float: left; width: 100px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="required allCaps" type="text" id="txtConstructionCd" name="fiField" style="width: 75px; float: left; border: none; height: 15px; margin: 0;" maxlength="2" tabindex="122" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchConstructionLOV" name="fiField" alt="Go" style="float: right;" tabindex="123"/>
							</span>
							<input id="txtConstructionDesc" name="fiField" type="text" class="required" style="width: 250px;" value="" readonly="readonly" tabindex="124"/>
						</td>				
					</tr>					
					<tr>
						<td class="rightAligned" >Coverage</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan " style="float: left; width: 100px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="integerNoNegativeUnformattedNoComma rightAligned" type="text" id="txtCoverageCd" name="txtCoverageCd" style="width: 75px; float: left; border: none; height: 15px; margin: 0;" maxlength="5" tabindex="125" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchCoverageLOV" name="searchCoverageLOV" alt="Go" style="float: right;" tabindex="126"/>
							</span>
							<input id="txtCoverageDesc" name="txtCoverageDesc" type="text" style="width: 707px;" value="" readonly="readonly" tabindex="127"/>
						</td>			
					</tr>
					<tr>
						<td class="rightAligned" >Remarks</td>
						<td class="leftAligned">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 363px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 337px; margin-top: 0; border: none;" id="txtRemarksHdr" name="txtRemarksHdr" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="128"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"/>
							</div>
						</td>
						<td class="rightAligned" colspan="2">
							<table style="border: solid 1px; padding: 5px; margin-left: 40px;">
								<tr>
									<td>
										<input id="fixedSIRB" name="defaultPremTagRG" type="radio" value="1" style="float: left; margin: 8px 7px 0 5px;">
										<label for="fixedSIRB" style="float: left; margin: 7px 0 5px 0;">Fixed Sum Insured</label>
									</td>
									<td>
										<input id="withCompRB" name="defaultPremTagRG" type="radio" value="2" checked="checked" style="float: left; margin: 8px 7px 0 12px;">
										<label for="withCompRB" style="float: left; margin: 7px 0 5px 0;">With Computation</label>
									</td>
									<td>
										<input id="fixedPremiumRB" name="defaultPremTagRG" type="radio" value="3" style="float: left; margin: 8px 7px 0 12px;">
										<label for="fixedPremiumRB" style="float: left; margin: 7px 0 5px 0;">Fixed Premium</label>
									</td>
								</tr>
							</table>
						</td>				
					</tr>	
				</table>			
			</div>					
			<div style="margin: 0 0 10px 0;" class="buttonsDiv">
				<input type="button" class="button" id="btnAddHdr" value="Add" tabindex="128">
				<input type="button" class="button" id="btnDeleteHdr" value="Delete" tabindex="129">
			</div>
		</div>
		
		<div id="tariffRatesDtlFormDiv" class="sectionDiv">
			<div id="fixedSIDiv">
				<div id="tariffRatesFixedSITableDiv" style="padding-top: 10px;">
					<div id="tariffRatesFixedSITable" style="height: 210px; margin: 0 0 10px 150px;"></div>
				</div>
				
				<div>
					<table align="left" style="width: 750px; margin: 10px 0 0 67px;">
						<tr>
							<td class="rightAligned">Fixed Sum Insured</td>
							<td class="leftAligned"><input id="txtFixedSI" name="dtlField" type="text" class="required money4 rdoOption" style="width: 200px; text-align: right;" tabindex="201" maxlength="17" errorMsg = "Invalid Fixed Sum Insured. Valid value should be from 0.10 to 99,999,999,999,999.99." min="0.10" max="99999999999999.99"></td>
							<td class="rightAligned">Fixed Premium</td>
							<td class="leftAligned"><input id="txtFixedPremium1" name="dtlField" type="text" style="width: 200px; text-align: right;" tabindex="202" maxlength="13" class="money4 rdoOption" errorMsg = "Invalid Fixed Premium. Valid value should be from 0.10 to 9,999,999,999.99." min="0.10" max="9999999999.99"></td>							
						</tr>
						<tr>
							<td class="rightAligned">Highest Limit</td>
							<td class="leftAligned"><input id="txtHigherRange" name="dtlField" type="text" style="width: 200px; text-align: right;" tabindex="203" maxlength="17" class="money4 rdoOption" errorMsg = "Invalid Higher Range. Valid value should be from 0.10 to 99,999,999,999,999.99." min="0.10" max="99999999999999.99"></td>
							<td class="rightAligned">Lowest Limit</td>
							<td class="leftAligned"><input id="txtLowerRange" name="dtlField" type="text"  style="width: 200px; text-align: right;" tabindex="204" maxlength="17" class="money4 rdoOption" errorMsg = "Invalid Lower Range. Valid value should be from 0.10 to 99,999,999,999,999.99." min="0.10" max="99999999999999.99"></td>							
						</tr>	
					</table>
				</div>
			</div>
			
			<div id="withCompDiv" style="padding-top: 10px;">
				<table align="left" style="width: 750px; margin-left: 45px;">
					<tr>
						<td class="rightAligned">Fixed Premium</td>
						<td class="leftAligned"><input id="txtFixedPremium2" type="text" style="width: 200px; text-align: right;" tabindex="201" maxlength="13" class="money4 rdoOption" errorMsg = "Invalid Fixed Premium. Valid value should be from 0.00 to 9,999,999,999.99." min="0" max="9999999999.99"></td>							
						<td class="rightAligned">Discount Rate</td>
						<td class="leftAligned"><input id="txtDiscountRate" type="text" style="width: 200px; text-align: right;" tabindex="202" maxlength="13" class="nthDecimal2 rdoOption" errorMsg = "Invalid Discount Rate. Valid value should be from 0.00 to 999.999999999." min="0" max="999.999999999"></td>
					</tr>
					<tr>
						<td class="rightAligned">Sum Insured Deductible</td>
						<td class="leftAligned"><input id="txtSIDeductible" type="text" style="width: 200px; text-align: right;" tabindex="203" maxlength="17" class="money4 rdoOption" errorMsg = "Invalid Sum Insured Deductible. Valid value should be from 0.00 to 99,999,999,999,999.99." min="0" max="99999999999999.99"></td>
						<td class="rightAligned">Additional Premium</td>
						<td class="leftAligned"><input id="txtAdditionalPremium" type="text" style="width: 200px; text-align: right;" tabindex="204" maxlength="13" class="money4 rdoOption" errorMsg = "Invalid Additional Premium. Valid value should be from 0.00 to 9,999,999,999.99." min="0" max="9999999999.99"></td>							
					</tr>
					<tr>
						<td class="rightAligned">Excess Rate</td>
						<td class="leftAligned"><input id="txtExcessRate" type="text" style="width: 200px; text-align: right;" tabindex="205" maxlength="10" class="nthDecimal2 rdoOption" nthDecimal="6" errorMsg = "Invalid Excess Rate. Valid value should be from 0.00 to 999.999999." min="0" max="999.999999"></td>
						<td class="rightAligned">Tariff Rate</td>
						<td class="leftAligned"><input id="txtTariffRate" type="text" style="width: 200px; text-align: right;" tabindex="206" maxlength="10" class="nthDecimal2 rdoOption" nthDecimal="6" errorMsg = "Invalid Tariff Rate. Valid value should be from 0.00 to 999.999999." min="0" max="999.999999"></td>							
					</tr>
					<tr>
						<td class="rightAligned">Loading Rate</td>
						<td class="leftAligned"><input id="txtLoadingRate" type="text" style="width: 200px; text-align: right;" tabindex="207" maxlength="13" class="nthDecimal2 rdoOption" errorMsg = "Invalid Loading Rate. Valid value should be from 0.00 to 999.999999999." min="0" max="999.999999999"></td>				
					</tr>	
				</table>
			</div>
			
			<div id="fixedPremDiv" style="padding-top: 10px; width: 100%;" >
				<table align="center">
					<tr><td class="rightAligned">Fixed Premium</td>
						<td class="leftAligned"><input id="txtFixedPremium3" type="text" style="width: 200px; text-align: right;" tabindex="201" maxlength="13" class="money4 rdoOption required" errorMsg = "Invalid Fixed Premium. Valid value should be from 0.00 to 9,999,999,999.99." min="0" max="9999999999.99"></td>							
					</tr>
				</table>
			</div>
			
			<table align="center" style="width: 500px;">					
				<tr>
					<input id="hidTariffDtlCd" type="hidden"/>
					<td width="" class="rightAligned">Remarks</td>
					<td class="leftAligned" colspan="3">
						<div id="remarksDtlDiv" name="remarksDtlDiv" style="float: left; width: 567px; border: 1px solid gray; height: 22px;">
							<textarea style="float: left; height: 16px; width: 540px; margin-top: 0; border: none;" id="txtRemarksDtl" name="txtRemarksDtl" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="208"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarksDtl"  tabindex="209"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">User ID</td>
					<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="210"></td>
					<td width="" class="rightAligned" style="padding-left: 75px;">Last Update</td>
					<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="211"></td>
				</tr>			
			</table>	
			<div style="margin: 10px 0 10px 0;" class="buttonsDiv" id="buttonsFixedSIDiv">
				<input type="button" class="button" id="btnAddFixedSI" value="Add" tabindex="212">
				<input type="button" class="button" id="btnDeleteFixedSI" value="Delete" tabindex="213">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="212">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="213">
</div>
<script type="text/javascript">	
try{
	setModuleId("GIISS106");
	setDocumentTitle("Default Peril Rate Maintenance");
	var giiss106Array = {};
	changeTag = 0;
	var changeTagDtl = 0;
	var rowIndex = -1;
	var defaultPremTagRB = $F("withCompRB");
	initializeAllMoneyFields(); //added by steven 07.01.2014
	var origFixedSI = null;
	var origHigherRange = null;
	var origLowerRange = null;
	var origLineCd = null;
	var origSublineCd = null;
	var origPerilCd = null;
	var origSublineTypeCd = null;
	var origMotortypeCd = null;
	var origTarfCd = null;
	var origConstructionCd = null;
	var origTariffZone = null;
	var origCoverageCd = null;
	
	var dummyTariffCd = null;
	var dummyTariffDtlCd = null;
	
	function saveGiiss106(){
		if(changeTag == 0 && changeTagDtl == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		
		if (rowIndex != -1 && (defaultPremTagRB == 3 && $F("txtFixedPremium3") == "") ){
			showWaitingMessageBox(objCommonMessage.REQUIRED, "I", function(){
				$("txtFixedPremium3").focus();
			});
			return;
		}
		
		var setRows = getAddedAndModifiedJSONObjects(tbgTariffRatesHdr.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgTariffRatesHdr.geniisysRows);
		
		var setDtlRows = [];
		var delDtlRows = [];
		
		if (rowIndex != -1 && changeTagDtl == 1){
			if (defaultPremTagRB == 1){
				setDtlRows = getAddedAndModifiedJSONObjects(tbgTariffRatesFixedSI.geniisysRows);
				delDtlRows = getDeletedJSONObjects(tbgTariffRatesFixedSI.geniisysRows);
			}
		}			
		
		new Ajax.Request(contextPath+"/GIISTariffRatesHdrController", {
			method: "POST",
			parameters : {action : "saveGiiss106",
						  params : JSON.stringify(giiss106Array),
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows),
					 	  setDtlRows : prepareJsonAsParameter(setDtlRows),
					 	  delDtlRows : prepareJsonAsParameter(delDtlRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS106.afterSave != null) {
							objGIISS106.afterSave();
							objGIISS106.afterSave = null;
						} else {
							tbgTariffRatesHdr._refreshList();
						}
					});
					changeTag = 0;
					changeTagDtl = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiiss106);
	
	var objGIISS106 = {};
	var objTariffRatesHdr = null;
	var objAllRecord = [];
	objGIISS106.tariffRatesHdrList = JSON.parse('${jsonDefaultPerilRate}');
	objGIISS106.afterSave = null;
	
	var tariffRatesHdrTable = {
			url : contextPath + "/GIISTariffRatesHdrController?action=showGiiss106&refresh=1&moduleId=GIISS106",
			options : {
				width : '900px',
				hideColumnChildTitle: true,
				pager : {},
				beforeClick: function(){
					if(changeTagDtl == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
				},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objTariffRatesHdr = tbgTariffRatesHdr.geniisysRows[y];
					setHdrFieldValues(objTariffRatesHdr);
					toggleTariffRatesDtlFields(true);
					tbgTariffRatesHdr.keys.removeFocus(tbgTariffRatesHdr.keys._nCurrentFocus, true);
					tbgTariffRatesHdr.keys.releaseKeys();
					$("txtLineCd").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setHdrFieldValues(null);
					toggleTariffRatesDtlFields(false);
					tbgTariffRatesHdr.keys.removeFocus(tbgTariffRatesHdr.keys._nCurrentFocus, true);
					tbgTariffRatesHdr.keys.releaseKeys();
					$("txtLineCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setHdrFieldValues(null);
						tbgTariffRatesHdr.keys.removeFocus(tbgTariffRatesHdr.keys._nCurrentFocus, true);
						tbgTariffRatesHdr.keys.releaseKeys();
					}
				},
				beforeSort : function(){
					if(changeTag == 1 || changeTagDtl == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
				},
				onSort: function(){
					rowIndex = -1;
					setHdrFieldValues(null);
					tbgTariffRatesHdr.keys.removeFocus(tbgTariffRatesHdr.keys._nCurrentFocus, true);
					tbgTariffRatesHdr.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setHdrFieldValues(null);
					tbgTariffRatesHdr.keys.removeFocus(tbgTariffRatesHdr.keys._nCurrentFocus, true);
					tbgTariffRatesHdr.keys.releaseKeys();
				},				
				prePager: function(){
					if(changeTag == 1 || changeTagDtl == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
					rowIndex = -1;
					setHdrFieldValues(null);
					tbgTariffRatesHdr.keys.removeFocus(tbgTariffRatesHdr.keys._nCurrentFocus, true);
					tbgTariffRatesHdr.keys.releaseKeys();
				},
				checkChanges: function(){
					return (changeTag == 1  || changeTagDtl == 1? true : false);
				},
				masterDetailRequireSaving: function(){
					return (changeTag == 1  || changeTagDtl == 1? true : false);
				},
				masterDetailValidation: function(){
					return (changeTag == 1  || changeTagDtl == 1? true : false);
				},
				masterDetail: function(){
					return (changeTag == 1  || changeTagDtl == 1? true : false);
				},
				masterDetailSaveFunc: function() {
					return (changeTag == 1  || changeTagDtl == 1? true : false);
				},
				masterDetailNoFunc: function(){
					return (changeTag == 1  || changeTagDtl == 1? true : false);
				}
			},
			columnModel : [
				{ 								// this column will only use for deletion
				    id: 'recordStatus', 		// 'id' should be 'recordStatus' to disregard the some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
				    width: '0',				    
				    visible : false			
				},
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},
				/* {						//lbeltran SR3955 090415
					id : 'tariffCd',
					title : 'Tariff Cd',
					titleAlign : 'right',
					align : 'right',
					width : '60px',
					
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},*/ 
				{
					id : "lineCd lineName",
					title: "Line",
					children: [
						{
							id: "lineCd",
							title: "Line Cd",
							width: 40,
							filterOption: true
						},
						{
							id: "lineName",
							title: "Line Name",
							width: 110,
							filterOption: true
						}
		            ]
				},	
				{
					id : "sublineCd sublineName",
					title: "Subline",
					children: [
						{
							id: "sublineCd",
							title: "Subline Cd",
							width: 40,
							filterOption: true
						},
						{
							id: "sublineName",
							title: "Subline Name",
							width: 150,
							filterOption: true
						}
		            ]
				},	
				{
					id : "perilCd perilName",
					title: "Peril",
					children: [
						{
							id: "perilCd",
							title: "Peril Cd",
							width: 40,
							align : 'right',
							filterOption: true,
							filterOptionType: 'integerNoNegative'
						},
						{
							id: "perilName",
							title: "Peril Name",
							width: 160,
							filterOption: true
						}
		            ]
				},	
				{
					id : "coverageCd coverageDesc",
					title: "Coverage",
					children: [
						{
							id: "coverageCd",
							title: "Coverage Cd",
							width: 51,
						    align: 'right',
							filterOption: true,
							filterOptionType: 'integerNoNegative'
						},
						{
							id: "coverageDesc",
							title: "Coverage Desc",
							width: 175,
							filterOption: true
						}
		            ]
				},	
				{
					id : 'sublineTypeCd',
					width : '0',
					visible: false				
				},
				{
					id : 'sublineTypeDesc',
					width : '0',
					visible: false
				},
				{
					id : 'motortypeCd',
					width : '0',
					visible: false				
				},
				{
					id : 'motortypeDesc',
					width : '0',
					visible: false
				},
				{
					id : 'tarfCd',
					width : '0',
					visible: false				
				},
				{
					id : 'tarfDesc',
					width : '0',
					visible: false
				},
				{
					id : 'constructionCd',
					width : '0',
					visible: false				
				},
				{
					id : 'constructionDesc',
					width : '0',
					visible: false
				},
				{
					id : 'tariffZone',
					width : '0',
					visible: false				
				},
				{
					id : 'tariffZoneDesc',
					width : '0',
					visible: false
				},
				{
					id : 'tariffCd',
					width : '0',
					visible: false				
				},
				{
					id : 'defaultPremTag',
					width : '0',
					visible: false
				},
				{
					id : 'remarks',
					width : '0',
					visible: false				
				},
				{
					id : 'userId',
					width : '0',
					visible: false
				},
				{
					id : 'lastUpdate',
					width : '0',
					visible: false				
				}
			],
			rows : objGIISS106.tariffRatesHdrList.rows
		};

		tbgTariffRatesHdr = new MyTableGrid(tariffRatesHdrTable);
		tbgTariffRatesHdr.pager = objGIISS106.tariffRatesHdrList;
		tbgTariffRatesHdr.render("tariffRatesHdrTable");
		tbgTariffRatesHdr.afterRender = function () {
			giiss106Array.tariffRatesHdr = tbgTariffRatesHdr.geniisysRows;
			objAllRecord = getAllRecord();
		};
	
	function setHdrFieldValues(rec){
		try{
			//$("txtTariffCd").value = (rec == null ? "" : rec.tariffCd);  //lbeltran 3955 090415 
			$("hidTariffCd").value = (rec == null ? "" : rec.tariffCd);
			$("txtLineCd").value = (rec == null ? "" : unescapeHTML2(rec.lineCd));
			$("txtLineCd").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.lineCd)) );
			$("txtLineName").value = (rec == null ? "" : unescapeHTML2(rec.lineName));
			$("txtSublineCd").value = (rec == null ? "" : unescapeHTML2(rec.sublineCd));
			$("txtSublineCd").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.sublineCd)) );
			$("txtSublineName").value = (rec == null ? "" : unescapeHTML2(rec.sublineName));
			$("txtPerilCd").value = (rec == null ? "" : rec.perilCd);
			$("txtPerilCd").setAttribute("lastValidValue", (rec == null ? "" : rec.perilCd) );
			$("txtPerilName").value = (rec == null ? "" : unescapeHTML2(rec.perilName));
			$("txtCoverageCd").value = (rec == null ? "" : rec.coverageCd);
			$("txtCoverageCd").setAttribute("lastValidValue", (rec == null ? "" : rec.coverageCd) );
			$("txtCoverageDesc").value = (rec == null ? "" : unescapeHTML2(rec.coverageDesc));
			$("txtSublineTypeCd").value = (rec == null ? "" : unescapeHTML2(rec.sublineTypeCd));
			$("txtSublineTypeCd").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.sublineTypeCd)) );
			$("txtSublineTypeDesc").value = (rec == null ? "" : unescapeHTML2(rec.sublineTypeDesc));
			$("txtMotortypeCd").value = (rec == null ? "" : rec.motortypeCd);
			$("txtMotortypeCd").setAttribute("lastValidValue", (rec == null ? "" : rec.motortypeCd) );
			$("txtMotortypeDesc").value = (rec == null ? "" : unescapeHTML2(rec.motortypeDesc));
			$("txtTarfCd").value = (rec == null ? "" : unescapeHTML2(rec.tarfCd));
			$("txtTarfCd").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.tarfCd)) );
			$("txtTarfDesc").value = (rec == null ? "" : unescapeHTML2(rec.tarfDesc));
			$("txtConstructionCd").value = (rec == null ? "" : unescapeHTML2(rec.constructionCd));
			$("txtConstructionCd").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.constructionCd)) );
			$("txtConstructionDesc").value = (rec == null ? "" : unescapeHTML2(rec.constructionDesc));
			$("txtTariffZone").value = (rec == null ? "" : unescapeHTML2(rec.tariffZone));
			$("txtTariffZone").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.tariffZone)) );
			$("txtTariffZoneDesc").value = (rec == null ? "" : unescapeHTML2(rec.tariffZoneDesc));
			$("txtRemarksHdr").value = (rec == null ? "" : unescapeHTML2(rec.remarks));	
			
			dummyTariffCd = (rec == null ? "" : nvl(rec.tariffCd,rec.tariffCd2));
			
			origLineCd 			= (rec == null ? "" : unescapeHTML2(rec.lineCd));	
			origSublineCd  		= (rec == null ? "" : unescapeHTML2(rec.sublineCd));	
			origPerilCd 		= (rec == null ? "" : rec.perilCd);	
			origSublineTypeCd 	= (rec == null ? "" : unescapeHTML2(nvl(rec.sublineTypeCd,"")));	
			origMotortypeCd 	= (rec == null ? "" : nvl(rec.motortypeCd,""));	
			origTarfCd 			= (rec == null ? "" : unescapeHTML2(nvl(rec.tarfCd,"")));	
			origConstructionCd 	= (rec == null ? "" : unescapeHTML2(nvl(rec.constructionCd,"")));	
			origTariffZone 		= (rec == null ? "" : unescapeHTML2(nvl(rec.tariffZone,"")));	
			origCoverageCd 		= (rec == null ? "" : nvl(rec.coverageCd,""));	
			
			$("txtRemarksDtl").value = (rec == null ? "" : unescapeHTML2(rec.remarks2));	
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(nvl(rec.userId2,rec.userId)));
			$("txtLastUpdate").value = (rec == null ? "" : nvl(rec.lastUpdate2,rec.lastUpdate));

			$("fixedSIRB").disabled = false;
			$("withCompRB").disabled = false;
			$("fixedPremiumRB").disabled = false;
			$("txtFixedPremium2").clear();
			$("txtSIDeductible").clear();
			$("txtExcessRate").clear();
			$("txtLoadingRate").clear();
			$("txtDiscountRate").clear();
			$("txtTariffRate").clear();
			$("txtAdditionalPremium").clear();
			$("txtFixedPremium3").clear();
			$("hidTariffDtlCd").clear();
			
			if (rec != null) {
				if(rec.defaultPremTag == 2){
					$("txtFixedPremium2").value 	= formatCurrency(rec.fixedPremium);
					$("txtSIDeductible").value  	= formatCurrency(rec.siDeductible);
					$("txtExcessRate").value 		= formatToNthDecimal(rec.excessRate,6);
					$("txtLoadingRate").value  		= formatToNthDecimal(rec.loadingRate,9);
					$("txtDiscountRate").value  	= formatToNthDecimal(rec.discountRate,9);
					$("txtTariffRate").value  		= formatToNthDecimal(rec.tariffRate,6);
					$("txtAdditionalPremium").value = formatCurrency(rec.additionalPremium);
					$("hidTariffDtlCd").value 		= rec.tariffDtlCd;
					if(rec.recExist == "Y"){
						$("fixedSIRB").disabled = true;
						$("fixedPremiumRB").disabled = true;
					}
				}else if(rec.defaultPremTag == 3){
					$("txtFixedPremium3").value  	= formatCurrency(rec.fixedPremium);
					$("hidTariffDtlCd").value 		= rec.tariffDtlCd;
					if(rec.recExist == "Y"){
						$("fixedSIRB").disabled = true;
						$("withCompRB").disabled = true;
					}
				}else if(rec.defaultPremTag == 1){
					if(rec.recExist == "Y"){
						$("withCompRB").disabled = true;
						$("fixedPremiumRB").disabled = true;
					}
					refreshTbgFixedSI();
				}
			}else{
				refreshTbgFixedSI();
			}
					
			rec == null ? $("btnAddHdr").value = "Add" : $("btnAddHdr").value = "Update";
			rec == null ? disableButton("btnDeleteHdr") : enableButton("btnDeleteHdr");			
			rec == null ? showTariffRatesDtlItems(2) : showTariffRatesDtlItems(rec.defaultPremTag);
			toggleMcFiFields();
			objTariffRatesHdr = rec;
			
		} catch(e){
			showErrorMessage("setHdrFieldValues", e);
		}
	}
	
	function generateDummyId(array,mode) {
		try {
			var dummyId = 0;
			for ( var i = 0; i < array.length; i++) {
				if (mode == "parent") {
					if (parseInt(nvl(array[i].tariffCd2,array[i].tariffCd)) > parseInt(dummyId)){
						dummyId = nvl(array[i].tariffCd2,array[i].tariffCd);
					}
				} else {
					if (parseInt(nvl(array[i].tariffDtlCd2,array[i].tariffDtlCd)) > parseInt(dummyId)){
						dummyId = nvl(array[i].tariffDtlCd2,array[i].tariffDtlCd);
					}
				}
			}
			return parseInt(dummyId) + 1;
		} catch (e) {
			showErrorMessage("generateDummyId", e);
		}
	}
	
	function setHdrRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.tariffCd = $F("hidTariffCd");
			obj.tariffCd2 = dummyTariffCd == null || dummyTariffCd == "" ? generateDummyId(objAllRecord,"parent") : dummyTariffCd;
			obj.lineCd = escapeHTML2($F("txtLineCd"));
			obj.lineName = escapeHTML2($F("txtLineName"));
			obj.sublineCd = escapeHTML2($F("txtSublineCd"));
			obj.sublineName = escapeHTML2($F("txtSublineName"));
			obj.perilCd = $F("txtPerilCd");
			obj.perilName = escapeHTML2($F("txtPerilName"));
			obj.tariffZone = $F("txtTariffZone");
			obj.tariffZoneDesc = escapeHTML2($F("txtTariffZoneDesc"));
			obj.coverageCd = $F("txtCoverageCd");
			obj.coverageDesc = escapeHTML2($F("txtCoverageDesc"));
			obj.sublineTypeCd = escapeHTML2($F("txtSublineTypeCd"));
			obj.sublineTypeDesc = escapeHTML2($F("txtSublineTypeDesc"));
			obj.motortypeCd = $F("txtMotortypeCd");
			obj.motortypeDesc = escapeHTML2($F("txtMotortypeDesc"));
			obj.tarfCd = escapeHTML2($F("txtTarfCd"));
			obj.tarfDesc = escapeHTML2($F("txtTarfDesc"));
			obj.constructionCd = escapeHTML2($F("txtConstructionCd"));
			obj.constructionDesc = escapeHTML2($F("txtConstructionDesc"));
			obj.remarks = escapeHTML2($F("txtRemarksHdr"));
			obj.defaultPremTag = defaultPremTagRB;
			if(defaultPremTagRB == 2){
				obj.fixedPremium = unformatCurrency($("txtFixedPremium2"));
				obj.siDeductible = unformatCurrency($("txtSIDeductible"));
				obj.excessRate = $F("txtExcessRate");
				obj.loadingRate = parseFloat($F("txtLoadingRate"));
				obj.discountRate = parseFloat($F("txtDiscountRate"));
				obj.tariffRate = $F("txtTariffRate");
				obj.additionalPremium = unformatCurrency($("txtAdditionalPremium"));
				obj.tariffDtlCd = $F("hidTariffDtlCd");
			}else if(defaultPremTagRB == 3){
				obj.fixedPremium = unformatCurrency($("txtFixedPremium3"));
				obj.siDeductible = null;
				obj.excessRate = null;
				obj.loadingRate = null;
				obj.discountRate = null;
				obj.tariffRate = null;
				obj.additionalPremium = null;
				obj.tariffDtlCd = $F("hidTariffDtlCd");
			}
			obj.remarks2 = escapeHTML2($F("txtRemarksDtl"));
			obj.userId2 = userId;
			var lastUpdate = new Date();
			obj.lastUpdate2 = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			return obj;
		} catch(e){
			showErrorMessage("setHdrRec", e);
		}
	}
	
	function addHdrRec(){
		try {
			changeTagFunc = saveGiiss106;
			var hdr = setHdrRec(objTariffRatesHdr);
			var newObj = setHdrRec(null);
			if($F("btnAddHdr") == "Add"){
				tbgTariffRatesHdr.addBottomRow(hdr);
				newObj.recordStatus = 0;
				objAllRecord.push(newObj);
			} else {
				if (changeTagDtl == 1) {
					showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
						$("btnSave").focus();
					});
					return;
				}
				tbgTariffRatesHdr.updateVisibleRowOnly(hdr, rowIndex, false);
				for(var i = 0; i<objAllRecord.length; i++){
					if(objAllRecord[i].recordStatus != -1 ){
						if(nvl(objAllRecord[i].tariffCd,objAllRecord[i].tariffCd2) == newObj.tariffCd2){
							newObj.recordStatus = 1;
							objAllRecord.splice(i, 1, newObj);
						}
					}
				}
			}
			giiss106Array.tariffRatesHdr = tbgTariffRatesHdr.geniisysRows;
			changeTag = 1;
			tbgTariffRatesHdr.onRemoveRowFocus();
		} catch(e){
			showErrorMessage("addHdrRec", e);
		}
	}		
	
	function valAddHdrRec(){
		try{
			if(checkAllRequiredFieldsInDiv("tariffRatesHdrFormDiv")){
				if($("fixedPremiumRB").checked && $F("txtFixedPremium3").blank()){
					customShowMessageBox(objCommonMessage.REQUIRED, "I", "txtFixedPremium3");
					return;
				}
				for(var i=0; i<objAllRecord.length; i++){
					if(objAllRecord[i].recordStatus != -1 ){
						if ($F("btnAddHdr") == "Add") {
							if ($F("txtLineCd") == $F("varMc")){
								if(unescapeHTML2(objAllRecord[i].lineCd) == $F("txtLineCd") &&
								   unescapeHTML2(objAllRecord[i].sublineCd) == $F("txtSublineCd") &&
								   objAllRecord[i].perilCd == $F("txtPerilCd") &&
								   unescapeHTML2(objAllRecord[i].sublineTypeCd) == $F("txtSublineTypeCd") &&
								   objAllRecord[i].motortypeCd == $F("txtMotortypeCd") &&
								   unescapeHTML2(nvl(objAllRecord[i].tariffZone,"")) == $F("txtTariffZone") &&
								   nvl(objAllRecord[i].coverageCd,"") == $F("txtCoverageCd")){
									showMessageBox("Record already exists with the same line_cd, subline_cd, peril_cd, subline_type_cd, motortype_cd, tariff_zone, and coverage_cd.", "E");
									return;
								}
							}else if ($F("txtLineCd") == $F("varFi")){
								if(unescapeHTML2(objAllRecord[i].lineCd) == $F("txtLineCd") &&
								   unescapeHTML2(objAllRecord[i].sublineCd) == $F("txtSublineCd") &&
								   objAllRecord[i].perilCd == $F("txtPerilCd") &&
								   unescapeHTML2(objAllRecord[i].tarfCd) == $F("txtTarfCd") &&
								   unescapeHTML2(nvl(objAllRecord[i].constructionCd,"")) == $F("txtConstructionCd") &&
								   unescapeHTML2(nvl(objAllRecord[i].tariffZone,"")) == $F("txtTariffZone") &&
								   nvl(objAllRecord[i].coverageCd,"") == $F("txtCoverageCd")){
									showMessageBox("Record already exists with the same line_cd, subline_cd, peril_cd, tarf_cd, construction_cd, tariff_zone, and coverage_cd.", "E");
									return;
								}
							}else{
								if(unescapeHTML2(objAllRecord[i].lineCd) == $F("txtLineCd") &&
								   unescapeHTML2(objAllRecord[i].sublineCd) == $F("txtSublineCd") &&
								   objAllRecord[i].perilCd == $F("txtPerilCd") &&
								   unescapeHTML2(nvl(objAllRecord[i].tariffZone,"")) == $F("txtTariffZone") &&
								   nvl(objAllRecord[i].coverageCd,"") == $F("txtCoverageCd")){
									showMessageBox("Record already exists with the same line_cd, subline_cd, peril_cd, tariff_zone, and coverage_cd.", "E");
									return;
								}
							}
						} else{
							if ($F("txtLineCd") == $F("varMc")){
								if((origLineCd != $F("txtLineCd") ||
								   	origSublineCd != $F("txtSublineCd") ||
								   	origPerilCd != $F("txtPerilCd") ||
								   	origSublineTypeCd != $F("txtSublineTypeCd") ||
								   	origMotortypeCd != $F("txtMotortypeCd") ||
								   	origTariffZone != $F("txtTariffZone") ||
								   	origCoverageCd != $F("txtCoverageCd")) 
								  &&
								  (unescapeHTML2(objAllRecord[i].lineCd) == $F("txtLineCd") &&
								   unescapeHTML2(objAllRecord[i].sublineCd) == $F("txtSublineCd") &&
								   objAllRecord[i].perilCd == $F("txtPerilCd") &&
								   unescapeHTML2(objAllRecord[i].sublineTypeCd) == $F("txtSublineTypeCd") &&
								   objAllRecord[i].motortypeCd == $F("txtMotortypeCd") &&
								   unescapeHTML2(nvl(objAllRecord[i].tariffZone,"")) == $F("txtTariffZone") &&
								   nvl(objAllRecord[i].coverageCd,"") == $F("txtCoverageCd"))){
									showMessageBox("Record already exists with the same line_cd, subline_cd, peril_cd, subline_type_cd, motortype_cd, tariff_zone, and coverage_cd.", "E");
									return;
								}
							}else if ($F("txtLineCd") == $F("varFi")){
								if((origLineCd != $F("txtLineCd") ||
								   	origSublineCd != $F("txtSublineCd") ||
								   	origPerilCd != $F("txtPerilCd") ||
								   	origTarfCd != $F("txtTarfCd") ||
								   	origConstructionCd != $F("txtConstructionCd") ||
								   	origTariffZone != $F("txtTariffZone") ||
								   	origCoverageCd != $F("txtCoverageCd")) 
								  &&
								  (unescapeHTML2(objAllRecord[i].lineCd) == $F("txtLineCd") &&
								   unescapeHTML2(objAllRecord[i].sublineCd) == $F("txtSublineCd") &&
								   objAllRecord[i].perilCd == $F("txtPerilCd") &&
								   unescapeHTML2(objAllRecord[i].tarfCd) == $F("txtTarfCd") &&
								   unescapeHTML2(nvl(objAllRecord[i].constructionCd,"")) == $F("txtConstructionCd") &&
								   unescapeHTML2(nvl(objAllRecord[i].tariffZone,"")) == $F("txtTariffZone") &&
								   nvl(objAllRecord[i].coverageCd,"") == $F("txtCoverageCd"))){
									showMessageBox("Record already exists with the same line_cd, subline_cd, peril_cd, tarf_cd, construction_cd, tariff_zone, and coverage_cd.", "E");
									return;
								}
							}else{
								if((origLineCd != $F("txtLineCd") ||
								   	origSublineCd != $F("txtSublineCd") ||
								   	origPerilCd != $F("txtPerilCd") ||
								   	origTariffZone != $F("txtTariffZone") ||
								   	origCoverageCd != $F("txtCoverageCd")) 
								  &&
								  (unescapeHTML2(objAllRecord[i].lineCd) == $F("txtLineCd") &&
								   unescapeHTML2(objAllRecord[i].sublineCd) == $F("txtSublineCd") &&
								   objAllRecord[i].perilCd == $F("txtPerilCd") &&
								   unescapeHTML2(nvl(objAllRecord[i].tariffZone,"")) == $F("txtTariffZone") &&
								   nvl(objAllRecord[i].coverageCd,"") == $F("txtCoverageCd"))){
									showMessageBox("Record already exists with the same line_cd, subline_cd, peril_cd, tariff_zone, and coverage_cd.", "E");
									return;
								}
							}
						}
					} 
				}
				addHdrRec();
			}
		} catch(e){
			showErrorMessage("valAddHdrRec", e);
		}
	}	
	
	function deleteHdrRec(){
		changeTagFunc = saveGiiss106;
		objTariffRatesHdr.recordStatus = -1;
		tbgTariffRatesHdr.deleteRow(rowIndex);
		giiss106Array.tariffRatesHdr = tbgTariffRatesHdr.geniisysRows;
		
		var newObj = setHdrRec(null);
		for(var i = 0; i<objAllRecord.length; i++){
			if(objAllRecord[i].recordStatus != -1 ){
				if(nvl(objAllRecord[i].tariffCd,objAllRecord[i].tariffCd2) == newObj.tariffCd2){
					newObj.recordStatus = -1;
					objAllRecord.splice(i, 1, newObj);
				}
			}
		}
		changeTag = 1;
		setHdrFieldValues(null);
	}
	
	function valDeleteHdrRec(){
		try{
			new Ajax.Request(contextPath + "/GIISTariffRatesHdrController", {
				parameters : {action : 		"valDeleteHdrRec",
							  tariffCd: $F("hidTariffCd")},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						deleteHdrRec();
					}
				}
			});
		} catch(e){
			showErrorMessage("valDeleteHdrRec", e);
		}
	}
	
	function showTariffRatesDtlItems(val){
		try{
			$$("input[name='defaultPremTagRG']").each(function(rb){
				rb.checked = (rb.value == val ? true : false);
			});
			
			defaultPremTagRB = val;
			
			if (defaultPremTagRB == 1){
				$("fixedSIDiv").show();
				$("buttonsFixedSIDiv").show();
				$("withCompDiv").hide();
				$("fixedPremDiv").hide();
				$("txtFixedSI").focus();
				refreshTbgFixedSI();
			}else if (defaultPremTagRB == 3){
				$("fixedPremDiv").show();
				$("buttonsFixedSIDiv").hide();
				$("withCompDiv").hide();
				$("fixedSIDiv").hide();	
				$("txtFixedPremium3").focus();	
			}else{
				$("withCompDiv").show();
				$("buttonsFixedSIDiv").hide();
				$("fixedSIDiv").hide();
				$("fixedPremDiv").hide();	
				$("txtFixedPremium2").focus();	
			}
		}catch(e){
			showErrorMessage("showTariffRatesDtlItems", e);
		}
	}
	
	function toggleMcFiFields(){
		if ($F("txtLineCd") == $F("varFi")){
			$("txtSublineTypeCd").clear();
			$("txtSublineTypeDesc").clear();
			$("txtMotortypeCd").clear();
			$("txtMotortypeDesc").clear();
			$("txtSublineTypeCd").readOnly = true;
			disableSearch("searchSublineTypeLOV");
			$("txtMotortypeCd").readOnly = true;
			disableSearch("searchMotortypeLOV");
			$("txtSublineTypeCd").removeClassName("required");
			$("sublineTypeSpan").removeClassName("required");
			$("txtSublineTypeDesc").removeClassName("required");
			$("txtMotortypeCd").removeClassName("required");
			$("motortypeSpan").removeClassName("required");
			$("txtMotortypeDesc").removeClassName("required");
			$("txtTarfCd").readOnly = false;
			enableSearch("searchTarfLOV");
			$("txtConstructionCd").readOnly = false;
			enableSearch("searchConstructionLOV");
			$("txtTarfCd").addClassName("required");
			$("tarfSpan").addClassName("required");
			$("txtTarfDesc").addClassName("required");
			$("txtTariffZone").addClassName("required");
			$("tariffZoneSpan").addClassName("required");
			$("txtTariffZoneDesc").addClassName("required");
			
			$("sublineTypeSpan").setStyle({
			  backgroundColor: '#FFFFFF'
			});
			$("motortypeSpan").setStyle({
			  backgroundColor: '#FFFFFF'
			});
			$("tariffZoneSpan").setStyle({
			  backgroundColor: '#FFFACD'
			});
			$("tarfSpan").setStyle({
			  backgroundColor: '#FFFACD'
			});
			
		}else if ($F("txtLineCd") == $F("varMc")){
			$("txtSublineTypeCd").readOnly = false;
			enableSearch("searchSublineTypeLOV");
			$("txtMotortypeCd").readOnly = false;
			enableSearch("searchMotortypeLOV");
			$("txtSublineTypeCd").addClassName("required");
			$("sublineTypeSpan").addClassName("required");
			$("txtSublineTypeDesc").addClassName("required");
			$("txtMotortypeCd").addClassName("required");
			$("motortypeSpan").addClassName("required");
			$("txtMotortypeDesc").addClassName("required");

			$("txtTarfCd").clear();
			$("txtTarfDesc").clear();
			$("txtConstructionCd").clear();
			$("txtConstructionDesc").clear();
			$("txtTarfCd").readOnly = true;
			disableSearch("searchTarfLOV");
			$("txtConstructionCd").readOnly = true;
			disableSearch("searchConstructionLOV");
			$("txtTarfCd").removeClassName("required");
			$("tarfSpan").removeClassName("required");
			$("txtTarfDesc").removeClassName("required");
			$("txtTariffZone").removeClassName("required");
			$("tariffZoneSpan").removeClassName("required");
			$("txtTariffZoneDesc").removeClassName("required");
			$("sublineTypeSpan").setStyle({
			  backgroundColor: '#FFFACD'
			});
			$("motortypeSpan").setStyle({
			  backgroundColor: '#FFFACD'
			});
			$("tariffZoneSpan").setStyle({
			  backgroundColor: '#FFFFFF'
			});
			$("tarfSpan").setStyle({
			  backgroundColor: '#FFFFFF'
			});
		}else{
			$("txtSublineTypeCd").clear();
			$("txtSublineTypeDesc").clear();
			$("txtMotortypeCd").clear();
			$("txtMotortypeDesc").clear();
			$("txtSublineTypeCd").readOnly = true;
			disableSearch("searchSublineTypeLOV");
			$("txtMotortypeCd").readOnly = true;
			disableSearch("searchMotortypeLOV");
			$("txtSublineTypeCd").removeClassName("required");
			$("sublineTypeSpan").removeClassName("required");
			$("txtSublineTypeDesc").removeClassName("required");
			$("txtMotortypeCd").removeClassName("required");
			$("motortypeSpan").removeClassName("required");
			$("txtMotortypeDesc").removeClassName("required");

			$("txtTarfCd").clear();
			$("txtTarfDesc").clear();
			$("txtConstructionCd").clear();
			$("txtConstructionDesc").clear();
			$("txtTarfCd").readOnly = true;
			disableSearch("searchTarfLOV");
			$("txtConstructionCd").readOnly = true;
			disableSearch("searchConstructionLOV");
			$("txtTarfCd").removeClassName("required");
			$("tarfSpan").removeClassName("required");
			$("txtTarfDesc").removeClassName("required");
			$("txtTariffZone").removeClassName("required");
			$("tariffZoneSpan").removeClassName("required");
			$("txtTariffZoneDesc").removeClassName("required");
			
			$("txtConstructionCd").removeClassName("required");
			$("constructionSpan").removeClassName("required");
			$("txtConstructionDesc").removeClassName("required");
			$("sublineTypeSpan").setStyle({
			  backgroundColor: '#FFFFFF'
			});
			$("motortypeSpan").setStyle({
			  backgroundColor: '#FFFFFF'
			});
			$("tariffZoneSpan").setStyle({
			  backgroundColor: '#FFFFFF'
			});
			$("tarfSpan").setStyle({
			  backgroundColor: '#FFFFFF'
			});
		}
	}
	
	function showLineLOV(isIconClicked){
		try{
			//var searchString = isIconClicked ? "%" : ($F("txtLineCd").trim() == "" ? "%" : $F("txtLineCd"));
			var searchString = ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : "");
			
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGiiss106LineLOV",
					searchString : searchString,//+"%",
					moduleId: 'GIISS106',
					page : 1
				},
				title : "List of Lines",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "lineCd",
					title : "Line",
					width : '120px'
				}, {
					id : "lineName",
					title : "Line Name",
					width : '345px'
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						if (row.lineCd != $("txtLineCd").readAttribute("lastValidValue")){
							$("txtSublineCd").clear();
							$("txtSublineName").clear();
							$("txtPerilCd").clear();
							$("txtPerilName").clear();
							$("txtSublineTypeCd").clear();
							$("txtSublineTypeDesc").clear();
							$("txtMotortypeCd").clear();
							$("txtMotortypeDesc").clear();
							$("txtTariffZone").clear();
							$("txtTariffZoneDesc").clear();
							$("txtCoverageCd").clear();
							$("txtCoverageDesc").clear();
						}
						
						$("txtLineCd").value = unescapeHTML2(row.lineCd);
						$("txtLineCd").setAttribute("lastValidValue", $("txtLineCd").value);
						$("txtLineName").value = unescapeHTML2(row.lineName);
						toggleMcFiFields();
					}
				},
				onCancel: function(){
					$("txtLineCd").focus();
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtLineCd");
				} 
			});
		}catch(e){
			showErrorMessage("showLineLOV", e);
		}		
	}
	
	function showSublineLOV(isIconClicked){
		try{
			//var searchString = isIconClicked ? "%" : ($F("txtSublineCd").trim() == "" ? "%" : $F("txtSublineCd"));
			var searchString = ($("txtSublineCd").readAttribute("lastValidValue").trim() != $F("txtSublineCd").trim() ? $F("txtSublineCd").trim() : "");
			
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGiiss106SublineLOV",
					lineCd:	$F("txtLineCd"),
					searchString : searchString,
					page : 1
				},
				title : "List of Sublines",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "sublineCd",
					title : "Subline",
					width : '120px'
				}, {
					id : "sublineName",
					title : "Subline Name",
					width : '345px'
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						if (row.sublineCd != $("txtSublineCd").readAttribute("lastValidValue")){
							$("txtSublineTypeCd").clear();
							$("txtSublineTypeDesc").clear();
							$("txtMotortypeCd").clear();
							$("txtMotortypeDesc").clear();
							$("txtTariffZone").clear();
							$("txtTariffZoneDesc").clear();
						}
						
						$("txtSublineCd").value = unescapeHTML2(row.sublineCd);
						$("txtSublineCd").setAttribute("lastValidValue", $("txtSublineCd").value);
						$("txtSublineName").value = unescapeHTML2(row.sublineName);
					}
				},
				onCancel: function(){
					$("txtSublineCd").focus();
					$("txtSublineCd").value = $("txtSublineCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("txtSublineCd").value = $("txtSublineCd").readAttribute("lastValidValue");
					var id = $F("txtLineCd").trim() == "" ? "txtLineCd" : "txtSublineCd";
					customShowMessageBox("No record selected.", imgMessage.INFO, id);
				} 
			});
		}catch(e){
			showErrorMessage("showSublineLOV", e);
		}		
	}
	
	function showPerilLOV(isIconClicked){
		try{
			//var searchString = isIconClicked ? "%" : ($F("txtPerilCd").trim() == "" ? "%" : $F("txtPerilCd"));
			var searchString = ($("txtPerilCd").readAttribute("lastValidValue").trim() != $F("txtPerilCd").trim() ? $F("txtPerilCd").trim() : "");
			
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGiiss106PerilLOV",
					lineCd:	$F("txtLineCd"),
					searchString : searchString,
					page : 1
				},
				title : "List of Perils",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "perilCd",
					title : "Peril",
					width : '120px',
					titleAlign : 'right',
					align : 'right'
				}, {
					id : "perilName",
					title : "Peril Name",
					width : '345px'
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						$("txtPerilCd").value = row.perilCd;
						$("txtPerilCd").setAttribute("lastValidValue", $("txtPerilCd").value);
						$("txtPerilName").value = unescapeHTML2(row.perilName);
					}
				},
				onCancel: function(){
					$("txtPerilCd").focus();
					$("txtPerilCd").value = $("txtPerilCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("txtPerilCd").value = $("txtPerilCd").readAttribute("lastValidValue");
					var id = $F("txtLineCd").trim() == "" ? "txtLineCd" : "txtPerilCd";
					customShowMessageBox("No record selected.", imgMessage.INFO, id);
				} 
			});
		}catch(e){
			showErrorMessage("showPerilLOV", e);
		}		
	}
	
	function showTariffZoneLOV(isIconClicked){
		try{
			//var searchString = isIconClicked ? "%" : ($F("txtTariffZone").trim() == "" ? "%" : $F("txtTariffZone"));
			var searchString = ($("txtTariffZone").readAttribute("lastValidValue").trim() != $F("txtTariffZone").trim() ? $F("txtTariffZone").trim() : "");
			
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getTariffZoneLOV2",
					searchString : searchString,
					page : 1
				},
				title : "List of Tariff Zone",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "tariffZone",
					title : "Tariff Zone",
					width : '120px'
				}, {
					id : "tariffZoneDesc",
					title : "Tariff Zone Desc",
					width : '345px'
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						$("txtTariffZone").value = unescapeHTML2(row.tariffZone);
						$("txtTariffZone").setAttribute("lastValidValue", $("txtTariffZone").value);
						$("txtTariffZoneDesc").value = unescapeHTML2(row.tariffZoneDesc);
					}
				},
				onCancel: function(){
					$("txtTariffZone").focus();
					$("txtTariffZone").value = $("txtTariffZone").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("txtTariffZone").value = $("txtTariffZone").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtTariffZone");
				} 
			});
		}catch(e){
			showErrorMessage("showTariffZoneLOV", e);
		}		
	}

	function showCoverageLOV(isIconClicked){
		try{
			//var searchString = isIconClicked ? "%" : ($F("txtCoverageCd").trim() == "" ? "%" : $F("txtCoverageCd"));
			var searchString = ($("txtCoverageCd").readAttribute("lastValidValue").trim() != $F("txtCoverageCd").trim() ? $F("txtCoverageCd").trim() : "");
			
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGiisCoverageLOV",
					searchString : searchString,
					page : 1
				},
				title : "List of Coverage",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "coverageCd",
					title : "Coverage",
					width : '120px',
					titleAlign : 'right',
					align : 'right'
				}, {
					id : "coverageDesc",
					title : "Coverage Desc",
					width : '345px'
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						$("txtCoverageCd").value = row.coverageCd;
						$("txtCoverageCd").setAttribute("lastValidValue", row.coverageCd);
						$("txtCoverageDesc").value = unescapeHTML2(row.coverageDesc);
					}
				},
				onCancel: function(){
					$("txtCoverageCd").focus();
					$("txtCoverageCd").value = $("txtCoverageCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("txtCoverageCd").value = $("txtCoverageCd").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtCoverageCd");
				} 
			});
		}catch(e){
			showErrorMessage("showCoverageLOV", e);
		}		
	}

	function showSublineTypeLOV(isIconClicked){
		try{
			//var searchString = isIconClicked ? "%" : ($F("txtSublineTypeCd").trim() == "" ? "%" : $F("txtSublineTypeCd"));	
			var searchString = ($("txtSublineTypeCd").readAttribute("lastValidValue").trim() != $F("txtSublineTypeCd").trim() ? $F("txtSublineTypeCd").trim() : "");
			
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGiiss106SublineTypeLOV",
					sublineCd:	$F("txtSublineCd"),
					searchString : searchString,
					page : 1
				},
				title : "List of Subline Types",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "sublineTypeCd",
					title : "Subline Type",
					width : '120px'
				}, {
					id : "sublineTypeDesc",
					title : "Subline Type Desc",
					width : '345px'
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						$("txtSublineTypeCd").value = unescapeHTML2(row.sublineTypeCd);
						$("txtSublineTypeCd").setAttribute("lastValidValue", $("txtSublineTypeCd").value);
						$("txtSublineTypeDesc").value = unescapeHTML2(row.sublineTypeDesc);
					}
				},
				onCancel: function(){
					$("txtSublineTypeCd").focus();
					$("txtSublineTypeCd").value = $("txtSublineTypeCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("txtSublineTypeCd").value = $("txtSublineTypeCd").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtSublineTypeCd");
				} 
			});
		}catch(e){
			showErrorMessage("showSublineTypeLOV", e);
		}		
	}

	function showMotortypeLOV(isIconClicked){
		try{
			//var searchString = isIconClicked ? "%" : ($F("txtMotortypeCd").trim() == "" ? "%" : $F("txtMotortypeCd"));
			var searchString = ($("txtMotortypeCd").readAttribute("lastValidValue").trim() != $F("txtMotortypeCd").trim() ? $F("txtMotortypeCd").trim() : "");
			
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGiiss106MotortypeLOV",
					sublineCd:	$F("txtSublineCd"),
					searchString : searchString,
					page : 1
				},
				title : "List of Motortypes",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "typeCd",
					title : "Motortype",
					width : '120px',
					titleAlign : 'right',
					align : 'right'
				}, {
					id : "motortypeDesc",
					title : "Motortype Desc",
					width : '345px'
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						$("txtMotortypeCd").value = row.typeCd;
						$("txtMotortypeCd").setAttribute("lastValidValue", row.typeCd);
						$("txtMotortypeDesc").value = unescapeHTML2(row.motortypeDesc);
					}
				},
				onCancel: function(){
					$("txtMotortypeCd").focus();
					$("txtMotortypeCd").value = $("txtMotortypeCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("txtMotortypeCd").value = $("txtMotortypeCd").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtMotortypeCd");
				} 
			});
		}catch(e){
			showErrorMessage("showMotortypeLOV", e);
		}		
	}
	
	function showTarfLOV(isIconClicked){
		try{
			var searchString = isIconClicked ? "%" : ($F("txtTarfCd").trim() == "" ? "%" : $F("txtTarfCd"));	
			
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGipis155TarfLOV",
					searchString : searchString,
					page : 1
				},
				title : "List of Tariff Codes",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "tarfCd",
					title : "Code",
					width : '120px',
				}, {
					id : "tarfDesc",
					title : "Tariff Code",
					width : '345px'
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						$("txtTarfCd").value = unescapeHTML2(row.tarfCd);
						$("txtTarfCd").setAttribute("lastValidValue",unescapeHTML2( row.tarfCd));
						$("txtTarfDesc").value = unescapeHTML2(row.tarfDesc);
					}
				},
				onCancel: function(){
					$("txtTarfCd").focus();
					$("txtTarfCd").value = $("txtTarfCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("txtTarfCd").value = $("txtTarfCd").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtTarfCd");
				} 
			});
		}catch(e){
			showErrorMessage("showTarfLOV", e);
		}		
	}

	function showConstructionLOV(isIconClicked){
		try{
			var searchString = isIconClicked ? "%" : ($F("txtConstructionCd").trim() == "" ? "%" : $F("txtConstructionCd"));	
			
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGiiss106ConstructionLOV",
					searchString : searchString,
					page : 1
				},
				title : "List of Constructions",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "constructionCd",
					title : "Construction Code",
					width : '120px',
				}, {
					id : "constructionDesc",
					title : "Construction Desc",
					width : '345px'
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						$("txtConstructionCd").value = unescapeHTML2(row.constructionCd);
						$("txtConstructionCd").setAttribute("lastValidValue", unescapeHTML2(row.constructionCd));
						$("txtConstructionDesc").value = unescapeHTML2(row.constructionDesc);
					}
				},
				onCancel: function(){
					$("txtConstructionCd").focus();
					$("txtConstructionCd").value = $("txtConstructionCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("txtConstructionCd").value = $("txtConstructionCd").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtConstructionCd");
				} 
			});
		}catch(e){
			showErrorMessage("showConstructionLOV", e);
		}		
	}


//----------------------------------------------------------------------------------------------------------------------------//
	
	var lastFixedSI = null;
	var lastHigherRange = null;
	var rowIndexDtl = -1;
	var objTariffRatesFixedSI = null;
	var objAllRecordDtl = [];
	objGIISS106.tariffRatesFixedSIList = JSON.parse('${jsonFixedSIList}');
	objGIISS106.afterSave = null;
	
	var tariffRatesFixedSITable = {
			url : contextPath + "/GIISTariffRatesHdrController?action=getGiiss106FixedSIList&refresh=1&tariffCd="+$F("hidTariffCd"),
			options : {
				width : '642px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndexDtl = y;
					objTariffRatesFixedSI = tbgTariffRatesFixedSI.geniisysRows[y];
					setFixedSIFieldValues(objTariffRatesFixedSI);
					tbgTariffRatesFixedSI.keys.removeFocus(tbgTariffRatesFixedSI.keys._nCurrentFocus, true);
					tbgTariffRatesFixedSI.keys.releaseKeys();
					$("txtFixedSI").focus();
				},
				onRemoveRowFocus : function(){
					rowIndexDtl = -1;
					setFixedSIFieldValues(null);
					tbgTariffRatesFixedSI.keys.removeFocus(tbgTariffRatesFixedSI.keys._nCurrentFocus, true);
					tbgTariffRatesFixedSI.keys.releaseKeys();
					$("txtFixedSI").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndexDtl = -1;
						setFixedSIFieldValues(null);
						tbgTariffRatesFixedSI.keys.removeFocus(tbgTariffRatesFixedSI.keys._nCurrentFocus, true);
						tbgTariffRatesFixedSI.keys.releaseKeys();
					}
				},
				beforeSort : function(){
					if(changeTagDtl == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
				},
				onSort: function(){
					rowIndexDtl = -1;
					setFixedSIFieldValues(null);
					tbgTariffRatesFixedSI.keys.removeFocus(tbgTariffRatesFixedSI.keys._nCurrentFocus, true);
					tbgTariffRatesFixedSI.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndexDtl = -1;
					setFixedSIFieldValues(null);
					tbgTariffRatesFixedSI.keys.removeFocus(tbgTariffRatesFixedSI.keys._nCurrentFocus, true);
					tbgTariffRatesFixedSI.keys.releaseKeys();
				},				
				prePager: function(){
					if(changeTagDtl == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
					rowIndexDtl = -1;
					setFixedSIFieldValues(null);
					tbgTariffRatesFixedSI.keys.removeFocus(tbgTariffRatesFixedSI.keys._nCurrentFocus, true);
					tbgTariffRatesFixedSI.keys.releaseKeys();
				},
				checkChanges: function(){
					return (changeTagDtl == 1 ? true : false);
				},
				masterDetailRequireSaving: function(){
					return (changeTagDtl == 1 ? true : false);
				},
				masterDetailValidation: function(){
					return (changeTagDtl == 1 ? true : false);
				},
				masterDetail: function(){
					return (changeTagDtl == 1 ? true : false);
				},
				masterDetailSaveFunc: function() {
					return (changeTagDtl == 1 ? true : false);
				},
				masterDetailNoFunc: function(){
					return (changeTagDtl == 1 ? true : false);
				}
			},
			columnModel : [
				{ 								// this column will only use for deletion
				    id: 'recordStatus', 		// 'id' should be 'recordStatus' to disregard the some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
				    width: '0',				    
				    visible : false			
				},
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},
				{
					id : 'fixedSI',
					title: 'Fixed Sum Insured',
					titleAlign: 'right',
					align: 'right',
					width : '150px',
					filterOption : true,
					filterOptionType : 'numberNoNegative',
					renderer: function(val){
						return formatCurrency(val);
					}
				},
				{
					id : 'higherRange',
					title: 'Highest Limit',
					titleAlign: 'right',
					align: 'right',
					width : '150px',
					filterOption : true,
					filterOptionType : 'numberNoNegative',
					renderer: function(val){
						return formatCurrency(val);
					}
				},
				{
					id : 'lowerRange',
					title: 'Lowest Limit',
					titleAlign: 'right',
					align: 'right',
					width : '150px',
					filterOption : true,
					filterOptionType : 'numberNoNegative',
					renderer: function(val){
						return formatCurrency(val);
					}
				},
				{
					id : 'fixedPremium',
					title: 'Fixed Premium',
					titleAlign: 'right',
					align: 'right',
					width : '150px',
					filterOption : true,
					filterOptionType : 'numberNoNegative',
					renderer: function(val){
						return formatCurrency(val);
					}
				},
				{
					id : 'tariffDtlCd',
					width : '0',
					visible: false				
				},
				{
					id : 'remarks',
					width : '0',
					visible: false				
				},
				{
					id : 'userId',
					width : '0',
					visible: false
				},
				{
					id : 'lastUpdate',
					width : '0',
					visible: false				
				}
			],
			rows : objGIISS106.tariffRatesFixedSIList.rows
		};

		tbgTariffRatesFixedSI = new MyTableGrid(tariffRatesFixedSITable);
		tbgTariffRatesFixedSI.pager = objGIISS106.tariffRatesFixedSIList;
		tbgTariffRatesFixedSI.render("tariffRatesFixedSITable");
		tbgTariffRatesFixedSI.afterRender = function(){
			if(rowIndex > -1 ){
				giiss106Array.tariffRatesHdr[rowIndex].tariffRatesFixedSI = tbgTariffRatesFixedSI.geniisysRows;
				objAllRecordDtl = getAllDtlRecord();
			}
		};
	
	function toggleTariffRatesDtlFields(enable){
		if(enable){
			$$("input[name='dtlField']").each(function(txt){
				$(txt).readOnly = false;
			});
			$("txtRemarksDtl").readOnly = false;
			enableButton("btnAddFixedSI");
		}else{
			$$("input[name='dtlField']").each(function(txt){
				$(txt).readOnly = true;
			});
			$("txtRemarksDtl").readOnly = true;
			disableButton("btnAddFixedSI");
		}
	}
	
	function setFixedSIFieldValues(rec){
		try{
			$("hidTariffDtlCd").value = (rec == null ? "" : rec.tariffDtlCd);
			$("txtFixedSI").value = (rec == null ? "" : formatCurrency(rec.fixedSI));
			$("txtFixedPremium1").value = (rec == null ? "" : formatCurrency(rec.fixedPremium));
			$("txtHigherRange").value = (rec == null ? "" : formatCurrency(rec.higherRange));
			$("txtLowerRange").value = (rec == null ? "" : formatCurrency(rec.lowerRange));
			$("txtRemarksDtl").value = (rec == null ? "" : unescapeHTML2(rec.remarks));	
			$("txtUserId").value =  (rec == null ? "" : unescapeHTML2(rec.userId));	
			$("txtLastUpdate").value =  (rec == null ? "" : unescapeHTML2(rec.lastUpdate));	
			
			dummyTariffDtlCd = (rec == null ? "" : nvl(rec.tariffDtlCd,rec.tariffDtlCd2));
			
			origFixedSI = (rec == null ? "" : (rec.fixedSI));
			origHigherRange = (rec == null ? "" : (rec.higherRange));
			origLowerRange = (rec == null ? "" : (rec.lowerRange));
			
			rec == null ? $("btnAddFixedSI").value = "Add" : $("btnAddFixedSI").value = "Update";
			rec == null ? disableButton("btnDeleteFixedSI") : enableButton("btnDeleteFixedSI");			
			
			objTariffRatesFixedSI = rec;
		} catch(e){
			showErrorMessage("setFixedSIFieldValues", e);
		}
	}
	
	function setFixedSIRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.tariffCd = $F("hidTariffCd");
			obj.tariffDtlCd = $F("hidTariffDtlCd");
			obj.tariffDtlCd2 = dummyTariffDtlCd == null || dummyTariffDtlCd == "" ? generateDummyId(objAllRecordDtl,"child") : dummyTariffDtlCd;
			obj.fixedSI = unformatValueToString($F("txtFixedSI"));
			obj.fixedPremium = unformatValueToString($F("txtFixedPremium1"));
			obj.higherRange = unformatValueToString($F("txtHigherRange"));
			obj.lowerRange = unformatValueToString($F("txtLowerRange"));
			obj.remarks = escapeHTML2($F("txtRemarksDtl"));
			
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			return obj;
		} catch(e){
			showErrorMessage("setFixedSIRec", e);
		}
	}
	
	function clearTariffRatesHdrDtl(){
		try {
			if (rowIndex != -1) {
				giiss106Array.tariffRatesHdr[rowIndex].recordStatus = 1;
				giiss106Array.tariffRatesHdr[rowIndex].fixedPremium = null;
				giiss106Array.tariffRatesHdr[rowIndex].siDeductible = null;
				giiss106Array.tariffRatesHdr[rowIndex].excessRate = null;
				giiss106Array.tariffRatesHdr[rowIndex].loadingRate = null;
				giiss106Array.tariffRatesHdr[rowIndex].discountRate = null;
				giiss106Array.tariffRatesHdr[rowIndex].tariffRate = null;
				giiss106Array.tariffRatesHdr[rowIndex].additionalPremium = null;
				giiss106Array.tariffRatesHdr[rowIndex].tariffDtlCd = null;
				giiss106Array.tariffRatesHdr[rowIndex].remarks2 = null;
			} 
		} catch(e){
			showErrorMessage("clearTariffRatesHdrDtl", e);
		}
	}
	
	function unformatValueToString(value) {
		try{
			value = nvl(value, "");
			var unformattedValue = "";	
			if (value.replace(/,/g, "") != "" && !isNaN(parseFloat(value.replace(/,/g, "")))){
				unformattedValue = value.replace(/,/g, "");
			}
			return unformattedValue;	
		}catch(e){
			showErrorMessage("unformatValueToString", e);
		}	
	}
	
	function addFixedSIRec(){
		try {
			changeTagFunc = saveGiiss106;
			var dtl = setFixedSIRec(objTariffRatesFixedSI);
			var newObj = setFixedSIRec(null);
			if($F("btnAddFixedSI") == "Add"){
				tbgTariffRatesFixedSI.addBottomRow(dtl);
				newObj.recordStatus = 0;
				objAllRecordDtl.push(newObj);
				clearTariffRatesHdrDtl();
			} else {
				tbgTariffRatesFixedSI.updateVisibleRowOnly(dtl, rowIndexDtl, false);
				for(var i = 0; i<objAllRecordDtl.length; i++){
					if (nvl(objAllRecordDtl[i].tariffDtlCd,objAllRecordDtl[i].tariffDtlCd2) == newObj.tariffDtlCd2 &&(objAllRecordDtl[i].recordStatus != -1)){
						newObj.recordStatus = 1;
						objAllRecordDtl.splice(i, 1, newObj);
					}
				}
			}
			if ($("fixedSIRB").checked) {
				changeTagDtl = 1;
				if (rowIndex != -1) {
					giiss106Array.tariffRatesHdr[rowIndex].defaultPremTag = 1;
				} 
			}
			giiss106Array.tariffRatesHdr[rowIndex].tariffRatesFixedSI = tbgTariffRatesFixedSI.geniisysRows;
			changeTag = 1;	//for logout
			//setFixedSIFieldValues(null); //remove by steven redundant code 
			/*tbgTariffRatesFixedSI.keys.removeFocus(tbgTariffRatesFixedSI.keys._nCurrentFocus, true);
			tbgTariffRatesFixedSI.keys.releaseKeys();*/
			tbgTariffRatesFixedSI.onRemoveRowFocus();
		} catch(e){
			showErrorMessage("addFixedSIRec", e);
		}
	}	

	function valAddUpdateDtlRec() {
		try {
			for(var i=0; i<objAllRecordDtl.length; i++){
				if(objAllRecordDtl[i].recordStatus != -1 ){
					if ($F("btnAddFixedSI") == "Add") {
						if(unformatValueToString(formatCurrency(objAllRecordDtl[i].fixedSI)) == unformatValueToString($F("txtFixedSI"))){
							showMessageBox("Record already exists with the same tariff_cd,tariff_dtl_cd and fixed_si.", "E");
							return;
						}else if (unformatValueToString(formatCurrency(objAllRecordDtl[i].higherRange)) == unformatValueToString($F("txtHigherRange")) && unformatValueToString(formatCurrency(objAllRecordDtl[i].lowerRange)) == unformatValueToString($F("txtLowerRange"))){
							showMessageBox("Record already exists with the same tariff_cd,tariff_cd,additional_premium,higher_range and lower_range.", "E");
							return;
						}
					} else{
						if(unformatValueToString(formatCurrency(origFixedSI)) != unformatValueToString($F("txtFixedSI")) && unformatValueToString(formatCurrency(objAllRecordDtl[i].fixedSI)) == unformatValueToString($F("txtFixedSI"))){
							showMessageBox("Record already exists with the same tariff_cd,tariff_dtl_cd and fixed_si.", "E");
							return;
						}else if (unformatValueToString(formatCurrency(origHigherRange)) != unformatValueToString($F("txtHigherRange")) && unformatValueToString(formatCurrency(origLowerRange)) != unformatValueToString($F("txtLowerRange")) && unformatValueToString(formatCurrency(objAllRecordDtl[i].higherRange)) == unformatValueToString($F("txtHigherRange")) && unformatValueToString(formatCurrency(objAllRecordDtl[i].lowerRange)) == unformatValueToString($F("txtLowerRange"))){
							showMessageBox("Record already exists with the same tariff_cd,tariff_cd,additional_premium,higher_range and lower_range.", "E");
							return;
						}
					}
				} 
			}
			addFixedSIRec();
		} catch (e) {
			showErrorMessage("valAddUpdateRec",e);
		}
	}
	function validPrevAmt() {
		try {
			var maxAmt = 0;
			var tariffDtlCd = null;
			for(var i=0; i<objAllRecordDtl.length; i++){
				if(objAllRecordDtl[i].recordStatus != -1 ){
					if ($F("btnAddFixedSI") == "Add") {
						if(parseFloat(objAllRecordDtl[i].fixedSI) >= parseFloat(maxAmt)){
							maxAmt = objAllRecordDtl[i].fixedSI;
							tariffDtlCd = nvl(objAllRecordDtl[i].tariffDtlCd,objAllRecordDtl[i].tariffDtlCd2);
						}
					} else {
						if(nvl(objAllRecordDtl[i].tariffDtlCd,objAllRecordDtl[i].tariffDtlCd2) ==  dummyTariffDtlCd){
							break;
						}else{
							if(parseFloat(objAllRecordDtl[i].fixedSI) >= parseFloat(maxAmt)){
								maxAmt = objAllRecordDtl[i].fixedSI;
								tariffDtlCd = nvl(objAllRecordDtl[i].tariffDtlCd,objAllRecordDtl[i].tariffDtlCd2);
							}
						}
					}
				} 
			}
			if (objAllRecordDtl.length > 0 && dummyTariffDtlCd != tariffDtlCd) {
				new Ajax.Request(contextPath + "/GIISTariffRatesHdrController", {
					parameters : {action : "validPrevAmt",
								  maxAmt: maxAmt,
								  high : unformatValueToString($F("txtHigherRange")),
								  low : unformatValueToString($F("txtLowerRange"))},
				  	evalScripts: true,
					asynchronous: false,
					onCreate : showNotice("Processing, please wait..."),
					onComplete : function(response){
						hideNotice();
						if(checkErrorOnResponse(response)){
							if (response.responseText != "OK"){
								var msg = null; 
								var id = null;
								if (response.responseText == "h error") {
									msg = "Highest limit must be greater than any previous fixed sum insured.";
									id = "txtHigherRange";
								}else{
									msg = "Lowest limit must be greater than any previous fixed sum insured.";
									id = "txtLowerRange";
								}
								showWaitingMessageBox(msg, "I", function(){
									$(id).focus();
								});
							}else{
								valAddUpdateDtlRec();
							}
						}
					}
				});
			}else{
				valAddUpdateDtlRec();
			}
		} catch (e) {
			showErrorMessage("validPrevAmt",e);
		}
	}
	
	function deleteFixedSIRec(){
		changeTagFunc = saveGiiss106;
		var newObj = setFixedSIRec(null);
		objTariffRatesFixedSI.recordStatus = -1;
		tbgTariffRatesFixedSI.deleteRow(rowIndexDtl);
		giiss106Array.tariffRatesHdr[rowIndex].tariffRatesFixedSI = tbgTariffRatesFixedSI.geniisysRows;
		for(var i = 0; i<objAllRecordDtl.length; i++){
			if (nvl(objAllRecordDtl[i].tariffDtlCd,objAllRecordDtl[i].tariffDtlCd2) == newObj.tariffDtlCd2 &&(objAllRecordDtl[i].recordStatus != -1)){
				newObj.recordStatus = -1;
				objAllRecordDtl.splice(i, 1, newObj);
			}
		}
		changeTagDtl = 1;
// 		setFixedSIFieldValues(null);
		tbgTariffRatesFixedSI.onRemoveRowFocus();
	}
	
	function refreshTbgFixedSI(){
		tbgTariffRatesFixedSI.url = contextPath + "/GIISTariffRatesHdrController?action=getGiiss106FixedSIList&refresh=1&tariffCd="
									+$F("hidTariffCd");
		tbgTariffRatesFixedSI._refreshList();
	}
	
	function higherLowerRangeValidation(high, low,id){
		try{
			var result = []; 
			new Ajax.Request(contextPath + "/GIISTariffRatesHdrController", {
				parameters : {action : "highLowValidation",
							  high : unformatValueToString(high),
							  low : unformatValueToString(low),
							  fixedSI : unformatValueToString($F("txtFixedSI")),
							  id : id},
		  		evalScripts: true,
				asynchronous: false,
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						if (response.responseText != "OK"){
							showWaitingMessageBox(response.responseText, "I", function(){
								$(id).clear();
								$(id).focus();
								$(id).value = $(id).getAttribute("lastValidValue");
							});
						}
					}
				}
			});
			return result;
		} catch(e){
			showErrorMessage("higherLowerRangeValidation", e);
		}
	}
//----------------------------------------------------------------------------------------------------------------------------//

	function exitPage(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	}	
	
	
	function cancelGiiss106(){
		if(changeTag == 1 || changeTagDtl == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISS106.afterSave = exitPage;
						saveGiiss106();
					}, function(){
						goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
					}, ""); 
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		}
	}
	
//--------------------------------------------------------------------------------------------------------------------------------//

	$("searchLineLOV").observe("click", function(){
		if($F("txtLineCd") == ""){
			$("txtLineCd").setAttribute("lastValidValue", "");
		}
		showLineLOV(true);
	});
	
	$("txtLineCd").observe("change", function(){
		if (this.value != ""){
			showLineLOV(false);
		}else{
			toggleMcFiFields();
			$("txtLineName").clear();
			$("txtLineCd").setAttribute("lastValidValue", "");
		}
	});
	
	$("searchSublineLOV").observe("click", function(){
		if($F("txtSublineCd") == ""){
			$("txtSublineCd").setAttribute("lastValidValue", "");
		}
		showSublineLOV(true);
	});
	
	$("txtSublineCd").observe("change", function(){
		if (this.value != ""){
			showSublineLOV(false);
		}else{
			$("txtSublineName").clear();
			$("txtSublineCd").setAttribute("lastValidValue", "");
		}
	});
	
	$("searchPerilLOV").observe("click", function(){
		if($F("txtPerilCd") == ""){
			$("txtPerilCd").setAttribute("lastValidValue", "");
		}
		showPerilLOV(true);
	});
	
	$("txtPerilCd").observe("change", function(){
		if (this.value != ""){
			showPerilLOV(false);
		}else{
			$("txtPerilName").clear();
			$("txtPerilCd").setAttribute("lastValidValue", "");
		}
	});
	
	$("searchTariffZoneLOV").observe("click", function(){
		if($F("txtTariffZone") == ""){
			$("txtTariffZone").setAttribute("lastValidValue", "");
		}
		showTariffZoneLOV(true);
	});
	
	$("txtTariffZone").observe("change", function(){
		if (this.value != ""){
			showTariffZoneLOV(false);
		}else{
			$("txtTariffZoneDesc").clear();
			$("txtTariffZone").setAttribute("lastValidValue", "");
		}
	});
	
	$("searchCoverageLOV").observe("click", function(){
		if($F("txtCoverageCd") == ""){
			$("txtCoverageCd").setAttribute("lastValidValue", "");
		}
		showCoverageLOV(true);
	});
	
	$("txtCoverageCd").observe("change", function(){
		if (this.value != ""){
			showCoverageLOV(false);
		}else{
			$("txtCoverageDesc").clear();
			$("txtCoverageCd").setAttribute("lastValidValue", "");
		}
	});
	
	$("searchSublineTypeLOV").observe("click", function(){
		if($F("txtSublineTypeCd") == ""){
			$("txtSublineTypeCd").setAttribute("lastValidValue", "");
		}
		showSublineTypeLOV(true);
	});
	
	$("txtSublineTypeCd").observe("change", function(){
		if (this.value != ""){
			showSublineTypeLOV(false);
		}else{
			$("txtSublineTypeDesc").clear();
			$("txtSublineTypeCd").setAttribute("lastValidValue", "");
		}
	});
	
	$("searchMotortypeLOV").observe("click", function(){
		if($F("txtMotortypeCd") == ""){
			$("txtMotortypeCd").setAttribute("lastValidValue", "");
		}
		showMotortypeLOV(true);
	});
	
	$("txtMotortypeCd").observe("change", function(){
		if (this.value != ""){
			showMotortypeLOV(false);
		}else{
			$("txtMotortypeDesc").clear();
			$("txtMotortypeCd").setAttribute("lastValidValue", "");
		}
	});
	
	$("searchTarfLOV").observe("click", function(){
		showTarfLOV(true);
	});
	
	$("txtTarfCd").observe("change", function(){
		if (this.value != ""){
			showTarfLOV(false);
		}else{
			$("txtTarfDesc").clear();
			$("txtTarfCd").setAttribute("lastValidValue", "");
		}
	});
	
	$("searchConstructionLOV").observe("click", function(){
		showConstructionLOV(true);
	});
	
	$("txtConstructionCd").observe("change", function(){
		if (this.value != ""){
			showConstructionLOV(false);
		}else{
			$("txtConstructionDesc").clear();
			$("txtConstructionCd").setAttribute("lastValidValue", "");
		}
	});
	
	$$("input[name='defaultPremTagRG']").each(function(rb){
		rb.observe("change", function(){
			showTariffRatesDtlItems(rb.value);
			$$("div#tariffRatesDtlFormDiv.rdoOption").each(function(a) {
				$(a).clear();
			});
			changeTagDtl = 0;
		});
	});

//fields------------------------------------------------------------------------------------------------------//	
//     $("txtFixedSI").setAttribute("lastValidValue", "");
// 	$("txtFixedSI").observe("focus", function(){
// 		if (this.value != ""){
// 			lastFixedSI = parseFloat(unformatCurrencyValue(this.value));	
// 			$("txtFixedSI").setAttribute("lastValidValue", parseFloat(unformatCurrencyValue(this.value)));	
// 		}		
// 	});	
	
	$("txtFixedSI").observe("change", function(){
		$("txtHigherRange").clear();
		$("txtLowerRange").clear();
		$("txtHigherRange").setAttribute("lastValidValue", "");
		$("txtLowerRange").setAttribute("lastValidValue", "");
	});
		
// 		var addedSameExists = false;
// 		var deletedSameExists = false;					
		
// 		for(var i=0; i<tbgTariffRatesFixedSI.geniisysRows.length; i++){
// 			if(tbgTariffRatesFixedSI.geniisysRows[i].recordStatus == 0 || tbgTariffRatesFixedSI.geniisysRows[i].recordStatus == 1){								
// 				if(parseFloat(unformatCurrencyValue(tbgTariffRatesFixedSI.geniisysRows[i].fixedSI)) == parseFloat(unformatCurrencyValue($F("txtFixedSI"))) ){
// 					addedSameExists = true;								
// 				}							
// 			} else if(tbgTariffRatesFixedSI.geniisysRows[i].recordStatus == -1){							
// 				if(parseFloat(unformatCurrencyValue(tbgTariffRatesFixedSI.geniisysRows[i].fixedSI)) == parseFloat(unformatCurrencyValue($F("txtFixedSI"))) ){
// 					deletedSameExists = true;
// 				}
// 			}
// 		}

// 		if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
// 			$("txtFixedSI").value = $("txtFixedSI").readAttribute("lastValidValue");
// 			showMessageBox("Fixed Sum Insured already exists.", "E");
// 			return;
// 		} else if(deletedSameExists && !addedSameExists){
// 			this.setAttribute("lastValidValue", this.value);	
// 		}
		
// 		validateFixedSIFieldInput(this.id);
// 	});
	
// 	$("txtFixedPremium1").setAttribute("lastValidValue", "");
// 	$("txtFixedPremium1").observe("focus", function(){
// 		if (this.value != ""){
// 			$("txtFixedPremium1").setAttribute("lastValidValue", parseFloat(unformatCurrencyValue(this.value)));	
// 		}		
// 	});
	
// 	$("txtFixedPremium1").observe("change", function(){
// 		if(this.value != ""){
// 			if(unformatCurrency("txtFixedPremium1") < 0.10 || unformatCurrency("txtFixedPremium1") > 99999999999990.99){
// 				showMessageBox("Invalid Fixed Premium. Valid value should be from 0.10 to 99,999,999,999,990.99.","E");
// 				$("txtFixedPremium1").value = formatCurrency($("txtFixedPremium1").readAttribute("lastValidValue"));
// 				return false;
// 			} else {
// 				$("txtFixedPremium1").value = formatCurrency($("txtFixedPremium1").value);
// 			}	
// 		}
// 	});
	
// 	$("txtHigherRange").setAttribute("lastValidValue", "");
	$("txtHigherRange").observe("focus", function(){
		if (this.value != ""){
			$("txtHigherRange").setAttribute("lastValidValue", unformatValueToString(this.value));	
		}	
	});
	
	$("txtHigherRange").observe("change", function(){
		if(this.value.trim() != ""){
			higherLowerRangeValidation(this.value,$F("txtLowerRange"),this.id);	
		}
	});

// 	$("txtLowerRange").setAttribute("lastValidValue", "");
	$("txtLowerRange").observe("focus", function(){
		if (this.value != ""){
			$("txtLowerRange").setAttribute("lastValidValue", unformatValueToString(this.value));	
		}		
	});
	$("txtLowerRange").observe("change", function(){
		if(this.value.trim() != ""){
			higherLowerRangeValidation($F("txtHigherRange"),this.value,this.id);	
		}
	});
	
// 	$("txtFixedPremium2").setAttribute("lastValidValue", "");
// 	$("txtFixedPremium2").observe("focus", function(){
// 		if (this.value != ""){
// 			$("txtFixedPremium2").setAttribute("lastValidValue", parseFloat(unformatCurrencyValue(this.value)));	
// 		}		
// 	});
// 	$("txtFixedPremium2").observe("change", function(){
// 		if(this.value != ""){
// 			if(unformatCurrency("txtFixedPremium2") > 9999999999.99 || unformatCurrency("txtFixedPremium2") < 0){
// 				showMessageBox("Invalid Fixed Premium. Valid value should be from 0.00 to 9,999,999,999.99.","E");
// 				$("txtFixedPremium2").value = formatCurrency($("txtFixedPremium2").readAttribute("lastValidValue"));
// 				return false;
// 			} else {
// 				$("txtFixedPremium2").value = formatCurrency($("txtFixedPremium2").value);
// 			}
// 		}
// 	});
	
// 	$("txtDiscountRate").setAttribute("lastValidValue", "");
// 	$("txtDiscountRate").observe("focus", function(){
// 		if (this.value != ""){
// 			$("txtDiscountRate").setAttribute("lastValidValue", parseFloat(unformatCurrencyValue(this.value)));	
// 		}		
// 	});
// 	$("txtDiscountRate").observe("change", function(){
// 		if(this.value != ""){
// 			if(unformatCurrency("txtDiscountRate") > 999.999999999){
// 				showMessageBox("Invalid Discount Rate. Valid value should be from 0.00 to 999.999999999.","E");
// 				$("txtDiscountRate").value = formatToNthDecimal($("txtDiscountRate").readAttribute("lastValidValue"),9);
// 				return false;
// 			} else {
// 				$("txtDiscountRate").value = formatToNthDecimal($("txtDiscountRate").value,9);
// 			}
// 		}
// 	});
	
// 	$("txtSIDeductible").setAttribute("lastValidValue", "");
// 	$("txtSIDeductible").observe("focus", function(){
// 		if (this.value != ""){
// 			$("txtSIDeductible").setAttribute("lastValidValue", parseFloat(unformatCurrencyValue(this.value)));	
// 		}		
// 	});
// 	$("txtSIDeductible").observe("change", function(){
// 		if(this.value != ""){
// 			if(unformatCurrency("txtSIDeductible") > 99999999999999.99 || unformatCurrency("txtSIDeductible") < 0){
// 				showMessageBox("Invalid Sum Insured Deductible. Valid value should be from 0.00 to 99,999,999,999,999.99.","E");
// 				$("txtSIDeductible").value = formatCurrency($("txtSIDeductible").readAttribute("lastValidValue"));
// 				return false;
// 			} else {
// 				$("txtSIDeductible").value = formatCurrency($("txtSIDeductible").value);
// 			}
// 		}
// 	});
	
// 	$("txtAdditionalPremium").setAttribute("lastValidValue", "");
// 	$("txtAdditionalPremium").observe("focus", function(){
// 		if (this.value != ""){
// 			$("txtAdditionalPremium").setAttribute("lastValidValue", parseFloat(unformatCurrencyValue(this.value)));	
// 		}		
// 	});
// 	$("txtAdditionalPremium").observe("change", function(){
// 		if(this.value != ""){
// 			if(unformatCurrency("txtAdditionalPremium") > 9999999999.99){
// 				showMessageBox("Invalid Additional Premium. Valid value should be from 0.00 to 9,999,999,999.99.","E");
// 				$("txtAdditionalPremium").value = formatCurrency($("txtAdditionalPremium").readAttribute("lastValidValue"));
// 				return false;
// 			} else {
// 				$("txtAdditionalPremium").value = formatCurrency($("txtAdditionalPremium").value);
// 			}
// 		}
// 	});
	
// 	$("txtExcessRate").setAttribute("lastValidValue", "");
// 	$("txtExcessRate").observe("focus", function(){
// 		if (this.value != ""){
// 			$("txtExcessRate").setAttribute("lastValidValue", parseFloat(unformatCurrencyValue(this.value)));	
// 		}		
// 	});
// 	$("txtExcessRate").observe("change", function(){
// 		if(this.value != ""){
// 			if(unformatCurrency("txtExcessRate") > 999.999999){
// 				showMessageBox("Invalid Excess Rate. Valid value should be from 0.00 to 999.999999.","E");
// 				$("txtExcessRate").value = formatToNthDecimal($("txtExcessRate").readAttribute("lastValidValue"),6);
// 				return false;
// 			} else {
// 				$("txtExcessRate").value = formatToNthDecimal($("txtExcessRate").value,6);
// 			}
// 		}
// 	});
	
// 	$("txtTariffRate").setAttribute("lastValidValue", "");
// 	$("txtTariffRate").observe("focus", function(){
// 		if (this.value != ""){
// 			$("txtTariffRate").setAttribute("lastValidValue", parseFloat(unformatCurrencyValue(this.value)));	
// 		}		
// 	});
// 	$("txtTariffRate").observe("change", function(){
// 		if(this.value != ""){
// 			if(unformatCurrency("txtTariffRate") > 999.999999){
// 				showMessageBox("Invalid Tariff Rate. Valid value should be from 0.00 to 999.999999.","E");
// 				$("txtTariffRate").value = formatToNthDecimal($("txtTariffRate").readAttribute("lastValidValue"),6);
// 				return false;
// 			} else {
// 				$("txtTariffRate").value = formatToNthDecimal($("txtTariffRate").value,6);
// 			}
// 		}
// 	});
	
// 	$("txtLoadingRate").setAttribute("lastValidValue", "");
// 	$("txtLoadingRate").observe("focus", function(){
// 		if (this.value != ""){
// 			$("txtLoadingRate").setAttribute("lastValidValue", parseFloat(unformatCurrencyValue(this.value)));	
// 		}		
// 	});
// 	$("txtLoadingRate").observe("change", function(){
// 		if(this.value != ""){
// 			if(unformatCurrency("txtLoadingRate") > 999.999999999){
// 				showMessageBox("Invalid Loading Rate. Valid value should be from 0.00 to 999.999999999.","E");
// 				$("txtLoadingRate").value = formatToNthDecimal($("txtLoadingRate").readAttribute("lastValidValue"),9);
// 				return false;
// 			} else {
// 				$("txtLoadingRate").value = formatToNthDecimal($("txtLoadingRate").value,9);
// 			}
// 		}
// 	});
	
// 	$("txtFixedPremium3").setAttribute("lastValidValue", "");
// 	$("txtFixedPremium3").observe("focus", function(){
// 		if (this.value != ""){
// 			$("txtFixedPremium3").setAttribute("lastValidValue", parseFloat(unformatCurrencyValue(this.value)));	
// 		}		
// 	});
// 	$("txtFixedPremium3").observe("change", function(){
// 		if(this.value != ""){
// 			if(unformatCurrency("txtFixedPremium2") > 9999999999.99){
// 				showMessageBox("Invalid Fixed Premium. Valid value should be from 0.00 to 9,999,999,999.99.","E");
// 				$("txtFixedPremium3").value = formatCurrency($("txtFixedPremium3").readAttribute("lastValidValue"));
// 				return false;
// 			} else {
// 				$("txtFixedPremium3").value = formatCurrency($("txtFixedPremium3").value);
// 			}
// 		}
// 	});
	
// 	$$("div#withCompDiv input, div#withCompDiv textarea, div#fixedPremDiv input, div#fixedPremDiv textarea").each(function(txt){
// 		$(txt).setAttribute("lastValidValue", $F(txt));
// 		$(txt).observe("change", function(){
// 			changeTagDtl = 1;
// 			changeTag = 1;
// 			changeTagFunc = saveGiiss106;
// 		});
// 	});
	
	$("editRemarksDtl").observe("click", function(){
		showOverlayEditor("txtRemarksDtl", 4000, $("txtRemarksDtl").hasAttribute("readonly"));
	});
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarksHdr", 4000, $("txtRemarksHdr").hasAttribute("readonly"));
	});
	
	disableButton("btnDeleteHdr");
	disableButton("btnDeleteFixedSI");
	
	$("btnSave").observe("click", saveGiiss106);
	$("btnCancel").observe("click", cancelGiiss106);
	$("btnAddHdr").observe("click", valAddHdrRec);
	$("btnDeleteHdr").observe("click", valDeleteHdrRec);
	
	$("btnAddFixedSI").observe("click", function(){
		if (checkAllRequiredFieldsInDiv("fixedSIDiv")){
			validPrevAmt();
		}
	});
	$("btnDeleteFixedSI").observe("click", deleteFixedSIRec);
	
	$("tariffRatesExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	
	
	showTariffRatesDtlItems(2);
	toggleMcFiFields();
	toggleTariffRatesDtlFields(false);
	initializeAll();
	
	$("txtLineCd").focus();	
	
	function getAllRecord(){
		try{
			var result = []; 
			new Ajax.Request(contextPath + "/GIISTariffRatesHdrController", {
				parameters : {action : "getGiiss106AllRec"},
		  		evalScripts: true,
				asynchronous: false,
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						result = JSON.parse((response.responseText).replace(/\\\\/g,"\\"));
						result = result.rows;
					}
				}
			});
			return result;
		} catch(e){
			showErrorMessage("getAllDtlRecord", e);
		}
	}
	
	function getAllDtlRecord(){
		try{
			var result = []; 
			new Ajax.Request(contextPath + "/GIISTariffRatesHdrController", {
				parameters : {action : "getGiiss106AllFixedSIList",
							  tariffCd : $F("hidTariffCd")},
		  		evalScripts: true,
				asynchronous: false,
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						result = JSON.parse((response.responseText).replace(/\\\\/g,"\\"));
						result = result.rows;
					}
				}
			});
			return result;
		} catch(e){
			showErrorMessage("getAllDtlRecord", e);
		}
	}
}catch(e){
	showErrorMessage("Page Error", e);
}
</script>