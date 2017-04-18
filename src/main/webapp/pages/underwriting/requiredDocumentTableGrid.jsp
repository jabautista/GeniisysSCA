<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<!-- by agazarraga 5/11/2012. Tablegrid conversion  -->
<div id="reqDocsMainDiv" name="reqDocsMainDiv" style="margin-top: 1px; display: none;" >
	<form id="reqDocsForm" name="reqDocsForm">
		<jsp:include page="/pages/underwriting/subPages/parInformation.jsp"></jsp:include>
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="outerDiv">
				<label id="">Required Documents Information</label>
				<span class="refreshers" style="margin-top: 0;">
		 			<label id="gr1o" name="gro" style="margin-left: 5px;">Hide</label>
		 			<!-- <label id="refreshList" name="refreshList" style="margin-left: 5px;">Refresh List</label> -->
				</span>
			</div>
		</div>
		<div id="aDiv" name="aDiv">
			<jsp:include page="/pages/underwriting/subPages/requiredDocumentsListing.jsp"></jsp:include>
			<!-- <div id="buttonsDiv" align="center" style="padding-top: 565px;"> -->
			<div id="buttonsDiv" align="center" style="float: left; width: 100%; height: 10px">
				<div style="margin-bottom: 50px; margin-top: 10px;">
					<input type="button" id="btnCancel" name="btnCancel" class="button" value="Cancel" style="margin-top: 5px; width: 100px;"/>
					<input type="button" id="btnSave" name="btnSave" class="button" value="Save" style="margin-top: 5px; width: 100px;"/>
				</div>
			</div>
		</div>
		<div id="hiddenDetailsDiv" name="hiddenDetailsDiv">
			<input type="hidden" id="expiryDate" name="expiryDate" value='<fmt:formatDate value="${expiryDate}" pattern="MM-dd-yyyy" />'/>
		</div>
	</form>
</div>

<script type="text/javaScript">
enableMenu("post");
trimLabelTexts();
try{
	
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	setModuleId("GIPIS029");
	var objReqDocs = new Object();
	objReqDocs.objReqDocsTblGrid =JSON.parse('${jsonReqDocsTableGrid}'.replace(/\\/g, '\\\\')); 
	objReqDocs.reqDocs = objReqDocs.objReqDocsTblGrid.rows||[]; 
	var ReqDocsProto = new Object();
	var objGIPIReqDoc = [];
	var reqDocsTableModel={
			url :contextPath+"/GIPIWRequiredDocumentsController?action=showRequiredDocsPage&refresh=1&globalParId="+$F("globalParId"),
			options:{
				width: '644px',
				height: '250px',
				onCellFocus: function(element, value, x, y, id){
					 var objCurrReqDoc = objGIPIReqDoc[y];
					setReqDocForm(objCurrReqDoc);
					currentRowIndex = y;
					$("btnAddDocument").value = "Update";
					enableButton("btnDeleteDocument");
					tbgReqDocs.keys.removeFocus(tbgReqDocs.keys._nCurrentFocus, true);
					tbgReqDocs.keys.releaseKeys();
					$("searchDocName").hide();
				},
				onRemoveRowFocus: function(element, value, x, y, id){
					currentRowIndex = -1;
					setReqDocForm(null); 
					$("btnAddDocument").value = "Add";
					disableButton("btnDeleteDocument");
					$("searchDocName").show();
				},
				afterRender: function(){
					showRequiredDocsPage();
					$("searchDocName").show();
				},
				 onRefresh: function(){
					 setReqDocForm(null); 
						$("btnAddDocument").value = "Add";
						disableButton("btnDeleteDocument");
						$("searchDocName").show();
				}, 
				toolbar : {
					elements : [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onRefresh: function(){
						setReqDocForm(null); 
						$("btnAddDocument").value = "Add";
						disableButton("btnDeleteDocument");
						$("searchDocName").show();
					},
					onFilter: function(){
						setReqDocForm(null); 
						$("btnAddDocument").value = "Add";
						disableButton("btnDeleteDocument");
						$("searchDocName").show();
					}
				},
				onSort: function() {
					tbgReqDocs.keys.removeFocus();
					tbgReqDocs.releaseKeys();
					setReqDocForm(null);
					$("btnAddDocument").value = "Add";
					disableButton("btnDeleteDocument");
					$("searchDocName").show();
				},
				beforeSort: function(){
					if(changeTag == 1){
						showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
								function(){
									saveReqDocsPageChanges();
									$("searchDocName").show();
								}, function(){
									showRequiredDocsPage();
									$("searchDocName").show();
									changeTag = 0;
								}, "");
						return false;
					}else{
						return true;
					}
				},
				postPager: function () {
					tbgReqDocs.keys.removeFocus();
					tbgReqDocs.releaseKeys();
					setReqDocForm(null);
					$("btnAddDocument").value = "Add";
					disableButton("btnDeleteDocument");
					$("searchDocName").show();
				}
			},columnModel: [
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
								id: 'docName',
								title: 'Document Name',
								width: '300px',
								align: 'left',
								filterOption: true,
								sortable: true
							},
							{
								id: 'docSw',
								width: '0',
								visible: false
							},
							{
								id: 'dateSubmitted',
								title: 'Date Submitted',
								width: '300px',
								sortable: true,
								renderer: function (value){
									var dateTemp;
									if(value=="" || value==null){
										dateTemp = "";
									}else{
										dateTemp = dateFormat(value,"mm-dd-yyyy");
									}
									value = dateTemp;
									return value;
								}
							},
							{
							id: 'tbgDocSw',
							title: 'P',
							width: '30px',
							tooltip: 'P',
							align: 'center',
							titleAlign: 'center',
							editable: false,
							editor: 'checkbox',
							sortable:false
							}, 

							],
							rows: objReqDocs.reqDocs
	};
	tbgReqDocs = new MyTableGrid(reqDocsTableModel);
	tbgReqDocs.pager = objReqDocs.objReqDocsTblGrid;
	tbgReqDocs.render('docsDivTablegrid');
	tbgReqDocs.afterRender = function(){
		objGIPIReqDoc = tbgReqDocs.geniisysRows;
		//setReqDocForm(null); 
	};
	initializeChangeTagBehavior(saveReqDocsPageChanges);
	/* observeReloadForm("reloadForm", showRequiredDocsPage); */
}catch(e){
	showErrorMessage("Required Documents Submitted",e);
}
//initial func
function initializeReqDocFormAndObj(){
	objGIPIReqDoc = tbgReqDocs.geniisysRows;
	setReqDocForm(null); 
}
//populate func
function setReqDocForm(obj){
	try{
		
		//(JSON.stringify(obj));
		$("document").value     = (obj) == null ? "" : (nvl(obj.docName,""));
		$("dateSubmitted").value = (obj) == null ? "" : (nvl(((obj.dateSubmitted==null||obj.dateSubmitted=="")?"":dateFormat(obj.dateSubmitted,'mm-dd-yyyy')),""));
		$("remarks").value     = (obj) == null ? "" : changeSingleAndDoubleQuotes(nvl(obj.remarks,""));
		$("postSwitch").checked = (obj) == null ? "" : (nvl(obj.docSw,"") == 'Y' ? true : false);
		$("docCd").value     = (obj) == null ? "" : (nvl(obj.docCd,""));
		$("selectedDocCd").value     = (obj) == null ? "" : (nvl(obj.docCd,""));
	}catch(e){
		showErrorMessage("setReqDocForm",e);
	}
	
}
//get func
function getReqDocsFormToObj(){
	try{
		var dateTempStor;
		var obj = new Object();
		
		obj.docName = escapeHTML2($F("document"));
		obj.dateSubmitted = ($F("dateSubmitted")=="" || $F("dateSubmitted")==null)?"":dateFormat(escapeHTML2($F("dateSubmitted")),'mm-dd-yyyy');
		obj.remarks = escapeHTML2(changeSingleAndDoubleQuotes($F("remarks")));
		obj.docSw = $("postSwitch").checked?"Y":"N";
 		obj.tbgDocSw = $("postSwitch").checked?true:false;
		obj.docCd = escapeHTML2($F("docCd"));
		obj.lineCd = escapeHTML2($F("globalLineCd"));
		obj.parId = parseInt($F("globalParId"));
		obj.recordStatus = "" ;
		return obj;
	}catch(e){
		showErrorMessage("getReqDocsFormToObj", e);
	}
		
}
//add func
function addRD(){
	try{
		var newReqDoc = getReqDocsFormToObj();
		if($("btnAddDocument").value == "Update"){
			for(var i = 0; i<objGIPIReqDoc.length;i++){
				if(
				   (objGIPIReqDoc[i].docCd == $("selectedDocCd").value)&&
				   (objGIPIReqDoc[i].recordStatus != -1)){
					objGIPIReqDoc[i].newReqDoc;
					newReqDoc.recordStatus = 1;
					objGIPIReqDoc.splice(i,1,newReqDoc);
					tbgReqDocs.updateVisibleRowOnly(newReqDoc, tbgReqDocs.getCurrentPosition()[1]);
				}
			}
		}else{
			newReqDoc.recordStatus = 0;
			objGIPIReqDoc.push(newReqDoc);
			tbgReqDocs.addBottomRow(newReqDoc);
		}
		changeTag = 1;
		tbgReqDocs.keys.removeFocus();
		tbgReqDocs.releaseKeys();
		setReqDocForm(null);
		$("btnAddDocument").value = "Add";
		disableButton("btnDeleteDocument");
	}catch (e) {
		showErrorMessage("addRD",e);
	}
}
$("btnAddDocument").observe("click",function(){
	if(validateBeforeAdd()){
		addRD();
		$("searchDocName").show();
	}
});
		
		

//del func
function delRD(){
	try{
		var delObj =  getReqDocsFormToObj() ;
		for(var i = 0; i<objGIPIReqDoc.length;i++){
			if((objGIPIReqDoc[i].docCd == delObj.docCd)&&
			   (objGIPIReqDoc[i].recordStatus != -1)){
				delObj.recordStatus =-1;
				objGIPIReqDoc.splice(i,1,delObj);
				tbgReqDocs.deleteRow( tbgReqDocs.getCurrentPosition()[1]);
				changeTag = 1;
			}
		}
		tbgReqDocs.keys.removeFocus();
		tbgReqDocs.releaseKeys();
		setReqDocForm(null);
		$("btnAddDocument").value = "Add";
		disableButton("btnDeleteDocument");
		$("searchDocName").show();
	}catch(e){
		showErrorMessage("delRD",e);
	}
}

$("btnDeleteDocument").observe("click",delRD);

//save func
function saveReqDocsPageChanges(){
	try{
			objParam = new Object();
			objParam.setRD = getAddedAndModifiedJSONObjects(objGIPIReqDoc);
			objParam.delRD = getDeletedJSONObjects(objGIPIReqDoc);
			(JSON.stringify(objParam));
			new Ajax.Request(contextPath+"/GIPIWRequiredDocumentsController?action=saveReqDocsPageChanges",{
				method: "POST",
				parameters:{
				parameters: JSON.stringify(objParam)	
				},
				onCreate:function(){
					showNotice("Saving Required Documents. Please Wait...");	
				},
				onComplete: function(response) {
					hideNotice("");
					changeTag=0;
					if(response.responseText == "SUCCESS"){
						if(checkErrorOnResponse(response)){
							tbgReqDocs.refresh();
							showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
							lastAction();
							lastAction = "";
						}
						
					}
				}
			});
	}catch (e){
		showErrorMessage("saveReqDocsPageChanges", e);
	}
}
$("btnSave").observe("click", function(){
	if(changeTag == 0){
		showMessageBox(objCommonMessage.NO_CHANGES, "I");
	}else{
		saveReqDocsPageChanges();
	}
	
});
function validateBeforeAdd(){
	var result = true;
	if ($("document").value == "" || $("document").value == null){
		showMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR);
		result = false;
	} else {
		result = checkDateSubmitted();
	}
	return result;
}

function checkDateSubmitted(){
	var dateOk = true;
	var dateSubmitted = Date.parse($F("dateSubmitted"));
	var expiryDate = Date.parse($F("globalExpiryDate"));
	var currentDate = Date.parse($F("globalExpiryDate"));
	if (dateSubmitted != "") {
		if (dateSubmitted > expiryDate){
			$("dateSubmitted").value = dateFormat(dateSubmitted,"mm-dd-yyyy");
			showMessageBox("Date Submitted must not be greater than the Expiry Date.", imgMessage.ERROR);
			dateOk = false;
		}
	}
	return dateOk;
}
//search using LOV
$("searchDocName").observe("click", function(){
	var notIn = "";
	var withPrevious = false;
	try {
		objGIPIReqDoc.filter(function(obj){return obj.recordStatus != -1;}).each(function(row){
			if(withPrevious) notIn += ",";
			notIn += "'"+row.docCd+"'";
			withPrevious = true;
		});
		notIn = (notIn != "" ? "("+notIn+")" : "");
		showReqDocsLOV($F("globalLineCd"), $F("globalSublineCd"), notIn);
	} catch (e){
		showErrorMessage("searchDocName", e);
	}
			
}); 

//reload form
$("reloadForm").observe("click", function () {
	if(changeTag == 1){
		showConfirmBox3("CONFIRMATION", "Reloading form will disregard all changes. Proceed?", "Yes", "No", 
				function(){
					showRequiredDocsPage();
					changeTag = 0;
				},"");
	}else{
		showRequiredDocsPage();
	}
	
});


$("btnCancel").observe("click", function(){
	//checkChangeTagBeforeCancel();
	if(changeTag == 1){
		showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
				function(){
					saveReqDocsPageChanges();
					if ($F("globalLineCd") == "SU"){
						showBondBasicInfo();
					}else{	
						showBasicInfo();
					}
					changeTag = 0;
				}, function(){
					if ($F("globalLineCd") == "SU"){
						showBondBasicInfo();
					}else{	
						showBasicInfo();
					}
					changeTag = 0;
				}, "");
	}else{
		if ($F("globalLineCd") == "SU"){
			showBondBasicInfo();
		}else{	
			showBasicInfo();
		}
	}
	
});


function clearSelected(){
	$("selectedDocCd").value 			= "";
	$("selectedDocSw").value 			= "";
	$("selectedDateSubmitted").value 	= "";
	$("selectedDocName").value 			= "";
	$("selectedUserId").value 			= "";
	$("selectedLastUpdate").value 		= "";
	$("selectedRemarks").value 			= "";
}

function clearAddDocFields(){
	$("document").selectedIndex 		= 0; 
	$("docCd").value					= "";
	$("dateSubmitted").value 			= $("currentDate").value;
	$("user").value 					= $F("defaultUser");
	$("remarks").value 					= "";
	$("postSwitch").checked 			= false;
}
$("editRemarks").observe("click", function () {
	showEditor("remarks", 4000);
});

$("remarks").observe("keyup", function () {
	limitText(this, 4000);
});



function trimLabelTexts(){
	$$("label[name='docText']").each(function (label)	{
		if ((label.innerHTML).length > 40)	{
			label.update((label.innerHTML).truncate(40, "..."));
		}
	});
}
</script>