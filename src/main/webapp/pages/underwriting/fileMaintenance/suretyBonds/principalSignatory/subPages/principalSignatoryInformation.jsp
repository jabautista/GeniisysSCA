<!-- move to principalSignatory.jsp
move by steven 
date 05.26.2014 -->

<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
	<div id="innerDiv" name="innerDiv">
		<label>Principal Signatory Information</label>
		<span class="refreshers" style="margin-top: 0;">
			<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
			<label id="signatoryReloadForm" name="signatoryReloadForm">Reload Form</label>
		</span>
	</div>
</div>
<div class="sectionDiv" id="parInfoMainDiv" name="parInfoMainDiv" changeTagAttr="true">
	<div id="parInfo" name="parInfoTop" style="margin: 10px;">
		<table align="center" border="0">
			<tr>
				<td class="rightAligned" >Principal</td>
				<td colspan="7"  class="leftAligned">
					<div style="border: 1px solid gray; width: 675px; height: 21px; float: left; margin-right: 3px;"  class="required" >
						<input id="principalAssdNo" name="principalAssdNo" type="hidden" value="${assdNo}"/><!--27191  -->
			    		<input style="float: left; border: none; margin-top: 0px; width: 650px;" id="principalAssdName" name="principalAssdName" type="text" value=""  readonly="readonly" class="required" /> <!-- removed {assdName} from value - Halley 10.04.13 -->
			    		<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osao" name="osao" alt="Go" />
		    		</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Control Type</td>
				<td class="leftAligned">
		    		<select style="width: 150px;" id="selControlType" name="selControlType" tabindex="102" class="required">
					<option></option>
				</select>
				</td>
				<td class="rightAligned">Number</td>
				<td class="leftAligned">
					<input type="text" style="width: 100px;" id="principalResNo" name="principalResNo" maxlength="15"/>
				</td>
				<td class="rightAligned">Issued on</td>
				<td  class="leftAligned">
					<div id="doeDiv" name="doeDiv" style="float: left; border: solid 1px gray; height: 21px; margin-right: 3px;">
						<!--<input type="text" style="width: 100px;" id="principalResDate" name="principalResDate" class="required" readonly="readonly" border="none"/>
						-->
						<input style="float: left; border: none; margin-top: 0px; width: 85px;" id="principalResDate" name="principalResDate" type="text" value="${gipiQuote.inceptDate}" readonly="readonly"/>
						<img id="hrefPrincipalResDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('principalResDate'),this, null);" class="hover" alt="Issued On" />
					</div>	
				</td>
				<td class="rightAligned">
					<label id="issuedAtLbl" style="float: right;">Issued at</label>	
				</td>
				<td  class="leftAligned">
					<input type="text" style="width: 100px;" id="principalResPlace" name="principalResPlace" maxlength="100"/>
				</td>
			</tr>
		</table>
	</div>
</div>

<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
	<div id="innerDiv" name="innerDiv">
		<label>Principal Signatory</label>
		<span class="refreshers" style="margin-top: 0;">
			<label name="gro" style="margin-left: 5px;">Hide</label>
		</span>
	</div>
</div>
<div id="tableGridSectionDiv" class="sectionDiv" style="height: 370;">
	<div id="principalSignatoryTableGridDiv" style= "padding: 10px;">
		
	</div>
</div>


<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
	<div id="innerDiv" name="innerDiv">
		<label>Co-Signatory Information</label>
		<span class="refreshers" style="margin-top: 0;">
			<label name="gro" style="margin-left: 5px;">Hide</label>
		</span>
	</div>
</div>
<div id="tableGridSectionDivRes" class="sectionDiv" style="height: 370;">
	<div id="cosignorResTableGridDiv" style= "padding: 10px;">
		
	</div>
</div>
<div>
	<input type="hidden" id="hidControlTypeCd" />
</div>
<script>
	var principalSignatoryTableGrid;
	var cosignorResTableGrid;
	defaultCtcNo = "${DEFAULT_CTC_NO}";
	controlTypeList = JSON.parse(unescapeHTML2('${controlTypeList}')); //unescapeHTML2 added by jeffdojello 04.30.2013
	var ctList = document.getElementById("selControlType");
	for (var i = ctList.length-1; i >= 0; i--){
		ctList.remove(i);
	}
	controlTypeList.each(function(item){
		addOption("selControlType", item.controlTypeCd, item.controlTypeDesc);
	});
	
	$("principalResNo").observe("blur", function(){
		if(checkSignatoryCTCNo($F("principalResNo"),'','N')){
			$("principalResNo").value = '';
		}else if(checkCosignorCTCNo($F("principalResNo"),'', 'N')){
			$("principalResNo").value = '';
		}/* else if(validateCTCNo($F("principalResNo"))){
			$("principalResNo").value = '';
			showMessageBox("CTC no. already exist in the database, it must be unique.", imgMessage.INFO);
		} //commented out by jeffdojello 05.07.2013 as per SR 12502 Note 31382*/ 
	});

	$("principalResDate").observe("blur", function(){
		var iDateArray = $F("principalResDate").split("-");
		var iDate = new Date();
		var date = parseInt(iDateArray[1], 10);
		var month = parseInt(iDateArray[0], 10);
		var year = parseInt(iDateArray[2], 10);
		iDate.setFullYear(year, month-1, date);
		iDate.format('mm-dd-yyyy');
    	var dateToday = new Date();
        if(iDate > dateToday){
			showMessageBox("Cannot record future issuance of IDENTIFICATION.", imgMessage.INFO); //CTC to IDENTIFICATION - 05.14.2013 - SR #12502
			$("principalResDate").value = '';
        }
	});
	
	
	/***Added by jeffdojello 12.26.2013***/
	//Please refer to http://cpi-sr.com.ph/genqa/view.php?id=1501
	$("selControlType").observe("change", function (){
		toggleRequiredFields();
	});
	
	function toggleRequiredFields(){
		if ($("selControlType").options[$("selControlType").selectedIndex].text == "CTC"){
			$("principalResNo").addClassName("required");
			$("doeDiv").addClassName("required");
			$("principalResDate").addClassName("required");
			$("principalResPlace").addClassName("required");
		}else{
			$("principalResNo").removeClassName("required");
			$("doeDiv").removeClassName("required");
			$("principalResDate").removeClassName("required");
			$("principalResPlace").removeClassName("required");
		}
	}
	/******************* End *************************/
	
	
	/***COSIGNOR RES SCRIPTS***/
	function getCosignorRes(){
		try{
			new Ajax.Updater("cosignorResTableGridDiv", contextPath+"/GIISPrincipalSignatoryController",{
				method: "GET",
				evalScripts: true,
				asynchronous: false,
				parameters: {
					action: "getCosignorRes",
					assdNo: $F("principalAssdNo")
				},onComplete: function(response){
					//createCosignorResTableGrid(response.responseText);
				}
			});
		}catch(e){
			showErrorMessage("getCosignorRes",e);
		}
	}

	/****END OF COSIGNOR RES SCRIPTS****/

	/***pRINCIPAL SIGNATORY SCRIPTS***/
	function getPrincipalSignatory(){
		try{
			new Ajax.Updater("principalSignatoryTableGridDiv", contextPath+"/GIISPrincipalSignatoryController",{
				method: "GET",
				evalScripts: true,
				asynchronous: false,
				parameters: {
					action: "getPrincipalSignatory",
					assdNo: $F("principalAssdNo")
				},onComplete: function(response){
					//createPrincipalSignatoryTableGrid(response.responseText);
				}
			});
		}catch(e){
			showErrorMessage("getPrincipalSignatory",e);
		}
	}

	function getAssuredPrincipalResInfo(){
		try{
			new Ajax.Request(contextPath+"/GIISPrincipalSignatoryController",{
				method: "GET",
				evalScripts: true,
				asynchronous: false,
				parameters: {
					action: "getAssuredPrincipalResInfo",
					assdNo: $F("principalAssdNo")
				},onComplete: function(response){
					
					if(checkErrorOnResponse(response)){
						var res = response.responseText.evalJSON();
						$("principalResNo").value = nvl(unescapeHTML2(res.principalResNo),"");
						$("principalResDate").value = nvl(res.principalResDate,"");
						$("principalResPlace").value = nvl(unescapeHTML2(res.principalResPlace),""); //escape HTML chars JC AUII-SR-14986
						$("selControlType").value = nvl(res.controlTypeCd, defaultCtcNo);  //added by Halley 10.07.2013
						toggleRequiredFields(); //added by jeffdojello 12.26.2013
						getPrincipalSignatory();
						getCosignorRes(); 
					}
				}
			});
		}catch(e){
			showErrorMessage("getAssuredPrincipalResInfo",e);
		}
	}

	getAssuredPrincipalResInfo();
	
	/* $("osao").observe("click",function(){
		showGIISAssuredLOV("getGIISAssuredLOV", function(row){
			$("principalAssdNo").value = row.assdNo;
			$("principalAssdName").value = unescapeHTML2(row.assdName);//monmon
			getAssuredPrincipalResInfo();
		});
	}); */
	
	// bonok :: 10.25.2013 :: replaced lov
	function showGIISS022AssuredLOV(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getGIISS022AssuredLOV",
							page : 1},
			title: "List of Lines",
			width : 500,
			height : 370,
			columnModel : [ {
								id : "assdNo",
								title : "Assured No",
								width : '50px'
							}, {
								id : "assdName",
								title : "Assured Name",
								width : '415px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							} ],
				autoSelectOneRecord: true,
				onSelect: function(row) {
					$("principalAssdNo").value = row.assdNo;
					$("principalAssdName").value = unescapeHTML2(row.assdName);
					$("hidControlTypeCd").value = row.controlTypeCd;
					getAssuredPrincipalResInfo();
					setControlType();
				}
		  });
	}
		
	$("osao").observe("click", showGIISS022AssuredLOV);
	
	function setControlType(){
		for(var i = 0; i < controlTypeList.length; i++){
			if(controlTypeList[i].controlTypeCd == $F("hidControlTypeCd")){
				$("selControlType").selectedIndex = i;
			}	
		}
	}
	
	function addOption(id, value, text){
		var newOpts = document.createElement('option');
		var selectElement = document.getElementById(id);
		newOpts.text = text;
		newOpts.value = value;
		try{
			selectElement.add(newOpts, null);
		} catch(e){
			selectElement.add(newOpts);
		}
	}
	
</script>