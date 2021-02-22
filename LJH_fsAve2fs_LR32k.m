function LJH_fsAve2fs_LR32k(OverlayMetric,fsAveSpace,fnum,surfFlag,ResultDir,prefix_name)

%% This function is used to resample metric in freesurfer space to fs_LR32 space.

%%
% *Inputs:

% *OverlayMetric:A vertor in fsAveSpace.
% *fsAveSpace:Freesurfer space such as fsaverage,fsaverage5,fsaverage6...
% *fnum:The number of faces of the surface in fsAveSpace.
%    fsAveSpace='fsaverage',fnum=327680;
%    fsAveSpace3='fsaverage3',fnum=1280;
%    fsAveSpace='fsaverage4',fnum=5120;
%    fsAveSpace3='fsaverage5',fnum=20480;
%    fsAveSpace='fsaverage6',fnum=81920;

% *surfFlag:'lh' or 'rh'.
% *ResultDir:Result folder to restore the results
% *prefix_name:key words of the name.
% output
% The overlay matric registered to fs_LR32k in the resultant folder:
%    $ResultDir/fs_LR32kFile.

addpath(genpath('/opt/software/freesurfer/matlab'));
addpath(genpath('/data/disk1/luojunhao/ToolBox/LJHCode/fibre_tri_Code/function_final/gifti-1.6'));
%addpath(genpath('/data/disk1/luojunhao/ToolBox'))

% *OverlayFile:Overlay file.(xxxx.txt)
% *fnum:Number of faces in surface in fsAveSpace;Eg:fsaverage6:fnum=81920
% *surfFlag:'lh' or 'rh'
Evo_fsAve=OverlayMetric;%load(OverlayFile);
%[ResultDir,name,~]=fileparts(OverlayFile);

%% write the original file to a curv.
%ResultDir=[fileDir,'/ResampleResult'];
if ~exist(ResultDir)
    mkdir(ResultDir);
end
fsAveSpaceDir=[ResultDir,'/fsAveOrigSpaceFile'];
if ~exist(fsAveSpaceDir)
    mkdir(fsAveSpaceDir);
end
fname=[fsAveSpaceDir,'/',surfFlag,'.',prefix_name];
write_curv(fname, Evo_fsAve, fnum);

%% register it to fsaverage
fsaverageDir=[ResultDir,'/fsaverageFile'];
if ~exist(fsaverageDir)
    mkdir(fsaverageDir);
end
fsaverage_filename=[fsaverageDir,'/',surfFlag,'.',prefix_name,'_fsaverage'];


cmd = ['mri_surf2surf --hemi ' surfFlag ' --srcsubject ' fsAveSpace ' --srcsurfval ' ...
       fname ' --src_type ' ...
       'curv --trgsubject fsaverage --trgsurfval ' fsaverage_filename ' --trg_type curv'];

system(cmd);
%% convert it to .gii
file_curv = read_curv(fsaverage_filename);
V_gii = gifti;
V_gii.cdata = file_curv;
V_File = [fsaverageDir,'/',surfFlag,'.',prefix_name,'.func.gii']
save(V_gii,V_File);% gifti package save.


%% fs-LR32k
fs_LR32kDir=[ResultDir,'/fs_LR32kFile'];
if ~exist(fs_LR32kDir)
    mkdir(fs_LR32kDir);
end
out_fs_LR32k=[fs_LR32kDir,'/',surfFlag,'.',prefix_name,'.fs_LR32k.func.gii'];

if strcmp(surfFlag,'lh')
    hemi='L';
elseif strcmp(surfFlag,'rh')
    hemi='R';
else
    error('surfFlag should be "lh or rh"!')
end
cmd=['export PATH=$PATH:/data/disk1/luojunhao/ToolBox/OtherTool/workbench/bin_rh_linux64;','bash /data/disk2/luojunhao/Hill_PNAS10_Figure_4/CuiZaixu/LJHCode/fsave2fs_LR32k.sh ',V_File,' ',hemi,' ',out_fs_LR32k];
system(cmd)



% %%
% OverlayFile=[Folder '/EvolutionaryExpansion/Hill2010_evo_fsaverage6.txt']
% 
% 
% clear
% Folder = '/data/disk2/luojunhao/MNI_surface_template/template_monkey_fs6';
% Evo_fsaverage6_rh = load([Folder '/EvolutionaryExpansion/Hill2010_evo_fsaverage6.txt']);
% fnum = 81920;
% fname = [Folder '/rh.Hill2010_evo_fsaverage6'];
% write_curv(fname, Evo_fsaverage6_rh, fnum);
% 
% 
% 
% 
% 
% % cmd = ['mri_surf2surf --hemi rh --srcsubject fsaverage6 --srcsurfval ' ...
% %        Folder '/EvolutionaryExpansion/rh.Hill2010_evo_fsaverage6 --src_type ' ...
% %        'curv --trgsubject fsaverage --trgsurfval ' Folder ...
% %        '/fsaverage_func/rh.Hill2010_evo_fsaverage --trg_type curv'];
% % system(cmd);
% 
% % Then, write the rh.Hill2010_evo_fsaverage5 into a gifti file for visualization
% Evo_fsaverage = read_curv([Folder '/fsaverage_func/rh.Hill2010_evo_fsaverage']);
% V_rh = gifti;
% V_rh.cdata = Evo_fsaverage;
% V_rh_File = [Folder '/fsaverage_func/rh.Hill2010_evo_fsaverage.func.gii'];
% save(V_rh, V_rh_File);
