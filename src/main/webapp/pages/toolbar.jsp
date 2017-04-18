<div id="toolbarDiv" name="toolbarDiv">	
	<div class="toolButton">
		<span style="background: url(${pageContext.request.contextPath}/images/toolbar/save.png) left center no-repeat;" id="btnToolbarSave">Save</span>
		<span style="display: none; background: url(${pageContext.request.contextPath}/images/toolbar/saveDisabled.png) left center no-repeat;" id="btnToolbarSaveDisabled">Save</span>
	</div>
	<div class="toolbarsep" id="btnToolbarSaveSep">&#160;</div>	
	<div class="toolButton">
		<span style="background: url(${pageContext.request.contextPath}/images/toolbar/enterQuery.png) left center no-repeat;" id="btnToolbarEnterQuery">Enter Query</span>
		<span style="display: none; background: url(${pageContext.request.contextPath}/images/toolbar/enterQueryDisabled.png) left center no-repeat;" id="btnToolbarEnterQueryDisabled">Enter Query</span>
	</div>
	<div class="toolbarsep" id="btnToolbarEnterQuerySep">&#160;</div>
	<div class="toolButton">
		<span style="background: url(${pageContext.request.contextPath}/images/toolbar/executeQuery.png) left center no-repeat;" id="btnToolbarExecuteQuery">Execute Query</span>
		<span style="display: none; background: url(${pageContext.request.contextPath}/images/toolbar/executeQueryDisabled.png) left center no-repeat;" id="btnToolbarExecuteQueryDisabled">Execute Query</span>
	</div>
	<div class="toolButton" style="float: right;">
		<span style="background: url(${pageContext.request.contextPath}/images/toolbar/exit.png) left center no-repeat;" id="btnToolbarExit">Exit</span>
		<span style="display: none; background: url(${pageContext.request.contextPath}/images/toolbar/exitDisabled.png) left center no-repeat;" id="btnToolbarExitDisabled">Exit</span>
	</div>
	<div style="float: right;" class="toolbarsep" id="btnToolbarPrintSep">&#160;</div>		
	<div class="toolButton" style="float: right;">
		<span style="background: url(${pageContext.request.contextPath}/images/toolbar/print.png) left center no-repeat;" id="btnToolbarPrint">Print</span>
		<span style="display: none; background: url(${pageContext.request.contextPath}/images/toolbar/printDisabled.png) left center no-repeat;" id="btnToolbarPrintDisabled">Print</span>
	</div>
 </div>
 <script>
 	// toolbar buttons will be hidden by default, buttons should be shown depending on the modules need
 	hideToolbarButton("btnToolbarSave");
 </script>