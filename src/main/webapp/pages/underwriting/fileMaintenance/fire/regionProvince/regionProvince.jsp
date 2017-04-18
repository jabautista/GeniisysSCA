<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss024MainDiv" name="giiss024MainDiv">
	<div id="giiss024Div">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="giiss024Exit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Region Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
	   			<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss024" name="giiss024">		
		<div class="sectionDiv">
			<div id="giiss024TableDiv" style="padding-top: 10px;">
				<div id="giiss024Table" style="height: 340px; margin-left: 115px;"></div>
			</div>
			<div align="center" id="giiss024FormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Region Code</td>
						<td class="leftAligned" colspan="3">
							<input id="txtRegionCd" type="text" class="required integerNoNegative" style="width: 200px; text-align: right;" tabindex="101" maxlength="2" lpad="2">
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Description</td>
						<td class="leftAligned" colspan="3">
							<input id="txtRegionDesc" type="text" class="required" style="width: 533px;" tabindex="102" maxlength="40">
						</td>
					</tr>				
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtRegionUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="103"></td>
						<td width="" class="rightAligned" style="padding-left: 47px">Last Update</td>
						<td class="leftAligned"><input id="txtRegionLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="104"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px;" align = "center">
				<input type="button" class="button" id="btnAddRegion" value="Add" tabindex="105">
				<input type="button" class="button" id="btnDeleteRegion" value="Delete" tabindex="106">
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Province Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label name="gro" style="margin-left: 5px;">Hide</label> 
			</span>
	   	</div>
	</div>	
	<div id="giiss024Div2" name="giiss024Div2">		
		<div class="sectionDiv">
			<div id="giiss024TableDiv2" style="padding-top: 10px;">
				<div id="giiss024Table2" style="height: 340px; margin-left: 115px;"></div>
			</div>
			<div align="center" id="giiss024FormDiv2">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Code</td>
						<td class="leftAligned" colspan="3">
							<input id="txtProvinceCd" type="text" class="required" style="width: 200px;" tabindex="201" maxlength="6">
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Province</td>
						<td class="leftAligned" colspan="3">
							<input id="txtProvinceDesc" type="text" class="required" style="width: 533px;" tabindex="202" maxlength="25">
						</td>
					</tr>				
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksProvinceDiv" name="remarksProvinceDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtProvinceRemarks" name="txtProvinceRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="203"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editProvinceRemarks"  tabindex="204"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtProvinceUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="205"></td>
						<td width="" class="rightAligned" style="padding-left: 47px">Last Update</td>
						<td class="leftAligned"><input id="txtProvinceLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="206"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px;" align = "center">
				<input type="button" class="button" id="btnAddProvince" value="Add" tabindex="107">
				<input type="button" class="button" id="btnDeleteProvince" value="Delete" tabindex="108">
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>City Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label name="gro" style="margin-left: 5px;">Hide</label> 
			</span>
	   	</div>
	</div>	
	<div id="giiss024Div3" name="giiss024Div3">		
		<div class="sectionDiv">
			<div id="giiss024TableDiv3" style="padding-top: 10px;">
				<div id="giiss024Table3" style="height: 340px; margin-left: 115px;"></div>
			</div>
			<div align="center" id="giiss024FormDiv3">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Code</td>
						<td class="leftAligned" colspan="3">
							<input id="txtCityCd" type="text" class="required" style="width: 200px;" tabindex="301" maxlength="6">
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">City</td>
						<td class="leftAligned" colspan="3">
							<input id="txtCityDesc" type="text" class="required" style="width: 533px;" tabindex="302" maxlength="40">
						</td>
					</tr>				
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksCityDiv" name="remarksCityDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtCityRemarks" name="txtCityRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="303"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editCityRemarks"  tabindex="304"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtCityUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="305"></td>
						<td width="" class="rightAligned" style="padding-left: 47px">Last Update</td>
						<td class="leftAligned"><input id="txtCityLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="306"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px;" align = "center">
				<input type="button" class="button" id="btnAddCity" value="Add" tabindex="107">
				<input type="button" class="button" id="btnDeleteCity" value="Delete" tabindex="108">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="109">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="110">
</div>



<script type="text/javascript">	
	setModuleId("GIISS024");
	setDocumentTitle("Region/Province Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	changeTagRegion = 0;
	changeTagProvince = 0;
	changeTagCity = 0;
	var rowIndexRegion = -1;
	var rowIndexProvince = -1;
	var rowIndexCity = -1;
	var allProvinceObj = {};
	var allCityObj = {};
	$("txtProvinceCd").readOnly = true;
	$("txtProvinceDesc").readOnly = true;
	$("txtProvinceRemarks").readOnly = true;
	$("txtCityCd").readOnly = true;
	$("txtCityDesc").readOnly = true;
	$("txtCityRemarks").readOnly = true;
	
	function saveGiiss024(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setGIISRegion = getAddedAndModifiedJSONObjects(tbgGIISRegion.geniisysRows);
		var delGIISRegion = getDeletedJSONObjects(tbgGIISRegion.geniisysRows);
		
		var setGIISProvince = getAddedAndModifiedJSONObjects(tbgGIISProvince.geniisysRows);
		var delGIISProvince = getDeletedJSONObjects(tbgGIISProvince.geniisysRows);
		
		var setGIISCity = getAddedAndModifiedJSONObjects(tbgGIISCity.geniisysRows);
		var delGIISCity = getDeletedJSONObjects(tbgGIISCity.geniisysRows);
		new Ajax.Request(contextPath+"/GIISS024Controller", {
			method: "POST",
			parameters : {action : "saveGiiss024",
						  setGIISRegion : prepareJsonAsParameter(setGIISRegion),
						  delGIISRegion : prepareJsonAsParameter(delGIISRegion),
						  setGIISProvince : prepareJsonAsParameter(setGIISProvince),
						  delGIISProvince : prepareJsonAsParameter(delGIISProvince),
						  setGIISCity : prepareJsonAsParameter(setGIISCity),
						  delGIISCity : prepareJsonAsParameter(delGIISCity)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS024.exitPage != null) {
							tbgGIISRegion.keys.releaseKeys();
							tbgGIISProvince.keys.releaseKeys();
							tbgGIISCity.keys.releaseKeys();
							objGIISS024.exitPage();
						} else {
							tbgGIISRegion._refreshList();
							tbgGIISRegion.keys.releaseKeys();
							tbgGIISProvince.keys.releaseKeys();
							tbgGIISCity.keys.releaseKeys();
						}
					});
					changeTag = 0;
					changeTagRegion = 0;
					changeTagProvince = 0;
					changeTagCity = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiiss024);
	
	var objGIISS024 = {};
	objGIISS024.exitPage = null;
	
	//GIIS_REGION tablegrid...
	var objCurrGIISRegion = null;
	objGIISS024.giiss024Region = JSON.parse('${jsonGIISRegion}');
	
	var giiss024RegionTable = {
			url : contextPath + "/GIISS024Controller?action=showGiiss024&refresh=1&mode=region",
			id: "region",
			options : {
				width : '700px',
				hideColumnChildTitle: true,
				pager : {},
				beforeClick: function(){
					if(changeTagProvince == 1 || changeTagCity == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
				},
				onCellFocus : function(element, value, x, y, id){
					rowIndexRegion = y;
					objCurrGIISRegion = tbgGIISRegion.geniisysRows[y];
					setFieldValues(objCurrGIISRegion,"region");
					showPageBlock("province",null);
					tbgGIISRegion.keys.removeFocus(tbgGIISRegion.keys._nCurrentFocus, true);
					tbgGIISRegion.keys.releaseKeys();
					$("txtRegionDesc").focus();
				},
				onRemoveRowFocus : function(){
					rowIndexRegion = -1;
					setFieldValues(null,"region");
					showPageBlock(null, "region");
					tbgGIISRegion.keys.removeFocus(tbgGIISRegion.keys._nCurrentFocus, true);
					tbgGIISRegion.keys.releaseKeys();
					$("txtRegionCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndexRegion = -1;
						setFieldValues(null,"region");
						showPageBlock(null, "region");
						tbgGIISRegion.keys.removeFocus(tbgGIISRegion.keys._nCurrentFocus, true);
						tbgGIISRegion.keys.releaseKeys();
					}
				},
				beforeSort : function(){
					if(changeTagRegion == 1 || changeTagProvince == 1 || changeTagCity == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
				},
				onSort: function(){
					rowIndexRegion = -1;
					setFieldValues(null,"region");
					showPageBlock(null, "region");
					tbgGIISRegion.keys.removeFocus(tbgGIISRegion.keys._nCurrentFocus, true);
					tbgGIISRegion.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndexRegion = -1;
					setFieldValues(null,"region");
					showPageBlock(null, "region");
					tbgGIISRegion.keys.removeFocus(tbgGIISRegion.keys._nCurrentFocus, true);
					tbgGIISRegion.keys.releaseKeys();
				},				
				prePager: function(){
					if(changeTagRegion == 1 || changeTagProvince == 1 || changeTagCity == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
					rowIndexRegion = -1;
					setFieldValues(null,"region");
					showPageBlock(null, "region");
					tbgGIISRegion.keys.removeFocus(tbgGIISRegion.keys._nCurrentFocus, true);
					tbgGIISRegion.keys.releaseKeys();
				},
				checkChanges: function(){
					return (changeTagRegion == 1 || changeTagProvince == 1 || changeTagCity == 1 ? true : false);
				},
				masterDetailRequireSaving: function(){
					return (changeTagRegion == 1 || changeTagProvince == 1 || changeTagCity == 1 ? true : false);
				},
				masterDetailValidation: function(){
					return (changeTagRegion == 1 || changeTagProvince == 1 || changeTagCity == 1 ? true : false);
				},
				masterDetail: function(){
					return (changeTagRegion == 1 || changeTagProvince == 1 || changeTagCity == 1 ? true : false);
				},
				masterDetailSaveFunc: function() {
					return (changeTagRegion == 1 || changeTagProvince == 1 || changeTagCity == 1 ? true : false);
				},
				masterDetailNoFunc: function(){
					return (changeTagRegion == 1 || changeTagProvince == 1 || changeTagCity == 1 ? true : false);
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
					id : "regionCd",
					title : "Region Code",
					align : "right",
				    titleAlign : "right",				
					filterOption : true,
					filterOptionType : "integerNoNegative",
					width : '150px',
					renderer : function(value){
						return lpad(value,2,'0');
					}
				},
				{
					id : 'regionDesc',
					title : 'Description',
					filterOption : true,
					width : '500px'				
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
			rows : objGIISS024.giiss024Region.rows
		};

		tbgGIISRegion = new MyTableGrid(giiss024RegionTable);
		tbgGIISRegion.pager = objGIISS024.giiss024Region;
		tbgGIISRegion.render("giiss024Table");
	
	//GIIS_PROVINCE tablegrid...
	var origProvinceDesc = null;
	var origCityDesc = null;
	var objCurrGIISProvince = null;
	objGIISS024.giiss024Province = [];
	
	var giiss024ProvinceTable = {
			url : contextPath + "/GIISS024Controller?action=showGiiss024&refresh=1",
			id:"province",
			options : {
				width : '700px',
				hideColumnChildTitle: true,
				pager : {},
				beforeClick: function(){
					if(changeTagCity == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
				},
				onCellFocus : function(element, value, x, y, id){
					rowIndexProvince = y;
					objCurrGIISProvince = tbgGIISProvince.geniisysRows[y];
					setFieldValues(objCurrGIISProvince,"province");
					showPageBlock("city", null);
					tbgGIISProvince.keys.removeFocus(tbgGIISProvince.keys._nCurrentFocus, true);
					tbgGIISProvince.keys.releaseKeys();
					$("txtProvinceDesc").focus();
				},
				onRemoveRowFocus : function(){
					rowIndexProvince = -1;
					setFieldValues(null,"province");
					showPageBlock(null, "province");
					tbgGIISProvince.keys.removeFocus(tbgGIISProvince.keys._nCurrentFocus, true);
					tbgGIISProvince.keys.releaseKeys();
					$("txtProvinceCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndexProvince = -1;
						setFieldValues(null,"province");
						showPageBlock(null, "province");
						tbgGIISProvince.keys.removeFocus(tbgGIISProvince.keys._nCurrentFocus, true);
						tbgGIISProvince.keys.releaseKeys();
					}
				},
				beforeSort : function(){
					if(changeTagProvince == 1 || changeTagCity == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
				},
				onSort: function(){
					rowIndexProvince = -1;
					setFieldValues(null,"province");
					showPageBlock(null, "province");
					tbgGIISProvince.keys.removeFocus(tbgGIISProvince.keys._nCurrentFocus, true);
					tbgGIISProvince.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndexProvince = -1;
					setFieldValues(null,"province");
					showPageBlock(null, "province");
					tbgGIISProvince.keys.removeFocus(tbgGIISProvince.keys._nCurrentFocus, true);
					tbgGIISProvince.keys.releaseKeys();
				},				
				prePager: function(){
					if(changeTagProvince == 1 || changeTagCity == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
					rowIndexProvince = -1;
					setFieldValues(null,"province");
					showPageBlock(null, "province");
					tbgGIISProvince.keys.removeFocus(tbgGIISProvince.keys._nCurrentFocus, true);
					tbgGIISProvince.keys.releaseKeys();
				},
				checkChanges: function(){
					return (changeTagProvince == 1 || changeTagCity == 1 ? true : false);
				},
				masterDetailRequireSaving: function(){
					return (changeTagProvince == 1 || changeTagCity == 1 ? true : false);
				},
				masterDetailValidation: function(){
					return (changeTagProvince == 1 || changeTagCity == 1 ? true : false);
				},
				masterDetail: function(){
					return (changeTagProvince == 1 || changeTagCity == 1 ? true : false);
				},
				masterDetailSaveFunc: function() {
					return (changeTagProvince == 1 || changeTagCity == 1 ? true : false);
				},
				masterDetailNoFunc: function(){
					return (changeTagProvince == 1 || changeTagCity == 1 ? true : false);
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
					id : "provinceCd",
					title : "Code",
					filterOption : true,
					width : '150px'
				},
				{
					id : 'provinceDesc',
					title : 'Province',
					filterOption : true,
					width : '500px'				
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

		tbgGIISProvince = new MyTableGrid(giiss024ProvinceTable);
		tbgGIISProvince.render("giiss024Table2");
		
	//GIIS_CITY tablegrid...
	var objCurrGIISCity = null;
	objGIISS024.giiss024City = [];
	
	var giiss024CityTable = {
			url : contextPath + "/GIISS024Controller?action=showGiiss024&refresh=1",
			id:"city",
			options : {
				width : '700px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndexCity = y;
					objCurrGIISCity = tbgGIISCity.geniisysRows[y];
					setFieldValues(objCurrGIISCity,"city");
					tbgGIISCity.keys.removeFocus(tbgGIISCity.keys._nCurrentFocus, true);
					tbgGIISCity.keys.releaseKeys();
					$("txtCityDesc").focus();
				},
				onRemoveRowFocus : function(){
					rowIndexCity = -1;
					setFieldValues(null,"city");
					tbgGIISCity.keys.removeFocus(tbgGIISCity.keys._nCurrentFocus, true);
					tbgGIISCity.keys.releaseKeys();
					$("txtCityCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndexCity = -1;
						setFieldValues(null,"city");
						tbgGIISCity.keys.removeFocus(tbgGIISCity.keys._nCurrentFocus, true);
						tbgGIISCity.keys.releaseKeys();
					}
				},
				beforeSort : function(){
					if(changeTagCity == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
				},
				onSort: function(){
					rowIndexCity = -1;
					setFieldValues(null,"city");
					tbgGIISCity.keys.removeFocus(tbgGIISCity.keys._nCurrentFocus, true);
					tbgGIISCity.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndexCity = -1;
					setFieldValues(null,"city");
					tbgGIISCity.keys.removeFocus(tbgGIISCity.keys._nCurrentFocus, true);
					tbgGIISCity.keys.releaseKeys();
				},				
				prePager: function(){
					if(changeTagCity == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
					rowIndexCity = -1;
					setFieldValues(null,"city");
					tbgGIISCity.keys.removeFocus(tbgGIISCity.keys._nCurrentFocus, true);
					tbgGIISCity.keys.releaseKeys();
				},
				checkChanges: function(){
					return (changeTagCity == 1 ? true : false);
				},
				masterDetailRequireSaving: function(){
					return (changeTagCity == 1 ? true : false);
				},
				masterDetailValidation: function(){
					return (changeTagCity == 1 ? true : false);
				},
				masterDetail: function(){
					return (changeTagCity == 1 ? true : false);
				},
				masterDetailSaveFunc: function() {
					return (changeTagCity == 1 ? true : false);
				},
				masterDetailNoFunc: function(){
					return (changeTagCity == 1 ? true : false);
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
					id : "cityCd",
					title : "Code",
					filterOption : true,
					width : '150px'
				},
				{
					id : 'city',
					title : 'City',
					filterOption : true,
					width : '500px'				
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
				},
				{
					id : "provinceCd",
					width : '0',
					visible: false
				}
			],
			rows : []
		};

		tbgGIISCity = new MyTableGrid(giiss024CityTable);
		//tbgGIISCity.pager = objGIISS024.giiss024City;
		tbgGIISCity.render("giiss024Table3");
		
	function showPageBlock(focusMode,unfocusMode) {
		try {
			if (focusMode == "province") {
				tbgGIISProvince.url = contextPath + "/GIISS024Controller?action=showGiiss024&refresh=1&mode="+focusMode+"&regionCd="+$F("txtRegionCd");
				tbgGIISProvince._refreshList();
				allProvinceObj = getAllRecord(focusMode);
				enableButton("btnAddProvince");
				disableButton("btnAddCity");
			} else if(focusMode == "city") {
				tbgGIISCity.url = contextPath + "/GIISS024Controller?action=showGiiss024&refresh=1&mode="+focusMode+"&provinceCd="+encodeURIComponent($F("txtProvinceCd"));
				tbgGIISCity._refreshList();
				allCityObj = getAllRecord(focusMode);
				enableButton("btnAddProvince");
				enableButton("btnAddCity");
			} 
			if (unfocusMode == "region") {
				tbgGIISProvince.url = contextPath + "/GIISS024Controller?action=showGiiss024&refresh=1";
				tbgGIISProvince._refreshList();
				tbgGIISCity.url = contextPath + "/GIISS024Controller?action=showGiiss024&refresh=1&";
				tbgGIISCity._refreshList();
				$("txtProvinceCd").readOnly = true;
				$("txtProvinceDesc").readOnly = true;
				$("txtProvinceRemarks").readOnly = true;
				$("txtCityCd").readOnly = true;
				$("txtCityDesc").readOnly = true;
				$("txtCityRemarks").readOnly = true;
				allProvinceObj = {};
				allCityObj = {};
				disableButton("btnAddProvince");
				disableButton("btnAddCity");
			} else if(unfocusMode == "province") {
				tbgGIISCity.url = contextPath + "/GIISS024Controller?action=showGiiss024&refresh=1&";
				tbgGIISCity._refreshList();
				$("txtCityCd").readOnly = true;
				$("txtCityDesc").readOnly = true;
				$("txtCityRemarks").readOnly = true;
				allCityObj = {};
				disableButton("btnAddCity");
			} 
		} catch (e) {
			showErrorMessage("showPageBlock",e);
		}
	}
	function setFieldValues(rec,mode){
		try{
			if (mode == "region") {
				$("txtRegionCd").value = (rec == null ? "" : unescapeHTML2(lpad(rec.regionCd,2,'0')));
				$("txtRegionCd").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.regionCd)));
				$("txtRegionDesc").value = (rec == null ? "" : unescapeHTML2(rec.regionDesc));
				$("txtRegionUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
				$("txtRegionLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
				
				rec == null ? $("btnAddRegion").value = "Add" : $("btnAddRegion").value = "Update";
				rec == null ? $("txtRegionCd").readOnly = false : $("txtRegionCd").readOnly = true;
				rec == null ? disableButton("btnDeleteRegion") : enableButton("btnDeleteRegion");
				if (rec==null) {
					$("txtProvinceCd").readOnly = true;
					$("txtProvinceDesc").readOnly = true;
					$("txtProvinceRemarks").readOnly = true;
				}else{
					$("txtProvinceCd").readOnly = false;
					$("txtProvinceDesc").readOnly = false;
					$("txtProvinceRemarks").readOnly = false;
				}
				objCurrGIISRegion = rec;
			} else if(mode == "province") {
				$("txtProvinceCd").value = (rec == null ? "" : unescapeHTML2(rec.provinceCd));
				$("txtProvinceCd").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.provinceCd)));
				$("txtProvinceDesc").value = (rec == null ? "" : unescapeHTML2(rec.provinceDesc));
				$("txtProvinceUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
				$("txtProvinceLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
				$("txtProvinceRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
				
				origProvinceDesc = (rec == null ? "" : unescapeHTML2(rec.provinceDesc));
				rec == null ? $("btnAddProvince").value = "Add" : $("btnAddProvince").value = "Update";
				rec == null ? $("txtProvinceCd").readOnly = false : $("txtProvinceCd").readOnly = true;
				rec == null ? disableButton("btnDeleteProvince") : enableButton("btnDeleteProvince");
				if (rec==null) {
					$("txtCityCd").readOnly = true;
					$("txtCityDesc").readOnly = true;
					$("txtCityRemarks").readOnly = true;
				}else{
					$("txtCityCd").readOnly = false;
					$("txtCityDesc").readOnly = false;
					$("txtCityRemarks").readOnly = false;
				}
				objCurrGIISProvince = rec;
			} else if (mode == "city"){
				$("txtCityCd").value = (rec == null ? "" : unescapeHTML2(rec.cityCd));
				$("txtCityCd").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.cityCd)));
				$("txtCityDesc").value = (rec == null ? "" : unescapeHTML2(rec.city));
				$("txtCityUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
				$("txtCityLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
				$("txtCityRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
				
				origCityDesc = (rec == null ? "" : unescapeHTML2(rec.city));
				rec == null ? $("btnAddCity").value = "Add" : $("btnAddCity").value = "Update";
				rec == null ? $("txtCityCd").readOnly = false : $("txtCityCd").readOnly = true;
				rec == null ? disableButton("btnDeleteCity") : enableButton("btnDeleteCity");
				objCurrGIISCity = rec;
			}
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec,mode){
		try {
			var obj = (rec == null ? {} : rec);
			if (mode == "region") {
				obj.regionCd = escapeHTML2($F("txtRegionCd"));
				obj.regionDesc = escapeHTML2($F("txtRegionDesc"));
				obj.userId = userId;
				var lastUpdate = new Date();
				obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			} else if(mode == "province") {
				obj.regionCd = escapeHTML2($F("txtRegionCd"));
				obj.provinceCd = escapeHTML2($F("txtProvinceCd"));
				obj.provinceDesc = escapeHTML2($F("txtProvinceDesc"));
				obj.remarks = escapeHTML2($F("txtProvinceRemarks"));
				obj.userId = userId;
				obj.origProvinceDesc = escapeHTML2(origProvinceDesc == null ? $F("txtProvinceDesc") : origProvinceDesc);
				var lastUpdate = new Date();
				obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			} else if (mode == "city"){
				obj.provinceCd = escapeHTML2($F("txtProvinceCd"));
				obj.cityCd = escapeHTML2($F("txtCityCd"));
				obj.city = escapeHTML2($F("txtCityDesc"));
				obj.remarks = escapeHTML2($F("txtCityRemarks"));
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
			changeTagFunc = saveGiiss024;
			if (mode == "region") {
				var dept = setRec(objCurrGIISRegion,mode);
				if($F("btnAddRegion") == "Add"){
					tbgGIISRegion.addBottomRow(dept);
				} else {
					if (changeTagProvince == 1 || changeTagCity == 1) {
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return;
					} else {
						tbgGIISRegion.updateVisibleRowOnly(dept, rowIndexRegion, false); 
					}
				}
				changeTag = 1;
				changeTagRegion = 1;
				setFieldValues(null, mode);
				tbgGIISRegion.keys.removeFocus(tbgGIISRegion.keys._nCurrentFocus, true);
				tbgGIISRegion.keys.releaseKeys();
				showPageBlock(null,mode);
			} else if(mode == "province") {
				var dept = setRec(objCurrGIISProvince,mode);
				var newObj = setRec(null,mode);
				if($F("btnAddProvince") == "Add"){
					tbgGIISProvince.addBottomRow(dept);
					newObj.recordStatus = 0;
					allProvinceObj.push(newObj);
				} else {
					if (changeTagCity == 1) {
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return;
					} else {
						tbgGIISProvince.updateVisibleRowOnly(dept, rowIndexProvince, false); 
					}
					for(var i = 0; i<allProvinceObj.length; i++){
						if ((allProvinceObj[i].provinceCd == newObj.provinceCd)&&(allProvinceObj[i].recordStatus != -1)){
							newObj.recordStatus = 1;
							allProvinceObj.splice(i, 1, newObj);
						}
					}
				}
				changeTag = 1;
				changeTagProvince = 1;
				setFieldValues(null, mode);
				tbgGIISProvince.keys.removeFocus(tbgGIISProvince.keys._nCurrentFocus, true);
				tbgGIISProvince.keys.releaseKeys();
				showPageBlock(null,mode);
			} else if (mode == "city"){
				var dept = setRec(objCurrGIISCity,mode);
				var newObj = setRec(null,mode);
				if($F("btnAddCity") == "Add"){
					tbgGIISCity.addBottomRow(dept);
					allCityObj.push(newObj);
				} else {
					tbgGIISCity.updateVisibleRowOnly(dept, rowIndexCity, false); 
					for(var i = 0; i<allCityObj.length; i++){
						if ((allCityObj[i].cityCd == newObj.cityCd)&&(allCityObj[i].recordStatus != -1)){
							newObj.recordStatus = 1;
							allCityObj.splice(i, 1, newObj);
						}
					}
				}
				changeTag = 1;
				changeTagCity = 1;
				setFieldValues(null, mode);
				tbgGIISCity.keys.removeFocus(tbgGIISCity.keys._nCurrentFocus, true);
				tbgGIISCity.keys.releaseKeys();
			}
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddUpdateRec(mode, toDo) {
		try {
			var addedSameExists = false;
			var deletedSameExists = false;	
			if (mode == "region") {
				if (toDo == "add") {
					for(var i=0; i<tbgGIISRegion.geniisysRows.length; i++){
						if(tbgGIISRegion.geniisysRows[i].recordStatus == 0 || tbgGIISRegion.geniisysRows[i].recordStatus == 1){								
							if(tbgGIISRegion.geniisysRows[i].regionCd == $F("txtRegionCd")){
								addedSameExists = true;								
							}							
						} else if(tbgGIISRegion.geniisysRows[i].recordStatus == -1){
							if(tbgGIISRegion.geniisysRows[i].regionCd == $F("txtRegionCd")){
								deletedSameExists = true;
							}
						}
					}
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same region_cd.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec(mode);
						return;
					}
					new Ajax.Request(contextPath + "/GIISS024Controller", {
						parameters : {action : "valAddRec",
									  recId : $F("txtRegionCd"),
									  recId2 : null,
									  mode : mode},
					  	asynchronous: false,
					    evalScripts: true,
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
			} else if(mode == "province") {
				for(var i=0; i<allProvinceObj.length; i++){
					if(allProvinceObj[i].recordStatus != -1 ){
						if (toDo == "add") {
							if(unescapeHTML2(allProvinceObj[i].provinceCd) == $F("txtProvinceCd")){
								showMessageBox("Record already exists with the same province_cd.", "E");
								return;
							}else if(unescapeHTML2(allProvinceObj[i].provinceDesc) == $F("txtProvinceDesc")){
								showMessageBox("Record already exists with the same province_desc.", "E");
								return;
							}
						} else{
							if(origProvinceDesc != $F("txtProvinceDesc") && unescapeHTML2(allProvinceObj[i].provinceDesc) == $F("txtProvinceDesc")){
								showMessageBox("Record already exists with the same province_desc.", "E");
								return;
							}
						}
					} 
				}
				if (toDo == "add") { //added by robert 02.03.15
					addRec(mode);
				}else{
					valUpdateRec($F("txtProvinceCd"), null, mode);
				}
			} else if (mode == "city"){
				for(var i=0; i<allCityObj.length; i++){
					if(allCityObj[i].recordStatus != -1 ){
						if (toDo == "add") {
							if(unescapeHTML2(allCityObj[i].cityCd) == $F("txtCityCd")){
								showMessageBox("Record already exists with the same city_cd and province_cd.", "E");
								return;
							}else if(unescapeHTML2(allCityObj[i].city) == $F("txtCityDesc")){
								showMessageBox("Record already exists with the same city.", "E");
								return;
							}
						} else{
							if(origCityDesc != $F("txtCityDesc") && unescapeHTML2(allCityObj[i].city) == $F("txtCityDesc")){
								showMessageBox("Record already exists with the same city.", "E");
								return;
							}
						}
					} 
				}
				if (toDo == "add") { //added by robert 02.03.15
					addRec(mode);
				}else{
					valUpdateRec($F("txtCityCd"), $F("txtProvinceCd"), mode);
				}
			}
		} catch (e) {
			showErrorMessage("valAddUpdateRec",e);
		}
	}
	
	function valAddRec(mode){
		try{
				if (mode == "region") {
					if(checkAllRequiredFieldsInDiv("giiss024FormDiv")){
						if($F("btnAddRegion") == "Add") {
							valAddUpdateRec(mode, "add");
						} else {
							valAddUpdateRec(mode, "update");
						}
					}
				} else if(mode == "province") {
					if(checkAllRequiredFieldsInDiv("giiss024FormDiv2")){
						if($F("btnAddProvince") == "Add") {
							valAddUpdateRec(mode, "add");
						} else {
							valAddUpdateRec(mode, "update");
						}
					}
				} else if (mode == "city"){
					if(checkAllRequiredFieldsInDiv("giiss024FormDiv3")){
						if($F("btnAddCity") == "Add") {
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
		changeTagFunc = saveGiiss024;
		var newObj = setRec(null,mode);
		if (mode == "region") {
			objCurrGIISRegion.recordStatus = -1;
			tbgGIISRegion.deleteRow(rowIndexRegion); 
			showPageBlock(null, "region");
			changeTag = 1;
			changeTagRegion = 1;
			disableButton("btnAddProvince");
		} else if(mode == "province") {
			objCurrGIISProvince.recordStatus = -1;
			tbgGIISProvince.deleteRow(rowIndexProvince); 
			tbgGIISProvince.geniisysRows[rowIndexProvince].provinceCd = escapeHTML2($F("txtProvinceCd"));
			for(var i = 0; i<allProvinceObj.length; i++){
				if ((allProvinceObj[i].provinceCd == newObj.provinceCd)&&(allProvinceObj[i].recordStatus != -1)){
					newObj.recordStatus = -1;
					allProvinceObj.splice(i, 1, newObj);
				}
			}
			showPageBlock(null, "province");
			changeTag = 1;
			changeTagProvince = 1;
			disableButton("btnAddCity");
		} else if (mode == "city"){
			objCurrGIISCity.recordStatus = -1;
			tbgGIISCity.deleteRow(rowIndexCity); 
			tbgGIISCity.geniisysRows[rowIndexCity].cityCd = escapeHTML2($F("txtCityCd"));
			for(var i = 0; i<allCityObj.length; i++){
				if ((allCityObj[i].cityCd == newObj.cityCd)&&(allCityObj[i].recordStatus != -1)){
					newObj.recordStatus = -1;
					allCityObj.splice(i, 1, newObj);
				}
			}
			changeTag = 1;
			changeTagCity = 1;
		}
		setFieldValues(null, mode);
	}
	
	function valDeleteRec(recId,recId2,mode){
		try{
			new Ajax.Request(contextPath + "/GIISS024Controller", {
				parameters : {action : "valDeleteRec",
							  recId : recId,
							  recId2 :recId2,
							  mode : mode},
			  	asynchronous: false,
			    evalScripts: true,
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
	
	//added by robert 02.03.15 
	function valUpdateRec(recId,recId2,mode){
		try{
			new Ajax.Request(contextPath + "/GIISS024Controller", {
				parameters : {action : "valDeleteRec",
							  recId : recId,
							  recId2 :recId2,
							  mode : mode},
			  	asynchronous: false,
			    evalScripts: true,
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if (response.responseText.include("Geniisys Exception") && 
							(origCityDesc != $F("txtCityDesc") || origProvinceDesc != $F("txtProvinceDesc"))){
						var message = response.responseText.split("#"); 
						showMessageBox(message[2].replace('delete record','update description'), message[1]);
					} else {
						addRec(mode);
					}
				}
			});
		} catch(e){
			showErrorMessage("valDeleteRec", e);
		}
	}
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", "");	
	}	
	
	function cancelGiiss024(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISS024.exitPage = exitPage;
						saveGiiss024();
					}, function(){
						goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", "");	
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", "");	
		}
	}

	function getAllRecord(mode) {
		try {
			var objReturn = {};
			new Ajax.Request(contextPath + "/GIISS024Controller", {
				parameters : {action : "showAllGiiss024",
// 							  regionCd : $F("txtRegionCd"),
							  provinceCd : $F("txtProvinceCd"),
							  mode : mode},
			    asynchronous: false,
				evalScripts: true,
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						var obj = {};
						obj = JSON.parse(response.responseText);
						objReturn = obj.rows;
					}
				}
			});
			return objReturn;
		} catch (e) {
			showErrorMessage("getAllRecord",e);
		}
	}
	
	$("txtRegionDesc").observe("keyup", function(){
		$("txtRegionDesc").value = $F("txtRegionDesc").toUpperCase();
	});

	
	$("editProvinceRemarks").observe("click", function(){
		showOverlayEditor("txtProvinceRemarks", 4000, $("txtProvinceRemarks").hasAttribute("readonly"));
	});
	
	$("txtProvinceDesc").observe("keyup", function(){
		$("txtProvinceDesc").value = $F("txtProvinceDesc").toUpperCase();
	});
	
	$("txtProvinceCd").observe("keyup", function(){
		$("txtProvinceCd").value = $F("txtProvinceCd").toUpperCase();
	});
	
	$("editCityRemarks").observe("click", function(){
		showOverlayEditor("txtCityRemarks", 4000, $("txtCityRemarks").hasAttribute("readonly"));
	});
	
	$("txtCityDesc").observe("keyup", function(){
		$("txtCityDesc").value = $F("txtCityDesc").toUpperCase();
	});
	
	$("txtCityCd").observe("keyup", function(){
		$("txtCityCd").value = $F("txtCityCd").toUpperCase();
	});
	
	disableButton("btnDeleteRegion");
	disableButton("btnDeleteProvince");
	disableButton("btnDeleteCity");
	disableButton("btnAddProvince");
	disableButton("btnAddCity");
	
	observeSaveForm("btnSave", saveGiiss024);
	$("btnCancel").observe("click", cancelGiiss024);
	
	$("btnAddRegion").observe("click", function() {
		valAddRec("region");
	}); 
	$("btnAddProvince").observe("click", function() {
		valAddRec("province");
	}); 
	$("btnAddCity").observe("click", function() {
		valAddRec("city");
	}); 
	$("btnDeleteRegion").observe("click", function () {
		valDeleteRec($F("txtRegionCd"), null, "region");
	});
	$("btnDeleteProvince").observe("click", function () {
		valDeleteRec($F("txtProvinceCd"), null, "province");
	});
	$("btnDeleteCity").observe("click", function () {
		valDeleteRec($F("txtCityCd"), $F("txtProvinceCd"), "city");
	});
	$("giiss024Exit").stopObserving("click");
	$("giiss024Exit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtRegionCd").focus();	
</script>