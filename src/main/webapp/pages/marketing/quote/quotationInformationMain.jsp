<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" %>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="quotationInformationMainDiv" name="quotationInformationMainDiv" style="display: none; margin-top: 1px;">
	<div  changeTagAttr="true">
	<form id="quotationInformationForm" name="quotationInformationForm">
		<jsp:include page="subPages/quotationInformation.jsp"></jsp:include>
		<jsp:include page="subPages/itemInformation.jsp"></jsp:include>
		<div id="otherInformationDiv" name="otherInformationDiv">
				<div id="outerDiv" name="outerDiv">	
					<div id="innerDiv" name="innerDiv">
				   		<label>Additional Information </label>
				   		<span class="refreshers" style="margin-top: 0;">
							<label id='additionalInfoAccordionLbl' name="gro">Show</label>
				   		</span>
					</div>
				</div>
				<c:choose>
					<c:when test="${lineCd eq 'AC' or lineCd eq 'PA'}">
						<jsp:include page="/pages/marketing/quote/subPages/additionalInfo/additionalInfoAC.jsp"></jsp:include>
					</c:when>
					<c:when test="${lineCd eq 'AV'}">
						<jsp:include page="/pages/marketing/quote/subPages/additionalInfo/additionalInfoAV.jsp"></jsp:include>
					</c:when>
					<c:when test="${lineCd eq 'CA'}">
						<jsp:include page="/pages/marketing/quote/subPages/additionalInfo/additionalInfoCA.jsp"></jsp:include>
					</c:when>
					<c:when test="${lineCd eq 'EN'}">
						<jsp:include page="/pages/marketing/quote/subPages/additionalInfo/additionalInfoEN.jsp"></jsp:include>
					</c:when>
					<c:when test="${lineCd eq 'FI'}">
						<jsp:include page="/pages/marketing/quote/subPages/additionalInfo/additionalInfoFI.jsp"></jsp:include>
					</c:when>
					<c:when test="${lineCd eq 'MC'}">
						<jsp:include page="/pages/marketing/quote/subPages/additionalInfo/additionalInfoMC.jsp"></jsp:include>
					</c:when>
					<c:when test="${lineCd eq 'MH'}">
						<jsp:include page="/pages/marketing/quote/subPages/additionalInfo/additionalInfoMH.jsp"></jsp:include>
					</c:when>
					<c:when test="${lineCd eq 'MN'}">
						<jsp:include page="/pages/marketing/quote/subPages/additionalInfo/additionalInfoMN.jsp"></jsp:include>
					</c:when>
				</c:choose>			
			
			<%-- nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles --%>
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
					<label>Item Deductible</label> 
					<span class="refreshers" style="margin-top: 0;"> 
						<label id="itemDeductibleInfoLbl" name="gro">Show</label>
					</span>
				</div>
			</div> 		
			<div id="itemDeductibleInformationMotherDiv" name="itemDeductibleInformationMotherDiv" style="display: none;">
				<jsp:include page="/pages/marketing/quote/subPages/deductible/itemQuoteDeductiblesInformation.jsp"></jsp:include>
			</div>
			<%-- nieko end --%>
			
			<div id="outerDiv" name="outerDiv">	
				<div id="innerDiv" name="innerDiv">
			   		<label>Peril Information</label>
			   		<span class="refreshers" style="margin-top: 0;">
						<label id='perilInfoAccordionLbl' name="gro" >Show</label>
			   		</span>
				</div>
			</div>
			<div id="perilInformationMotherDiv" name="perilInformationMotherDiv" style="display: none;">
				<jsp:include page="/pages/marketing/quote/subPages/peril/perilInformation.jsp"></jsp:include>
			</div>
			
			<%-- nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles 
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
					<label>Deductible Information</label> 
					<span class="refreshers" style="margin-top: 0;"> 
						<label id="deductibleInfoLbl" name="gro">Show</label>
					</span>
				</div>
			</div>
			<div id="deductibleInformationMotherDiv" name="deductibleInformationMotherDiv" style="display: none;">
				<jsp:include page="/pages/marketing/quote/subPages/deductible/deductibleInformation.jsp"></jsp:include>
			</div>	
			--%>
			
			<%-- nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles --%>
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
					<label>Peril Deductible</label> 
					<span class="refreshers" style="margin-top: 0;"> 
						<label id="perilItemDeductibleInfoLbl" name="gro">Show</label>
					</span>
				</div>
			</div> 		
			<div id="perilItemDeductibleInformationMotherDiv" name="perilItemDeductibleInformationMotherDiv" style="display: none;">
				<jsp:include page="/pages/marketing/quote/subPages/deductible/perilItemQuoteDeductiblesInformation.jsp"></jsp:include>
			</div>
			<%-- nieko end --%>
			
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
					<label>Mortgagee Information</label> <span class="refreshers"
						style="margin-top: 0;"> <label id="showMortgagee" name="gro"
						style="margin-left: 5px">Show</label>
					</span>
				</div>
			</div>
			<div id="mortgageeInformationMotherDiv"  name="mortgageeInformationMotherDiv" style="display: none;">	
					<jsp:include page="/pages/marketing/quote/subPages/mortgagee/mortgagee.jsp"></jsp:include>
			</div>
					
		</div>	
	
		<input id="lineCdHidden" name="lineCdHidden" type="hidden">
		<input id="quoteId" name="quoteId" type="hidden">
		<input id="itemNoHid" name="itemNoHid" type="hidden">
		<input id="vesAirQuoteId" name="vesAirQuoteId" type="hidden">
	</form>
	</div>
	<div class="buttonsDiv">
		<input type="button" class="button" id="btnViewInvoice" name="btnViewInvoice" value="Invoice" style="width: 75px;" tabindex="801"/>
		<input type="button" class="button" id="btnAttachMedia" name="btnAttachMedia" value="Attach Media" tabindex="802"/>
		<input type="button" class="button" id="btnEditQuotation" name="btnEditQuotation" value="Edit Basic Quotation Info" tabindex="803"/>
		<input type="button" class="button" id="btnSaveQuotation" name="btnSaveQuotation" value="Save" tabindex="804"/>
	</div>
</div>
<script type="text/javascript">
	objGIPIQuote = JSON.parse('${gipiQuoteObj}');
	objQuoteGlobal.lineCd = '${lineCd}';
	$("lineCdHidden").value = '${lineCd}';
	$("vesAirQuoteId").value = '${vesAirQuoteId}';
	objQuoteGlobal.hasPendingAdditional = false;
	objQuoteGlobal.selected = false;
	var toCarrierInfo = false;
	objQuote.addtlInfo = 'N'; //robert 9.28.2012
	var exitPage = "";
	
	$("btnViewInvoice").observe("click", function(){
		if(objQuote.selectedItemInfoRow != ""){
			if(objQuote.objPeril.length > 0){
				if(changeTag == 0){
					showInvoiceOverlay();
				}else{
					showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
				}
			}else{
				showMessageBox("Item has no perils.", "I");
			}
		}else{
			showMessageBox("Please select an item.", "I");
		}
	});
	
	$("btnAttachMedia").observe("click", function(){
		if(objQuote.selectedItemInfoRow != ""){
			if(objQuote.objPeril.length > 0){
				if(changeTag == 0){
					writeFilesToServer();
				}else{
					showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
				}
			}else{
				showMessageBox("Item has no perils.", "I");
			}
		}else{
			showMessageBox("Please select an item.", "I");
		}
	});
	
	function showInvoiceOverlay(){
		invoiceOverlay = Overlay.show(contextPath+"/GIPIQuoteInvoiceController", {
			urlContent: true,
			draggable: true,
			urlParameters: {
				action     : "showInvoiceOverlay",
				quoteId    : objGIPIQuote.quoteId,
				currencyCd : objQuote.selectedItemInfoRow.currencyCd
			},
		    title: "Invoice",
		    height: 535,
		    width: 755
		});
	}
	
	function getLastItemNo(){
		var rows =(objQuote.itemInfo).filter(function(o){ return nvl(o.recordStatus, 0) != -1;}); // modified by: Nica 06.13.2012
		var lastItemNo = "";
		for ( var i = 0; i < rows.length; i++) {
			if ((parseInt(rows[i].itemNo) > lastItemNo)) {
				lastItemNo = parseInt(rows[i].itemNo);
			}
		}
		return lastItemNo;
	}
	
	function saveAllQuotationInformation(){		
		if(checkPendingRecordChanges()){
			if(objQuote.itemInfo.filter(function(obj){return obj.recordStatus != -1;}).length > 0){ //marco - 08.12.2014 - added condition
				var peril = objQuote.objPeril.length - getDeletedJSONObjects(objQuote.objPeril).length;
				if(peril==0 && objQuoteGlobal.selected){
					showMessageBox("Item no " +removeLeadingZero($F("txtItemNo"))+" has no peril specified, please complete the neccessary information.", "E");
					return false;
				}else if(peril==0 && objQuoteGlobal.generatedQuoteNo == getLastItemNo()){
					showMessageBox("Item no " +getLastItemNo()+" has no peril specified, please complete the neccessary information.", "E");
					return false;
				}else if(peril==0 && objQuoteGlobal.generatedQuoteNo == 1){ 
					showMessageBox("Item no 1 has no peril specified, please complete the neccessary information.", "E");
					return false;
				}else if(/*'${requireMcCompany}' == "Y" &&*/ objQuoteGlobal.lineCd == "MC" /*&& $F("txtDspCarCompanyCd") == ""*/){
					var mcArray = (objQuote.itemInfo).filter(function(o){ return nvl(o.recordStatus, 0) != -1 && nvl(o.gipiQuoteItemMC.dspCarCompanyCd, "") == "";});
					if(mcArray.length > 0){ // added by: Nica 06.13.2012 - modified condition for checking existence of car company cd
						for(var i=0; i<mcArray.length; i++){
							var itemNo = removeLeadingZero(mcArray[i].itemNo);
							customShowMessageBox("Car company is required. Press Show button in Additional Information Block to enter car company for Item No. "+itemNo+ ".", "E", "txtDspCarCompanyCd");
							return false;
						}
					} 
				}else if(objQuoteGlobal.lineCd == "AV"){
					var avArray = (objQuote.itemInfo).filter(function(o){ return nvl(o.recordStatus, 0) != -1 && nvl(o.gipiQuoteAVItem.vesselCd, "") == "";});
					if(avArray.length > 0){
						for(var i=0; i<avArray.length; i++){
							var itemNo = removeLeadingZero(avArray[i].itemNo);
							customShowMessageBox("Aircraft name is required. Press Show button in Additional Information Block to enter aircraft name for Item No. "+itemNo+ ".", "E", "txtVesselName");
							return false;
						}
					}
				}
			}
			
			var objParameters = new Object();
			
			objParameters.setItemRows= getAddedAndModifiedJSONObjects(objQuote.itemInfo);
			objParameters.delItemRows = getDeletedJSONObjects(objQuote.itemInfo);
			objParameters.newItemRows = getAddedJSONObjects(objQuote.itemInfo);
			// for peril info
			objParameters.setPerilRows = getAddedAndModifiedJSONObjects(objQuote.objPeril);
			objParameters.delPerilRows = getDeletedJSONObjects(objQuote.objPeril);
	
			// for motgagee info
			objParameters.setMortgageeRows = getAddedAndModifiedJSONObjects(objQuote.objMortgagee);
			objParameters.delMortgageeRows = getDeletedJSONObjects(objQuote.objMortgagee);
	
			//for default warranties
			objParameters.setWarrantyRows = objQuote.objWarranty;
			// for deductible info
			objParameters.setDeductibleRows = getAddedAndModifiedJSONObjects(objQuote.objDeductibleInfo); 
			objParameters.delDeductibleRows = getDeletedJSONObjects(objQuote.objDeductibleInfo);		
			
			//variable for additional Information robert 9.28.2012
			objParameters.addtlInfo = objQuote.addtlInfo;
			
			//item deductible - nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
			objParameters.setItemDeductibleRows = getAddedAndModifiedJSONObjects(tbgItemQuotationDeductible.geniisysRows); 
			objParameters.delItemDeductibleRows = getDeletedJSONObjects(tbgItemQuotationDeductible.geniisysRows);	
			
			//peril deductible - nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
			objParameters.setPerilDeductibleRows = getAddedAndModifiedJSONObjects(tbgPerilItemQuotationDeductible.geniisysRows); 
			objParameters.delPerilDeductibleRows = getDeletedJSONObjects(tbgPerilItemQuotationDeductible.geniisysRows);
			
			new Ajax.Request(contextPath+"/GIPIQuoteItemController?action=saveAllQuotationInformation",{
				method: "POST",
				parameters:{
					parameters : JSON.stringify(objParameters),
					lineCd:			getLineCd(objGIPIQuote.lineCd),//getLineCdMarketing() Gzelle 05222015 SR4112
					delPolicyLevel : (objQuote.delPolicyLevel == null ? "N" : objQuote.delPolicyLevel), //nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
					quoteId : objGIPIQuote.quoteId //nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function(){
					showNotice("Saving , please wait...");
				},
				onComplete: function(response){
					hideNotice("");
					if(checkErrorOnResponse(response)) {
						if (response.responseText == "SUCCESS"){
							changeTag = 0;
							if($F("lineCdHidden") == "MN" && $F("vesAirQuoteId") == "" && toCarrierInfo){
								showWaitingMessageBox("Carrier Information should be entered first.", "I", function(){
									toCarrierInfo = false;
									showQuotationCarrierInfoPage();
								});
							}else{
								//showWaitingMessageBox(objCommonMessage.SUCCESS, "S", showQuotationInformation);
								//updateObjPerilInfo();
								showWaitingMessageBox(objCommonMessage.SUCCESS, "S", function(){									
									if(exitPage != "")
										exitPage();
									else
										showQuotationInformation();
								});
							}
						}else{ //added by steven 1/11/2012
							showMessageBox(response.responseText, imgMessage.ERROR);
						}
					}else{
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		}
	}
	
	function updateObjPerilInfo(){
		for(var i = 0; i < objQuote.objPeril.length; i++){
			if(objQuote.objPeril[i].recordStatus = -1){
				delete objQuote.objPeril[i];
			}
			objQuote.objPeril[i].recordStatus == null;
		}
	}

	function saveDeductibleInfo(){
		var objDeductibleInfoParams = new Object();
		objDeductibleInfoParams.setRows = getAddedAndModifiedJSONObjects(objQuote.objDeductibleInfo);
		objDeductibleInfoParams.delRows = getDeletedJSONObjects(objQuote.objDeductibleInfo);
		new Ajax.Request(contextPath+"/GIPIQuoteDeductiblesController?action=saveDeductibleInfo",{
			method: "POST",
			parameters: {
				parameters : JSON.stringify(objDeductibleInfoParams)
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
				showNotice("Saving Deductible Information, please wait...");
			},
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					if(response.responseText == "SUCCESS"){
						showMessageBox(objCommonMessage.SUCCESS, "S");
					}
				}else{
					showMessageBox(response.responseText, "E");
				}
			}
		});
	}

	function toggleInfos(show) {
		/* if (show) {
			$$("div.childInformation").each(function(a) {
				a.setStyle('display : inherit;');
			});
		} else {
			$$("div.childInformation").each(function(a) {
				a.setStyle('display : none;');
			});
		}
		if (objGIPIQuote.lineCd == "SU" || objGIPIQuote.lineCd == "TE") {
			disableSubpage("additionalInfoAccordionLbl");
		} */
	}
	
	function updateObjDeductibleInfo(){
		for(var i = 0;i<objQuote.objDeductibleInfo.length; i++){
			if(objQuote.objDeductibleInfo[i].recordStatus = -1){
				delete objQuote.objDeductibleInfo[i];
			}
			objQuote.objDeductibleInfo[i].recordStatus == null;
		}
	}
	
	function checksIfQuoteItemHasPerils(quoteId, itemNo){
		var isPerilExisting = false;
		for(var i=0; i<objQuote.objPeril.length; i++){
			if(objQuote.objPeril[i].quoteId == quoteId &&
					objQuote.objPeril[i].itemNo == itemNo &&
					objQuote.objPeril[i].recordStatus != -1){
					isPerilExisting = true;
					break;
			}
		}
		return isPerilExisting;
	}

	observeSaveForm("btnSaveQuotation", function(){
		toCarrierInfo = false;
		saveAllQuotationInformation();
	});
	initializeChangeTagBehavior(saveAllQuotationInformation);

	function checkBasicPerilIfExisting(quoteId, itemNo){
		var isBasicPerilExisting = false;
		
		for(var i=0; i<objQuote.objPeril.length; i++){
			if(objQuote.objPeril[i].quoteId == quoteId &&
					objQuote.objPeril[i].itemNo == itemNo &&
					objQuote.objPeril[i].recordStatus != -1 && 
					objQuote.objPeril[i].perilType == "B"){
					isBasicPerilExisting = true;
					break;
			}
		}
		
		return isBasicPerilExisting;
	}
	
	function checkIfAllQuotationItemsHasPerils(){
		for(var i=0; i< objQuote.objPeril.length; i++){
			var quoteId = objQuote.objPeril[i].quoteId;
			var itemNo = objQuote.objPeril[i].itemNo;
			
			if(objQuote.objPeril[i].recordStatus != -1){
				if(!checksIfQuoteItemHasPerils(quoteId, itemNo)){
					showMessageBox("Item no "+itemNo+" has no peril specified, please complete the neccessary information.", imgMessage.ERROR);
					return false;
				}else if(!checkBasicPerilIfExisting(quoteId, itemNo)){
					showMessageBox("Item no "+itemNo+" has no basic peril specified. Basic peril is required.", imgMessage.ERROR);
					return false;
				}
			}
		}
		return true;
	}
	
	/* $("additionalInfoAccordionLbl").observe("click", function(){		
		if($F("lineCdHidden") == "MH" || $F("lineCdHidden") == "MN"){
			if($F("vesAirQuoteId") == ""){
				showWaitingMessageBox("Carrier Information should be entered first.", "I", showQuotationCarrierInfoPage);
			}
		}
	}); */
	
	if($F("lineCdHidden") == "MN" && $F("vesAirQuoteId") == ""){
		$("additionalInfoAccordionLbl").stopObserving();
		$("additionalInfoAccordionLbl").observe("click", function(){
			toCarrierInfo = true;
			saveAllQuotationInformation();
		});
	}
	
	function showDeductibleInfoTG(show){
		try{	
			var quoteId = show ? objGIPIQuote.quoteId : 0;
			var itemNo = show ? objQuote.selectedItemInfoRow.itemNo : 0;
			var perilCd = show ? objQuote.selectedPerilInfoRow.perilCd : 0;
			var lineCd = show ? objGIPIQuote.lineCd : "";
			var sublineCd = show ? objGIPIQuote.sublineCd : "";
			deductibleInfoGrid.url = contextPath+"/GIPIQuoteDeductiblesController?action=getDeductibleInfoTG&quoteId="+ quoteId
									+"&itemNo="+ itemNo
									+"&perilCd="+ perilCd
									+"&lineCd="+ lineCd
									+"&sublineCd="+ sublineCd;
			deductibleInfoGrid._refreshList();
			enableSearch("deductibleInfoLOV");
		}catch(e){
			showErrorMessage("showDeductibleInfoTG",e);
		}
	}
	
	//nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
	function showItemDeductibleInfo(show){
		try{
			var quoteId = show ? objGIPIQuote.quoteId : 0;
			var itemNo = show ? objQuote.selectedItemInfoRow.itemNo : 0;
			
			tbgItemQuotationDeductible.url = contextPath + "/GIPIQuotationDeductiblesController?action=refreshItemQuoteDeductibleTable&quoteId=" + quoteId + "&itemNo=" + itemNo;
			tbgItemQuotationDeductible._refreshList();
			enableSearch("hrefDeductible2");
		}catch(e){
			showErrorMessage("showItemDeductibleInfo",e);
		}
	}
	
	//nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
	function showPerilItemDeductibleInfo(show){
		try{
			var quoteId = show ? objGIPIQuote.quoteId : 0;
			var itemNo = show ? objQuote.selectedItemInfoRow.itemNo : 0;
			var perilCd = show ? objQuote.selectedPerilInfoRow.perilCd : 0;
			
			tbgPerilItemQuotationDeductible.url = contextPath + "/GIPIQuotationDeductiblesController?action=refreshPerilItemQuoteDeductibleTable&quoteId=" + quoteId 
															  + "&itemNo=" 	+ itemNo 
															  + "&perilCd=" + perilCd;
			tbgPerilItemQuotationDeductible._refreshList();
			enableSearch("hrefDeductible3");
		}catch(e){
			showErrorMessage("showPerilItemDeductibleInfo",e);
		}
	}
	
	function requireMcCompany(){
		if('${requireMcCompany}' == "Y" && objQuoteGlobal.lineCd == "MC"){
			$("txtDspCarCompanyCd").addClassName("required");
			$("txtDspCarCompanyCd").up("div",0).addClassName("required");
		}
	}
	
	function checkUpdateDedText(){
		new Ajax.Request(contextPath+"/GIPIQuoteDeductiblesController?action=checkDeductibleText",{
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response){
				if(response.responseText == "Y"){
					$("txtDeductibleText").readOnly = false;			
				}else{
					$("txtDeductibleText").readOnly = true;
				}
			}
		});
	}
	
	$("btnEditQuotation").observe("click", function(){
		editQuotation(contextPath+"/GIPIQuotationController?action=editQuotation&quoteId="+objGIPIQuote.quoteId+"&ajax=1");
	});
	
	function saveAttachments(){
		try{
			new Ajax.Request(contextPath + "/GIPIQuotePicturesController", {
				method : "POST",
				parameters : {action : "saveQuotationAttachments",
							  quoteId : objGIPIQuote.quoteId,
							  setAttachRows : prepareJsonAsParameter(setAttachRows),
							  delAttachRows : prepareJsonAsParameter(delAttachRows)},
				onComplete : function(response){
					if(checkErrorOnResponse(response)){
						showWaitingMessageBox("Attachment finished.", imgMessage.INFO, showQuotationInformation);
					}
				}
			});
		}catch(e){
			showErrorMessage("saveAttachments",e);
		}
	}
	
	function writeFilesToServer(){
		try{
			new Ajax.Request(contextPath+"/GIPIQuotePicturesController", {
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
						};
						showQuotationAttachmentList();
						/* Added by MarkS 02/15/2017 SR5918 */
						if(response.responseText.include("Missing some files.")){
							showMessageBox("Some Attach files are missing or had been deleted.", imgMessage.WARNING);
						}
						/* end SR23838 */
						
					}
				}
			});
		}catch(e){
			showErrorMessage("writeFilesToServer",e);
		}
	}
	
	function showQuotationAttachmentList(){
		/* try{
			overlayAttachmentList = Overlay.show(contextPath+"/GIPIQuotePicturesController", {
				urlContent: true,
				urlParameters: {action : "getQuotationAttachmentList",						
								files : prepareJsonAsParameter(objGIPIQuote.attachedMedia),
								quoteId: objGIPIQuote.quoteId, // SR-21674 JET NOV-25-2016
								itemNo: removeLeadingZero($F("txtItemNo")), // SR-21674 JET NOV-25-2016
								ajax : "1"},
			    title: "Attach/View Pictures or Videos",
			    height: 350,
			    width: 600,
			    draggable: true
			});
		}catch(e){
			showErrorMessage("showWorkflowAttachmentList", e);
		} */
		
		// SR-5931 JET FEB-9-2017
		openAttachMediaOverlay("quotation");
	}
	
	if(objQuoteGlobal.lineCd == "SU"){ // andrew - 09.19.2012 - SR # 10526
		disableSubpage("additionalInfoAccordionLbl");
	}
	
	objQuoteGlobal.toggleInfos = toggleInfos;
	objQuoteGlobal.showDeductibleInfoTG = showDeductibleInfoTG;
	objQuoteGlobal.showItemDeductibleInfo = showItemDeductibleInfo; //nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
	objQuoteGlobal.showPerilItemDeductibleInfo = showPerilItemDeductibleInfo; //nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
	objQuoteGlobal.saveAllQuotationInformation = saveAllQuotationInformation;
	
	requireMcCompany();
	checkUpdateDedText();
	addStyleToInputs();
	initializeAll();
	initializeChangeAttribute();
	initializeAllMoneyFields();
	setModuleId("GIIMM002");
	
	$("gimmExit").stopObserving("click");
	$("gimmExit").observe("click", function(){		
		if(changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						exitPage = createQuotationFromLineListing;
						saveAllQuotationInformation();
					}, 
					function(){
						changeTag = 0;
						changeTagFunc = "";
						createQuotationFromLineListing();							
					}, 
					"");
				
		}else{
			createQuotationFromLineListing();			
		}
	});
	
	//Apollo Cruz 10.16.2014 - used in item and peril info
	function toggleButtonsForBonds(caller) {
		try {
			if(objQuoteGlobal.lineCd != "SU") return;
			
			var rows = caller == "item" ? itemInfoGrid.geniisysRows : perilTableGrid.geniisysRows;
			var btn = caller == "item" ? $("btnAddItem") : $("btnAddPeril");
			var count = 0;
			
			for(var i = 0; i < rows.length; i++){
				if(rows[i].recordStatus != -1)
					count++;
			}
	
			if(count >= 1 && btn.value == "Add")
				disableButton(btn.id);
			else
				enableButton(btn.id);
		} catch (e) {
			showErrorMessage("toggleButtonsForBonds", e);
		}
	}
	
	this.toggleButtonsForBonds = toggleButtonsForBonds;
	
</script>