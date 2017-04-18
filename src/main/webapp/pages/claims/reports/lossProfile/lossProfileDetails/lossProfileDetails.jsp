<div id="lossProfileDetailsMainDiv" class="sectionDiv" style="margin-bottom: 50px; height: 695px;">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="btnExitLossProfileDetails">Exit</a></li>
			</ul>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>View Loss Profile Detail</label>
			<span class="refreshers" style="margin-top: 0;">
		 		<!-- <label id="reloadForm1" name="reloadForm1">Reload Form</label> --> 
			</span>
		</div>
	</div>
	<div id="parametersDiv" style="margin: 20px 0 20px 0; float: left;">
		<table>
			<tr>
				<td class="rightAligned" width="100px">Line</td>
				<td>
					<input type="text" id="txtDtlLineCd" style="width: 70px; height: 13px;" readonly="readonly"/>
					<input type="text" id="txtDtlLineName" style="width: 220px; height: 13px;" readonly="readonly"/>
				</td>
				<td class="rightAligned" width="100px">Subline</td>
				<td>
					<input type="text" id="txtDtlSublineCd" style="width: 70px; height: 13px;" readonly="readonly"/>
					<input type="text" id="txtDtlSublineName" style="width: 220px; height: 13px;" readonly="readonly"/>
				</td>
			</tr>
		</table>
	</div>
	<div id="tabComponentsDiv1" class="tabComponents1" style="align:center;width:100%">
		<ul>
			<li class="tab1 selectedTab1" style="width:19.1%"><a id="lossProfileSummaryTab">Loss Profile Summary</a></li>
			<li class="tab1" style="width:17.1%"><a id="lossProfileDetailTab">Loss Profile Details</a></li>
		</ul>			
	</div>
	<div id="tabBorderBottom" class="tabBorderBottom1"></div>
	<div id="tabPageContents1" name="tabPageContents1" style="width: 100%; float: left;">	
		<div id="lossProfileDetailDiv" name="lossProfileDetailDiv" style="width: 100%; float: left;"></div>
	</div>
	<div id="hiddenDiv">
		<input type="hidden" id="hidVarNew" value="Y" />
	</div>
</div>
<script type="text/JavaScript">
try{
	initializeTabs();
	
	$("lossProfileSummaryTab").observe("click", function(){
		new Ajax.Request(contextPath + "/GICLLossProfileController", {
		    parameters : {
		    	action : "showLossProfileSummary",
		    	globalChoice : $("rdoByLine").checked ? "L" : "X",
		    	globalTreaty : $("chkAllTreaties").checked ? "Y" : "N",
		    	globalLineCd : nvl($F("txtLineCd"), $F("txtDtlLineCd")),
		    	globalSublineCd : nvl($F("txtSublineCd"), $F("txtDtlSublineCd"))
		    },
		    onCreate: showNotice("Loading Loss Profile Summary...  Please wait..."),
			onComplete : function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					$("lossProfileDetailDiv").update(response.responseText);
				}
			} 
		});
		
		$("lossProfileDetailsMainDiv").setStyle("height: 553px;");
	});
	
	$("lossProfileDetailTab").observe("click", function(){
		new Ajax.Request(contextPath + "/GICLLossProfileController", {
		    parameters : {
		    	action : "showLossProfileDetails",
		    	lineCd : nvl($F("txtLineCd"), $F("txtDtlLineCd")),
		    	moduleId: 'GICLS212',
		    	sublineCd : nvl($F("txtSublineCd"), $F("txtDtlSublineCd"))
		    },
		    onCreate: showNotice("Loading Loss Profile Details...  Please wait..."),
			onComplete : function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					$("lossProfileDetailDiv").update(response.responseText);
				}
			} 
		});
		
		$("lossProfileDetailsMainDiv").setStyle("height: 695px;");
	});
	
	$("btnExitLossProfileDetails").observe("click", function(){
		$("lossProfileMainDiv").show();
		$("lossProfileDetailsDiv").hide();
		setModuleId("GICLS211");
	});
	/* observeReloadForm("reloadForm1", showGICLS211); */
}catch(e){
	showErrorMessage("lossProfileDetails page", e);
}
</script>
