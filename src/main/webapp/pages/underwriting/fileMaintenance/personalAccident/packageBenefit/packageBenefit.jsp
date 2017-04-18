<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss120MainDiv" name="giiss120MainDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Package Benefit Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
	   			<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss120" name="giiss120">	
		<div class="sectionDiv">
			<table align="center" style="margin: 15px auto;">
				<tr>
					<td><label for="txtLineCd" style="float: right; margin: 0 5px 2px 0;">Line</label></td>
					<td>
						<span class="lovSpan required" style="width: 200px; margin: 0px;">
							<input type="text" id="txtLineCd" ignoreDelKey="true" style="width: 175px; float: left; border: none; height: 14px; margin: 0;" class="required allCaps" tabindex="101" lastValidValue="" maxlength="2"/> 
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgLineSearch" alt="Go" style="float: right;" tabindex="102"/>
						</span>
					</td>
					<td style="padding-left: 100px;"><label for="txtLineCd" style="float: right; margin: 0 5px 2px 0;">Subline</label></td>
					<td>
						<span class="lovSpan required" style="width: 200px; margin: 0px;">
							<input type="text" id="txtSublineCd" ignoreDelKey="true" style="width: 175px; float: left; border: none; height: 14px; margin: 0;" class="required allCaps" tabindex="103" lastValidValue="" maxlength="7"/> 
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSublineSearch" alt="Go" style="float: right;" tabindex="104"/>
						</span>
					</td>
				</tr>
			</table>
		</div>	
		<div class="sectionDiv">
			<div id="giiss120TableDiv" style="padding-top: 10px;">
				<div id="giiss120Table" style="height: 205px; margin-left: 190px;"></div>
			</div>
			<div align="center" id="giiss120FormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Plan</td>
						<td class="leftAligned" colspan="3">
							<input id="txtPackBenCd" type="hidden">
							<input id="txtPackageCd" type="text" class="required" style="width: 533px;" tabindex="105" maxlength="20">
						</td>
					</tr>	
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtPackageBenefitUserId" type="text" class="readOnly" style="width: 200px;" readonly="readonly" tabindex="106"></td>
						<td width="" class="rightAligned" style="padding-left: 47px">Last Update</td>
						<td class="leftAligned"><input id="txtPackageBenefitLastUpdate" type="text" class="readOnly" style="width: 200px;" readonly="readonly" tabindex="107"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px;" align = "center">
				<input type="button" class="button" id="btnAddPackageBenefit" value="Add" tabindex="105">
				<input type="button" class="button" id="btnDeletePackageBenefit" value="Delete" tabindex="106">
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Package Benefit Detail Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label name="gro" style="margin-left: 5px;">Hide</label> 
			</span>
	   	</div>
	</div>	
	<div id="giiss120Div2" name="giiss120Div2">		
		<div class="sectionDiv">
			<div id="giiss120TableDiv2" style="padding-top: 10px;">
				<div id="giiss120Table2" style="height: 340px; margin-left: 10px;"></div>
			</div>
			<div id="giiss120TotalsDiv2">
				<table align="right"  style="margin-top: 5px; margin-right: 10px;">
					<tr>
						<td class="rightAligned">Premium Amount</td>
						<td class="leftAligned">
							<input id="txtTotalPremAmt" type="text" style="width: 200px; text-align: right;" readonly="readonly">
						</td>
					</tr>
				</table>
			</div>
			<div align="center" id="giiss120FormDiv2">
				<table style="margin-top: 45px;">
					<tr>
						<td class="rightAligned">Peril Name</td>
						<td class="leftAligned">
							<input id="txtPerilCd" type="hidden" lastValidValue="">
							<span class="lovSpan required" style="width: 206px; margin: 0px;">
								<input type="text" id="txtPerilName" ignoreDelKey="true" style="width: 180px; float: left; border: none; height: 14px; margin: 0;" class="required" tabindex="201" lastValidValue="" maxlength="20"/> 
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgPerilNameSearch" alt="Go" style="float: right;" tabindex="202"/>
							</span>
						</td>
						<td colspan="2">
							<input type="checkbox" style="float: left; margin-right: 7px; margin-top: 3px; margin-left: 121px;" title="Aggregate" id="chkAggregateSw">
							<label style="float: left; margin-top: 3px;" for="chkAggregateSw" title="Aggregate">Aggregate</label>
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Premium %</td>
						<td class="leftAligned">
							<input id="txtPremPct" type="text" class="nthDecimal2" style="width: 200px;" tabindex="203" maxlength="13" errorMsg = "Invalid Premium %. Valid value should be from 0.000000000 to 100.000000000." min="0" max="100">
						</td>
						<td width="" class="rightAligned">Premium Amount</td>
						<td class="leftAligned">
							<input id="txtPremAmt" type="text" class="money4" style="width: 200px;" tabindex="208" maxlength="17" errorMsg = "Invalid Premium Amount. Valid value should be from 0.00 to 99,999,999,999,999.99." min="0" max="99999999999999.99">
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">No. of Days</td>
						<td class="leftAligned">
							<input id="txtNoOfDays" type="text" class="integerNoNegativeUnformattedNoComma" style="width: 200px; text-align: right;" tabindex="204" maxlength="5">
						</td>
						<td width="" class="rightAligned">Benefit</td>
						<td class="leftAligned">
							<input id="txtBenefit" type="text" class="money4" style="width: 200px;" tabindex="209" maxlength="17" errorMsg = "Invalid Benefit. Valid value should be from 0.00 to 99,999,999,999,999.99." min="0" max="99999999999999.99">
						</td>
					</tr>					
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksPackageBenefitDtlDiv" name="remarksPackageBenefitDtlDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtPackageBenefitDtlRemarks" name="txtPackageBenefitDtlRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="205"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editPackageBenefitDtlRemarks"  tabindex="206"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtPackageBenefitDtlUserId" type="text" class="readOnly" style="width: 200px;" readonly="readonly" tabindex="207"></td>
						<td width="" class="rightAligned" style="padding-left: 47px">Last Update</td>
						<td class="leftAligned"><input id="txtPackageBenefitDtlLastUpdate" type="text" class="readOnly" style="width: 200px;" readonly="readonly" tabindex="210"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px;" align = "center">
				<input type="button" class="button" id="btnAddPackageBenefitDtl" value="Add" tabindex="107">
				<input type="button" class="button" id="btnDeletePackageBenefitDtl" value="Delete" tabindex="108">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="109">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="110">
</div>



<script type="text/javascript">	
	setModuleId("GIISS120");
	setDocumentTitle("Package Benefit Maintenance");
	initializeAll();
	initializeAccordion();
	initializeAllMoneyFields();
	var rowIndexPackageBenefit = -1;
	var rowIndexPackageBenefitDtl = -1;
	var divArray = [];
	var objGIISS120 = {};
	var objAllRecord = [];
	objGIISS120.exitPage = null;
	objGIISS120.enterQueryPage = null;
	
	resetAllFields();

	function resetAllFields() {
		changeTag = 0;
		objAllRecord = [];
		changeTagPackageBenefit = 0;
		changeTagPackageBenefitDtl = 0;
		rowIndexPackageBenefit = -1;
		rowIndexPackageBenefitDtl = -1;
		objGIISS120.exitPage = null;
		objGIISS120.enterQueryPage = null;
		
	 	showToolbarButton("btnToolbarSave");
		hideToolbarButton("btnToolbarPrint");
		disableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
		disableButton("btnAddPackageBenefit");
		disableButton("btnDeletePackageBenefit");
		disableButton("btnDeletePackageBenefitDtl");
		disableButton("btnAddPackageBenefitDtl");
		$("txtLineCd").readOnly = false;
		enableSearch("imgLineSearch");
		$("txtSublineCd").readOnly = true;
		disableSearch("imgSublineSearch");
		divArray = ["giiss120FormDiv","giiss120FormDiv2"];
		enableDisableFields(divArray, "disable");
		$("txtLineCd").clear();
		$("txtSublineCd").clear();
		$("txtPerilName").setAttribute("lastValidValue", "");
		$("txtPerilCd").setAttribute("lastValidValue", "");
		$("txtLineCd").setAttribute("lastValidValue", "");
		$("txtSublineCd").setAttribute("lastValidValue", "");
	}
 	
 	function enableDisableFields(divArray,toDo){
		try{
			if (divArray!= null){
				for ( var i = 0; i < divArray.length; i++) {
					$$("div#"+divArray[i]+" input[type='text'], div#"+divArray[i]+" textarea, div#"+divArray[i]+" input[type='hidden']").each(function (b) {
						toDo == "enable" ?  $(b).readOnly= false : $(b).readOnly= true;
						if (toDo == "disable"){
							$(b).clear();
						}
						if($(b).hasClassName('readOnly')){
							$(b).readOnly= true;
						}
					});
					$$("div#"+divArray[i]+" input[type='checkbox']").each(function (b) {
						$(b).checked = false;
						toDo == "enable" ?  $(b).enable() : $(b).disable();
					});
					$$("div#"+divArray[i]+" img").each(function (img) {
						var src = img.src;
						var id = img.id;
						if(nvl(img, null) != null){
							if(src.include("searchIcon.png")){
								toDo == "enable" ? enableSearch(img) : disableSearch(img);
							}else if(src.include("but_calendar.gif")){
								toDo == "enable" ? enableDate(img) : disableDate(img); 
							}
						}
					});
				}
			}
		}catch(e){
			showErrorMessage("enableDisableFields", e);
		}
	}
	
	function saveGiiss120(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setGIISPackageBenefit = getAddedAndModifiedJSONObjects(tbgGIISPackageBenefit.geniisysRows);
		var delGIISPackageBenefit = getDeletedJSONObjects(tbgGIISPackageBenefit.geniisysRows);
		
		var setGIISPackageBenefitDtl = getAddedAndModifiedJSONObjects(tbgGIISPackageBenefitDtl.geniisysRows);
		var delGIISPackageBenefitDtl = getDeletedJSONObjects(tbgGIISPackageBenefitDtl.geniisysRows);
		
		new Ajax.Request(contextPath+"/GIISPackageBenefitController", {
			method: "POST",
			parameters : {action : "saveGiiss120",
						  setGIISPackageBenefit : prepareJsonAsParameter(setGIISPackageBenefit),
						  delGIISPackageBenefit : prepareJsonAsParameter(delGIISPackageBenefit),
						  setGIISPackageBenefitDtl : prepareJsonAsParameter(setGIISPackageBenefitDtl),
						  delGIISPackageBenefitDtl : prepareJsonAsParameter(delGIISPackageBenefitDtl)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					tbgGIISPackageBenefit.keys.releaseKeys();
					tbgGIISPackageBenefitDtl.keys.releaseKeys();
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS120.exitPage != null) {
							objGIISS120.exitPage();
						}else if(objGIISS120.enterQueryPage != null){
							objGIISS120.enterQueryPage();
						}else {
							tbgGIISPackageBenefit._refreshList();
						}
					});
					changeTag = 0;
					changeTagPackageBenefit = 0;
					changeTagPackageBenefitDtl = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiiss120);
	
	//GIIS_PACKAGE_BENEFIT tablegrid...
	var origPackageCd = null;
	var objCurrGIISPackageBenefit = null;
	objGIISS120.giiss120PackageBenefit = JSON.parse('${jsonGIISPackageBenefit}');
	
	var giiss120PackageBenefitTable = {
			url : contextPath + "/GIISPackageBenefitController?action=showGiiss120&refresh=1&mode=packageBenefit",
			id: "giisPackageBenefit",
			options : {
				width : '540px',
				pager : {},
				beforeClick: function(){
					if(changeTagPackageBenefitDtl == 1 ){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
				},
				onCellFocus : function(element, value, x, y, id){
					rowIndexPackageBenefit = y;
					objCurrGIISPackageBenefit = tbgGIISPackageBenefit.geniisysRows[y];
					setFieldValues(objCurrGIISPackageBenefit,"giisPackageBenefit");
					showGIISPackageBenefitDtl(true);
					tbgGIISPackageBenefit.keys.removeFocus(tbgGIISPackageBenefit.keys._nCurrentFocus, true);
					tbgGIISPackageBenefit.keys.releaseKeys();
					$("txtPackageCd").focus();
				},
				onRemoveRowFocus : function(){
					rowIndexPackageBenefit = -1;
					setFieldValues(null,"giisPackageBenefit");
					showGIISPackageBenefitDtl(false);
					tbgGIISPackageBenefit.keys.removeFocus(tbgGIISPackageBenefit.keys._nCurrentFocus, true);
					tbgGIISPackageBenefit.keys.releaseKeys();
					$("txtPackageCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndexPackageBenefit = -1;
						setFieldValues(null,"giisPackageBenefit");
						showGIISPackageBenefitDtl(false);
						tbgGIISPackageBenefit.keys.removeFocus(tbgGIISPackageBenefit.keys._nCurrentFocus, true);
						tbgGIISPackageBenefit.keys.releaseKeys();
					}
				},
				beforeSort : function(){
					if(changeTagPackageBenefit == 1 || changeTagPackageBenefitDtl == 1 ){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
				},
				onSort: function(){
					rowIndexPackageBenefit = -1;
					setFieldValues(null,"giisPackageBenefit");
					showGIISPackageBenefitDtl(false);
					tbgGIISPackageBenefit.keys.removeFocus(tbgGIISPackageBenefit.keys._nCurrentFocus, true);
					tbgGIISPackageBenefit.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndexPackageBenefit = -1;
					setFieldValues(null,"giisPackageBenefit");
					showGIISPackageBenefitDtl(false);
					tbgGIISPackageBenefit.keys.removeFocus(tbgGIISPackageBenefit.keys._nCurrentFocus, true);
					tbgGIISPackageBenefit.keys.releaseKeys();
				},				
				prePager: function(){
					if(changeTagPackageBenefit == 1 || changeTagPackageBenefitDtl == 1 ){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
					rowIndexPackageBenefit = -1;
					setFieldValues(null,"giisPackageBenefit");
					showGIISPackageBenefitDtl(false);
					tbgGIISPackageBenefit.keys.removeFocus(tbgGIISPackageBenefit.keys._nCurrentFocus, true);
					tbgGIISPackageBenefit.keys.releaseKeys();
				},
				checkChanges: function(){
					return (changeTagPackageBenefit == 1 || changeTagPackageBenefitDtl == 1  ? true : false);
				},
				masterDetailRequireSaving: function(){
					return (changeTagPackageBenefit == 1 || changeTagPackageBenefitDtl == 1  ? true : false);
				},
				masterDetailValidation: function(){
					return (changeTagPackageBenefit == 1 || changeTagPackageBenefitDtl == 1  ? true : false);
				},
				masterDetail: function(){
					return (changeTagPackageBenefit == 1 || changeTagPackageBenefitDtl == 1  ? true : false);
				},
				masterDetailSaveFunc: function() {
					return (changeTagPackageBenefit == 1 || changeTagPackageBenefitDtl == 1  ? true : false);
				},
				masterDetailNoFunc: function(){
					return (changeTagPackageBenefit == 1 || changeTagPackageBenefitDtl == 1  ? true : false);
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
					id : "packBenCd",
					width : '0',
					visible: false
				},
				{
					id : 'packageCd',
					title : 'Plan',
					filterOption : true,
					width : '500px'				
				},
				{
					id : 'lineCd',
					width : '0',
					visible: false
				},
				{
					id : 'sublineCd',
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
			rows : objGIISS120.giiss120PackageBenefit.rows
		};

		tbgGIISPackageBenefit = new MyTableGrid(giiss120PackageBenefitTable);
		tbgGIISPackageBenefit.pager = objGIISS120.giiss120PackageBenefit;
		tbgGIISPackageBenefit.render("giiss120Table");
		tbgGIISPackageBenefit.afterRender = function(){
			objAllRecord = getAllRecord();
		};
	
	//GIIS_PACKAGE_BENEFIT_DTL tablegrid...
	var objCurrGIISPackageBenefitDtl = null;
	objGIISS120.giiss120PackageBenefitDtl = [];
	
	var giiss120PackageBenefitDtlTable = {
			url : contextPath + "/GIISPackageBenefitController?action=showGiiss120&refresh=1",
			id:"giisPackageBenefitDtl",
			options : {
				width : '900px',
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndexPackageBenefitDtl = y;
					objCurrGIISPackageBenefitDtl = tbgGIISPackageBenefitDtl.geniisysRows[y];
					setFieldValues(objCurrGIISPackageBenefitDtl,"giisPackageBenefitDtl");
					tbgGIISPackageBenefitDtl.keys.removeFocus(tbgGIISPackageBenefitDtl.keys._nCurrentFocus, true);
					tbgGIISPackageBenefitDtl.keys.releaseKeys();
					$("txtPerilName").focus();
				},
				onRemoveRowFocus : function(){
					rowIndexPackageBenefitDtl = -1;
					setFieldValues(null,"giisPackageBenefitDtl");
					tbgGIISPackageBenefitDtl.keys.removeFocus(tbgGIISPackageBenefitDtl.keys._nCurrentFocus, true);
					tbgGIISPackageBenefitDtl.keys.releaseKeys();
					$("txtPerilCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndexPackageBenefitDtl = -1;
						setFieldValues(null,"giisPackageBenefitDtl");
						tbgGIISPackageBenefitDtl.keys.removeFocus(tbgGIISPackageBenefitDtl.keys._nCurrentFocus, true);
						tbgGIISPackageBenefitDtl.keys.releaseKeys();
					}
				},
				beforeSort : function(){
					if(changeTagPackageBenefitDtl == 1 ){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
				},
				onSort: function(){
					rowIndexPackageBenefitDtl = -1;
					setFieldValues(null,"giisPackageBenefitDtl");
					tbgGIISPackageBenefitDtl.keys.removeFocus(tbgGIISPackageBenefitDtl.keys._nCurrentFocus, true);
					tbgGIISPackageBenefitDtl.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndexPackageBenefitDtl = -1;
					setFieldValues(null,"giisPackageBenefitDtl");
					tbgGIISPackageBenefitDtl.keys.removeFocus(tbgGIISPackageBenefitDtl.keys._nCurrentFocus, true);
					tbgGIISPackageBenefitDtl.keys.releaseKeys();
				},				
				prePager: function(){
					if(changeTagPackageBenefitDtl == 1 ){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
					rowIndexPackageBenefitDtl = -1;
					setFieldValues(null,"giisPackageBenefitDtl");
					tbgGIISPackageBenefitDtl.keys.removeFocus(tbgGIISPackageBenefitDtl.keys._nCurrentFocus, true);
					tbgGIISPackageBenefitDtl.keys.releaseKeys();
				},
				checkChanges: function(){
					return (changeTagPackageBenefitDtl == 1  ? true : false);
				},
				masterDetailRequireSaving: function(){
					return (changeTagPackageBenefitDtl == 1  ? true : false);
				},
				masterDetailValidation: function(){
					return (changeTagPackageBenefitDtl == 1  ? true : false);
				},
				masterDetail: function(){
					return (changeTagPackageBenefitDtl == 1  ? true : false);
				},
				masterDetailSaveFunc: function() {
					return (changeTagPackageBenefitDtl == 1  ? true : false);
				},
				masterDetailNoFunc: function(){
					return (changeTagPackageBenefitDtl == 1  ? true : false);
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
					id : "packBenCd",
					width : '0',
					visible: false
				},
				{
					id : "perilCd",
					width : '0',
					visible: false
				},
				{
					id: 'aggregateSw',
					title: '&#160;A',
	            	width: '23px',
	            	altTitle: 'Aggregate',
	            	filterOption : true,
	            	filterOptionType : 'checkbox',
	            	titleAlign: 'center',
	            	editable: false,
	            	editor: new MyTableGrid.CellCheckbox({
			            getValueOf: function(value){
			            	return value ? "Y" : "N";
		            	}
	            	})
				},
				{
					id : "perilName",
					title : "Peril Name",
					filterOption : true,
					width : '200px'
				},
				{
					id : 'premPct',
					title : 'Premium %',
					filterOption : true,
					filterOptionType : 'numberNoNegative',
					geniisysClass : 'rate',
					titleAlign: 'right',
					align: 'right',
					width : '155px'				
				},
				{
					id : 'premAmt',
					title : 'Premium Amount',
					filterOption : true,
					filterOptionType : 'numberNoNegative',
					geniisysClass : 'money',
					titleAlign: 'right',
					align: 'right',
					width : '155px'				
				},
				{
					id : 'noOfDays',
					title : 'No. of Days',
					filterOption : true,
					filterOptionType : 'integerNoNegative',
					titleAlign: 'right',
					align: 'right',
					width : '155px'				
				},
				{
					id : 'benefit',
					title : 'Benefit',
					filterOption : true,
					filterOptionType : 'numberNoNegative',
					geniisysClass : 'money',
					titleAlign: 'right',
					align: 'right',
					width : '155px'				
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
			rows : []
		};

		tbgGIISPackageBenefitDtl = new MyTableGrid(giiss120PackageBenefitDtlTable);
		tbgGIISPackageBenefitDtl.render("giiss120Table2");
		tbgGIISPackageBenefitDtl.afterRender = function(){
			var amtTotal = 0;
			if(tbgGIISPackageBenefitDtl.geniisysRows.length != 0){
				amtTotal=nvl(tbgGIISPackageBenefitDtl.geniisysRows[0].totalPremAmt,0);
			}
			$("txtTotalPremAmt").value = formatCurrency(amtTotal);
		};
		
		function computeTotalAmountInTable(val1,val2,mode) {
			try {
				var result = "0.00"; 
				new Ajax.Request(contextPath + "/GIISPackageBenefitController", {
					parameters : {action : "computeTotalAmount",
						          total : unformatValueToString($F("txtTotalPremAmt")),
						          val1 : nvl(val1,"0"),
						          val2 : nvl(val2,"0"),
						          mode : mode},
			  		evalScripts: true,
					asynchronous: false,
					onComplete : function(response){
						hideNotice();
						if(checkErrorOnResponse(response)){
							result = response.responseText;
						}
					}
				});
				$("txtTotalPremAmt").value = formatCurrency(result);
			} catch (e) {
				showErrorMessage("computeTotalAmountInTable", e);
			}
		}
		
	function showGIISS120LineLOV(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getGiiss120LineLOV",
							filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : ""),
							page : 1},
			title: "List of Lines",
			width: 500,
			height: 400,
			columnModel : [ {
								id: "lineCd",
								title: "Line Code",
								width : '100px'
							}, {
								id : "lineName",
								title : "Line Name",
								width : '360px'
							} ],
				autoSelectOneRecord: true,
				filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : ""),
				onSelect: function(row) {
					$("txtLineCd").value = unescapeHTML2(row.lineCd);
					$("txtLineCd").setAttribute("lastValidValue", unescapeHTML2(row.lineCd));
					$("txtSublineCd").clear();
					$("txtSublineCd").readOnly = false;
					enableSearch("imgSublineSearch");
					$("txtSublineCd").focus();
					enableToolbarButton("btnToolbarEnterQuery");
				},
				onCancel: function (){
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	function showGIISS120SublineLOV(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getGiiss120SublineLOV",
				            lineCd : $F("txtLineCd"),
							filterText : ($("txtSublineCd").readAttribute("lastValidValue").trim() != $F("txtSublineCd").trim() ? $F("txtSublineCd").trim() : ""),
							page : 1},
			title: "List of Sublines",
			width: 500,
			height: 400,
			columnModel : [ {
								id: "sublineCd",
								title: "Subline Code",
								width : '100px'
							}, {
								id : "sublineName",
								title : "Subline Name",
								width : '360px'
							} ],
				autoSelectOneRecord: true,
				filterText : ($("txtSublineCd").readAttribute("lastValidValue").trim() != $F("txtSublineCd").trim() ? $F("txtSublineCd").trim() : ""),
				onSelect: function(row) {
					$("txtSublineCd").value = unescapeHTML2(row.sublineCd);
					$("txtSublineCd").setAttribute("lastValidValue", unescapeHTML2(row.sublineCd));
					enableToolbarButton("btnToolbarExecuteQuery");
				},
				onCancel: function (){
					$("txtSublineCd").value = $("txtSublineCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtSublineCd").value = $("txtSublineCd").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	function showGIISS120PerilLOV(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getGiiss120PerilLOV",
				            lineCd : $F("txtLineCd"),
				            sublineCd : $F("txtSublineCd"),
							filterText : ($("txtPerilName").readAttribute("lastValidValue").trim() != $F("txtPerilName").trim() ? $F("txtPerilName").trim() : ""),
							page : 1},
			title: "List of Perils",
			width: 500,
			height: 400,
			columnModel : [ {
								id: "perilCd",
								title: "Peril Code",
								width : '100px',
								align : 'right',
								titleAlign : 'right'
							}, {
								id : "perilName",
								title : "Peril Name",
								width : '360px'
							} ],
				autoSelectOneRecord: true,
				filterText : ($("txtPerilName").readAttribute("lastValidValue").trim() != $F("txtPerilName").trim() ? $F("txtPerilName").trim() : ""),
				onSelect: function(row) {
					$("txtPerilCd").value = unescapeHTML2(row.perilCd);
					$("txtPerilName").value = unescapeHTML2(row.perilName);
					$("txtPerilCd").setAttribute("lastValidValue", row.perilCd);
					$("txtPerilName").setAttribute("lastValidValue", unescapeHTML2(row.perilName));
				},
				onCancel: function (){
					$("txtPerilCd").value = $("txtPerilCd").readAttribute("lastValidValue");
					$("txtPerilName").value = $("txtPerilName").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtPerilCd").value = $("txtPerilCd").readAttribute("lastValidValue");
					$("txtPerilName").value = $("txtPerilName").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
		
	function setFieldValues(rec,mode){
		try{
			if (mode == "giisPackageBenefit") {
				$("txtPackageCd").value = (rec == null ? "" : unescapeHTML2(rec.packageCd));
				$("txtPackageCd").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.packageCd)));
				$("txtPackBenCd").value = (rec == null ? "" : rec.packBenCd);
				$("txtPackageBenefitUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
				$("txtPackageBenefitLastUpdate").value = (rec == null ? "" : rec.lastUpdate);

				origPackageCd = (rec == null ? "" : unescapeHTML2(rec.packageCd));
				rec == null ? $("btnAddPackageBenefit").value = "Add" : $("btnAddPackageBenefit").value = "Update";
				rec == null ? disableButton("btnDeletePackageBenefit") : enableButton("btnDeletePackageBenefit");
				objCurrGIISPackageBenefit = rec;
			} else if(mode == "giisPackageBenefitDtl") {
				$("txtPerilCd").value = (rec == null ? "" : unescapeHTML2(rec.perilCd));
				$("txtPerilCd").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.perilCd)));
				$("txtPerilName").value = (rec == null ? "" : unescapeHTML2(rec.perilName));
				$("txtPremPct").value = (rec == null ? "" : formatToNthDecimal(rec.premPct,9));
				$("txtPremAmt").value = (rec == null ? "" :formatCurrency(rec.premAmt));
				$("txtNoOfDays").value = (rec == null ? "" : rec.noOfDays);
				$("txtBenefit").value = (rec == null ? "" : formatCurrency(rec.benefit));
				$("chkAggregateSw").checked = (rec == null ? false : rec.aggregateSw == 'Y' ? true : false);
				$("txtPackageBenefitDtlRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
				$("txtPackageBenefitDtlUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
				$("txtPackageBenefitDtlLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
				
				rec == null ? $("btnAddPackageBenefitDtl").value = "Add" : $("btnAddPackageBenefitDtl").value = "Update";
				if (rowIndexPackageBenefit >= 0) {
					rec == null ? $("txtPerilName").readOnly = false : $("txtPerilName").readOnly = true;
					rec == null ? enableSearch("imgPerilNameSearch") : disableSearch("imgPerilNameSearch");
				}
				rec == null ? disableButton("btnDeletePackageBenefitDtl") : enableButton("btnDeletePackageBenefitDtl");
				objCurrGIISPackageBenefitDtl = rec;
			} 
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}

	function showGIISPackageBenefitDtl(cond) {
		try{
			if (cond) {
				tbgGIISPackageBenefitDtl.url = contextPath + "/GIISPackageBenefitController?action=showGiiss120&refresh=1&mode=giisPackageBenefitDtl&lineCd="+encodeURIComponent($F("txtLineCd"))
				 																																  +"&packBenCd="+$F("txtPackBenCd");
				tbgGIISPackageBenefitDtl._refreshList();
				enableButton("btnAddPackageBenefitDtl");
				enableDisableFields(["giiss120FormDiv2"], "enable");
			} else {
				tbgGIISPackageBenefitDtl.url = contextPath + "/GIISPackageBenefitController?action=showGiiss120&refresh=1";
				tbgGIISPackageBenefitDtl._refreshList();
				enableDisableFields(["giiss120FormDiv2"], "disable");
				disableButton("btnAddPackageBenefitDtl");
				disableButton("btnDeletePackageBenefitDtl");
			}
		} catch(e){
			showErrorMessage("showGIISPackageBenefitDtl", e);
		}
	}
	function setRec(rec,mode){
		try {
			var obj = (rec == null ? {} : rec);
			if (mode == "giisPackageBenefit") {
				obj.packageCd = escapeHTML2($F("txtPackageCd"));
				obj.origPackageCd = escapeHTML2(origPackageCd == null ? $F("txtPackageCd") : origPackageCd);
				obj.packBenCd = $F("txtPackBenCd");
				obj.lineCd = escapeHTML2($F("txtLineCd"));
				obj.sublineCd = escapeHTML2($F("txtSublineCd"));
				obj.userId = userId;
				var lastUpdate = new Date();
				obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			} else if(mode == "giisPackageBenefitDtl") {
				obj.packBenCd = $F("txtPackBenCd");
				obj.packageCd = escapeHTML2($F("txtPackageCd"));
				obj.perilCd = escapeHTML2($F("txtPerilCd"));
				obj.perilName = escapeHTML2($F("txtPerilName"));
				obj.premPct = $F("txtPremPct");
				obj.premAmt = unformatValueToString($F("txtPremAmt"));
				obj.noOfDays = unformatCurrency($("txtNoOfDays"));
				obj.benefit = unformatValueToString($F("txtBenefit"));
				obj.aggregateSw = $("chkAggregateSw").checked ? 'Y' : 'N';
				obj.remarks = escapeHTML2($F("txtPackageBenefitDtlRemarks"));
				obj.userId = userId;
				var lastUpdate = new Date();
				obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			} 
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(mode){
		try {
			changeTagFunc = saveGiiss120;
			if (mode == "giisPackageBenefit") {
				var dept = setRec(objCurrGIISPackageBenefit,mode);
				var newObj = setRec(null,mode);
				if($F("btnAddPackageBenefit") == "Add"){
					tbgGIISPackageBenefit.addBottomRow(dept);
					newObj.recordStatus = 0;
					objAllRecord.push(newObj);
				} else {
					if (changeTagPackageBenefitDtl == 1 ) {
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return;
					} else {
						tbgGIISPackageBenefit.updateVisibleRowOnly(dept, rowIndexPackageBenefit, false); 
						for(var i = 0; i<objAllRecord.length; i++){
							if ((objAllRecord[i].packBenCd == newObj.packBenCd)&&(objAllRecord[i].recordStatus != -1)){
								newObj.recordStatus = 1;
								objAllRecord.splice(i, 1, newObj);
							}
						}
						showGIISPackageBenefitDtl(false);
					}
				}
				changeTag = 1;
				changeTagPackageBenefit = 1;
				setFieldValues(null, mode);
				tbgGIISPackageBenefit.keys.removeFocus(tbgGIISPackageBenefit.keys._nCurrentFocus, true);
				tbgGIISPackageBenefit.keys.releaseKeys();
			} else if(mode == "giisPackageBenefitDtl") {
				var dept = null;
				if($F("btnAddPackageBenefitDtl") == "Add"){
					dept = setRec(objCurrGIISPackageBenefitDtl,mode);
					computeTotalAmountInTable(dept.premAmt, "0", "add");
					tbgGIISPackageBenefitDtl.addBottomRow(dept);
				} else {
					dept = setRec(null,mode);
					computeTotalAmountInTable(dept.premAmt, tbgGIISPackageBenefitDtl.geniisysRows[rowIndexPackageBenefitDtl].premAmt, "update");
					dept = setRec(objCurrGIISPackageBenefitDtl,mode);
					tbgGIISPackageBenefitDtl.updateVisibleRowOnly(dept, rowIndexPackageBenefitDtl, false); 
				}
				changeTag = 1;
				changeTagPackageBenefitDtl = 1;
				setFieldValues(null, mode);
				tbgGIISPackageBenefitDtl.keys.removeFocus(tbgGIISPackageBenefitDtl.keys._nCurrentFocus, true);
				tbgGIISPackageBenefitDtl.keys.releaseKeys();
			} 
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddUpdateRec(mode, toDo) {
		try {
			var addedSameExists = false;
			var deletedSameExists = false;	
			if (mode == "giisPackageBenefit") {
				for(var i=0; i<objAllRecord.length; i++){
					if(objAllRecord[i].recordStatus != -1 ){
						if (toDo == "add") {
							if(unescapeHTML2(objAllRecord[i].packageCd) == $F("txtPackageCd")){
								showMessageBox("Record already exists with same line_cd, subline_cd and package_cd.", "E");
								return;
							}
						} else{
							if(origPackageCd != $F("txtPackageCd") && unescapeHTML2(objAllRecord[i].packageCd) == $F("txtPackageCd")){
								showMessageBox("Record already exists with same line_cd, subline_cd and package_cd.", "E");
								return;
							}
						}
					} 
				}
				addRec(mode);
			} else if(mode == "giisPackageBenefitDtl") {
				if (toDo == "add") {
					for(var i=0; i<tbgGIISPackageBenefitDtl.geniisysRows.length; i++){
						if(tbgGIISPackageBenefitDtl.geniisysRows[i].recordStatus == 0 || tbgGIISPackageBenefitDtl.geniisysRows[i].recordStatus == 1){								
							if(tbgGIISPackageBenefitDtl.geniisysRows[i].perilCd == $F("txtPerilCd")){
								addedSameExists = true;								
							}							
						} else if(tbgGIISPackageBenefitDtl.geniisysRows[i].recordStatus == -1){
							if(tbgGIISPackageBenefitDtl.geniisysRows[i].perilCd == $F("txtPerilCd")){
								deletedSameExists = true;
							}
						}
					}
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with same pack_ben_cd and peril_cd.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec(mode);
						return;
					}
					new Ajax.Request(contextPath + "/GIISPackageBenefitController", {
						parameters : {action : "valAddRec",
									  lineCd : $F("txtLineCd"),
							          sublineCd : $F("txtSublineCd"),
									  recId : $F("txtPerilCd"),
									  recId2 : $F("txtPackBenCd"),
									  mode : mode},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response){
							hideNotice();
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
								addRec(mode);
							}
						}
					});
				} else {
					addRec(mode);
				}
			} 
		} catch (e) {
			showErrorMessage("valAddUpdateRec",e);
		}
	}
	
	function valAddRec(mode){
		try{
				if (mode == "giisPackageBenefit") {
					if(checkAllRequiredFieldsInDiv("giiss120FormDiv")){
						if($F("btnAddPackageBenefit") == "Add") {
							valAddUpdateRec(mode, "add");
						} else {
							valAddUpdateRec(mode, "update");
						}
					}
				} else if(mode == "giisPackageBenefitDtl") {
					if(checkAllRequiredFieldsInDiv("giiss120FormDiv2")){
						if($F("btnAddPackageBenefitDtl") == "Add") {
							valAddUpdateRec(mode, "add");
						} else {
							valAddUpdateRec(mode, "update");
						}
					}
				} 
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}	
	
	function deleteRec(mode){
		changeTagFunc = saveGiiss120;
		if (mode == "giisPackageBenefit") {
			var newObj = setRec(null,mode);
			objCurrGIISPackageBenefit.recordStatus = -1;
			for(var i = 0; i<objAllRecord.length; i++){
				if ((objAllRecord[i].packBenCd == newObj.packBenCd)&&(objAllRecord[i].recordStatus != -1)){
					newObj.recordStatus = -1;
					objAllRecord.splice(i, 1, newObj);
				}
			}
			
			tbgGIISPackageBenefit.deleteRow(rowIndexPackageBenefit); 
			changeTag = 1;
			changeTagPackageBenefit = 1;
			disableButton("btnAddPackageBenefitDtl");
			showGIISPackageBenefitDtl(false);
		} else if(mode == "giisPackageBenefitDtl") {
			objCurrGIISPackageBenefitDtl.recordStatus = -1;
			computeTotalAmountInTable(tbgGIISPackageBenefitDtl.geniisysRows[rowIndexPackageBenefitDtl].premAmt, "0", "delete");
			tbgGIISPackageBenefitDtl.deleteRow(rowIndexPackageBenefitDtl); 
			changeTag = 1;
			changeTagPackageBenefitDtl = 1;
		} 
		setFieldValues(null, mode);
	}
	
	function valDeleteRec(mode){
		try{
			new Ajax.Request(contextPath + "/GIISPackageBenefitController", {
				parameters : {action : "valDeleteRec",
					  		  recId : $F("txtPackBenCd")},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						deleteRec(mode);
					}
				}
			});
		} catch(e){
			showErrorMessage("valDeleteRec", e);
		}
	}
	
	function getAllRecord(){
		try{
			var result = []; 
			new Ajax.Request(contextPath + "/GIISPackageBenefitController", {
				parameters : {action : "showAllGiiss120",
					  		  lineCd : $F("txtLineCd"),
					  		  sublineCd : $F("txtSublineCd")},
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
			showErrorMessage("getAllRecord", e);
		}
	}
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", "");	
	}	
	
	function enterQueryPage() {
		tbgGIISPackageBenefit.url = contextPath + "/GIISPackageBenefitController?action=showGiiss120&refresh=1";
		tbgGIISPackageBenefit._refreshList();
		tbgGIISPackageBenefitDtl.url = contextPath + "/GIISPackageBenefitController?action=showGiiss120&refresh=1";
		tbgGIISPackageBenefitDtl._refreshList();
		resetAllFields();
	}
	
	function cancelGiiss120(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISS120.exitPage = exitPage;
						saveGiiss120();
					}, function(){
						goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", "");	
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", "");	
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
	
	$("imgLineSearch").observe("click",showGIISS120LineLOV);
	$("imgSublineSearch").observe("click",showGIISS120SublineLOV);
	$("imgPerilNameSearch").observe("click",showGIISS120PerilLOV);
	
	$("txtLineCd").observe("change", function() {
		if($F("txtLineCd").trim() == "") {
			$("txtLineCd").clear();
			$("txtLineCd").setAttribute("lastValidValue", "");
			$("txtSublineCd").clear();
			$("txtSublineCd").setAttribute("lastValidValue", "");
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
			$("txtSublineCd").readOnly = true;
			disableSearch("imgSublineSearch");
		} else {
			if($F("txtLineCd").trim() != "" && $F("txtLineCd") != $("txtLineCd").readAttribute("lastValidValue")) {
				showGIISS120LineLOV();
			}
		}
	});
	
	$("txtSublineCd").observe("change", function() {
		if($F("txtSublineCd").trim() == "") {
			$("txtSublineCd").clear();
			$("txtSublineCd").setAttribute("lastValidValue", "");
			disableToolbarButton("btnToolbarExecuteQuery");
		} else {
			if($F("txtSublineCd").trim() != "" && $F("txtSublineCd") != $("txtSublineCd").readAttribute("lastValidValue")) {
				showGIISS120SublineLOV();
			}
		}
	});
	
	$("txtPerilName").observe("change", function() {
		if($F("txtPerilName").trim() == "") {
			$("txtPerilName").clear();
			$("txtPerilCd").clear();
			$("txtPerilName").setAttribute("lastValidValue", "");
			$("txtPerilCd").setAttribute("lastValidValue", "");
		} else {
			if($F("txtPerilName").trim() != "" && $F("txtPerilName") != $("txtPerilName").readAttribute("lastValidValue")) {
				showGIISS120PerilLOV();
			}
		}
	});
	
	$("txtPremPct").observe("change",function(){
		$("txtPremAmt").clear();
	});
	
	$("txtPremAmt").observe("change",function(){
		$("txtPremPct").clear();
	});
	
	$("txtPackageCd").observe("keyup", function(){
		$("txtPackageCd").value = $F("txtPackageCd").toUpperCase();
	});

	$("editPackageBenefitDtlRemarks").observe("click", function(){
		showOverlayEditor("txtPackageBenefitDtlRemarks", 4000, $("txtPackageBenefitDtlRemarks").hasAttribute("readonly"));
	});
	
	observeSaveForm("btnSave", saveGiiss120);
	$("btnCancel").observe("click", cancelGiiss120);
	
	$("btnAddPackageBenefit").observe("click", function() {
		valAddRec("giisPackageBenefit");
	}); 
	$("btnAddPackageBenefitDtl").observe("click", function() {
		valAddRec("giisPackageBenefitDtl");
	}); 
	$("btnDeletePackageBenefit").observe("click", function () {
		valDeleteRec("giisPackageBenefit");
	});
	$("btnDeletePackageBenefitDtl").observe("click", function () {
		deleteRec("giisPackageBenefitDtl");
	});
	
	//toolbar events
	$("btnToolbarEnterQuery").observe("click", function(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISS120.enterQueryPage = enterQueryPage;
						saveGiiss120();
					}, function(){
						enterQueryPage();
					}, "");
		} else {
			enterQueryPage();
		}
	});
	$("btnToolbarExecuteQuery").observe("click", function(){
		tbgGIISPackageBenefit.url = contextPath + "/GIISPackageBenefitController?action=showGiiss120&refresh=1&mode=giisPackageBenefit&lineCd="+encodeURIComponent($F("txtLineCd"))
																																	+"&sublineCd="+encodeURIComponent($F("txtSublineCd"));
		tbgGIISPackageBenefit._refreshList();
		disableToolbarButton("btnToolbarExecuteQuery");
		enableDisableFields(["giiss120FormDiv"], "enable");
		$("txtLineCd").readOnly = true;
		$("txtSublineCd").readOnly = true;
		disableSearch("imgLineSearch");
		disableSearch("imgSublineSearch");
		enableButton("btnAddPackageBenefit");
	});
	$("btnToolbarSave").observe("click", function(){
		fireEvent($("btnSave"), "click");
	});
	$("btnToolbarExit").stopObserving("click");
	$("btnToolbarExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtLineCd").focus();	
</script>