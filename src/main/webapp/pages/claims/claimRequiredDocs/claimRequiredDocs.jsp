<jsp:include page="/pages/claims/subPages/claimInformation.jsp"></jsp:include>
<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
	<div id="innerDiv" name="innerDiv">
		<label>Claim Required Documents</label>
		<span class="refreshers" style="margin-top: 0;">
			<label name="gro" style="margin-left: 5px;">Hide</label>
		</span>
	</div>
</div>

<div id="reqdDocsMainDiv" class="sectionDiv">
	<div id="reqdDocsTableGrid" style="width: 900px; padding: 10px; height: 330px;" >
	</div>
	
	<div style="margin-left: 10px; height: 60px; margin-top: 20px;" >
		<div  style=" width: 105px; margin-left: 400px;" class="withIconDiv" >
			<input style="width: 80px; border: none;" id="dateSubmittedApply" name="dateSubmittedApply" type="text" value="" class="withIcon" readonly="readonly" triggerChange="Y" removeStyle="true"/>
			<img id="hrefDateSubmittedApply" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('dateSubmittedApply'),this, null);" />
		</div>
		<div  style=" width: 105px; margin-left:0 px;" class="withIconDiv" >
			<input style="width: 80px; border: none;" id="dateCompletedApply" name="dateCompletedApply" type="text" value="" class="withIcon" readonly="readonly" triggerChange="Y" removeStyle="true"/>
			<img id="hrefDateCompletedApply" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('dateCompletedApply'),this, null);" />
		</div>
		<input type="button" id="btnApply"	name="btnApply" class="disabledButton"	value="Apply" />
	</div>
	<!-- <div class="buttonsDiv">
		<input type="button" id="btnAddDocument"	name="btnAddDocument" class="button"	value="Add Document"/>
	</div> -->
	
	<div id="docDetailsDiv" changeTagAttr="true">
		<table align="center">
			<tr>
				<td class="rightAligned" >Document Code</td> 
				<td class="leftAligned">
					<input type="text" id="clmDocCd" name="clmDocCd" value=""  readonly="readonly" style="width: 50px; text-align: right;">
				</td> 
				<td class="rightAligned" >Document Name</td> 
				<td class="leftAligned">
					<input type="text" id="clmDocDesc" name="clmDocDesc" value=""  readonly="readonly" style="width: 180px; text-align: left;">
				</td> 
			</tr>
			<tr>
				<td class="rightAligned">Date Submitted</td>
				<td class="leftAligned">
					<div style="float: left; width: 125px;" class="withIconDiv">
						<input style="width: 100px; border: none;" id="docSbmttdDt" name="docSbmttdDt" type="text" value="" class="withIcon" readonly="readonly" triggerChange="Y" removeStyle="true"/>
						<img id="hrefDocSubmit" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"  onClick="scwShow($('docSbmttdDt'),this, null);" />
					</div>
				</td>
				<td class="rightAligned">Date Completed</td>
				<td class="leftAligned">
					<div  style="float: left; width: 125px;" class="withIconDiv">
						<input style="width: 100px; border: none;" id="docCmpltdDt" name="docCmpltdDt" type="text" value="" class="withIcon" readonly="readonly" triggerChange="Y" removeStyle="true"/>
						<img id="hrefDocComplete" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('docCmpltdDt'),this, null);" />
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Received By</td>
				<td class="leftAligned">
					<div style="width: 123px; float: left;" class="withIconDiv">
						<input style="width: 97px; " id="rcvdBy" name="rcvdBy" type="text" value="" readOnly="readonly" class="withIcon" />
						<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="rcvdByOscm" name="rcvdByOscm" alt="Go" />
					</div>
				</td>
				<td class="rightAligned">Forwarded From</td>
				<td class="leftAligned">
					<div style="width: 55px; float: left;" class="withIconDiv">
						<input style="width: 30px;" id="frwdFr" name="frwdFr" type="text" value="" readOnly="readonly" class="withIcon" />
						<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="frwdFrOscm" name="frwdFrOscm" alt="Go" />
					</div>
					<input style="width: 120px; float: left;" type="text" id="frwdBy" name="frwdBy" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Remarks</td>
				<td class="leftAligned" colspan="3">
					<div style="float:left; width: 430px;" class="withIconDiv">
						<textarea class="withIcon" onKeyDown="limitText(this,4000);" onKeyUp="limitText(this,4000);" id="remarks" name="remarks" style="width: 400px;"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editTxtRemarks" class="hover"/>
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Last Update</td>
				<td class="leftAligned" >
					<input type="text" id="lastupdate" name="lastupdate" value="" style="width: 150px; float: left;" readonly="readonly">	
				</td>
				<td class="rightAligned">User Id</td>
				<td class="leftAligned" >
					<input type="text" id="userId" name="userId" value="" style="width: 118px; float: left;" readonly="readonly">	
				</td>
				
			</tr>
		</table>
		<div style="text-align:center; margin-top: 10px;">
			<input type="button" class="disabledButton" style="width: 100px; " id="btnUpdate" value="Update"/>
			<input type="button" class="disabledButton" style="width: 100px;" id="btnDeleteDocument" value="Delete"/>
		</div>
	</div>
	<div class="sectionDiv"  style="padding-top: 5px; padding-bottom:5px;  margin-bottom:30px;  margin-top:30px; border: none; " >
		<div style="text-align:center">
			<input type="button" class="button" id="btnSaveDocument" value="Save" style="width: 120px;"/>
			<input type="button" id="btnAddDocument"	name="btnAddDocument" class="button"	value="Add Document" style="width: 120px;"/>
			<input type="button" id="btnPrint"	name="btnPrint" class="button"	value="Print" style="width: 120px;"/>
		</div>
	</div>
</div>


<input type="hidden" id="callOut" name="callOut" value=""/>
<input type="hidden" id="claimSw" name="claimSw" value="${claimSw }"/>

<script>
	 /******NOTE: mtgId of tablegrid is '3'****** - irwin*/
	 // modified 12.10.2012 - irwin
	 
	changeTag = 0;
	var objExit = new Object();
	var systemDate = makeDate('${systemDate}');
	var objSelectedDoc = {};
	var tempDocSubDate = "";
	var tempDocComDate = "";
	var exitModule = null;
	
	function saveChanges(stayInPage){
		if(changeTag == 0	){
			 showMessageBox(objCommonMessage.NO_CHANGES,"I");
		 }else{
			
			var objParameters = new Object();
			objParameters.modifiedRows 	= getAddedAndModifiedJSONObjects(objClaimDocsArr);
			objParameters.deletedRows = getDeletedJSONObjects(objClaimDocsArr);
			objParameters.claimId = objCLMGlobal.claimId;
			objParameters.lineCd = objCLMGlobal.lineCd; 
			objParameters.sublineCd = objCLMGlobal.sublineCd;
			objParameters.issCd = objCLMGlobal.issCd;
			var strParameters = JSON.stringify(objParameters);
			
			new Ajax.Request(contextPath+"/GICLReqdDocsController",{
				method: "POST",
				evalScripts: true,
				asynchronous: false,
				parameters:{
					action: "saveClaimDocs", 	
					strParameters: strParameters,
					mode: "update"
				},onCreate: function(){
					showNotice("Saving, please wait...");
				},
				onComplete: function (response) {	
					hideNotice();
					if (!checkErrorOnResponse(response)) {
						showMessageBox(response.responseText, imgMessage.ERROR);
					}else{
						changeTagFunc = "";
						showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){ //changed by shan 04.11.2014; showClaimRequiredDocs); //change by steven 11/13/2012 from: "response.responseText"  to: objCommonMessage.SUCCESS
							changeTag = 0;
							exitModule = stayInPage || logOutOngoing == "Y"? showClaimRequiredDocs : lastAction;
							exitModule();
							exitModule = "";
						});
					}
				}
			}); 
		 }
	}
	
	$("btnSaveDocument").observe("click",function(){
		 saveChanges(true);
	});
	
	try{
		var selectedIndex = null;
		var objDocs = JSON.parse('${docsTableGrid}'.replace(/\\/g, "\\\\"));
		var objClaimDocsArr = objDocs.rows;
		var objLovs =JSON.parse('${objLovs}');
		var dateToday = systemDate;
		
		function createFWDLov(obj){
			var fwdList = new Array();
			for ( var i = 0; i < obj.length; i++) {
				var fwd = new Object();
				fwd.frwdFr = obj[i].issCd;
				fwd.frwdBy = obj[i].issName;
				fwdList.push(fwd);
			}
			return fwdList;
		}
		
		function prepareLOVForTableGrid2(lovObj, lovObjValue, lovObjText){
			var listing = new Array();
			listing.push({"value" : "" , "text" : ""});
			
			var listObject1 = new Object(); 
			listObject1.value = "";
			listObject1.text = "";
			
			for (var i = 0; i < lovObj.length; i++){
				var listObject = new Object(); 
				var tempObj = lovObj[i];
				listObject.value = tempObj[lovObjValue];
				listObject.text = tempObj[lovObjText];
				listing.push(listObject);
			}
			
			return listing;
		}
		
		var objOrigIss = objLovs.allIssSource;
		var objUsersList = prepareLOVForTableGrid2(objLovs.allUsers, "userId", "userId");
		var objIssSource = prepareLOVForTableGrid2(createFWDLov(objLovs.allIssSource), "frwdFr", "frwdFr");
		var docsTable = {
			url: contextPath+ "/GICLReqdDocsController?action=getDocumentTableGridListing&refresh=1&claimId="+ objCLMGlobal.claimId,
			id: 3,
			options: {
				title: '',
				querySort: false,
				hideColumnChildTitle: true,
				prePager: function(){
					if(changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
						return false;
					} else {
						populateDocumentFields(null);
						return true;
					}
				},beforeSort: function(){
					if(changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
						return false;
					} else {
						populateDocumentFields(null);
						return true;
					}
				},
		      	onCellFocus: function(element, value, x, y, id){
					var mtgId = reqdDocsTableGrid._mtgId;
					selectedIndex = -1;
					if(y != undefined){ // temp solution to null
						if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
							selectedIndex = y;
						}
					}
					if(id != "subDateCbox" && id != "comDateCbox"){
						removeDateCBoxes();
					}
					objSelectedDoc = reqdDocsTableGrid.geniisysRows[y];
					populateDocumentFields(objSelectedDoc);
					//reqdDocsTableGrid.releaseKeys();
					observeChangeTagInTableGrid(reqdDocsTableGrid);
					reqdDocsTableGrid.releaseKeys(); //added by steven 2.6.2013
				},onCellBlur: function(element, value, x, y, id){
					//reqdDocsTableGrid.releaseKeys();
					observeChangeTagInTableGrid(reqdDocsTableGrid);
				},onRemoveRowFocus : function(){
					objSelectedDoc = null;
					populateDocumentFields(null);
					reqdDocsTableGrid.releaseKeys();
			  	},
				checkChanges: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailRequireSaving: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailValidation: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetail: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailSaveFunc: function() {
					return (changeTag == 1 ? true : false);
				},
				masterDetailNoFunc: function(){
					return (changeTag == 1 ? true : false);
				},
		      	toolbar:{
			 		elements: [/* MyTableGrid.SAVE_BTN,MyTableGrid.DEL_BTN,  */MyTableGrid.REFRESH_BTN],
			 		/*onDelete: function(){
			 			return true;
			 		},onSave : function(){
						
					} */
			 		onRefresh: function(){ //added by steven 2.6.2013
			 			objSelectedDoc = null;
						populateDocumentFields(null);
						reqdDocsTableGrid.releaseKeys();
						$("mtgLoader3").hide();
			 		}
		  		}
			},
			columnModel: [
				{
					id: 'recordStatus', 		
				    title: '&#160;D',
				    altTitle: 'Delete?',
				    width: 23,
				    sortable: false,
				    editable: true, 
				    visible: false,
				    editor: 'checkbox',
				    align : 'center',
				    hideSelectAllBox: true	
				},{
					id: 'divCtrId',
					width: '0',
					visible: false
				},
				{
					id: 'clmDocCd clmDocDesc',
					title: 'Claim Documents',
					titleAlign : 'center',
					//sortable : false,
					width: 300,
					align : 'center',
					children: [
						{
							id : 'clmDocCd',
			                width : 50,
			                editable: false,
			                type: "number"
			                //sortable: false		
						},{
							id : 'clmDocDesc',
			                width : 310,
			                editable: false,
			                sortable: false		
						}          
					]
				},
				{
					id: 'subDateCbox', 		
				    title: '',
				    altTitle: 'Select?',
				    width: 23,
				    visible: false,
				    editable: true,
				    sortable:false,
				    editor: 'checkbox',
				    align : 'center',
				    hideSelectAllBox: true		
				}, 
				{
					title: 'Date Submitted',
					id: 'docSbmttdDt',
					titleAlign : 'center',
					width : 105,
					align : 'center',
	                editable: false,
	                //sortable: false
				},{
					id: 'comDateCbox', 		// 'id' should be 'recordStatus' to disregard the some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
				    title: '',
				    altTitle: 'Select?',
				    width: 23,
				    visible: false,
				    editable: true,
				    sortable:false,
				    editor: 'checkbox',
				    align : 'center',
				    hideSelectAllBox: true		
				},{
					title: 'Date Completed',
					id: 'docCmpltdDt',
					titleAlign : 'center',
					width : 105,
					align : 'center',
	                editable: false,
	                //sortable: false
				},
				{
					title: 'Received By',
					id: 'rcvdBy',
					titleAlign : 'center',
					width : 100,
					align : 'center'
				},{
					id : 'frwdFr',
					title: 'Forwarded From',
					width: 100,
					visible: true,
					maxlength: 10
				},{
					id : 'frwdBy',
	                width :90,
	                editable: false,
	                sortable: false		
				}, 
				{	id: 'remarks',
					titleAlign: 'center',
					width: '150px',
					title: 'Remarks',
					align: 'center',
					visible: true,
					filterOption: true
				},
				{	id: 'lastupdate',
					titleAlign: 'center',
					width: '150px',
					title: 'Last Update',
					align: 'center',
					visible: true
				},
				{	id: 'userId',
					titleAlign: 'center',
					width: '75px',
					title: 'User',
					align: 'center',
					visible: true
				}
			],
			rows: objDocs.rows
		};
		reqdDocsTableGrid = new MyTableGrid(docsTable);
		reqdDocsTableGrid.pager = objDocs;
		reqdDocsTableGrid.render('reqdDocsTableGrid');
		reqdDocsTableGrid.afterRender = function(){
			var mtgId = reqdDocsTableGrid._mtgId;
			var frwdIndex = 	reqdDocsTableGrid.getColumnIndex("frwdFr");
			
			for ( var i = 0; i < reqdDocsTableGrid.rows.length; i++) {
				var subDate = reqdDocsTableGrid.getValueAt(reqdDocsTableGrid.getColumnIndex('docSbmttdDt'), i);
				var comDate = reqdDocsTableGrid.getValueAt(reqdDocsTableGrid.getColumnIndex('docCmpltdDt'), i);
				 if(subDate == null && comDate == null){
					 if($('mtgInput'+mtgId+'_'+frwdIndex+','+i) != null){
						 $('mtgInput'+mtgId+'_'+frwdIndex+','+i).disable(); 
					 }
				} 
			}
		}; 
	}catch(e){
		showErrorMessage("claim docs listing", e);
	}	
	
	
	function showDateCBoxes(){
		$('mtgHC'+reqdDocsTableGrid._mtgId+'_4').style.removeProperty("display");
		$('mtgHC'+reqdDocsTableGrid._mtgId+'_6').style.removeProperty("display");
		var mtgId = reqdDocsTableGrid._mtgId;
		var subIndex = 	reqdDocsTableGrid.getColumnIndex("subDateCbox");
		var comIndex = reqdDocsTableGrid.getColumnIndex("comDateCbox");
		for ( var i = 0; i < reqdDocsTableGrid.rows.length; i++) {
			$('mtgC'+mtgId+'_'+subIndex+','+i).style.removeProperty("display");
			$('mtgC'+mtgId+'_'+comIndex+','+i).style.removeProperty("display");
			$('mtgC'+mtgId+'_'+comIndex+','+i).editable = false;
			if(reqdDocsTableGrid.getValueAt(reqdDocsTableGrid.getColumnIndex('docSbmttdDt'), i) == null){
				//reqdDocsTableGrid.setValueAt(true,reqdDocsTableGrid.getColumnIndex('subDateCbox'),i, true);
				$('mtgInput'+mtgId+'_'+subIndex+','+i).checked = true;
			}
			if(reqdDocsTableGrid.getValueAt(reqdDocsTableGrid.getColumnIndex('docCmpltdDt'), i) == null){
				//reqdDocsTableGrid.setValueAt(true,reqdDocsTableGrid.getColumnIndex('comDateCbox'),i, true);
				$('mtgInput'+mtgId+'_'+comIndex+','+i).checked = true;
			} 
		}
		
		enableButton("btnApply");
		/* for ( var i = 0; i <docsListTableGrid.rows.length; i++) {
			docsListTableGrid.setValueAt(true,docsListTableGrid.getColumnIndex('recordStatus'),i, true);
			$("mtgIC"+docsListTableGrid._mtgId+"_"+docsListTableGrid.getColumnIndex('recordStatus')+","+i).removeClassName('modifiedCell');
		}  */
	} 
	
	function removeDateCBoxes(){
		$('mtgHC'+reqdDocsTableGrid._mtgId+'_4').setStyle("display: none;");
		$('mtgHC'+reqdDocsTableGrid._mtgId+'_6').setStyle("display: none;");
		var mtgId = reqdDocsTableGrid._mtgId;
		var subIndex = 	reqdDocsTableGrid.getColumnIndex("subDateCbox");
		var comIndex = reqdDocsTableGrid.getColumnIndex("comDateCbox");
		for ( var i = 0; i < reqdDocsTableGrid.rows.length; i++) {
			$('mtgC'+mtgId+'_'+subIndex+','+i).setStyle("display: none;");
			$('mtgC'+mtgId+'_'+comIndex+','+i).setStyle("display: none;");
			
			/* reqdDocsTableGrid.setValueAt(false,reqdDocsTableGrid.getColumnIndex('subDateCbox'),i, true);
			reqdDocsTableGrid.setValueAt(false,reqdDocsTableGrid.getColumnIndex('comDateCbox'),i, true); */
			$('mtgInput'+mtgId+'_'+comIndex+','+i).checked = false;
			$('mtgInput'+mtgId+'_'+subIndex+','+i).checked = false;
		}
		$("dateSubmittedApply").value = '';
		$("dateCompletedApply").value = '';
		disableButton("btnApply");
	}
	
	$("btnApply").observe("click", function(){
		try{
			var dateSub = $F("dateSubmittedApply");
			var dateCom = $F("dateCompletedApply");
			
			
			if((dateSub == "" ? true :  checkDate3(dateSub,"dateSubmittedApply"))){
				dateSub = makeDate(dateSub);
				for ( var i = 0; i < reqdDocsTableGrid.rows.length; i++) {
					if($("mtgInput"+reqdDocsTableGrid._mtgId+"_4,"+i).checked){
						var rowComDate = reqdDocsTableGrid.getValueAt(reqdDocsTableGrid.getColumnIndex('docCmpltdDt'), i) == null ? "" : makeDate(reqdDocsTableGrid.getValueAt(reqdDocsTableGrid.getColumnIndex('docCmpltdDt'), i));
						if(validateSubDate(dateSub,dateCom, rowComDate)){
							if(dateSub != ""){
								var docCd = reqdDocsTableGrid.getValueAt(reqdDocsTableGrid.getColumnIndex('clmDocCd'), i);
								for ( var x = 0; x < objClaimDocsArr.length; x++) {
									var doc = objClaimDocsArr[x];
									if(docCd == doc.clmDocCd){
										doc.userId = userId;
										doc.recordStatus = "1";
										doc.docSbmttdDt = $F("dateSubmittedApply");
										doc.clmDocDesc = escapeHTML2(reqdDocsTableGrid.getValueAt(reqdDocsTableGrid.getColumnIndex('clmDocDesc'), i)); // added by: Nica 05.02.2013
										changeTag = 1;
										addModifiedClaimDoc(doc);
										reqdDocsTableGrid.updateVisibleRowOnly(doc, i);
									} 
								}
							}
						}else return false;
					}
				}
			}
			
			if(dateCom == "" ?true :  checkDate3(dateCom,"dateCompletedApply")){
				dateCom = makeDate(dateCom);
				
				for ( var i = 0; i < reqdDocsTableGrid.rows.length; i++) {
					
					if($("mtgInput"+reqdDocsTableGrid._mtgId+"_6,"+i).checked){
						var rowSubDate = reqdDocsTableGrid.getValueAt(reqdDocsTableGrid.getColumnIndex('docSbmttdDt'), i) == null ? "" : makeDate(reqdDocsTableGrid.getValueAt(reqdDocsTableGrid.getColumnIndex('docSbmttdDt'), i));
						
						if(validateComDate(dateCom, dateSub,rowSubDate)){
							if(dateCom != ""){
								var docCd = reqdDocsTableGrid.getValueAt(reqdDocsTableGrid.getColumnIndex('clmDocCd'), i);
								for ( var x = 0; x < objClaimDocsArr.length; x++) {
									var doc = objClaimDocsArr[x];
									if(docCd == doc.clmDocCd){
										doc.userId = userId;
										doc.recordStatus = "1";
										doc.docCmpltdDt = $F("dateCompletedApply");
										doc.clmDocDesc = escapeHTML2(reqdDocsTableGrid.getValueAt(reqdDocsTableGrid.getColumnIndex('clmDocDesc'), i)); // added by: Nica 05.02.2013
										changeTag = 1;
										addModifiedClaimDoc(doc);
										reqdDocsTableGrid.updateVisibleRowOnly(doc, i);
									} 
								}
							}
						}else return false;
					}
				}
			} 
			removeDateCBoxes();
			populateDocumentFields(null);
		}catch(e){
			showErrorMessage("apply",e);
		}
	});
	
	$("btnPrint").observe("click", function(){
		showConfirmBox4("Print Report", "What kind of report do you want to print?", "Claim Acknowledgement", "Call-out Letter", "Cancel", 
			function(){
				$("callOut").value = 'N';
				prePrint();
		}, function(){
			$("callOut").value = 'Y';
			prePrint();
		}, "") ;
	});
	
	function prePrint(){
	    try {
	    	var title = ($F("callOut") == "Y"? "Print Call-out Letter" : "Print Claim Acknowledgement");
			overlayPrinter = Overlay.show(contextPath
					+ "/PrintDocumentsController", {
				urlContent : true,
				urlParameters : {
					action : "prePrint",
					ajax : "1",
					callOut : $F("callOut"),
					assuredName : unescapeHTML2(objCLMGlobal.assuredName),
					title: title
					},
				title : title,
				 height: 470,
				 width: 505,
				draggable : true
			});
		} catch (e) {
			showErrorMessage("overlay error: ", e);
		}
	}
	
	function validateSubDate(appSubDate, appComDate, rowComDate){
		try{
			var bool = true;
			if(/* appSubDate > dateToday  */compareDatesIgnoreTime(appSubDate, dateToday) == -1){
				bool =  false;
				showMessageBox("Date of document submission that is to be applied can not be later than the current date.", imgMessage.INFO);
				return false;
	        }else if(appSubDate < makeDate(objCLMGlobal.strClaimFileDate)){
	        	bool = false;
	        	showMessageBox("This claim was filed on: "+objCLMGlobal.strClaimFileDate+"; the date of document submission can not be earlier than this.", imgMessage.INFO);
	        	return false;
	        }else if(appComDate != ""){ 
	        	if(appSubDate > appComDate){
	        		showMessageBox("The date submitted that is to be applied should not be greater than the date completed that is to be applied.", imgMessage.INFO);
	        		bool = false;
	        		return false;
	        	}
	        }
			
			if(rowComDate!= ""){
	        	//appComDate != null && appSubDate != rowComDate && appSubDate > rowComDate
	        	if(appSubDate > rowComDate){
	        		showMessageBox("Date of document submitted that should be apply should not be greater than the existing date completed.", imgMessage.INFO);
	        		bool =  false;
	        		return false;
	        	}
	        }
			
			return bool;
		}catch(e){
			showErrorMessage("validateSubDate",e);
		}
	}
	
	function validateComDate(appComDate, appSubDate, rowSubDate){
		try{
			var bool = true;
			if(appComDate > dateToday){
				showMessageBox("Date of document completion that is to be applied can not be later than the current date.", imgMessage.INFO);
				bool = false;
	         }else if(appComDate < makeDate(objCLMGlobal.strClaimFileDate)){
	         	showMessageBox("This claim was filed on: "+objCLMGlobal.strClaimFileDate+"; the date of document completion can not be earlier than this.", imgMessage.INFO);
	         	bool = false;
	        }else if(appSubDate != ""){
	        	if(appComDate < appSubDate){
	        		showMessageBox("The date submitted that is to be applied should not be greater than the date completed that is to be applied.", imgMessage.INFO);
	        		bool = false;
	        	}
	        	
	        }
			if(rowSubDate != ""){
	        	if(appComDate < rowSubDate){
	        		showMessageBox("Date of document completed that should be apply should not be less than the existing date submitted.", imgMessage.INFO);
	        		bool = false;
	        	}
	        	
	        }
			return bool;
		}catch(e){
			showErrorMessage("validateComDate",e);
		}
	}
	
	$("dateSubmittedApply").observe("focus",showDateCBoxes);
	$("dateCompletedApply").observe("focus", showDateCBoxes);
	
	function getClmDocsList(){
		try{
			reqdDocsTableGrid.releaseKeys();
			var notIn = createCompletedNotInParam(reqdDocsTableGrid, "clmDocCd");
		
		    var contentHTML = '<div id="modal_content_docsList1"></div>';
		    
		    winWorkflow = Overlay.show(contentHTML, {
				id: 'modal_dialog_docsList1',
				title: "Claim Document",
				width: 600,
				height: 500,
				draggable: true
				//closable: true
			});
		     new Ajax.Updater("modal_content_docsList1", contextPath+"/GICLReqdDocsController?action=getDocsList&notIn="+notIn+"&lineCd="+objCLMGlobal.lineCd
					+"&sublineCd="+objCLMGlobal.sublineCd+"&claimId="+ objCLMGlobal.claimId, {
				evalScripts: true,
				asynchronous: false,
				onComplete: function (response) {			
					if (!checkErrorOnResponse(response)) {
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			}); 
		}catch(e){
			showErrorMessage("getClmDocsList",e);
		}	
	}
	
	$("btnAddDocument").observe("click", function(){
		if(changeTag == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		}else{
			getClmDocsList();
		}
		
	});
	
	function populateDocumentFields(obj){
		try{
			$("clmDocCd").value = obj == null ? "" : obj.clmDocCd;
			$("clmDocDesc").value = obj == null ? "" : unescapeHTML2(obj.clmDocDesc);
			$("docSbmttdDt").value = obj == null ? "" : obj.docSbmttdDt;
			$("docCmpltdDt").value = obj == null ? "" : obj.docCmpltdDt;
			$("rcvdBy").value = obj == null ? "" : obj.rcvdBy;
			$("frwdFr").value = obj == null ? "" : obj.frwdFr;
			$("frwdBy").value = obj == null ? "" : unescapeHTML2(obj.frwdBy);
			$("remarks").value = obj == null ? "" : unescapeHTML2(obj.remarks);
			$("lastupdate").value = obj == null ? "" : obj.lastupdate;
			$("userId").value = obj == null ? "" : unescapeHTML2(obj.userId);
			
			obj == null ? disableButton("btnUpdate") : enableButton("btnUpdate");
			obj == null ? disableButton("btnDeleteDocument") : enableButton("btnDeleteDocument");
			
			if(obj != null){
				if(obj.docSbmttdDt == null || obj.docCmpltdDt == null){
					disableSearch("frwdFrOscm");
				}else{
					enableSearch("frwdFrOscm");
				}
				enableDate("hrefDocComplete");
				enableDate("hrefDocSubmit");
				enableSearch("rcvdByOscm");
				enableInputField("remarks");
			}else{
				disableDate("hrefDocComplete");
				disableDate("hrefDocSubmit");
				disableSearch("rcvdByOscm");
				disableSearch("frwdFrOscm");
				disableInputField("remarks");
			}
		}catch(e){
			showErrorMessage("populateDocumentFields");
		}
	}
	
	function showReceivedByLOV(){
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getGiisUserAllListTGLov", 
							page : 1},
			title: "",
			width: 375,
			height: 386,
			columnModel : [	{	id : "userId",
								title: "User ID",
								width: '90px'
							},
							{	id : "username",
								title: "User Name",
								width: '265px'
							}
						],
			draggable: true,
			onSelect: function(row){
				$("rcvdBy").value = unescapeHTML2(row.userId);
			},
	  		onCancel: function(){
	  			
	  		}
		  });
	}
	
	function showForwardFromLOV(){
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getAllIssSourceTG", 
							page : 1},
			title: "",
			width: 375,
			height: 386,
			columnModel : [	{	id : "issCd",
								title: "Issue Code",
								width: '90px'
							},{	id : "issName",
								title: "Issue Name",
								width: '265px'
							}
						],
			draggable: true,
			onSelect: function(row){
				$("frwdFr").value = unescapeHTML2(row.issCd);
	  			$("frwdBy").value = unescapeHTML2(row.issName);
			},
	  		onCancel: function(){
	  			
	  		}
		  });
	}
	
	function disableFrwd(subValue, comValue){
		if(nvl(subValue,"") == "" || nvl(comValue,"") == ""){
			disableSearch("frwdFrOscm");
		}else{
			enableSearch("frwdFrOscm");
		}
	}	
	
	function addModifiedClaimDoc(editedObj){
		try{
			for ( var i = 0; i < objClaimDocsArr.length; i++) {
				var doc = objClaimDocsArr[i];
				if(editedObj.clmDocCd == doc.clmDocCd){
					if(doc.recordStatus == "0" && editedObj.recordStatus == "-1"){ // removed if just added
						objClaimDocsArr.splice(i,1);
					}else{// if modified
						objClaimDocsArr.splice(i,1,editedObj);
					}
					
				}
			}
			
		}catch(e){
			showErrorMessage("addModifiedClaimDoc",e);
		}
	}
	
	$("editTxtRemarks").observe("click", function(){
		showEditor("remarks",4000,'false'); //added by steven 04.06.2013; 'false'
	});
	
	$("btnDeleteDocument").observe("click" , function (){
		/*  var selectedRows = reqdDocsTableGrid._getSelectedRowsIdx();
		 if(nvl(selectedRows , "") == "" ){
			 showMessageBox("No record selected.", "I");
		 }else{
			 changeTag = 1;
			 reqdDocsTableGrid.deleteRows();
		 } */
		 var obj = {};
			obj.clmDocCd = $F("clmDocCd");
			obj.recordStatus = "-1";
			changeTagFunc = saveChanges;
			addModifiedClaimDoc(obj);
			reqdDocsTableGrid.deleteVisibleRowOnly(selectedIndex);
			populateDocumentFields(null);
			changeTag = 1;
	 });
	
	function createDocObj(){
		try{
			var obj = {};
			obj.clmDocCd = $F("clmDocCd");
			obj.clmDocDesc = $F("clmDocDesc");
			obj.docSbmttdDt = $F("docSbmttdDt");
			obj.docCmpltdDt = $F("docCmpltdDt");
			obj.rcvdBy = $F("rcvdBy");
			obj.frwdFr = $F("frwdFr");
			obj.frwdBy = $F("frwdBy");
			obj.remarks = $F("remarks");
			obj.lastupdate = $F("lastupdate");
			obj.userId = $F("userId");
			return obj;
		}catch(e){
			showErrorMessage("createDocObj");
		}
	}
	
	$("btnUpdate").observe("click",function(){
		var obj = createDocObj();
		obj.recordStatus = "1";
		changeTag = 1;
		changeTagFunc = saveChanges; // shan 04.11.2014
		addModifiedClaimDoc(obj);
		reqdDocsTableGrid.updateVisibleRowOnly(obj, selectedIndex);
		populateDocumentFields(null);
	});
	
	deleteOnBackSpace("frwdFr","frwdBy","frwdFrOscm");
	
	deleteOnBackSpace("docSbmttdDt","","hrefDocSubmit",function(){
		$("frwdFr").value = "";
		$("frwdBy").value = "";
		disableSearch("frwdFrOscm");
	});
	deleteOnBackSpace("docCmpltdDt","","hrefDocComplete",function(){
		$("frwdFr").value = "";
		$("frwdBy").value = "";
		disableSearch("frwdFrOscm");
	});
	
	deleteOnBackSpace("rcvdBy","","rcvdByOscm");
	$("rcvdByOscm").observe("click", showReceivedByLOV);
	
	$("frwdFrOscm").observe("click", showForwardFromLOV);
	
	$("docSbmttdDt").observe("focus", function(){
		tempDocSubDate = this.value;
	});
	$("docSbmttdDt").observe("change", function(){
		if(this.value != ''){
			var iDate;
			 if (checkDate2(this.value)) {
				 iDate = makeDate(this.value);
                if(iDate > dateToday){
                	this.value = tempDocSubDate;
					showMessageBox("Date of document submission can not be later than the current date.", imgMessage.INFO);
					return false;
                }else if(iDate < makeDate(objCLMGlobal.strClaimFileDate)){
                	this.value = tempDocSubDate;
                	showMessageBox("This claim was filed on: "+objCLMGlobal.strClaimFileDate+"; the date of document submission can not be earlier than this.", imgMessage.INFO);
					return false;
                }else{
					var dateCompleted = $F("docCmpltdDt");
					if(dateCompleted != null && iDate != makeDate(dateCompleted) && iDate > makeDate(dateCompleted)){
						this.value = tempDocSubDate;
						showMessageBox("Date of document submission should not be later than the date of completion.", imgMessage.INFO);
						return false;
					}else{
						$("rcvdBy").value = userId;
						//reqdDocsTableGrid.setValueAt($F("rcvdBy"),userId,i, true);
						disableFrwd(this.value, dateCompleted);
						return true;							
						
					}
	            }
			}	
		}else{
			disableFrwd(this.value, $F("docCmpltdDt"));
			return true;
		}
	});
	
	$("docCmpltdDt").observe("focus",function(){
		tempDocComDate = this.value;
	});
	$("docCmpltdDt").observe("change", function(){
		if(this.value != ''){
			 if (checkDate2(this.value)) {
				 var comDate = makeDate(this.value);
				 if(comDate > dateToday){
					this.value = tempDocComDate;
					showMessageBox("Date of document completion can not be later than the current date.", imgMessage.INFO);
					return false;
               }else if(comDate < makeDate(objCLMGlobal.strClaimFileDate)){
           		this.value = tempDocComDate;
            	   	showMessageBox("This claim was filed on: "+objCLMGlobal.strClaimFileDate+"; the date of document completion can not be earlier than this.", imgMessage.INFO);
					return false;
               }else{
					var dateSub = $F("docSbmttdDt");
					if(dateSub != null && comDate != makeDate(dateSub) && comDate < makeDate(dateSub)){
						this.value = tempDocComDate;
						showMessageBox("Date of document completion should not be earlier than the date of submission.", imgMessage.INFO);
						return false;
					}else{
						disableFrwd(dateSub, this.value);
						return true;
					}
               }
			 }
		}else{ 
			disableFrwd(reqdDocsTableGrid.getValueAt(reqdDocsTableGrid.getColumnIndex('docSbmttdDt'), y), value, y);
			return true;
		}
	});
	
	initializeAll();
	initializeAccordion();
	observeReloadForm("reloadForm", showClaimRequiredDocs);
	setDocumentTitle("Claim Required Documents");
	setModuleId("GICLS011"); 
	populateDocumentFields(null);
	//initializeChangeTagBehavior(saveLineSubline);
	
	$("clmExit").stopObserving("click");	
	$("clmExit").observe("click",function(){
		exitCancelFunc();
	});
	
	function exitCancelFunc(){
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
					"Yes", "No", "Cancel", function() {
						objExit.exit = true;
						fireEvent($("btnSaveDocument"), "click");
					}, function() {
						goToModule("/GIISUserController?action=goToUnderwriting","Underwriting Main", null);
					}, "");
		}else if (objCLMGlobal.callingForm == "GICLS001"){
			goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
		} else {
			showClaimListing();
		}
	}
	
	
</script>

