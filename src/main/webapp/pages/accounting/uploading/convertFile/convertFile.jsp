<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="convertFileMainDiv">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>File Conversion</label>
			<span class="refreshers" style="margin-top: 0;">
				<label id="btnReloadForm" name="gro" style="margin-left: 5px;">Reload Form</label>
			</span>
		</div>
	</div>
	<div class="sectionDiv">
		<div class="sectionDiv" style="float: none; margin: 30px auto 0; width: 650px; padding: 40px 0;">
			<form id="uploadExcelForm" name="uploadExcelForm" enctype="multipart/form-data" method="POST" action="" target="uploadTrg">
				<input type="hidden" value="readFile2" id="action" name="action" />
				<table align="center" border="0">
					<tr>
						<td>
							<label for="txtConvertDate" style="float: right;">Convert Date</label>
						</td>
						<td colspan="3" style="padding-left: 4px;">
							<div style="float: left; width: 160px; height: 20px; margin: 0;" class="withIconDiv required">
								<input type="text" id="txtConvertDate" name="txtConvertDate" class="withIcon required" readonly="readonly" style="width: 136px;" tabindex="101"/>
								<img id="imgConvertDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="" style="margin : 1px 1px 0 0; cursor: pointer"/>
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<label for="txtSourceCd" style="float: right;">Source</label>
						</td>
						<td colspan="3" style="padding-left: 4px;">
							<span class="lovSpan required" style="width: 70px; margin-bottom: 0;">
								<input type="text" id="txtSourceCd" name="txtSourceCd" style="width: 45px; float: left;" class="withIcon allCaps required"  maxlength="4"  tabindex="102"/>  
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSourceCd" alt="Go" style="float: right;" />
							</span>
							<input type="text" id="txtSourceName" readonly="readonly" style="float: left; margin: 0; height: 14px; width: 321px; margin-left: 2px;" tabindex="103"/>
						</td>
					</tr>
					<tr>
						<td>
							<label for="selTransaction" style="float: right;">Transaction</label>
						</td>
						<td colspan="3" style="padding-left: 4px;">
							<select id="selTransaction" name="selTransaction" class="required" style="float: left; width: 403px; margin: 0;">
								<c:forEach var="trans" items="${trans}">
									<option value="${trans.tranCd}">${trans.tranName}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<td>
							<label for="txtfileName" style="float: right;">Filename</label>
						</td>
						<td colspan="3" style="padding-left: 4px;">
							<input type="file" name="file" id="fileName" style="width: 100%;"/>
							<div id="uploadStatusDiv" style="display: none; padding: 2px; width: 336px; height: 18px; border: 1px solid gray; float: left; background-color: white;">
								<span id="progressBar" style="background-color: #66FF33; height: 18px; float: left;"></span>
							</div>
						</td>
					</tr>
					<tr>
						<!-- <td>
							<label for="txtRemarks" style="float: right;">Remarks</label>
						</td>
						<td colspan="3" style="padding-left: 4px;">
							<input type="text" id="txtRemarks" name="txtRemarks" style="float: left; width: 395px; margin: 0; height: 14px;" />
						</td> -->
						<td width="" class="rightAligned" style="float: right;">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 400px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 370px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="209"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="210"/>
							</div>
						</td>
					</tr>
					<tr>
						<td><label for="txtRecsConverted" style="float: right;">Records Converted</label></td>
						<td style="padding-left: 4px;">
							<input type="text" id="txtRecsConverted" style="float: left; text-align:right; margin: 0; height: 14px;" readonly="readonly"/>
						</td>
						<td><label for="totRecs" style="float: right; margin-left: 4px;">Total Records in File</label></td>
						<td>
							<input type="text" id="totRecs" style="float: left; text-align:right; margin: 0; height: 14px;" readonly="readonly"/>
						</td>
					</tr>
				</table>
			</form>
			<div>
				<iframe id="uploadTrg" name="uploadTrg" height="0" width="0" frameborder="0" scrolling="no" style="display: none;"></iframe>
				<div id="updaterDiv" name="updaterDiv" style="visibility: hidden; display: none; height: 0; width: 0"></div>
			</div>
		</div>
		<div style="margin: 20px auto; width: 650px;">
			<input type="button" class="button" id="btnConvertFile" value="Convert File" style="width: 110px;" />
			<input type="button" class="button" id="btnProcessData" value="Process Data" style="width: 110px;" />
		</div>
	</div>
</div>
<div id="process"></div>
<script type="text/javascript">
	try {
		
		var onLOV = false;
		var checkFileSource = "";
		atmTag = "";
		sourceCd = "";
		fileNo = "";
		objUploading = new Object();	//shan 06.09.2015 : conversion of GIACS607
		
		function initGIACS601(){
			setModuleId("GIACS601");
			setDocumentTitle("File Conversion");
			$("txtConvertDate").value = getCurrentDate();
			disableButton("btnConvertFile");
			disableButton("btnProcessData");
		}
		
		function reloadForm(){
			onLOV = false;
			checkFileSource = "";
			atmTag = "";
			$("txtConvertDate").value = getCurrentDate();
			disableButton("btnConvertFile");
			disableButton("btnProcessData");
			$("fileName").clear();
			$("selTransaction").value = 1;
			$("txtSourceCd").clear();
			$("txtSourceName").clear();
			$("txtRemarks").clear();
			$("txtRecsConverted").clear();
			$("totRecs").clear();
		}
		
		$("btnReloadForm").observe("click", reloadForm);
		
		$("fileName").observe("click", function(event){
			if(checkFileSource == ""){
				event.stop();
				this.clear();
				disableButton("btnConvertFile");
				disableButton("btnProcessData");
				customShowMessageBox("Please enter value for Source first.", "I", "txtSourceCd");
			}
		});
				
		function getFileSourceLOV() {
			if(onLOV) return;
			onLOV = true;
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getFileSourceLOV",
					searchString : checkFileSource == "" ? $("txtSourceCd").value : "",
					page : 1
				},
				title : "Valid Values for Source",
				width : 480,
				height : 386,
				columnModel : [
					{
						id : "sourceCd",
						title : "Code",
						width : '90px',
					},
					{
						id : "sourceName",
						title : "Name",
						width : '270px',
						renderer: function(value) {
							return unescapeHTML2(value);
						}
					}
				],
				draggable : true,
				autoSelectOneRecord: true,
				filterText:  checkFileSource == "" ? $("txtSourceCd").value : "",
				onSelect : function(row) {
					onLOV = false;
					checkFileSource = row.sourceCd;
					$("txtSourceCd").value = row.sourceCd;
					$("txtSourceName").value = row.sourceName;
					atmTag = row.atmTag;
				},
				onCancel : function () {
					onLOV = false;
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtSourceCd");
					onLOV = false;
				}
			});
		}
		
		$("txtSourceCd").observe("change", function(event){
			/* if(event.keyCode == 13) {
				getFileSourceLOV();
			} else if (event.keyCode == 0 || event.keyCode == 8 || event.keyCode == 46) {
				checkFileSource = "";
				$("txtSourceName").clear();
				disableButton("btnConvertFile");
				disableButton("btnProcessData");
			} */
			if($("txtSourceCd").value == ""){
				checkFileSource = "";
				atmTag = "";
				$("txtSourceName").clear();
				disableButton("btnConvertFile");
				disableButton("btnProcessData");
			} else {
				getFileSourceLOV();
			}
		});
		
		$("imgSourceCd").observe("click", getFileSourceLOV);
		
		$("fileName").observe("change", function(event){
			var message= "";
			var tmppath = URL.createObjectURL(event.target.files[0]);
			if(!this.value == "" || !this.value == null)
				message = checkfileName();
				if (message != 'GOOD'){
					showMessageBox(message, imgMessage.ERROR);
					$("fileName").clear();
				} else {
					enableButton("btnConvertFile");
					disableButton("btnProcessData");
				}
		});
		
		function checkfileName() {
			var ajaxResponse = "";
			
			new Ajax.Request(contextPath + "/GIACUploadingController",{
				method: "POST",
				parameters: {
						     action : "checkFileName",
						     fileName : $("fileName").value,
						     transactionType : $("selTransaction").value,
						     sourceCd : $("txtSourceCd").value
				},
				asynchronous: false,
				onComplete : function(response){
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						ajaxResponse = trim(response.responseText);
					}
				}
			});
			
			return ajaxResponse;
		}
		
		function uploadFile(){//here
			$("uploadTrg").contentWindow.document.body.innerHTML = "";
			$("progressBar").style.width = "0%";
			$("uploadExcelForm").action = "GIACUploadingController?" + fixTildeProblem(Form.serialize("uploadExcelForm"));
			$("uploadExcelForm").submit();
			
			updater = new Ajax.PeriodicalUpdater('updaterDiv','GIACUploadingController', {
		        frequency: 0.1,
		        method: "GET", 
		        onSuccess: function(response) {
		        	var result = JSON.parse($("uploadTrg").contentWindow.document.body.innerHTML.stripTags().strip());
		        	if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
			            if (result.message == "SUCCESS") {
			            	updater.stop();
			            	$("progressBar").style.width = "100%";
			            	Effect.Fade($("uploadStatusDiv"), {
			            			duration: 0.5,
			            			afterFinish: function(){
			            				processFile(result);
			            				$("fileName").clear();
			            				$("fileName").show();
			            				$("uploadStatusDiv").hide();	  
			            			 }
			            		});
			            } else {
			            	showMessage(response.responseText, imgMessage.ERROR);
			            	updater.stop();
			            }
		        	}
		        	updater.stop();
		    	}
		    });	  
			
		}
		
		function processFile(result){
			new Ajax.Request(contextPath + "/GIACUploadingController",{
				method: "POST",
				parameters: {
						     action : "processFile",
						     tranTypeCd : result.tranTypeCd,
						     sourceCd : result.sourceCd,
						     convertDate : result.convertDate,
						     remarks : result.remarks,
						     fileName : result.fileName,
						     filePath : result.filePath
				},
				asynchronous: true,
				onComplete : function(response){
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						var obj = JSON.parse(response.responseText);
						if (obj.message == "Good"){
							showWaitingMessageBox("Data conversion completed successfully.", imgMessage.SUCCESS, function(){
								$("totRecs").value = obj.rows;
							 	$("txtRecsConverted").value = obj.recordsConverted;
							 	disableButton("btnConvertFile");
								enableButton("btnProcessData");
								sourceCd = obj.sourceCd;
								fileNo = obj.fileNo;
							});
						} else {
							showMessageBox(obj.message, imgMessage.ERROR);
						}
					}
				}
			});
		}
		
		
		$("btnConvertFile").observe("click", function(){

			var message= "";
			
			if(!this.value == "" || !this.value == null)
				message = checkfileName();
				if (message != 'GOOD'){
					showMessageBox(message, imgMessage.ERROR);
					$("fileName").clear();
					disableButton("btnConvertFile");
					disableButton("btnProcessData");
				} else {
					new Ajax.Request(contextPath + "/GIACUploadingController",{
						method: "POST",
						parameters: {
								     action : "checkFileName",
								     fileName : $("fileName").value,
								     transactionType : $("selTransaction").value,
								     sourceCd : $("txtSourceCd").value
						},
						asynchronous: true,
						evalScripts : true,
						onComplete : function(response){
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
								ajaxResponse = trim(response.responseText);
								if (ajaxResponse == "GOOD"){
									uploadFile();
									/* $("uploadExcelForm").action = "GIACUploadingController?" + fixTildeProblem(Form.serialize("uploadExcelForm"));
									$("uploadExcelForm").submit();
									
									var periodicalChecker = setInterval(function(){
										var iframe = document.getElementById('targetDiv');
										var innerDoc = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
										if(innerDoc.body){
											var content = innerDoc.body.innerHTML;
											if(content.length != 0){
												if (content.include("Geniisys Exception")){
													jsonContent = JSON.parse(content);
													var message = jsonContent.message.split("#");
													showMessageBox(message[2] , message[1]);
													clearInterval(periodicalChecker);
													innerDoc.body.innerHTML = "";
												} else if (content.include("Exception")) {
													clearInterval(periodicalChecker);
													showMessageBox(content, "E");
													innerDoc.body.innerHTML = "";
													$("txtRecsConverted").value = 0;
												} else if (content.include("Good")){
													clearInterval(periodicalChecker);
													jsonContent = JSON.parse(content);
													$("totRecs").value = jsonContent.rows;
													$("txtRecsConverted").value = jsonContent.recordsConverted;
													disableButton("btnConvertFile");
													enableButton("btnProcessData");
													sourceCd = jsonContent.sourceCd;
													fileNo = jsonContent.fileNo;
													innerDoc.body.innerHTML = "";
													showMessageBox("Data conversion completed successfully.", "S");
												}
												clearInterval(periodicalChecker);
											} else {
												clearInterval(periodicalChecker);
											}
										} else {
											clearInterval(periodicalChecker);
										}
									}, 1); */
									
								}
							}
						}
					});
				}
		});
		
		
		$("imgConvertDate").observe("click", function(){
			scwShow($("txtConvertDate"), this, null);
		});
		
		$("btnProcessData").observe("click", function(){
			//added by john 4.20.2015
		 	if($F("txtSourceCd") == ""){
				customShowMessageBox("Please enter value for Source first.", "I", "txtSourceCd");
			} else {
				if($F("txtRecsConverted") != "" && $F("txtRecsConverted") == $F("totRecs")){
					if ($F("selTransaction") == 1){
						if(atmTag == "Y"){
							showGiacs604();
						} else {
							showGiacs603();
						}
					} else if ($F("selTransaction") == 2){	
						showGiacs607();
					} else if ($F("selTransaction") == 3){	
						showGiacs608();
					} else if ($F("selTransaction") == 4){	
						showGiacs609();
					} else if ($F("selTransaction") == 5){
						showGiacs610();
					} else{
						showMessageBox(objCommonMessage.UNAVAILABLE_MODULE, "I");
					}
				} else {
					customShowMessageBox("Please enter value for Source first.", "I", "txtSourceCd");
				} 
			}
		});
		
		function showGiacs603(){
			new Ajax.Updater("process", contextPath+"/GIACUploadingController",{
				parameters:{
					action: "showGiacs603",
					sourceCd: sourceCd,
					fileNo: fileNo
				},
				asynchronous: false,
				evalScripts: true, 
				onCreate: showNotice("Loading, please wait..."),
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)) {
						//nieko Accounting Uploading
						objACGlobal.prevForm = "GIACS601";
						$("mainNav").hide();
						objUploading.totRecs = $F("totRecs");
						//nieko end
						$("convertFileMainDiv").hide();
						$("process").show();
					}	
				}
			});
		}
		
		/*
		**nieko Accounting Uploading GIACS607
		function showGIACS607(){	//shan 06.09.2015 : conversion of GIACS607
			new Ajax.Request(contextPath+"/GIACUploadingController",{
				method: "POST",
				parameters:{
					action: "showGIACS607",
					sourceCd: sourceCd,
					fileNo: fileNo
				},
				onCreate: showNotice("Loading, please wait..."),
				onComplete: function(response){
					hideNotice();
					$("process").update(response.responseText);
					$("convertFileMainDiv").hide();
					$("process").show();
					objACGlobal.callingForm = "GIACS601";
				}
			});
		}*/
		
		function showGiacs604(){ //john 8.27.2015 : conversion of GIACS604
			new Ajax.Updater("process", contextPath+"/GIACUploadingController",{
				parameters:{
					action: "showGiacs604",
					sourceCd: sourceCd, 
					fileNo: fileNo
				},
				asynchronous: false,
				evalScripts: true, 
				onCreate: showNotice("Loading, please wait..."),
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)) {
						//nieko Accounting Uploading
						objACGlobal.prevForm = "GIACS601";
						$("mainNav").hide();
						objUploading.totRecs = $F("totRecs");
						//nieko end
						$("convertFileMainDiv").hide();
						$("process").show();
					}	
				}
			});
		}
		
		function showGiacs607(){ //nieko Accounting Uploading
			new Ajax.Updater("process", contextPath+"/GIACUploadingController",{
				parameters:{
					action: "showGIACS607",
					sourceCd: sourceCd, 
					fileNo: fileNo
				},
				asynchronous: false,
				evalScripts: true, 
				onCreate: showNotice("Loading, please wait..."),
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)) {
						objACGlobal.prevForm = "GIACS601";
						$("mainNav").hide();
						objUploading.totRecs = $F("totRecs");
						$("convertFileMainDiv").hide();
						$("process").show();
					}	
				}
			});
		}
		
		function showGiacs608(){ //john 9.21.2015 : conversion of GIACS608
			new Ajax.Updater("process", contextPath+"/GIACUploadingController",{
				parameters:{
					action: "showGIACS608",
					sourceCd: sourceCd, 
					fileNo: fileNo
				},
				asynchronous: false,
				evalScripts: true, 
				onCreate: showNotice("Loading, please wait..."),
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)) {
						//nieko Accounting Uploading
						objACGlobal.prevForm = "GIACS601";
						$("mainNav").hide();
						objUploading.totRecs = $F("totRecs");
						//nieko end
						$("convertFileMainDiv").hide();
						$("process").show();
					}	
				}
			});
		}
		
		function showGiacs610(){ //john 10.22.2015 : conversion of GIACS610
			new Ajax.Updater("process", contextPath+"/GIACUploadingController",{
				parameters:{
					action: "showGiacs610",
					sourceCd: sourceCd, 
					fileNo: fileNo
				},
				asynchronous: false,
				evalScripts: true, 
				onCreate: showNotice("Loading, please wait..."),
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)) {
						//Deo [10.06.2016]: add start
						objACGlobal.prevForm = "GIACS601";
						$("mainNav").hide();
						objUploading.totRecs = $F("totRecs");
						//Deo [10.06.2016]: add ends
						$("convertFileMainDiv").hide();
						$("process").show();
					}	
				}
			});
		}
		
		function showGiacs609() {
			new Ajax.Updater("process", contextPath+"/GIACUploadingController",{
				parameters:{
					action: "showGiacs609",
					sourceCd: sourceCd,
					fileNo: fileNo
				},
				asynchronous: false,
				evalScripts: true, 
				onCreate: showNotice("Loading, please wait..."),
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)) {
						objACGlobal.prevForm = "GIACS601";
						$("mainNav").hide();
						objUploading.totRecs = $F("totRecs");
						$("convertFileMainDiv").hide();
					}
				}
			});
		}
		
		//objUploading.showGIACS607 = showGIACS607; nieko Accounting Uploading GIACS607
		
		$("acExit").stopObserving("click");
		$("acExit").observe("click", function(){
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		});
		
		$("editRemarks").observe("click", function() {
			showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
		});
		
		initializeAll();
		initGIACS601();
		
		//Deo [10.06.2016]: add start
		if (objACGlobal.callingForm == "GIACS610") {
			$("txtConvertDate").value = dateFormat (objGIACS610.convertDate, "mm-dd-yyyy");
			$("txtSourceCd").value = objGIACS610.sourceCd;
			$("txtSourceName").value = objGIACS610.sourceName;
			$("selTransaction").value = 5;
			$("txtRemarks").value = objGIACS610.remarks;
			$("txtRecsConverted").value = objGIACS610.noOfRecords;
			$("totRecs").value = objGIACS610.totRecs;
			sourceCd = $F("txtSourceCd");
			checkFileSource = $F("txtSourceCd");
			fileNo = objGIACS610.fileNo;
			objGIACS610.convertDate = "";
		 	objGIACS610.sourceCd = "";
			objGIACS610.sourceName = "";
			objGIACS610.remarks = "";
			objGIACS610.noOfRecords = "";
			objUploading.totRecs = "";
			objGIACS610.fileNo = "";
			objACGlobal.callingForm = "";
			disableButton("btnConvertFile");
			enableButton("btnProcessData");
			//Deo [10.06.2016]: add ends
		} else if(objACGlobal.callingForm == "GIACS603") {
			//nieko Accounting Uploading
			$("txtConvertDate").value = dateFormat (objGIACS603.convertDate, "mm-dd-yyyy");
			$("txtSourceCd").value = objGIACS603.sourceCd;
			$("txtSourceName").value = objGIACS603.sourceName;
			$("selTransaction").value = 1;
			$("txtRemarks").value = objGIACS603.remarks;
			$("txtRecsConverted").value = objGIACS603.noOfRecords;
			$("totRecs").value = objGIACS603.totRecs;
			sourceCd = $F("txtSourceCd");
			checkFileSource = $F("txtSourceCd");
			fileNo = objGIACS603.fileNo;
			objGIACS603.convertDate = "";
			objGIACS603.sourceCd = "";
			objGIACS603.sourceName = "";
			objGIACS603.remarks = "";
			objGIACS603.noOfRecords = "";
			objGIACS603.totRecs = "";
			objGIACS603.fileNo = "";
			objACGlobal.callingForm = "";
			disableButton("btnConvertFile");
			enableButton("btnProcessData");
		} else if(objACGlobal.callingForm == "GIACS604") {
			//nieko Accounting Uploading
			$("txtConvertDate").value = dateFormat (objGIACS604.convertDate, "mm-dd-yyyy");
			$("txtSourceCd").value = objGIACS604.sourceCd;
			$("txtSourceName").value = objGIACS604.sourceName;
			$("selTransaction").value = 1;
			$("txtRemarks").value = objGIACS604.remarks;
			$("txtRecsConverted").value = objGIACS604.noOfRecords;
			$("totRecs").value = objGIACS604.totRecs;
			sourceCd = $F("txtSourceCd");
			checkFileSource = $F("txtSourceCd");
			fileNo = objGIACS604.fileNo;
			objGIACS604.convertDate = "";
			objGIACS604.sourceCd = "";
			objGIACS604.sourceName = "";
			objGIACS604.remarks = "";
			objGIACS604.noOfRecords = "";
			objGIACS604.totRecs = "";
			objGIACS604.fileNo = "";
			objACGlobal.callingForm = "";
			disableButton("btnConvertFile");
			enableButton("btnProcessData");	
		} else if(objACGlobal.callingForm == "GIACS607") {
			//nieko Accounting Uploading
			$("txtConvertDate").value = dateFormat (objGIACS607.convertDate, "mm-dd-yyyy");
			$("txtSourceCd").value = objGIACS607.sourceCd;
			$("txtSourceName").value = objGIACS607.sourceName;
			$("selTransaction").value = 2;
			$("txtRemarks").value = objGIACS607.remarks;
			$("txtRecsConverted").value = objGIACS607.noOfRecords;
			$("totRecs").value = objGIACS607.totRecs;
			sourceCd = $F("txtSourceCd");
			checkFileSource = $F("txtSourceCd");
			fileNo = objGIACS607.fileNo;
			objGIACS607.convertDate = "";
			objGIACS607.sourceCd = "";
			objGIACS607.sourceName = "";
			objGIACS607.remarks = "";
			objGIACS607.noOfRecords = "";
			objGIACS607.totRecs = "";
			objGIACS607.fileNo = "";
			objACGlobal.callingForm = "";
			disableButton("btnConvertFile");
			enableButton("btnProcessData");	
		} else if(objACGlobal.callingForm == "GIACS608") {
			//nieko Accounting Uploading
			$("txtConvertDate").value = dateFormat (objGIACS608.convertDate, "mm-dd-yyyy");
			$("txtSourceCd").value = objGIACS608.sourceCd;
			$("txtSourceName").value = objGIACS608.sourceName;
			$("selTransaction").value = 3;
			$("txtRemarks").value = objGIACS608.remarks;
			$("txtRecsConverted").value = objGIACS608.noOfRecords;
			$("totRecs").value = objGIACS608.totRecs;
			sourceCd = $F("txtSourceCd");
			checkFileSource = $F("txtSourceCd");
			fileNo = objGIACS608.fileNo;
			objGIACS608.convertDate = "";
			objGIACS608.sourceCd = "";
			objGIACS608.sourceName = "";
			objGIACS608.remarks = "";
			objGIACS608.noOfRecords = "";
			objGIACS608.totRecs = "";
			objGIACS608.fileNo = "";
			objACGlobal.callingForm = "";
			disableButton("btnConvertFile");
			enableButton("btnProcessData");
		} else if (objACGlobal.callingForm == "GIACS609") { //Deo: GIACS609 conversion
			$("txtConvertDate").value = dateFormat (objGIACS609.convertDate, "mm-dd-yyyy");
			$("txtSourceCd").value = objGIACS609.sourceCd;
			$("txtSourceName").value = objGIACS609.sourceName;
			$("selTransaction").value = 4;
			$("txtRemarks").value = objGIACS609.remarks;
			$("txtRecsConverted").value = objGIACS609.noOfRecords;
			$("totRecs").value = objGIACS609.totRecs;
			sourceCd = $F("txtSourceCd");
			checkFileSource = $F("txtSourceCd");
			fileNo = objGIACS609.fileNo;
			objGIACS609.convertDate = "";
			objGIACS609.sourceCd = "";
			objGIACS609.sourceName = "";
			objGIACS609.remarks = "";
			objGIACS609.noOfRecords = "";
			objUploading.totRecs = "";
			objGIACS609.fileNo = "";
			objACGlobal.callingForm = "";
			disableButton("btnConvertFile");
			enableButton("btnProcessData");
		}
	} catch (e) {
		showErrorMessage("File Conversion", e);
	}
</script>
