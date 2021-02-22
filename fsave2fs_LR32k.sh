#!/bin/bash

## This bash is used to register the mertric from fsaverage to fs_LR32k.
# inputs:
# $1:The first input:The gifti format file in fsaverage space.
# $2:The second input:The hemi of the surf,it should be "L" or "R"
# $3:The output name of the file registerd to fs_LR32k space.

HCP_TEMP=/data/disk1/luojunhao/1001/standard_mesh_atlases/resample_fsaverage
metric_file=$1
hemi=$2 # L/R
outfile=$3

## fsaverage to fs_LR 32k
# inputs

metric_in=$metric_file
current_sphere=$HCP_TEMP/fsaverage_std_sphere.${hemi}.164k_fsavg_${hemi}.surf.gii
new_sphere=$HCP_TEMP/fs_LR-deformed_to-fsaverage.${hemi}.sphere.32k_fs_LR.surf.gii
metric_out=$outfile 
current_area=$HCP_TEMP/fsaverage.${hemi}.midthickness_va_avg.164k_fsavg_${hemi}.shape.gii
new_area=$HCP_TEMP/fs_LR.${hemi}.midthickness_va_avg.32k_fs_LR.shape.gii

#command

wb_command -metric-resample $metric_in $current_sphere $new_sphere ADAP_BARY_AREA $metric_out -area-metrics $current_area $new_area



#wb_command -metric-resample $metric_file $HCP_TEMP/fsaverage_std_sphere.${hemi}.164k_fsavg_${hemi}.surf.gii $HCP_TEMP/fs_LR-deformed_to-fsaverage.${hemi}.sphere.32k_fs_LR.surf.gii ADAP_BARY_AREA $outfile  -area-metrics $HCP_TEMP/fsaverage.${hemi}.midthickness_va_avg.164k_fsavg_${hemi}.shape.gii $HCP_TEMP/fs_LR.${hemi}.midthickness_va_avg.32k_fs_LR.shape.gii



#wb_command -metric-resample /data/disk2/luojunhao/MNI_surface_template/template_monkey_fs6/fsaverage_func/rh.Hill2010_evo_fsaverage.func.gii   $HCP_TEMP/fsaverage_std_sphere.R.164k_fsavg_R.surf.gii $HCP_TEMP/fs_LR-deformed_to-fsaverage.R.sphere.32k_fs_LR.surf.gii ADAP_BARY_AREA /data/disk2/luojunhao/MNI_surface_template/template_monkey_fs6/fsaverage_func/rh.Hill2010_fs_LR32k.func.gii  -area-metrics $HCP_TEMP/fsaverage.R.midthickness_va_avg.164k_fsavg_R.shape.gii HCP_TEMP/fs_LR.R.midthickness_va_avg.32k_fs_LR.shape.gii
