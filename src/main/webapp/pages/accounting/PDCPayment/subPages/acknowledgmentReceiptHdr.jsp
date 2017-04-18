<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="spinLoadingDiv"></div>
<div class="sectionDiv">
	<div id="otherHeaderDtlsDiv" style="float: left; width: 100%; margin-top: 10px;" changeTagAttr="true">
		<div style="width: 100%; float: left;">
			<label style="margin-left: 70px; margin-top: 5px; float: left;">APDC No.</label>
			<input style="float: left; margin-left: 5px; width: 65px;" type="text" id="apdcNo1" name="apdcNo1" readonly="readonly" value="${docPrefSuf}" tabindex="101"/>
			<input style="float: left; margin-left: 5px; width: 119px;" type="text" id="apdcNoText" name="apdcNoText" readonly="readonly" tabindex="102"/>
			<%-- <div style="border: 1px solid gray; width: 126px; float: left; margin-left: 5px; height: 19.5px; margin-top: 1.7px;">
				<input style="float: left; height: 12px; margin-top: 1px; width: 80%; border: none;" type="text" id="apdcNoText" name="apdcNoText" readonly="readonly"/>
				<img style="float: left;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="apdcNoLOV" name="apdcNoLOV" alt="Go" />
			</div> --%>
			<label style="float: left; margin-top: 5px; margin-left: 113px;">Reference APDC No.</label>
			<input style="float: left; margin-left: 5px; width: 250px;" type="text" id="refApdcNo" name="refApdcNo" maxlength="15" tabindex="106"/>
		</div>
		<div style="width: 100%; float: left;">
			<label style="margin-left: 62px; margin-top: 5px; float: left;">APDC Date</label>
			<div style="float: left; margin-left: 5px; margin-top: 2px; width: 204px; height: 19px; margin-right:3px; border: 1px solid gray;" class="required">
		    	<input style="width: 179px; border: none; float: left; height: 11px;" id="apdcDate" name="apdcDate" type="text" value="" readonly="readonly" tabindex="103" class="required"/>
		    	<img name="accModalDate" id="apdcDateCal" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('apdcDate'),this, null);" alt="APDC Date" />
			</div>
			<label style="float: left; margin-top: 5px; margin-left: 192px;">Status</label>
			<input style="float: left; margin-left: 4px; width: 60px;" type="text" id="statusCd" name="statusCd" readonly="readonly" value="" tabindex="107"/>
			<input style="float: left; margin-left: 4px; width: 178px;" type="text" id="status" name="status" readonly="readonly" value="" tabindex="108"/>
		</div>
		<div style="width: 100%; float: left;">
			<label style="margin-left: 93px; margin-top: 5px; float: left;">Payor</label>
			<input style="float: left; margin-left: 4px; width: 692px;" type="text" id="hdrDtlsPayor" name="hdrDtlsPayor" maxlength="150" tabindex="104" class="required"/>
		</div>
		<div style="width: 100%; float: left;">
			<label style="margin-left: 80px; margin-top: 5px; float: left;">Address</label>
			<input style="float: left; margin-left: 4px; width: 692px;" type="text" id="txtApdcAddress1" name="txtAddress1" maxlength="50" tabindex="104"/>
		</div>
		<div style="width: 100%; float: left;">
			<input style="float: left; margin-left: 130px; width: 692px;" type="text" id="txtApdcAddress2" name="txtAddress2" maxlength="50" tabindex="105"/>
		</div>
		<div style="width: 100%; float: left;">
			<input style="float: left; margin-left: 130px; width: 692px;" type="text" id="txtApdcAddress3" name="txtAddress3" maxlength="50" tabindex="106"/>
		</div>
		<div style="width: 100%; float: left; margin-top: 2px;">
			<label style="margin-left: 66px; margin-top: 5px; float: left;">Particulars</label>
			<div id="hdrDtlsParticulars" name="hdrDtlsParticulars" style="float: left; margin-left: 5px; border: 1px solid gray;"/>
				<!-- marco - replaced with textarea to handle next line -->
				<!-- <input type="text" id="payorParticulars" name="payorParticulars" style="float: left; width: 671px; border: none;" maxlength="500" tabindex="107"/> -->
				<textarea id="payorParticulars" name="payorParticulars" style="width: 671px; border: none; height: 12px; float: left; resize: none;" maxlength="500"/></textarea>
				<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="EditParticulars" id="editParticularsText" />
			</div>
		</div>
	</div>	
	<div id="headerDtlsButtonsDiv" style="margin-bottom: 15px; margin-top: 15px; float: left; width: 100%;">
		<input type="button" id="btnPrintApdc" name="btnPrintApdc" class="button" value="Print APDC" style="width: 100px;" tabindex="108"/>
		<input type="button" id="btnCancelApdc" name="btnCancelApdc" class="button" value="Cancel APDC" style="width: 100px;" tabindex="109"/>
	</div>
</div>
<script type="text/javascript">
	objGIACApdcPayt = JSON.parse('${giacApdcPayt}'.replace(/\\/g, '\\\\'));
	
	$("editParticularsText").observe("click", function (){
		showOverlayEditor("payorParticulars", 500, $("payorParticulars").hasAttribute("readonly"), 
					function(){ // bonok :: 3.9.2016 :: UCPB SR 21683
						changeTag = 1; 
					});
	});

	$("btnCancelApdc").observe("click", function (){
		checkCancelAcknowledgmentReceipt();
	});

	function checkCancelAcknowledgmentReceipt(){
		if ($F("statusCd") == "C"){
			showMessageBox('This acknowledgment receipt is already cancelled.', imgMessage.INFO);
			return false;
		} else if (checkIfGeneratedOR(objGIACApdcPayt.apdcId)) {
			showMessageBox('Please cancel the existing O.R. first.', imgMessage.INFO);
			return false;
		} else {
			showConfirmBox("Cancel acknowledgment receipt", 'Please confirm cancellation of acknowledgment receipt. Continue?',
					"Yes", "No",
					cancelApdcPayt, "");
		}
	}

	function checkIfGeneratedOR(apdcId){
		var generatedOR = false;
		new Ajax.Request(contextPath+"/GIACAcknowledgmentReceiptsController?action=checkIfGeneratedOR&apdcId="+apdcId, {
			method: "POST",
			evalScripts: true,
			asynchronous: false,
			onComplete: function (response){
				if (checkErrorOnResponse(response)){
					if (response.responseText =='Y'){
						generatedOR = true;
					}
				}
			}
		});

		return generatedOR;
	}

	function cancelApdcPayt(){
		new Ajax.Request(contextPath + "/GIACAcknowledgmentReceiptsController", {
			method : "GET",
			parameters : {action : "cancelApdcPayt",
						  apdcId : objGIACApdcPayt.apdcId},
			onComplete : function(response){
				if(checkErrorOnResponse(response)){
					showAcknowledgementReceipt();
					showMessageBox('Acknowledgment Receipt cancelled.', imgMessage.INFO);
				}
			}
		});
	}
	
	function cancelAcknowledgmentReceipt(){
		showNotice("Cancelling acknowledgment receipt...");
		$("statusCd").value = "C";
		$("status").value = "Cancelled";
		for (var ctr = 0; ctr < postDatedChecksTableGrid.rows.length; ctr++){
			var isExists = false;
			postDatedChecksTableGrid.setValueAt('Cancelled', postDatedChecksTableGrid.getColumnIndex('checkStatus'), ctr, true);
			var modifiedRow = postDatedChecksTableGrid.getModifiedRows();
			for (var i = 0; i < modifiedRow.length; i++){
				var addedRow = postDatedChecksTableGrid.getRow(ctr);
				addedRow.checkStatus = "Cancelled";
				if (addedRow.divCtrId == modifiedRow[i].divCtrId){
					modifiedRow.splice(i, 1);
					isExists = true;
				} 
			}
			if (!isExists){
				postDatedChecksTableGrid.modifiedRows.push(postDatedChecksTableGrid.getRow(ctr));
			}
		};
		hideNotice("");
		disableButton("btnPrintApdc");
		showMessageBox('Acknowledgment Receipt cancelled.', imgMessage.INFO);
	}

	$("btnPrintApdc").observe("click", function (){
		if (changeTag == 1){
			showMessageBox('Please save your changes first before printing.', imgMessage.ERROR);
			return false;
		} else {
			overlayAPDCPrintDialog = Overlay.show(contextPath+"/GIACAcknowledgmentReceiptsController", {
				urlContent : true,
				urlParameters: {action : "showAPDCPrintDialog",
								apdcId:objGIACApdcPayt.apdcId,
								apdcNo:$F("apdcNoText"),
								branchCd:$F("globalBranchCd"),
								fundCd:$F("globalFundCd"),
								cicPrintTag: objGIACApdcPayt.cicPrintTag
								},
			    title: "Print APDC",
			    height: 215,
			    width: 380,
			    draggable: true
			});
			
			/* overlayGenericPrintDialog.onPrint = onPrintFunc;
			overlayGenericPrintDialog.onLoad  = nvl(onLoadFunc,null); */
			//printAR();			
		}
	});

/* 	function printAR(){
		Modalbox.show(contextPath+"/PrintAcknowledgmentReceiptController?action=showPrintAR&ajaxModal=1&apdcId="
				+objGIACApdcPayt.apdcId+"&apdcNo="+$F("apdcNoText")+"&branchCd="+$F("globalBranchCd")+"&fundCd="+$F("globalFundCd"),
				{title: "Print APDC",
				 width: 500});
	}
	 */
	// andrew - 10.06.2011
	function setApdcPaytForm(obj){
		try {
			$("apdcNo1").value = (obj == null ? "" : obj.apdcPref);
			$("apdcNoText").value = (obj == null ? "" : (obj.apdcNo == null || obj.apdcNo == ""? "" : formatNumberDigits(obj.apdcNo, 10))); 
			$("refApdcNo").value = (obj == null ? "" : obj.refApdcNo);
			$("apdcDate").value = (obj == null ? dateFormat(new Date(), "mm-dd-yyyy") : dateFormat(obj.apdcDate, "mm-dd-yyyy"));
			$("statusCd").value = (obj == null ? "" : obj.apdcFlag);
			$("status").value = (obj == null ? "" : obj.apdcFlagMeaning);
			$("hdrDtlsPayor").value = (obj == null ? "" : unescapeHTML2(nvl(obj.payor,""))); //added by steven 10/10/2012
			$("cashierCd").value = (obj == null ? "" : obj.cashierCd);
			$("payorParticulars").value = (obj == null ? "" : unescapeHTML2(nvl(obj.particulars,""))); //added by steven 10/10/2012
			$("txtApdcAddress1").value = (obj == null ? "" : unescapeHTML2(nvl(obj.address1,""))); //added by steven 10/10/2012
			$("txtApdcAddress2").value = (obj == null ? "" : unescapeHTML2(nvl(obj.address2,""))); //added by steven 10/10/2012
			$("txtApdcAddress3").value = (obj == null ? "" : unescapeHTML2(nvl(obj.address3,""))); //added by steven 10/10/2012
			
			/* if(obj == null) {
				$("payorParticulars").removeAttribute("readonly");
			} else { */
				//$("payorParticulars").setAttribute("readonly", "readonly"); // bonok :: 3.9.2016 :: UCPB SR 21683
			//}
		} catch (e){
			showErrorMessage("setApdcPaytForm", e);
		}
	}
	
	$("hdrDtlsPayor").observe("keyup", function() {
		$("hdrDtlsPayor").value = $("hdrDtlsPayor").value.toUpperCase();
	});
	
	if(objGIACApdcPayt != null){
		setApdcPaytForm(objGIACApdcPayt);
	} 
	
	if(objGIACApdcPayt != null && nvl(objGIACApdcPayt.payor, "") == ""){
		$("payorParticulars").removeAttribute("readonly");
	}
</script>