<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma","no-cache");
%>

<div id="batchDistMainDiv" name="batchDistMainDiv" style="margin-top: 1px;">
	<div id="batchDistMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="batchDistExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="batchPolicyListingDiv" name="batchPolicyListingDiv">
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
		   		<label>Policy Listing</label>
		   		<span class="refreshers" style="margin-top: 0;">
		   			<label id="showBatchPolicyListing" name="gro" style="margin-left: 5px;">Hide</label>
		   			<label id="reloadForm" name="reloadForm">Reload Form</label>
		   		</span>
		   	</div>
		</div>
		<div id="policyListingDiv" name="policyListingDiv" class="sectionDiv">
			<jsp:include page="/pages/underwriting/distribution/batchDistribution/giuwPolDistPolbasicVListing.jsp"></jsp:include>
			<div class="buttonsDiv" align="center" style="margin-bottom: 10px;">
				<input type="button" id="btnDistribute" name="btnDistribute"  class="button hover"	style="width: 90px;"   value="Distribute" />
				<input type="button" id="btnParameter" 	name="btnParameter"   class="button hover"  style="width: 90px;"   value="Parameter" />
				<input type="button" id="btnCancel" 	name="btnCancel" 	  class="button hover"  style="width: 90px;"   value="Cancel" />
				<input type="button" id="btnSave" 		name="btnSave" 		  class="button hover"  style="width: 90px;"   value="Save" />
			</div>
		</div>
	</div>
</div>

<script>
	initializeAccordion();
	initializeAll();
	initializeAllMoneyFields();
	setModuleId("GIUWS015");
	setDocumentTitle("Batch Distribution");
	objUW.hidObjGIUWS015 = {};
	changeTag = 0;
	objGIUWS015.filterByParam = false;
	objGIUWS015.tempTaggedRecords = [];
	objGIUWS015.tempUntaggedRecords = [];

	disableButton("btnDistribute");
	
	$("btnDistribute").observe("click", function(){
		var batchId = nvl(objUW.hidObjGIUWS015.selectedGiuwPolDistPolbasicV.batchId, "");
		var lineCd =  nvl(objUW.hidObjGIUWS015.selectedGiuwPolDistPolbasicV.lineCd, "");
		giuwPolDistPolbasicVTableGrid.keys.releaseKeys();
		/*Modalbox.show(contextPath+"/GIUWDistBatchController?action=getGiuwDistBatch&batchId="+batchId+"&lineCd="+lineCd, 
				  {title: "Enter Distribution Share (%)", 
				  width: 750,
				  overlayClose: false});*/ // replaced by code below : shan 08.07.2014
		overlayBatchDistShare = Overlay.show(contextPath+"/GIUWDistBatchController",{
				urlContent: true,
				urlParameters: {
					action: "getGiuwDistBatch",
					batchId: batchId,
					lineCd: lineCd
				},
				title: "Enter Distribution Share (%)",
				height: 470,
				width: 600,
				draggable: true		
		});				  
	});

	$("btnParameter").observe("click", function(){
		giuwPolDistPolbasicVTableGrid.keys.releaseKeys();
		/*Modalbox.show(contextPath+"/GIUWPolDistPolbasicVController?action=showBatchDistParameterPage", 
				  {title: "Enter Parameters", 
				  width: 500,
				  overlayClose: false});*/	// replaced by codes below : shan 08.29.2014
		overlayBatchParameter = Overlay.show(contextPath+"/GIUWPolDistPolbasicVController",{
			urlContent: true,
			urlParameters: {
				action: "showBatchDistParameterPage"
			},
			title: "Enter Parameters",
			height: 270,
			width: 500,
			draggable: true		
		});			  
	});

	$("btnSave").observe("click", function(){
		if(changeTag == 0){
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
		}else{
			saveBatchDistribution();
		}
	});

	$("batchDistExit").observe("click", function(){
		checkChangeTagBeforeUWMain();
	});

	function filterTableGridByBatchId(batchId){
		giuwPolDistPolbasicVTableGrid.objFilter.batchId = batchId;
		var mtgId = giuwPolDistPolbasicVTableGrid._mtgId;
		var filterBy = $('mtgFilterBy'+mtgId);
		var filterText = $('mtgFilterText'+mtgId);
		$('mtgFilterText'+mtgId).clear();
		for (var property in giuwPolDistPolbasicVTableGrid.objFilter){
			for(var i=0; i<filterBy.options.length; i++){    					
				if(property == filterBy.options[i].value){
					filterText.value+=filterBy.options[i].text+"="+giuwPolDistPolbasicVTableGrid.objFilter[property]+";";
				}
			}
		}
		
		fireEvent($('mtgBtnAddFilter'+mtgId), "click");
		fireEvent($('mtgBtnOkFilter'+mtgId), "click");
	}

	function saveBatchDistribution(){
		var objArray = objGIUWS015.tempTaggedRecords; //giuwPolDistPolbasicVTableGrid.getModifiedRows();	// changed by shan : 09.01.2014
		objArray = objArray.filter(function(obj){ return obj.batchIdTag == true;});
		
		if(objArray.length > 0){
			objParameters = new Object();
			objParameters.setRows = prepareJsonAsParameter(objArray);
	
			new Ajax.Request(contextPath+"/GIUWDistBatchController", {
				method: "POST",
				asynchronous: false,
				parameters :{
					action: "saveBatchDistribution",
					parameters : JSON.stringify(objParameters)
				},
				onCreate: function(){
					showNotice("Saving Batch Distribution");
				},
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						var text = response.responseText;
						var arr = text.split(resultMessageDelimiter);
						if(arr[0] == "SUCCESS"){
							var newBatchId = arr[1];
							showMessageBox(objCommonMessage.SUCCESS, "S");
							filterTableGridByBatchId(newBatchId);
							objGIUWS015.tempTaggedRecords = [];
							objGIUWS015.tempUntaggedRecords = [];
							changeTag = 0;
						}else{
							showMessageBox(arr[0], "E");
						}
					}else{
						showMessageBox(response.responseText, "E");
					}
				}
			});
		}else{
			changeTag = 0;
		}
	}

	observeReloadForm("reloadForm", showBatchDistribution);
	observeCancelForm("btnCancel", saveBatchDistribution, checkChangeTagBeforeUWMain);

	initializeChangeTagBehavior(saveBatchDistribution);
		 
</script>