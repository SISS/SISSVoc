<%@ page import="java.util.*" %>
<%!
    Date theDate = new Date();
    Date getDate()
    {
        System.out.println( "In getDate() method" );
        return theDate;
    }
	 
	 String repoName = "Geologic Timescale";
	 String serviceName = "api/isc2009";
	 String repoNote = "*Single document view contains >10000 RDF triples";

	 String conceptSchemes = serviceName+"/conceptscheme";
	 String conceptCollections = serviceName+"/collection";
	 String concepts = serviceName+"/concept";
	 String conceptResource = serviceName+"/resource";

	 //String sparqlEndPoint = "http://services-test.auscope.org/openrdf-workbench/repositories/ischart/summary";
    String sparqlEndPoint = "http://services-test.auscope.org/openrdf-sesame/repositories/ischart";

	 String sissvoc3wiki = "https://www.seegrid.csiro.au/wiki/Siss/VocabularyService3";
	 String isc2010 = "http://def.seegrid.csiro.au/ontology/geotime/isc-2009.ttl";
	 String isc2009 = "http://def.seegrid.csiro.au/ontology/geotime/isc-2009.ttl";
	 String isc2008 = "http://def.seegrid.csiro.au/ontology/geotime/isc-2008.ttl";
	 String isc2006 = "http://def.seegrid.csiro.au/ontology/geotime/isc-2006.ttl";
	 String isc2005 = "http://def.seegrid.csiro.au/ontology/geotime/isc-2005.ttl";
	 String isc2004 = "http://def.seegrid.csiro.au/ontology/geotime/isc-2004.ttl";


%>

<html>
	
	<head>
	</head>
	<title>API configuration</title>

	<link rel="stylesheet" href="sissvoc.css" type="text/css" media="all" />  

	<script type="text/javascript">

	function toggle(id) {
   	var div = document.getElementById( id );
	   div.className = (div.className == "show" ? "hide" : "show");
	}

	function go_to(url) {
		window.location = url;
	}

	function navigateTo(conceptSchemeUrl, conceptCollectionUrl, conceptUrl, conceptResourceUrl) {
		applyOptions(conceptSchemeUrl, conceptCollectionUrl, conceptUrl, conceptResourceUrl);
		window.location = getAllResultOptions(conceptUrl);
	}

	function applyOptions(conceptSchemeUrl, conceptCollectionUrl, conceptUrl, conceptResourceUrl) {
		document.getElementById('conceptScheme_url').href = updateAllConceptUrls(conceptSchemeUrl);
		document.getElementById('conceptCollection_url').href = updateAllConceptUrls(conceptCollectionUrl);
		document.getElementById('concept_url').href = updateAllConceptUrls(conceptUrl);
		document.getElementById('conceptLabel_url').href = getAllResultOptions(conceptUrl);
	}

	
	//updates url for "All Concept Scehemes", "All Concept Collections" and "All Concepts"
	function updateAllConceptUrls(url) {
		var lang = getLang();
		var format = getFormat();
		var metadata = getMetadata();
		var pageSize = getPageSize();
		if(metadata !='') metadata = '&'+metadata;
		return url + format +"?"+lang+"&"+pageSize+metadata;
	}

	//constructs getResourceByUri url
	function updateUrl(serviceName) {		
		var resource = getResource();
		var lang = getLang();
		var format = getFormat();
		var relationship = getRelationship();
		var metadata = getMetadata();

		if(metadata !='') metadata = '&'+metadata;
		if(relationship == "") relationship = "resource";
		else relationship = "concept/"+relationship;

		var url = serviceName + "/"+ relationship + format +"?uri="+resource +"&"+lang+metadata;

		window.location = url
	}

	//constructs getConceptByLabel url
	function getAllResultOptions(url) {
		var label = getLabel();
		var relationship = getRelationship();
		var lang = getLang();
		var format = getFormat();
		var pageSize = getPageSize();
		var metadata = getMetadata();

		if(metadata !='') metadata = '&'+metadata;

		var prefix = "";
		var index = url.indexOf("?");

		if(index == -1) //check for other fitlers
			prefix = "?";
		else prefix = "&";

		if(relationship != "") {
			if(index == -1)  // no filters added yet just append relationship
				url = url + "/" + relationship;
			else {
				url = url.substring(0,index) + "/" + relationship + url.substring(index,url.length)
				index = url.indexOf("?"); // have to find the index after appending text to url.
			}
		}

		var resourceIndex = url.indexOf("uri");
		var resource = "";

		if(resourceIndex != -1) {
			resource = url.substring(resourceIndex,url.length);
			pageSize = ""; //_pageSize can only be used with a list endpoint.
			label = "?"; //label not used for resource
		}
		else {
			pageSize = "&" + pageSize;
			label = "?"+label;
		}

		if(index!=-1) url = url.substring(0,index) + format + label +"&"+ resource + prefix+lang+pageSize+metadata;	
		else url = url+format+label+"&"+lang+pageSize+metadata

		return url;
	}

	function getResource() {
		return document.forms['landingPage'].elements['resource'].value;
	}

	function getLabel() {
		var labelMatch = getLabelMatch();
		
		if(labelMatch == "includes")	labelMatch = "labelcontains=";
		else if(labelMatch == "matches") labelMatch = "anylabel=";
		
		var label = document.forms['landingPage'].elements['label'].value;
		if(label) label = labelMatch+label;
		else label = "";
		return label;
	}

	function getLabelMatch() {
		var form = document.forms['landingPage'];
		var labelMatch = "";

		for (var i = 0; i < form.labelMatch.length; i++) {
			if (form.labelMatch[i].checked) {
   	   	break;
	      }
		}
		if(i<form.labelMatch.length) 
			labelMatch = form.labelMatch[i].value;
		
		return labelMatch;
	}

	function getRelationship() {
		var form = document.forms['landingPage'];
		var relationship = "";

		for (var i = 0; i < form.relationship.length; i++) {
			if (form.relationship[i].checked) {
   	   	break;
	      }
		}
		if(i<form.relationship.length) 
			relationship = form.relationship[i].value;
		
		return relationship;
	}

	function getLang() {
		var form = document.forms['landingPage'].elements['language'];
		return "_lang="+form.options[form.selectedIndex].value;
	}

	function getFormat() {
		var form = document.forms['landingPage'].elements['format'];
		return "."+form.options[form.selectedIndex].value;
	}

	function getPageSize() {
		var form = document.forms['landingPage'].elements['pagesize'];
		return "_pageSize="+form.options[form.selectedIndex].value;
	}

	function getMetadata() {
		var form = document.forms['landingPage'];
		var metadata = "";
		for (var i = 0; i < form.metadata.length; i++) {
			if (form.metadata[i].checked) {
				break;
			}
		}
		if(i<form.metadata.length) {
			var metadataValue = form.metadata[i].value;
			if(metadataValue == 'yes') 
				metadata = "_metadata=all";			
		}
		return metadata;		
	}

	</script>


	<body>
	<form id="landingPage">
		<h2><%= repoName %></h2>
		This service provides a <a href="<%= sissvoc3wiki %>">SISSVoc</a> interface to an OWL representation of the <a href="<%= isc2009 %>">2009</a> edition of the International Stratigraphic Chart</a>
		<br>
		<a><%= repoNote %></a>
		<br>
		<br>
			<legend>Queries</legend>
				<input type="button" id="conceptScheme_url" class="styled-buttons" value="All Concept Schemes" onclick="go_to('<%=conceptSchemes%>')";>&nbsp
				<input type="button" id="conceptCollection_url" class="styled-buttons" value="All Concept Collections" onclick="go_to('<%=conceptCollections%>')";>&nbsp
				<input type="button" id="concept_url" class="styled-buttons" value="All Concepts" onclick="go_to('<%=concepts%>')";>&nbsp
				<br>
				<br>
				<a id="conceptLabel_url">Concept whose label</a><input type="radio" name="labelMatch" value="matches" checked="true" />matches <input type="radio" name="labelMatch" value="includes" />includes the text: <input type="text" size="60" name="label" value="Cambrian"/> <input type="button" class="styled-buttons2" value="Go" onclick="navigateTo('<%=conceptSchemes%>','<%=conceptCollections%>','<%=concepts%>','<%=conceptResource%>');"/>
				<br>
				<br>
				<a id="conceptResource_url">Description of</a>: <input type="text" size="92" name="resource" value="http://resource.geosciml.org/classifier/ics/ischart/Furongian"/> <input type="button" class="styled-buttons2" value="Go" onclick="updateUrl('<%=serviceName%>');"/>	
				<br>
				<br>
				<div STYLE="background-color:#ECF3FF; padding:5px"> 
				<legend>Result Options</legend>

						<a>Concepts: </a>						
						<input type="radio" name="relationship" value="narrowerTransitive" />narrowerTransitive
						<input type="radio" name="relationship" value="narrower" />narrower
						<input type="radio" name="relationship" value="" checked="true" />exact
						<input type="radio" name="relationship" value="broader" />broader
						<input type="radio" name="relationship" value="broaderTransitive" />broaderTransitive
						<br>
						<br>
						<div class="styled-select">
						<a>Report result in</a>
						<select name="language">
							<option value="bg">bg</option>
							<option value="cs">cs</option>
							<option value="da">da</option>
							<option value="de">de</option>
							<option value="en" selected="selected">en</option>
							<option value="es">es</option>
							<option value="et">et</option>
							<option value="fi">fi</option>
							<option value="fr">fr</option>
							<option value="hu">hu</option>
							<option value="it">it</option>
							<option value="ja">ja</option>
							<option value="lt">lt</option>
							<option value="nl">nl</option>
							<option value="no">no</option>
							<option value="pl">pl</option>
							<option value="pt">pt</option>
							<option value="sk">sk</option>
							<option value="sl">sl</option>
							<option value="sv">sv</option>
							<option value="zh">zh</option>
						</select>
						<a>Report result in</a>
						<select name="format">
							<option value="html" selected="selected">HTML</option> 
							<option value="rdf" >RDF/XML</option>
							<option value="ttl" >Turtle</option>
							<option value="json" >JSON</option>
							<option value="xml" >XML</option>
						</select>
						<a>Page size</a>
						<select name="pagesize">
							<option value="10" selected="selected">10</option>
							<option value="20">20</option>
							<option value="50">50</option>
						</select>
						</div>
						<br>
						<table border="0" cellspacing="0" cellpadding="0" class="normal">
							<tr>
								<td>Full Metadata <input type="radio" name="metadata" value="no" checked="true" /> No	<input type="radio" name="metadata" value="yes"/> Yes</td>
								<td width="500" align="right"><input type="button" class="styled-buttons2" value="Apply" onclick="applyOptions('<%=conceptSchemes%>','<%=conceptCollections%>','<%=concepts%>','<%=conceptResource%>');"/></td>
							</tr>
						</table>
				</div>
		<br>
		<br>
		<br>
		<br>
		<a>SPARQL end-point: <%= sparqlEndPoint %></a>
		<br>
		<br>
		Other versions of this vocabulary: <a href="<%= isc2010 %>">2010</a> <a href="<%= isc2008 %>">2008</a> <a href="<%= isc2006 %>">2006</a> <a href="<%= isc2005 %>">2005</a> <a href="<%= isc2004 %>">2004</a>
		<br>
		<br>
		<a>Ontologies used by this vocabulary are:</a><br>
		<a href="http://def.seegrid.csiro.au/ontology/geotime/geologictimescale">http://def.seegrid.csiro.au/ontology/geotime/geologictimescale</a><br>
		<a href="http://def.seegrid.csiro.au/ontology/geotime/gtrs">http://def.seegrid.csiro.au/ontology/geotime/gtrs</a><br>
		<a href="http://def.seegrid.csiro.au/ontology/isotc211/sampling">http://def.seegrid.csiro.au/ontology/isotc211/sampling</a><br>
		<a href="http://def.seegrid.csiro.au/ontology/isotc211/temporal">http://def.seegrid.csiro.au/ontology/isotc211/temporal</a><br>
		<a href="http://def.seegrid.csiro.au/ontology/isotc211/spatial">http://def.seegrid.csiro.au/ontology/isotc211/spatial</a><br>
		<a href="http://def.seegrid.csiro.au/ontology/isotc211/feature">http://def.seegrid.csiro.au/ontology/isotc211/feature</a><br>
		<a href="http://def.seegrid.csiro.au/ontology/isotc211/base">http://def.seegrid.csiro.au/ontology/isotc211/base</a><br>
		<a href="http://www.opengis.net/def/geosparql">http://www.opengis.net/def/geosparql/</a><br>
		<a href="http://xmlns.com/foaf/0.1/">http://xmlns.com/foaf/0.1/</a><br>
		<a href="http://www.w3.org/2004/02/skos/core">http://www.w3.org/2004/02/skos/core</a><br>
		<a href="http://www.w3.org/2002/07/owl">http://www.w3.org/2002/07/owl</a><br>
	
	</body>



</html>
