#!/usr/bin/env bash 
## This script is used to resample the metric/cifti file to any resolution(e.g.,32k to 10k).

## Step1:Creat the 10k sphere file.
# https://www.humanconnectome.org/software/workbench-command/-all-commands-help/wb_command -surface-create-sphere

wb_command -surface-create-sphere 10000 /Project-HCP/Vertex/resample_surf/Sphere.10k.L.surf.gii
wb_command -surface-flip-lr /Project-HCP/Vertex/resample_surf/Sphere.10k.L.surf.gii/Project-HCP/Vertex/resample_surf/Sphere.10k.R.surf.gii
wb_command -set-structure /Project-HCP/Vertex/resample_surf/Sphere.10k.R.surf.gii CORTEX_RIGHT
wb_command -set-structure /Project-HCP/Vertex/resample_surf/Sphere.10k.L.surf.gii CORTEX_LEFT

## Step2: Register the 32k surface to the 10k surface(e.g.,use the S1200 average 32k surface.
# S1200.L.midthickness_MSMAll.10k_fs_LR.surf.gii is the registered surface.

wb_command -surface-resample /Project-HCP/HCP_S1200_GroupAvg_v1/HCP_S1200_GroupAvg_v1/S1200.L.midthickness_MSMAll.32k_fs_LR.surf.gii/Project-HCP/HCP_S1200_GroupAvg_v1/HCP_S1200_GroupAvg_v1/S1200.L.sphere.32k_fs_LR.surf.gii /Project-HCP/Vertex/resample_surf/Sphere.10k.L.surf.gii BARYCENTRIC/Project-HCP/Vertex/resample_surf/S1200.L.midthickness_MSMAll.10k_fs_LR.surf.gii
wb_command -surface-resample /Project-HCP/HCP_S1200_GroupAvg_v1/HCP_S1200_GroupAvg_v1/S1200.R.midthickness_MSMAll.32k_fs_LR.surf.gii/Project-HCP/HCP_S1200_GroupAvg_v1/HCP_S1200_GroupAvg_v1/S1200.R.sphere.32k_fs_LR.surf.gii /Project-HCP/Vertex/resample_surf/Sphere.10k.R.surf.gii BARYCENTRIC/Project-HCP/Vertex/resample_surf/S1200.R.midthickness_MSMAll.10k_fs_LR.surf.gii

## Step3:After generating the S1200.L.midthickness_MSMAll.10k_fs_LR.surf.gii,then it can be used for metric resampling.

# Cifti data should apply this step to separated it to metric data such as "xxxx.func.gii".Uncomment the following 2 lines.
#wb_command -cifti-separate /Project-HCP/Vertex/DataSample/scrub_wm_csf_LR.dtseries.nii COLUMN -metric CORTEX_LEFT/Project-HCP/Vertex/resample_surf/sLR_L_32k.func.gii
#wb_command -cifti-separate /Project-HCP/Vertex/DataSample/scrub_wm_csf_LR.dtseries.nii COLUMN -metric CORTEX_RIGHT/Project-HCP/Vertex/resample_surf/sLR_R_32k.func.gii

# Resampling metric files. (2 methods:BARYCENTRIC and ADAP_BARY_AREA(recommanded))
#wb_command -metric-resample /Project-HCP/Vertex/resample_surf/sLR_L_32k.func.gii/Project-HCP/HCP_S1200_GroupAvg_v1/HCP_S1200_GroupAvg_v1/S1200.L.sphere.32k_fs_LR.surf.gii /Project-HCP/Vertex/resample_surf/Sphere.10k.L.surf.gii BARYCENTRIC/Project-HCP/Vertex/resample_surf/BARYC_sLR_L_10k.func.gii
#wb_command -metric-resample /Project-HCP/Vertex/resample_surf/sLR_R_32k.func.gii/Project-HCP/HCP_S1200_GroupAvg_v1/HCP_S1200_GroupAvg_v1/S1200.R.sphere.32k_fs_LR.surf.gii /Project-HCP/Vertex/resample_surf/Sphere.10k.R.surf.gii BARYCENTRIC/Project-HCP/Vertex/resample_surf/BARYC_sLR_R_10k.func.gii

## Then S1200.L.midthickness_MSMAll.10k_fs_LR.surf.gii is the final metric file registered from 32k to 10k surface space.
wb_command -metric-resample /Project-HCP/Vertex/resample_surf/sLR_L_32k.func.gii/Project-HCP/HCP_S1200_GroupAvg_v1/HCP_S1200_GroupAvg_v1/S1200.L.sphere.32k_fs_LR.surf.gii /Project-HCP/Vertex/resample_surf/Sphere.10k.L.surf.gii ADAP_BARY_AREA/Project-HCP/Vertex/resample_surf/ADAP_sLR_L_10k.func.gii -area-surfs/Project-HCP/HCP_S1200_GroupAvg_v1/HCP_S1200_GroupAvg_v1/S1200.L.midthickness_MSMAll.32k_fs_LR.surf.gii/Project-HCP/Vertex/resample_surf/S1200.L.midthickness_MSMAll.10k_fs_LR.surf.gii
wb_command -metric-resample /Project-HCP/Vertex/resample_surf/sLR_R_32k.func.gii/Project-HCP/HCP_S1200_GroupAvg_v1/HCP_S1200_GroupAvg_v1/S1200.R.sphere.32k_fs_LR.surf.gii /Project-HCP/Vertex/resample_surf/Sphere.10k.R.surf.gii ADAP_BARY_AREA/Project-HCP/Vertex/resample_surf/ADAP_sLR_R_10k.func.gii -area-surfs/Project-HCP/HCP_S1200_GroupAvg_v1/HCP_S1200_GroupAvg_v1/S1200.R.midthickness_MSMAll.32k_fs_LR.surf.gii/Project-HCP/Vertex/resample_surf/S1200.R.midthickness_MSMAll.10k_fs_LR.surf.gii


## Step4:If step3 is done for cifti file,you should convert the 10k metric file to cifti file.Uncomment the following 2 lines.

# BARYCENTRIC
#wb_command -cifti-create-dense-timeseries  /Project-HCP/Vertex/resample_surf/BARYC_sLR_L_10k.dtseries.nii -left-metric  /Project-HCP/Vertex/resample_surf/BARYC_sLR_L_10k.func.gii -timestep 0.72

#wb_command -cifti-create-dense-timeseries  /Project-HCP/Vertex/resample_surf/BARYC_sLR_R_10k.dtseries.nii -right-metric  /Project-HCP/Vertex/resample_surf/BARYC_sLR_R_10k.func.gii -timestep 0.72


# ADAP_BARY_AREA

#wb_command -cifti-create-dense-timeseries  /Project-HCP/Vertex/resample_surf/ADAP_sLR_L_10k.dtseries.nii -left-metric  /Project-HCP/Vertex/resample_surf/ADAP_sLR_L_10k.func.gii -timestep 0.72

#wb_command -cifti-create-dense-timeseries  /Project-HCP/Vertex/resample_surf/ADAP_sLR_R_10k.dtseries.nii -right-metric  /Project-HCP/Vertex/resample_surf/ADAP_sLR_R_10k.func.gii -timestep 0.72







