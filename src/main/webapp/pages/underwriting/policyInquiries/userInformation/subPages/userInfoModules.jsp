<div id="userInfoModuleMainDiv" name="userInfoModuleMainDiv" style="height:400px;">
	<div id="userDetailDiv" name="userDetailDiv" class="sectionDiv" style="margin-top: 10px; width: 800px;">
		<table align="center" style="margin-top: 5px; margin-bottom: 5px;">
			<tr>
				<td class="rightAligned" style="padding-right: 3px;">User ID</td>
				<td class="leftAligned">
					<input type="text" id="txtModUserId" name="txtModUserId" class="text" readonly="readonly" style="width: 380px;" tabindex="601"/>
				</td>
			</tr>
		</table>
	</div>
	<div id="userGrpDetailDiv" name="userGrpDetailDiv" class="sectionDiv" style="margin-top: 10px; width: 800px;">
		<table align="center" style="margin-top: 5px; margin-bottom: 5px;">
			<tr>
				<td class="rightAligned" style="padding-right: 3px;">User Grp</td>
				<td class="leftAligned">
					<input type="text" id="txtModUserGrp" name="txtTranUserGrp" class="text" readonly="readonly" style="width: 80px;" tabindex="601"/>
					<input type="text" id="txtModUserGrpDesc" name="txtTranUserGrpDesc" class="text" readonly="readonly" style="width: 280px;" tabindex="602"/>
					<input type="text" id="txtModUserGrpIss" name="txtTranUserGrpIss" class="text" readonly="readonly" style="width: 90px;" tabindex="603"/>
				</td>
			</tr>
		</table>
	</div>	
	<div id="moduleTableDiv" class="sectionDiv" style="height: 380px; width: 800px;">
		<div id="tableGridDiv" name="tableGridDiv" style="margin-top: 10px; margin-left: 10px; height: 290px;">
			<div id="moduleTable" style="height: 190px;"></div>
		</div>
		<div id="moduleDetailDiv" name="moduleDetailDiv" style="margin-top: 10px;">
			<table align="center">
				<tr>
					<td class="rightAligned" style="padding-right: 3px;">Remarks</td>
					<td colspan="5" class="leftAligned">
						<div style="border: 1px solid gray;">
							<textarea id="remarks" name="remarks" style="width: 570px; border: none; height: 13px; resize: none;" readonly="readonly" tabindex="701"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarksText" tabindex="702"/>
						</div>
					</td>
				</tr>
			</table>
			<table>
				<tr align="center">
					<td class="rightAligned" style="width:124px; padding-right: 3px;">User ID</td>
					<td class="leftAligned" style="width: 46.3%">
						<input type="text" id="txtUserId" name="txtUserId" class="text" readonly="readonly" style="width: 180px;" tabindex="703"/>
					</td>
					<td class="rightAligned" style="padding-right: 3px;">Last Update 
						<input type="text" id="txtLastUpdate" name="txtLastUpdate" class="text" style="width: 180px;" readonly="readonly" tabindex="704"/>
					</td>
				</tr>
			</table>
		</div>
	</div>	
	<div class="buttonsDiv" style="width: 800px; margin-bottom: 10px;">
		<input type="button" class="button" id="btnReturn" name="btnReturn" value="Return" style="width:150px;" tabindex="801"/>
	</div>
	
</div>

<script type="text/javascript">	
	if (objUserInfo.selectedAccess == "Transaction") {
		$("userDetailDiv").show();
		$("userGrpDetailDiv").hide();
		$("txtModUserId").value = selectedUser;
		$("txtModUserId").focus();
		$("moduleTableDiv").setStyle({height:'380px'});
		try{
			var objMod = new Object();
			var objCurrModule = null;
			objMod.objModListing = JSON.parse('${jsonModuleList}');
			objMod.modList = objMod.objModListing.rows || [];
			var tbgModule = {
					url: contextPath+"/GIPIPolbasicController?action=getModuleList&refresh=1&userId="+selectedUser+"&tranCd="+selectedTranCd,
				options: {
					width: '780px',
					height: '270px',
					id: 1,
					onCellFocus: function(element, value, x, y, id){
						objCurrModule = moduleTableGrid.geniisysRows[y];
						populateUserInfoModule(objCurrModule);
					},
					onRemoveRowFocus: function(){
						populateUserInfoModule(null);
		            },
	                onSort: function(){
	                	populateUserInfoModule(null);
	                },
	                prePager: function(){
	                	populateUserInfoModule(null);
	                },
					onRefresh: function(){
						populateUserInfoModule(null);
					},
					toolbar: {
						elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
						onFilter: function(){
							populateUserInfoModule(null);
						}
					}
				},
				columnModel: [
					{
						id : 'recordStatus',
						width : '0',
						visible : false
					},
					{	id: 'divCtrId',
						width: '0',
						visible: false
					},
					{	id: 'incTag',
						width: '30px',
						editable : false,
						align : 'center',
						titleAlign: 'center',
						altTitle : 'Inc Tag',
						editor : new MyTableGrid.CellCheckbox({
							getValueOf : function(value) {
								if (value) {
									return "Y";
								} else {
									return "N";
								}
							}
						})
					},
					{	id: 'moduleId',
						title: 'Module Code',
						width: '200px',
						filterOption: true
					},
					{	id: 'moduleDesc',
						title: 'Module Description',
						width: '360px',
						filterOption: true
					},
					{	id: 'accessTagDesc',
						title: 'Access Tag',
						width: '155px',
						filterOption: true
					}
					],
				rows: objMod.modList
			};
			
			moduleTableGrid = new MyTableGrid(tbgModule);
			moduleTableGrid.pager = objMod.objModListing;
			moduleTableGrid.render('moduleTable');
		}catch (e) {
			showErrorMessage("moduleTableGrid", e);
		}
	}else {
		$("userDetailDiv").hide();
		$("moduleDetailDiv").hide();
		$("userGrpDetailDiv").show();
		$("txtModUserGrp").focus();
		$("txtModUserGrp").value = selectedUserGrp;
		$("txtModUserGrpDesc").value = selectedUserGrpDesc;
		$("txtModUserGrpIss").value = selectedGrpIssCd;
		$("moduleTableDiv").setStyle({height:'340px'});
		try{
			var objModGrp = new Object();
			objModGrp.objModGrpListing = JSON.parse('${jsonGrpModule}');
			objModGrp.modGrpList = objModGrp.objModGrpListing.rows || [];
			var tbgModuleGrp = {
					url: contextPath+"/GIPIPolbasicController?action=getGrpModuleList&refresh=1&userGrp="+selectedUserGrp+"&tranCd="+selectedTranCdGrp,
				options: {
					width: '780px',
					height: '270px',
					id: 1,
					onCellFocus: function(element, value, x, y, id){
					},
					onRemoveRowFocus: function(){
						moduleGrpTableGrid.keys.removeFocus(moduleGrpTableGrid.keys._nCurrentFocus, true);
						moduleGrpTableGrid.keys.releaseKeys();
		            },
	                onSort: function(){
	                	moduleGrpTableGrid.keys.removeFocus(moduleGrpTableGrid.keys._nCurrentFocus, true);
	            		moduleGrpTableGrid.keys.releaseKeys();
	                },
	                prePager: function(){
	                	moduleGrpTableGrid.keys.removeFocus(moduleGrpTableGrid.keys._nCurrentFocus, true);
	            		moduleGrpTableGrid.keys.releaseKeys();
	                },
					onRefresh: function(){
						moduleGrpTableGrid.keys.removeFocus(moduleGrpTableGrid.keys._nCurrentFocus, true);
						moduleGrpTableGrid.keys.releaseKeys();
					},
					toolbar: {
						elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
						onFilter: function(){
							moduleGrpTableGrid.keys.removeFocus(moduleGrpTableGrid.keys._nCurrentFocus, true);
							moduleGrpTableGrid.keys.releaseKeys();
						}
					}
				},
				columnModel: [
					{
						id : 'recordStatus',
						width : '0',
						visible : false
					},
					{	id: 'divCtrId',
						width: '0',
						visible: false
					},
					{	id: 'incTagGrp',
						width: '30px',
						editable : false,
						align : 'center',
						titleAlign: 'center',
						altTitle : 'Inc Tag',
						editor : new MyTableGrid.CellCheckbox({
							getValueOf : function(value) {
								if (value) {
									return "Y";
								} else {
									return "N";
								}
							}
						})
					},
					{	id: 'moduleIdGrp',
						title: 'Module Code',
						width: '200px',
						filterOption: true
					},
					{	id: 'moduleDescGrp',
						title: 'Module Description',
						width: '360px',
						filterOption: true
					},
					{	id: 'accessTagDescGrp',
						title: 'Access Tag',
						width: '155px',
						filterOption: true
					}
					],
				rows: objModGrp.modGrpList
			};
			
			moduleGrpTableGrid = new MyTableGrid(tbgModuleGrp);
			moduleGrpTableGrid.pager = objModGrp.objModGrpListing;
			moduleGrpTableGrid.render('moduleTable');
		}catch (e) {
			showErrorMessage("moduleTableGrid", e);
		}
	}
	
	function populateUserInfoModule(record) {
		$("remarks").value 		 = record == null ? "" : unescapeHTML2(record.moduleRemarks);
		$("txtUserId").value 	 = record == null ? "" : record.moduleUserId;
		$("txtLastUpdate").value = record == null ? "" : record.moduleLastUpdate;
		moduleTableGrid.keys.removeFocus(moduleTableGrid.keys._nCurrentFocus, true);
		moduleTableGrid.keys.releaseKeys();
	}
	
	$("editRemarksText").observe("click", function () {
		showOverlayEditor("remarks", 4000, $("remarks").hasAttribute("readonly"),"");
	});
	
	$("btnReturn").observe("click", function() {
		overlayModule.close();
	});
	
</script>