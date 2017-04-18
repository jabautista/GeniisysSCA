<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="checkReleaseInfoMainDiv" name="checkReleaseInfoMainDiv">

	<div id="checkReleaseInfoFieldsDiv" name="checkReleaseInfoFieldsDiv" changeTagAttr="true" class="sectionDiv" style="align:center; width:680px; height: 150px;margin: 20px 10px 10px 20px">
		<form id="checkReleaseInfoForm" name="checkReleaseInfoForm">
			<!-- <br />&nbsp;&nbsp;&nbsp;Check Release Information: -->
			<table border="0" width="680px" align="center" style="margin-top:10px;">
				<tr>
					<td>
						<input type="hidden" id="hidGaccTranId" name="hidGaccTranId" />
						<input type="hidden" id="hidItemNo" name="hidItemNo" />
						<input type="hidden" id="hidCheckPrefSuf" name="hidCheckPrefSuf" />
						<input type="hidden" id="hidCheckNo" name="hidCheckNo" />
					</td>
				</tr>
				<tr style="width:100px;">
					<td style="text-align:right;">Check No.</td>
					<td>
						<input type="text" id="txtCheckPrefSuf" name="txtCheckPrefSuf" maxLength="5" style="width:49px; margin-left:5px;" readonly="readonly" />
						<input type="text" id="txtCheckNo" name="txtCheckNo"  maxLength="12" style="text-align:right; width:108px;margin-left:2px;" readonly="readonly" />
					</td>
					<td style="text-align:right;">Check Received By</td>
					<td><input type="text" id="txtCheckReceivedBy" name="txtCheckReceivedBy" name2="chng" maxLength="30" class="required" style="margin-left:5px; width:170px;" /></td>
				</tr>
				<tr>
					<td style="text-align:right;">Check Release Date</td>
					<td>
						<!-- <input type="text" id="txtCheckReleaseDate" name="txtCheckReleaseDate" class="required" maxLength="11" style="margin-left:5px;width:170px;" /> --> 
						<div class="required" style="border: solid 1px gray; width:176px; height: 22px; margin-right:0px; margin-left:5px; margin-top: 0px;">
					    	<input type="text" id="txtCheckReleaseDate" name="txtCheckReleaseDate" class="required" maxLength="11" style="float:left;width:152px; border: none; height:12px;" />
					    	<img name="hrefCheckReleaseDate" id="hrefCheckReleaseDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" style="align:right;" alt="checkReleaseDate" />
						</div>	
					</td>
					<td style="text-align:right;">O.R. No.</td>
					<td><input type="text" id="txtORNo" name="txtORNo"  name2="chng" maxLength="10" style="margin-left:5px;width:170px;" /></td>
				</tr>
				<tr>
					<td style="text-align:right;">Check Released By</td>
					<td><input type="text" id="txtCheckReleasedBy" name="txtCheckReleasedBy"  name2="chng" class="required" maxLength="30" style="margin-left:5px;width:170px;" /> </td>
					<td style="text-align:right;">O.R. Date</td>
					<td>
						<!-- <input type="text" id="txtORDate" name="txtORDate" maxLength="11" style="margin-left:5px;width:170px;" /> -->
						<div style="border: solid 1px gray; width:176px; height: 22px; margin-right:0px; margin-left:5px; margin-top: 0px;">
					    	<input type="text" id="txtORDate" name="txtORDate" maxLength="11" style="float:left;width:152px; border: none; height:12px;" />
					    	<img name="hrefORDate" id="hrefORDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" style="align:right;" alt="checkReleaseDate" />
						</div>
					</td>
				</tr>
				<tr>
					<td style="text-align:right;">User ID</td>
					<td><input type="text" id="txtChkUserID" name="txtChkUserID" maxLength="8" style="margin-left:5px;width:170px;" readonly="readonly" /> </td>
					<td style="text-align:right;">Last Update</td>
					<td><input type="text" id="txtChkLastUpdate" name="txtChkLastUpdate" maxLength="26" style="margin-left:5px;width:170px;" readonly="readonly" /></td>
				</tr>
			</table>
		</form>
	</div>
	
	<div id="checkReleaseButtonDiv" name="checkReleaseButtonDiv" class="buttonsDiv" style="align:center; width: 680px; height:30px; margin: 10px 5px 5px 35px;" >
		<input type="button" id="btnSave" name="btnSave" class="button" value="Save" style="width:90px;"/>
		<input type="button" id="btnReturn" name="btnReturn" class="button" value="Return" style="width:90px;" />
	</div>
</div>

<script type="text/javascript">
	
	changeTag = 0;
	try {
		var chkReleaseInfo = JSON.parse('${chkReleaseInfo}'.replace(/\\/g,'\\\\'));
		var checkPrefSuf = '${checkPrefSuf}';
		var checkNo = '${checkNo}';
		
	} catch(e){
		showErrorMessage("checkReleaseInformation.jsp: " + e);
	}
	
	function initializeFields(){
		if(chkReleaseInfo.gaccTranId != null){
			$("hidGaccTranId").value 		= chkReleaseInfo.gaccTranId;
			$("hidItemNo").value 			= chkReleaseInfo.itemNo;	
			/*$("hidLastUpdate").value 		= chkReleaseInfo.lastUpdate;
			$("hidCheckReleaseDate").value 	= chkReleaseInfo.checkReleaseDate;
			$("hidOrDate").value 			= chkReleaseInfo.orDate;*/
			
			$("txtCheckPrefSuf").value 		= chkReleaseInfo.checkPrefSuf == null ? "" : unescapeHTML2(chkReleaseInfo.checkPrefSuf);	
			$("txtCheckNo").value 			= chkReleaseInfo.checkNo == null ? "" : (chkReleaseInfo.checkNo == "" ? "" : formatNumberDigits(chkReleaseInfo.checkNo, 10));	
			$("txtCheckReceivedBy").value 	= chkReleaseInfo.checkReceivedBy == null ? "" : unescapeHTML2(chkReleaseInfo.checkReceivedBy);	
			$("txtCheckReleaseDate").value 	= chkReleaseInfo.strCheckReleaseDate == null ? "" : chkReleaseInfo.strCheckReleaseDate;	
			$("txtORDate").value 			= chkReleaseInfo.strOrDate == null ? "" : chkReleaseInfo.strOrDate;	
			$("txtCheckReleasedBy").value	= chkReleaseInfo.checkReleasedBy == null ? "" : unescapeHTML2(chkReleaseInfo.checkReleasedBy);	
			$("txtORNo").value 				= chkReleaseInfo.orNo == null ? "": unescapeHTML2(chkReleaseInfo.orNo);	
			$("txtChkUserID").value 			= chkReleaseInfo.userId == null ? "" : unescapeHTML2(chkReleaseInfo.userId);	
			$("txtChkLastUpdate").value 		= chkReleaseInfo.strLastUpdate2 == null ? "" : chkReleaseInfo.strLastUpdate2;	
			
			/*var reqDivArray = ["checkReleaseInfoFieldsDiv", "checkReleaseButtonDiv"]; 
			disableFields2(reqDivArray, true);*/
		} else {
			var now = new Date().format("mm-dd-yyyy h:MM:ss TT");
			var now1 = new Date().format("mm-dd-yyyy");
			
			$("hidGaccTranId").value 		= objGIACS002.gaccTranId;
			$("hidItemNo").value 			= objGIACS002.itemNo;
			
			$("txtCheckPrefSuf").value 		= checkPrefSuf; //$F("hidCheckPrefSuf");
			$("txtCheckNo").value 			= checkNo == "" ? "" : formatNumberDigits(checkNo, 10);	
			$("txtCheckReceivedBy").value 	= chkReleaseInfo.checkReceivedBy == null ? "" : unescapeHTML2(chkReleaseInfo.checkReceivedBy);	
			//$("txtCheckReleaseDate").value 	= now1;																								commented out by gab 11.17.2015
			$("txtORDate").value 			= "";	
			//$("txtCheckReleasedBy").value	= objGIACS002.currentUserId; //objGIACS002.userId;	commented out by gab 11.17.2015
			$("txtORNo").value 				= "";	
			$("txtChkUserID").value 			= objGIACS002.currentUserId; //objGIACS002.userId;	
			$("txtChkLastUpdate").value 		= now;	
			
			if(objGIACS002.isPrinted){
				enableButton("btnSave");
			}
		}
	}
	
	function disableFields2(reqDivArray, flag){
		//if flag == true ? disable
		for(var i=0; i< reqDivArray.length; i++){
			$$("div#"+reqDivArray[i]+" input[type='text']").each(function (a) {
				if(a.id != "txtChkUserID" || a.id != "txtChkLastUpdate"){
					$(a).readOnly = flag;
				}
				//$(a).disable();
			});
			/* $$("div#"+reqDivArray[i]+" input[type='button']").each(function (d) {
				if(d.id == "btnSave"){
					flag ? disableButton(d) : enableButton(d);
				}
			}); */
		}
	}
	
	function proceedSaveChkReleaseInfo(){
		if(checkAllRequiredFieldsInDiv("checkReleaseInfoFieldsDiv")){
			if(changeTag != 0){
				saveChkReleaseInfo();
			} else {
				showMessageBox(objCommonMessage.NO_CHANGES, "I");
			}
		}
		/*if(changeTag == 0){
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
		} else {
			if(checkAllRequiredFieldsInDiv("checkReleaseInfoFieldsDiv")){
				saveChkReleaseInfo();
			}
		}*/
	}
	
	function saveChkReleaseInfo(){
		if(checkAllRequiredFieldsInDiv("checkReleaseInfoFieldsDiv")){	
			try{
				new Ajax.Request(contextPath + "/GIACChkDisbursementController?action=saveCheckReleaseInfo", {
					 method: "POST",
					 postBody: Form.serialize("checkReleaseInfoForm"),
					 evalScripts: true,
					 asynchronous: false,
					 onCreate: function(){
						 showNotice("Saving check release information, please wait...");
					 },
					 onComplete: function(response){
						 hideNotice("");
						 if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response, null)){
							 if(response.responseText == "SUCCESS"){
									showMessageBox("Saving successful.", "S");
									changeTag = 0;
									//disableFields2(["checkReleaseInfoFieldsDiv","checkReleaseButtonDiv"], true);
									enableButton("btnSave");
									$("btnSave").value = "Update";
							 }
						 }
					 }
				 });
			}catch(e){
				showErrorMessage("saveChkReleaseInfo: " + e);
			}	
		}
	}
	
	function validateDateFormat(strValue, elemName){
		var text = strValue; 
		var comp = text.split('-');
		var m = parseInt(comp[0], 10);
		var d = parseInt(comp[1], 10);
		var y = parseInt(comp[2], 10);
		var status = true;
		var isMatch = text.match(/^(\d{1,2})-(\d{1,2})-(\d{4})$/);
		var date = new Date(y,m-1,d);
		
		if(isNaN(y) || isNaN(m) || isNaN(d) || y.toString().length < 4 || !isMatch ){
			customShowMessageBox("Date must be entered in a format like MM-DD-RRRR.", imgMessage.INFO, elemName);
			status = false;
		}
		if(0 >= m || 13 <= m){
			customShowMessageBox("Month must be between 1 and 12.", imgMessage.INFO, elemName);	
			status = false; 
		}
		if(date.getDate() != d){				
			customShowMessageBox("Day must be between 1 and the last of the month.", imgMessage.INFO, elemName);	
			status = false;
		}
		if(!status){
			$(elemName).value = "";
		}
		return status;
	}
	
	function validateCheckReleaseDate(){
		changeTag = 1;
		if($F("txtCheckReleaseDate") != ""){
			if(validateDateFormat($F("txtCheckReleaseDate"), "txtCheckReleaseDate")){
				var now = new Date(); //.format("mm-dd-yyyy");
				var crd = Date.parse($F("txtCheckReleaseDate")); //.format("mm-dd-yyyy");
				
				if(crd > now){  //crd is later than today
					$("txtCheckReleaseDate").value = ""; //now.format("mm-dd-yyyy");
					customShowMessageBox("Check release date should not be later than today's date: " + now.format("mm-dd-yyyy"), "I", "txtCheckReleaseDate");
				} 
			}
		}
	}
	
	function validateOrDate(){
		changeTag = 1;
		if($F("txtORDate") != ""){
			if(validateDateFormat($F("txtORDate"), "txtORDate")){
				var od = Date.parse($F("txtORDate")).format("mm-dd-yyyy");
				$("txtORDate").value = od;
			}
		}
	}
	
	$("txtCheckReleaseDate").observe("change", validateCheckReleaseDate);
	
	$("hrefCheckReleaseDate").observe("click", function(){
		scwShow($('txtCheckReleaseDate'),this, null); 
	});
	
	$("hrefORDate").observe("click", function(){
		scwShow($('txtORDate'),this, null); 
	});
	$("txtORDate").observe("change", validateOrDate);
	
	$$("input[name2='chng']").each(function (d) {
		$(d).observe("change", function(){changeTag = 1;});
	});
	
	$("btnSave").observe("click", function(){
		proceedSaveChkReleaseInfo();
	});
	
	$("btnReturn").observe("click", function(){
		if(changeTag == 0 || ($("btnSave").disabled == true)){
			changeTag = 0;
			overlayCheckReleaseInfo.close();	
		} else {
			//showMessageBox("Please save your changes first.", "I");
			showConfirmBox("Confirmation", "Leaving the page will discard changes. Do you want to continue?", 
							"Yes", "No", 
							function(){
								changeTag = 0;
								overlayCheckReleaseInfo.close();
							}, // if YES
							function(){}, // if NO
							"");
		}
	});
	
	//added by gab 11.17.2015
	$("txtCheckReleasedBy").observe("click", function(){
		if(chkReleaseInfo.gaccTranId != null){
			$("txtCheckReleasedBy").value	= chkReleaseInfo.checkReleasedBy == null ? "" : unescapeHTML2(chkReleaseInfo.checkReleasedBy);
		} else {
			$("txtCheckReleasedBy").value	= objGIACS002.currentUserId;
		}
	});
	
	//added by gab 11.17.2015
	var now1 = new Date().format("mm-dd-yyyy");
	$("txtCheckReleaseDate").observe("click", function(){
		if(chkReleaseInfo.gaccTranId != null){
			$("txtCheckReleaseDate").value 	= chkReleaseInfo.strCheckReleaseDate == null ? "" : chkReleaseInfo.strCheckReleaseDate;
		} else {
			$("txtCheckReleaseDate").value 	= now1;	
		}
	});
	
	initializeAll();
	initializeChangeTagBehavior(proceedSaveChkReleaseInfo);
	initializeChangeAttribute();
	initializeFields();
	observeChangeTagOnDate("hrefORDate", "txtORDate", validateOrDate);
	observeChangeTagOnDate("hrefCheckReleaseDate", "txtCheckReleaseDate", validateCheckReleaseDate);
	/* if(objACGlobal.queryOnly == "Y" || objGIACS002.cancelDV == "Y"){
		var reqDivArray = ["checkReleaseInfoFieldsDiv", "checkReleaseButtonDiv"]; 
		disableFields2(reqDivArray, true);
	} */
</script>
