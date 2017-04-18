/**
 * THIS FILE CONTAINS VARIABLES AND FUNCTIONS FOR UW PACKAGE PAR 
 */

var objGIPIWPackLineSubline = null;
var objGIPIWPackLineSublineCreatePack = null; //created a seperate obj so that the objGIPIWPackLineSubline wont conflict with the assigning of value in packParCreationLineSubline
var objGIPIWPackLineSublineTemp; // This object is for the createPackPar page. To temporarily store the line/subline before it is save with the par. -irwin
var hasLineSubline = 'N';
var objLineSubline; // holds the line/subline LOV object
var objCurrPackPar = null; // this will be used as object holder of the selected par in package
var objTempUWGlobal = null; // for pack line/subline coverages and pack endt basic info
var objGIRIPackWInPolbas; // for RI pack par 