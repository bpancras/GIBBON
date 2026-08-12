function plan = buildfile
import matlab.buildtool.tasks.CodeIssuesTask
import matlab.buildtool.tasks.TestTask

% Create a plan with no tasks
plan = buildplan(localfunctions);

end


function createtocTask(~)
% Run unit tests

%% Get toolbox location
toolboxRoot=pwd;
helpPath=fullfile(toolboxRoot,'docs','html', '*.html');

%% FIND HTML FILES
fileGlob = matlab.buildtool.io.FileCollection.fromPaths(string(helpPath));
allFiles = fileGlob.paths;
DemoFiles = allFiles(find(contains(allFiles, "DEMO")));
HelpFiles = allFiles(find(contains(allFiles, "HELP")));
StartFile = allFiles(find(contains(allFiles, "GIBBON_product_page")));
% logicDemo=gcontains(allFiles,'DEMO_');
% 
% demoFiles=allFiles(logicDemo);
% numDemoFiles=numel(demoFiles);
% 
% logicHelp=gcontains(allFiles,'HELP_');
% 
% helpFiles=allFiles(logicHelp);
% numHelpFiles=numel(helpFiles);
% 
% logicStart=gcontains(allFiles,'GIBBON_product_page');
% 
% startFile=allFiles{logicStart};

%% BUILD helptoc.xml USING THE DOM API
import matlab.io.xml.dom.*

% Create the document with <toc version="2.0"> as the root element
dom = Document('toc');
toc = dom.getDocumentElement;
toc.setAttribute('version','2.0');

% TOP SECTION: The GIBBON Toolbox
rootItem = makeTocItem(dom,StartFile(1),'The GIBBON Toolbox');
toc.appendChild(rootItem);

% GETTING STARTED SECTION
startItem = makeTocItem(dom,'GettingStarted.html','Getting Started');
startItem.setAttribute('image','HelpIcon.GETTING_STARTED');
startItem.appendChild(makeTocItem(dom,'GettingStarted.html','Getting started'));
rootItem.appendChild(startItem);

% FUNCTION HELP SECTION
helpItem = makeTocItem(dom,'funclist.html','Functions');
helpItem.setAttribute('image','HelpIcon.FUNCTION');
for q=1:1:numel(HelpFiles)
    currentFile=HelpFiles{q};
    [~,currentName,~]=fileparts(currentFile);
    helpItem.appendChild(makeTocItem(dom,currentFile,currentName(6:end)));
end
rootItem.appendChild(helpItem);

% DEMO EXAMPLES SECTION
demoItem = makeTocItem(dom,'gibbonExampes.html','DEMOS and Examples');
demoItem.setAttribute('image','HelpIcon.EXAMPLES');
for q=1:1:numel(DemoFiles)
    currentFile=DemoFiles{q};
    [~,currentName,~]=fileparts(currentFile);
    demoItem.appendChild(makeTocItem(dom,currentFile,currentName(6:end)));
end
rootItem.appendChild(demoItem);

%% WRITE helptoc.xml
saveName=fullfile(toolboxRoot,'docs','html','helptoc.xml');
writer = DOMWriter;
writer.writeToFile(dom,saveName);

%% Add searchable help
% addHelpSearch;
% 
% disp('You may need to restart MATLAB to allow for the help and documentation integration changes to take effect');
% 
% disp('Use gdoc command to open GIBBON documentation page in MATLAB, or use https://www.gibboncode.org/Documentation/');

end


function item = makeTocItem(dom,target,label)
% Create a <tocitem target="..">label</tocitem> element in document dom
item = dom.createElement('tocitem');
item.setAttribute('target',char(target));
item.appendChild(dom.createTextNode(char(label)));

end


%%
% _*GIBBON footer text*_ 
% 
% License: <https://github.com/gibbonCode/GIBBON/blob/master/LICENSE>
% 
% GIBBON: The Geometry and Image-based Bioengineering add-On. A toolbox for
% image segmentation, image-based modeling, meshing, and finite element
% analysis.
% 
% Copyright (C) 2006-2026 Kevin Mattheus Moerman and the GIBBON contributors
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.