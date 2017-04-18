<div id="userInfoTransactionMainDiv" name="userInfoTransactionMainDiv">
	<div id="userDetailDiv" name="userDetailDiv" class="sectionDiv" style="margin-top: 10px; width: 680px;">
		<table align="center" style="margin-top: 5px; margin-bottom: 5px;">
			<tr>
				<td class="rightAligned" style="padding-right: 3px;">User ID</td>
				<td class="leftAligned">
					<input type="text" id="txtTranUserId" name="txtTranUserId" class="text" readonly="readonly" style="width: 380px;" tabindex="301"/>
				</td>
			</tr>
		</table>
	</div>
	<div id="userGrpDetailDiv" name="userGrpDetailDiv" class="sectionDiv" style="margin-top: 10px; width: 680px;">
		<table align="center" style="margin-top: 5px; margin-bottom: 5px;">
			<tr>
				<td class="rightAligned" style="padding-right: 3px;">User Grp</td>
				<td class="leftAligned">
					<input type="text" id="txtTranUserGrp" name="txtTranUserGrp" class="text" readonly="readonly" style="width: 80px;" tabindex="301"/>
					<input type="text" id="txtTranUserGrpDesc" name="txtTranUserGrpDesc" class="text" readonly="readonly" style="width: 280px;" tabindex="302"/>
					<input type="text" id="txtTranUserGrpIss" name="txtTranUserGrpIss" class="text" readonly="readonly" style="width: 90px;" tabindex="303"/>
				</td>
			</tr>
		</table>
	</div>
	<div id="transactionTableDiv" name="transactionTableDiv" class="sectionDiv" style="height:235px; width: 680px;">
		<div id="tableDiv" style="width: 600px; height: 190px;">
			<div id="transactionTable" name="transactionTable" style="margin-left: 40px; margin-top: 10px; float: left;"></div>
		</div>
		<div id="buttonsDiv" style="float: left; margin-left: 38%; margin-top: 10px;">
			<input type="button" class="button" id="btnModules" name="btnModules" value="Modules" style="width:150px;" tabindex="401"/>
		</div>
	</div>
	<div id="issTableDiv" name="issTableDiv" class="sectionDiv" style="height:205px; width: 680px;">
		<div id="tableDiv" style="width: 600px; float: left;">
			<div id="tranIssTable" name="tranIssTable" style="margin-left: 40px; margin-top: 10px; float: left;"></div>
		</div>
	</div>
	<div id="tranLineTableDiv" name="tranLineTableDiv" class="sectionDiv" style="height:205px; width: 680px;">
		<div id="tableDiv" style="width: 600px; float: left;">
			<div id="tranLineTable" name="tranLineTable" style="margin-left: 40px; margin-top: 10px; float: left;"></div>
		</div>
	</div>
	<div class="buttonsDiv" style="width: 680px; margin-bottom: 10px;">
		<input type="button" class="button" id="btnReturn" name="btnReturn" value="Return" style="width:150px;" tabindex="501"/>
	</div>
	
</div>

<script type="text/javascript">	
	if (objUserInfo.selectedAccess == "Transaction") {
		$("userDetailDiv").show();
		$("userGrpDetailDiv").hide();
		$("txtTranUserId").focus();
		$("txtTranUserId").value = selectedUser;
		disableButton("btnModules");
		
		try{
			var row = null;
			var objCurrTran = null;
			var objTran = new Object();
			objTran.objTranListing = JSON.parse('${jsonTranList}');
			objTran.tranList = objTran.objTranListing.rows || [];
			var tbgTran = {
					url: contextPath+"/GIPIPolbasicController?action=getTranList&refresh=1&userId="+selectedUser,
				options: {
					width: '600px',
					height: '160px',
					id: 1,
					onCellFocus: function(element, value, x, y, id){
						row = y;
						objCurrTran = tranTableGrid.geniisysRows[y];
						selectedTranCd = objCurrTran.tranCd;
						issTableGrid.url = contextPath + "/GIPIPolbasicController?action=getTranIssList&tranCd="+objCurrTran.tranCd+"&userId="+selectedUser;
						issTableGrid._refreshList();
						enableButton("btnModules");
						tranTableGrid.keys.removeFocus(tranTableGrid.keys._nCurrentFocus, true);
						tranTableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus: function(){
						refreshTbg(1);
						tranTableGrid.keys.removeFocus(tranTableGrid.keys._nCurrentFocus, true);
						tranTableGrid.keys.releaseKeys();
		            },
	                onSort: function(){
	                	refreshTbg(1);
	                	tranTableGrid.keys.removeFocus(tranTableGrid.keys._nCurrentFocus, true);
	                	tranTableGrid.keys.releaseKeys();
	                },
	                prePager: function(){
	                	refreshTbg(1);
	                	tranTableGrid.keys.removeFocus(tranTableGrid.keys._nCurrentFocus, true);
	                	tranTableGrid.keys.releaseKeys();
	                },
					onRefresh: function(){
						refreshTbg(1);
						tranTableGrid.keys.removeFocus(tranTableGrid.keys._nCurrentFocus, true);
						tranTableGrid.keys.releaseKeys();
					},
					toolbar: {
						elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
						onFilter: function(){
							refreshTbg(1);
							tranTableGrid.keys.removeFocus(tranTableGrid.keys._nCurrentFocus, true);
							tranTableGrid.keys.releaseKeys();
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
					{	id: 'tranCd',
						title: 'Tran Code',
						width: '200px',
						filterOption: true,
						filterOptionType: "integerNoNegative"
					},
					{	id: 'tranDesc',
						title: 'Description',
						width: '360px',
						filterOption: true
					}
					],
				rows: objTran.tranList
			};
			
			tranTableGrid = new MyTableGrid(tbgTran);
			tranTableGrid.pager = objTran.objTranListing;
			tranTableGrid.render('transactionTable');
			tranTableGrid.afterRender = function(y) {
				if (tranTableGrid.geniisysRows.length == 0) {
					disableButton("btnModules");
				}
			};
		}catch (e) {
			showErrorMessage("transactionTableGrid", e);
		}

		try{
			var row = null;
			var objCurrIss = null;
			objUserInfo.objIssListing = [];
			objUserInfo.issList = objUserInfo.objIssListing.rows || [];
			var tbgIss = {
					url: contextPath+"/GIPIPolbasicController?action=getTranIssList",
				options: {
					width: '600px',
					height: '160px',
					id: 1,
					onCellFocus: function(element, value, x, y, id){
						row = y;
						objCurrIss = issTableGrid.geniisysRows[y];
						lineTableGrid.url = contextPath + "/GIPIPolbasicController?action=getTranLineList&tranCd="+objCurrTran.tranCd+"&userId="+selectedUser+"&issCd="+objCurrIss.issCd;
						lineTableGrid._refreshList();
						issTableGrid.keys.removeFocus(issTableGrid.keys._nCurrentFocus, true);
						issTableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus: function(){
						refreshTbg(2);
						issTableGrid.keys.removeFocus(issTableGrid.keys._nCurrentFocus, true);
						issTableGrid.keys.releaseKeys();
		            },
	                onSort: function(){
	                	refreshTbg(2);
	                	issTableGrid.keys.removeFocus(issTableGrid.keys._nCurrentFocus, true);
	                	issTableGrid.keys.releaseKeys();
	                },
	                prePager: function(){
	                	refreshTbg(2);
	                	issTableGrid.keys.removeFocus(issTableGrid.keys._nCurrentFocus, true);
	                	issTableGrid.keys.releaseKeys();
	                },
					onRefresh: function(){
						refreshTbg(2);
						issTableGrid.keys.removeFocus(issTableGrid.keys._nCurrentFocus, true);
						issTableGrid.keys.releaseKeys();
					},
					toolbar: {
						elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
						onFilter: function(){
							refreshTbg(2);
							issTableGrid.keys.removeFocus(issTableGrid.keys._nCurrentFocus, true);
							issTableGrid.keys.releaseKeys();
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
					{	id: 'issCd',
						title: 'Issue Code',
						width: '200px',
						filterOption: true
					},
					{	id: 'issName',
						title: 'Description',
						width: '360px',
						filterOption: true
					}
					],
				rows: objUserInfo.issList
			};
			
			issTableGrid = new MyTableGrid(tbgIss);
			issTableGrid.pager = objUserInfo.objIssListing;
			issTableGrid.render('tranIssTable');
		}catch (e) {
			showErrorMessage("issTableGrid", e);
		}
		
		try{
			var row = null;
			var objCurrLine = null;
			objUserInfo.objLineListing = [];
			objUserInfo.lineList = objUserInfo.objLineListing.rows || [];
			var tbgLine = {
					url: contextPath+"/GIPIPolbasicController?action=getTranLineList",
				options: {
					width: '600px',
					height: '160px',
					id: 1,
					onCellFocus: function(element, value, x, y, id){
						row = y;
						objCurrLine = lineTableGrid.geniisysRows[y];
						lineTableGrid.keys.removeFocus(lineTableGrid.keys._nCurrentFocus, true);
						lineTableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus: function(){
						lineTableGrid.keys.removeFocus(lineTableGrid.keys._nCurrentFocus, true);
						lineTableGrid.keys.releaseKeys();
		            },
	                onSort: function(){
	                	lineTableGrid.keys.removeFocus(lineTableGrid.keys._nCurrentFocus, true);
	                	lineTableGrid.keys.releaseKeys();
	                },
	                prePager: function(){
	                	lineTableGrid.keys.removeFocus(lineTableGrid.keys._nCurrentFocus, true);
	                	lineTableGrid.keys.releaseKeys();
	                },
					onRefresh: function(){
						lineTableGrid.keys.removeFocus(lineTableGrid.keys._nCurrentFocus, true);
						lineTableGrid.keys.releaseKeys();
					},
					toolbar: {
						elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
						onFilter: function(){
							lineTableGrid.keys.removeFocus(lineTableGrid.keys._nCurrentFocus, true);
							lineTableGrid.keys.releaseKeys();
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
					{	id: 'lineCd',
						title: 'Line Code',
						width: '200px',
						filterOption: true
					},
					{	id: 'lineName',
						title: 'Description',
						width: '360px',
						filterOption: true
					}
					],
				rows: objUserInfo.issList
			};
			
			lineTableGrid = new MyTableGrid(tbgLine);
			lineTableGrid.pager = objUserInfo.objLineListing;
			lineTableGrid.render('tranLineTable');
		}catch (e) {
			showErrorMessage("lineTableGrid", e);
		}
	}else {		////////////////////////////////////////////////////////////////USER GRP///////////////////////////////
		$("userDetailDiv").hide();
		$("userGrpDetailDiv").show();
		$("txtTranUserGrp").focus();
		$("txtTranUserGrp").value = selectedUserGrp;
		$("txtTranUserGrpDesc").value = selectedUserGrpDesc;
		$("txtTranUserGrpIss").value = selectedGrpIssCd;
		disableButton("btnModules");
		try{
			var row = null;
			var objCurrTran = null;
			var objTran = new Object();
			objTran.objTranListing = JSON.parse('${jsonTranGrp}');
			objTran.tranList = objTran.objTranListing.rows || [];
			var tbgTran = {
					url: contextPath+"/GIPIPolbasicController?action=getGrpTranList&refresh=1&userGrp="+selectedUserGrp,
				options: {
					width: '600px',
					height: '160px',
					id: 1,
					onCellFocus: function(element, value, x, y, id){
						row = y;
						objCurrTran = tranTableGrid.geniisysRows[y];
						selectedTranCdGrp = objCurrTran.tranCdGrp;
						issTableGrid.url = contextPath + "/GIPIPolbasicController?action=getGrpTranIssList&tranCd="+objCurrTran.tranCdGrp+"&userGrp="+selectedUserGrp;
						issTableGrid._refreshList();
						enableButton("btnModules");
						tranTableGrid.keys.removeFocus(tranTableGrid.keys._nCurrentFocus, true);
						tranTableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus: function(){
						refreshTbg(3);
						tranTableGrid.keys.removeFocus(tranTableGrid.keys._nCurrentFocus, true);
						tranTableGrid.keys.releaseKeys();
		            },
	                onSort: function(){
	                	refreshTbg(3);
	                	tranTableGrid.keys.removeFocus(tranTableGrid.keys._nCurrentFocus, true);
	                	tranTableGrid.keys.releaseKeys();
	                },
	                prePager: function(){
	                	refreshTbg(3);
	                	tranTableGrid.keys.removeFocus(tranTableGrid.keys._nCurrentFocus, true);
	                	tranTableGrid.keys.releaseKeys();
	                },
					onRefresh: function(){
						refreshTbg(3);
						tranTableGrid.keys.removeFocus(tranTableGrid.keys._nCurrentFocus, true);
						tranTableGrid.keys.releaseKeys();
					},
					toolbar: {
						elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
						onFilter: function(){
							refreshTbg(1);
							tranTableGrid.keys.removeFocus(tranTableGrid.keys._nCurrentFocus, true);
							tranTableGrid.keys.releaseKeys();
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
					{	id: 'tranCdGrp',
						title: 'Tran Code',
						width: '200px',
						filterOption: true,
						filterOptionType: "integerNoNegative"
					},
					{	id: 'tranDescGrp',
						title: 'Description',
						width: '360px',
						filterOption: true
					}
					],
				rows: objTran.tranList
			};
			
			tranTableGrid = new MyTableGrid(tbgTran);
			tranTableGrid.pager = objTran.objTranListing;
			tranTableGrid.render('transactionTable');
			tranTableGrid.afterRender = function(y) {
				if (tranTableGrid.geniisysRows.length == 0) {
					disableButton("btnModules");
				}
			};
		}catch (e) {
			showErrorMessage("transactionTableGrid", e);
		}

		try{
			var row = null;
			var objCurrIss = null;
			objUserInfo.objIssListing = [];
			objUserInfo.issList = objUserInfo.objIssListing.rows || [];
			var tbgIss = {
					url: contextPath+"/GIPIPolbasicController?action=getGrpTranIssList",
				options: {
					width: '600px',
					height: '160px',
					id: 1,
					onCellFocus: function(element, value, x, y, id){
						row = y;
						objCurrIss = issTableGrid.geniisysRows[y];
						lineTableGrid.url = contextPath + "/GIPIPolbasicController?action=getGrpTranLineList&tranCd="+objCurrTran.tranCdGrp+"&userGrp="+selectedUserGrp+"&issCd="+objCurrIss.issCdGrp;
						lineTableGrid._refreshList();
						issTableGrid.keys.removeFocus(issTableGrid.keys._nCurrentFocus, true);
						issTableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus: function(){
						refreshTbg(4);
						issTableGrid.keys.removeFocus(issTableGrid.keys._nCurrentFocus, true);
						issTableGrid.keys.releaseKeys();
		            },
	                onSort: function(){
	                	refreshTbg(4);
	                	issTableGrid.keys.removeFocus(issTableGrid.keys._nCurrentFocus, true);
	                	issTableGrid.keys.releaseKeys();
	                },
	                prePager: function(){
	                	refreshTbg(4);
	                	issTableGrid.keys.removeFocus(issTableGrid.keys._nCurrentFocus, true);
	                	issTableGrid.keys.releaseKeys();
	                },
					onRefresh: function(){
						refreshTbg(4);
						issTableGrid.keys.removeFocus(issTableGrid.keys._nCurrentFocus, true);
						issTableGrid.keys.releaseKeys();
					},
					toolbar: {
						elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
						onFilter: function(){
							refreshTbg(3);
							issTableGrid.keys.removeFocus(issTableGrid.keys._nCurrentFocus, true);
							issTableGrid.keys.releaseKeys();
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
					{	id: 'issCdGrp',
						title: 'Issue Code',
						width: '200px',
						filterOption: true
					},
					{	id: 'issNameGrp',
						title: 'Description',
						width: '360px',
						filterOption: true
					}
					],
				rows: objUserInfo.issList
			};
			
			issTableGrid = new MyTableGrid(tbgIss);
			issTableGrid.pager = objUserInfo.objIssListing;
			issTableGrid.render('tranIssTable');
		}catch (e) {
			showErrorMessage("issTableGrid", e);
		}
		
		try{
			var row = null;
			var objCurrLine = null;
			objUserInfo.objLineListing = [];
			objUserInfo.lineList = objUserInfo.objLineListing.rows || [];
			var tbgLine = {
					url: contextPath+"/GIPIPolbasicController?action=getGrpTranLineList",
				options: {
					width: '600px',
					height: '160px',
					id: 1,
					onCellFocus: function(element, value, x, y, id){
						row = y;
						objCurrLine = lineTableGrid.geniisysRows[y];
						lineTableGrid.keys.removeFocus(lineTableGrid.keys._nCurrentFocus, true);
						lineTableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus: function(){
						lineTableGrid.keys.removeFocus(lineTableGrid.keys._nCurrentFocus, true);
						lineTableGrid.keys.releaseKeys();
		            },
	                onSort: function(){
	                	lineTableGrid.keys.removeFocus(lineTableGrid.keys._nCurrentFocus, true);
	                	lineTableGrid.keys.releaseKeys();
	                },
	                prePager: function(){
	                	lineTableGrid.keys.removeFocus(lineTableGrid.keys._nCurrentFocus, true);
	                	lineTableGrid.keys.releaseKeys();
	                },
					onRefresh: function(){
						lineTableGrid.keys.removeFocus(lineTableGrid.keys._nCurrentFocus, true);
						lineTableGrid.keys.releaseKeys();
					},
					toolbar: {
						elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
						onFilter: function(){
							lineTableGrid.keys.removeFocus(lineTableGrid.keys._nCurrentFocus, true);
							lineTableGrid.keys.releaseKeys();
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
					{	id: 'lineCdGrp',
						title: 'Line Code',
						width: '200px',
						filterOption: true
					},
					{	id: 'lineNameGrp',
						title: 'Description',
						width: '360px',
						filterOption: true
					}
					],
				rows: objUserInfo.issList
			};
			
			lineTableGrid = new MyTableGrid(tbgLine);
			lineTableGrid.pager = objUserInfo.objLineListing;
			lineTableGrid.render('tranLineTable');
		}catch (e) {
			showErrorMessage("lineTableGrid", e);
		}
	}
	
	function refreshTbg(tbg) {
		if (tbg == 1) {
			disableButton("btnModules");
			selectedTranCd = null;
			issTableGrid.url = contextPath + "/GIPIPolbasicController?action=getTranIssList";
			issTableGrid._refreshList();
			lineTableGrid.url = contextPath + "/GIPIPolbasicController?action=getTranLineList";
			lineTableGrid._refreshList();
		}else if (tbg == 2) {
			lineTableGrid.url = contextPath + "/GIPIPolbasicController?action=getTranLineList";
			lineTableGrid._refreshList();
		}else if (tbg == 3) {
			disableButton("btnModules");
			selectedTranCdGrp = null;
			issTableGrid.url = contextPath + "/GIPIPolbasicController?action=getGrpTranIssList";
			issTableGrid._refreshList();
			lineTableGrid.url = contextPath + "/GIPIPolbasicController?action=getGrpTranLineList";
			lineTableGrid._refreshList();
		}else if (tbg == 4) {
			lineTableGrid.url = contextPath + "/GIPIPolbasicController?action=getGrpTranLineList";
			lineTableGrid._refreshList();
		}
	}
	
	function showUserInfoModule() {
		try {
			overlayModule = Overlay.show(contextPath + "/GIPIPolbasicController", {
				urlContent : true,
				urlParameters : {action : "getModuleList",
								 userId : selectedUser,
								 tranCd : selectedTranCd},
				title : "Modules",
				height : '483px',
				width : '815px',
				draggable : true
			});
		} catch (e) {
			showErrorMessage("showUserInfoModule Overlay", e);
		}
	}
	
	function showUserInfoGrpModule() {
		try {
			overlayModule = Overlay.show(contextPath + "/GIPIPolbasicController", {
				urlContent : true,
				urlParameters : {action : "getGrpModuleList",
								 userGrp : selectedUserGrp,
								 tranCd : selectedTranCdGrp},
				title : "Modules",
				height : '483px',
				width : '815px',
				draggable : true
			});
		} catch (e) {
			showErrorMessage("showUserInfoGrpModule Overlay", e);
		}
	}
	
	$("btnModules").observe("click", function() {
		if (objUserInfo.selectedAccess == "Transaction") {
			showUserInfoModule();
		}else {
			showUserInfoGrpModule();
		}
	});
	
	$("btnReturn").observe("click", function() {
		overlayTransaction.close();
	});
	
</script>