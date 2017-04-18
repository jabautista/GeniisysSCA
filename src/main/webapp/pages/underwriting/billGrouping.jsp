<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="billGroupingMainDiv" style="padding-bottom: 10px;">
	<form id="billGroupingForm" name="billGroupingForm">
		<div id="message" style="display:none;">${message}</div>
		<div id="hidItems">
			<input type="hidden" value="${parId}" name="parId">
			<input type="hidden" value="${lineCd}" name="lineCd">
			<input type="hidden" value="${issCd}" name="issCd">
			<input type="hidden" value="" id="saveSw" name="saveSw">
		</div>
		<c:if test="${isPack ne 'Y'}">
			<jsp:include page="/pages/underwriting/subPages/parInformation.jsp"></jsp:include>
		</c:if>
		
		<div id="outerDiv" style="width: 100%; margin-bottom: 1px;">
			<div id="innerDiv" >
		   		<label>Group Items Per Bill</label>
		   		<span class="refreshers" style="margin-top: 0;">
		   			<label name="gro" style="margin-left: 5px;">Hide</label>	   		
		   		</span>
		   	</div>
		</div>
		<div id="billGroupingDiv" class="sectionDiv" style="margin-bottom: 10px;">
			<div class="tableHeader" style="padding-right: 0; float: none; margin-top: 10px; margin-left: 10px; margin-right: 10px;">
				<label style="width: 120px; text-align: right;">Group Item</label>
				<label style="width: 100px; text-align: center;">Item No.</label>
				<label style="width: 140px; text-align: left;">Item Title</label>
				<label style="width: 100px; text-align: right;">Sum Insured</label>
				<label style="width: 110px; text-align: right;">Premium</label>
				<label style="width: 90px; text-align: right;">Currency</label>
				<label style="width: 120px; text-align: right;">Currency Rate</label>
				<label style="width: 100px; text-align: right;">Package Line</label>
			</div>
			
			<div id="groupItemsPerBillTable">	
				<c:forEach var="item" items="${items}">
					<div id="itemBillGrouping" name="itemBillGrouping" class="tableRow" style="padding-left: 15px; margin: 0 10px;">
						<div style="width: 20px; float: left;"><input style="width: 20px;" type="checkbox" id="checkGroup${item.itemNo}" name="checkItemGroup"></input></div>
						<label style="width: 80px; text-align: center;">
							<c:if test="${empty item.itemGrp}">1</c:if>
							${fn:escapeXml(item.itemGrp)}
						</label>
						<label style="width: 100px; text-align: center;">${fn:escapeXml(item.itemNo)}</label>
						<label name="textItem" style="width: 120px; margin-left: 10px;">${fn:escapeXml(item.itemTitle)}</label>
						<label style="width: 100px; text-align: right; margin-left: 15px;"><fmt:formatNumber value='${fn:escapeXml(item.tsiAmt)}' pattern='##,###,###,###,###.##' minFractionDigits="2"></fmt:formatNumber></label>
						<label style="width: 100px; text-align: right; margin-left: 10px;"><fmt:formatNumber value='${fn:escapeXml(item.premAmt)}' pattern='##,###,###,###.##' minFractionDigits="2"></fmt:formatNumber></label>
						<label name="textItem2" style="width: 90px; margin-left: 30px;">${fn:escapeXml(item.currencyDesc)}</label>
						<label name="textRate" style="width: 90px; text-align: right;"><fmt:formatNumber value='${fn:escapeXml(item.currencyRt)}' pattern='###.####' minFractionDigits="4"></fmt:formatNumber></label>
						<label name="textItem2" style="width: 90px; text-align: center;">${fn:escapeXml(item.packLineCd)} - ${fn:escapeXml(item.packSublineCd)}</label>
					</div>
				</c:forEach>
			</div>
			
			<div style="text-align: center; padding: 20px 0;">
				<input type="button" class="disabledButton" id="btnNewGroup" value="New Group"/>
				<input type="button" class="disabledButton" id="btnJoinGroup" value="Join Group"/>
			</div>
		</div>
	</form>
	
	<div class="buttonsDiv" style="text-align: center; margin-bottom: 20px;">
		<input type="button" class="button" id="btnCancel" value="Cancel">
		<input type="button" class="button" id="btnSave" value="Save"/>
	</div>
	
</div>

<script type="text/javascript">
	var pageActions = {none: 0, save : 1, reload : 2, cancel : 3};
	var pAction = pageActions.none;
	
	setModuleId("GIPIS025");
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	$("btnNewGroup").disable();
	$("btnJoinGroup").disable();
	checkIfToResizeTable2("groupItemsPerBillTable", "itemBillGrouping");

	$$("label[name='textItem']").each(function (label)    {
        if ((label.innerHTML).length > 15)    {
            label.update((label.innerHTML).truncate(15, "..."));
        }
    });
    $$("label[name='textItem2']").each(function (label)    {
        if ((label.innerHTML).length > 10)    {
            label.update((label.innerHTML).truncate(10, "..."));
        }
    });
    $$("label[name='textRate']").each(function (label)    {
        if ((label.innerHTML).length > 10)    {
            label.update((label.innerHTML).truncate(10, "..."));
        }
    });
    

    $$("div[name='itemBillGrouping']").each(function(billGroup){

        billGroup.observe("mouseover", function(){
            billGroup.addClassName("lightblue");
        });

        billGroup.observe("mouseout", function(){
            billGroup.removeClassName("lightblue");
        });
    });

    $$("input[name='checkItemGroup']").each(function(checkbox){
	    checkbox.observe("click", function(){
	    	if(!checkIfSingleCurrencyExists()){
				showMessageBox("Only items of the same currency and currency rate"
								+ " may be grouped together as one.");
				checkbox.checked = false;
			}else if(!checkIfSinglePackLineCdExists()){
				showMessageBox("Only items of the same currency , currency rate, "
								+ "package line and package subline may be grouped together as one.");
				checkbox.checked = false;
			}
	    	setButtonsBehavior();
	    });
    });

    $("btnNewGroup").observe("click", function(){
		if (postedBinderExists()){ //added edgar 01/08/2015 : for checking posted binders
			showWaitingMessageBox('Cannot group items for PAR with posted binder(s).', 'I', function(){
				// in case functions are to be added.
			});	
			return false;
		}	
    	regroupItems();
    	setButtonsBehavior();
    	setExistingGroupsLOV();
    });

    $("btnJoinGroup").observe("click", function(){
		if (postedBinderExists()){ //added edgar 01/08/2015 : for checking posted binders
			showWaitingMessageBox('Cannot regroup items for PAR with posted binder(s).', 'I', function(){
				// in case functions are to be added.
			});	
			return false;
		}	
        showOverlayContent2(contextPath+"/GIPIParBillGroupingController?action=joinGroup&parId="+ (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId")), // andrew - 10.05.2011 - added condition for pack par
             "Existing Groups" ,350, showExistingGroupsOverlay);
        setExistingGroupsLOV();
    	
    });

    $("btnSave").observe("click", function(){
    	//if(changeTag == 0){
    	if ($F("saveSw") == ""){
			showMessageBox("No changes to save.");
		} else {
			pAction = pageActions.save;
			saveBillGrouping();
		}
    	
    });

    $("btnCancel").observe("click", function(){
    	//if(changeTag == 1) {
    	if ($F("saveSw") == 1){
			//showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No","Cancel", saveAndCancel, showParListing,"");
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No","Cancel", saveAndCancel, doParExit,"");
    	} else {
			showParListing();
		}
    });

/*     $("reloadForm").observe("click", function() {
		//if(changeTag == 1) {
		if ($F("saveSw") == 1){	
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No","Cancel", saveAndReload, showBillGroupingPage, "");
		} else {
			showBillGroupingPage();
		}
	}); */
	// andrew - 10.05.2011
	observeReloadForm("reloadForm", showBillGroupingPage);
	
    function saveAndCancel(){
		pAction = pageActions.cancel;
		saveBillGrouping();
	}

    function saveAndReload(){
		pAction = pageActions.reload;
		saveBillGrouping();
	}

    function setButtonsBehavior(){
    	if(!checkIfNoItemsCheck()){
    	   	$("btnNewGroup").enable();
        	$("btnNewGroup").setAttribute("class", "button");
        	$("btnJoinGroup").enable();
        	$("btnJoinGroup").setAttribute("class", "button");
		}else{
			$("btnNewGroup").disable();
        	$("btnNewGroup").setAttribute("class", "disabledButton");
        	$("btnJoinGroup").disable();
        	$("btnJoinGroup").setAttribute("class", "disabledButton");
		}
    };

    function getLastItemGrpNo(){
    	var lastItemGrpNo = 0;

    	$$("div[name='itemBillGrouping']").each(function(itemGroup){
    		if(parseInt(itemGroup.down("label", 0).innerHTML) > lastItemGrpNo){
        		lastItemGrpNo = parseInt(itemGroup.down("label", 0).innerHTML); 
    		}	
        });
        return lastItemGrpNo;
    };

    function checkIfNoItemsCheck(){
        var isItemsCheckedZero = true;

        $$("input[name='checkItemGroup']").each(function(checkbox){
    	    if(checkbox.checked){
        	    isItemsCheckedZero = false;
        	    return false;
    	    }
        });
        return isItemsCheckedZero;
    }

    function getNextItemGrpNo(){
        var lastItemGrpNo = getLastItemGrpNo();
        var nextItemGrpNo =(parseInt(lastItemGrpNo))+1;
        
        return (nextItemGrpNo);
    }

    function countItemsPerItemGroup(itemGroupNo){
    	var ctr = 0;
    	
    	$$("div[name='itemBillGrouping']").each(function(itemGroup){
			if(itemGroupNo == parseInt(itemGroup.down("label", 0).innerHTML)){
				ctr++;
			}        	
        });
        return ctr;
    };

    function checkIfSingleItemGroupExists(){
        var itemGroupNo = 0;
        var prevItemGroup = 0;
        var isSingleItemExists = true;

        $$("div[name='itemBillGrouping']").each(function(itemGroup){
        	var itemNo= itemGroup.down("label", 1).innerHTML;

    		if($("checkGroup"+itemNo).checked){
    			isSingleItemExists = true;
        		prevItemGroup = itemGroupNo;
    			itemGroupNo = itemGroup.down("label", 0).innerHTML;

    			if(prevItemGroup != itemGroupNo && prevItemGroup != 0){
        			isSingleItemExists = false;
        			return false;
    			}else if(prevItemGroup == 0){
    				isSingleItemExists = false;
    			}
    		}else{
        		if(itemGroupNo == itemGroup.down("label", 0).innerHTML){
        			isSingleItemExists = false;
        			return false;
        		}
    		}
        });
       
        return isSingleItemExists;
    };

    function checkIfSingleCurrencyExists(){
        var previousCurrencyCd ="";
        var recentCurrencyCd ="";
        var previousCurrencyRate ="";
        var recentCurrencyRate ="";
        var isSingleCurrencyExists = true;

        $$("div[name='itemBillGrouping']").each(function(itemGroup){
        	var itemNo= itemGroup.down("label", 1).innerHTML;

    		if($("checkGroup"+itemNo).checked){
    			previousCurrencyCd = recentCurrencyCd;
    			recentCurrencyCd = itemGroup.down("label", 5).innerHTML;
    			previousCurrencyRate = recentCurrencyRate;
    			recentCurrencyRate = itemGroup.down("label", 6).innerHTML;

    			if(previousCurrencyCd != recentCurrencyCd && previousCurrencyCd != ""){
    				isSingleCurrencyExists = false;
    				return false;
    			}else if(previousCurrencyRate != recentCurrencyRate && previousCurrencyRate != ""){
    				isSingleCurrencyExists = false;
    				return false;
    			}
    		}
        });
        return isSingleCurrencyExists;
    }

    function checkIfSinglePackLineCdExists(){
    	var previousPackLineCd ="";
        var recentPackLineCd ="";
        var isSinglePackLineCdExists = true;

        $$("div[name='itemBillGrouping']").each(function(itemGroup){
        	var itemNo= itemGroup.down("label", 1).innerHTML;

    		if($("checkGroup"+itemNo).checked){
    			previousPackLineCd = recentPackLineCd;
            	recentPackLineCd = itemGroup.down("label", 7).innerHTML;

            	if(previousPackLineCd != recentPackLineCd && previousPackLineCd != ""){
            		isSinglePackLineCdExists = false;
            		return false;
            	}
       		}
        });
        
        return isSinglePackLineCdExists;
    }

    function checkIfToRegroupItems(){
    	var regroupSw = true;
    	
    	$$("div[name='itemBillGrouping']").each(function(itemGroup){
        	var itemNo= itemGroup.down("label", 1).innerHTML;
        	var lastItemGrpNo = parseInt(getLastItemGrpNo());
			if($("checkGroup"+itemNo).checked){
	   			if(countItemsPerItemGroup(itemGroup.down("label", 0).innerHTML) == 1){ 
	       			regroupSw = false;
	       			return false;
	   			}
			}
    		
        });

    	if(checkIfSingleItemGroupExists()){
			regroupSw = false;
			return false;
		}else if(!checkIfSingleCurrencyExists()){
			regroupSw = false;
			return false;
		}else if(!checkIfSinglePackLineCdExists()){
			regroupSw = false;
			return false;
		}
		
        return regroupSw;
    };

    function regroupItems(){
		var nextItemGroupNo = getNextItemGrpNo();
        
    	if(checkIfToRegroupItems()){
    		$$("div[name='itemBillGrouping']").each(function(itemGroup){
            	var itemNo= itemGroup.down("label", 1).innerHTML;

        		if($("checkGroup"+itemNo).checked){
            		var updateGroupItem ='<input type="hidden" name="itemNo" value="'+itemNo+'">' +
            							 '<input type="hidden" name="itemGrp" value="'+nextItemGroupNo+'">';
            		$("hidItems").insert({bottom: updateGroupItem});
            		itemGroup.down("label", 0).update(nextItemGroupNo);
            		$("checkGroup"+itemNo).checked = false;
        		}
            });
            $("saveSw").value = 1;
    	}else{
    		showMessageBox("Regrouping cannot be done.", imgMessage.INFO);
    		$$("div[name='itemBillGrouping']").each(function(itemGroup){
            	var itemNo= itemGroup.down("label", 1).innerHTML;

        		if($("checkGroup"+itemNo).checked){
            		$("checkGroup"+itemNo).checked = false;
        		}
            });
		}
    };

    function setExistingGroupsLOV(){
        if($("existingItemGroups") != null){
			var opt="";
			var lastItemGrpNo = parseInt(getLastItemGrpNo());
			$("existingItemGroups").update("");

			for(var i=1; i<=lastItemGrpNo ; i++){
				opt += '<option value="'+i+'">'+i+'</option>';
			}
	
			$("existingItemGroups").insert({bottom : opt});
			$("existingItemGroups").selectedIndex = 0;
        }
	}

    function saveBillGrouping(){
        new Ajax.Request(contextPath + "/GIPIParBillGroupingController?action=saveBillGrouping",{
			method: "POST",
			parameters: Form.serialize("billGroupingForm"),
			asynchronous: false,
			evalScripts: true,
			onCreate:
				function(){
					//showNotice("Saving Group Items Per Bill, please wait...");
        		},
			onComplete:
				function(response){
    				hideNotice("");
    				//pAction = pageActions.none;
    				setButtonsBehavior();	
    				if(checkErrorOnResponse(response)){
        				//changeTag = 0;
        				$("saveSw").value = "";
        				if(response.responseText == "SUCCESS"){
        					if(pAction == pageActions.reload){
            					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, showBillGroupingPage);
            				}else if (pAction == pageActions.cancel){
            					//showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, showParListing);
            					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, doParExit);
            				}else{
            					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, showBillGroupingPage);
            				}
        				}
    				}
        		}
        });
    };
    
	function postedBinderExists(){ //edgar 01/08/2015 : Check if PAR has posted binder/s.
		try{
			var exists = false;
			new Ajax.Request(contextPath+"/GIPIPARListController",{
				parameters:{
					action: "checkForPostedBinder",
					parId : $F("globalParId"),
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if (checkErrorOnResponse(response)){
						if(response.responseText == 'Y'){
							exists = true;
						}
					}
				}
			});
			return exists;
		} catch(e){
			showErrorMessage("postedBinderExists", e);
		}
	}
	
    if(objUWGlobal.packParId != null){ // andrew - 10.05.2011 - sets the save function as method member of the object, which can be called even outside this jsp
    	objCurrPackPar.saveFunction = saveBillGrouping; 
    }
    
    if(objUWParList.parType == "E"){   	//SR3411 lmbeltran 9/9/15
		if(objGIPIWPolbas.polFlag == 4 || objUWGlobal.cancelTag == "Y"){
			$$("input[type=checkbox]").each(function(chk){
				chk.disable();
			});
			
			$$("input.button").each(function(btn){
				if(btn.id !="btnSubmitText" && btn.id !="btnCancelText" &&
				   btn.id !="btnGroupedItems" && btn.id !="btnPersonalAddtlInfo" && 
				   btn.id !="btnCancelGrp" && btn.id !="btnMsgBoxOk"){
					if (btn.getAttribute("toEnable") != "true"){ 
						disableButton(btn);
					}
				}
			});
			
			showMessageBox("This is a cancellation type of endorsement, update/s of any details will not be allowed.", imgMessage.WARNING);
		} 
	} //end SR3411
    
    
    //initializeChangeTagBehavior(saveBillGrouping);
</script>