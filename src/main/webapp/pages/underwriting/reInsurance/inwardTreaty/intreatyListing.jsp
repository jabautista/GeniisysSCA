<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="intreatyListingMainDiv" name="intreatyListingMainDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>List of Inward Treaty</label>
		</div>
	</div>
	<div align="center" class="sectionDiv" style="padding-top:15px; padding-bottom: 15px;">
		<table>
			<tr>
				<td class="rightAligned">Line</td>
				<td class="leftAligned">
					<span class="lovSpan required" style="width: 300px;">
						<input type="hidden" id="lineCd" name="lineCd" lastValidValue="${lineCd}" value="${lineCd}"/>
						<input type="text" id="lineName" name="lineName" style="width: 275px; float: left; border: none; height: 14px; margin: 0;" class="allCaps required" tabindex="101" lastValidValue="${lineName}" value="${lineName}" ignoreDelKey="1" maxlength="20"/>  
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLine" name="searchLine" alt="Go" style="float: right;"/>
					</span>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Treaty Year</td>
				<td class="leftAligned">
					<span class="lovSpan required" style="width: 300px;">
						<input type="hidden" id="trtyYy" name="trtyYy" lastValidValue="${trtyYy}" value="${trtyYy}"/>
						<input type="text" id="dspTrtyYy" name="dspTrtyYy" style="width: 275px; float: left; border: none; height: 14px; margin: 0;" class="integerNoNegativeUnformattedNoComma required" tabindex="102" lastValidValue="${dspTrtyYy}" value="${dspTrtyYy}" ignoreDelKey="1" maxlength="4"/>  
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchTrtyYy" name="searchTrtyYy" alt="Go" style="float: right;"/>
					</span>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Treaty Name</td>
				<td class="leftAligned">
					<span class="lovSpan required" style="width: 300px;">
						<input type="hidden" id="shareCd" name="shareCd" lastValidValue="${shareCd}" value="${shareCd}"/>
						<input type="text" id="trtyName" name="trtyName" style="width: 275px; float: left; border: none; height: 14px; margin: 0;" class="allCaps required" tabindex="103" lastValidValue="${trtyName}" value="${trtyName}" ignoreDelKey="1" maxlength="30"/>  
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchTrtyName" name="searchTrtyName" alt="Go" style="float: right;"/>
					</span>
				</td>
			</tr>
		</table>
		<div id="intrtyFlagOptionsDiv" style="float: left; margin-top: 15px; margin-left: 280px;">
			<input type="radio" id="intrtyFlagNew" name="intrtyFlag" value="1" checked="checked" disabled="disabled" style="margin: 0 5px 0 50px; float: left;"/><label for="intrtyFlagNew">New</label>
			<input type="radio" id="intrtyFlagApproved" name="intrtyFlag" value="2" disabled="disabled" style="margin: 0 5px 0 50px; float: left;"/><label for="intrtyFlagApproved">Approved</label>
			<input type="radio" id="intrtyFlagCancelled" name="intrtyFlag" value="3" disabled="disabled" style="margin: 0 5px 0 50px; float: left;"/><label for="intrtyFlagCancelled">Cancelled</label>
		</div>
		<input type="hidden" id="userId" name="userId" value="${userId}">
	</div>
	<div class="sectionDiv">
		<div id="intreatyTableGridDiv" style="padding: 10px 0 10px 10px;">
			<div id="intreatyTableGrid" style="height: 331px"></div>
		</div>
	</div>		
</div>	

<script type="text/javascript">
	setModuleId("GIRIS056");
	setDocumentTitle("Inward Treaty Listing");
	initializeAll();
	initializeAccordion();
	hideToolbarButton("btnToolbarPrint");
	disableToolbarButton("btnToolbarEnterQuery");
	hideToolbarButton("btnToolbarExecuteQuery");
	
	try{
		var exec = "Y";
		var giriIntreatyTableGrid = JSON.parse('${giriIntreatyTableGrid}');
		var curr = null;
		var objIntreatyRows = [];
		var objCheckedRows = [];
		var intreatyTableModel = {
			url : contextPath+"/GIRIIntreatyController?action=showIntreatyListing&refresh=1",
			options: {
				toolbar:{
					elements: [MyTableGrid.ADD_BTN, MyTableGrid.EDIT_BTN, MyTableGrid.COPY_BTN, MyTableGrid.APPROVE_BTN, MyTableGrid.CANCEL_BTN, MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onRefresh: function() {
						clearCheckedRows();
						tbgIntreaty.keys.removeFocus(tbgIntreaty.keys._nCurrentFocus, true);
						tbgIntreaty.keys.releaseKeys();
					},
	             	onAdd: function(){
	             		tbgIntreaty.keys.removeFocus(tbgIntreaty.keys._nCurrentFocus, true);
	 					tbgIntreaty.keys.releaseKeys();
	             		if(checkAllRequiredFieldsInDiv("intreatyListingMainDiv")){
	             			if(!checkUserModule('GIRIS056A')){
	            				showMessageBox("You are not allowed to access this module.", "E");
	            				return false;	
	            			}else{
	             				showCreateIntreaty(null, $F("lineCd"), $F("trtyYy"), $F("shareCd"));
	            			}
	             		}
	             		return false;
	             	},
					onEdit: function(){
						tbgIntreaty.keys.removeFocus(tbgIntreaty.keys._nCurrentFocus, true);
	 					tbgIntreaty.keys.releaseKeys();
						if(curr == null){
	 						showMessageBox("Please select a record first.", imgMessage.INFO);
						}else{
							if(!checkUserModule('GIRIS056A')){
	            				showMessageBox("You are not allowed to access this module.", "E");
	            				return false;	
	            			}else{
								showCreateIntreaty(objIntreatyRows[curr].intreatyId, $F("lineCd"), $F("trtyYy"), $F("shareCd"));
	            			}
	            		}
					},
					onCopy: function(){
						tbgIntreaty.keys.removeFocus(tbgIntreaty.keys._nCurrentFocus, true);
	 					tbgIntreaty.keys.releaseKeys();
						if(curr == null){
	 						showMessageBox("Please select a record first.", imgMessage.INFO);
						}else{
							showConfirmBox("Confirmation", "Copy Intrty No. " + objIntreatyRows[curr].intrtyNo + "?", "Yes", "No", 
									function(){										
										copyIntreaty(objIntreatyRows[curr].intreatyId, objIntreatyRows[curr].intrtyNo);
									}, 
									"");
						}
	             	},
	             	onApprove: function(){
	             		tbgIntreaty.keys.removeFocus(tbgIntreaty.keys._nCurrentFocus, true);
	 					tbgIntreaty.keys.releaseKeys();
	 					validateApprove();
	             	},
	             	onCancel: function(){
	             		tbgIntreaty.keys.removeFocus(tbgIntreaty.keys._nCurrentFocus, true);
	 					tbgIntreaty.keys.releaseKeys();
	 					validateCancel();
	             	}
				},
				width: '900px',
				pager: {},
				validateChangesOnPrePager : false,
				onCellFocus : function(element, value, x, y, id) {
					curr = Number(y);
				},			
				onRemoveRowFocus : function(element, value, x, y, id){
					curr = null;
					tbgIntreaty.keys.releaseKeys();
				},
				onSort : function(){
					tbgIntreaty.keys.removeFocus(tbgIntreaty.keys._nCurrentFocus, true);
					tbgIntreaty.keys.releaseKeys();
				},
				onRefresh : function(){
					clearCheckedRows();
					tbgIntreaty.keys.removeFocus(tbgIntreaty.keys._nCurrentFocus, true);
					tbgIntreaty.keys.releaseKeys();
				}
			},									
			columnModel: [
				{	id: 'recordStatus',
				    title: '',
				    width: '0',
				    visible: false
				},
				{	id: 'divCtrId',
					width: '0',
					visible: false 
				},
				{	id: 'intreatyId',
					width: '0',
					visible: false 
				},
				{
					id: 'processTag',
				    title : '&nbsp;&nbsp;P',
				    altTitle: 'For Approval',
		            width: '26px',
				    sortable: false,
			   		editable: true,
				    hideSelectAllBox: true,
				    editor: new MyTableGrid.CellCheckbox({
				    	 getValueOf: function(value){
		            		if (value){
								return "Y";
		            		}else{
								return "N";	
		            		}	
		            	},
		            	onClick: function(value, checked){
		            		tbgIntreaty.keys.releaseKeys();
		            		whenCheckBoxChanged(checked);
		            	}
		            })
				}, 
				{   id: 'riName',
		            title: 'Reinsurer',
		            width: '280px',
		            editable: false,
		            filterOption: true	            
				},				
				{	id: 'intrtyNo',
		            title: 'Intrty No',
		            width: '90px',
		            editable: false,
		            filterOption: true	            
				},
				{	id : 'acceptDate',
					title: 'Accept Date',
					titleAlign : 'center',
		            width: '100px',
		            editable: false,
					align: 'center',
					type: 'date',
					format: 'mm-dd-yyyy',
					filterOption: true,
					filterOptionType: 'formattedDate'															
				},
				{	id: 'userId',
		            title: 'User',
		            width: '90px',
		            editable: false,
		            filterOption: true	            
				},
				{	id: 'lastUpdate',
		            title: 'Last Update',
		            titleAlign : 'center',
		            width: '100px',
		            editable: false,
					align: 'center',
					type: 'date',
					format: 'mm-dd-yyyy',
					filterOption: true,
					filterOptionType: 'formattedDate'										
				},
				{	id: 'approveBy',
		            title: 'Approved By',
		            width: '90px',
		            editable: false,
		            filterOption: true	            
				},
				{	id: 'approveDate',
		            title: 'Date Approved',
		            titleAlign : 'center',
		            width: '100px',
		            editable: false,
					align: 'center',
					type: 'date',
					format: 'mm-dd-yyyy',
					filterOption: true,
					filterOptionType: 'formattedDate'										
				}
			],
			rows: giriIntreatyTableGrid.rows || []
		};
		
		tbgIntreaty = new MyTableGrid(intreatyTableModel);
		tbgIntreaty.pager = giriIntreatyTableGrid;
		tbgIntreaty.render('intreatyTableGrid');
		tbgIntreaty.afterRender = function(){
			objIntreatyRows = tbgIntreaty.geniisysRows;
			
			for(var i=0; i<objCheckedRows.length; i++){
				for(var j = 0; j < objIntreatyRows.length; j++){
					if(objCheckedRows[i].intreatyId == objIntreatyRows[j].intreatyId){
						$("mtgInput"+tbgIntreaty._mtgId+"_"+tbgIntreaty.getColumnIndex('processTag')+','+j).checked = true;
					}
				}
			}
			
			if(exec == "Y"){
				if(nvl($F("shareCd"), "") != ""){
					exec = "N";
					executeQuery();
				}
			}
		};
	}catch(e){
		showErrorMessage("intreatyListing.jsp", e);
	}
	
	function whenCheckBoxChanged(checked){
		if(checked){
			objIntreatyRows[curr].recordStatus = 1;
			objCheckedRows.push(objIntreatyRows[curr]);
		}else{
			for (var i=0; i<objCheckedRows.length; i++){
				if (objCheckedRows[i].intreatyId == objIntreatyRows[curr].intreatyId) {
					objCheckedRows.splice(i, 1);
				}
			}
		}
	}
	
	function clearCheckedRows(){
		for (var i=0; i<objCheckedRows.length; i++){
			for ( var j = 0; j < objIntreatyRows.length; j++) {
				if (objCheckedRows[i].intreatyId == objIntreatyRows[j].intreatyId) {
					$("mtgInput"+tbgIntreaty._mtgId+"_"+tbgIntreaty.getColumnIndex('processTag')+','+j).checked = false;
				}
			}
		}
		
		objCheckedRows = [];
	}
	
	function getIntrtyFlag(){
		var rbCheck = 1;
		$$("input[name='intrtyFlag']").each(function(rb){
			if(rb.checked == true){
				rbCheck = rb.value;
			}
		});
		return rbCheck;
	}
	
	function executeQuery(){
		enableToolbarButton("btnToolbarEnterQuery");
		disableSearch("searchLine");
		disableSearch("searchTrtyYy");
		disableSearch("searchTrtyName");
		$("lineName").readOnly = true;
		$("dspTrtyYy").readOnly = true;
		$("trtyName").readOnly = true;
		$("intrtyFlagNew").disabled = false;
		$("intrtyFlagApproved").disabled = false;
		$("intrtyFlagCancelled").disabled = false;
		tbgIntreaty.url = contextPath+"/GIRIIntreatyController?action=showIntreatyListing&refresh=1&intrtyFlag=1&lineCd="+$F("lineCd")+"&trtyYy="+$F("trtyYy")+"&shareCd="+$F("shareCd");
		tbgIntreaty._refreshList();
	}
	
	function clearLine(){
		$("lineCd").value = "";
		$("lineName").value = "";
		$("lineCd").setAttribute("lastValidValue", "");
		$("lineName").setAttribute("lastValidValue", "");
		disableToolbarButton("btnToolbarEnterQuery");
	}
	
	function clearTreatyYear(){
		$("trtyYy").value = "";
		$("dspTrtyYy").value = "";
		$("trtyYy").setAttribute("lastValidValue", "");
		$("dspTrtyYy").setAttribute("lastValidValue", "");
	}
	
	function clearTreatyName(){
		$("shareCd").value = "";
		$("trtyName").value = "";
		$("shareCd").setAttribute("lastValidValue", "");
		$("trtyName").setAttribute("lastValidValue", "");
	}
	
	function showLineLOV(){
 		try {			
			LOV.show({
				controller : "UWReinsuranceLOVController",
				urlParameters : {
					action : "getGIRIS056LineLOV",
					filterText: $F("lineName") != $("lineName").getAttribute("lastValidValue") ? $F("lineName") + "%" : "%",
					page : 1
				},
				title : "List of Lines",
				width : 450,
				height : 390,
				columnModel : [ {
					id : "lineCd",
					title : "Line Code",
					width : '120px'
				}, {
					id : "lineName",
					title : "Line Name",
					width : '315px'
				} ],
				draggable : true,
				autoSelectOneRecord: true,			
				onSelect : function(row) {
					if (row != null || row != undefined) {
						$("lineCd").value = row.lineCd;
						$("lineName").value = unescapeHTML2(row.lineName);
						if($F("lineCd") != $("lineCd").getAttribute("lastValidValue")){
							$("lineCd").setAttribute("lastValidValue", $F("lineCd"));
							$("lineName").setAttribute("lastValidValue", $F("lineName"));
							clearTreatyYear();
							clearTreatyName();
						}
						enableToolbarButton("btnToolbarEnterQuery");
					}
				},
				onCancel: function(){
					$("lineCd").value = $("lineCd").readAttribute("lastValidValue");
					$("lineName").value = $("lineName").readAttribute("lastValidValue");
					$("lineName").focus();
				},
				onUndefinedRow:	function(){
					$("lineCd").value = $("lineCd").readAttribute("lastValidValue");
					$("lineName").value = $("lineName").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "lineName");
				}
			});
		} catch (e) {
			showErrorMessage("showLineLOV", e);
		}		 
	}
	
	function showTrtyYyLOV(){
 		try {			
			LOV.show({
				controller : "UWReinsuranceLOVController",
				urlParameters : {
					action : "getGIRIS056TrtyYyLOV",
					lineCd : $F("lineCd"),
					filterText: $F("dspTrtyYy") != $("dspTrtyYy").getAttribute("lastValidValue") ? $F("dspTrtyYy") + "%" : "%",
					page : 1
				},
				title : "List of Treaty Year",
				width : 450,
				height : 390,
				columnModel : [ {
					id : "dspTrtyYy",
					title : "Treaty Year",
					width : '150px'
				} ],
				draggable : true,
				autoSelectOneRecord: true,			
				onSelect : function(row) {
					if (row != null || row != undefined) {
						$("trtyYy").value = row.trtyYy;
						$("dspTrtyYy").value = row.dspTrtyYy;
						if($F("trtyYy") != $("trtyYy").getAttribute("lastValidValue")){
							$("trtyYy").setAttribute("lastValidValue", $F("trtyYy"));
							$("dspTrtyYy").setAttribute("lastValidValue", $F("dspTrtyYy"));
							clearTreatyName();
						}
					}
				},
				onCancel: function(){
					$("trtyYy").value = $("trtyYy").readAttribute("lastValidValue");
					$("dspTrtyYy").value = $("dspTrtyYy").readAttribute("lastValidValue");
					$("dspTrtyYy").focus();
				},
				onUndefinedRow:	function(){
					$("trtyYy").value = $("trtyYy").readAttribute("lastValidValue");
					$("dspTrtyYy").value = $("dspTrtyYy").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "dspTrtyYy");
				}
			});
		} catch (e) {
			showErrorMessage("showTrtyYyLOV", e);
		}		 
	}
	
	function showTrtyNameLOV(){
 		try {			
			LOV.show({
				controller : "UWReinsuranceLOVController",
				urlParameters : {
					action : "getGIRIS056TrtyNameLOV",
					lineCd : $F("lineCd"),
					trtyYy : $F("trtyYy"),
					filterText: $F("trtyName") != $("trtyName").getAttribute("lastValidValue") ? $F("trtyName") + "%" : "%",
					page : 1
				},
				title : "List of Treaty Names",
				width : 450,
				height : 390,
				columnModel : [ {
					id : "trtyName",
					title : "Treaty Name",
					width : '437px'
				} ],
				draggable : true,
				autoSelectOneRecord: true,			
				onSelect : function(row) {
					if (row != null || row != undefined) {
						$("shareCd").value = row.shareCd;
						$("trtyName").value = unescapeHTML2(row.trtyName);
						if($F("shareCd") != $("shareCd").getAttribute("lastValidValue")){
							$("shareCd").setAttribute("lastValidValue", $F("shareCd"));
							$("trtyName").setAttribute("lastValidValue", $F("trtyName"));
						}
						executeQuery();
					}
				},
				onCancel: function(){
					$("shareCd").value = $("shareCd").readAttribute("lastValidValue");
					$("trtyName").value = $("trtyName").readAttribute("lastValidValue");
					$("trtyName").focus();
				},
				onUndefinedRow:	function(){
					$("shareCd").value = $("shareCd").readAttribute("lastValidValue");
					$("trtyName").value = $("trtyName").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "trtyName");
				}
			});
		} catch (e) {
			showErrorMessage("showTrtyNameLOV", e);
		}		 
	}
	
	function copyIntreaty(intreatyId, intrtyNo){
		try{
			new Ajax.Request(contextPath+"/GIRIIntreatyController?action=copyIntreaty", {
				method: "POST",
				asynchronous: true,
				evalScripts: true,
				parameters: {
					intreatyId: intreatyId,
					intrtyNo: intrtyNo
				},
				onCreate: function() {
					showNotice("Copying Inward Treaty, please wait...");
				},
				onComplete: function (response) {
					if (checkErrorOnResponse(response)) {
						hideNotice("");
						showMessageBox(response.responseText, imgMessage.INFO);
						tbgIntreaty.clear();
						tbgIntreaty.refresh();
						curr = null;
					}
				}
			});
		}catch(e){
			showErrorMessage("copyIntreaty", e);
		}
	}
	
	function validateApprove(){
		var intrtyFlag = getIntrtyFlag();
		
		if(objCheckedRows.length > 0){
			if(intrtyFlag==2){
				showMessageBox("Records are already tagged as approve.", imgMessage.INFO);
			}else if(intrtyFlag==3){
				showMessageBox("You cannot approve cancelled records.", imgMessage.INFO);
			}else{
				if(validateUserFunc3($F("userId"), "AP", "GIRIS056")){
					var confMsg = "Approve Various Inward Treaty Records?";
					if(objCheckedRows.length == 1){
						confMsg = "Approve Inward Treaty Record " + objCheckedRows[0].intrtyNo + "?";
					}
					showConfirmBox("Confirmation", confMsg, "Yes", "No",
							function(){
								approveIntreaty();
							},
							"");
				}else{
					showMessageBox($F("userId") + " is not allowed to approve inward treaty record.", imgMessage.INFO);
				}
			}
		}else{
			showMessageBox("There are no records tagged for approval.", imgMessage.INFO);
		}
	}
	
	function approveIntreaty(){
		try{
			for(var i=0; i<objCheckedRows.length; i++){
				new Ajax.Request(contextPath+"/GIRIIntreatyController?action=approveIntreaty", {
					method: "POST",
					asynchronous: true,
					evalScripts: true,
					parameters: {
						intreatyId: objCheckedRows[i].intreatyId
					},
					onCreate: function() {
						showNotice("Approving Inward Treaty, please wait...");
					},
					onComplete: function (response) {
						if(checkErrorOnResponse(response)){
							hideNotice("");
						}
					}
				});
			}
			showMessageBox("Records successfully approved.", imgMessage.SUCCESS);
			objCheckedRows = [];
			curr = null;
			tbgIntreaty.clear();
			tbgIntreaty.refresh();
		}catch(e){
			showErrorMessage("approveIntreaty", e);
		}
	}
	
	function validateCancel(){
		var intrtyFlag = getIntrtyFlag();
		
		if(objCheckedRows.length > 0){
			if(intrtyFlag==3){
				showMessageBox("Records are already tagged as cancelled.", imgMessage.INFO);
			}else{
				if(validateUserFunc3($F("userId"), "CP", "GIRIS056")){
					var confMsg = "Cancel Various Inward Treaty Records?";
					if(objCheckedRows.length == 1){
						confMsg = "Cancel Inward Treaty Record " + objCheckedRows[0].intrtyNo + "?";
					}
					showConfirmBox("Confirmation", confMsg, "Yes", "No",
							function(){
								cancelIntreaty();
							},
							"");
				}else{
					showMessageBox($F("userId") + " is not allowed to cancel inward treaty record.", imgMessage.INFO);
				}
			}
		}else{
			showMessageBox("There are no records tagged for cancellation.", imgMessage.INFO);
		}
	}
	
	function cancelIntreaty(){
		try{
			for(var i=0; i<objCheckedRows.length; i++){
				new Ajax.Request(contextPath+"/GIRIIntreatyController?action=cancelIntreaty", {
					method: "POST",
					asynchronous: true,
					evalScripts: true,
					parameters: {
						intreatyId: objCheckedRows[i].intreatyId
					},
					onCreate: function() {
						showNotice("Cancelling Inward Treaty, please wait...");
					},
					onComplete: function (response) {
						if(checkErrorOnResponse(response)){
							hideNotice("");
						}
					}
				});
			}
			showMessageBox("Records successfully cancelled.", imgMessage.SUCCESS);
			objCheckedRows = [];
			curr = null;
			tbgIntreaty.clear();
			tbgIntreaty.refresh();
		}catch(e){
			showErrorMessage("cancelIntreaty", e);
		}
	}
	
	$$("input[name='intrtyFlag']").each(function(rb){
		rb.observe("click", function(){
			if(rb.checked == true){
				tbgIntreaty.url = contextPath+"/GIRIIntreatyController?action=showIntreatyListing&refresh=1&intrtyFlag="+rb.value+"&lineCd="+$F("lineCd")+"&trtyYy="+$F("trtyYy")+"&shareCd="+$F("shareCd");
				tbgIntreaty._refreshList();
			}
		});
	});
	
	$("btnToolbarEnterQuery").observe("click", function() {
		showIntreatyListing();
	});
	
	$("btnToolbarExit").observe("click", function() {
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});
	
	$("searchLine").observe("click", function() {
		showLineLOV();
	});
	
	$("searchTrtyYy").observe("click", function() {
		if($F("lineName") == ""){
			customShowMessageBox("Please select line first.", imgMessage.INFO, "lineName");
		}else{
			showTrtyYyLOV();
		}
	});
	
	$("searchTrtyName").observe("click", function() {
		if($F("lineName") == ""){
			customShowMessageBox("Please select line first.", imgMessage.INFO, "lineName");
		}else if($F("dspTrtyYy") == ""){
			customShowMessageBox("Please select treaty year first.", imgMessage.INFO, "dspTrtyYy");
		}else{
			showTrtyNameLOV();
		}
	});
	
	$("lineName").observe("change",function(){
		if($F("lineName") == ""){
			clearLine();
			clearTreatyYear();
			clearTreatyName();
		}else{
			showLineLOV();
		}
	});
	
	$("dspTrtyYy").observe("change",function(){
		if($F("lineName") == ""){
			clearLine();
			clearTreatyYear();
			clearTreatyName();
			customShowMessageBox("Please select line first.", imgMessage.INFO, "lineName");
		}else{
			if($F("dspTrtyYy") == ""){
				clearTreatyYear();
				clearTreatyName();
			}else{
				showTrtyYyLOV();
			}
		}
	});
	
	$("trtyName").observe("change",function(){
		if($F("lineName") == ""){
			clearLine();
			clearTreatyYear();
			clearTreatyName();
			customShowMessageBox("Please select line first.", imgMessage.INFO, "lineName");
		}else if($F("dspTrtyYy") == ""){
			clearTreatyYear();
			clearTreatyName();
			customShowMessageBox("Please select treaty year first.", imgMessage.INFO, "dspTrtyYy");
		}else{
			if($F("trtyName") == ""){
				clearTreatyName();
			}else{
				showTrtyNameLOV();
			}
		}
	});
	
</script>	
