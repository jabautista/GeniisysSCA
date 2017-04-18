function resetGIPIS901GlobalVar(){
	objGIPIS901.extractId = null;
	objGIPIS901.refItem = "FOLDER.STATISTICAL";
	objGIPIS901.refItem2 = "OTHERS.MOTOR_STAT";
	objGIPIS901.currMonth = getCurrentMonthWord();
	objGIPIS901.currYear = new Date().getFullYear();
	objGIPIS901.asOfSw = "N";
	objGIPIS901.rangeValue = 0;
	objGIPIS901.incEndt = "N";
	objGIPIS901.incExp = "Y";
	objGIPIS901.firePerilType = "B";
	objGIPIS901.chkboxStat = [];
	objGIPIS901.extractPrevParam = [];
	objGIPIS901.zone = null;
	objGIPIS901.printSw = " ";
	objGIPIS901.commitAccumDistShare = null;
	objGIPIS901.tableName = null;
	objGIPIS901.columnName = null;
	objGIPIS901.fireSelectedRow = null;
	objGIPIS901.commAccumSw = null;
}