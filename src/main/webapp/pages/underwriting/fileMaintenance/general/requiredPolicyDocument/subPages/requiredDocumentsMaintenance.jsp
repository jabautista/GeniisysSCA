<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>	

<div id="requiredDocumentsMaintenanceSubSectionDiv" class= "subSectionDiv" changeTagAttr="true">
	<div id="requiredDocumentsMaintenanceTable" style="height: 245px;position:relative;left:5px;top:5px;border-bottom: 0px;" ></div>
	
	<table style="position:relative;left:215px;border-bottom: 0px;" >
		<tr>
			<td class="rightAligned"></td>
			<td class="leftAligned"><input type="checkbox" id="chkValidFlag" value="" tabindex="101" changeTagAttr="true"/>&nbsp;Valid</td>
		</tr>
		<tr>
			<input type="hidden" id="txtLineCode" value=""/>
			<input type="hidden" id="txtSublineCode" value=""/>
			<td class="rightAligned">Document Code</td>
			<td class="leftAligned"><input  type="text" id="txtDocumentCode" value="" style="width: 350px;" class="required upper" maxlength="3" tabindex="102" changeTagAttr="true"/></td>
		</tr>
		<tr>
			<td class="rightAligned">Document Name</td>
			<td class="leftAligned"><input type="text" id="txtDocumentName" value="" style="width: 350px;" class="required upper" maxlength="100" tabindex="103" changeTagAttr="true"/></td>
		</tr>
		<tr>
			<td class="rightAligned">Effectivity Date</td>
			<td class="leftAligned">
				<div id="txtEffectivityDateDiv" name="txtEffectivityDateDiv" style="float: left; width: 355px;" class="withIconDiv required">
					<input type="text" id="txtEffectivityDate" value="" style="width: 330px;" class="withIcon required" readonly="readonly" maxlength="10" tabindex="104" changeTagAttr="true"/>
					<img id="hrefEffectivityDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Effectivity Date" onClick="scwShow($('txtEffectivityDate'),this, null);" tabindex="105"/>
				</div>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Remarks</td>
			<td class="leftAligned">
				<div style="border: 1px solid gray; height: 20px; width: 356px;">
					<textarea id="txtRemarks" name="txtRemarks" style="width: 300px; border: none; height: 13px;" maxlength="4000" tabindex="106" changeTagAttr="true"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" tabindex="107"/>
				</div>
			</td>
			<!-- <td class="leftAligned"><input type="text" id="txtRemarks" value="" style="width: 350px;" maxlength="4000"/></td> -->
		</tr>
		<tr>
			<td class="rightAligned">User ID</td>
			<td class="leftAligned"><input type="text" id="txtUserId" value="" style="width: 100px;" maxlength="8" readonly="readonly"/>
			&nbsp;Last Update&nbsp;&nbsp;<input type="text" id="txtLastUpdate" value="" style="width: 159px;" maxlength="26" readonly="readonly"/></td>
		</tr>
		<!-- <tr>
			<td colspan="2">
				<div class="buttonsDiv">
					<input type="button" class="button" id="btnAddRequiredDoc" name="btnAddRequiredDoc" value="Add" envalue="Add" tabindex="108" />
					<input type="button" class="button" id="btnDeleteRequiredDoc" name="btnDeleteRequiredDoc" value="Delete" envalue="Delete" tabindex="109"/>
				</div>
			</td>
		</tr> -->
	</table>
	<div class="buttonsDiv">
		<input type="button" class="button" id="btnAddRequiredDoc" name="btnAddRequiredDoc" value="Add" envalue="Add" tabindex="108" />
		<input type="button" class="button" id="btnDeleteRequiredDoc" name="btnDeleteRequiredDoc" value="Delete" envalue="Delete" tabindex="109"/>
	</div>
	<div class="buttonsDiv" style="float:left; width: 98%;">
		<input type="button" class="button" id="btnCancelRequiredDoc" name="btnCancelRequiredDoc" value="Cancel" tabindex=110/>
		<input type="button" class="button" id="btnSaveRequiredDoc" name="btnSaveRequiredDoc" value="Save" tabindex=112/>
	</div>	
</div>


<script type="text/javascript">
	var selectedIndex = null;
	var withChanges = false;
	
	disableButton("btnDeleteRequiredDoc");
	
	try{
		
		var row = 0;
		var objRequiredPolicyDocumentMain = [];
		var objRequiredDoc = new Object();
		objRequiredDoc.objRequiredDocListing = [];
		objRequiredDoc.objRequiredDocMaintenance = objRequiredDoc.objRequiredDocListing.rows || [];
		
		var requiredDocMaintenanceTG = {
				url: contextPath+"/GIISRequiredDocController?action=getGiisRequiredDocList",
				id: 3,
			options: {
				width: '891px',
				height: '200px',
				masterDetail : true,  
				masterDetailRequireSaving: true, 
				checkChanges: function(){  
					return (changeTag == 1 ? true : false);
				},
				masterDetailValidation: function(){  
					return (changeTag == 1 ? true : false);
				},
				masterDetailNoFunc: function(){  
					return (changeTag == 1 ? true : false);
				},
				onCellFocus: function(element, value, x, y, id){
					var mtgId = requiredDocMaintenanceTableGrid._mtgId;					
					if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){						
						row = y;
						selectedIndex = row;
					    objGIISS035.objRequiredDocMaintain = requiredDocMaintenanceTableGrid.geniisysRows[y];
					    setRequiredDocForm(objGIISS035.objRequiredDocMaintain);
					}
				    requiredDocMaintenanceTableGrid.releaseKeys();
				},
				onRemoveRowFocus: function(){
					 sublineMaintenanceTableGrid.keys.releaseKeys();
					 selectedIndex = null;
					 setRequiredDocForm(null);
	            },
	            beforeSort: function(){
	            	if (changeTag == 1) {
						showMessageBox("Please save changes first.", "I");						
						return false;
					} else {
						return true;
					}
                },
                onSort: function(){
                	
                },
				prePager: function(){
					if (changeTag == 1) {
						showMessageBox("Please save changes first.", "I");						
						return false;
					} else {
						return true;
					}
				},
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onRefresh: function(){
						setRequiredDocForm(null);
					},
					onFilter: function(){

					}
				}
			},
			columnModel: [
				{   id: 'recordStatus',
				    title: '',
				    width: '0',
				    visible: false,
				    editor: 'checkbox' 			
				},
				{	id: 'divCtrId',
					width: '0',
					visible: false
				},
				{
					id: 'lineCd',
					width: '0',
					visible: false
				},
				{
					id: 'sublineCd',
					width: '0',
					visible: false
				},
				{
					id: 'validFlag',
					title: 'V',
					titleAlign: 'center',
				    width: '25px',
				    visible: true,
				    filterOption: true,
				    defaultValue: false,
					otherValue: false,
					//editable: true,
				    editor: new MyTableGrid.CellCheckbox({
				        getValueOf: function(value){
				        	if (value){
								return "Y";
			            	}else{
								return "N";	
			            	}
				        }
			    	})
				},
			    {   id: 'docCd',
				    title: 'Code',
				    titleAlign: 'center',
				    width: '35px',
				    visible: true,
				    filterOption: true,
				    sortable:true
				},
				{	id: 'docName',
					title: 'Document Name',
					titleAlign: 'center',
					width: '300px',
					visible: true,
					filterOption: true,
					sortable:true
				},
				{   id: 'effectivityDate',
				    title: 'Effectivity Date',
				    titleAlign: 'center',
				    align: 'center',
				    width: '100px',
				    visible: true,
				    filterOption: true,
				    sortable:true,
				    filterOptionType: 'formattedDate',
				    geniisysClass: 'date',
				    renderer : function(value){
						return dateFormat(value, 'mm-dd-yyyy');
					}
				},
				{	id: 'remarks',
					title: 'Remarks',
					titleAlign: 'center',
					width: '390px',
					filterOption: true
				},
				{	id: 'userId',
					visible: false,
					width: '0'
				},
				{	id: 'lastUpdate',				
					visible: false,
					width: '0',
					renderer : function(value){
							return dateFormat(value, 'mm-dd-yyyy hh:mm:ss TT');
					}
				}
				],
			rows: objRequiredDoc.objRequiredDocMaintenance
		};
		
		requiredDocMaintenanceTableGrid = new MyTableGrid(requiredDocMaintenanceTG);
		requiredDocMaintenanceTableGrid.pager = objRequiredDoc.objRequiredDocListing;
		requiredDocMaintenanceTableGrid.render('requiredDocumentsMaintenanceTable');
		requiredDocMaintenanceTableGrid.afterRender = function(){
			objRequiredPolicyDocumentMain = requiredDocMaintenanceTableGrid.geniisysRows;
			changeTag = 0;	
			setRequiredDocForm(null);
		};

	}catch (e) {
		 showErrorMessage("Required Policy Document Table Grid", e); 
	}
	
	//Kris 05.23.2013
	function getCurrentDocList(){
		
		var isExisting = false;
		if(objG035.currDocList == null || objG035.currDocList.length == 0){
			objG035.currDocList = [];
			getReqdDocList();
		} else {
			for(var z=0; z<objRequiredPolicyDocumentMain.length; z++){
				isExisting = false;
				for(var y=0; y<objG035.currDocList.length; y++){
					if(objG035.currDocList[y] == objRequiredPolicyDocumentMain[z].docCd){
						isExisting = true;						
						break;
					}					
				}
				if(!isExisting){
					objG035.currDocList.push(objRequiredPolicyDocumentMain[z].docCd);
				}
			}
		}
		//showMessageBox("currList: "+objG035.currDocList, "I");
	}
	
	function getReqdDocList(){
		try{
			new Ajax.Request(contextPath + "/GIISRequiredDocController", {
				method: "POST",
				parameters: {
					action 		: "getCurrenDocCdList",
					lineCd 		: objG035.lineCd,
					sublineCd 	: objG035.sublineCd
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response) {
					if (response.responseText != "" && response.responseText != "[]") {
						var tempArr = eval(response.responseText);
						for(var i=0; i<tempArr.length; i++){
							objG035.currDocList.push(tempArr[i]);
						}
					}
				}
			});		
		}catch(e){
			showErrorMessage("getReqdDocList", e);
		}
	}
	
	function checkIfDuplicateDocCd(){
		var isExisting = false;
		
		for(var x=0; x<objRequiredPolicyDocumentMain.length; x++){
			//isExisting = false;
			for(var y=0; y<objG035.currDocList.length; y++){
				if(objRequiredPolicyDocumentMain[x].docCd == objG035.currDocList[y] && objRequiredPolicyDocumentMain[x].docCd == $F("txtDocumentCode")){
					isExisting = true;			
					break;
				}
			}
			if(isExisting){
				showMessageBox("Document Code must be unique.", "I");					
			}
		}
		return isExisting;
	}
	
	function createRequiredDoc(obj){
		try {
			var requiredDoc = obj == null ? new Object() : obj;	
			requiredDoc.lineCd = "";
			if (objGIISS035.objLineMaintain.lineCd != null){
				requiredDoc.lineCd = objGIISS035.objLineMaintain.lineCd;
			}
			requiredDoc.sublineCd = "";
			if (typeof objGIISS035.objSublineMaintain && objGIISS035.objSublineMaintain != null
					&& typeof objGIISS035.objSublineMaintain.sublineCd != 'undefined' && objGIISS035.objSublineMaintain.sublineCd != null){
				requiredDoc.sublineCd = objGIISS035.objSublineMaintain.sublineCd;
			}
			requiredDoc.docCd 			= escapeHTML2($F("txtDocumentCode"));
			//requiredDoc.docName	 		= escapeHTML2(escapeHTML2($F("txtDocumentName"))); // Comment out by Joms Diago 05312013
			//requiredDoc.docName	 		= $F("txtDocumentName"); // Needed no escaping, no escaping, no escaping. :D // Comment out by Fons Ellarina 11.15.2013
			requiredDoc.docName	 		= escapeHTML2($F("txtDocumentName")); 
			requiredDoc.effectivityDate = dateFormat($F("txtEffectivityDate"), "mm-dd-yyyy");
			requiredDoc.remarks 		= escapeHTML2($F("txtRemarks")); 
			requiredDoc.validFlag 		= $("chkValidFlag").checked == true ? 'Y' : 'N';
			requiredDoc.userId 			= "${PARAMETERS['USER'].userId}";
			requiredDoc.lastUpdate 		= dateFormat(new Date(), "mm-dd-yyyy hh:mm:ss TT");
			
			return requiredDoc;
		} catch (e){
			showErrorMessage("createRequiredDoc", e);
		}			
	}
	
	function setRequiredDocForm(row){
		try {
			$("txtLineCode").value 			= row == null ? "" : unescapeHTML2(row.lineCd);
			$("txtSublineCode").value 		= row == null ? "" : unescapeHTML2(row.sublineCd);
			$("txtDocumentCode").value 		= row == null ? "" : unescapeHTML2(row.docCd);
			$("txtDocumentName").value 		= row == null ? "" : unescapeHTML2(row.docName);
			$("txtEffectivityDate").value 	= row == null ? "" : dateFormat(row.effectivityDate, "mm-dd-yyyy");
			$("txtRemarks").value 			= row == null ? "" : unescapeHTML2(row.remarks); 
			$("chkValidFlag").checked 		= row == null ? "" : row.validFlag == 'Y' ? true : false;
			$("txtUserId").value 			= row == null ? "" : row.userId;
			$("txtLastUpdate").value 		= row == null ? "" : dateFormat(row.lastUpdate, "mm-dd-yyyy hh:mm:ss TT");
			
			$("btnAddRequiredDoc").setAttribute("enValue", row == null ? "Add" : "Update");
			$("btnAddRequiredDoc").value = row == null ? "Add" : "Update";
			if ($F("btnAddRequiredDoc") == "Add"){
				$("txtDocumentCode").removeAttribute("readonly");
			} else {
				$("txtDocumentCode").setAttribute("readonly", "readonly");
				enableButton("btnDeleteRequiredDoc");
			}
		} catch (e){
			showErrorMessage("setRequiredDocForm", e);
		}
	}
	
	function addRequiredDoc(){
		try {
			if(validateRequiredDocForm()){
				var requiredDoc = createRequiredDoc();
				if($("btnAddRequiredDoc").getAttribute("enValue") == "Add"){			
					requiredDocMaintenanceTableGrid.addBottomRow(requiredDoc);			
				} else {
					requiredDocMaintenanceTableGrid.updateVisibleRowOnly(requiredDoc, selectedIndex);
				}
				setRequiredDocForm(null);
				withChanges = true;
				changeTag = 1;
			}						
		} catch (e){
			showErrorMessage("addRequiredDoc", e);
		}
		getCurrentDocList(); //kris
	}
	
	function deleteRequiredDoc(){
		if(selectedIndex != null) {
			requiredDocMaintenanceTableGrid.deleteRow(selectedIndex);
			setRequiredDocForm(null);
			withChanges = true;
			changeTag = 1;
		}
	}
	
	function saveRequiredDocForm(){
		try {
			if (withChanges){
				var setRows = getAddedAndModifiedJSONObjects(requiredDocMaintenanceTableGrid.geniisysRows);
				var delRows = requiredDocMaintenanceTableGrid.getDeletedRows();
				var params = new Object();
				params.setRows = setRows;
				params.delRows = delRows;
				
				new Ajax.Request(contextPath+"/GIISRequiredDocController", {
					method : "POST",
					parameters : {action : "saveGIISRequiredDoc",
								  parameters : JSON.stringify(params)
								  /* setRows : prepareJsonAsParameter(setRows),
								  delRows : prepareJsonAsParameter(delRows) */},
					onComplete : function (response){
						if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response, null)){
							if("SUCCESS" == response.responseText){
								showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
								requiredDocMaintenanceTableGrid.refresh();
								setRequiredDocForm(null);
								changeTag = 0;
							}
						}
					}
				});
			} else {
				showMessageBox("No changes to save.", imgMessage.INFO);
			}
		} catch (e){
			showErrorMessage("saveRequiredDocForm", e);
		}
	}
	
	function validateRequiredDocForm(){
		try {
			var result = true;
			var field = "";
			var fields = $w("txtDocumentCode txtDocumentName txtEffectivityDate");
			
			for(var i=0; i<fields.length; i++){
				if($F(fields[i]) == "") {
					result = false;
					field = fields[i];
					break;
				}
			}
				
			if(!result){
				showWaitingMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, function(){$(field).focus();});				
			} 
			return result;
		} catch (e){
			showErrorMessage("validateRequiredDocForm", e);
		}
	}
	
	observeReloadForm("reloadForm",showRequiredPolicyDocument);	
	$("btnAddRequiredDoc").observe("click", addRequiredDoc);
	$("btnDeleteRequiredDoc").observe("click", deleteRequiredDoc);
	$("btnSaveRequiredDoc").observe("click", saveRequiredDocForm);
	$("btnCancelRequiredDoc").observe("click", function (){
		clearObjectValues(objG035);
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main" , null);
	});
	$("editRemarks").observe("click", function(){
		//showOverlayEditor("txtRemarks", 4000);
		// kris 05.23.2013 : replaced showOverlay Editor with showEditor
		showEditor("txtRemarks", 4000, "false");
	});
	
	$("txtDocumentCode").observe("blur", function(){
		getCurrentDocList();
		if(checkIfDuplicateDocCd()){
			showMessageBox("Document Code must be unique.", "I");
			$("txtDocumentCode").value = "";
			$("txtDocumentCode").focus();
		}
	});
	
	observeBackSpaceOnDate("txtEffectivityDate");
	initPreTextOnFieldWithIcon("hrefEffectivityDate", "txtEffectivityDate");
</script>