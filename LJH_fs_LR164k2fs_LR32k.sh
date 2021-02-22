#!/bin/bash
## This bash is used to register the mertric from fs_LR164 to fs_LR32k.

# inputs:
# $1:The first input:The gifti format file in fs_LR164k space.
# $2:The second input:The hemi of the surf,it should be "L" or "R"
# $3:The output name of the file registerd to fs_LR32k space.
## Eg:
#  bash /data/disk2/luojunhao/Hill_PNAS10_Figure_4/CuiZaixu/LJHCode/fs_LR164k2fs_LR32k.sh /data/disk2/luojunhao/Hill_PNAS10_Figure_4/CuiZaixu/PALS-term12_and_B12_SurfaceAREA_Percentage_SUMMARY.surface_shape_onLR_L.func.gii L  /data/disk2/luojunhao/Hill_PNAS10_Figure_4/CuiZaixu/espansion_164k_32k_func/PALS-term12_and_B12_SurfaceAREA_Percentage_SUMMARY.surface_shape_onLR_fs_LR32k.L.func.gii 

##

# Set workbench path
export PATH=$PATH:/data/disk1/luojunhao/ToolBox/OtherTool/workbench/bin_rh_linux64
# Standandard Atlas
HCP_TEMP=/data/disk1/luojunhao/1001/standard_mesh_atlases/resample_fsaverage

metric_file=$1 # First input
hemi=$2 # L/R    # Second input
outfile_32k=$3    # Third input

tempDir=$HCP_TEMP/temp
mkdir -p $tempDir
outfile=$tempDir/temp_fs_LR164k_fsaverage.func.gii

## fs_LR164k to fsaverage
#inputs 

metric_in=$metric_file
current_sphere=$HCP_TEMP/fs_LR-deformed_to-fsaverage.${hemi}.sphere.164k_fs_LR.surf.gii
new_sphere=$HCP_TEMP/fsaverage_std_sphere.${hemi}.164k_fsavg_${hemi}.surf.gii
metric_out=$outfile 
current_area=$HCP_TEMP/fs_LR.${hemi}.midthickness_va_avg.164k_fs_LR.shape.gii
new_area=$HCP_TEMP/fsaverage.${hemi}.midthickness_va_avg.164k_fsavg_${hemi}.shape.gii

#command

wb_command -metric-resample $metric_in $current_sphere $new_sphere ADAP_BARY_AREA $metric_out -area-metrics $current_area $new_area

## fsaverage to fs_LR32k  
bash /data/disk2/luojunhao/Hill_PNAS10_Figure_4/CuiZaixu/LJHCode/fsave2fs_LR32k.sh $outfile $hemi $outfile_32k

rm -rf $tempDir

echo "Completed"




