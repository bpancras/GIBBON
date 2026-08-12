function plan = buildfile
% Create a plan from local functions
plan = buildplan(localfunctions);

end


function createHelpTocTask(~)
% Create help table of content

%% Get location of the html files, buildtool runs from repo root
repoRoot=pwd;
helpPath=fullfile(repoRoot,'docs','html', '*.html');


fileGlob = matlab.buildtool.io.FileCollection.fromPaths(string(helpPath));
allHTMLFiles = fileGlob.paths;
DemoFiles = allHTMLFiles(allHTMLFiles.contains("DEMO")>0);
HelpFiles = allHTMLFiles(allHTMLFiles.contains("HELP")>0);
StartFile = allHTMLFiles(allHTMLFiles.contains("GIBBON_product_page")>0);

tocDom = matlab.io.xml.dom.Document('toc');
tocDocument = tocDom.getDocumentElement;
tocDocument.setAttribute('version','2.0');

gibbonToc = tocDom.createElement('tocitem');
[~,currentName, extension]=fileparts(StartFile(1));
gibbonToc.setAttribute("target", currentName + extension);
gibbonToc.appendChild(tocDom.createTextNode('The GIBBON Toolbox'));
tocDocument.appendChild(gibbonToc);


GettingStartedToc = tocDom.createElement('tocitem');
GettingStartedToc.setAttribute('target','GettingStarted.html');
GettingStartedToc.setAttribute('image','HelpIcon.GETTING_STARTED');
GettingStartedToc.appendChild(tocDom.createTextNode('Getting Started'));
gibbonToc.appendChild(GettingStartedToc);

functiolistToc = tocDom.createElement('tocitem');
functiolistToc.setAttribute('target','funclist.html');
functiolistToc.setAttribute('image','HelpIcon.FUNCTION');
functiolistToc.appendChild(tocDom.createTextNode('Functions'));
for q=HelpFiles
    [~,currentName, extension]=fileparts(q);
    helpItem = tocDom.createElement('tocitem');
    helpItem.setAttribute("target", currentName + extension);
    helpItem.appendChild(tocDom.createTextNode(currentName));
    functiolistToc.appendChild(helpItem);
end
gibbonToc.appendChild(functiolistToc);

examplesToc = tocDom.createElement('tocitem');
examplesToc.setAttribute('target','gibbonExamples.html');
examplesToc.setAttribute('image','HelpIcon.EXAMPLES');
examplesToc.appendChild(tocDom.createTextNode('DEMOS and Examples'));
for q=DemoFiles
    [~,currentName,extension]=fileparts(q);
    demoItem = tocDom.createElement('tocitem');
    demoItem.setAttribute("target", currentName + extension);
    demoItem.appendChild(tocDom.createTextNode(currentName));
    examplesToc.appendChild(demoItem);
end
gibbonToc.appendChild(examplesToc);

saveName=fullfile(repoRoot,'docs','html','helptoc1.xml');
writer = matlab.io.xml.dom.DOMWriter;
writer.Configuration.FormatPrettyPrint = true;
writer.writeToFile(tocDom,saveName);

end

function createSearchdbTask(~)
% Create searchdb
    repoRoot=pwd;
    HTMLPath=fullfile(repoRoot,'docs','html');
    builddocsearchdb(HTMLPath)
end
