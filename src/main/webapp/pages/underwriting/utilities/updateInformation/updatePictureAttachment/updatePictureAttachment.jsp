<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giuts029MainDiv" name="giuts029MainDiv" style="margin-bottom: 50px;">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Policy Information</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div class="sectionDiv" id="policyDiv">
		<div style="" align="center">
			<table cellspacing="2" border="0" style="margin: 10px auto;">
	 			<tr>
					<td class="rightAligned" style="width: 85px;" id="lblPolNo">Policy No. </td>
					<td class="leftAligned" style="width: 346px;">
						<input type="hidden" id="hidPolicyId">
						<input type="text" id="txtPolLineCd" name="txtPolLineCd" class="required" style="float: left; width: 30px; margin-right: 3px;" maxlength="2" tabindex="101"/>
						<input type="text" id="txtPolSublineCd" name="txtPolSublineCd" class="required" style="float: left; width: 70px; margin-right: 3px;" maxlength="7" tabindex="102"/>
						<input type="text" id="txtPolIssCd" name="txtPolIssCd" class="required" style="float: left; width: 30px; margin-right: 3px;" maxlength="2" tabindex="103"/>
						<input type="text" id="txtPolIssueYy" name="txtPolIssueYy" class="required" style="float: left; width: 30px; margin-right: 3px; text-align: right;" maxlength="2" tabindex="104"/>
						<input type="text" id="txtPolPolSeqNo" name="txtPolPolSeqNo" class="required" style="float: left; width: 70px; margin-right: 3px; text-align: right;" maxlength="7" tabindex="105"/>
						<input type="text" id="txtPolRenewNo" name="txtPolRenewNo" class="required" style="float: left; width: 30px; margin-right: 3px; text-align: right;" maxlength="2" tabindex="106"/>
						<img id="hrefPolicyNo" alt="Policy No" style="margin-left: 1px; cursor: pointer; margin: 2px 1px 0 0; height: 17px; width: 18px;" class="" src="${pageContext.request.contextPath}/images/misc/searchIcon.png"  tabindex="107"/>						
					</td>
					<td class="rightAligned" style="width: 118px;">Endorsement No.</td>
					<td class="leftAligned">
						<input type="text" id="txtEndtIssCd" name="txtEndtIssCd" class="" style="float: left; width: 30px; margin-right: 3px;" maxlength="2" tabindex="108"/>
						<input type="text" id="txtEndtYy" name="txtEndtYy" class="" style="float: left; width: 30px; margin-right: 3px; text-align: right;" maxlength="2" tabindex="109"/>
						<input type="text" id="txtEndtSeqNo" name="txtEndtSeqNo" class="" style="float: left; width: 70px; margin-right: 3px; text-align: right;" maxlength="7" tabindex="110"/>									
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 85px;" id="lblAssdName">Assured Name </td>
					<td class="leftAligned" colspan="3">
						<input id="txtAssdName" name="txtAssdName" type="text" style="width: 629px;" value="" readonly="readonly" />
					</td>
				</tr>
			</table>			
		</div>		
	</div>	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Item Information</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
			</span>
	   	</div>
	</div>
	<div class="sectionDiv" id="itemDiv">
		<div id="itemTableDiv" style="padding: 10px 0 0 10px;">
			<div id="itemTable" style="height: 300px"></div>
		</div>
		<div style="margin: 10px 0 10px 0;" align="center">
			<input type="button" id="btnAttachments" class="button" value="Attachments">
		</div>
	</div>
</div>
<script type="text/javascript">
	initializeAll();
	setModuleId("GIUTS029");
	observeReloadForm("reloadForm",showGIUTS029);
	setDocumentTitle("Update/Add Policy Picture Attachment");
	hideToolbarButton("btnToolbarPrint");
	objGIUTS029 = JSON.parse('${jsonGIUTS029}');	
	var mediaTypes = objGIUTS029.allowedMediaTypes.split(",");
	objGIUTS029.allowedMediaTypes = mediaTypes;	
	
	$("txtPolLineCd").observe("keyup", function(){
		$("txtPolLineCd").value = $F("txtPolLineCd").toUpperCase();
	});

	$("txtPolSublineCd").observe("keyup", function(){
		$("txtPolSublineCd").value = $F("txtPolSublineCd").toUpperCase();
	});

	$("txtPolIssCd").observe("keyup", function(){
		$("txtPolIssCd").value = $F("txtPolIssCd").toUpperCase();
	});

	$("txtEndtIssCd").observe("keyup", function(){
		$("txtEndtIssCd").value = $F("txtEndtIssCd").toUpperCase();
	});

	$("txtPolIssueYy").observe("keyup", function(){
		if(isNaN($F("txtPolIssueYy"))){
			$("txtPolIssueYy").clear();
		}  
	});

	$("txtPolPolSeqNo").observe("keyup", function(){
		if(isNaN($F("txtPolPolSeqNo"))){
			$("txtPolPolSeqNo").clear();
		}
	});

	$("txtPolRenewNo").observe("keyup", function(){
		if(isNaN($F("txtPolRenewNo"))){
			$("txtPolRenewNo").clear();
		}
	});

	$("txtEndtYy").observe("keyup", function(){
		if(isNaN($F("txtEndtYy"))){
			$("txtEndtYy").clear();
		}
	});

	$("txtEndtSeqNo").observe("keyup", function(){
		if(isNaN($F("txtEndtSeqNo"))){
			$("txtEndtSeqNo").clear();
		}
	});
	
	
	
	
	
	$("txtPolLineCd").observe("change", function(){
		if($F("hidPolicyId") != ""){
			clearGIUTS029();
		}
	});

	$("txtPolSublineCd").observe("keyup", function(){
		if($F("hidPolicyId") != ""){
			clearGIUTS029();
		}
	});

	$("txtPolIssCd").observe("keyup", function(){
		if($F("hidPolicyId") != ""){
			clearGIUTS029();
		}
	});

	$("txtEndtIssCd").observe("keyup", function(){
		if($F("hidPolicyId") != ""){
			clearGIUTS029();
		}
	});

	$("txtPolIssueYy").observe("keyup", function(){
		if($F("hidPolicyId") != ""){
			clearGIUTS029();
		}  
	});

	$("txtPolPolSeqNo").observe("keyup", function(){
		if($F("hidPolicyId") != ""){
			clearGIUTS029();
		}
	});

	$("txtPolRenewNo").observe("keyup", function(){
		if($F("hidPolicyId") != ""){
			clearGIUTS029();
		}
	});

	$("txtEndtYy").observe("keyup", function(){
		if($F("hidPolicyId") != ""){
			clearGIUTS029();
		}
	});

	$("txtEndtSeqNo").observe("keyup", function(){
		if($F("hidPolicyId") != ""){
			clearGIUTS029();
		}
	});
	
	var itemTable = {
			url : contextPath + "/UpdateUtilitiesController?action=getGIUTS029Items&policyId=",
			options : {
				width : '900px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					objGIUTS029.selectedItemNo = tbgItems.geniisysRows[y].itemNo;
					enableButton("btnAttachments");
					tbgItems.keys.removeFocus(tbgItems.keys._nCurrentFocus, true);
					tbgItems.keys.releaseKeys();
				},
				onRemoveRowFocus : function(){
					disableButton("btnAttachments");
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
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
					id : "itemNo",
					title : "Item No.",
					width : '100px',
					type : 'number',
					align : 'right',
					titleAlign : 'right',
					filterOption : true,
					filterOptionType: 'integerNoNegative',
					renderer : function(value){
						return lpad(value.toString(), 9, "0");					
					}
				},
				{
					id : "itemTitle",
					title : "Item Title",
					width : '340px',
					filterOption : true,
					renderer : function(value){
						return unescapeHTML2(value);
					}
				},
				{
					id : 'itemDesc',
					title : 'Description 1',
					width : '210px',
					filterOption : true,
					renderer : function(value){
						return unescapeHTML2(value);
					}
				},
				{
					id : 'itemDesc2',
					title : 'Description 2',
					width : '210px',
					filterOption : true,						
					renderer : function(value){
						return unescapeHTML2(value);
					}
				}
			],
			rows : []
		};

		tbgItems = new MyTableGrid(itemTable);
		//tbgItems.pager = objItemArray;
		tbgItems.render("itemTable");

	function disableFields(){
		try {
			$("txtPolLineCd").readOnly = true;
			$("txtPolSublineCd").readOnly = true;
			$("txtPolIssCd").readOnly = true;
			$("txtPolIssueYy").readOnly = true;
			$("txtPolPolSeqNo").readOnly = true;
			$("txtPolRenewNo").readOnly = true;
			$("txtEndtIssCd").readOnly = true;
			$("txtEndtYy").readOnly = true;
			$("txtEndtSeqNo").readOnly = true;
			disableSearch("hrefPolicyNo");
		} catch(e){
			showErrorMessage("disableFields", e);
		}
	}

	function enableFields(){
		try {
			$("txtPolLineCd").readOnly = false;
			$("txtPolSublineCd").readOnly = false;
			$("txtPolIssCd").readOnly = false;
			$("txtPolIssueYy").readOnly = false;
			$("txtPolPolSeqNo").readOnly = false;
			$("txtPolRenewNo").readOnly = false;
			$("txtEndtIssCd").readOnly = false;
			$("txtEndtYy").readOnly = false;
			$("txtEndtSeqNo").readOnly = false;
			enableSearch("hrefPolicyNo");
		} catch(e){
			showErrorMessage("enableFields", e);
		}
	}
	
	function clearGIUTS029(){
		try {
			$("hidPolicyId").clear();
			$("txtPolLineCd").clear();
			$("txtPolSublineCd").clear();
			$("txtPolIssCd").clear();
			$("txtPolIssueYy").clear();
			$("txtPolPolSeqNo").clear();
			$("txtPolRenewNo").clear();
			$("txtEndtIssCd").clear();
			$("txtEndtYy").clear();
			$("txtEndtSeqNo").clear();
			$("txtAssdName").clear();
			disableButton("btnAttachments");
			disableToolbarButton("btnToolbarExecuteQuery");
			$("txtPolLineCd").focus();
		} catch(e){
			showErrorMessage("clearGIUTS029", e);
		}
	}

	function showGIUTS029AttachmentList(){
		/* try{
			overlayAttachedMedia = Overlay.show(contextPath+"/UpdateUtilitiesController", {
				urlContent: true,
				urlParameters: {action : "showGIUTS029ItemAttachments",
					    		policyId : $F("hidPolicyId"),
					    		lineCd: $F("txtPolLineCd"),
					    		itemNo : objGIUTS029.selectedItemNo,
								ajax : "1"},
			    title: "Attachments",
			    height: 380,
			    width: 650,
			    draggable: true
			});
		}catch(e){
			showErrorMessage("showGIUTS029AttachmentList", e);
		} */
		
		objPolicy.lineCd = $F("txtPolLineCd");
		objPolicy.policyNo = ($F("txtPolLineCd") + "-" + $F("txtPolSublineCd") + "-" + $F("txtPolIssCd") + "-" + $F("txtPolIssueYy") + "-" + $F("txtPolPolSeqNo") + "-" + $F("txtPolRenewNo")).replace(/\s+/g, '');
		getParNo2($F("hidPolicyId"));
		
		openAttachMediaOverlay2("policy", $F("hidPolicyId"), objGIUTS029.selectedItemNo); // SR-5931 JET FEB-20-2017
	}
	
	function getParNo2(policyId) {
		new Ajax.Request(contextPath + "/GIPIPARListController", {
			parameters: {
				action: "getParNo2",
				policyId: policyId
			},
			onComplete: function(response) {
				objPolicy.parNo = response.responseText;
			}
		});
	}
	
	function writeFilesToServer(){
		try{
/* 			new Ajax.Request(contextPath+"/GIPIQuotePicturesController", {
				method: "POST",
				parameters : {action : "writeFilesToServer",
							  files : prepareJsonAsParameter(objGIPIQuote.attachedMedia)},
				onComplete : function(response){
					if(checkErrorOnResponse(response)){
						objAttachedMedia = objGIPIQuote.attachedMedia;
						objAttachment = {};
						objAttachment.onAttach = function(files){
							setAttachRows = getAddedAndModifiedJSONObjects(files);
							delAttachRows = getDeletedJSONObjects(files);
							saveAttachments();
						};	 */						
						showGIUTS029AttachmentList();
/* 					}
				}
			}); */
		}catch(e){
			showErrorMessage("writeFilesToServer",e);
		}
	}
	
	function showGIUTS029PolicyLOV(){
		try {
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "showGIUTS029PolicyLOV",
					lineCd : $F("txtPolLineCd"),
					sublineCd : $F("txtPolSublineCd"),
					issCd : $F("txtPolIssCd"),
					issueYy : $F("txtPolIssueYy"),
					polSeqNo : $F("txtPolPolSeqNo"),
					renewNo : $F("txtPolRenewNo"),
					endtIssCd : $F("txtEndtIssCd"),
					endtYy : $F("txtEndtYy"),
					endtSeqNo : $F("txtEndtSeqNo"),
					page : 1
				},
				autoSelectOneRecord: true,
				title : "List of Policies",
				width : 700,
				height : 400,
				columnModel : [ {
					id : "policyNo",
					title : "Policy No. / Endt No.",
					width : '260px'
				}, {
					id : "assdName",
					title : "Assured Name",
					width : '425px'
				}],
				draggable : true,
				onSelect : function(row) {
					objGIUTS029.policyId = row.policyId;
					$("hidPolicyId").value = row.policyId;
					$("txtPolLineCd").value = row.lineCd;
					$("txtPolSublineCd").value = unescapeHTML2(row.sublineCd);
					$("txtPolIssCd").value = row.issCd;
					$("txtPolIssueYy").value = row.issueYy;
					$("txtPolPolSeqNo").value = row.polSeqNo;
					$("txtPolRenewNo").value = row.renewNo;
					$("txtEndtIssCd").value = row.endtIssCd;
					$("txtEndtYy").value = row.endtYy;
					$("txtEndtSeqNo").value = row.endtSeqNo;
					$("txtAssdName").value = unescapeHTML2(row.assdName);
					enableToolbarButton("btnToolbarExecuteQuery");
				}
			});
		} catch(e){
			showErrorMessage("showGIUTS029PolicyLOV", e);
		}
	}
	
	$("hrefPolicyNo").observe("click", function(){
		if($F("txtPolLineCd") == ""){
			showWaitingMessageBox("Please enter Line Code first.", "I", function(){
				$("txtPolLineCd").focus();
			});
		} else {
			showGIUTS029PolicyLOV();
		}
	});

	$("btnToolbarEnterQuery").observe("click", function(){
		if($F("hidPolicyId") != ""){
			tbgItems.url = contextPath + "/UpdateUtilitiesController?action=getGIUTS029Items&policyId=";
			tbgItems._refreshList();
		}
		clearGIUTS029();
		enableFields();
	});
	
	$("btnToolbarExecuteQuery").observe("click", function(){
		tbgItems.url = contextPath + "/UpdateUtilitiesController?action=getGIUTS029Items&policyId="+$F("hidPolicyId");
		tbgItems._refreshList();
		disableToolbarButton("btnToolbarExecuteQuery");
		disableFields();
	});
	
	$("btnToolbarExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main" , null);
	});

	$("btnAttachments").observe("click", function(){
		writeFilesToServer();
	});
	
	clearGIUTS029();
</script>